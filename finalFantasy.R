library(leaps)
library(MASS)
library(usdm)
data <- read.csv("final_proj/stat318/smash2.csv", header=TRUE, na.strings='')
#data <- read.csv("smash2.csv", header=TRUE, na.strings='')
#data <- read.csv(file.choose(), header=TRUE)
n <- dim(data)[1]
attach(data)
# NOT USED: Name, Num, Generation, Rank, Raw, Raw.Per, Real, Real.Per
is.factor(Type.1) # 3
is.factor(Type.2) # 4
is.numeric(Total) # 5 
is.numeric(HP) # 6
is.numeric(Attack) # 7
is.numeric(Defense) # 8
is.numeric(Sp.Atk) # 9
is.numeric(Sp.Def) # 10
is.numeric(Speed) # 11
is.factor(Legendary) # 13
is.numeric(Usage.Per) # 15
data.new <- data[,c(-1,-2,-12,-14,-16,-17,-18,-19)]
detach(data)
### CHECK FOR MULTICOLLINEARITY 
attach(data.new)
names(data.new)
data.new$Type.1 <- relevel(Type.1,ref="Normal")
data.new$Type.2 <- relevel(Type.2,ref="Normal") # consider 'None'
lm.full <- lm(Usage.Per~.,data=data.new)
summary(lm.full)
quantData <- data.new[,c(-1,-2)]
quantX <- model.matrix(Usage.Per~.,data=quantData)[,-1]
X < data.new[,-10]
Y <- data.new[,10]
vifstep(quantX,th=10)
detach(data.new)
data.new <- data.new[,-3]
names(data.new)
attach(data.new)
### VARIABLE SELECTION
lm.full <- lm(Usage.Per~.,data=data.new)
summary(lm.full)
#autoSelect.A <- step(lm.full,direction="both",trace=0,k=2) #AIC
# Usage.Per ~ Type.1 + Sp.Atk + Legendary + Attack
autoSelect.B <- step(lm.full,direction="both",trace=0,k=log(n)) #BIC
# Usage.Per ~ Attack + Legendary
lm.bic <- lm(Usage.Per~Attack+Legendary)
summary(lm.bic)
### TRANSFORMATION
# adding 0.000001 to all values in Usage.per
detach(data.new)
data.new$Usage.Per <- data.new$Usage.Per + 0.000001
attach(data.new)
lm.datanew <- lm(Usage.Per~Attack+Legendary)
boxcox(lm.datanew)
lm.transY <- lm(log(Usage.Per)~Attack+Legendary)
                            ### CHECK FOR OUTLIERS
thresh <- qf(0.5, df1=3, df2=n-3)
outliers <- which(cooks.distance(lm.transY) > thresh)
data.new[outliers,]
summary(lm.transY)
plot(lm.transY)
### CHECK MODEL ASSUMPTIONS
scatter.smooth(residuals(lm.full)~predict(lm.full))
scatter.smooth(residuals(lm.bic)~predict(lm.bic))
scatter.smooth(residuals(lm.transY)~predict(lm.transY))
with(subset(data.new,Legendary=="False"),plot(log(Usage.Per)~Attack, col="red"))
with(subset(data.new,Legendary=="True"),points(log(Usage.Per)~Attack, col="blue"))
fit1 = lm(log(Usage.Per)~Attack,subset=Legendary=="False")#model for normies
fit2 = lm(log(Usage.Per)~Attack,subset=Legendary=="True") #model for legends
abline(fit1,lty=1) #lty=1 uses solid line
abline(fit2,lty=2) #lty=2 uses dashed line
### ADD INTERACTION TERMS
autoSelectInt.B <- step(lm.bic,.~.^2,direction="both",trace=0,k=log(n)) #BIC
#lm.int <- lm(log(Usage.Per)~Attack+Legendary+Attack:Legendary)
lm.int <- lm(Usage.Per~Attack+Legendary+Attack:Legendary)

summary(lm.int)
detach(data.new)