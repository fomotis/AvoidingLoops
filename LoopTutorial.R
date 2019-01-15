## ----setup, include=FALSE, message=FALSE, warning=FALSE------------------
knitr::opts_chunk$set(echo = TRUE, message=FALSE, warning=FALSE, cache = TRUE,
                      collapse = TRUE, comment = ">")
library(readxl)
library(tidyverse)

## ------------------------------------------------------------------------
#bootstrap function
boot_func <- function(dat) {
  # sample from data
  sample(dat, length(dat), replace = T)
  # mean and standard deviation of dat
  return(mean(dat))
}
sdata <- rnorm(80000, 0.5, 1.5)
# 3 X 3 matrices from uniform distribution
mdata <- vector("list", 80000)
mdata<- lapply(mdata, function(x) {
  matrix(runif(15, 0, 1), nrow = 3, ncol = 3)
})

## ----forloop, echo = FALSE-----------------------------------------------
Results <- lapply(1:10, function(k){
  #for loop
  ttfor_sdata <- system.time(for(i in 1:1000) {
  boot_func(dat = sdata) })[[2]]
  ttfor_mdata <- system.time(
    for(i in 1:length(mdata)) {
    det(mdata[[i]]) })[[2]]
  #sapply
  ttsa_sdata <- system.time(
    sapply(1:1000, function(i) {
  boot_func(dat = sdata)
  }))[[2]]
 ttsa_mdata <- system.time(
   sapply(mdata, det))[[2]]
 #purrr
  ttpu_sdata <- system.time(
    purrr::rerun(1000, boot_func(dat = 
                       sdata)))[[2]]
  ttpu_mdata <- system.time(purrr::map(mdata, 
                            det))[[2]]
  result <- rbind(data.frame(FOR = ttfor_sdata, 
                  SA = ttsa_sdata, 
                  PUR = ttpu_sdata, 
                  Data_Type = "sdata"), 
        data.frame(FOR = ttfor_mdata, 
                   SA = ttsa_mdata, 
                   PUR = ttpu_mdata, 
                   Data_Type = "mdata"))
  return(result)
}) %>% do.call(rbind.data.frame, .)


## ----plot, echo=FALSE----------------------------------------------------
Results %>% gather(key = "Function_Type", value = "Time", -Data_Type) %>% 
  group_by(Data_Type, Function_Type) %>% 
  summarise(Ave_Time = mean(Time), sd_Time = sd(Time)) %>% 
  ggplot(aes(x = Function_Type, y = Ave_Time)) + geom_point() + 
  geom_errorbar(aes(ymin = Ave_Time - sd_Time, ymax = Ave_Time + sd_Time), width = 0.2,
                     position = position_dodge(0.05), size = 1) + theme_bw() + 
  facet_grid(.~Data_Type)


## ----modelfit, echo=FALSE------------------------------------------------
chickendata <- read_excel("Data/PhMatt.xls",sheet="PhMatt")
#Tags that occur more than once
doubles <- chickendata %>% filter(TAGNO %in% names(which(table(chickendata$TAGNO)>1)))
#for( i in 1:54){
#  print(list(i,which(chickendata$TAGNO == doubles$TAGNO[[i]])))
#}
#which(chickendata$TAGNO == "A74")
chickendata2 <- chickendata %>% slice(-c(715:(715+20),3823:(3823+20),6028:(6028+20),6049:(6049+20),
                                       3907:(3907+20),3928:(3928+20),6133:(6133+20),3970:(3970+20),
                                       3991:(3991+20),4012:(4012+20),4033:(4033+20),6238:(6238+20),
                                       4075:(4075+20),6280:(6280+20),4117:(4117+20),4138:(4138+20),
                                       6343:(6343+20),4180:(4180+20),4201:(4201+20),4222:(4222+20),
                                       6427:(6427+20),6448:(6448+20),6469:(6469+20),4306:(4306+20),
                                       6511:(6511+20),6532:(6532+20),3886:(3886+20)
                                       ) )

chickendata2 <- chickendata2 %>% mutate(TAGNO=rep(unique(chickendata2$TAGNO)[!is.na(unique(chickendata2$TAGNO))]
                                                ,each=21))

###creating another group where CHICKG==11,22,33,44 = unibreed and, others are crossbreed
chickendata2 <- chickendata2 %>% mutate(Group=ifelse(chickendata2$CHICKG %in% c(11,22,33,44),
                                                     "High Breed",
                                                     "Cross Breed") )
#make a list
bychick <- chickendata2 %>% group_by(TAGNO) %>% nest()

## ------------------------------------------------------------------------
model_func <- function(ddata) {
  if( length(which(!is.na(ddata$BW))) >= 3 ) {
   model  <- lm(BW ~ AGE, data = ddata)
   slope <- coef(model)[2]
  } else {
    slope <- NA
  }
  return(slope)
}

## ------------------------------------------------------------------------
slopes <- c()
system.time( for(i in 1:length(bychick$data)) {
  result <- model_func(ddata = bychick$data[[i]])
  slopes <- c(slopes, result)
})

## ------------------------------------------------------------------------
system.time(lapply(bychick$data, model_func))

## ------------------------------------------------------------------------
system.time(map(bychick$data, model_func))

