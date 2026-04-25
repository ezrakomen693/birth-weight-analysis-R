# Birth Weight Analysis
# Dataset: birthwt (MASS package)
# Author: Ezra Komen Kipyegon
# Description: Exploring risk factors associated with low infant birth weight using statistical summaries and visualisations in R.

# Loading required packages
library(MASS)
library(ggplot2)

# Load dataset
data(birthwt)

# Preview the data
head(birthwt)
str(birthwt)

# convert categorical variables to factors
birthwt$race<-factor(birthwt$race,levels=c(1,2,3),labels=c("White","Black","Other"))
birthwt$smoke<-factor(birthwt$smoke,levels=c(0,1),labels=c("Non Smoker","Smoker"))
birthwt$ui<-factor(birthwt$ui,levels=c(0,1),labels=c("No","Yes"))
birthwt$low<-factor(birthwt$low,levels=c(0,1),labels=c("Normal","Low"))
birthwt$ht<-factor(birthwt$ht,levels=c(0,1),labels=c("No","Yes"))

# Summary statistics for all variables
summary(birthwt)

# Fit the model
model_multi<-lm(bwt~lwt+smoke+age+ui+race+ht+ptl,data=birthwt)
summary(model_multi)

# Diagnostic plots
par(mfrow = c(2, 2))
plot(model_multi)

# Identify influential observations
cooksd <- cooks.distance(model_multi)

# Plot cook's distance 
plot(cooksd, type = "h",
     main = "Cook's Distance - Influential Observations",
     xlab = "Observation Index",
     ylab = "Cook's Distance")
abline(h = 4/nrow(birthwt), col = "Red", lwd = 2)

# Print which observations are influential
influential <- which(cooksd > 4/nrow(birthwt))

# Examine those rows
birthwt[influential, ]

# Compare the model with and without influential points
model_clean <- lm(bwt~lwt+smoke+age+ui+race+ht+ptl,data=birthwt[- influential, ])

# Compare coefficients side by side
data.frame(Variable = names(coef(model_multi)),
           With_Influential = round(coef(model_multi), 2),
           Without_Influential = round(coef(model_clean), 2))

# Ensure response variable is binary
birthwt$low <- factor(birthwt$low, levels = c("Normal", "Low"))

# Logistic regression predicting low birthweight
model_logit <- glm(low~lwt+smoke+age+ui+race+ht+ptl,data=birthwt, family = binomial)
summary(model_logit)

# Odds ratio with confidence intervals
odds_ratios <- exp(cbind(
  OR = coef(model_logit),
  confint(model_logit)
))
round(odds_ratios, 3)
odds_ratios

# Model with smoking * race interaction
model_interact <- glm(low~lwt+smoke*race+age+ui+ht+ptl,data=birthwt, family = binomial)
summary(model_interact)

# Compare models using AIC
AIC(model_logit, model_interact)

# OR Forest Plot- the signature visual of epidemiology
or_df <- data.frame(Variable = c("lwt", "Smoker", "Age", "UI", "Black", "Other", "Hypertension", "PTL"),
                    OR = c(0.985, 2.518, 0.973, 2.135, 3.537, 2.367, 6.257, 1.719),
                    Lower = c(0.971, 1.161, 0.905, 0.859, 1.264, 1.013, 1.669, 0.881),
                    Upper = c(0.998, 5.645, 1.044, 5.271, 10.126, 5.725, 26.520, 3.478)
)
ggplot(or_df, aes(x = OR, y = reorder(Variable, OR))) +
  geom_point(size = 3, color = "steelblue") +
  geom_errorbarh(aes(xmin = Lower, xmax = Upper), width = 0.2) +
  geom_vline(xintercept = 1, linetype = "dashed", color = "red") +
  labs(title = "Odds Ratios for Low Birthweight Risk Factors",
       subtitle = "Logistic Regression with 95% Confidence Intervals",
       x = "Odds Ratio",
       y = "Variable") +
  theme_minimal()

# Birthweight by smoking and race combined
ggplot(birthwt, aes(x = race, y = bwt, fill = smoke)) +
  geom_boxplot(alpha = 0.7) +
  scale_fill_manual(values = c("lightblue", "salmon")) +
  labs(title = "Birthweight by Race and Smoking Status",
       subtitle = "Birth Weight | n = 189",
       x = "Race",
       y = "Birth Weight (grams)",
       fill = "Smoking Status") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"))

# Saving plots
# forest plot
ggsave("forest_plot_OR.png", width = 8, height = 5, dpi = 300)
# combined boxplot
ggsave("birthweight_race_smoking.png", width = 8, height = 5, dpi = 300)
