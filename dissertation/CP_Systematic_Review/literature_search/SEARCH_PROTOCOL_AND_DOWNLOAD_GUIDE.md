# CP Systematic Review — Search Protocol & Download Guide

**Review title:** Co-expression Networks of Cerebral Palsy-Associated Genes in the Developing Human Brain: A Systematic Review  
**Lead researcher:** Kumar  
**Date:** 2026-10-23  

---

## 1. Refined Research Questions

### Aim
To identify, critically appraise, and synthesise published co-expression network evidence for cerebral palsy (CP)-associated genes in the developing human brain.

---

### Primary Research Question

> In co-expression networks constructed from developing human brain transcriptomic data, do CP-associated genes cluster within shared modules or show stronger mutual co-expression than expected by chance — and if so, in which modules, developmental stages, brain regions, and cell types?

**PICO framing:**

| Element | Definition |
|---|---|
| **Population** | Co-expression networks derived from developing human brain tissue, organoids, or primary neural cells |
| **Index condition** | CP-associated gene membership (credible genetic evidence) |
| **Comparator** | Non-CP genes within the same network; random gene sets of matched size |
| **Outcome** | Module co-membership, hub-gene status, enrichment of CP genes within specific modules; biological pathway identity of those modules |

---

### Secondary Research Questions

| # | Question |
|---|---|
| **SQ1** | Which genes have credible genetic evidence of association with CP, and what evidence tier do they belong to (de novo pathogenic variant, CNV, GWAS locus, familial variant, candidate)? |
| **SQ2** | Which co-expression modules contain CP-associated genes, and are any CP genes module hubs (high intramodular connectivity / module membership score)? |
| **SQ3** | Do module memberships or convergence signals differ by developmental stage (embryonic, fetal, neonatal, postnatal), brain region (cortex, cerebellum, basal ganglia, brainstem), cell type (radial glia, excitatory neuron, inhibitory neuron, oligodendrocyte, astrocyte), or sex — where data allow? |
| **SQ4** | Which biological processes and pathways (GO, KEGG, Reactome) characterise modules enriched for CP-associated genes? |
| **SQ5** | Are CP-gene modules shared with, or distinct from, modules enriched for other neurodevelopmental disorder (NDD) genes (ASD, ID, ADHD, epilepsy)? |
| **SQ6** | How robust and reproducible is the network evidence across datasets and methods, and how does primary human tissue evidence compare with organoid or cell-model evidence? |

---

## 2. Two-Stage Search Strategy

### Stage 1 — Identify CP-associated genes
Search for genetic studies establishing gene–CP associations.  
**PubMed query:** `(#1 AND #2) NOT #6`

### Stage 2A — Co-expression studies mentioning CP
**PubMed query:** `#1 AND #3 AND #4`

### Stage 2B — Co-expression studies for specific CP genes (targeted)
Build GENE_LIST from Stage 1 results.  
**PubMed query:** `(GENE_LIST[tiab]) AND #3 AND #4`

### Stage 2C — Broad developmental brain co-expression atlases
**PubMed query:** `#3 AND #4 AND #5`

### Supplementary — Systematic reviews
**PubMed query:** `#1 AND (#3 OR #4) AND systematic[sb]`

---

## 3. Databases to Search

| Database | Format to export | Notes |
|---|---|---|
| PubMed | `.nbib` (PubMed format) | Free, supports bulk export up to 10,000 records |
| Embase | `.ris` | Requires institutional login |
| Scopus | `.ris` | Requires institutional login |
| Web of Science | `.ris` or `.bib` | Export in batches of 1,000 |
| Europe PMC | `.ris` | Free |
| Google Scholar | Manual `.ris` via Zotero connector | Use for citation chasing only |

---

## 4. File Naming Convention

All export files must follow this format:

```
YYYY-MM-DD_[DATABASE]_Stage[X]_[DESCRIPTION].[ext]
```

**Examples:**
```
2026-10-23_PubMed_Stage1_CP-genetics.nbib
2026-10-23_Embase_Stage2A_CP-coexpression.ris
2026-10-23_Scopus_Stage2C_BrainDev-coexpression.ris
2026-10-23_WoS_Stage2B_CPgenes-network.ris
2026-10-23_EuropePMC_Stage1_CP-genetics.ris
2026-10-23_GoogleScholar_Supplementary_citations.ris
```

**Rules:**
- Use the date you ran the search (not today if you run it later)
- Keep database name exactly as above (PubMed / Embase / Scopus / WoS / EuropePMC / GoogleScholar)
- Stage number matches the query stage (1, 2A, 2B, 2C, Supplementary)
- No spaces — use hyphens within the description field
- Save every raw export **before** deduplication

---

## 5. Step-by-Step Download Instructions

---

### 5.1 PubMed (free — do this first)

1. Go to **pubmed.ncbi.nlm.nih.gov**
2. Paste your PubMed query into the search bar and press Enter
3. Note the total result count at the top
4. Click **Save** (just below the search bar, next to Sort)
5. In the dropdown:
   - **Selection:** All results
   - **Format:** PubMed (this gives you `.nbib`)
6. Click **Create file** — it downloads automatically
7. Rename the file following the naming convention above
8. Move it to `raw_exports/`
9. Repeat for each stage query (Stage 1, Stage 2A, Stage 2C, Supplementary)

> If results exceed 10,000: export in batches using the date filter (e.g. 2000–2015, then 2016–2026).

---

### 5.2 Embase (requires institutional login)

1. Go to **embase.com** (log in through your university library)
2. Click **Advanced search**
3. Paste your search terms (translate the PubMed query — Embase uses Emtree rather than MeSH, but free-text [tiab] terms work)
4. Run the search; note the result count
5. Tick the checkbox next to the results header to **select all**
6. Click **Export**
7. Choose:
   - **Format:** RIS
   - **Output:** All fields (or at minimum: title, authors, abstract, journal, year, DOI)
8. Download — rename and move to `raw_exports/`

---

### 5.3 Scopus (requires institutional login)

1. Go to **scopus.com** (log in through your university library)
2. Click **Advanced search** (top right)
3. Translate your query to Scopus syntax:
   - Replace `[tiab]` with `TITLE-ABS-KEY( )` 
   - Replace `[Mesh]` terms with the equivalent keyword in `TITLE-ABS-KEY( )`
4. Run the search
5. Tick **Select all** in the results list
6. Click **Export**
7. Choose:
   - **File type:** RIS Format
   - **Information to export:** Citation information + Abstract & keywords
8. Download — rename and move to `raw_exports/`

> Scopus exports up to 2,000 at a time. If you have more, sort by date and export in batches.

---

### 5.4 Web of Science (WoS)

1. Go to **webofscience.com** (log in through your university)
2. Click **Advanced Search**
3. Translate your query (WoS uses `TS=` for topic, `TI=` for title, `AB=` for abstract)
4. Run the search
5. Click **Export > Other File Formats**
6. Choose:
   - **Records:** 1 to [n] (max 1,000 per export — repeat in batches if needed)
   - **Record Content:** Full Record
   - **File Format:** RIS
7. Download — rename and move to `raw_exports/`

---

### 5.5 Europe PMC (free)

1. Go to **europepmc.org**
2. Click **Advanced Search**
3. Paste your query (Europe PMC supports PubMed-style syntax, so your PubMed queries work directly)
4. Run the search
5. Click **Export results** (below the search bar)
6. Choose:
   - **Format:** RIS or JSON (choose RIS for Rayyan)
   - **Fields to include:** All
7. Download — rename and move to `raw_exports/`

---

### 5.6 Google Scholar (supplementary / citation chasing only)

Google Scholar does not have a native bulk export. Use it to chase citations of key papers found in other databases.

1. Install the **Zotero desktop app** (free — zotero.org) and the **Zotero Connector** browser extension
2. Search Google Scholar for a key review paper
3. Click the Zotero Connector icon in your browser to save results to Zotero
4. In Zotero, select the items → **File > Export Library** → RIS format
5. Rename and move to `raw_exports/`

---

## 6. After All Downloads — Before Rayyan

Before uploading to Rayyan, do a quick sanity check:

1. Open each `.ris` / `.nbib` file in a text editor
2. Confirm it has `TI  -` (title) and `AB  -` (abstract) fields — Rayyan needs these to screen
3. Count the records (search for `ER  -` in `.ris` files — each marks one record end; PubMed `.nbib` files use `PMID-`)
4. Record counts in the table in Section 7 below

---

## 7. Search Log (fill in as you go)

| Date | Database | Stage | Query version | Raw count | File name |
|---|---|---|---|---|---|
| | PubMed | Stage 1 | v1 | | |
| | PubMed | Stage 2A | v1 | | |
| | PubMed | Stage 2C | v1 | | |
| | Embase | Stage 1 | v1 | | |
| | Embase | Stage 2A | v1 | | |
| | Scopus | Stage 1 | v1 | | |
| | Scopus | Stage 2A | v1 | | |
| | WoS | Stage 2A | v1 | | |
| | Europe PMC | Stage 1 | v1 | | |
| | Europe PMC | Stage 2A | v1 | | |
| | Google Scholar | Supplementary | v1 | | |
| **TOTAL before dedup** | | | | | |

---

## 8. Uploading to Rayyan

1. Go to **rayyan.ai** and log in / create account
2. Create a new **Review** — title: `CP Co-expression Systematic Review`
3. Click **References > Import**
4. Upload each `.ris` / `.nbib` file one at a time (upload all files from all databases)
5. Rayyan will automatically deduplicate — review the duplicate detection after import
6. Assign Kumar (and supervisor if they have a Rayyan account) as collaborators

---

## 9. Google Drive Folder Structure (share with supervisor)

```
CP_Systematic_Review/                          ← share this top-level folder
│
├── 00_Protocol/
│   ├── SEARCH_PROTOCOL_AND_DOWNLOAD_GUIDE.md  ← this file
│   └── PRISMA_checklist.docx                  ← add when ready
│
├── 01_Literature_Search/
│   ├── raw_exports/                            ← all .ris / .nbib files (named per convention)
│   └── search_log.xlsx                        ← copy of Section 7 table above
│
├── 02_Screening/
│   ├── rayyan_export_pre-screening.ris
│   └── rayyan_export_post-screening.ris
│
├── 03_Data_Extraction/
│   └── extraction_template.xlsx
│
├── 04_Quality_Assessment/
│
└── 05_Manuscript/
```

---

*Protocol version 1.0 — Kumar, 2026-10-23*
