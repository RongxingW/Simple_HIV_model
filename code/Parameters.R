####This script is to Generate parameters
##no need to change the content in this script
Parameters<-function(fixeddata, timeseries,projectspecs){
with(as.list(c(fixeddata, timeseries,projectspecs)), {
# Setting up parameters
fixeddata$value<-as.numeric(fixeddata$value)
timeseries$timestep<-as.numeric(timeseries$timestep)
timeseries$acts<-as.numeric(timeseries$acts)
timeseries$condoms<-as.numeric(timeseries$condoms)
timeseries$prep<-as.numeric(timeseries$prep)
timeseries$testing <-as.numeric(timeseries$testing )
timeseries$immigrants<-as.numeric(timeseries$immigrants)
timeseries$emigrants<-as.numeric(timeseries$emigrants)
timeseries$Deaths<-as.numeric(timeseries$Deaths)
projectspecs$betaoption<-as.character    (projectspecs$betaoption)
#summary(data2)
#summary(data1)
# Put parmaters in a list for beta
parameters_beta0<- c(S0=fixeddata$value[fixeddata$Para == "numsus"],##number of susceptible people
N0=fixeddata$value[fixeddata$Para == "plhiv"], ##plhiv
I0=fixeddata$value[fixeddata$Para == "newinf"], ##new infection
d0=fixeddata$value[fixeddata$Para == "prodiag"], ##proportion  diagnosed
tau0=fixeddata$value[fixeddata$Para == "proART"], ##proportion on ART
sigma0=fixeddata$value[fixeddata$Para == "prosupp"] ,##proportion suppressed
phi=fixeddata$value[fixeddata$Para == "effisupp"],  ##the reduction in transmission due to suppression 0.95?
omega0= fixeddata$value[fixeddata$Para == "PrEPcov"], ##PrEP coverage (FIG1 Hammoud/##FIG21 HIV Strategy 2016 ?C 2020)
epsilon_PrEP=fixeddata$value[fixeddata$Para == "effiPrEP"])  ###scott(0.86) efficacy of PrEP
#different functions for beta0
# beta option
# beta option 1: the number of infections caused by PLHIV
# beta option 2: the number of infections occurring in susceptible people
if (projectspecs$betaoption == "N") {
beta0<- betaoption1(parameters = parameters_beta0)
} else if (projectspecs$value[5] == "S") {
beta0<- betaoption2(parameters = parameters_beta0)
} else {beta0 <- 0}
# After obtain beta0, Put parmaters as vectors for HIVmodel
parameters<- c(beta0 =beta0,
N0=fixeddata$value[fixeddata$Para == "plhiv"], ##plhiv
I0=fixeddata$value[fixeddata$Para == "newinf"], ##new infection
d0=fixeddata$value[fixeddata$Para == "prodiag"], ##proportion  diagnosed
tau0=fixeddata$value[fixeddata$Para == "proART"], ##proportion on ART
sigma0=fixeddata$value[fixeddata$Para == "prosupp"] ,##proportion suppressed
phi=fixeddata$value[fixeddata$Para == "effisupp"],  ##the reduction in transmission due to suppression 0.95?
omega0= fixeddata$value[fixeddata$Para == "PrEPcov"], ##PrEP coverage (FIG1 Hammoud/##FIG21 HIV Strategy 2016 ?C 2020)
epsilon_PrEP=fixeddata$value[fixeddata$Para == "effiPrEP"],  ###scott(0.86) efficacy of PrEP
epsilon_condom=fixeddata$value[fixeddata$Para == "efficon"],  ###efficacy condoms, scott
chi_0=fixeddata$value[fixeddata$Para == "conduse"], ##proportion of condom use FIG21 HIV Strategy 2016 ?C 2020 Quarter 4 & Annual 2020 Data Report
alpha0=fixeddata$value[fixeddata$Para == "sexact"],  ####proportion of sexual acts (baseline) Table1 Hammoud, total number of partners mean
T= fixeddata$value[fixeddata$Para == "testpro"])##proportion of testing, FIG22a HIV Strategy 2016 ?C 2020 Quarter 4 & Annual 2020 Data Report
#the monthly data are extracted. (below are monthly data from Jan 2020 - Dec 2020)
temporal_data<-  as.data.frame(  cbind(alpha_t=c(timeseries$acts),###Table1 Hammoud
chi_t=c(timeseries$condoms), ##FIG21 NSW HIV Strategy 2016 ?C 2020 Quarter 4 & Annual 2020 Data Report
T_p= c(timeseries$testing),###testing
##FIG22a NSW HIV Strategy 2016 ?C 2020 Quarter 4 & Annual 2020 Data Report
omega_p=c(timeseries$prep),###PREP
IM=c(timeseries$immigrants),###migrants month 0-12
EM=c(timeseries$emigrants),
Death=c(timeseries$Deaths),
tau=c(timeseries$tau),
sigma=c(timeseries$sigma)))
return(as.list(c(parameters, temporal_data)))
})
}