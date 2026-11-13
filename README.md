# NHANES Pulse Predictive Modeling

Statistical analysis of NHANES health data using R, including data screening, feature engineering, descriptive statistics, and exploratory visualizations. Regression modeling and evaluation are planned for later stages.

## Project overview

**Research question:** Which demographic, health, and lifestyle variables are associated with resting pulse rate among U.S. adults, and how well can multiple linear regression predict pulse?

This project uses the 2011–2012 NHANES training dataset to investigate resting pulse rate (beats per minute). The analysis starts with data inspection, missing-value assessment, exploratory visualization, and feature engineering. It then develops and evaluates multiple linear regression models, including an interaction between testosterone and gender, to identify meaningful associations and assess predictive performance.

EDA and regression modeling are combined into **one R Markdown notebook**, with results and limitations summarized here. Findings describe associations, not cause-and-effect relationships.

## 1. Project structure

```text
nhanes-pulse-prediction/
├── README.md
├── NHANES_Pulse_Analysis.Rmd      # Combined EDA + model-building notebook
├── data/
│   └── NHANES-training.csv       # Original training dataset (1,807 rows; 66 columns)
├── scripts/
    └── cross_validation.R       # Reproducible 10-fold model vs. baseline comparison
```

The notebook combines the original EDA and modeling work; the README summarizes the final results.

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
Rscript scripts/cross_validation.R
```

The first command renders the analysis as HTML; the second runs the model-versus-baseline validation. **No absolute file paths are required.**


*Reproducibility note:* The reorganized R notebook has not been executed end-to-end in the packaging environment because R is not installed. The final regression coefficients and model fit statistics were independently checked against the supplied CSV. Package availability and rendering should be verified locally after cloning.

## 4. Dataset

The supplied `NHANES-training.csv` contains **1,807 observations and 66 columns**, drawn from a course-provided 2011–2012 National Health and Nutrition Examination Survey (NHANES) training sample. The outcome is **`Pulse` (beats per minute)**. There are 47 missing Pulse values; the final multiple regression uses **1,523 complete cases** across the selected predictors.

The repository includes the **full training CSV**, not a fabricated or simulated replacement. This is a course-provided subset, so confirm that course rules permit publishing the specific file. Do not treat the unweighted results as population-representative estimates.

## 5. Exploratory data analysis

The exploratory stage investigates numerical and categorical distributions, missingness, candidate relationships with Pulse, unusual observations, and relationships between predictors.

| EDA finding | Observation |
| --- | --- |
| Pulse distribution | Mean **72.62 bpm**, median **72 bpm**; range **40–136 bpm** |
| Strongest numerical marginal correlation among those examined | Age vs. Pulse: **r ≈ −0.189** (weak negative) |
| High missingness | `PhysActiveDays`: **52.7%**; `AlcoholDay`: **33.3%** |
| Derived variable | `SmokeStatus` constructed from `Smoke100` and `SmokeNow` |
| Important predictor overlap | Age and systolic blood pressure (**r ≈ 0.42**); gender and testosterone show markedly different distributions |

Unusual observations were inspected rather than automatically removed. The EDA findings guided model selection.

## 6. Regression modeling

The same `NHANES_Pulse_Analysis.Rmd` notebook develops and diagnoses four models:

1. **Initial multiple regression** containing the most promising EDA candidates and contextual variables.
2. **Reduced additive model** using Age, BMI, diastolic blood pressure, testosterone, and days of poor mental health.
3. **Exploratory high-order interaction model** to study possible interaction effects; not chosen because of its complexity and limited interpretability.
4. **Final interaction model**, adding Gender and a **Testosterone × Gender** interaction to permit different testosterone slopes across groups.

The selected final regression formula is:

```r
Pulse ~ Age + BMI + BPDiaAve + Testosterone * Gender + DaysMentHlthBad
```

The full code provides model summaries, coefficient confidence intervals, and standard residual-diagnostic plots.

## 7. Results and interpretation

### Overall model performance

| Metric | Reported result |
| --- | ---: |
| Final model sample size | **1,523** |
| R² | **0.0975** |
| Adjusted R² | **0.0933** |
| Residual standard error | **10.95 bpm** |
| Cross-validated model MSE | **120.8 bpm²** |
| Cross-validated baseline MSE | **132.3 bpm²** |
| Relative MSE reduction vs. baseline | **~8.7%** |

The multiple regression explains about **9.7% of observed variation in Pulse**. The reported cross-validated prediction error improves on a simple mean-only baseline, but substantial individual variation remains unexplained. The cross-validation results come from the original report; rerunning with different folds may change them slightly.

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

**R · R Markdown · Data cleaning · Missing-data profiling · Exploratory data analysis · Feature engineering · Statistical visualization · Correlation analysis · Multiple linear regression · Model diagnostics · Interaction effects · Confidence intervals · Cross-validation · Technical reporting**

## 9. Data references

- [CDC: National Health and Nutrition Examination Survey (NHANES)](https://www.cdc.gov/nchs/nhanes/)
- [2011–2012 NHANES Demographics Documentation](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2011/DataFiles/DEMO_G.htm)
- [2011–2012 NHANES Blood Pressure Documentation](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2011/DataFiles/BPX_G.htm)
