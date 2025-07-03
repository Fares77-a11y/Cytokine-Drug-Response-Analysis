set.seed(960625)  
Procalcitonin=rnorm(21,20,2)
CRP=c(rnorm(14,30,4),rnorm(7,37,4))
Group=factor(c(rep("Virus",7),rep("Bacteria",7),rep("Malaria",7)),levels=c("Virus","Bacteria","Malaria"))
df=data.frame(Procalcitonin,CRP,Group)
df

#Q1
set.seed(960625)
head(dff,6)

#Q2
library(ggplot2)
# Set seed for reproducibility
set.seed(960625)
# Create boxplots
ggplot(df, aes(x = Group, y = Procalcitonin, fill = Group)) +
  geom_boxplot() +
  geom_jitter(aes(color = Group), position = position_jitter(width = 0.2), shape = 21) +
  scale_color_manual(values = c("black", "red", "green")) +
  labs(title = "Boxplot of Procalcitonin by Group", x = "Group", y = "Procalcitonin") +
  theme_minimal()
# Set seed for reproducibility
set.seed(960625)
ggplot(df, aes(x = Group, y = CRP, fill = Group)) +
  geom_boxplot() +
  geom_jitter(aes(color = Group), position = position_jitter(width = 0.2), shape = 21) +
  scale_color_manual(values = c("black", "red", "green")) +
  labs(title = "Boxplot of CRP by Group", x = "Group", y = "CRP") +
  theme_minimal()

#Q3
# Set the seed for reproducibility
set.seed(960625)
#Multivariate Normality
library(mvnormtest)
V=subset(df,Group=="Virus")
B=subset(df,Group=="Bacteria")
M=subset(df,Group=="Malaria")
mshapiro.test(t(V[,1:2]))
mshapiro.test(t(B[,1:2]))
mshapiro.test(t(M[,1:2]))
#Outliers
MD_V=mahalanobis(V[,1:2], colMeans(V[,1:2]), cov(V[,1:2]))
MD_B=mahalanobis(B[,1:2], colMeans(B[,1:2]), cov(B[,1:2]))
MD_M=mahalanobis(V[,1:2], colMeans(V[,1:2]), cov(M[,1:2]))
#Using cutoff value of 0.01
pchisq(MD_V,df=2)
pchisq(MD_B,df=2)
pchisq(MD_M,df=2)
#Homogeneity of variance-covariance matrices
library(biotools)
boxM(df[,1:2], df[,3])
#No Multicolinearity
cor(Procalcitonin,CRP)
#Linear relationship of the dependent variables
plot(Procalcitonin,CRP)

# Perform MANOVA
maov = manova(cbind(Procalcitonin, CRP) ~ Group, data=df)
summary(maov, test="Hotelling-Lawley")

# ANOVA for Procalcitonin
model_procalcitonin = aov(Procalcitonin ~ Group, data=dff)
summary(model_procalcitonin)
# Post-hoc tests for Procalcitonin
posthoc_procalcitonin = TukeyHSD(model_procalcitonin)
print(posthoc_procalcitonin)

# ANOVA for CRP
model_crp = aov(CRP ~ Group, data=dff)
summary(model_crp)
# Post-hoc tests for CRP
posthoc_crp = TukeyHSD(model_crp)
print(posthoc_crp)

