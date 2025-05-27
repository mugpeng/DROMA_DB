# DROMA SQL Database Functionality

This document explains how to use the SQL database functionality in the DROMA package, which provides significant memory and performance improvements when working with large omics datasets.

## Why Use a SQL Database?

The DROMA package includes large pre-loaded datasets (such as `mRNA.Rda`, `drug.Rda`, etc.) that can consume substantial memory when loaded into R. Using a SQL database approach offers several advantages:

1. **Reduced Memory Usage**: Only load the specific data you need instead of entire datasets
2. **Faster Query Performance**: Efficient SQL queries with indexing for faster data retrieval
3. **Selective Data Loading**: Access only specific datasets (e.g., just CCLE data) without loading everything
4. **Better Scalability**: Handle larger datasets more efficiently as your data grows

## Quick Start

```r
library(DROMA.Set)

# First time only: Create the database from .Rda files
createDROMADatabase()

# Connect to the database
connectDROMADatabase()

# Get BRCA1 expression data from specific sources
brca1_data <- getFeatureFromDatabase(
  select_feas_type = "mRNA", 
  select_feas = "BRCA1",
  data_sources = c("ccle", "gdsc")
)

# Close connection when done
closeDROMADatabase()
```

## Core Functions

### Setup and Connection

- `createDROMADatabase(db_path = "~/droma.sqlite")`: Creates a SQLite database from DROMA data files (only needed once)
- `connectDROMADatabase(db_path = "~/droma.sqlite")`: Establishes a connection to the database
- `closeDROMADatabase()`: Closes the database connection when finished

### Data Retrieval

- `getFeatureFromDatabase(select_feas_type, select_feas, data_sources = "all", data_type = "all", tumor_type = "all")`: 
  Retrieves specific data features with flexible filtering options
  
### Information and Management

- `listDROMADatabaseTables(pattern = NULL)`: Lists available tables in the database, optionally filtered by pattern

## Example Workflows

### Example 1: Basic Data Retrieval

```r
# Connect to database
connectDROMADatabase()

# Get TP53 mutation data
tp53_mutations <- getFeatureFromDatabase("mutation_gene", "TP53")

# Close connection
closeDROMADatabase()
```

### Example 2: Targeted Retrieval with Filtering

```r
connectDROMADatabase()

# Get drug response data only from breast cancer PDX models
tamoxifen_data <- getFeatureFromDatabase(
  select_feas_type = "drug",
  select_feas = "Tamoxifen",
  data_type = "PDX",
  tumor_type = "breast cancer"
)

closeDROMADatabase()
```

### Example 3: Selecting Specific Data Sources

```r
connectDROMADatabase()

# Get BRCA1 expression, but only from cell line datasets
brca1_cell_lines <- getFeatureFromDatabase(
  select_feas_type = "mRNA",
  select_feas = "BRCA1",
  data_sources = c("ccle", "gdsc", "NCI60")
)

closeDROMADatabase()
```

## Comparison with Traditional Loading

| Feature | Traditional Loading | SQL Database Approach |
|---------|---------------------|------------------------|
| Memory Usage | High (loads entire datasets) | Low (loads only needed data) |
| Startup Time | Slow (loads all data at once) | Fast (connects to database only) |
| Query Speed | Moderate (in-memory filtering) | Fast (database-level filtering) |
| Selective Loading | Limited (loads entire files) | Full control (select specific sources) |

## Requirements

The SQL database functionality requires the following R packages:
- RSQLite
- DBI

These are installed automatically when you install the DROMA package.

## Advanced Usage

### Custom Database Path

```r
# Create database in a custom location
createDROMADatabase("/path/to/my/database.sqlite")

# Connect to the custom database
connectDROMADatabase("/path/to/my/database.sqlite")
```

### Working with Multiple Connections

```r
# Explicitly manage connections
con1 <- connectDROMADatabase("/path/to/database1.sqlite")
con2 <- connectDROMADatabase("/path/to/database2.sqlite")

# Use specific connection for queries
data1 <- getFeatureFromDatabase("mRNA", "BRCA1", connection = con1)
data2 <- getFeatureFromDatabase("mRNA", "BRCA1", connection = con2)

# Close specific connections
closeDROMADatabase(con1)
closeDROMADatabase(con2)
```

## Performance Tips

1. Create appropriate indices for frequently queried columns
2. Limit the data requested to only what you need
3. Use the `data_sources` parameter to limit queries to specific datasets
4. Keep the database connection open during analysis sessions, only closing when finished 
