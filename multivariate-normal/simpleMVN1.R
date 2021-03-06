## This example shows how to estimate parameters
## of the multivariate normal distribution

library(TMB)

################################################################################
## Prepare data and parameters
p <- 3     # dimension of the MVN
n <- 1000  # number of observations
mu <- c(10, 20, 30)
sd <- c(3, 2, 1)
rho <- 0.5
## Variance-covariance matrix of MVN:
Sigma <- matrix(c(sd[1]*sd[1],     sd[2]*sd[1]*rho, sd[3]*sd[1]*rho,
                  sd[1]*sd[2]*rho, sd[2]*sd[2],     sd[3]*sd[2]*rho,
                  sd[1]*sd[3]*rho, sd[2]*sd[3]*rho, sd[3]*sd[3]),
                  nrow=p, ncol=p, byrow=TRUE)
set.seed(1)
X <- MASS::mvrnorm(n=n, mu=mu, Sigma)  # simulate
pairs(X, lower.panel=NULL)

data <- list(X=X)
parameters <- list(mu=rep(0,p), log_sd=rep(0,p), transformed_rho=0)

################################################################################
## Build and fit model
compile("simpleMVN1.cpp")
dyn.load(dynlib("simpleMVN1"))

model <- MakeADFun(data, parameters, DLL="simpleMVN1")
fit <- nlminb(model$par, model$fn, model$gr)

################################################################################
## Output section
rep <- sdreport(model)

fit$par
rep

Sigma
model$report()
