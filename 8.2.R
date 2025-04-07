#Q8.2

rm(list = ls())

uscrime <- read.table("uscrime.txt", stringsAsFactors = FALSE, header = TRUE)

lm_uscrime <- lm(Crime~., data = uscrime)

lm_uscrime
summary(lm_uscrime)


# Calculate the fitted values and residuals
fitted_values <- lm_uscrime$fitted.values
residuals <- lm_uscrime$residuals

# Standardise the residuals
standardised_residuals <- rstandard(lm_uscrime)

#all plots
plot(lm_uscrime)

# Create the plot of fitted values vs residuals
plot(fitted_values, residuals,
     xlab = "Fitted Values",
     ylab = "Residuals",
     main = "Residuals vs Fitted Values")
abline(h = 0, col = "red")


# Create the plot of standardised residuals vs fitted values
plot(fitted_values, standardised_residuals,
     xlab = "Fitted Values",
     ylab = "Standardised Residuals",
     main = "Standardised Residuals vs Fitted Values")
abline(h = 0, col = "green")


# Calculate the square root of the absolute standardised residuals
sqrt_standardised_residuals <- sqrt(abs(standardised_residuals))

# Create the scale-location plot
#decided against doing my own line for this one so I used the plot in the all plots code
plot(fitted_values, sqrt_standardised_residuals,
     xlab = "Fitted Values",
     ylab = "Square Root of Standardised Residuals",
     main = "Scale-Location Plot")
abline(h = 0, col = "purple")

#Breusch Pagan Test 
install.packages("lmtest")
library(lmtest)
bptest(lm_uscrime)

#QQ plot
qqnorm(standardised_residuals,main = "Q-Q Plot of Standardised Residuals vs Theoretical Quantities",
       ylab = "Standardised residuals")
qqline(standardised_residuals, col = "blue")


#test the point given
city <- data.frame(M = 14.0, So = 0, Ed = 10.0, Po1 = 12.0, Po2 = 15.5, 
                   LF = 0.640, M.F = 94.0, Pop = 150, NW = 1.1, U1 = 0.120, 
                   U2 = 3.6, Wealth = 3200, Ineq = 20.1, Prob = 0.04, 
                   Time = 39.0)

pred_model <- predict(lm_uscrime, city)
pred_model

#cross validation
#install.packages("DAAG")
#library(DAAG)
#Perform ?-fold validation CV with the linear model that was created earlier
set.seed(2)
lm_uscrime_cv <- cv.lm(uscrime, lm_uscrime, m=5)

# Calculate the variance of the observed values
variance_observed <- var(uscrime$Crime)

# Calculate the R-squared value for the cross-validated model
r_squared_cv <- 1 - (84948.87 / variance_observed)
r_squared_cv

#removed predictors
lm_uscrime_new <- lm(Crime ~ M + Ed + Po1 + U2 + Ineq + Prob, data = uscrime)
summary(lm_uscrime_new)

plot(lm_uscrime_new)

#--------------------------------------------------------------------------------------------------

# Scale the predictor variables
uscrime_scaled <- as.data.frame(scale(uscrime[, -ncol(uscrime)]))
uscrime_scaled$Crime <- uscrime$Crime

# Fit the new linear regression model without predictors with p-value > 0.5
lm_uscrime_scaled <- lm(Crime ~ M + Ed + Po1 + U2 + Ineq + Prob, data = uscrime_scaled)

# Display the summary of the new model
summary(lm_uscrime_scaled)


