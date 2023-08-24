library(dplyr)
library(readr)
library(glmnet)
library(caret)

# This script contains an example of the codes used to perform elastic net regression for the derivation of the BMI-protein signature and WC-protein signature

#-------------------------------------------------------------------------------------
# Feature Selection Using Elastic Net Regression
#-------------------------------------------------------------------------------------

#read in mock data
setwd("C:/Users/proteomics_of_adiposity") # change file path accordingly

dat <- read_csv("data/dat.csv")
protein_list_bmi <- read_csv("data/shortlisted_bmi_proteins.csv")
protein_list_waist <- read_csv("data/shortlisted_waist_proteins.csv")

# dat = training dataset, dataframe containing all the required variables including BMI, WC, and protein abundance that has been log2 transformed and winsorized at 5 SD 
# protein_list_bmi = dataframe containing the IDs of the proteins (column names in dat) shortlisted for the BMI protein signature 
# protein_list_waist = dataframe containing the IDs of the proteins (column names in dat) shortlisted for the WC protein signature 


#-------------------------------------------------------------------------------------
# Deriving the BMI-protein signature
#-------------------------------------------------------------------------------------

# Prepare matrices for elastic net regression
y_bmi <- dat %>% 
  select(bmi) %>% 
  as.matrix()
x_bmi <- dat %>% 
  select(all_of(protein_list_bmi$shortlisted_bmi_proteins)) %>% 
  as.matrix()


control <- trainControl(method = "repeatedcv",
                        number = 10,
                        repeats = 100,
                        search = "random",
                        verboseIter = F)



# setting seed for reproducibility
set.seed(123)
elastic_model_bmi <- train(bmi ~ .,
                           data = cbind(y_bmi, x_bmi),
                           method = "glmnet",
                           tuneLength = 25,
                           trControl = control)


# extract coefficients and export
best_model_bmi <- as.data.frame(as.matrix(coef(elastic_model_bmi$finalModel, elastic_model_bmi$bestTune$lambda)))
bmi_signature<-cbind(seq = rownames(best_model_bmi), best_model_bmi)
colnames(bmi_signature) <- c("protein_id","beta")

dir.create("output") #create output folder if it does not already exist
write.csv(bmi_signature,"output/weights_bmi_signature.csv",row.names = F)

#-------------------------------------------------------------------------------------
# Deriving the WC-protein signature
#-------------------------------------------------------------------------------------

y_waist <- dat %>% 
  select(waist) %>% 
  as.matrix()
x_waist <- dat %>% 
  select(all_of(protein_list_waist$shortlisted_waist_proteins)) %>% 
  as.matrix()


control <- trainControl(method = "repeatedcv",
                        number = 10,
                        repeats = 100,
                        search = "random", 
                        verboseIter = F)

# setting seed for reproducibility
set.seed(123)
elastic_model_waist <- train(waist ~ .,
                             data = cbind(y_waist, x_waist),
                             method = "glmnet",
                             tuneLength = 25,
                             trControl = control)


# extract coefficients and export
best_model_waist <- as.data.frame(as.matrix(coef(elastic_model_waist$finalModel, elastic_model_waist$bestTune$lambda)))
waist_signature<-cbind(seq = rownames(best_model_waist), best_model_waist)
colnames(waist_signature) <- c("protein_id","beta")
write.csv(waist_signature,"output/weights_wc_signature.csv",row.names = F)

