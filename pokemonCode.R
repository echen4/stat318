library(leaps) # leaps
library(MASS) # boxcox
library(usdm) # vifstep
library(asbio) # press
data <- read.csv("final_proj/stat318/smash2.csv", header=TRUE, na.strings='')
#data <- read.csv(file.choose(), header=TRUE)
n <- dim(data)[1]
attach(data)
# NOT USED: Name, Num, Generation, Rank, Usage.Per, Raw, Raw.Per, Real, Real.Per
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
totBattle <- 523289
Calc.Usage <- Raw / totBattle # counts all Pokémon in team, for popularity
data.new <- data[,c(-1,-2,-12,-14,-15, -16,-17,-18,-19)]
data.new <- cbind(data.new, Calc.Usage)
detach(data)
### CHECK FOR MULTICOLLINEARITY 
attach(data.new)
names(data.new)
data.new$Type.1 <- relevel(Type.1,ref="Normal")
data.new$Type.2 <- relevel(Type.2,ref="Normal") # consider 'None'
lm.full <- lm(Calc.Usage~.,data=data.new)
summary(lm.full)
quantData <- data.new[,c(-1,-2,-10)]
quantX <- model.matrix(Calc.Usage~.,data=quantData)[,-1]
X <- data.new[,-10]
Y <- data.new[,10]
vifstep(quantX,th=10)
detach(data.new)
data.new <- data.new[,-3]
names(data.new)
attach(data.new)
### VARIABLE SELECTION
lm.full <- lm(Calc.Usage~.,data=data.new)
summary(lm.full)
lm.aic <- step(lm.full,direction="both",trace=0,k=2) #AIC
# Usage.Per ~ Type.1 + HP + Attack + Defense + Sp.Atk + Speed (adjr2=0.2086)
summary(lm.aic)
### CHECK MODEL ASSUMPTIONS
scatter.smooth(residuals(lm.full)~predict(lm.full))
scatter.smooth(residuals(lm.aic)~predict(lm.aic)) # ordinary residu-8080000al
scatter.smooth(rstudent(lm.aic)~predict(lm.aic)) # studentized residual
press(lm.aic) 
abs(press(lm.full) - press(lm.aic))# compares to lm.full
plot(lm.aic)
# outliers: 33 (smeargle), 53 (xerneas), 100 (rayquaza mega), 666 (primal groudon)
# cite https://www.smogon.com/dex/sm/pokemon/
### ADD INTERACTION TERMS
lm.intA <- step(lm.aic,.~.^2,direction="both",trace=0,k=2) #AIC
# Calc.Usage ~ Type.1+HP+Attack+Defense+Sp.Atk+Speed+Attack:Sp.Atk+Type.1:Attack+HP:Defense+Type.1:Sp.Atk (adjr2 = 0.3616)
lm.intB<- step(lm.aic,.~.^2,direction="both",trace=0,k=log(n)) #BIC
# Calc.Usage ~ HP+Attack+Defense+Sp.Atk+Speed+Attack:Sp.Atk (adjr2 = 0.2778)
summary(lm.intA) # 0.869048 (individ-t, Attack:Sp.Atk possibly insignificant)
anova(lm.intA) # 0.52088, (partial-f, Type.1:Attack possibly insignificant)
lm.reOrder <- lm(Calc.Usage~Type.1+HP+Attack+Defense+Sp.Atk+Speed+Type.1:Sp.Atk+HP:Defense+Attack:Sp.Atk+Type.1:Attack)
anova(lm.reOrder)
lm.intA <- lm(Calc.Usage~Type.1+HP+Attack+Defense+Sp.Atk+Speed+Type.1:Sp.Atk+HP:Defense)
summary(lm.intA)
### CHECK MODEL ASSUMPTIONS (AGAIN)
scatter.smooth(residuals(lm.intA)~predict(lm.intA)) # ordinary residual
scatter.smooth(rstudent(lm.intA)~predict(lm.intA)) # studentized residual
### TRANSFORMATION
boxcox(lm.intA)
trans <- boxcox(lm.intA)
trans$x[which.max(trans$y)]
lm.transY <- lm(log(Calc.Usage)~Type.1+HP+Attack+Defense+Sp.Atk+Speed+HP:Defense+Type.1:Sp.Atk)
scatter.smooth(rstudent(lm.transY)~predict(lm.transY)) # studentized residual
plot(lm.transY)
# outliers in QQ plot: 33 (smeargle), 75 (ditto), 554 (shedinja)
# influential / high leverage: 121 (noibat), 264 (noivern)
### CHECK FOR INFLUENTIAL POINTS
thresh <- qf(0.5, df1=40, df2=n-40)
outliers <- which(cooks.distance(lm.transY) > thresh)
data[outliers,]
# no influential, outlying points
summary(lm.transY) # (adjr2 = 0.5997)

lm.transY <- lm(log(Calc.Usage)~Type.1+HP+Attack+Defense+Sp.Atk+Speed+HP:Defense+Type.1:Sp.Atk)
anova(lm.transY, test='Chisq')



library(ggplot2)
ggplot(data, aes(Legendary, Total)) + geom_boxplot(colour="red")
ggplot(data, aes(Attack, Defense)) + geom_point()
ggplot(data, aes(Type.1, Total)) + geom_boxplot(colour="red", fill="red", alpha=0.5,outlier.shape=1)