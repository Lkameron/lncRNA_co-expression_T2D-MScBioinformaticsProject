# Copy-Paste Search Strings
## CP Co-expression Systematic Review — All Databases, All Stages

**Date searches prepared:** 2026-10-23  
**Prepared by:** Kumar  

---

> **How to use this file**
> - Each database has its own section
> - Within each database, there is one ready-to-paste query per stage
> - Copy the whole block between the triple backticks — paste it exactly as-is
> - For PubMed: use the History method (recommended) — paste Block 1, save, paste Block 2, save, then paste the Stage Combination line
> - Record your result counts in `search_log.xlsx` immediately after each run

---

---

# DATABASE 1: PubMed

> **Recommended method:** use PubMed's **Advanced Search Builder** → paste each block → click **Search** → it saves to History as #1, #2, etc. Then paste the combination query at the bottom of each stage.

---

## BLOCKS (paste each one separately into PubMed Advanced Search)

---

### Block 1 — Cerebral Palsy terms

```
"Cerebral Palsy"[Mesh] OR "cerebral palsy"[tiab] OR "cerebral palsies"[tiab] OR "spastic diplegia"[tiab] OR "spastic quadriplegia"[tiab] OR "spastic hemiplegia"[tiab] OR "dyskinetic cerebral palsy"[tiab]
```

---

### Block 2 — CP Genetics terms

```
"Genetic Predisposition to Disease"[Mesh] OR "Mutation"[Mesh] OR "DNA Copy Number Variations"[Mesh] OR "Exome Sequencing"[Mesh] OR "Whole Genome Sequencing"[Mesh] OR gene[tiab] OR genes[tiab] OR genetic*[tiab] OR genomic*[tiab] OR genotyp*[tiab] OR variant*[tiab] OR mutation*[tiab] OR "de novo"[tiab] OR monogenic[tiab] OR "copy number"[tiab] OR exome*[tiab] OR "genome sequencing"[tiab] OR "risk gene"[tiab] OR "risk genes"[tiab] OR "candidate gene"[tiab] OR "candidate genes"[tiab]
```

---

### Block 3 — Co-expression and Networks

```
"Gene Regulatory Networks"[Mesh] OR "Gene Expression Profiling"[Mesh] OR "Transcriptome"[Mesh] OR coexpress*[tiab] OR co-express*[tiab] OR WGCNA[tiab] OR "weighted gene co-expression"[tiab] OR "gene network"[tiab] OR "gene networks"[tiab] OR "expression network"[tiab] OR "expression networks"[tiab] OR "correlation network"[tiab] OR "correlation networks"[tiab] OR "expression module"[tiab] OR "expression modules"[tiab] OR "gene module"[tiab] OR "gene modules"[tiab] OR "transcriptional network"[tiab] OR "transcriptional networks"[tiab] OR "module eigengene"[tiab] OR "module eigengenes"[tiab] OR "hub gene"[tiab] OR "hub genes"[tiab] OR "network analysis"[tiab]
```

---

### Block 4 — Developing Brain

```
"Brain/growth and development"[Mesh] OR "Brain/embryology"[Mesh] OR "Cerebral Cortex/embryology"[Mesh] OR "Neurogenesis"[Mesh] OR "Neural Stem Cells"[Mesh] OR "brain development"[tiab] OR "developing brain"[tiab] OR "fetal brain"[tiab] OR "foetal brain"[tiab] OR "embryonic brain"[tiab] OR "prenatal brain"[tiab] OR "neonatal brain"[tiab] OR neurodevelopment*[tiab] OR corticogenesis[tiab] OR "cortical development"[tiab] OR "neural progenitor"[tiab] OR "neural progenitors"[tiab] OR "radial glia"[tiab] OR "radial glial"[tiab] OR "brain organoid"[tiab] OR "brain organoids"[tiab] OR "cerebral organoid"[tiab] OR "cerebral organoids"[tiab]
```

---

### Block 5 — Human Developmental Context

```
"Humans"[Mesh] AND ("Fetus"[Mesh] OR fetal[tiab] OR foetal[tiab] OR prenatal[tiab] OR embryonic[tiab] OR postconception[tiab] OR "post-conception"[tiab] OR "gestational week"[tiab] OR "gestational weeks"[tiab] OR "mid-gestation"[tiab] OR midgestation[tiab] OR trimester*[tiab])
```

---

### Block 6 — Animal-Only Exclusion filter

```
"Animals"[Mesh] NOT "Humans"[Mesh]
```

---

## STAGE COMBINATION QUERIES (paste after running all blocks above)

> Replace #1, #2 etc. with the actual History numbers PubMed assigned your blocks.  
> PubMed shows them as Search #1, Search #2 in the History panel.

---

### PubMed — Stage 1: CP Genetics
**Logic:** Block 1 AND Block 2, excluding animal-only

```
(#1 AND #2) NOT #6
```

**Full self-contained version** (paste this if not using History):

```
(
  "Cerebral Palsy"[Mesh] OR "cerebral palsy"[tiab] OR "cerebral palsies"[tiab] OR "spastic diplegia"[tiab] OR "spastic quadriplegia"[tiab] OR "spastic hemiplegia"[tiab] OR "dyskinetic cerebral palsy"[tiab]
)
AND
(
  "Genetic Predisposition to Disease"[Mesh] OR "Mutation"[Mesh] OR "DNA Copy Number Variations"[Mesh] OR "Exome Sequencing"[Mesh] OR "Whole Genome Sequencing"[Mesh] OR gene[tiab] OR genes[tiab] OR genetic*[tiab] OR genomic*[tiab] OR genotyp*[tiab] OR variant*[tiab] OR mutation*[tiab] OR "de novo"[tiab] OR monogenic[tiab] OR "copy number"[tiab] OR exome*[tiab] OR "genome sequencing"[tiab] OR "risk gene"[tiab] OR "risk genes"[tiab] OR "candidate gene"[tiab] OR "candidate genes"[tiab]
)
NOT ("Animals"[Mesh] NOT "Humans"[Mesh])
```

---

### PubMed — Stage 2A: CP Co-expression Studies
**Logic:** Block 1 AND Block 3 AND Block 4

```
#1 AND #3 AND #4
```

**Full self-contained version:**

```
(
  "Cerebral Palsy"[Mesh] OR "cerebral palsy"[tiab] OR "cerebral palsies"[tiab] OR "spastic diplegia"[tiab] OR "spastic quadriplegia"[tiab] OR "spastic hemiplegia"[tiab] OR "dyskinetic cerebral palsy"[tiab]
)
AND
(
  "Gene Regulatory Networks"[Mesh] OR "Gene Expression Profiling"[Mesh] OR "Transcriptome"[Mesh] OR coexpress*[tiab] OR co-express*[tiab] OR WGCNA[tiab] OR "weighted gene co-expression"[tiab] OR "gene network"[tiab] OR "gene networks"[tiab] OR "expression network"[tiab] OR "expression networks"[tiab] OR "correlation network"[tiab] OR "correlation networks"[tiab] OR "expression module"[tiab] OR "expression modules"[tiab] OR "gene module"[tiab] OR "gene modules"[tiab] OR "transcriptional network"[tiab] OR "transcriptional networks"[tiab] OR "module eigengene"[tiab] OR "module eigengenes"[tiab] OR "hub gene"[tiab] OR "hub genes"[tiab] OR "network analysis"[tiab]
)
AND
(
  "Brain/growth and development"[Mesh] OR "Brain/embryology"[Mesh] OR "Cerebral Cortex/embryology"[Mesh] OR "Neurogenesis"[Mesh] OR "Neural Stem Cells"[Mesh] OR "brain development"[tiab] OR "developing brain"[tiab] OR "fetal brain"[tiab] OR "foetal brain"[tiab] OR "embryonic brain"[tiab] OR "prenatal brain"[tiab] OR "neonatal brain"[tiab] OR neurodevelopment*[tiab] OR corticogenesis[tiab] OR "cortical development"[tiab] OR "neural progenitor"[tiab] OR "neural progenitors"[tiab] OR "radial glia"[tiab] OR "radial glial"[tiab] OR "brain organoid"[tiab] OR "brain organoids"[tiab] OR "cerebral organoid"[tiab] OR "cerebral organoids"[tiab]
)
```

---

### PubMed — Stage 2B: Specific CP Genes (fill in gene list from Stage 1)
**Logic:** Gene list AND Block 3 AND Block 4  
**⚠ Complete Stage 1 first — replace GENE_LIST with your actual genes**

```
(GENE_LIST[tiab]) AND #3 AND #4
```

**Template to fill in** (replace GENE_LIST with your genes, comma-separated with OR):

```
(
  "GENE1"[tiab] OR "GENE2"[tiab] OR "GENE3"[tiab]
)
AND
(
  "Gene Regulatory Networks"[Mesh] OR "Gene Expression Profiling"[Mesh] OR "Transcriptome"[Mesh] OR coexpress*[tiab] OR co-express*[tiab] OR WGCNA[tiab] OR "weighted gene co-expression"[tiab] OR "gene network"[tiab] OR "gene networks"[tiab] OR "expression network"[tiab] OR "expression networks"[tiab] OR "correlation network"[tiab] OR "correlation networks"[tiab] OR "expression module"[tiab] OR "expression modules"[tiab] OR "gene module"[tiab] OR "gene modules"[tiab] OR "transcriptional network"[tiab] OR "transcriptional networks"[tiab] OR "module eigengene"[tiab] OR "module eigengenes"[tiab] OR "hub gene"[tiab] OR "hub genes"[tiab] OR "network analysis"[tiab]
)
AND
(
  "Brain/growth and development"[Mesh] OR "Brain/embryology"[Mesh] OR "Cerebral Cortex/embryology"[Mesh] OR "Neurogenesis"[Mesh] OR "Neural Stem Cells"[Mesh] OR "brain development"[tiab] OR "developing brain"[tiab] OR "fetal brain"[tiab] OR "foetal brain"[tiab] OR "embryonic brain"[tiab] OR "prenatal brain"[tiab] OR "neonatal brain"[tiab] OR neurodevelopment*[tiab] OR corticogenesis[tiab] OR "cortical development"[tiab] OR "neural progenitor"[tiab] OR "neural progenitors"[tiab] OR "radial glia"[tiab] OR "radial glial"[tiab] OR "brain organoid"[tiab] OR "brain organoids"[tiab] OR "cerebral organoid"[tiab] OR "cerebral organoids"[tiab]
)
```

---

### PubMed — Stage 2C: Broad Developmental Brain Co-expression Atlases
**Logic:** Block 3 AND Block 4 AND Block 5

```
#3 AND #4 AND #5
```

**Full self-contained version:**

```
(
  "Gene Regulatory Networks"[Mesh] OR "Gene Expression Profiling"[Mesh] OR "Transcriptome"[Mesh] OR coexpress*[tiab] OR co-express*[tiab] OR WGCNA[tiab] OR "weighted gene co-expression"[tiab] OR "gene network"[tiab] OR "gene networks"[tiab] OR "expression network"[tiab] OR "expression networks"[tiab] OR "correlation network"[tiab] OR "correlation networks"[tiab] OR "expression module"[tiab] OR "expression modules"[tiab] OR "gene module"[tiab] OR "gene modules"[tiab] OR "transcriptional network"[tiab] OR "transcriptional networks"[tiab] OR "module eigengene"[tiab] OR "module eigengenes"[tiab] OR "hub gene"[tiab] OR "hub genes"[tiab] OR "network analysis"[tiab]
)
AND
(
  "Brain/growth and development"[Mesh] OR "Brain/embryology"[Mesh] OR "Cerebral Cortex/embryology"[Mesh] OR "Neurogenesis"[Mesh] OR "Neural Stem Cells"[Mesh] OR "brain development"[tiab] OR "developing brain"[tiab] OR "fetal brain"[tiab] OR "foetal brain"[tiab] OR "embryonic brain"[tiab] OR "prenatal brain"[tiab] OR "neonatal brain"[tiab] OR neurodevelopment*[tiab] OR corticogenesis[tiab] OR "cortical development"[tiab] OR "neural progenitor"[tiab] OR "neural progenitors"[tiab] OR "radial glia"[tiab] OR "radial glial"[tiab] OR "brain organoid"[tiab] OR "brain organoids"[tiab] OR "cerebral organoid"[tiab] OR "cerebral organoids"[tiab]
)
AND
(
  "Humans"[Mesh] AND ("Fetus"[Mesh] OR fetal[tiab] OR foetal[tiab] OR prenatal[tiab] OR embryonic[tiab] OR postconception[tiab] OR "post-conception"[tiab] OR "gestational week"[tiab] OR "gestational weeks"[tiab] OR "mid-gestation"[tiab] OR midgestation[tiab] OR trimester*[tiab])
)
```

---

### PubMed — Supplementary: Systematic Reviews
**Logic:** Block 1 AND (Block 3 OR Block 4) AND systematic review filter

```
#1 AND (#3 OR #4) AND systematic[sb]
```

**Full self-contained version:**

```
(
  "Cerebral Palsy"[Mesh] OR "cerebral palsy"[tiab] OR "cerebral palsies"[tiab] OR "spastic diplegia"[tiab] OR "spastic quadriplegia"[tiab] OR "spastic hemiplegia"[tiab] OR "dyskinetic cerebral palsy"[tiab]
)
AND
(
  "Gene Regulatory Networks"[Mesh] OR "Gene Expression Profiling"[Mesh] OR "Transcriptome"[Mesh] OR coexpress*[tiab] OR co-express*[tiab] OR WGCNA[tiab] OR "weighted gene co-expression"[tiab] OR "gene network"[tiab] OR "gene networks"[tiab] OR "expression network"[tiab] OR "expression networks"[tiab] OR "correlation network"[tiab] OR "correlation networks"[tiab] OR "expression module"[tiab] OR "expression modules"[tiab] OR "gene module"[tiab] OR "gene modules"[tiab] OR "transcriptional network"[tiab] OR "transcriptional networks"[tiab] OR "module eigengene"[tiab] OR "module eigengenes"[tiab] OR "hub gene"[tiab] OR "hub genes"[tiab] OR "network analysis"[tiab]
  OR
  "Brain/growth and development"[Mesh] OR "Brain/embryology"[Mesh] OR "Cerebral Cortex/embryology"[Mesh] OR "Neurogenesis"[Mesh] OR "Neural Stem Cells"[Mesh] OR "brain development"[tiab] OR "developing brain"[tiab] OR "fetal brain"[tiab] OR "foetal brain"[tiab] OR "embryonic brain"[tiab] OR "prenatal brain"[tiab] OR "neonatal brain"[tiab] OR neurodevelopment*[tiab] OR corticogenesis[tiab] OR "cortical development"[tiab] OR "neural progenitor"[tiab] OR "neural progenitors"[tiab] OR "radial glia"[tiab] OR "radial glial"[tiab] OR "brain organoid"[tiab] OR "brain organoids"[tiab] OR "cerebral organoid"[tiab] OR "cerebral organoids"[tiab]
)
AND systematic[sb]
```

---
---

# DATABASE 2: Embase

> **How to use:** Go to embase.com → Advanced Search → paste each query into the search box → click Search. Embase uses `:ab,ti` for title/abstract and `/exp` for controlled Emtree vocabulary.

---

### Embase — Stage 1: CP Genetics

```
('cerebral palsy'/exp OR 'cerebral palsy':ab,ti OR 'cerebral palsies':ab,ti OR 'spastic diplegia':ab,ti OR 'spastic quadriplegia':ab,ti OR 'spastic hemiplegia':ab,ti OR 'dyskinetic cerebral palsy':ab,ti)
AND
('genetic predisposition'/exp OR 'mutation'/exp OR 'copy number variation'/exp OR 'exome sequencing'/exp OR 'whole genome sequencing'/exp OR gene:ab,ti OR genes:ab,ti OR genetic*:ab,ti OR genomic*:ab,ti OR genotyp*:ab,ti OR variant*:ab,ti OR mutation*:ab,ti OR 'de novo':ab,ti OR monogenic:ab,ti OR 'copy number':ab,ti OR exome*:ab,ti OR 'genome sequencing':ab,ti OR 'risk gene':ab,ti OR 'risk genes':ab,ti OR 'candidate gene':ab,ti OR 'candidate genes':ab,ti)
NOT ('animal experiment'/exp NOT 'human'/exp)
```

---

### Embase — Stage 2A: CP Co-expression Studies

```
('cerebral palsy'/exp OR 'cerebral palsy':ab,ti OR 'cerebral palsies':ab,ti OR 'spastic diplegia':ab,ti OR 'spastic quadriplegia':ab,ti OR 'spastic hemiplegia':ab,ti OR 'dyskinetic cerebral palsy':ab,ti)
AND
('gene regulatory network'/exp OR 'gene expression profiling'/exp OR 'transcriptome'/exp OR coexpress*:ab,ti OR co-express*:ab,ti OR WGCNA:ab,ti OR 'weighted gene co-expression':ab,ti OR 'gene network':ab,ti OR 'gene networks':ab,ti OR 'expression network':ab,ti OR 'expression networks':ab,ti OR 'correlation network':ab,ti OR 'correlation networks':ab,ti OR 'expression module':ab,ti OR 'expression modules':ab,ti OR 'gene module':ab,ti OR 'gene modules':ab,ti OR 'transcriptional network':ab,ti OR 'transcriptional networks':ab,ti OR 'module eigengene':ab,ti OR 'module eigengenes':ab,ti OR 'hub gene':ab,ti OR 'hub genes':ab,ti OR 'network analysis':ab,ti)
AND
('brain development'/exp OR 'neurogenesis'/exp OR 'neural stem cell'/exp OR 'brain development':ab,ti OR 'developing brain':ab,ti OR 'fetal brain':ab,ti OR 'foetal brain':ab,ti OR 'embryonic brain':ab,ti OR 'prenatal brain':ab,ti OR 'neonatal brain':ab,ti OR neurodevelopment*:ab,ti OR corticogenesis:ab,ti OR 'cortical development':ab,ti OR 'neural progenitor':ab,ti OR 'neural progenitors':ab,ti OR 'radial glia':ab,ti OR 'radial glial':ab,ti OR 'brain organoid':ab,ti OR 'brain organoids':ab,ti OR 'cerebral organoid':ab,ti OR 'cerebral organoids':ab,ti)
```

---

### Embase — Stage 2B: Specific CP Genes
**⚠ Fill in gene names from your Stage 1 results**

```
(GENE1:ab,ti OR GENE2:ab,ti OR GENE3:ab,ti)
AND
('gene regulatory network'/exp OR 'gene expression profiling'/exp OR 'transcriptome'/exp OR coexpress*:ab,ti OR co-express*:ab,ti OR WGCNA:ab,ti OR 'weighted gene co-expression':ab,ti OR 'gene network':ab,ti OR 'gene networks':ab,ti OR 'expression network':ab,ti OR 'expression networks':ab,ti OR 'correlation network':ab,ti OR 'correlation networks':ab,ti OR 'expression module':ab,ti OR 'expression modules':ab,ti OR 'gene module':ab,ti OR 'gene modules':ab,ti OR 'transcriptional network':ab,ti OR 'transcriptional networks':ab,ti OR 'module eigengene':ab,ti OR 'module eigengenes':ab,ti OR 'hub gene':ab,ti OR 'hub genes':ab,ti OR 'network analysis':ab,ti)
AND
('brain development'/exp OR 'neurogenesis'/exp OR 'neural stem cell'/exp OR 'brain development':ab,ti OR 'developing brain':ab,ti OR 'fetal brain':ab,ti OR 'foetal brain':ab,ti OR 'embryonic brain':ab,ti OR 'prenatal brain':ab,ti OR 'neonatal brain':ab,ti OR neurodevelopment*:ab,ti OR corticogenesis:ab,ti OR 'cortical development':ab,ti OR 'neural progenitor':ab,ti OR 'neural progenitors':ab,ti OR 'radial glia':ab,ti OR 'radial glial':ab,ti OR 'brain organoid':ab,ti OR 'brain organoids':ab,ti OR 'cerebral organoid':ab,ti OR 'cerebral organoids':ab,ti)
```

---

### Embase — Stage 2C: Broad Developmental Brain Co-expression Atlases

```
('gene regulatory network'/exp OR 'gene expression profiling'/exp OR 'transcriptome'/exp OR coexpress*:ab,ti OR co-express*:ab,ti OR WGCNA:ab,ti OR 'weighted gene co-expression':ab,ti OR 'gene network':ab,ti OR 'gene networks':ab,ti OR 'expression network':ab,ti OR 'expression networks':ab,ti OR 'correlation network':ab,ti OR 'correlation networks':ab,ti OR 'expression module':ab,ti OR 'expression modules':ab,ti OR 'gene module':ab,ti OR 'gene modules':ab,ti OR 'transcriptional network':ab,ti OR 'transcriptional networks':ab,ti OR 'module eigengene':ab,ti OR 'module eigengenes':ab,ti OR 'hub gene':ab,ti OR 'hub genes':ab,ti OR 'network analysis':ab,ti)
AND
('brain development'/exp OR 'neurogenesis'/exp OR 'neural stem cell'/exp OR 'brain development':ab,ti OR 'developing brain':ab,ti OR 'fetal brain':ab,ti OR 'foetal brain':ab,ti OR 'embryonic brain':ab,ti OR 'prenatal brain':ab,ti OR 'neonatal brain':ab,ti OR neurodevelopment*:ab,ti OR corticogenesis:ab,ti OR 'cortical development':ab,ti OR 'neural progenitor':ab,ti OR 'neural progenitors':ab,ti OR 'radial glia':ab,ti OR 'radial glial':ab,ti OR 'brain organoid':ab,ti OR 'brain organoids':ab,ti OR 'cerebral organoid':ab,ti OR 'cerebral organoids':ab,ti)
AND
('human'/exp AND ('fetus'/exp OR fetal:ab,ti OR foetal:ab,ti OR prenatal:ab,ti OR embryonic:ab,ti OR postconception:ab,ti OR 'post-conception':ab,ti OR 'gestational week':ab,ti OR 'gestational weeks':ab,ti OR 'mid-gestation':ab,ti OR midgestation:ab,ti OR trimester*:ab,ti))
```

---

### Embase — Supplementary: Systematic Reviews

```
('cerebral palsy'/exp OR 'cerebral palsy':ab,ti OR 'cerebral palsies':ab,ti OR 'spastic diplegia':ab,ti OR 'spastic quadriplegia':ab,ti OR 'spastic hemiplegia':ab,ti OR 'dyskinetic cerebral palsy':ab,ti)
AND
('gene regulatory network'/exp OR coexpress*:ab,ti OR co-express*:ab,ti OR WGCNA:ab,ti OR 'gene network':ab,ti OR 'gene networks':ab,ti OR 'brain development':ab,ti OR 'developing brain':ab,ti OR neurodevelopment*:ab,ti OR 'fetal brain':ab,ti OR 'foetal brain':ab,ti)
AND
('systematic review'/exp OR 'meta analysis'/exp OR 'systematic review':ab,ti OR 'meta-analysis':ab,ti)
```

---
---

# DATABASE 3: Scopus

> **How to use:** scopus.com → Advanced Search → paste query into the search field → Search. Scopus uses `TITLE-ABS-KEY()` for title/abstract/keyword searching. Wildcards: `*` works the same way.  
> **Export limit:** 2,000 records at a time — if results exceed this, sort by date and export in batches.

---

### Scopus — Stage 1: CP Genetics

```
TITLE-ABS-KEY ( "cerebral palsy" OR "cerebral palsies" OR "spastic diplegia" OR "spastic quadriplegia" OR "spastic hemiplegia" OR "dyskinetic cerebral palsy" )
AND
TITLE-ABS-KEY ( gene OR genes OR genetic* OR genomic* OR genotyp* OR variant* OR mutation* OR "de novo" OR monogenic OR "copy number" OR exome* OR "genome sequencing" OR "risk gene" OR "risk genes" OR "candidate gene" OR "candidate genes" )
AND NOT
TITLE-ABS-KEY ( mouse OR mice OR rat OR rats OR zebrafish OR drosophila OR "animal model" )
```

> After running: use the left sidebar to filter by **Document type: Article, Review** and optionally limit to human subjects if the filter appears.

---

### Scopus — Stage 2A: CP Co-expression Studies

```
TITLE-ABS-KEY ( "cerebral palsy" OR "cerebral palsies" OR "spastic diplegia" OR "spastic quadriplegia" OR "spastic hemiplegia" OR "dyskinetic cerebral palsy" )
AND
TITLE-ABS-KEY ( coexpress* OR co-express* OR WGCNA OR "weighted gene co-expression" OR "gene network" OR "gene networks" OR "expression network" OR "expression networks" OR "correlation network" OR "correlation networks" OR "expression module" OR "expression modules" OR "gene module" OR "gene modules" OR "transcriptional network" OR "transcriptional networks" OR "module eigengene" OR "module eigengenes" OR "hub gene" OR "hub genes" OR "network analysis" )
AND
TITLE-ABS-KEY ( "brain development" OR "developing brain" OR "fetal brain" OR "foetal brain" OR "embryonic brain" OR "prenatal brain" OR "neonatal brain" OR neurodevelopment* OR corticogenesis OR "cortical development" OR "neural progenitor" OR "neural progenitors" OR "radial glia" OR "radial glial" OR "brain organoid" OR "brain organoids" OR "cerebral organoid" OR "cerebral organoids" )
```

---

### Scopus — Stage 2B: Specific CP Genes
**⚠ Fill in gene names from your Stage 1 results**

```
TITLE-ABS-KEY ( "GENE1" OR "GENE2" OR "GENE3" )
AND
TITLE-ABS-KEY ( coexpress* OR co-express* OR WGCNA OR "weighted gene co-expression" OR "gene network" OR "gene networks" OR "expression network" OR "expression networks" OR "correlation network" OR "correlation networks" OR "expression module" OR "expression modules" OR "gene module" OR "gene modules" OR "transcriptional network" OR "transcriptional networks" OR "module eigengene" OR "module eigengenes" OR "hub gene" OR "hub genes" OR "network analysis" )
AND
TITLE-ABS-KEY ( "brain development" OR "developing brain" OR "fetal brain" OR "foetal brain" OR "embryonic brain" OR "prenatal brain" OR "neonatal brain" OR neurodevelopment* OR corticogenesis OR "cortical development" OR "neural progenitor" OR "neural progenitors" OR "radial glia" OR "radial glial" OR "brain organoid" OR "brain organoids" OR "cerebral organoid" OR "cerebral organoids" )
```

---

### Scopus — Stage 2C: Broad Developmental Brain Co-expression Atlases

```
TITLE-ABS-KEY ( coexpress* OR co-express* OR WGCNA OR "weighted gene co-expression" OR "gene network" OR "gene networks" OR "expression network" OR "expression networks" OR "correlation network" OR "correlation networks" OR "expression module" OR "expression modules" OR "gene module" OR "gene modules" OR "transcriptional network" OR "transcriptional networks" OR "module eigengene" OR "module eigengenes" OR "hub gene" OR "hub genes" OR "network analysis" )
AND
TITLE-ABS-KEY ( "brain development" OR "developing brain" OR "fetal brain" OR "foetal brain" OR "embryonic brain" OR "prenatal brain" OR "neonatal brain" OR neurodevelopment* OR corticogenesis OR "cortical development" OR "neural progenitor" OR "neural progenitors" OR "radial glia" OR "radial glial" OR "brain organoid" OR "brain organoids" OR "cerebral organoid" OR "cerebral organoids" )
AND
TITLE-ABS-KEY ( fetal OR foetal OR prenatal OR embryonic OR postconception OR "post-conception" OR "gestational week" OR "gestational weeks" OR "mid-gestation" OR midgestation OR trimester* )
```

---

### Scopus — Supplementary: Systematic Reviews

```
TITLE-ABS-KEY ( "cerebral palsy" OR "cerebral palsies" OR "spastic diplegia" OR "spastic quadriplegia" OR "spastic hemiplegia" )
AND
TITLE-ABS-KEY ( coexpress* OR co-express* OR WGCNA OR "gene network" OR "gene networks" OR "brain development" OR "developing brain" OR neurodevelopment* OR "fetal brain" OR "foetal brain" )
AND
TITLE-ABS-KEY ( "systematic review" OR "meta-analysis" )
```

---
---

# DATABASE 4: Web of Science (WoS)

> **How to use:** webofscience.com → Advanced Search → paste query → Search.  
> WoS uses `TS=` for topic (title + abstract + keywords + keywords plus), `TI=` for title only.  
> **Export limit:** 1,000 records per export — batch by date if needed.

---

### WoS — Stage 1: CP Genetics

```
TS=("cerebral palsy" OR "cerebral palsies" OR "spastic diplegia" OR "spastic quadriplegia" OR "spastic hemiplegia" OR "dyskinetic cerebral palsy")
AND
TS=(gene OR genes OR genetic* OR genomic* OR genotyp* OR variant* OR mutation* OR "de novo" OR monogenic OR "copy number" OR exome* OR "genome sequencing" OR "risk gene" OR "risk genes" OR "candidate gene" OR "candidate genes")
```

> After running: use the **Refine Results** panel to filter by **Organism: Humans** if available.

---

### WoS — Stage 2A: CP Co-expression Studies

```
TS=("cerebral palsy" OR "cerebral palsies" OR "spastic diplegia" OR "spastic quadriplegia" OR "spastic hemiplegia" OR "dyskinetic cerebral palsy")
AND
TS=(coexpress* OR co-express* OR WGCNA OR "weighted gene co-expression" OR "gene network" OR "gene networks" OR "expression network" OR "expression networks" OR "correlation network" OR "correlation networks" OR "expression module" OR "expression modules" OR "gene module" OR "gene modules" OR "transcriptional network" OR "transcriptional networks" OR "module eigengene" OR "module eigengenes" OR "hub gene" OR "hub genes" OR "network analysis")
AND
TS=("brain development" OR "developing brain" OR "fetal brain" OR "foetal brain" OR "embryonic brain" OR "prenatal brain" OR "neonatal brain" OR neurodevelopment* OR corticogenesis OR "cortical development" OR "neural progenitor" OR "neural progenitors" OR "radial glia" OR "radial glial" OR "brain organoid" OR "brain organoids" OR "cerebral organoid" OR "cerebral organoids")
```

---

### WoS — Stage 2B: Specific CP Genes
**⚠ Fill in gene names from your Stage 1 results**

```
TS=("GENE1" OR "GENE2" OR "GENE3")
AND
TS=(coexpress* OR co-express* OR WGCNA OR "weighted gene co-expression" OR "gene network" OR "gene networks" OR "expression network" OR "expression networks" OR "correlation network" OR "correlation networks" OR "expression module" OR "expression modules" OR "gene module" OR "gene modules" OR "transcriptional network" OR "transcriptional networks" OR "module eigengene" OR "module eigengenes" OR "hub gene" OR "hub genes" OR "network analysis")
AND
TS=("brain development" OR "developing brain" OR "fetal brain" OR "foetal brain" OR "embryonic brain" OR "prenatal brain" OR "neonatal brain" OR neurodevelopment* OR corticogenesis OR "cortical development" OR "neural progenitor" OR "neural progenitors" OR "radial glia" OR "radial glial" OR "brain organoid" OR "brain organoids" OR "cerebral organoid" OR "cerebral organoids")
```

---

### WoS — Stage 2C: Broad Developmental Brain Co-expression Atlases

```
TS=(coexpress* OR co-express* OR WGCNA OR "weighted gene co-expression" OR "gene network" OR "gene networks" OR "expression network" OR "expression networks" OR "correlation network" OR "correlation networks" OR "expression module" OR "expression modules" OR "gene module" OR "gene modules" OR "transcriptional network" OR "transcriptional networks" OR "module eigengene" OR "module eigengenes" OR "hub gene" OR "hub genes" OR "network analysis")
AND
TS=("brain development" OR "developing brain" OR "fetal brain" OR "foetal brain" OR "embryonic brain" OR "prenatal brain" OR "neonatal brain" OR neurodevelopment* OR corticogenesis OR "cortical development" OR "neural progenitor" OR "neural progenitors" OR "radial glia" OR "radial glial" OR "brain organoid" OR "brain organoids" OR "cerebral organoid" OR "cerebral organoids")
AND
TS=(fetal OR foetal OR prenatal OR embryonic OR postconception OR "post-conception" OR "gestational week" OR "gestational weeks" OR "mid-gestation" OR midgestation OR trimester*)
```

---

### WoS — Supplementary: Systematic Reviews

```
TS=("cerebral palsy" OR "cerebral palsies" OR "spastic diplegia" OR "spastic quadriplegia" OR "spastic hemiplegia")
AND
TS=(coexpress* OR co-express* OR WGCNA OR "gene network" OR "gene networks" OR "brain development" OR "developing brain" OR neurodevelopment* OR "fetal brain" OR "foetal brain")
AND
TS=("systematic review" OR "meta-analysis")
```

---
---

# DATABASE 5: Europe PMC

> **How to use:** europepmc.org → Advanced Search → paste query → Search.  
> Europe PMC supports most PubMed syntax. The PubMed queries above work here directly — **you can paste the PubMed full self-contained queries for each stage without modification.**  
> The one difference: replace `[tiab]` with `:ab` or `:t` (or just remove the field tag — Europe PMC defaults to title+abstract).

**Shortcut:** Use the exact same full self-contained PubMed queries above for Europe PMC — they are compatible.

---

### Europe PMC — Stage 1: CP Genetics
*(paste the PubMed Stage 1 full query above — it works directly)*

---

### Europe PMC — Stage 2A: CP Co-expression Studies
*(paste the PubMed Stage 2A full query above — it works directly)*

---

### Europe PMC — Stage 2C: Broad Developmental Brain Co-expression Atlases
*(paste the PubMed Stage 2C full query above — it works directly)*

---

### Europe PMC — Supplementary: Systematic Reviews
*(paste the PubMed Supplementary full query above — it works directly)*

---
---

# Quick Reference Table

| Stage | What it finds | PubMed logic |
|---|---|---|
| **Stage 1** | Papers with CP genetics evidence | Block1 AND Block2, NOT Block6 |
| **Stage 2A** | Papers on CP + co-expression + brain dev | Block1 AND Block3 AND Block4 |
| **Stage 2B** | Papers on specific CP genes + networks | GENE_LIST AND Block3 AND Block4 |
| **Stage 2C** | Broad brain co-expression atlases | Block3 AND Block4 AND Block5 |
| **Supplementary** | Existing systematic reviews | Block1 AND (Block3 OR Block4) AND systematic filter |

| Database | Export format | Batch limit | Login needed |
|---|---|---|---|
| PubMed | `.nbib` | 10,000 | No |
| Embase | `.ris` | No limit shown | Yes (university) |
| Scopus | `.ris` | 2,000 | Yes (university) |
| WoS | `.ris` | 1,000 | Yes (university) |
| Europe PMC | `.ris` | No limit shown | No |

---

*Prepared by Kumar — v1.0 — 2026-10-23*
