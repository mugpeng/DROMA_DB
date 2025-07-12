# DROMA_DB: Drug Response Omics Multi-Analysis Database Manager

[![Website](https://img.shields.io/website?url=https%3A//droma01.github.io/)](https://droma01.github.io/)
[![R](https://img.shields.io/badge/R-%3E%3D4.0.0-blue.svg)](https://www.r-project.org/)
[![License: MPL-2.0](https://img.shields.io/badge/License-MPL--2.0-yellow.svg)](https://opensource.org/licenses/MPL-2.0)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15055905.svg)](https://doi.org/10.5281/zenodo.15055905)

## Overview

**DROMA_DB** is a comprehensive database creation and management system that converts diverse omics datasets into a structured SQLite database for drug response analysis. This project serves as the foundation for the DROMA ecosystem, providing efficient data storage and retrieval for multi-omics drug response studies across different model systems.

It is a part of [DROMA project](https://github.com/mugpeng/DROMA). Visit the [official DROMA website](https://droma01.github.io/) for comprehensive documentation and interactive examples.

### Key Features

- **🗄️ Unified Database Structure**: Converts heterogeneous Rda files into a structured SQLite database
- **📊 Project-Oriented Architecture**: Organizes data by research projects for efficient access
- **🔬 Multi-Omics Support**: Handles various molecular profile types (mRNA, CNV, mutations, methylation, proteomics)
- **💊 Drug Response Integration**: Comprehensive treatment response data management
- **🏥 Model System Coverage**: Supports Cell Lines, PDOs, PDXs, and PDCs
- **⚡ Optimized Queries**: Indexed database for fast data retrieval
- **📋 Metadata Management**: Maintains comprehensive sample and drug annotations

## Database Content

The DROMA database contains **21 projects** with comprehensive omics and drug response data:

| **project_name** | **dataset_type** | **data_types**                                               | **sample_count** | **drug_count** |
| ---------------- | ---------------- | ------------------------------------------------------------ | ---------------- | -------------- |
| **CCLE**         | CellLine         | cnv,drug,drug_dose,fusion,meth,mRNA,mutation_gene,mutation_site,proteinms,proteinrppa | 1811             | 24             |
| **CTRP1**        | CellLine         | drug                                                         | 241              | 354            |
| **CTRP2**        | CellLine         | drug,drug_dose                                               | 887              | 545            |
| **FIMM**         | CellLine         | drug                                                         | 50               | 52             |
| **GDSC1**        | CellLine         | drug,drug_dose                                               | 983              | 339            |
| **GDSC2**        | CellLine         | drug,drug_dose                                               | 806              | 188            |
| **GDSC**         | CellLine         | cnv,mRNA,mutation_gene,mutation_site                         | 1028             | 0              |
| **GRAY**         | CellLine         | drug                                                         | 71               | 106            |
| **NCI60**        | CellLine         | drug,mRNA                                                    | 162              | 54773          |
| **PDTXBreast**   | PDC              | drug                                                         | 37               | 98             |
| **Prism**        | CellLine         | drug,drug_dose                                               | 521              | 1442           |
| **Tavor**        | PDC              | drug,mRNA                                                    | 53               | 46             |
| **UHNBreast**    | CellLine         | drug                                                         | 57               | 8              |
| **UMPDO1**       | PDO              | drug,mRNA,mutation_gene,mutation_site                        | 112              | 49             |
| **UMPDO2**       | PDO              | cnv,drug,mRNA,mutation_gene,mutation_site                    | 40               | 49             |
| **UMPDO3**       | PDO              | drug,mRNA                                                    | 42               | 48             |
| **Xeva**         | PDX              | cnv,drug,mRNA,mutation_gene                                  | 266              | 38             |
| **gCSI**         | CellLine         | cnv,drug,drug_dose,mutation_gene                             | 579              | 44             |
| **LICOB**        | PDO              | cnv,drug,meth,mRNA,mutation_gene,proteinms                   | 65               | 76             |
| **CTRDB**        | Clinical         | mRNA                                                         | 2745             | 36             |
| **HKUPDO**       | PDO              | drug,fusion,mRNA,mutation_gene,mutation_site                 | 69               | 37             |



The table for details are in sql_db/DROMA_Projects_info_detail.csv



## Installation

### Prerequisites

Ensure you have R (≥ 4.0.0) and the required packages:

```r
# Install required dependencies
if (!requireNamespace("RSQLite", quietly = TRUE)) {
    install.packages("RSQLite")
}
if (!requireNamespace("DBI", quietly = TRUE)) {
    install.packages("DBI")
}
```

### Download Data

Download the DROMA data from Zenodo:

```r
# Data is available at: 10.5281/zenodo.15055905
# Download and extract the data files to your desired directory
```

### Clone Repository

```bash
git clone https://github.com/mugpeng/DROMA_DB.git
cd DROMA_DB
```

## Quick Start

### 1. Load Functions

```r
# Load the DROMA_DB functions
source("function/function.R")
```

### 2. Create Database

```r
# Create SQLite database from Rda files
createDROMADatabase(
    db_path = "sql_db/droma.sqlite",
    rda_dir = "data",
    projects = NULL  # Include all projects
)
```

### 3. Connect and Explore

```r
# Connect to the database
con <- connectDROMADatabase("sql_db/droma.sqlite")

# List all available projects
projects <- listDROMAProjects()
print(projects)

# List all database tables
tables <- listDROMADatabaseTables()
print(head(tables))

# Close connection when done
closeDROMADatabase()
```

### 4. Use with DROMA_Set Package

Once the database is created, use it with the DROMA_Set package:

```r
# Install DROMA_Set package
# devtools::install_github("mugpeng/DROMA_Set")
library(DROMA.Set)

# Create DromaSet objects from the database
gCSI <- createDromaSetFromDatabase("gCSI", "sql_db/droma.sqlite")
ccle <- createDromaSetFromDatabase("CCLE", "sql_db/droma.sqlite")

# Create MultiDromaSet for cross-project analysis
multi_set <- createMultiDromaSetFromDatabase(
    project_names = c("gCSI", "CCLE"),
    db_path = "sql_db/droma.sqlite"
)
```

## Database Creation Workflow

### Step 1: Data Preparation

Ensure your data directory contains:
- `anno.Rda`: Sample and drug annotations
- `{datatype}.Rda`: Data files (e.g., `mRNA.Rda`, `drug.Rda`, `cnv.Rda`)



### Step 2: Database Creation

```r
# Create comprehensive database
createDROMADatabase(
    db_path = "path/to/droma.sqlite",
    rda_dir = "path/to/data",
    projects = c("CCLE", "gCSI", "GDSC1")  # Specify projects or NULL for all
)
```

### Step 3: Database Connection

```r
# Connect 
con <- connectDROMADatabase("path/to/droma.sqlite")

# Check database structure
tables <- listDROMADatabaseTables()
```

Actually, there is no need for you to do these trivialities, just download the lastest version of DROMA_DB:[10.5281/zenodo.15055905](https://doi.org/10.5281/zenodo.15055905)

Then use [DROMA.Set package](https://github.com/mugpeng/DROMA_Set) and [DROMA_R](https://github.com/mugpeng/DROMA_R) to play with DROMA.

## Database Structure

### Table Naming Convention

- **Data Tables**: `{project}_{datatype}` (e.g., `CCLE_mRNA`, `gCSI_drug`)
- **Annotation Tables**: `sample_anno`, `drug_anno`
- **Metadata**: `projects` table with project information

### Supported Data Types

#### Molecular Profiles
- **mRNA**: Gene expression data
- **cnv**: Copy number variation data
- **mutation_gene**: Gene-level mutation data
- **mutation_site**: Site-specific mutation data
- **fusion**: Gene fusion data
- **meth**: DNA methylation data
- **proteinrppa**: Reverse-phase protein array data
- **proteinms**: Mass spectrometry proteomics data

#### Treatment Response
- **drug**: Drug sensitivity/response data
- **drug_dose/viability**: drug sensitivity raw data allows users to recalculate sensitivity metrics (IC50, AUC, AAC) and generate dose-viability plots.

#### Model Systems
- **CellLine**: Cancer cell lines
- **PDO**: Patient-derived organoids
- **PDX**: Patient-derived xenografts
- **PDC**: Patient-derived cells
- **Clinical**: Clinical patients data labeled as `response` or `non-response`, and needs special API to access from CTRDB database currently.

#### Annotation Data
- **sample_anno**: Annotation data for samples, example:

| **SampleID** | **PatientID** | **ProjectID** | **HarmonizedIdentifier** | **TumorType**                  | **MolecularSubtype** | **Gender** | **Age** | **FullEthnicity** | **SimpleEthnicity** | **TNMstage** | **Primary_Metastasis** | **DataType** | **ProjectRawName** | **AlternateName**                                            | **IndexID**    |
| ------------ | ------------- | ------------- | ------------------------ | ------------------------------ | -------------------- | ---------- | ------- | ----------------- | ------------------- | ------------ | ---------------------- | ------------ | ------------------ | ------------------------------------------------------------ | -------------- |
| **CAL12T**   |               | GDSC1         | CVCL_1105                | lung cancer                    |                      | Male       |         |                   |                     |              |                        | CellLine     | CAL-12T            | CAL-12T:\|:Cal-12T:\|:CAL 12T:\|:CAL12T:\|:CAL 12            | UM_SAMPLE_141  |
| **BxPC-3**   |               | gCSI          | CVCL_0186                | pancreatic cancer              |                      | Female     | 61      |                   |                     |              |                        | CellLine     | BxPC-3             | BxPC-3:\|:BxPc-3:\|:BXPC-3:\|:Bx-PC3:\|:BXPC3:\|:BxPC3:\|:BxPc3:\|:Biopsy xenograft of Pancreatic Carcinoma line-3 | UM_SAMPLE_111  |
| **150108**   |               | Tavor         |                          | haematopoietic/lymphoid cancer |                      |            |         |                   |                     |              |                        | PDC          | 150108             |                                                              | UM_SAMPLE_2149 |
| **BICR22**   |               | CTRP2         | CVCL_2310                | aerodigestive tract cancer     |                      | Male       |         | caucasian         | caucasian           |              |                        | CellLine     | BICR 22            | BICR 22:\|:BICR-22:\|:BICR22                                 | UM_SAMPLE_92   |
| **2313287**  |               | CTRP2         | CVCL_1046                | stomach cancer                 |                      | Male       | 72      |                   |                     |              |                        | CellLine     | 2313287            | 23132/87:\|:23132-87:\|:2313287:\|:St 23132:\|:St23132       | UM_SAMPLE_8    |
| **BB49-HNC** |               | GDSC2         | CVCL_1077                | aerodigestive tract cancer     |                      | Female     |         |                   |                     |              |                        | CellLine     | BB49HNC            | BB49-HNC:\|:BB49 HNC:\|:BB49-SCCHN                           | UM_SAMPLE_70   |
| **639-V**    |               | Prism         | CVCL_1048                | bladder cancer                 |                      | Male       | 69      | caucasian         | caucasian           |              |                        | CellLine     | 639V               | 639V:\|:639-V:\|:639 V                                       | UM_SAMPLE_15   |
| **21PT**     |               | GRAY          |                          |                                |                      |            |         |                   |                     |              |                        | CellLine     | 21PT               |                                                              | UM_SAMPLE_2190 |
| **A3KAW**    |               | GDSC2         | CVCL_1062                | haematopoietic/lymphoid cancer |                      | Female     | 68      | japanese          | asian               |              |                        | CellLine     | A3/KAWAKAMI        | A3/Kawakami:\|:A3/KAW:\|:A3-KAW                              | UM_SAMPLE_42   |
| **BICR22**   |               | gCSI          | CVCL_2310                | aerodigestive tract cancer     |                      | Male       |         | caucasian         | caucasian           |              |                        | CellLine     | BICR 22            | BICR 22:\|:BICR-22:\|:BICR22                                 | UM_SAMPLE_92   |


- **drug_anno**: Annotation data for drugs, example:

| **DrugName**         | **ProjectID** | **Harmonized ID (Pubchem ID)** | **Source for Clinical Information** | **Clinical Phase** | **MOA**                                      | **Targets**                                                  | **ProjectRawName** | **IndexID**   |
| -------------------- | ------------- | ------------------------------ | ----------------------------------- | ------------------ | -------------------------------------------- | ------------------------------------------------------------ | ------------------ | ------------- |
| **Bortezomib**       | GDSC1         |                                |                                     |                    | NFkB pathway inhibitor\|proteasome inhibitor | PSMA1\|PSMA2\|PSMA3\|PSMA4\|PSMA5\|PSMA6\|PSMA7\|PSMA8\|PSMB1\|PSMB10\|PSMB11\|PSMB2\|PSMB3\|PSMB4\|PSMB5\|PSMB6\|PSMB7\|PSMB8\|PSMB9\|PSMD1\|PSMD2\|RELA | Bortezomib         | UM_DRUG_42    |
| **Austocystin D**    | CTRP2         |                                |                                     |                    |                                              |                                                              | austocystin D      | UM_DRUG_303   |
| **CYT-997**          | CTRP1         | 11351021                       | Broad DRH                           | Phase 2            | tubulin polymerization inhibitor             | TUBB                                                         | CYT-997            | UM_DRUG_178   |
| **CAY10618**         | CTRP2         |                                |                                     |                    |                                              | NAMPT                                                        | CAY10618           | UM_DRUG_161   |
| **AT-7519**          | LICOB         |                                |                                     |                    | CDK inhibitor                                | CDK1\|CDK2\|CDK4\|CDK5\|CDK6\|CDK9                           | AT-7519            | UM_DRUG_695   |
| **AT7867**           | CTRP2         |                                |                                     |                    | AKT inhibitor                                | AKT2\|GSK3B\|PKIA\|PRKACA                                    | AT7867             | UM_DRUG_422   |
| **CHM-1**            | CTRP2         | 375860                         |                                     |                    |                                              |                                                              | CHM-1              | UM_DRUG_169   |
| **A1874**            | LICOB         |                                |                                     |                    |                                              |                                                              | A1874              | UM_DRUG_56399 |
| **4'-Epiadriamycin** | GRAY          | 41867                          | Broad DRH                           | Launched           | topoisomerase inhibitor                      | TOP2A                                                        | Epirubicin         | UM_DRUG_39    |
| **Abiraterone**      | Prism         |                                |                                     |                    | androgen biosynthesis inhibitor              | CYP11B1\|CYP17A1                                             | abiraterone        | UM_DRUG_606   |


## Example Workflows

The `workflow/` directory contains comprehensive examples and tutorials:

### **Workflow Scripts:**

1. **`01-CreateDROMA.R`** - Basic database creation script
   ```r
   # Simple database creation from all projects
   createDROMADatabase(db_path = "sql_db/droma.sqlite",
                       rda_dir = "data", 
                       projects = NULL)
   ```

2. **`02-UpdateDROMA01.R`** - Database update script for adding new data

3. **`02-UpdateDROMA02.Rmd`** - Comprehensive update workflow with documentation

4. **`03-using_droma_database.R`** - Complete usage examples including:
   - Connecting to database and listing tables
   - Retrieving specific gene expression data (BRCA1 from CCLE/gCSI)
   - Filtering by data type (PDX models only)
   - Filtering by tumor type (breast cancer cell lines)
   - Proper connection management

5. **`README_SQL_DATABASE.md`** - Detailed SQL database functionality guide with:
   - Performance comparison vs traditional loading
   - Advanced usage patterns
   - Best practices and optimization tips

### **Key Example Use Cases:**

```r
# Example 1: Get BRCA1 expression from specific sources
brca1_data <- getFeatureFromDatabase(
  select_feas_type = "mRNA",
  select_feas = "BRCA1",
  data_sources = c("CCLE", "gCSI")
)

# Example 2: Filter by model system
drug_pdx <- getFeatureFromDatabase(
  select_feas_type = "drug",
  select_feas = "Tamoxifen",
  data_type = "PDX"
)

# Example 3: Filter by tumor type
tp53_mutations <- getFeatureFromDatabase(
  select_feas_type = "mutation_gene",
  select_feas = "TP53",
  data_type = "CellLine",
  tumor_type = "breast cancer"
)
```

For detailed examples and best practices, **refer to the `workflow/` directory**.

## File Structure

```
DROMA_DB/
├── data/                    # Input Rda files
│   ├── anno.Rda            # Sample and drug annotations
│   ├── mRNA.Rda            # Gene expression data
│   ├── drug.Rda            # Drug response data
│   ├── cnv.Rda             # Copy number data
│   └── ...
├── function/               # Database creation functions
│   └── function.R          # Main functions
├── workflow/               # ⭐ Example workflows and tutorials
│   ├── 01-CreateDROMA.R    # Database creation script
│   ├── 02-UpdateDROMA01.R  # Database update script
│   ├── 02-UpdateDROMA02.Rmd # Comprehensive update workflow
│   ├── 03-using_droma_database.R # Usage examples
│   └── README_SQL_DATABASE.md # SQL functionality guide
├── sql_db/                 # Output database directory
│   └── droma.sqlite        # Generated SQLite database
└── README.md              # This file
```

## Performance Optimizations

- **Indexed Tables**: All feature tables have indexes on `feature_id` for fast lookups
- **Efficient Storage**: Optimized SQLite schema reduces storage requirements
- **Batch Processing**: Bulk data insertion for improved performance
- **Memory Management**: Streaming data processing for large datasets

## Requirements

- **R**: Version 4.0.0 or higher
- **Required Packages**:
  - `RSQLite` (≥ 2.2.0)
  - `DBI` (≥ 1.1.0)
  - `tools` (base R)

## Citation

Li, S., Peng, Y., Chen, M. et al. Facilitating integrative and personalized oncology omics analysis with UCSCXenaShiny. *Commun Biol* 7, 1200 (2024). https://doi.org/10.1038/s42003-024-06891-2

## Related Projects

- **DROMA_Set Package**: https://github.com/mugpeng/DROMA_Set
- **Data Repository**: https://zenodo.org/records/15742800
- **Documentation**: Refer to `workflow/` directory for detailed examples

## License

This project is licensed under the Mozilla Public License 2.0 - see the [LICENSE](LICENSE) file for details.

## Support

For questions and support:
- Open an issue on GitHub
- Check the workflow examples in `workflow/`
- Review the function documentation in `function/function.R`



## Changelog

### Version 0.4

Documentation and Maintenance:

- **Overhauled `README.md`:** The project now features a comprehensive README with a detailed overview, core features, clear installation instructions, and practical usage examples.
- **Streamlined Workflow:** Removed deprecated preprocessing and database update scripts to simplify project maintenance.
- **Linked Primary Datasource:** Added a direct link to the [Input data for DROMA_DB](https://doi.org/10.5281/zenodo.15055905) on Zenodo for improved transparency and accessibility.

Data and Feature Enhancements:

- **Expanded Project Coverage:** Integrated three new data sources: LICOB (PDOs), HKUPDO (PDOs), and CTRDB (clinical records), significantly broadening the database's scope.
- **Enabled Raw Data Analysis:** Introduced raw drug-dose response data for several projects. This new feature allows users to recalculate sensitivity metrics (IC50, AUC, AAC) and generate dose-viability plots.
- **Standardized Sensitivity Scoring:** Rescaled all drug sensitivity values to a unified 0-1 range where higher values indicate greater sensitivity. This involved converting UMPDO data with a rescaled `1 - IC50` and applying an AAC calculation based on tumor volume for Xeva data, as detailed in its [official vignette](https://bioconductor.org/packages/release/bioc/vignettes/Xeva/inst/doc/Xeva.pdf).



---

**Note**: This database creation tool is designed to work seamlessly with the [DROMA_Set package](https://github.com/mugpeng/DROMA_Set) for comprehensive omics data analysis.

**DROMA_DB** - as the foundation for the broader DROMA ecosystem 🧬💊
