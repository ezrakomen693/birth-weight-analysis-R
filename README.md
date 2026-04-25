# Birth Weight Risk Factor Analysis in R
## A Biostatistical Investigation Using Logistic & Multiple Regression

**Author:** Ezra Komen Kipyegon  
**Tools:** R 4.5.3 | MASS | ggplot2  
**Dataset:** birthwt (MASS package) | n = 189 mothers

---

## Objective
To identify maternal risk factors associated with low infant 
birth weight (<2,500g) using multiple linear regression, 
logistic regression, and interaction analysis.

---

## Methods
- Descriptive statistics and factor encoding
- Multiple linear regression (bwt ~ lwt + smoke + race + 
  age + ht + ui + ptl)
- Model diagnostics: residual plots, Cook's distance, 
  sensitivity analysis
- Logistic regression predicting low birthweight (binary)
- Odds ratios with 95% confidence intervals
- Interaction analysis: smoking × race
- Model selection via AIC comparison
- Visualizations: forest plot, grouped boxplots (ggplot2)

---

## Key Findings

| Risk Factor | Odds Ratio | 95% CI | Significance |
|---|---|---|---|
| Hypertension | 6.26 | 1.67 – 26.52 | ** |
| Black race | 3.54 | 1.26 – 10.13 | * |
| Smoking | 2.52 | 1.16 – 5.65 | * |
| Other race | 2.37 | 1.01 – 5.72 | * |
| Maternal weight | 0.985 | 0.97 – 0.998 | * |

- Smoking reduced mean birth weight by **351g** after 
  controlling for all confounders
- No significant smoking × race interaction was found 
  (AIC favoured simpler model: 219.43 vs 221.08)
- Sensitivity analysis confirmed smoking and hypertension 
  effects were robust to influential observations

---

## Visualizations
- Forest plot of odds ratios with 95% CIs
- Grouped boxplots: birth weight by race and smoking status
- Regression diagnostics: Cook's distance plot

---

## Files
- `birthweight_analysis.R` — full reproducible script
- `forest_plot_OR.png` — odds ratio forest plot
- `birthweight_race_smoking.png` — grouped boxplot


