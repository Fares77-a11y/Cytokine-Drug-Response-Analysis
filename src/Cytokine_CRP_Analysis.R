# -------------------------------------------
# 🧬Multivariate Biomarker Analysis
# Author: Fares Ibrahim
# Date: [4-7-2025]
# Description:
#   Simulated clinical dataset of 21 patients with virus, bacterial, or malaria infection.
#   Two biomarkers (Procalcitonin and CRP) measured.
#   Objective: Analyze differences between groups using MANOVA, ANOVA, and post-hoc testing.
# -------------------------------------------

# Set seed for reproducibility (Use your DOB as instructed)
set.seed(960625)

# -------------------------------------------
# 🧪 1. Simulate Biomarker Data
# -------------------------------------------
Procalcitonin <- rnorm(21, mean = 20, sd = 2)
CRP <- c(rnorm(14, mean = 30, sd = 4), rnorm(7, mean = 37, sd = 4))
Group <- factor(rep(c("Virus", "Bacteria", "Malaria"), each = 7), levels = c("Virus", "Bacteria", "Malaria"))

# Create data frame
df <- data.frame(Procalcitonin, CRP, Group)
head(df)

# -------------------------------------------
# 📊 2. Boxplots with Jittered Points
# -------------------------------------------
library(ggplot2)

# Procalcitonin by group
ggplot(df, aes(x = Group, y = Procalcitonin, fill = Group)) +
  geom_boxplot() +
  geom_jitter(aes(color = Group), width = 0.2, shape = 21) +
  scale_color_manual(values = c("black", "red", "green")) +
  labs(title = "Boxplot of Procalcitonin by Group", x = "Infection Type", y = "Procalcitonin") +
  theme_minimal()

# CRP by group
ggplot(df, aes(x = Group, y = CRP, fill = Group)) +
  geom_boxplot() +
  geom_jitter(aes(color = Group), width = 0.2, shape = 21) +
  scale_color_manual(values = c("black", "red", "green")) +
  labs(title = "Boxplot of CRP by Group", x = "Infection Type", y = "CRP") +
  theme_minimal()

# -------------------------------------------
# 📈 3. Assumption Checks for MANOVA
# -------------------------------------------

# Load required packages
library(mvnormtest)  # For Shapiro tests
library(biotools)    # For Box’s M test

# Test for multivariate normality by group
V <- subset(df, Group == "Virus")
B <- subset(df, Group == "Bacteria")
M <- subset(df, Group == "Malaria")

mshapiro.test(t(V[, 1:2]))
mshapiro.test(t(B[, 1:2]))
mshapiro.test(t(M[, 1:2]))

# Mahalanobis distance for outlier detection
MD_V <- mahalanobis(V[, 1:2], colMeans(V[, 1:2]), cov(V[, 1:2]))
MD_B <- mahalanobis(B[, 1:2], colMeans(B[, 1:2]), cov(B[, 1:2]))
MD_M <- mahalanobis(M[, 1:2], colMeans(M[, 1:2]), cov(M[, 1:2]))

# Assess outliers using Chi-square cutoff at p=0.01
pchisq(MD_V, df = 2)
pchisq(MD_B, df = 2)
pchisq(MD_M, df = 2)

# Test homogeneity of covariance matrices
boxM(df[, 1:2], df$Group)

# Check multicollinearity and linear relationship
cor(df$Procalcitonin, df$CRP)
plot(df$Procalcitonin, df$CRP)

# -------------------------------------------
# 🔬 4. MANOVA Test (Hotelling-Lawley)
# -------------------------------------------
maov <- manova(cbind(Procalcitonin, CRP) ~ Group, data = df)
summary(maov, test = "Hotelling-Lawley")

# -------------------------------------------
# 🔍 5. Post-hoc ANOVAs and Tukey Tests
# -------------------------------------------

# ANOVA for Procalcitonin
model_pro <- aov(Procalcitonin ~ Group, data = df)
summary(model_pro)
posthoc_pro <- TukeyHSD(model_pro)
print(posthoc_pro)

# ANOVA for CRP
model_crp <- aov(CRP ~ Group, data = df)
summary(model_crp)
posthoc_crp <- TukeyHSD(model_crp)
print(posthoc_crp)
