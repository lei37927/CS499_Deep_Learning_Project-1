#--- do the random train/validation/test split three times for each data set------------------------------------------

#loading function
source("GradientDescent.R") # solve method for variance matrices
source("Scale.R") # solve method for variance matrices

#load data
dataSet <- c('spam','SAheart','zip.train')[1]

switch(dataSet,
       'spam'={
         dataset <- read.table('spam.data.txt',sep='',header = F)
         num.features <- ncol(dataset)
         num.samples <- nrow(dataset)
         
         X <- dataset[,-num.features]
         y <- dataset[,num.features]
       },
       'SAheart'={
         dataset <- read.table('SAheart.data.txt',sep=',',header = T)
         num.features <- ncol(dataset)
         num.samples <- nrow(dataset)
         
         X <- dataset[,-num.features]
         y <- dataset[,num.features]
       },
       'zip.train'={
         dataset <- read.table('zip.train',sep='')
         dataset <- dataset[dataset$V1 <= 1,]
         num.features <- ncol(dataset)
         num.samples <- nrow(dataset)
         
         X <- dataset[,-1]
         y <- dataset[,1]
       }
       )



#First scale the inputs (each column should have mean 0 and variance 1)
X <- Scale(X)

#Second, randomly split the data into 60% train, 20% validation, 20% test.
Split <- function(X,y){
  m <- nrow(X) #num.samples
  split <- sample(rep(c("train", "validation", "test"), m*c(0.6, 0.2, 0.2)))
  
  train_X <- X[split=='train',];  train_y <- y[split=='train']
  test_X <- X[split=='test',];  test_y <- y[split=='test']
  validation_X <- X[split=='validation',];  validation_y <- y[split=='validation']
  
  print(rbind(test=table(test_y), train=table(train_y), validation=table(validation_y)))
  out <- list(train_X=train_X,test_X=test_X,validation_X=validation_X,
              train_y=train_y,test_y=test_y,validation_y=validation_y)
  return(out)
}

#
Modling <- function(X,y){
  out <- Split(X,y)
  train_X <- out$train_X; train_y <- out$train_y
  test_X <- out$test_X; test_y <- out$test_y
  validation_X <- out$validation_X; validation_y <- out$validation_y
  
  #
  weightMatrix <- GradientDescent(train_X,train_y,stepSize = 0.05,maxIterations = 500)
  
  validation_h <-  1/(1+exp(- as.matrix(validation_X) %*% weightMatrix))
  validation_err <- colMeans((validation_h >= 0.5) != validation_y)
  
  m_minimizes <- which.min(validation_err)
  weightVector <- weightMatrix[,m_minimizes]
  
  #
  train_pred <- 1/(1+exp(- as.matrix(train_X) %*% weightVector))
  test_pred <- 1/(1+exp(- as.matrix(test_X) %*% weightVector))
  validation_pred <- 1/(1+exp(- as.matrix(validation_X) %*% weightVector))
  
  train_baseline <-rep(mean(train_y) >0.5,length(train_y))
  test_baseline <- rep(mean(test_y) >0.5,length(test_y))
  validation_baseline <- rep(mean(validation_y) >0.5,length(validation_y))
  
  out <- list(test_y=test_y,
              test_pred=test_pred,
              test_baseline=test_baseline)
  return(out)
}


#---main ----------
library(plotROC)
longtest <- replicate(3,expr = {
  out <- Modling(X,y)
  test <- data.frame(y = out$test_y, Logistic_Regression =out$test_pred ,
                     Baseline = out$test_baseline, stringsAsFactors = FALSE)
  longtest <- melt_roc(test, 'y', c("Logistic_Regression", "Baseline"))
}, simplify = FALSE)


p<-ggplot(longtest[[1]], aes(d = D, m = M, color = name)) + geom_roc() + style_roc() + 
  xlab("FPR") + ylab("TPR") + 
  scale_x_continuous(expand = c(0, 0)) + scale_y_continuous(expand = c(0, 0)) + 
  ggpubr::theme_classic2() + 
  theme(legend.position="top")

p + geom_roc(data=longtest[[2]], aes(d = D, m = M, color = name)) +
  geom_roc(data=longtest[[3]], aes(d = D, m = M, color = name))
