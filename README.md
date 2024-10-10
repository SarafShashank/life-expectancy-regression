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

```r
# Install necessary packages
install.packages(c("tidyverse", "dplyr", "corrplot", "fastDummies", "car", "Metrics", "olsrr", "leaps", "lmtest"))
Clone this repository:

bash
Copy code
git clone https://github.com/yourusername/life-expectancy-regression.git
cd life-expectancy-regression
Ensure that your working directory contains the lifeexp.csv file.

Project Workflow
1. Data Preparation
Data Cleaning: The Country column is removed as it is not useful for prediction.
Dummy Variables: Dummy variables are created for the Status column (developed vs developing countries).
Interaction Terms: Second-order interaction terms between variables are created to capture complex relationships.
2. Model Building
A forward stepwise selection method is applied to the base model (Adult.Mortality + HIV.AIDS + Income.composition.of.resources) and full model, selecting the most significant predictors and interaction terms.
Multicollinearity is checked using Variance Inflation Factor (VIF) to remove predictors causing multicollinearity.
3. Model Diagnostics
Residuals Normality: The normality of residuals is checked using the Q-Q plot and Shapiro-Wilk test.
Homoscedasticity: The Breusch-Pagan test is used to check for constant variance in residuals.
Outliers and Influential Points: Influential points are detected using Cook's Distance and DFBetas.
4. Cross-Validation
A 10-fold Cross-Validation is performed to evaluate model stability and performance on unseen data, calculating the Root Mean Squared Error (RMSE) for each fold.
Results and Visualizations
Key plots generated during the analysis are included in the plots directory.

1. Residuals vs Fitted Plot
This plot helps in checking the randomness of residuals. Ideally, residuals should be randomly scattered around zero with no clear pattern.


2. Q-Q Plot of Residuals
The Q-Q plot is used to visually check if the residuals follow a normal distribution. Ideally, the points should fall on the 45-degree line.


3. Cross-Validation Results
The average RMSE across 10 folds is:

bash
Copy code
Average RMSE across 10 folds: XX.XX
(Replace XX.XX with actual output.)

Usage
To run the analysis, simply execute the R script:

bash
Copy code
Rscript life_expectancy_regression.R
Ensure that lifeexp.csv is in the same directory as the script.

The script performs the following steps automatically:

Data cleaning
Model fitting and selection
Diagnostics and cross-validation
Saves the final model and cross-validation results to disk
Contributing
Contributions are welcome! If you have any improvements or suggestions, feel free to submit a pull request or open an issue.

Steps to Contribute:
Fork the repository.
Create your feature branch (git checkout -b feature/myfeature).
Commit your changes (git commit -am 'Add some feature').
Push to the branch (git push origin feature/myfeature).
Create a new Pull Request.