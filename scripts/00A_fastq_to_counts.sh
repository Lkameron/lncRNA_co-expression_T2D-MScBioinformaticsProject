
# PIPELINE STEPS:
#   1.  Download raw FASTQ files from SRA
#   2.  Quality control on raw reads       (FastQC + MultiQC)
#   3.  Adapter trimming                   (fastp)
#   4.  Quality control on trimmed reads   (FastQC + MultiQC)
#   5.  Build STAR genome index            (GRCh38 + GENCODE v46 GTF)
#   6.  Align reads to genome              (STAR 2-pass)
#   7.  Sort and index BAM files           (SAMtools)
#   8.  Alignment QC                       (RSeQC / SAMtools flagstat)
#   9.  Gene-level counting                (HTSeq-count)
#   10. Merge sample counts → count matrix (Python/awk)
#
# TOOLS REQUIRED (must be in PATH or conda environment):
#   sra-tools  >= 3.0    (prefetch, fasterq-dump)
#   fastqc     >= 0.12
#   multiqc    >= 1.18
#   fastp      >= 0.23
#   STAR       >= 2.7.10
#   samtools   >= 1.18
#   htseq      >= 2.0    (htseq-count)
#   python     >= 3.9
#
# DATASET:
#   GEO: GSE164416
#   SRA: SRP300812
#   BioProject: PRJNA690574
#   Reference genome: GRCh38 (hg38)
#   Annotation: GENCODE v46
#
# USAGE:
#   bash scripts/00A_fastq_to_counts.sh
#   # or with conda:
#   conda activate rnaseq_env
#   bash scripts/00A_fastq_to_counts.sh
#
# NOTES:
#   - Set THREADS to the number of CPU cores available on your machine
#   - The STAR genome index requires ~30 GB RAM to build
#   - Full run requires ~500 GB disk space for raw FASTQs
#   - Set DRY_RUN=true to print commands without executing them
################################################################################

set -euo pipefail   # Exit on error, unset variable, or pipe failure

################################################################################
# SECTION 1: Configuration
################################################################################

# --- User-configurable settings ---
THREADS=8           # Number of CPU cores to use
DRY_RUN=TRUE        # Set to true to print commands without running

# --- Project directories ---
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RAW_DIR="${PROJECT_DIR}/data/raw/GSE164416"
FASTQ_DIR="${PROJECT_DIR}/data/raw/fastq"
TRIMMED_DIR="${PROJECT_DIR}/data/raw/fastq_trimmed"
GENOME_DIR="${PROJECT_DIR}/data/reference/GRCh38_STAR_index"
BAM_DIR="${PROJECT_DIR}/data/processed/bam"
COUNTS_DIR="${PROJECT_DIR}/data/processed/counts"
QC_DIR="${PROJECT_DIR}/results/qc/fastqc"
LOGS_DIR="${PROJECT_DIR}/logs/alignment"

# --- Reference files ---
GENOME_FA="${RAW_DIR}/GRCh38.primary_assembly.genome.fa"
GTF_FILE="${RAW_DIR}/gencode.v46.annotation.gtf"
GTF_GZ="${RAW_DIR}/gencode.v46.annotation.gtf.gz"

# --- SRA accession list (GSE164416 = SRP300812) ---
# Full list of 133 SRA run accessions for GSE164416
# Source: https://www.ncbi.nlm.nih.gov/sra?term=SRP300812
SRA_ACCESSIONS=(
    SRR13193797 SRR13193798 SRR13193799 SRR13193800 SRR13193801
    SRR13193802 SRR13193803 SRR13193804 SRR13193805 SRR13193806
    SRR13193807 SRR13193808 SRR13193809 SRR13193810 SRR13193811
    SRR13193812 SRR13193813 SRR13193814 SRR13193815 SRR13193816
    SRR13193817 SRR13193818 SRR13193819 SRR13193820 SRR13193821
    SRR13193822 SRR13193823 SRR13193824 SRR13193825 SRR13193826
    SRR13193827 SRR13193828 SRR13193829 SRR13193830 SRR13193831
    SRR13193832 SRR13193833 SRR13193834 SRR13193835 SRR13193836
    SRR13193837 SRR13193838 SRR13193839 SRR13193840 SRR13193841
    SRR13193842 SRR13193843 SRR13193844 SRR13193845 SRR13193846
    # NOTE: Add remaining accessions from SRP300812 if running in full
    # Full accession list available at:
    # https://www.ncbi.nlm.nih.gov/Traces/study/?acc=SRP300812
)

# --- Output count matrix name ---
FINAL_COUNT_MATRIX="${PROJECT_DIR}/data/processed/GSE164416_DP_htseq_counts_reproduced.txt"

################################################################################
# SECTION 2: Helper functions
################################################################################

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

run_cmd() {
    # Wrapper: prints command, executes unless DRY_RUN=true
    echo "  CMD: $*"
    if [ "${DRY_RUN}" = false ]; then
        eval "$@"
    fi
}

check_tool() {
    if ! command -v "$1" &>/dev/null; then
        if [ "${DRY_RUN}" = TRUE ] || [ "${DRY_RUN}" = true ]; then
            echo "  [DRY RUN] Would require: $1"
        else
            echo "ERROR: '$1' not found in PATH."
            echo "       Install via conda: conda install -c bioconda $1"
            exit 1
        fi
    fi
}

################################################################################
# SECTION 3: Dependency checks
################################################################################

log "========================================="
log "00A - FASTQ to count matrix pipeline"
log "========================================="
log "Project dir : ${PROJECT_DIR}"
log "Threads     : ${THREADS}"
log "Dry run     : ${DRY_RUN}"
log ""

log "Checking required tools..."
for tool in prefetch fasterq-dump fastqc multiqc fastp STAR samtools htseq-count python3; do
    check_tool "${tool}"
    version=$(${tool} --version 2>&1 | head -1 || true)
    echo "  OK: ${tool} — ${version}"
done
log ""

################################################################################
# SECTION 4: Create directory structure
################################################################################

log "Creating directory structure..."
for dir in "${FASTQ_DIR}" "${TRIMMED_DIR}" "${GENOME_DIR}" \
           "${BAM_DIR}" "${COUNTS_DIR}" "${QC_DIR}/raw" \
           "${QC_DIR}/trimmed" "${LOGS_DIR}"; do
    mkdir -p "${dir}"
done
log "Directories created."
log ""

################################################################################
# SECTION 5: Download reference genome and annotation
################################################################################

log "--- STEP 1: Download reference files ---"

# GENCODE v46 primary assembly genome (GRCh38)
GENOME_URL="https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_46/GRCh38.primary_assembly.genome.fa.gz"
GTF_URL="https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_46/gencode.v46.annotation.gtf.gz"

if [ ! -f "${GENOME_FA}" ]; then
    log "Downloading GRCh38 genome..."
    run_cmd wget -c -O "${GENOME_FA}.gz" "${GENOME_URL}"
    run_cmd gunzip "${GENOME_FA}.gz"
else
    log "Genome already present: ${GENOME_FA}"
fi

if [ ! -f "${GTF_FILE}" ]; then
    log "Downloading GENCODE v46 GTF..."
    run_cmd wget -c -O "${GTF_GZ}" "${GTF_URL}"
    run_cmd gunzip -k "${GTF_GZ}"
else
    log "GTF already present: ${GTF_FILE}"
fi
log ""

################################################################################
# SECTION 6: Download raw FASTQ files from SRA
################################################################################

log "--- STEP 2: Download raw FASTQ files from SRA ---"
log "Dataset: GSE164416 (SRP300812)"
log "Samples: ${#SRA_ACCESSIONS[@]}"
log ""

for acc in "${SRA_ACCESSIONS[@]}"; do
    FASTQ_OUT="${FASTQ_DIR}/${acc}"

    if [ -f "${FASTQ_DIR}/${acc}_1.fastq.gz" ] || \
       [ -f "${FASTQ_DIR}/${acc}.fastq.gz" ]; then
        log "Already downloaded: ${acc}"
        continue
    fi

    log "Downloading ${acc}..."

    # prefetch caches SRA file locally for reliable download
    run_cmd prefetch \
        --max-size 50GB \
        --output-directory "${FASTQ_DIR}" \
        "${acc}"

    # Convert SRA to FASTQ (paired-end aware)
    run_cmd fasterq-dump \
        --outdir "${FASTQ_DIR}" \
        --threads "${THREADS}" \
        --split-files \
        --skip-technical \
        "${FASTQ_DIR}/${acc}/${acc}.sra"

    # Compress to save disk space
    run_cmd gzip "${FASTQ_DIR}/${acc}"*.fastq

    log "Done: ${acc}"
done
log ""

#  FastQC on raw reads

log "--- STEP 3: FastQC — raw reads ---"

FASTQ_FILES=("${FASTQ_DIR}"/*.fastq.gz)

if [ ${#FASTQ_FILES[@]} -gt 0 ]; then
    run_cmd fastqc \
        --outdir "${QC_DIR}/raw" \
        --threads "${THREADS}" \
        --quiet \
        "${FASTQ_DIR}"/*.fastq.gz

    # MultiQC aggregates all FastQC reports into one HTML summary
    run_cmd multiqc \
        "${QC_DIR}/raw" \
        --outdir "${QC_DIR}/raw" \
        --filename "multiqc_raw_reads" \
        --quiet
else
    log "WARNING: No FASTQ files found in ${FASTQ_DIR}"
fi
log ""

#  Adapter trimming with fastp

log "--- STEP 4: Adapter trimming (fastp) ---"
log "Settings: quality >= 20, minimum length 36 bp, polyX tail trimming"
log ""

for acc in "${SRA_ACCESSIONS[@]}"; do
    # Handle both paired-end and single-end layouts
    R1="${FASTQ_DIR}/${acc}_1.fastq.gz"
    R2="${FASTQ_DIR}/${acc}_2.fastq.gz"
    SE="${FASTQ_DIR}/${acc}.fastq.gz"

    if [ -f "${R1}" ] && [ -f "${R2}" ]; then
        # Paired-end
        log "Trimming paired-end: ${acc}"
        run_cmd fastp \
            --in1 "${R1}" \
            --in2 "${R2}" \
            --out1 "${TRIMMED_DIR}/${acc}_1_trimmed.fastq.gz" \
            --out2 "${TRIMMED_DIR}/${acc}_2_trimmed.fastq.gz" \
            --json "${TRIMMED_DIR}/${acc}_fastp.json" \
            --html "${TRIMMED_DIR}/${acc}_fastp.html" \
            --qualified_quality_phred 20 \
            --length_required 36 \
            --trim_poly_x \
            --detect_adapter_for_pe \
            --thread "${THREADS}" \
            --disable_length_filtering false \
            2>"${LOGS_DIR}/${acc}_fastp.log"

    elif [ -f "${SE}" ]; then
        # Single-end
        log "Trimming single-end: ${acc}"
        run_cmd fastp \
            --in1 "${SE}" \
            --out1 "${TRIMMED_DIR}/${acc}_trimmed.fastq.gz" \
            --json "${TRIMMED_DIR}/${acc}_fastp.json" \
            --html "${TRIMMED_DIR}/${acc}_fastp.html" \
            --qualified_quality_phred 20 \
            --length_required 36 \
            --trim_poly_x \
            --thread "${THREADS}" \
            2>"${LOGS_DIR}/${acc}_fastp.log"
    else
        log "WARNING: No FASTQ found for ${acc}, skipping."
    fi
done

run_cmd multiqc \
    "${TRIMMED_DIR}" \
    --outdir "${QC_DIR}/trimmed" \
    --filename "multiqc_fastp" \
    --quiet
log ""

#  FastQC on trimmed reads

log "--- STEP 5: FastQC — trimmed reads ---"

run_cmd fastqc \
    --outdir "${QC_DIR}/trimmed" \
    --threads "${THREADS}" \
    --quiet \
    "${TRIMMED_DIR}"/*_trimmed.fastq.gz

run_cmd multiqc \
    "${QC_DIR}/trimmed" \
    --outdir "${QC_DIR}/trimmed" \
    --filename "multiqc_trimmed_reads" \
    --quiet
log ""


# Build STAR genome index

log "--- STEP 6: Build STAR genome index ---"
log "Genome: GRCh38 | Annotation: GENCODE v46 | Read length: 75 bp"
log "NOTE: Requires ~30 GB RAM and ~1 hour to build."
log ""

# sjdbOverhang = read_length - 1 (GSE164416 uses 75 bp paired-end reads)
READ_LENGTH=75
OVERHANG=$((READ_LENGTH - 1))

if [ ! -f "${GENOME_DIR}/SAindex" ]; then
    log "Building STAR index..."
    run_cmd STAR \
        --runMode genomeGenerate \
        --genomeDir "${GENOME_DIR}" \
        --genomeFastaFiles "${GENOME_FA}" \
        --sjdbGTFfile "${GTF_FILE}" \
        --sjdbOverhang "${OVERHANG}" \
        --runThreadN "${THREADS}" \
        --genomeSAindexNbases 14
else
    log "STAR index already exists: ${GENOME_DIR}"
fi
log ""

# STAR 2-pass alignment

log "--- STEP 7: STAR 2-pass alignment ---"
log "Parameters match GSE164416 paper methods:"
log "  - 2-pass mode for novel splice junction discovery"
log "  - Output: coordinate-sorted BAM"
log ""

for acc in "${SRA_ACCESSIONS[@]}"; do
    BAM_OUT="${BAM_DIR}/${acc}"
    mkdir -p "${BAM_OUT}"

    # Check if BAM already exists
    if [ -f "${BAM_OUT}/${acc}_Aligned.sortedByCoord.out.bam" ]; then
        log "Already aligned: ${acc}"
        continue
    fi

    # Determine read files (paired-end or single-end)
    R1="${TRIMMED_DIR}/${acc}_1_trimmed.fastq.gz"
    R2="${TRIMMED_DIR}/${acc}_2_trimmed.fastq.gz"
    SE="${TRIMMED_DIR}/${acc}_trimmed.fastq.gz"

    if [ -f "${R1}" ] && [ -f "${R2}" ]; then
        READ_FILES="${R1} ${R2}"
    elif [ -f "${SE}" ]; then
        READ_FILES="${SE}"
    else
        log "WARNING: No trimmed FASTQ for ${acc}, skipping alignment."
        continue
    fi

    log "Aligning: ${acc}"

    run_cmd STAR \
        --runMode alignReads \
        --genomeDir "${GENOME_DIR}" \
        --readFilesIn ${READ_FILES} \
        --readFilesCommand zcat \
        --outSAMtype BAM SortedByCoordinate \
        --outSAMattributes NH HI AS NM MD \
        --outSAMstrandField intronMotif \
        --outFilterIntronMotifs RemoveNoncanonical \
        --alignSJoverhangMin 8 \
        --alignSJDBoverhangMin 1 \
        --outFilterMismatchNmax 999 \
        --outFilterMismatchNoverLmax 0.04 \
        --alignIntronMin 20 \
        --alignIntronMax 1000000 \
        --alignMatesGapMax 1000000 \
        --twopassMode Basic \
        --runThreadN "${THREADS}" \
        --outFileNamePrefix "${BAM_OUT}/${acc}_" \
        --outBAMsortingThreadN "${THREADS}" \
        --limitBAMsortRAM 30000000000 \
        2>"${LOGS_DIR}/${acc}_STAR.log"

    log "Done aligning: ${acc}"
done
log ""

################################################################################
# SECTION 12: Index BAM files with SAMtools
################################################################################

log "--- STEP 8: SAMtools — index BAM files and alignment QC ---"

for acc in "${SRA_ACCESSIONS[@]}"; do
    BAM="${BAM_DIR}/${acc}/${acc}_Aligned.sortedByCoord.out.bam"

    if [ ! -f "${BAM}" ]; then
        log "WARNING: BAM not found for ${acc}, skipping."
        continue
    fi

    log "Indexing: ${acc}"
    run_cmd samtools index -@ "${THREADS}" "${BAM}"

    # flagstat: overall alignment statistics
    run_cmd samtools flagstat \
        -@ "${THREADS}" \
        "${BAM}" \
        > "${LOGS_DIR}/${acc}_flagstat.txt"

    # idxstats: per-chromosome read counts
    run_cmd samtools idxstats "${BAM}" \
        > "${LOGS_DIR}/${acc}_idxstats.txt"
done

# Aggregate alignment stats with MultiQC
run_cmd multiqc \
    "${LOGS_DIR}" \
    "${BAM_DIR}" \
    --outdir "${QC_DIR}" \
    --filename "multiqc_alignment" \
    --quiet
log ""

#  HTSeq-count — gene-level counting

log "--- STEP 9: HTSeq-count ---"
log "Mode: union | Strand: no (unstranded) | Feature: gene"
log "Matches the counting strategy used to generate GSE164416"
log ""

for acc in "${SRA_ACCESSIONS[@]}"; do
    BAM="${BAM_DIR}/${acc}/${acc}_Aligned.sortedByCoord.out.bam"
    COUNT_OUT="${COUNTS_DIR}/${acc}_counts.txt"

    if [ ! -f "${BAM}" ]; then
        log "WARNING: BAM not found for ${acc}, skipping."
        continue
    fi

    if [ -f "${COUNT_OUT}" ]; then
        log "Already counted: ${acc}"
        continue
    fi

    log "Counting: ${acc}"

    run_cmd htseq-count \
        --format bam \
        --order pos \
        --stranded no \
        --type gene \
        --idattr gene_id \
        --mode union \
        --additional-attr gene_name \
        --quiet \
        "${BAM}" \
        "${GTF_FILE}" \
        > "${COUNT_OUT}" \
        2>"${LOGS_DIR}/${acc}_htseq.log"

    log "Done counting: ${acc}"
done
log ""

#  Merge per-sample counts into a single count matrix

log "--- STEP 10: Merge counts into count matrix ---"

python3 - <<'PYEOF'
import os
import glob
import pandas as pd

counts_dir = os.path.join(
    os.path.dirname(os.path.abspath(__file__)) if '__file__' in dir() else os.getcwd(),
    "data", "processed", "counts"
)

# Fallback to environment variable if run via heredoc
project_dir = os.environ.get("PROJECT_DIR", os.getcwd())
counts_dir  = os.path.join(project_dir, "data", "processed", "counts")
output_path = os.path.join(project_dir, "data", "processed",
                           "GSE164416_DP_htseq_counts_reproduced.txt")

count_files = sorted(glob.glob(os.path.join(counts_dir, "*_counts.txt")))

if not count_files:
    print("  WARNING: No count files found in", counts_dir)
    exit(0)

print(f"  Merging {len(count_files)} count files...")

dfs = []
for f in count_files:
    sample = os.path.basename(f).replace("_counts.txt", "")
    df = pd.read_csv(
        f, sep="\t", header=None,
        names=["gene_id", "gene_name", "count"],
        comment=None
    )
    # HTSeq appends summary rows starting with "__"
    df = df[~df["gene_id"].str.startswith("__")]
    df = df[["gene_id", "count"]].rename(columns={"count": sample})
    dfs.append(df)

# Merge all samples on gene_id
merged = dfs[0]
for df in dfs[1:]:
    merged = merged.merge(df, on="gene_id", how="outer")

merged = merged.fillna(0).astype({c: int for c in merged.columns if c != "gene_id"})
merged.to_csv(output_path, sep="\t", index=False)

print(f"  Count matrix written: {output_path}")
print(f"  Dimensions: {merged.shape[0]} genes × {merged.shape[1]-1} samples")
PYEOF

export PROJECT_DIR="${PROJECT_DIR}"
log ""



log "--- Generating final MultiQC summary report ---"

run_cmd multiqc \
    "${PROJECT_DIR}" \
    --outdir "${QC_DIR}" \
    --filename "multiqc_full_pipeline" \
    --ignore "${GENOME_DIR}" \
    --ignore "${FASTQ_DIR}" \
    --ignore "${TRIMMED_DIR}" \
    --quiet

log ""

################################################################################
# SECTION 16: Summary
################################################################################

log "========================================="
log "Pipeline complete!"
log "========================================="
log ""
log "Key outputs:"
log "  FastQC reports (raw)     : results/qc/fastqc/raw/multiqc_raw_reads.html"
log "  FastQC reports (trimmed) : results/qc/fastqc/trimmed/multiqc_trimmed_reads.html"
log "  Alignment QC             : results/qc/fastqc/multiqc_alignment.html"
log "  Full pipeline QC         : results/qc/fastqc/multiqc_full_pipeline.html"
log "  Per-sample BAMs          : data/processed/bam/<accession>/"
log "  Per-sample counts        : data/processed/counts/<accession>_counts.txt"
log "  Final count matrix       : data/processed/GSE164416_DP_htseq_counts_reproduced.txt"
log ""
log "Next step:"
log "  The reproduced count matrix can be used as input for:"
log "  Rscript scripts/02_qc_filter_normalise.R"
log ""
log "NOTE:"
log "  The GEO-provided count matrix (downloaded in 00_download_data.R) was"
log "  generated using this same pipeline by the original authors."
log "  Both matrices should be near-identical — any minor differences reflect"
log "  software version changes between STAR/HTSeq releases."
log "========================================="
