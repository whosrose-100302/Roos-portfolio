# libraries:
library(Hmisc)
library(mice)
library(tidyverse)

# load in the data:
d1 <- sasxport.get("data/DEMO_I.xpt")
d2 <- sasxport.get("data/BPX_I.xpt")
d3 <- sasxport.get("data/BMX_I.xpt")
d4 <- sasxport.get("data/GHB_I.xpt")
d5 <- sasxport.get("data/TCHOL_I.xpt")

# we create subsets of the data, we take only the variables we need, and we
# leave out variables we dont, such as education level
d1.t <- subset(d1,select=c("seqn","riagendr","ridageyr"))
d2.t <- subset(d2,select=c("seqn","bpxsy1"))
d3.t <- subset(d3,select=c("seqn","bmxbmi"))
d4.t <- subset(d4,select=c("seqn","lbxgh"))
d5.t <- subset(d5,select=c("seqn","lbdtcsi"))

# we want to combine our datasets back into one dataset, d, which we do here
d <- merge(d1.t,d2.t)
d <- merge(d,d3.t)
d <- merge(d,d4.t)
d <- merge(d,d5.t)

# then, we rename variables, to make coding easier:
# RIAGENDR - Gender
# RIDAGEYR - Age in years at screening
# BPXSY1 - Systolic: Blood pres (1st rdg) mm Hg
# BMXBMI - Body Mass Index (kg/m**2)
# LBDTCSI - Total Cholesterol (mmol/L)
# LBXGH - Glycohemoglobin (%)
d$age <- d$ridageyr
d$sex <- d$riagendr
d$bp <- d$bpxsy1
d$bmi <- d$bmxbmi
d$HbA1C <- d$lbxgh
d$chol <- d$lbdtcsi

# give everyone with age <18 an NA for their age, so they get removed
# in the subsequent step
d$age[d$age<18] <- NA

# only take complete cases:
dc <- cc(subset(d, select = c("age","sex","bmi","HbA1C","bp")))

# In the analyses, we will work with the dataframe dc, which will be called
# clean_data
save(dc, file = "clean_data.RData")