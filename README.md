# NHANES-pulse-predictive-modeling
Statistical analysis of NHANES health data using R, featuring exploratory data analysis, feature engineering, multiple linear regression, interaction effects, and model evaluation.

## Project overview

**Research question:** Which demographic, health, and lifestyle variables are associated with resting pulse rate among U.S. adults, and how well can multiple linear regression predict pulse?

This project uses the 2011–2012 NHANES training dataset to investigate resting pulse rate (beats per minute). The analysis includes data inspection, missing-value assessment, exploratory visualization, and feature engineering.

The analysis is organized in **one R Markdown notebook**. Findings describe associations, not cause-and-effect relationships.

## 1. Project structure

```text
nhanes-pulse-prediction/
├── data/
    └── NHANES-training.csv       # Original training dataset (1,807 rows; 66 columns)
├── NHANES_Pulse_Analysis.Rmd      # Exploratory analysis notebook
├── README.md      # project overview, methodology, and usage instructions
```

The notebook contains the analysis and figures documented in this README.

## 2. Prerequisites

- **R 4.1 or newer** (the modeling code uses R’s native `|>` pipe) and **RStudio** (recommended, optional)
- R packages: `rmarkdown`, `knitr`, `mosaic`, `ggformula`, and `dplyr`
- **Pandoc** (included with RStudio; required for HTML knitting)
- The included training dataset at `data/NHANES-training.csv`

Install the R packages in R or the RStudio console:

```r
install.packages(c("rmarkdown", "knitr", "mosaic", "ggformula", "dplyr"))
```

## 3. How to run the project

**Option A — RStudio:**

1. Download or clone this repository and open the folder in RStudio.
2. Open `NHANES_Pulse_Analysis.Rmd`.
3. Use the **Knit** menu and select **Knit to HTML**. All analysis sections run from the top, in order.

**Option B — Terminal:**

Run the following commands **from the repository root**:

```bash
Rscript -e 'rmarkdown::render("NHANES_Pulse_Analysis.Rmd")'
```

The command renders the analysis as HTML. **No absolute file paths are required.**

## 4. Dataset

The supplied `NHANES-training.csv` contains **1,807 observations and 66 columns**, drawn from a course-provided 2011–2012 National Health and Nutrition Examination Survey (NHANES) training sample. The outcome is **`Pulse` (beats per minute)**. There are 47 missing Pulse values.

The repository includes the **full training CSV**, not a fabricated or simulated replacement. This is a course-provided subset, so confirm that course rules permit publishing the specific file. Do not treat the unweighted results as population-representative estimates.

## 5. Exploratory data analysis

The exploratory stage investigates numerical and categorical distributions, missingness, candidate relationships with Pulse, unusual observations, and relationships between predictors.

| EDA finding | Observation |
| --- | --- |
| High missingness | `PhysActiveDays`: **52.7%**; `AlcoholDay`: **33.3%** |
| Derived variable | `SmokeStatus` constructed from `Smoke100` and `SmokeNow` |

The initial screening documents data quality and recoding decisions before visualization and modeling.

## 6. Regression modeling

Variable screening and exploratory comparisons provide the basis for regression modeling. Model estimates are not included in this version.

## 7. Results and interpretation

Missing values are concentrated in some lifestyle measures, while `SmokeStatus` provides a combined categorical smoking measure. These observations support later predictor screening.

These are descriptive associations, not causal effects or individual predictions.

## 8. Skills and tools demonstrated

**R · R Markdown · Data inspection · Missing-data profiling · Variable screening · Feature engineering**

## 9. Data references

- [CDC: National Health and Nutrition Examination Survey (NHANES)](https://www.cdc.gov/nchs/nhanes/)
- [2011–2012 NHANES Demographics Documentation](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2011/DataFiles/DEMO_G.htm)
- [2011–2012 NHANES Blood Pressure Documentation](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2011/DataFiles/BPX_G.htm)
