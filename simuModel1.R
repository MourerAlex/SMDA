

Simu <- function(n, p_lin, p_lin_cor, cor = 0.9, betacor = 0.5, p_unim, p_unim_cor){
  library(mvtnorm)
  
  y <- rep(0,n)
  imp <- c()
  inc <- 1
  X <- matrix(0, nrow=n)
  if(p_lin>1){
    sigma_p <- diag(rep(1,p_lin))
    X_lin <- rmvnorm(n, rep(0,p_lin), sigma_p)
    colnames(X_lin) <- paste0("X_lin", 1:p_lin)
    seq_imp <- seq(1,1/p_lin, length = p_lin)
    
    for(i in 1:ncol(X_lin)){
      y <- y + seq_imp[i] * X_lin[,i]
      imp[inc] <- seq_imp[i] ; inc <- inc+1
    }
    X <- data.frame(X, X_lin)
  }
  if(p_lin_cor>1){
    sigma_p <- diag(rep(1-cor,p_lin_cor))+cor
    X_lin_cor <- rmvnorm(n, rep(0,p_lin_cor), sigma_p)
    y <- y + betacor * X_lin_cor[,1]
    
    for(i in 1:ncol(X_lin_cor)){
      imp[inc] <- betacor*cor ; inc <- inc+1
    }
    
    X_temp_cor <- X_lin_cor[,1:(p_lin_cor)]
    colnames(X_temp_cor) <- paste0("X_lin_cor", 1:(p_lin_cor))
    X <- data.frame(X, X_temp_cor)
  }
  if(p_unim>1){
    sigma_p <- diag(rep(1,p_unim))
    X_unim <-  rmvnorm(n, rep(0,p_unim), sigma_p)
    colnames(X_unim) <- paste0("X_unim", 1:p_unim)
    
    X <- data.frame(X, X_unim)
    imp[inc:(inc+p_unim-1)] <- 0
    inc <- inc+p_unim
  }
  if(p_unim_cor>1){
    sigma_p <- diag(rep(1-cor,p_unim_cor))+cor
    X_unim_cor <-  rmvnorm(n, rep(0,p_unim_cor), sigma_p)
    colnames(X_unim_cor) <- paste0("X_unim_cor", 1:p_unim_cor)
    
    X <- data.frame(X, X_unim_cor)
    imp[inc:(inc+p_unim_cor-1)] <- 0
    inc <- inc+p_unim_cor
  }

  return(list(y=y, X=X[,-1], imp = imp))
}
