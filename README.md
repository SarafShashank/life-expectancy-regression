# Life Expectancy Prediction using Linear Regression

This project focuses on predicting **Life Expectancy** using various socio-economic and health indicators through **Linear Regression**. The dataset includes features like adult mortality, schooling, healthcare expenditure, and more. The model is developed using interaction terms, dummy variables, and stepwise selection to refine the predictors. The analysis includes key model diagnostics, cross-validation, and outlier detection.

## Table of Contents
1. [Project Overview](#project-overview)
2. [Dataset](#dataset)
3. [Installation](#installation)
4. [Project Workflow](#project-workflow)
    1. [Data Preparation](#data-preparation)
    2. [Model Building](#model-building)
    3. [Model Diagnostics](#model-diagnostics)
    4. [Cross-Validation](#cross-validation)
5. [Results and Visualizations](#results-and-visualizations)
6. [Usage](#usage)
7. [Contributing](#contributing)
8. [License](#license)

## Project Overview

The goal of this project is to build a linear regression model to predict life expectancy based on a wide range of indicators including health, socio-economic, and demographic factors. The project steps through data cleaning, model selection, and diagnostics to ensure the final model adheres to linear regression assumptions such as normality and homoscedasticity.

## Dataset

The dataset used is `lifeexp.csv`, which contains the following features:

- **Life expectancy**: The target variable we aim to predict.
- **Status**: Categorical variable indicating whether the country is developed or developing.
- **Adult Mortality**: Mortality rate for adults.
- **HIV/AIDS**: Death rate due to HIV/AIDS.
- **Schooling**: Average number of years of schooling.
- **Income Composition of Resources**: Proxy for the country's wealth.
- And several other health indicators (BMI, Measles, Hepatitis B, etc.).

The dataset can be found in this repository as `lifeexp.csv`.

## Installation

To run this project, you need R and several R packages. You can install the required packages by running the following commands in your R console:


# Install necessary packages
install.packages(c("tidyverse", "dplyr", "corrplot", "fastDummies", "car", "Metrics", "olsrr", "leaps", "lmtest"))
Clone this repository:

bash
Copy code
git clone https://github.com/yourusername/life-expectancy-regression.git
cd life-expectancy-regression
Ensure that your working directory contains the lifeexp.csv file.

## Project Workflow
This section describes the complete process of the analysis, from data cleaning to model diagnostics and evaluation.

 4.1 Data Preparation
Remove Unnecessary Columns: The Country column is removed from the dataset since it is a categorical variable that does not directly influence the prediction of life expectancy.

Handling Categorical Variables:

The Status column (Developed/Developing) is converted to a factor and then dummy variables are created using the fastDummies package to include it as a predictor in the model.
Interaction Terms:

Interaction terms allow us to explore how two or more predictors together influence life expectancy. This project generates all possible second-order interaction terms (e.g., how the effect of Adult Mortality changes when considering Total Expenditure).

 4.2 Model Building
Base Model: The initial model is created with important predictors like Adult Mortality, HIV/AIDS, and Income Composition of Resources.

--  base.model <- lm(Life.expectancy ~ Adult.Mortality + HIV.AIDS + Income.composition.of.resources, data = interaction_terms)

Full Model: A model including all variables and interaction terms is defined, and forward stepwise selection is used to pick the most significant predictors.

-- forward_model <- step(base.model, direction = "forward", scope = list(upper = full.model, lower = base.model))

Multicollinearity: Variance Inflation Factor (VIF) is calculated to check for multicollinearity among the predictors. Any predictor with a VIF value > 5 or 10 is removed to avoid multicollinearity.

 4.3 Model Diagnostics
Several diagnostic tests and plots are generated to assess the quality of the regression model:

Normality of Residuals: The Q-Q plot and Shapiro-Wilk test are used to ensure that residuals are normally distributed.

-- qqnorm(resid(reduced_model))
-- qqline(resid(reduced_model), col="red")

Homoscedasticity: The Breusch-Pagan test checks whether the residuals have constant variance (homoscedasticity). A p-value > 0.05 suggests that the residuals are homoscedastic.

Outlier Detection: Outliers and influential points are detected using Cook’s Distance and DFBetas, which highlight observations that might disproportionately affect the model's performance.


 4.4 Cross-Validation
To evaluate how well the model generalizes to unseen data, 10-fold Cross-Validation is performed. The dataset is split into 10 folds, and the model is trained on 9 folds and tested on the 10th fold. This process repeats until each fold has been used for testing. The average Root Mean Squared Error (RMSE) is calculated as a performance measure.
"rmse_values <- c()
for(i in 1:10) {
    # Perform training and testing for each fold
    ...
}
mean_rmse <- mean(rmse_values)
cat("Average RMSE across 10 folds:", mean_rmse)"

## 5. Results and Visualizations
Residuals vs Fitted Plot
This plot checks the randomness of residuals to ensure that no patterns exist. Ideally, the residuals should be scattered randomly around zero.


Q-Q Plot of Residuals
The Q-Q plot helps check if the residuals follow a normal distribution. If the points fall along the 45-degree line, the residuals are approximately normal.


## 6. Usage
To run the analysis on your machine, follow these steps:

Ensure you have installed the required packages (see Installation).

Clone the repository and navigate to the directory containing the script and dataset.

Run the R script by executing:

Rscript life_expectancy_regression.R

This script will:

Clean the dataset.
Perform model selection, diagnostics, and cross-validation.
Save the final model and cross-validation results as output files.

## 7. Contributing
We welcome contributions to this project. If you have ideas for improvement, follow these steps:

Fork the repository to your GitHub account.
Create a new branch (git checkout -b feature/myfeature).
Make your changes and commit them (git commit -am 'Add some feature').
Push to the branch (git push origin feature/myfeature).
Create a Pull Request describing your changes.
