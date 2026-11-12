# NHANES Pulse Predictive Modeling

Statistical analysis of NHANES health data using R, including data screening, feature engineering, descriptive statistics, and exploratory visualizations. Regression modeling and evaluation are planned for later stages.

## Project overview

**Research question:** Which demographic, health, and lifestyle variables are associated with resting pulse rate among U.S. adults, and how well can multiple linear regression predict pulse?

This project uses the 2011–2012 NHANES training dataset to investigate resting pulse rate (beats per minute). The analysis includes data inspection, missing-value assessment, exploratory visualization, and feature engineering. Multiple regression models examine associations with Pulse using screened variables.

The analysis is organized in **one R Markdown notebook**. Findings describe associations, not cause-and-effect relationships.

## 1. Project structure

```text
nhanes-pulse-prediction/
├── data/
│   └── NHANES-training.csv
├── figures/
├── NHANES_Pulse_Analysis.Rmd
└── README.md
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

The supplied `NHANES-training.csv` contains **1,807 observations and 66 columns**, drawn from a course-provided 2011–2012 National Health and Nutrition Examination Survey (NHANES) training sample. The outcome is **`Pulse` (beats per minute)**. There are 47 missing Pulse values; model-specific complete cases depend on the selected predictors.

The repository includes the **full training CSV**, not a fabricated or simulated replacement. This is a course-provided subset, so confirm that course rules permit publishing the specific file. Do not treat the unweighted results as population-representative estimates.

## 5. Exploratory data analysis

The exploratory stage investigates numerical and categorical distributions, missingness, candidate relationships with Pulse, unusual observations, and relationships between predictors.

| EDA finding | Observation |
| --- | --- |
| High missingness | `PhysActiveDays`: **52.7%**; `AlcoholDay`: **33.3%** |
| Derived variable | `SmokeStatus` constructed from `Smoke100` and `SmokeNow` |
| Pulse distribution | Mean **72.62 bpm**, median **72 bpm**; range **40–136 bpm** |
| Categorical distributions | Gender, race, education, health, and lifestyle categories examined with frequency tables and bar charts |
| Numerical relationship | Age vs. Pulse: **r ≈ −0.189** (weak negative) |
| Group comparisons | Pulse compared across demographic, health, and lifestyle categories |
| Predictor overlap | Age and systolic blood pressure (**r ≈ 0.42**); gender and testosterone distributions differ substantially |
| Complete-case EDA shortlist | **1,439** observations with Pulse and all 13 shortlisted predictors recorded |

The age and blood-pressure comparisons are also shown in `figures/figure_1.png`.

The gender–testosterone distributions and within-group trends are also shown in `figures/figure_2.png`.

Unusual observations were inspected rather than automatically removed. The EDA findings guided selection of 13 candidate predictors for modeling.

## 6. Regression modeling

The same `NHANES_Pulse_Analysis.Rmd` notebook develops and diagnoses four models:

1. **Initial multiple regression** containing the most promising EDA candidates and contextual variables.
2. **Reduced additive model** using Age, BMI, diastolic blood pressure, testosterone, and days of poor mental health.
3. **Exploratory high-order interaction model** to study possible interaction effects; not chosen because of its complexity and limited interpretability.
4. **Final interaction model**, adding Gender and a **Testosterone × Gender** interaction to permit different testosterone slopes across groups.

The selected regression formula is:

```r
Pulse ~ Age + BMI + BPDiaAve + Testosterone * Gender + DaysMentHlthBad
```

Model summaries, coefficient confidence intervals, and standard residual-diagnostic plots are included in the notebook.

## 7. Results and interpretation

### Overall model performance

| Metric | Reported result |
| --- | ---: |
| Final model sample size | **1,523** |
| R² | **0.0975** |
| Adjusted R² | **0.0933** |
| Residual standard error | **10.95 bpm** |

The fitted interaction model explains about **9.7% of observed variation in Pulse**. Predictive validation is not included in this version.

### Final regression estimates

| Predictor | Coefficient | 95% confidence interval | p-value |
| --- | ---: | ---: | ---: |
| Age (years) | −0.1088 | (−0.1416, −0.0760) | <0.001 |
| BMI (kg/m²) | +0.1056 | (+0.0178, +0.1933) | 0.018 |
| Diastolic blood pressure (mmHg) | +0.1354 | (+0.0881, +0.1828) | <0.001 |
| Days of poor mental health | +0.1382 | (+0.0661, +0.2102) | <0.001 |
| Testosterone (ng/dL; reference gender) | +0.0952 | (+0.0550, +0.1354) | <0.001 |
| Male indicator | +3.2376 | (+0.9295, +5.5457) | 0.006 |
| Testosterone × male | −0.1033 | (−0.1438, −0.0629) | <0.001 |

The intercept is approximately **63.60 bpm**, but its literal interpretation is not meaningful because it assumes impossible or unrealistic zeros for several predictors. Because the model has an interaction, **the testosterone coefficient is the fitted slope among women (reference group)**, while the estimated slope among men is approximately `0.0952 − 0.1033 = −0.0081` bpm per ng/dL. The male indicator alone compares groups at testosterone equal to zero and should not be treated as a typical gender difference.

### Findings in context

- **Age:** Holding other modeled variables constant, an additional 10 years is associated with approximately **1.1 bpm lower** predicted Pulse.
- **Diastolic blood pressure:** An additional 10 mmHg is associated with approximately **1.4 bpm higher** predicted Pulse.
- **BMI:** An additional 5 kg/m² corresponds to approximately **0.5 bpm higher** predicted Pulse.
- **Days of poor mental health:** Ten additional reported days in the preceding month correspond to approximately **1.4 bpm higher** predicted Pulse.
- **Testosterone × gender:** The fitted testosterone–Pulse association differs in direction between the two reference groups, supporting the decision to test an interaction. Because the typical testosterone ranges differ widely by group, slopes should be interpreted within observed ranges, not extrapolated.

### Limits and responsible interpretation

This is an observational analysis; estimated effects are **associations rather than causal relationships**. Complete-case analysis excludes records with missing predictors. Survey weights and design-based variance methods were not applied. The model explains relatively little individual variation and **must not be used for clinical or individual health decisions**.

## 8. Skills and tools demonstrated

**R · R Markdown · Exploratory data analysis · Multiple linear regression · Interaction effects · Model diagnostics · Confidence intervals · Technical reporting**

## 9. Data references

- [CDC: National Health and Nutrition Examination Survey (NHANES)](https://www.cdc.gov/nchs/nhanes/)
- [2011–2012 NHANES Demographics Documentation](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2011/DataFiles/DEMO_G.htm)
- [2011–2012 NHANES Blood Pressure Documentation](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2011/DataFiles/BPX_G.htm)
