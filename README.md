# DROMA-DB: Drug Response Omics Association Map, Database

<div class="row">   
    <div class="column" style="float:left;width:75%"> 
     	   DROMA-DB is a comprehensive database and analysis tool that integrates the largest published studies investigating cancer response to chemical compounds and the associations between drug sensitivity and multi-omics data (mRNA, CNV, protein, mutation, etc.) across various cancer models including PDC (Patient-Derived Cells), PDO (Patient-Derived Organoids), and PDX, human data are under development.
    </div>
    <div class="column" style="float:left;width:25%">    
        <img src="http://cos01.mugpeng.top/img/20250310150357.png">  
    </div> 
</div>











deng1-3 are our in house pdo data, others are all pcd data.

<img src="http://cos01.mugpeng.top/img/20250310150259.png" style="zoom:50%;" />



## Citation

If you use DROMA-DB in your research, please cite:

Li, S., Peng, Y., Chen, M. et al. Facilitating integrative and personalized oncology omics analysis with UCSCXenaShiny. Commun Biol 7, 1200 (2024). https://doi.org/10.1038/s42003-024-06891-2

## Features

DROMA-DB offers a range of powerful features for cancer pharmacogenomics research:

1. **Comprehensive Data Integration**: Includes high-throughput cancer type PDO, PDC, PDX data associated between drug sensitivity and multi-omics, as well as in-house data.

2. **Drug-Omics Pairs Analysis**: Explore associations between specific drug responses and omics features with statistical rigor.

3. **Batch Features Associations Analysis**: Conduct large-scale analysis of associations between a target feature and all features in a dataset.

4. **Filtering Capabilities**: Filter analyses by data type (cell lines or PDO) and tumor type for more targeted research.

5. **Statistical Visualization**: View meta-analysis forest plots, volcano plots, and other visualizations to understand relationships.

6. **Data Export**: Download results in various formats (PDF, CSV, R objects) for further analysis.



## Statistics Information

This section provides overview statistics about the database:

- Drug and sample counts by source
- Data type counts (cell lines vs PDO)
- Molecular characteristics available in each dataset
- Drug and sample overlap between datasets
- Tumor type distribution
- Drug mechanism of action visualization

![](http://cos01.mugpeng.top/img/20250310150835.png)

A. Drug and sample distribution within the dataset. A total of 2,065 drugs and 1,815 samples are represented in the dataset, with cell lines (2,065 drugs) being more extensively tested than patient-derived organoids (PDO, 78 drugs tested). For type of resource, PRISM shows the highest number of drugs, while GDSC2 contains the most cell lines.
B. Molecular characterization coverage across dataset types. Multiple omics data types, such as whole-exome sequencing, RNA-Seq, and proteomics, are available for different systems, with variation observed across DEG and PDO datasets. Gene fusion data are limited to specific subsets.
C. Mechanisms of action (MOA) for drugs tested in the dataset. The dataset comprises diverse drug classes, encompassing EGFR inhibitors (69 drugs), VEGFR inhibitors (70 drugs), PI3K inhibitors (51 drugs), and CDK inhibitors (24 drugs), among others. Targeted therapies dominate the collection.
D. Tumor type distribution across organ systems. Tumor systems represented include lung (1373), blood/lymphatic (1028 samples), gastrointestinal (669 samples), breast (513 samples), and other tumors. The sizes of the bubbles correlate with the number of samples per tumor system.



## Use DROMA-DB shiny

Web application can only be accessed in UM campus: http://fscpo.fhs.um.edu.mo:8888/DROMA_DB/



## Local deployment

### Prerequisites

- R (>= 4.0.0)
- RStudio (recommended for ease of use)

### Required R Packages

```r
# Core packages
install.packages(c("shiny", "shinyWidgets", "shinyjs", "waiter", "DT", "config"))

# Data manipulation
install.packages(c("dplyr", "data.table"))

# Meta analysis
install.packages(c("meta", "metafor", "effsize"))

# Visualization
install.packages(c("UpSetR", "ggpubr", "plotly", "patchwork"))

# Parallel processing
install.packages(c("snowfall", "parallel"))
```

### Setup

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/DROMA-DB.git
   ```

2. Open the project in RStudio by clicking on the `Project.Rproj` file.

3. Run the application:
   ```r
   source("App.R")
   ```

## Usage

DROMA-DB consists of three main sections:

### 1. Drugs-Omics Pairs Analysis

This module allows you to explore the association between a selected drug resistance event and a specific omic feature:

- Select a molecular type (mRNA, CNV, mutation, etc.)
- Choose a specific molecular feature
- Select a drug of interest
- Filter by data type (cell lines or PDO) and tumor type
- View statistical results and visualizations

For continuous omics data (mRNA, methylation, CNV, protein), Spearman correlation is calculated. For discrete omics data (mutations, fusions), Wilcoxon tests are used.

![Drugs-Omics Pairs Analysis](http://cos01.mugpeng.top/img/20250121101140.png)

### 2. Batch Features Associations Analysis

This module helps you conduct significant tests between a targeted feature (a drug or an omic) and all features in a particular dataset:

- Select a feature type and specific feature
- Choose a second feature type to compare against
- Filter by data type and tumor type
- View results as a volcano plot
- Download results for further analysis

![](http://cos01.mugpeng.top/img/20250310150740.png)

A. Volcano plot showing associations between Bortezomib and mRNA expression. The x-axis represents effect size (strength and direction of association), while the y-axis shows statistical significance (-log10 p-value). Red points indicate significant positive associations (effect size > 0.2, p < 0.001), suggesting resistance markers; blue points show significant negative associations, suggesting sensitivity markers. The effect size is calculated from meta analysis which each feature pairs use different statistic method depends on data type: 1) For continuous vs. continuous features (e.g., drug vs. mRNA): Pearson correlation; 2) For discrete vs. continuous features (e.g., mutation vs. drug), Wilcoxon test; 3) For discrete vs. discrete features (e.g., mutation vs. fusion): Chi-squared test. PSMB5 may server as a potential Bortezomib resistance gene from screen.
B. All results are downloadable in various formats (PDF, CSV, R objects) for further analysis.
C. A popup window can remind user the completion of analysis.



## Project Structure

- **App.R**: Main application file
- **Modules/**: Contains UI and server components for different application sections
  - **DrugOmicPair.R**: Drug-omics pairs analysis module
  - **BatchFeature.R**: Batch features analysis module
  - **StatAnno.R**: Statistics and annotations module
  - **LoadData.R**: Data loading module
  - **Preprocess.R**: Data preprocessing module
- **Package_Function/**: Contains core functionality
  - **FuncGetData.R**: Data retrieval functions
  - **FuncDrugOmicPair.R**: Drug-omics pair analysis functions
  - **FuncBatchFeature.R**: Batch feature analysis functions
- **Input/**: Contains data files
- **config.yml**: Configuration settings



## Data Sources

DROMA-DB integrates data from multiple sources:

- **Cell Line Data**: CCLE, GDSC, gCSI, CTRP1, CTRP2, PRISM
- **Patient-Derived Organoid (PDO) Data**: In-house and published datasets
- **Annotation Data**: Comprehensive annotations for samples and drugs



## Contact

Feel free to contact us if you find any bugs or have any suggestions:

- Email: mugpeng@foxmail.com, mugpeng@outlook.com, yc47680@um.edu.mo
- GitHub: https://github.com/mugpeng



## License

This project is licensed under the MIT License - see the LICENSE file for details.



# TODO

## Major

- [x] Add PDO drug and rna
- [ ] Reonline
- [ ] Add PDO WES
- [ ] change to z-score 
- [ ] add chemical structure info



## Minor

- [ ] Add compare methods
- [ ] Add drug annotation for drug screen in batch mode
- [ ] 
