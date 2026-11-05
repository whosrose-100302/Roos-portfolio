# load in the data
load("data/clean_data.RData")

# the model and its CI's without confounder bmi
summary(lm(bp ~ HbA1C + age + as.factor(sex), data=dc))
confint(lm(bp ~ HbA1C + age + as.factor(sex), data=dc))

# the model and its CI's with confounder bmi
summary(lm(bp ~ HbA1C + bmi + age + as.factor(sex), data=dc))
confint(lm(bp ~ HbA1C + bmi + age + as.factor(sex), data=dc))

# we run a model and select the second coefficient, the slope for HbA1C
ref <- lm(bp ~ HbA1C + bmi + age + as.factor(sex), data = dc)$coef[2]

# the number of simulations, 1000
n.sim <- 1e3

# 0-0.5 by steps of 0.1, so we get numbers 0, 0.1, 0.2, etc
# this is the percentage of measurement error in the exposure variable, HbA1C
perc.me.exp <- seq(0,.5,.1)
# same for the confounder, bmi
perc.me.conf<- seq(0,.5,.1)

# then we make a grid that shows all possible scenarios, from 0% meas. error in
# HbA1c and 40% error in bmi to 10% in both, etc
# so we get 6x6 = 36 possible combinations/scenarios
scenarios <- expand.grid(perc.me.exp, perc.me.conf)

# variance of the exposure and the confounder in the original data
var.exp <- var(dc$HbA1C)
var.conf <- var(dc$bmi)

# we want the number of observations, rows, which is the first element if
# you inspect a datasets dimensions
n <- dim(dc)[1]

# then, we make a beta_hat empty matrix, to store results
# we want the rows to be the simulations, and the columns to be the scenarios
beta.hat <- matrix(ncol = dim(scenarios)[1], nrow = n.sim)

# we start a for loop, we run over all 1000 simulations
for (k in 1:n.sim) {
  
  # set the seed each time
  set.seed(k)
  
  # we start a second loop, we loop over all scenarions we have
  for (i in 1:dim(scenarios)[1]) {
    
    # calculate the amount of measurement error we want to introduce
    # we will take the original variable and add measurement error to that
    var.me.exp <- var.exp*scenarios[i,1]/(1-scenarios[i,1])
    var.me.conf <- var.conf*scenarios[i,2]/(1-scenarios[i,2])
    
    # we can now add the measurement error to the variables
    # we save them as new variables in the dataset
    dc$HbA1C.me <- dc$HbA1C + rnorm(n, 0, sqrt(var.me.exp))
    dc$bmi.me <- dc$bmi + rnorm(n, 0, sqrt(var.me.conf))
    
    # now, we run the model from before again, with confounder BMI included,
    # and now with measurement error
    # again, we extract the second coefficient, the slope for HbA1C
    beta.hat[k,i] <- lm(bp ~ HbA1C.me + age + bmi.me + as.factor(sex),
                        data=dc)$coef[2]
    
  } 
}

# creating figure 2
tot.mat <- cbind(100*scenarios, apply(beta.hat, 2, mean))
colnames(tot.mat) <- c("me.exp", "me.conf", "estimate")

FIGURE <- ggplot(tot.mat, aes(me.exp, me.conf)) +
  geom_tile(color = "white", aes(fill = estimate)) +
  geom_text(aes(label = round(estimate, 2))) +
  scale_fill_gradient2(low = "#D55E00",
                       mid = "white",
                       high = "#56B4E9",
                       midpoint = ref) +
  labs(x = paste("% of total variance of HbA1c due to measurement error"),
       y = paste("% of total variance of BMI due to measurement error")) +
  coord_equal()+
  scale_y_continuous(breaks = unique(tot.mat[,1]))+
  scale_x_continuous(breaks = unique(tot.mat[,1]))+
  theme(panel.background = element_rect(fill = 'white', 
                                        colour = 'grey'),
        plot.title = element_text(hjust = 0),
        axis.ticks = element_blank(),
        axis.title = element_text(size = 12),
        axis.text = element_text(size = 10),
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 10))
FIGURE