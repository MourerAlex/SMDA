# SMDA
The present repository implement a method that tackles the issues of model interpretability and variable importance in random forests, in the presence of correlated input variables. Variable importance criteria based on random permutations are known to be sensitive when input variables are correlated, and may lead for instance to unreliability in the importance ranking. In order to overcome some of the problems raised by correlation, an original variable importance measure is introduced. The proposed measure builds upon an algorithm which clusters the input variables based on their correlations, and summarises each such cluster by a synthetic variable.


The code implementing the method is available in the file "CodeSMDA.R" and with it is provided the code to simulate data (in the file named "simuModel1.r").
