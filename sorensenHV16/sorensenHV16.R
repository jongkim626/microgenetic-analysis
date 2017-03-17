##
##  sorensenHV16
##

library(rstan)
library(knitr)

## Fixed Effects Model

# 1. Read the data
# getwd "C:/Users/jkim/Documents/RData/sorensenHV16"

rDat <- read.table("gibsonwu2012data.txt", header=TRUE) ## set working directory
rDat <- subset(rDat, region=="headnoun")
dim(rDat)  
# other useful commands to look at the data, names(rDat), str(rDat), levels(), dim()
# head()

# 2. Convert subject and item to factors
rDat$region <- factor(rDat$region)
rDat$subj <- factor(rDat$subj)
rDat$item <- factor(rDat$item)
summary(rDat)

# 3. Apply sum contrast coding to predictor (obj: +1; subj: -1)
rDat$so <- ifelse(rDat$type == "subj-ext", -1, 1)
summary(rDat)

# 4. Set up data for stan
stanDat <- list(rt = rDat$rt,
                so = rDat$so,
                N = nrow(rDat))

# 5. Load, compile, and fit model
fixEfFit <- stan(file = "fixEf.stan", 
                 data = stanDat, 
                 iter = 2000, chains = 4)

save(list="fixEfFit",file="fixEfFit.Rda",compress="xz")
traceplot(fixEfFit, pars = c("beta","sigma_e"), inc_warmup = FALSE)
print(fixEfFit, pars = c("beta","sigma_e"), probs = c(0.025, 0.5, 0.975))


