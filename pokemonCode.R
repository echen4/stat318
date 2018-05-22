library(leaps) # leaps
library(MASS) # boxcox
library(usdm) # vifstep
library(asbio) # press
data <- read.csv("final_proj/stat318/combined_data.csv", header=TRUE, na.strings='')
#data <- read.csv(file.choose(), header=TRUE)
n <- dim(data)[1]
attach(data)
# NOT USED: Name, Num, Generation, Rank, Usage.Per, Raw, Raw.Per, Real, Real.Per
is.logical(Can_Evolve) #3
is.factor(Type.1) # 4
is.factor(Type.2) # 5
is.numeric(Total) # 6 
is.numeric(HP) # 7
is.numeric(Attack) # 8
is.numeric(Defense) # 9
is.numeric(Sp.Atk) # 10
is.numeric(Sp.Def) # 11
is.numeric(Speed) # 12
is.logical(Legendary) # 14
is.numeric(Raw) #17
totPoke <- sum(Raw)
Calc.Usage <- 100 * Raw / totPoke # counts all Pokémon in team, for popularity
data.new <- data[,-c(1,2,13,15,16,17,18,19,20)]
data.new <- cbind(data.new, Calc.Usage)
detach(data)
### CHECK FOR MULTICOLLINEARITY 
attach(data.new)
names(data.new)
data.new$Type.1 <- relevel(Type.1,ref="Normal")
data.new$Type.2 <- relevel(Type.2,ref="Normal") # consider 'None'
lm.full <- lm(Calc.Usage~.,data=data.new)
summary(lm.full)
quantData <- data.new[,-c(1,2,3,11)]
quantX <- model.matrix(Calc.Usage~.,data=quantData)[,-1]
vifstep(quantX,th=10)
detach(data.new)
data.new <- data.new[,-4]
names(data.new)
attach(data.new)
### VARIABLE SELECTION
lm.full <- lm(Calc.Usage~.,data=data.new)
summary(lm.full)
lm.aic <- step(lm.full,direction="both",trace=0,k=2) #AIC
# RUN 1: Calc.Usage ~ Type.1 + HP + Attack + Sp.Atk + Defense + Speed (adjr2=0.2086)
# RUN 2: Calc.Usage ~ Type.2 + HP + Attack + Sp.Atk + Sp.Def + Speed (adjr2=0.2142)
summary(lm.aic)
### CHECK MODEL ASSUMPTIONS
scatter.smooth(residuals(lm.full)~predict(lm.full))
scatter.smooth(residuals(lm.aic)~predict(lm.aic)) # ordinary residu-8080000al
scatter.smooth(rstudent(lm.aic)~predict(lm.aic)) # studentized residual
press(lm.aic) 
abs(press(lm.full) - press(lm.aic))# compares to lm.full
plot(lm.aic)
# outliers: 52 (GroudonPrimal), 362 (Marshadow), 421 (Smeargle), 770 (RayquazaMega)
# cite https://www.smogon.com/dex/sm/pokemon/
### ADD INTERACTION TERMS
lm.intA <- step(lm.aic,.~.^2,direction="both",trace=0,k=2) #AIC
# RUN 1: Calc.Usage ~ Type.1+HP+Attack+Defense+Sp.Atk+Speed+Attack:Sp.Atk+Type.1:Attack+HP:Defense+Type.1:Sp.Atk (adjr2 = 0.3616)
# RUN 2: Calc.Usage ~ Type.2+HP+Attack+Sp.Def+Sp.Atk+Speed+Attack:Sp.Atk+Type.2:Attack+Type.2:Speed (adjr2 = 0.3648)
lm.intB<- step(lm.aic,.~.^2,direction="both",trace=0,k=log(n)) #BIC
# Calc.Usage ~ HP+Attack+Defense+Sp.Atk+Speed+Attack:Sp.Atk (adjr2 = 0.2778)
summary(lm.intA)
### CHECK MODEL ASSUMPTIONS (AGAIN)
scatter.smooth(residuals(lm.intA)~predict(lm.intA)) # ordinary residual
scatter.smooth(rstudent(lm.intA)~predict(lm.intA)) # studentized residual
### TRANSFORMATION
boxcox(lm.intA)
trans <- boxcox(lm.intA)
trans$x[which.max(trans$y)]
lm.transY <- lm(log(Calc.Usage)~Type.2+HP+Attack+Sp.Def+Sp.Atk+Speed+Attack:Sp.Atk+Type.2:Attack+Type.2:Speed)
scatter.smooth(rstudent(lm.transY)~predict(lm.transY)) # studentized residual
plot(lm.transY)
# outliers in QQ plot: 307 (Rattata), 421 (Smeargle), 927 (Ditto)
# influential / high leverage: 52 (GroudonPrimal), 273 (Shuckle), 507 (Zekrom)
### CHECK FOR INFLUENTIAL POINTS
thresh <- qf(0.5, df1=60, df2=n-60)
outliers <- which(cooks.distance(lm.transY) > thresh)
data[outliers,]
# no influential, outlying points
summary(lm.transY) # (adjr2 = 0.566)
anova(lm.transY) 
# choose to remove all interaction terms
lm.transY <- lm(log(Calc.Usage)~Type.2+HP+Attack+Sp.Def+Sp.Atk+Speed)
summary(lm.transY) # (adjr2 = 0.561)


library(glmnet)
# remove multicolinearity first?
testX <- model.matrix(Calc.Usage~.,data=data.new)[,-1]
Y <- data.new[,11]
fit <- glmnet(testX, Y, alpha=1)
fit

library(ggplot2)
ggplot(data, aes(Legendary, Total)) + geom_boxplot(colour="red")
ggplot(data, aes(Attack, Defense)) + geom_point()
ggplot(data, aes(Type.1, Total)) + geom_boxplot(colour="red", fill="red", alpha=0.5,outlier.shape=1)


ggplot(data.new, aes(fill=Legendary, x=Type.1)) + 
  geom_bar(position="dodge", stat="count")
ggplot(data.new, aes(fill=Legendary, x=Type.1)) + 
  geom_bar(position="fill", stat="count")
ggplot(data.new, aes(fill=Legendary, x=Type.2)) + 
  geom_bar(position="dodge", stat="count")
ggplot(data.new, aes(fill=Legendary, x=Type.2)) + 
  geom_bar(position="fill", stat="count")
ggplot(data, aes(x=Type.1, y=Total)) + 
  stat_summary(fun.y="mean", geom="bar")

dodge <- position_dodge(width = 0.9)
limits <- aes(ymax = Total$mean + myData$se,
              ymin = myData$mean - myData$se)
ggplot(data, aes(x=Type.2, y=Total, fill=Type.2)) + 
  stat_summary(fun.y="mean", geom="bar") + guides(fill=FALSE) +
  geom_errorbar(limits, position = dodge, width = 0.25) +
detach(data.new)
