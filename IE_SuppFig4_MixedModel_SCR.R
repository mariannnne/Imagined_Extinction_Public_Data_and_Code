# by marianne, updated in jan 2018
# Mixed Model for IE SCR data
#install.packages('lme4')
#install.packages('lmerTest')
#install.packages('lsmeans')
library(lme4)
library(lmerTest)
library(lsmeans)

dat = IE_LMER_SCR_42
#dat = IE_LMER_SCR_66

# set up contrasts
# dat$group = factor(dat$group)
contrasts(dat$group) = contr.poly(3)

# dat$phase = factor(dat$phase)
contrasts(dat$phase) = contr.poly(5)

dat$sub = factor(dat$sub)

#group-phase interaction and most basic model
mod1=lmer(SCR ~ group * phase + (1|sub), data=dat)

#which will allow the repeated affect to vary across subjects i.e. a random slopes model 
mod2=lmer(SCR ~ group * phase + (phase|sub), data=dat)

#run both, save them each as a variable, and then do:
#anova(mod1, mod2)
anova(mod1)

#see which model has a lower AIC/BIC
#then run summary on the model, which will give you actual p-values for your IVs

# Pairwise
#if you want pairwise diffs of the conditions broken up by gender
#lsmeansLT(mod1, test.effs="gender:cond")
#lsmeansLT(mod1, test.effs="cond:gender")

#if you want pairwise diffs of gender broken up by condition
lsmeans(mod1, pairwise ~group|phase)
lsmeans(mod1, pairwise ~phase|group)
lsmeans(mod1, pairwise ~group)
