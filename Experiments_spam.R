#--- Experiments/application: run your code on the following data sets------------------------------------------

#loading data
spam <- read.table('spam.data.txt',sep='',header = F)
SAheart <- read.table('SAheart.data.txt',sep=',',header = T)
zip.train <- read.table('zip.train',sep='')

#loading function
source("GradientDescent.R") # solve method for variance matrices
source("Scale.R") # solve method for variance matrices


#split X,y
num.features <- ncol(spam)
num.samples <- nrow(spam)

X <- spam[,-num.features]
y <- spam[,num.features]

#First scale the inputs (each column should have mean 0 and variance 1)
X <- Scale(X)

#Second, randomly split the data into 60% train, 20% validation, 20% test.
m <- num.samples;split <- sample(rep(c("train", "validation", "test"), m*c(0.6, 0.2, 0.2)))
train_X <- X[split=='train',]
test_X <- X[split=='test',]
validation_X <- X[split=='validation',]

train_y <- y[split=='train']
test_y <- y[split=='test']
validation_y <- y[split=='validation']

rbind(test=table(test_y),
      train=table(train_y),
      validation=table(validation_y))

#Use GradientDescent on train data to compute a learned weightMatrix.
weightMatrix <- GradientDescent(train_X,train_y,stepSize = 0.05,maxIterations = 500)
#summary(glm(y ~.+0, family = binomial, data=data.frame(train_X,y=train_y)))

#Multiply train and validation inputs with weightMatrix to obtain a matrix of predicted values 
train_h <-  1/(1+exp(- as.matrix(train_X) %*% weightMatrix))
validation_h <-  1/(1+exp(- as.matrix(validation_X) %*% weightMatrix))

#error rate (percent incorrectly predicted labels) and logistic loss
train_err <- colMeans((train_h >= 0.5) != train_y)
validation_err <- colMeans((validation_h >= 0.5) != validation_y)

train_J <- (-t(train_y)%*%log(train_h)-t(1-train_y)%*%log(1-train_h))/length(train_y)
validation_J <- (-t(validation_y)%*%log(validation_h)-t(1-validation_y)%*%log(1-validation_h))/length(validation_y)


#Plot error rate (percent incorrectly predicted labels) and logistic loss as a function of number of iterations, separately for each set (black line for train, red line for validation)
m <- ncol(weightMatrix)
df2 <- data.frame(set=rep(c("train", "validation"),c(m,m)),
                  iterations=c(seq(1,m),seq(1,m)),
                  error_rate=c(train_err,validation_err),
                  logistic_loss=c(train_J,validation_J))
library(ggplot2)

p_err <- ggplot(df2, aes(x=iterations, y=error_rate, group=set)) +
  geom_line(aes(color=set)) + 
  theme_minimal() + 
  theme(legend.position="top")
p_err + scale_color_manual(values=c("#000000", "#D55E00")) + 
  geom_point(size = 1.5, aes(which.min(train_err), min(train_err)),color="#000000") +
  geom_text(aes(x = which.min(train_err) * 1.05, y = min(train_err)+0.1, label = which.min(train_err))) +
  geom_point(size = 1.5, aes(which.min(validation_err), min(validation_err)),color="#D55E00") + 
  geom_text(aes(x = which.min(validation_err) * 1.05, y = min(validation_err)+0.1, label = which.min(validation_err)))
  

p_logL <-ggplot(df2, aes(x=iterations, y=logistic_loss, group=set)) +
  geom_line(aes(color=set)) + 
  theme_minimal() + 
  theme(legend.position="top")
p_logL + scale_color_manual(values=c("#000000", "#D55E00")) + 
  geom_point(size = 1.5, aes(which.min(train_J), min(train_J)),color="#000000") +
  geom_text(aes(x = which.min(train_J) * 1.05, y = min(train_J)+0.1, label = which.min(train_J))) +
  geom_point(size = 1.5, aes(which.min(validation_J), min(validation_J)),color="#D55E00") + 
  geom_text(aes(x = which.min(validation_J) * 1.05, y = min(validation_J)+0.1, label = which.min(validation_J)))



#Make a table of error rates with three rows (train/validation/test sets) and two columns (logistic regression and baseline)
m_minimizes <- which.min(validation_err)
weightVector <- weightMatrix[,m_minimizes]

train_pred <- 1/(1+exp(- as.matrix(train_X) %*% weightVector))
test_pred <- 1/(1+exp(- as.matrix(test_X) %*% weightVector))
validation_pred <- 1/(1+exp(- as.matrix(validation_X) %*% weightVector))

train_baseline <-rep(mean(train_y) >0.5,length(train_y))
test_baseline <- rep(mean(test_y) >0.5,length(test_y))
validation_baseline <- rep(mean(validation_y) >0.5,length(validation_y))

train_pred_err <- mean((train_pred>0.5) != train_y)
test_pred_err <- mean((test_pred>0.5) != test_y)
validation_pred_err <- mean((validation_pred>0.5) != validation_y)

train_basel_err <- mean(train_baseline != train_y)
test_basel_err <- mean(test_baseline != test_y)
validation_basel_err <- mean(validation_baseline != validation_y)

#Make a table of error rates with three rows (train/validation/test sets) and two columns (logistic regression and baseline)
table_err <- data.frame('logistic regression' = c(train_pred_err,test_pred_err,validation_pred_err),
                        'baseline' = c(train_basel_err,test_basel_err,validation_basel_err),
                        row.names = c('train sets','validation sets','test sets'))

#For each model (logistic regression and baseline), compute the Receiver Operating Characteristic (ROC) curve of the predictions with respect to the test set.
library(plotROC)
test <- data.frame(y = test_y, 
                   Logistic_Regression =test_pred , Baseline = test_baseline, stringsAsFactors = FALSE)

longtest <- melt_roc(test, 'y', c("Logistic_Regression", "Baseline"))

ggplot(longtest, aes(d = D, m = M, color = name)) + geom_roc() + style_roc() + 
  xlab("FPR") + ylab("TPR") + 
  scale_x_continuous(expand = c(0, 0)) + scale_y_continuous(expand = c(0, 0)) + 
  ggpubr::theme_classic2() + 
  theme(legend.position="top")
