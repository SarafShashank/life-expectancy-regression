# ==============================================
#   Life Expectancy Prediction using Linear Regression
# ==============================================

# Required Libraries
library(tidyverse)      # Data manipulation
library(dplyr)          # Data wrangling
library(corrplot)       # Correlation plots
library(fastDummies)    # Creating dummy variables
library(car)            # Companion to Applied Regression
library(Metrics)        # Model performance metrics (e.g., RMSE)
library(olsrr)          # Regression diagnostics
library(leaps)          # Subset selection in regression
library(lmtest)         # Diagnostic testing in linear models

# ==============================================
#   1. Data Loading and Preparation
# ==============================================

# Read the CSV file (ensure to adjust the path as per your system)
sourcedata <- read.csv("C:/Users/saraf/OneDrive/Desktop/LR/lifeexp.csv", header = TRUE)

# Remove 'Country' column and convert 'Status' to a factor
without_country <- sourcedata %>%
  select(-Country)

without_country$Status <- factor(without_country$Status)

# ==============================================
#   2. Create Dummy Variables for 'Status'
# ==============================================

# Separate Life Expectancy and create dummy variables for 'Status'
without_life_expectancy <- without_country %>% 
  select(-Life.expectancy)

without_life_expectancy <- dummy_cols(without_life_expectancy, 
                                      select_columns = c("Status"), 
                                      remove_selected_columns = TRUE, 
                                      remove_first_dummy = TRUE)

# Create interaction terms for all second-order interactions
interaction_terms <- as.data.frame(model.matrix(~ (.-1)^2, data = without_life_expectancy))

# Add Life Expectancy back to the dataset
interaction_terms$Life.expectancy <- without_country$Life.expectancy

# ==============================================
#   3. Model Building and Selection
# ==============================================

# Define the base and full models
base.model <- lm(Life.expectancy ~ Adult.Mortality + HIV.AIDS + Income.composition.of.resources, data = interaction_terms)
full.model <- lm(Life.expectancy ~ ., data = interaction_terms)

# Perform forward stepwise selection
forward_model <- step(base.model, direction = "forward", scope = list(upper = full.model, lower = base.model))

# ==============================================
#   4. Check for Multicollinearity using VIF
# ==============================================

# Calculate VIF values and print them
vif_values <- vif(forward_model)
print(vif_values)

# Refine model by removing variables with high VIF (> 5 or 10)
reduced_model <- lm(Life.expectancy ~ Adult.Mortality + HIV.AIDS + Income.composition.of.resources + Total.expenditure, 
                    data = interaction_terms)
summary(reduced_model)

# ==============================================
#   5. Model Diagnostics: Checking Assumptions
# ==============================================

# Normality Check: Q-Q Plot and Shapiro-Wilk Test
par(mfrow=c(1,2)) # Display two plots side by side
qqnorm(resid(reduced_model), main="Normal Q-Q Plot")
qqline(resid(reduced_model), col="red")

# Perform Shapiro-Wilk test for normality
shapiro_test <- shapiro.test(resid(reduced_model))
print(shapiro_test)

# Homoscedasticity Check: Breusch-Pagan Test
bptest_result <- bptest(reduced_model)
print(bptest_result)

# ==============================================
#   6. Cross-Validation (10-Fold)
# ==============================================

# Set seed for reproducibility and perform k-fold cross-validation
set.seed(123)
folds <- cut(seq(1,nrow(interaction_terms)), breaks=10, labels=FALSE)

# Store RMSE values for each fold
rmse_values <- c()

for(i in 1:10) {
  # Split data into training and testing sets based on the fold
  test_indices <- which(folds == i, arr.ind=TRUE)
  test_data <- interaction_terms[test_indices, ]
  train_data <- interaction_terms[-test_indices, ]
  
  # Train the model on the training set
  cv_model <- lm(Life.expectancy ~ Adult.Mortality + HIV.AIDS + Income.composition.of.resources + Total.expenditure, 
                 data = train_data)
  
  # Predict on the test set
  test_predictions <- predict(cv_model, test_data)
  
  # Calculate and store RMSE for this fold
  rmse_values[i] <- rmse(test_data$Life.expectancy, test_predictions)
}

# Print the average RMSE across the folds
mean_rmse <- mean(rmse_values)
cat("Average RMSE across 10 folds:", mean_rmse, "\n")

# ==============================================
#   7. Final Model Diagnostics
# ==============================================

# Plot Residuals vs Fitted to check for randomness
plot(fitted(reduced_model), resid(reduced_model), 
     xlab="Fitted Values", ylab="Residuals", 
     main="Residuals vs Fitted")
abline(h=0, col="red")

# Cook's Distance Plot to detect influential points
ols_plot_cooksd_bar(reduced_model)

# DFBetas plot to identify influential observations
ols_plot_dfbetas(reduced_model)

# ==============================================
#   8. Save Final Model and Results
# ==============================================

# Save the final reduced model for future use
saveRDS(reduced_model, file = "final_life_expectancy_model.rds")

# Save cross-validation RMSE results
write.csv(data.frame(Fold=1:10, RMSE=rmse_values), "cross_validation_results.csv")

# ==============================================
#   End of Script
# ==============================================