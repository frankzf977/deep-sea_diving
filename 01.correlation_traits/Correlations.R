
###input
the.species <- c("Tursiops truncatus","Tursiops aduncus","Globicephala melas","Lagenorhynchus obliquidens","Grampus griseus","Lagenorhynchus acutus","Pseudorca crassidens","Orcinus orca","Delphinus delphis","Phocoena sinus","Phocoena phocoena","Phocoenoides dalli","Delphinapterus leucas","Monodon Monoceros","Mesoplodon densirostris","Mesoplodon europaeus","Mesoplodon stejnegeri","Hyperoodon ampullatus","Physeter catodon","Kogia breviceps","Kogia sima","Balaenoptera physalus","Balaenoptera musculus","Balaenoptera acutorostrata","Balaenoptera borealis","Eschrichtius robustus","Balaena mysticetus")
the.species <- gsub("\\s", "_", the.species)


##the.traits from supplemental table


max.dive.time <-  c(8,22.9,8.9,6.2,10,4,18,21,0.55,3,7,NA,18.3,25,68,84,68,70,73,52,50,14,17.5,9,20,26,31) #
max.dive.depth <- c(50,50,401,1017.7,50,270,927.5,767.5,200,12,98.6,94,1000,1500,1408,1599,1560,1453,3000,1200,3200,617,510,105,57,170,400)
#
MB <- c(1.65,NA,NA,3.45,2.6,NA,6.3,3.07,NA,NA,2.6,6,3.44,7.8,6.92,7.41,NA,6.34,7,4.33,4.33,2.42,0.8,0.7,0.91,1.27,3.54)
#
blubber.thickness <- c(2.13,NA,3.36,NA,3.62,1.94,NA,NA,NA,0.9,2.03,NA,10.8,6.17,3.55,3.5,6,NA,9.84,3.4,NA,9.46,6.15,4,5.85,20,18.69)
#
HB <- c(14.4,13.86,NA,17,17.2,14.8,15.2,15.1,NA,NA,19.76,NA,19.9,22.5,NA,22.9,NA,NA,25,20,20,NA,NA,14.1,NA,NA,NA)
#
EQ <- c(4.14,NA,2.39,NA,4.55,4.01,3.95,6.23,2.57,2.24,3.15,NA,2.24,1.76,1.39,2.11,NA,NA,0.58,1.78,1.63,0.49,0.21,0.49,0.48,0.58,0.11)
#
body.mass <- c(209.53,200,943.2,91.05,328,120,402,1955.45,52,NA,51.193,NA,636,1578.33,767,732.5,NA,NA,35833.33,305,168.5,38421.5,50904,9200,22680,14329,90000)
#
brain.mass <- c(1.824,NA,2.893,1.148,2.387,1.2,4.249,5.059,2.08,NA,0.54,NA,2.083,2.997,1.463,2.149,NA,NA,8.028,1.012,0.622,7.085,3.636,2.7,4.9,4.305,2.843)
#
lung.mass <- c(3.3525,NA,0.97,NA,NA,NA,NA,2.03,2.58,3,4.13,3,2.34,2.6,1.4,1.4,1.4,0.86,0.9,1.03,1.03,0.58,NA,NA,0.88,1,0.9)
#
lung.capacity <- c(13.35,NA,45.1,NA,8.3,NA,NA,NA,9.47,NA,3.3325,NA,75.91,NA,NA,NA,NA,35,23.79,6.38,6.38,1552,NA,NA,1740,NA,NA)
#
lung.capacity2body.mass <- c(77.33,NA,100.2,NA,111.6,NA,NA,44.59,95.05,NA,98.43,NA,100.7,NA,NA,NA,NA,26.25,19.25,34.6,34.6,44.74,NA,NA,130.9,NA,NA)
#
heart.mass <- c(0.54,0.6,0.44,0.85,NA,NA,NA,0.641,NA,NA,0.84,1.31,0.57,0.5,NA,NA,NA,NA,0.332,0.326,NA,0.396,0.399,0.475,0.404,0.6,NA)

# add to big traits df.

stats_df = data.frame(matrix(ncol=4, nrow=0))
names(stats_df) = c("Trait","Dive.trait", "lm_R2", "lm_pval")
the.traits <- cbind(max.dive.time,max.dive.depth,MB,blubber.thickness,HB,body.mass,brain.mass,lung.mass,lung.capacity,lung.capacity2body.mass,heart.mass,EQ)
the.traits <- data.frame(Species_name = the.species, the.traits)



row.names(the.traits) <- the.species

the.traits
# how many have all values?
length(the.traits[,1]) 

# select which traits we are interested to compare in lm-fit
the.diving.traits <- c("max.dive.time","max.dive.depth")
the.other.traits <-  c("MB","blubber.thickness","HB","body.mass","brain.mass","EQ","lung.mass","lung.capacity","lung.capacity2body.mass","heart.mass")  





# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
###lm ANALYSES
for (TRAIT in the.other.traits){
for (DIVE.TRAIT in the.diving.traits){

temp.TRAIT.df <- cbind(the.traits[,TRAIT],the.traits[,DIVE.TRAIT])
colnames(temp.TRAIT.df) <- c(TRAIT,DIVE.TRAIT)
#
temp.TRAIT.df <- temp.TRAIT.df[complete.cases(temp.TRAIT.df), ] #   remove rows with NA after we have selected our traits of interest!
# testar <- temp.TRAIT.df[complete.cases(temp.TRAIT.df), ]

# log10 the values!
temp.TRAIT.df[,1] <- log10(temp.TRAIT.df[,1])
temp.TRAIT.df[,2] <- log10(temp.TRAIT.df[,2])


# loop through and save stats
formula_df = temp.TRAIT.df[, DIVE.TRAIT] ~ temp.TRAIT.df[, TRAIT]
lm_summary = summary(lm(formula_df))
lm_rsquared = round(lm_summary$r.squared, 4)
lm_pval = as.numeric(round(lm_summary$coefficients[,4][2], 4))

stats_df.temp = data.frame(Trait=TRAIT, Dive.trait=DIVE.TRAIT, lm_R2=lm_rsquared, lm_pval=lm_pval)
stats_df = rbind(stats_df,stats_df.temp)
stats_df 
  }
}


stats_df
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

##PGLS analysis (Default Brownian model)
library(ape)
library(phytools)
library(nlme)
library(geiger)
library(caper)


pglstree <- read.tree("27.nwk")

for (TRAIT in the.other.traits){
  for (DIVE.TRAIT in the.diving.traits){
    
    temp.TRAIT.df <- cbind(the.traits[, c("Species_name", TRAIT, DIVE.TRAIT)])
    colnames(temp.TRAIT.df) <- c("Species_name", TRAIT, DIVE.TRAIT)    
    
    # delete NA
    
    temp.TRAIT.df[, TRAIT] <- log10(temp.TRAIT.df[, TRAIT])
    temp.TRAIT.df[, DIVE.TRAIT] <- log10(temp.TRAIT.df[, DIVE.TRAIT])
    
    
    cdata <- comparative.data(data = temp.TRAIT.df, phy = pglstree, names.col = "Species_name", na.omit = FALSE, vcv = TRUE, vcv.dim = 3)
    formula <- as.formula(paste(DIVE.TRAIT, "~", TRAIT))
    respgls <- pgls(as.formula(paste(DIVE.TRAIT, "~", TRAIT)), cdata, lambda = "ML")
    pgls_summary <- summary(respgls)
    
    print(pgls_summary)
    
    pgls_lambda = as.numeric(round(pgls_summary$param[2], 4))
    pgls_rsquared = round(pgls_summary$r.squared, 4)
    pgls_pval = as.numeric(round(pgls_summary$coefficients[,4][2], 4))

    
  }
}



stats_df






# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
##PGLS analysis (OU model)

pglstree <- read.tree("27.nwk")

for (TRAIT in the.other.traits){
  for (DIVE.TRAIT in the.diving.traits){
    
    temp.TRAIT.df <- cbind(the.traits[, c("Species_name", TRAIT, DIVE.TRAIT)])
    colnames(temp.TRAIT.df) <- c("Species_name", TRAIT, DIVE.TRAIT) 
    
    # delete NA
    temp.TRAIT.df <- temp.TRAIT.df[complete.cases(temp.TRAIT.df), ] 
    
    temp.TRAIT.df[, TRAIT] <- log10(temp.TRAIT.df[, TRAIT])
    temp.TRAIT.df[, DIVE.TRAIT] <- log10(temp.TRAIT.df[, DIVE.TRAIT])

    ou_model <- gls( as.formula(paste(DIVE.TRAIT, "~", TRAIT)), correlation = corMartins(value = 1, phy = pglstree, form = ~Species_name),data = temp.TRAIT.df, method = 'ML')
    summary(ou_model)
  }
}
