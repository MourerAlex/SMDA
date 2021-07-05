
library(ClustOfVar)
library(ranger)

# code to simulate data
source('simuModel1.R')

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
set.seed(42)
# simulate with beta = 0.5 and 0.9 of correlation within groups of correlated variables (2 groups of correlated variables :  imp and non imp)
data <- Simu(n=N, p_lin=p_lin, p_lin_cor=p_lin_cor, cor = 0.90, betacor = 0.5, p_unim=p_unim, p_unim_cor=p_unim_cor)
X <- data.frame(data$X)
y <- data$y
Beta <- data$imp

## Hclust Var
### Cluster variables
tree <- hclustvar(X) # cluster variables
error_pred <- c()

### Find the best K
for(k in 1:ncol(X)){ # try for all the K, number of clusters
  part_hier <- cutreevar(tree, k) # cut in K classes
  # fit a RF on the K synthetic variables
  RG <- ranger(y~., data = data.frame(part_hier$scores), importance = "permutation", num.trees = num.trees, min.node.size = min.node.size)
  error_pred[k] <- RG$prediction.error # get the errors for all clustering
}
K <- which.min(error_pred) # choose K

### fit the final model
part_hier <- cutreevar(tree, K) # cut in K classes
datacov <- data.frame(part_hier$scores) # get the synthetic variables 
RG <- ranger(y~., data = datacov, importance = "permutation", num.trees = num.trees, min.node.size = min.node.size)
VIMP <- RG$variable.importance # get the importance of variable

### compute the SMDA
VItemp <- rep(1, ncol(X))
for(k in 1:K){
  sqload <- part_hier$var[[k]]
  # for each cluster: importance of an original variable = 
  # = the importance of the synthetic variable of the cluster the original variable belongs to
  # times the squared loading of the original variable (which measure its association with the synthetic variable)
  if(is.vector(sqload) == T){
    VItemp[which(k==part_hier$cluster)] <- VIMP[k]*part_hier$var[[k]][1]
  } else{
    VItemp[which(k==part_hier$cluster)] <- VIMP[k]*part_hier$var[[k]][,1]
  }
}

# Final results
df_res<- data.frame(
  SMDA=VItemp,
  imp = Beta^2
)
