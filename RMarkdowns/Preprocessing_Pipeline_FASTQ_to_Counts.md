# Preprocessing Pipeline: FASTQ to Count Matrix

**Script:** `scripts/00A_fastq_to_counts.sh`
**Dataset:** GEO GSE164416 / SRA SRP300812 / BioProject PRJNA690574 (133 runs)
**Reference:** GRCh38 (hg38), GENCODE v46 annotation
**Status:** Dry-run verified (`DRY_RUN=TRUE`) — every command below was checked and logged without execution, since the raw sequencing tools are not installed on this machine. The dissertation's actual differential expression / WGCNA / ML analysis uses the GEO-provided pre-computed count matrix, which the original authors generated using this same pipeline. This script documents and reproduces that pipeline for methodological transparency.

---

## Step 1 — Download reference genome and annotation

GRCh38 primary assembly genome and GENCODE v46 GTF, retrieved directly from the EBI GENCODE FTP mirror.

```bash
GENOME_URL="https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_46/GRCh38.primary_assembly.genome.fa.gz"
GTF_URL="https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_46/gencode.v46.annotation.gtf.gz"

wget -c -O "${GENOME_FA}.gz" "${GENOME_URL}"
gunzip "${GENOME_FA}.gz"

wget -c -O "${GTF_GZ}" "${GTF_URL}"
gunzip -k "${GTF_GZ}"
```

## Step 2 — Download raw FASTQ files from SRA

`prefetch` caches the SRA file locally; `fasterq-dump` converts it to paired-end FASTQ.

```bash
prefetch \
    --max-size 50GB \
    --output-directory "${FASTQ_DIR}" \
    "${acc}"

fasterq-dump \
    --outdir "${FASTQ_DIR}" \
    --threads "${THREADS}" \
    --split-files \
    --skip-technical \
    "${FASTQ_DIR}/${acc}/${acc}.sra"

gzip "${FASTQ_DIR}/${acc}"*.fastq
```

## Step 3 — FastQC on raw reads

Per-sample quality reports, aggregated into one summary with MultiQC.

```bash
fastqc \
    --outdir "${QC_DIR}/raw" \
    --threads "${THREADS}" \
    --quiet \
    "${FASTQ_DIR}"/*.fastq.gz

multiqc \
    "${QC_DIR}/raw" \
    --outdir "${QC_DIR}/raw" \
    --filename "multiqc_raw_reads" \
    --quiet
```

## Step 4 — Adapter and quality trimming (fastp)

Quality threshold Phred ≥20, minimum retained read length 36 bp, poly-X tail trimming, automatic paired-end adapter detection.

```bash
fastp \
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
    --disable_length_filtering false

multiqc \
    "${TRIMMED_DIR}" \
    --outdir "${QC_DIR}/trimmed" \
    --filename "multiqc_fastp" \
    --quiet
```

## Step 5 — FastQC on trimmed reads

Re-run FastQC post-trimming to confirm adapter removal and stable per-base quality.

```bash
fastqc \
    --outdir "${QC_DIR}/trimmed" \
    --threads "${THREADS}" \
    --quiet \
    "${TRIMMED_DIR}"/*_trimmed.fastq.gz

multiqc \
    "${QC_DIR}/trimmed" \
    --outdir "${QC_DIR}/trimmed" \
    --filename "multiqc_trimmed_reads" \
    --quiet
```

## Step 6 — Build STAR genome index

`sjdbOverhang = read_length - 1` (GSE164416 uses 75 bp paired-end reads, so overhang = 74).

```bash
READ_LENGTH=75
OVERHANG=$((READ_LENGTH - 1))

STAR \
    --runMode genomeGenerate \
    --genomeDir "${GENOME_DIR}" \
    --genomeFastaFiles "${GENOME_FA}" \
    --sjdbGTFfile "${GTF_FILE}" \
    --sjdbOverhang "${OVERHANG}" \
    --runThreadN "${THREADS}" \
    --genomeSAindexNbases 14
```

## Step 7 — STAR 2-pass alignment

Two-pass mode enables novel splice junction discovery in the second pass. Output is coordinate-sorted BAM.

```bash
STAR \
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
    --limitBAMsortRAM 30000000000
```

## Step 8 — Index BAM files and alignment QC (SAMtools)

`flagstat` gives overall alignment rate; `idxstats` gives per-chromosome read counts.

```bash
samtools index -@ "${THREADS}" "${BAM}"

samtools flagstat \
    -@ "${THREADS}" \
    "${BAM}" \
    > "${LOGS_DIR}/${acc}_flagstat.txt"

samtools idxstats "${BAM}" \
    > "${LOGS_DIR}/${acc}_idxstats.txt"

multiqc \
    "${LOGS_DIR}" \
    "${BAM_DIR}" \
    --outdir "${QC_DIR}" \
    --filename "multiqc_alignment" \
    --quiet
```

## Step 9 — Gene-level counting (HTSeq-count)

Union mode, unstranded library, feature type `gene`, `gene_id` as the counting attribute — matches the counting strategy used to generate the original GSE164416 count matrix.

```bash
htseq-count \
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
    > "${COUNT_OUT}"
```

## Step 10 — Merge per-sample counts into one count matrix

HTSeq's `__` summary rows (`__no_feature`, `__ambiguous`, etc.) are stripped before merging on `gene_id` across all samples.

```python
import os, glob
import pandas as pd

count_files = sorted(glob.glob(os.path.join(counts_dir, "*_counts.txt")))

dfs = []
for f in count_files:
    sample = os.path.basename(f).replace("_counts.txt", "")
    df = pd.read_csv(f, sep="\t", header=None,
                      names=["gene_id", "gene_name", "count"])
    df = df[~df["gene_id"].str.startswith("__")]
    df = df[["gene_id", "count"]].rename(columns={"count": sample})
    dfs.append(df)

merged = dfs[0]
for df in dfs[1:]:
    merged = merged.merge(df, on="gene_id", how="outer")

merged = merged.fillna(0).astype({c: int for c in merged.columns if c != "gene_id"})
merged.to_csv(output_path, sep="\t", index=False)
```

---

## Final QC rollup

```bash
multiqc \
    "${PROJECT_DIR}" \
    --outdir "${QC_DIR}" \
    --filename "multiqc_full_pipeline" \
    --ignore "${GENOME_DIR}" \
    --ignore "${FASTQ_DIR}" \
    --ignore "${TRIMMED_DIR}" \
    --quiet
```

## Tool versions required

| Tool | Minimum version |
|---|---|
| sra-tools (prefetch, fasterq-dump) | ≥ 3.0 |
| FastQC | ≥ 0.12 |
| MultiQC | ≥ 1.18 |
| fastp | ≥ 0.23 |
| STAR | ≥ 2.7.10 |
| SAMtools | ≥ 1.18 |
| HTSeq | ≥ 2.0 |
| Python | ≥ 3.9 |
