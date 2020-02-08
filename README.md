# CS499_Deep_Learning_Project-1

## Project Description
In this project our goal is to implement the gradient descent algorithm for learning a logistic regression model, and then use it with early stopping regularization to make predictions on several real data sets.

#### Gradient Descent Algorithm
See our implementation of Gradient Descent Algorithm using R language [here](GradientDescent.R).

## How to run it
### 1 Environment Configuration
#### 1.1 Install R
Because the project is written in R language, so it is necessary to have R on your machine.

You can download R [here](https://www.r-project.org/) and install it.

#### 1.2 Install RStudio
This is the easiest way for everyone can run the project.

You can download RStudio [here](https://rstudio.com/products/rstudio/download/#download) and install it.

### 2 Having the project
#### 2.1 Download the project
You can use ```git clone``` to download the project or just click the green button to download a ZIP file.

#### 2.2 Unzip the project
Use any tools you like to unzip the project into the folder you want.

### 3 Run the project
#### 3.1 Set the path
***This is an important step, ignoring this may cause some problems with reading data.***
Open RStudio, in the 'console' command line at the bottom left corner, type
```
setwd('PATH')
```
where PATH is where you unzip all the R and data files on your machine.

WARNING: In your path, use '/' instead of '\'.

#### 3.2 Open R files
Click 'File'->'Open File' at the top left corner, the choose
```
Scale.R
GradientDescent.R
Experiments_spam.R
Extra_Credits.R
```
to open them.

#### 3.3 Run R files
First go to Scale.R, then click the 'run' button in the file section (not the whole window) once, this will run the current line, which is the whole file in this case.

Then go to GradientDescent.R, then click 'run' again until there's nothing running in the console section.

Then go to Experiments_spam.R, then click 'run' until we see the package 'ggplot2' is imported (sorry for the inconvenience), then click twice, and wait for seconds, a graph will show in the bottom right section, showing the relationship between error rate and # of iterations. Click twice more, a graph will show the relationship between logistic loss and # of iterations. Then click to the end, a graph will show ROC curve.

For extra credits, just go to Extra_Credits.R and run from the first line again to the end. At last you will see a graph with one baseline and three differnet models trained from three different data sets.


## About
This is our first group project of CS499 Deep Learning course in Spring 2020 at [NAU](https://nau.edu/)

### Project Requirements
You can find the requirements for this project [here](https://github.com/tdhock/cs499-spring2020/blob/master/projects/1.org)

### Instructor
Dr. T.D.Hocking - [tdhock](https://github.com/tdhock) at [SICCS](https://nau.edu/school-of-informatics-computing-and-cyber-systems/)

### Authors
* Zhenyu Lei - [lei37927](https://github.com/lei37927)
* Jianxuan Yao - [JianxuanA](https://github.com/JianxuanA)

### Copyright ©
Any cloning or downloading before the project due date constitutes an infringement of our intellectual property rights, and after that it goes to open source. For any of the aforementioned infringements, Zhenyu Lei and Jianxuan Yao will report this to the NAU [Academic Integrity Hearing Board](https://in.nau.edu/academic-affairs/academic-integrity/).
