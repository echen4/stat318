library(leaps)
library(MASS)
data <- read.csv("Documents/stat318/smash2.csv", header=TRUE, na.strings='')
n <- dim(data)[1]
#data <- read.csv(file.choose(), header=TRUE)
attach(data)
# NOT USED: Name, Num, Generation, Rank, Raw, Raw.Per, Real, Real.Per
is.factor(Type.1) # 3
is.factor(Type.2) # 4
is.numeric(Total) # 5 (collinear with other variables)
is.numeric(HP) # 6
is.numeric(Attack) # 7
is.numeric(Defense) # 8
is.numeric(Sp.Atk) # 9
is.numeric(Sp.Def) # 10
is.numeric(Speed) # 11
is.factor(Legendary) # 13
is.numeric(Usage.Per) # 15
data.new <- data[,c(-1,-2,-5,-12,-14,-16,-17,-18,-19)]
detach(data)
attach(data.new)
data.new$Type.1 <- relevel(Type.1,ref="Normal")
data.new$Type.2 <- relevel(Type.2,ref="Normal") # consider 'None'
lm.full <- lm(Usage.Per~.,data=data.new)
summary(lm.full)
X <- data.new[,-10]
Y <- data.new[,10]
#allSubset <- leaps(X,Y,method="Cp") # ask Wendy Wang about:
#Error in leaps.setup(x, y, wt = wt, nbest = nbest, nvmax = NCOL(x) + int,  : 
#  NA/NaN/Inf in foreign function call (arg 4)
#In addition: Warning message:
#In leaps.setup(x, y, wt = wt, nbest = nbest, nvmax = NCOL(x) + int,  :
#only first string in char vector used in .Fortran
autoSelect.A <- step(lm.full,direction="both",trace=0,k=2) #AIC
# Usage.Per ~ Type.1 + Sp.Atk + Legendary + Attack
autoSelect.B <- step(lm.full,direction="both",trace=0,k=log(n)) #BIC
# Usage.Per ~ Attack + Legendary
autoSelectInt.A <- step(lm.full,.~.^2,direction="both",trace=0,k=2) #AIC
# Usage.Per ~ Type.1 + Type.2 + Attack + Defense + 
  #Sp.Atk + Sp.Def + Speed + Legendary + Type.1:Legendary + 
  #Type.1:Type.2 + Sp.Atk:Legendary + Type.2:Legendary + Defense:Legendary + 
  #Attack:Sp.Atk + Speed:Legendary + Sp.Def:Legendary + Attack:Sp.Def
autoSelectInt.B <- step(lm.full,.~.^2,direction="both",trace=0,k=log(n)) #BIC
# Usage.Per ~ Type.1 + Attack + Defense + Sp.Atk + 
  #Legendary + Type.1:Legendary + Attack:Sp.Atk + Defense:Legendary + 
  #Sp.Atk:Legendary + Attack:Legendary


detach(data.new)

