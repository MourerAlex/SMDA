# SMDA: Synthetic Mean Decrease Accuracy

## Resume: 

The present repository implement a method that tackles the issues of model interpretability and variable importance in random forests, in the presence of correlated input variables. Variable importance criteria based on random permutations are known to be sensitive when input variables are correlated, and may lead for instance to unreliability in the importance ranking. In order to overcome some of the problems raised by correlation, an original variable importance measure is introduced. The proposed measure, called SMDA for Synthetic Mean Decrease Accuracy, builds upon an algorithm which clusters the input variables based on their correlations, and summarises each such cluster by a synthetic variable.

## Short Description:

### Objectives of variable importance 
Computing variable importance aims at two goals: i) find the contribution of each input variable to the prediction, and ii) measure the dependency between the input variables and the output one. Most of the importance measure in Random Forests (RF), such as MDA and MDI, focus on objective i) while this method aims to solve objective ii).

### Algorithm

The algorithm works in several steps:
* The input variables are clustered according to their correlation (between them) with a clustering of variables. 
* The number of cluster is choosen in a supervised manner (more details later).
* Each cluster is resumed by a synthetic variable: the first principal component of the variables of the cluster.
* A RF is fit on these synthetic variable. 
* The MDA of each synthetic variable is computed.
* The SMDA is the importance of the original variables through the synthetic ones.

The code implementing the method is available in the file "function_SMDA.R" and with it is provided the function to simulate data (in the file named "simu_Model1.r") and an example to illustrate the method ("Example1.R").
