
# code to simulate data
source('simu_Model1.R')
source('function_SMDA.R')

# number of observations
N = 500

# number of trees of the RF
num.trees = 500
# min number of observation per leaf
min.node.size = 5

p_unim=3; # number of noise variables
p_unim_cor=3 # number of noise variables
p_lin=3; # number of important variables
p_lin_cor=5; # number of important correlated variables

# set a seed for reproducibility
set.seed(1)
# simulate with beta = 0.5 and 0.9 of correlation within groups of correlated variables (2 groups of correlated variables :  imp and non imp)
data <- Simu(n=N, p_lin=p_lin, p_lin_cor=p_lin_cor, cor = 0.90, betacor = 0.5, p_unim=p_unim, p_unim_cor=p_unim_cor)

# Run the SMDA function
res <- SMDA(X = data$X, y = data$y, num.trees = 500, min.node.size=5)

# Final results
df_res<- data.frame(
  SMDA = res$SMDA,
  corsq = cor(data$X,data$y)^2
)

## print res
options(digits = 4, scipen = 100)
print(df_res)

## What clusters were found
res$COV$cluster
## Correlated variables were clustered all together
