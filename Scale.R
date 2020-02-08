#--- Scale the inputs (each column should have mean 0 and variance 1)------------------------------------------
#' Scale the inputs function.
#' @description subtracting away the mean and then dividing by the standard deviation of each column
#' 
#' @param X Matrix of numeric inputs.
#' @return Vector of 

Scale <- function(x, mean.val=NA) {
  if(is.matrix(x)) return(apply(x, 2, Scale, mean.val=mean.val))
  if(is.data.frame(x)) return(data.frame(apply(x, 2, Scale, mean.val=mean.val)))
  if(is.na(mean.val)) mean.val <- mean(x)
  sd.val <- sd(x)
  if(all(sd.val == 0)) return(x) # if all the values are the same
  (x - mean.val) / sd.val 
}
