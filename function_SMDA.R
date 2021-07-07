
# Library need for the function to run 
library(ClustOfVar)
library(ranger)

# Short Description:
# This function implement the SMDA measure.
# This measure of importance  aims to assess the relationships between input and output variables.
# The is robust to correlations between input variables as opposed to the MDA or the MDI.
# Note that this method does not predict the target values for new observations.

# Input Parameters

## X : Data frame or matrix of input variables of size n (rows) times p (columns)
## y : A vector of size n to be "predicted"/analysed (either numeric or categorical). 
## seq_K : The vector indicating the different numbers of clusters to be tested. Default is 1:ncol(X)
## num.trees : Integer indicating the number of trees in the RF. Default is 500
## min.node.size : Integer. Minimal node size. Default is 5 

### Note : Other parameters of the ranger function are not provided but can be easily modified in the SMDA function

# Output parameters

## SMDA : Numeric vector of size p, giving the importance of the variables of X. 
## RF_final: Object of class ranger with different elements such as the importance of the synthetic variables or the overall out of bag prediction error.
## number_of_clusters : Integer indicating the number of synthetic variables
## synthetic_data : Data frame of the synthetic variables of size n times number_of_clusters (number of synthetic variables)
## COV : Object given by the function cutreevar; cutreevar cuts a hierarchical tree of variables resulting from hclustvar into several clusters by specifying the desired number of clusters
## tree : Object given by the function hclustvar; hclustvar performs an ascendant hierarchical clustering of a set of variables

SMDA <- function(X, y, seq_K = 1:ncol(X), num.trees = 500, min.node.size=5){

  X <- as.data.frame(X)
  y <- as.vector(y)
  
  ## Hclust Var
  ### Cluster variables
  tree <- hclustvar(X) # cluster variables
  error_pred <- c()
  
  ### Find the best K
  for(k in seq_K){ # try for all the K, number of clusters
    part_hier <- cutreevar(tree, k) # cut in K classes
    # fit a RF on the K synthetic variables
    RF <- ranger(y~., data = data.frame(part_hier$scores), importance = "permutation", num.trees = num.trees, min.node.size = min.node.size)
    error_pred[k] <- RF$prediction.error # get the errors for all clustering
  }
  K <- seq_K[which.min(error_pred)] # choose K
  
  ### fit the final model
  part_hier_final <- cutreevar(tree, K) # cut in K classes
  datacov <- data.frame(part_hier_final$scores) # get the synthetic variables 
  RF_final <- ranger(y~., data = datacov, importance = "permutation", num.trees = num.trees, min.node.size = min.node.size)
  VIMP <- RF_final$variable.importance # importance of the synthetic variables

  ### compute the SMDA
  VItemp <- rep(1, length(seq_K))
  for(k in 1:K){
    sqload <- part_hier_final$var[[k]]
    # for each cluster: importance of an original variable = 
    # = the importance of the synthetic variable of the cluster the original variable belongs to
    # times the squared loading of the original variable (which measure its association with the synthetic variable)
    if(is.vector(sqload) == T){
      VItemp[which(k==part_hier_final$cluster)] <- VIMP[k]*part_hier_final$var[[k]][1]
    } else{
      VItemp[which(k==part_hier_final$cluster)] <- VIMP[k]*part_hier_final$var[[k]][,1]
    }
  }

  return(
    list(
      SMDA = VItemp, # SMDA measure
      RF_final, # The final Random Forests Model
      number_of_clusters = K, # Final number of clusters
      synthetic_data = datacov, # synthetic variables,
      COV = part_hier_final, # clustering of variables outputs
      tree = tree # COV tree
    )
  )
}

