#--- Gradient descent for logistic regression------------------------------------------

#' Gradient function.
#' 
#' @param X Matrix of numeric inputs.
#' @param y Vector of binary outputs.
#' @param theta Vector of weight.
#' @return Vector of gradient
Gradient <- function(x, y, theta) {
  gradient <- (1 / nrow(y)) * (t(x) %*% (1/(1 + exp(-x %*% t(theta))) - y))
  return(t(gradient))
}

#' the gradient descent algorithm.
#' @description which iteratively computes linear model parameters that minimize the average logistic loss over the training data.
#' 
#' @param X Matrix of numeric inputs (one row for each observation, one column for each feature).
#' @param y Vector of binary outputs (the corresponding label for each observation, either 0 or 1).
#' @param stepSize (0,1), also known as learning rate.a positive real number that controls how far to step in the negative gradient direction.
#' @param maxIterations positive integer that controls how many steps to take.
#' @return At the end of the algorithm you should return weightMatrix
GradientDescent <- function(x, y, stepSize=0.1, maxIterations=500, threshold=1e-15) {
  
  # Add x_0 = 1 as the first column
  m <- if(is.vector(x)) length(x) else nrow(x)
  #if(is.vector(x) || (!all(x[,1] == 1))) x <- cbind(rep(1, m), x)
  if(is.vector(y)) y <- matrix(y)
  x <- apply(x, 2, as.numeric)
  
  num.features <- ncol(x)
  
  # Initialize the parameters of weight
  ##a variable called weightVector which is initialized to the zero vector (one element for each feature).
  weightVector <- matrix(rep(0, num.features), nrow=1)
  
  ##a variable called weightMatrix of real numbers (number of rows = number of input features, number of columns = maxIterations).
  weightMatrix <- matrix(0, nrow=num.features, ncol=maxIterations)
  weightMatrix[,1] <- weightVector
  
  # Look at the values over each iteration
  for (i in 2:maxIterations) {
    #first compute the gradient given the current weightVector (make sure that the gradient is of the mean logistic loss over all training data)
    gradient <- Gradient(x, y, weightVector)
    
    #then update weightVector by taking a step in the negative gradient direction.
    weightVector <- weightVector - stepSize * gradient
    if(all(is.na(weightVector))) break
  
    #then store the resulting weightVector in the corresponding column of weightMatrix.
    weightMatrix[,i] <-  weightVector
    #if(i > 2) 
    #  if(all(abs(weightVector - weightMatrix[,i]) < threshold)) break 
  }
  
  #At the end of the algorithm you should return weightMatrix.
  return(weightMatrix)
}
