library(leaps) # leaps
library(MASS) # boxcox
library(usdm) # vifstep
library(asbio) # press
data <- read.csv("final_proj/stat318/smash2.csv", header=TRUE, na.strings='')
#data <- read.csv("smash2.csv", header=TRUE, na.strings='')
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
quantData <- data.new[,c(-1,-2)]
quantX <- model.matrix(Calc.Usage~.,data=quantData)[,-1]
X < data.new[,-10]
Y <- data.new[,10]
vifstep(quantX,th=10)
detach(data.new)
data.new <- data.new[,-3]
names(data.new)
attach(data.new)
### VARIABLE SELECTION
lm.full <- lm(Calc.Usage~.,data=data.new)
summary(lm.full)
autoSelect.A <- step(lm.full,direction="both",trace=0,k=2) #AIC
# Usage.Per ~ Type.1 + Sp.Atk + Legendary + Attack
#autoSelect.B <- step(lm.full,direction="both",trace=0,k=log(n)) #BIC
# Usage.Per ~ Attack + Legendary
lm.aic <- lm(Calc.Usage~Type.1+Sp.Atk+Attack+Legendary)
summary(lm.aic)
### TRANSFORMATION
boxcox(lm.aic)
trans <- boxcox(lm.aic)
trans$x[which.max(trans$y)]
lm.transY <- lm(log(Calc.Usage)~Type.1+Sp.Atk+Attack+Legendary)
### CHECK FOR INFLUENTIAL POINTS
thresh <- qf(0.5, df1=22, df2=n-22)
outliers <- which(cooks.distance(lm.transY) > thresh)
data.new[outliers,]
summary(lm.transY)
plot(lm.transY)
### CHECK MODEL ASSUMPTIONS
scatter.smooth(residuals(lm.full)~predict(lm.full))
scatter.smooth(residuals(lm.aic)~predict(lm.aic))
scatter.smooth(residuals(lm.transY)~predict(lm.transY)) # ordinary residual
scatter.smooth(rstudent(lm.transY)~predict(lm.transY)) # studentized residual
# look for obvious clustering in residuals by Legendary
c1 <- data.new[(rstudent(lm.transY)<0.2 & predict(lm.transY)<5.5),]
c2 <- data.new[(rstudent(lm.transY)>=0.2 | predict(lm.transY)>=5.5),]
sum(c1$Legendary=="True")/(sum(c1$Legendary=="True")+sum(c1$Legendary=="False"))
sum(c2$Legendary=="True")/(sum(c2$Legendary=="True")+sum(c2$Legendary=="False"))
# with(subset(data.new,Legendary=="False"),plot(log(Usage.Per)~Attack, col="red"))
# with(subset(data.new,Legendary=="True"),points(log(Usage.Per)~Attack, col="blue"))
# fit1 = lm(log(Usage.Per)~Attack,subset=Legendary=="False")#model for normies
# fit2 = lm(log(Usage.Per)~Attack,subset=Legendary=="True") #model for legends
# abline(fit1,lty=1) #lty=1 uses solid line
# abline(fit2,lty=2) #lty=2 uses dashed line
press(lm.aic) # compares to lm.full
press(lm.transY) # compare to lm.full with log transformation (unimplemented)
summary(lm.transY)
plot(lm.transY)
# outliers in QQ plot: 33 (smeargle), 573 (shuckle), 641 (chansey)
# cite https://www.smogon.com/dex/sm/pokemon/
### REDEFINING LEVELS
# Type.1: Bug, Dark, Fairy, (Fighting), (Flying), Ground, Steel are > 0.05 significance
levels(data.new$Type.1) <- c(levels(data.new$Type.1),"NotSig")
data.new$Type.1[(data.new$Type.1=="Bug" | data.new$Type.1=="Dark" | 
                   data.new$Type.1=="Fairy" | data.new$Type.1=="Fighting" | 
                   data.new$Type.1=="Flying" | data.new$Type.1=="Ground" | 
                   data.new$Type.1=="Steel")] <- "NotSig"
data.new$Type.1 <- factor(data.new$Type.1)
levels(data.new$Type.1)
data.new$Type.1 <- relevel(Type.1,ref="Normal")
### ADD INTERACTION TERMS
lm.reformed <- lm(Calc.Usage~Type.1+Attack+Sp.Atk+Legendary)
autoSelectInt.A <- step(lm.reformed,.~.^2,direction="both",trace=0,k=2) #AIC
autoSelectInt.B <- step(lm.reformed,.~.^2,direction="both",trace=0,k=log(n)) #BIC
lm.intA <- lm(Calc.Usage~Type.1+Attack+Sp.Atk+Attack:Sp.Atk+Type.1:Attack)
lm.intA <- lm(Calc.Usage~Attack+Sp.Atk+Attack:Sp.Atk)
#lm.int <- lm(log(Usage.Per)~Attack+Legendary+Attack:Legendary)
lm.int <- lm(Calc.Usage~Attack+Legendary+Attack:Legendary)
scatter.smooth(residuals(lm.int)~predict(lm.int))

summary(lm.int)
detach(data.new)











