# DROMA Database Manager

Convert Rda data into sqlite for DROMA.

The data is in:

includes:
| **project_name** | **dataset_type** | **data_types**                                               | **sample_count** | **drug_count** |
| ---------------- | ---------------- | ------------------------------------------------------------ | ---------------- | -------------- |
| **CCLE**         | CellLine         | cnv,drug,fusion,mRNA,meth,mutation_gene,mutation_site,proteinms,proteinrppa | 1489             | 24             |
| **CTRP1**        | CellLine         | drug                                                         | 241              | 354            |
| **CTRP2**        | CellLine         | drug                                                         | 832              | 481            |
| **FIMM**         | CellLine         | drug                                                         | 50               | 52             |
| **GDSC1**        | CellLine         | drug                                                         | 988              | 304            |
| **GDSC2**        | CellLine         | drug                                                         | 810              | 169            |
| **GDSC**         | CellLine         | cnv,mRNA,mutation_gene,mutation_site                         | 1024             | 0              |
| **GRAY**         | CellLine         | drug                                                         | 71               | 106            |
| **NCI60**        | CellLine         | drug,mRNA                                                    | 162              | 54773          |
| **PDTXBreast**   | PDC              | drug                                                         | 37               | 98             |
| **Prism**        | CellLine         | drug                                                         | 480              | 1448           |
| **Tavor**        | PDC              | drug,mRNA                                                    | 53               | 46             |
| **UHNBreast**    | CellLine         | drug                                                         | 57               | 8              |
| **UMPDO1**       | PDO              | drug,mRNA                                                    | 112              | 49             |
| **UMPDO2**       | PDO              | drug,mRNA                                                    | 39               | 49             |
| **UMPDO3**       | PDO              | drug,mRNA                                                    | 42               | 48             |
| **Xeva**         | PDX              | cnv,drug,mRNA,mutation_gene                                  | 268              | 38             |
| **gCSI**         | CellLine         | cnv,drug,mutation_gene                                       | 581              | 44             |

For detail usages refer `workflow/`.

## Citation

Li, S., Peng, Y., Chen, M. et al. Facilitating integrative and personalized oncology omics analysis with UCSCXenaShiny. Commun Biol 7, 1200 (2024). https://doi.org/10.1038/s42003-024-06891-2


## Overview
DROMA (Drug Response Omics Multi-Analysis) is an R package that provides a unified interface for accessing and analyzing multi-omics data related to drug responses across different model systems. This project converts diverse omics datasets into a structured SQLite database with a project-oriented architecture, facilitating efficient data retrieval and analysis.

## Features
- **Project-Oriented Structure**: Organizes data by projects, making it easy to work with specific datasets
- **Multi-Omics Data Support**: Handles various data types:
  - Genomic data (mRNA, CNV, methylation, mutations, fusions)
  - Proteomic data
  - Drug response data
- **Model System Coverage**: Supports different model systems:
  - Cell lines
  - Patient-derived organoids (PDO)
  - Patient-derived xenografts (PDX)
  - Patient-derived cells (PDC)
- **Efficient Data Retrieval**: SQL-based querying for fast and flexible data access
- **Metadata Management**: Maintains annotations for samples and drugs

## Installation

```r
# Install required dependencies
install.packages(c("RSQLite", "DBI"))

# For development version from GitHub (if available)
# install.packages("devtools")
# devtools::install_github("username/DROMA")
```

## Getting Started

### Creating the Database
Convert your DROMA data files to a SQLite database:

```r
# Create a SQLite database from data files
createDROMADatabase(db_path = "path/to/droma.sqlite", 
                    rda_dir = "path/to/data",
                    projects = NULL) # NULL includes all projects
```

### Connecting to the Database
```r
# Connect to an existing DROMA database
con <- connectDROMADatabase("path/to/droma.sqlite")
```

### Exploring Available Data
```r
# List all projects in the database
projects <- listDROMARojects()

# List all tables in the database
tables <- listDROMADatabaseTables()

# List tables matching a pattern
drug_tables <- listDROMADatabaseTables(pattern = "_drug$")
```

### Retrieving Data
```r
# Get data for a specific feature across data sources
# Example: retrieve EGFR mRNA expression data
egfr_data <- getFeatureFromDatabase(
  select_feas_type = "mRNA",
  select_feas = "EGFR", 
  data_sources = c("ccle", "gdsc"),
  data_type = "CellLine",
  tumor_type = "all"
)
```

### Closing the Connection
```r
# Close the database connection when done
closeDROMADatabase()
```

## Database Structure
The DROMA database organizes data in the following structure:
- **Project tables**: Named as `{project_name}_{data_type}` (e.g., `ccle_mRNA`, `gdsc_drug`)
- **Annotation tables**: `sample_anno` and `drug_anno`
- **Metadata table**: `projects` contains information about each project

The `projects` table includes:
- Project name
- Dataset type (e.g., CellLine, PDO)
- Available data types
- Sample count
- Drug count

## Data Types
DROMA supports multiple data types:
- `mRNA`: Gene expression data
- `cnv`: Copy number variation data
- `meth`: Methylation data 
- `mut`: Mutation data
- `fusion`: Gene fusion data
- `protein`: Protein expression data
- `drug`: Drug response data

## Requirements
- R 3.5.0 or higher
- RSQLite package
- DBI package
