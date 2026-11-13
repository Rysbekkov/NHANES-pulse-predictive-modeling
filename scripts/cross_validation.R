# Author: Atabek Rysbekov
# Independent 10-fold cross-validation check for the portfolio repository.
# The original course report quoted model MSE ~120.8 and baseline MSE ~132.3.
# This script uses a new, documented set of folds and may return different values.

input_file <- file.path("data", "NHANES-training.csv")
nhanes <- read.csv(input_file)
cols <- c("Pulse", "Age", "BMI", "BPDiaAve", "Testosterone", "Gender", "DaysMentHlthBad")
model_data <- na.omit(nhanes[, cols])
model_data$Gender <- factor(model_data$Gender, levels = c("female", "male"))

final_formula <- Pulse ~ Age + BMI + BPDiaAve + Testosterone * Gender + DaysMentHlthBad

set.seed(231)
k <- 10
n <- nrow(model_data)
folds <- sample(rep(seq_len(k), length.out = n))
model_squared_errors <- rep(NA_real_, n)
baseline_squared_errors <- rep(NA_real_, n)

for (fold in seq_len(k)) {
  train <- model_data[folds != fold, ]
  test <- model_data[folds == fold, ]

  fit <- lm(final_formula, data = train)
  predicted <- predict(fit, newdata = test)
  baseline <- mean(train$Pulse)

  model_squared_errors[folds == fold] <- (test$Pulse - predicted)^2
  baseline_squared_errors[folds == fold] <- (test$Pulse - baseline)^2
}

cat("Complete-case sample size:", n, "\n")
cat("Final regression CV MSE:", round(mean(model_squared_errors), 1), "\n")
cat("Mean-only baseline CV MSE:", round(mean(baseline_squared_errors), 1), "\n")
cat("Relative error reduction:",
    round(100 * (1 - mean(model_squared_errors)/mean(baseline_squared_errors)), 1), "%\n")
