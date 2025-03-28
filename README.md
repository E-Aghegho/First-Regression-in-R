# Crime Rate Prediction Using Regression

## An Overview
This project explores the application of multiple regression models to predict crime rates in U.S. cities using data from [US Crime Data](http://www.statsci.org/data/general/uscrime.html). The dataset consists of 47 observations with 15 predictors and the response variable being the crime rate.

---

## Exploratory Data Analysis (EDA)
Before developing the regression model, an initial review of the data was conducted to identify significant predictors.

### Key Predictors Considered:
- **M**: Percentage of males aged 14–24 in the state population.
- **Ed**: Average years of schooling.
- **U1, U2**: Unemployment rates for different age groups.
- **Ineq**: Income inequality.
- **Prob**: Probability of imprisonment after committing a crime.
- **Po1, Po2**: Per capita expenditure on police protection.
- **Wealth**: Median value of transferable assets or family income.

---

## Regression Model
### Model Summary
A multiple linear regression model was fit using all predictors.
```r
lm_uscrime <- lm(Crime ~ ., data = uscrime)
summary(lm_uscrime)
```
#### Output:
```
Call:
lm(formula = Crime ~ ., data = uscrime)

Residuals:
   Min     1Q Median    3Q   Max
-395.74 -98.09  -6.69 112.99 512.67

Coefficients:
              Estimate Std. Error t value Pr(>|t|)
(Intercept) -5984.50   1628.00  -3.675  0.0009 ***
M             87.83      41.71   2.106  0.0434 *
Ed           188.30      62.09   3.033  0.0049 **
Po1          192.80     106.10   1.817  0.0788 .
U2           167.80      82.34   2.038  0.0502 .
Ineq          70.67      22.72   3.111  0.0040 **
Prob       -4855.00    2272.00  -2.137  0.0406 *
```
**Model Fit:**
- **Multiple R-squared:** 0.8031
- **Adjusted R-squared:** 0.7078
- **F-statistic:** 8.429 (p-value: 3.539e-07)

### Interpretation
- **Education (Ed)** and **Income Inequality (Ineq)** were significant predictors, aligning with expectations.
- **Probability of Imprisonment (Prob)** had a negative coefficient, indicating that a higher likelihood of imprisonment correlates with lower crime rates.
- **Male Population (M)** and **Unemployment (U2)** also contributed to predicting crime.

---

## Model Assumptions & Diagnostics
### **Homoscedasticity Check**
To ensure the variance in residuals remains constant:
```r
library(lmtest)
bptest(lm_uscrime)
```
**Breusch-Pagan Test Result:** p-value = 0.2388 → **Data is homoscedastic** ✅

### **Normality of Residuals (QQ Plot)**
```r
qqnorm(residuals(lm_uscrime))
qqline(residuals(lm_uscrime), col = "blue")
```
- Residuals appear **mostly normal**, though some extreme values deviate from the line.
- **Potential mild non-normality.**

### **Cross-Validation**
To check for overfitting:
```r
library(DAAG)
set.seed(2)
lm_uscrime_cv <- cv.lm(uscrime, lm_uscrime, m = 5)
```
**Cross-validated R-squared:** 0.4321 → **Possible overfitting detected** 🔍

---

## Prediction for a New City
Using the given city data:
```r
city <- data.frame(M = 14.0, So = 0, Ed = 10.0, Po1 = 12.0, Po2 = 15.5,
                   LF = 0.640, M.F = 94.0, Pop = 150, NW = 1.1, 
                   U1 = 0.120, U2 = 3.6, Wealth = 3200, Ineq = 20.1,
                   Prob = 0.04, Time = 39.0)

pred_model <- predict(lm_uscrime, city)
print(pred_model)
```
**Predicted Crime Rate:** **155.43 crimes per 100,000 population**

---

## Improved Model
A refined model was built by removing predictors with **p > 0.5**:
```r
lm_uscrime_new <- lm(Crime ~ M + Ed + Po1 + U2 + Ineq + Prob, data = uscrime)
summary(lm_uscrime_new)
```
**Adjusted Model Fit:**
- Adjusted R-squared **0.7307** (slightly lower)
- Some **outliers remain**, affecting the model’s robustness.

### **Final Observations**
- Removing non-significant predictors led to a **more interpretable model** but did not greatly improve accuracy.
- **Cross-validation suggests mild overfitting.**
- **Education, unemployment, inequality, and imprisonment probability are strong crime predictors.**

---

## Conclusions
- The regression model reasonably explains **crime rate variability** but may **overfit due to small dataset size**.
- Predictors **Ed, Ineq, and Prob** significantly affect crime rates.
- Future work should explore **regularization techniques (e.g., LASSO, Ridge Regression)** to improve generalization.
- Files are in the repository for futher inspection.

### **Next Steps:**
- Use **ridge/lasso regression** to reduce overfitting.
- **Increase dataset size** or perform feature engineering.
- Apply **robust regression** to mitigate outliers' impact.

---

## References
- [US Crime Data](http://www.statsci.org/data/general/uscrime.html)
- [Breusch-Pagan Test Explanation](https://boostedml.com/2019/03/linear-regression-plots-scale-location-plot.html)
- [Cross-Validation in R](https://stats.stackexchange.com/questions/58141/interpreting-plot-lm)
