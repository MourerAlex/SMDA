# SMDA: Synthetic Mean Decrease Accuracy

The present repository implement a method described in [1].

## Resume: 

The present repository implement a method that tackles the issues of model interpretability and variable importance in random forests, in the presence of correlated input variables. Variable importance criteria based on random permutations are known to be sensitive when input variables are correlated, and may lead for instance to unreliability in the importance ranking. In order to overcome some of the problems raised by correlation, an original variable importance measure is introduced. The proposed measure, called SMDA for Synthetic Mean Decrease Accuracy, builds upon an algorithm which clusters the input variables based on their correlations, and summarises each such cluster by a synthetic variable.

## Short Description:

### Objectives of variable importance 
Computing variable importance aims at two goals: i) find the contribution of each input variable to the prediction, and ii) measure the dependency between the input variables and the output one. Most of the importance measure in Random Forests (RF), such as MDA [1], focus on objective i) while this method aims to solve objective ii).

### Algorithm
The algorithm works in several steps:
* The input variables are clustered according to their correlation (between them) with a clustering of variables [2]. 
* The number of cluster is choosen in a supervised manner (more details in [2]).
* Each cluster is resumed by a synthetic variable: the first principal component of the variables of the cluster.
* A RF is fit on these synthetic variable. 
* The MDA of each synthetic variable is computed.
* The SMDA is the importance of the original variables through the synthetic ones (more details in [1]).

The code implementing the method is available in the file "function_SMDA.R" and with it is provided the function to simulate data (in the file named "simu_Model1.r") and an example to illustrate the method ("Example1.R").

## References
* [1] Chavent, M., Lacaille, J., Mourer, A., Olteanu, M. (2021).Handling Correlations in Random Forests: which Impacts on Variable Importance and Model Interpretability?. To appear in ESANN 2021 proceedings.
* [2] Leo Breiman.  Random forests.Machine learning, 45(1):5–32, 2001.
* [3] M. Chavent, R. Genuer, and J. Saracco.  Combining clustering of variables and feature se-lection using random forests. Communications in Statistics-Simulation and Computation,50(2):426–445, 2021.
