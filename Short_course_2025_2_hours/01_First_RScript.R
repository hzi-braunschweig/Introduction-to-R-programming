
# 1.) Install R and R Studio

# https://posit.co/download/rstudio-desktop/

# 2.) This is an R script 
# which is used to store your programming code and comments 
# comments start with hashtag #, these are not analysed as programming code by R

# Running code in the console: click enter
# Run a line of code in an R script: click "Run" or ctrl + enter (command + enter on mac)
# Run several lines of code in an R script by highlighting them before

# Calculator:

345 + 5

60/5*10

abs(-3)
# abs() is a "function", and you put in "-3", so the function is applied on "-3":
# the absolute value of "-3" is 3


# -----------------------------------------------------------------------------
###  R objects

# Assigning a value to an object with an arrow:

x <- 5

# "x" is the name of the object
# Object names are not allowed to start with a number

x
# variable x is equal to 5
# tip: by clicking Alt and Minus[-], the assigning arrow with spaces is inserted

x <- 10

# If something else is assigned to the same name, the former object is overwritten
x

x + 20

# create a vector object:

y <- c(-12, -4, 0, 3, 6)

# functions/calculations are automatically done element wise 
# if they take one value into account:

y - 5
abs(y)

# -----------------------------------------------------------------------------
### R functions


# Other functions take all values, like taking the mean:
mean(y)

# Managing Not Available NA values
(y <- c(y, NA))

mean(y)
mean(x = y, na.rm = TRUE)
# x and na.rm are arguments of the function mean()

seq(from = 1, to = 10, by = 0.5)
seq(1, 10, 0.5)
# If you do not give the argument names, the inputs are assigned 
# to the arguments in the specified order

z <- seq(1, 10, 0.5)

# Get 5th value in vector z
z[5]

# Subset vector z based on the condition "z > 5"

which(z > 5)
z > 5

z[z > 5]

# -----------------------------------------------------------------------------

## Help in R
# If you do not know / forget package names, function names, arguments, application

# 3 Search methods:
# 1.) help for a known function
#     ?function-name or help(function-name) lets a help-page appear
?mean
help(mean)

?seq

# In "Usage", the default arguments and their order are displayed:
# here: if you do not set the argument "na.rm", it will be FALSE by default

# In "Arguments", the arguments and appropriate inputs are explained 

# In "Value", the output structure is explained


# 2.) You know the package name and not the function: help for a package
help(package="tidyverse")

#------------------------------------------------------------------------------
# objects for data storage: data.frames, lists, tibbles

# 1.) Data frame

data()
# gives you a list of data sets provided by R

data(mtcars)

str(mtcars)

# This is a data frame

# With help of brackets, you can subset a data frame:
# dataframe[row, column]

mtcars[,2]
# gives you the second column

mtcars[2,]
# gives you the second row

mtcars[2,2] 
# gives you the value in row 2, column 2

# columns can also be extracted with $column_name:
mtcars$cyl


# 2.) Tibble
# Tibbles are from the tidyverse package and the "modern" form of base R's data.frame

#------------------------------------------------------------------------------
# Excurse: Import data files

# If you have data stored somewhere (e.g. as excel, csv, txt),
# you can read them in with specific functions:

# Read in excel files for example with
# R package readxl from tidyverse 

# tidyverse is a big R package for data wrangling

# install.packages("readxl")
library(readxl)
# Additional functions created by R developers 
# after initial R functionality are stored in R packages

?read_excel
# ?function-name lets a help-page appear

epi_dat <- read_xlsx("U:\\Introduction to R\\Introduction-to-R-programming\\Short_course_2025_2_hours\\simple_epidemiology.xlsx")
# path where the data is stored plus name of data file, 
# separations with \\ or /

str(epi_dat)
# epi_dat is a "tibble": an advanced form of data frame from the tidyverse package

# -> read_xlsx gives a tibble

# other reading-in functions from tidyverse: 
# read_delim, 
# read_csv (reads comma-delimited files per default), 
# read_csv2 (reads semicolon-delimited files per default);
# these give tibbles

# Base R functions:
# read.csv for csv files (reads comma-delimited files per default)
# read.csv2 for german version of csv files (reads semicolon-delimited files per default)
# read.table for txt files

#------------------------------------------------------------------------------

str(epi_dat)

# Differences to data.frame:

# Printing a tibble into the console shows only first rows and columns - 
# data frame would give all the data
epi_dat

epi_dat[,2]
# Subsetting a tibble to a column by brackets gives another tibble -
# data frame gives a vector

# Leads to changing behaviour with base R functions:
mean(epi_dat[,2])
# mean() expects a vector

# But you can use $ subsetting for giving a vector:
epi_dat$age

mean(epi_dat$age)


# 3.) Lists

empId = c(1, 2, 3, 4) 
empName = c("Hans", "Franz", "Anna", "Kirsten")
numberOfEmp = 4

empList = list(empId, empName, numberOfEmp)

print(empList)

# Get element 2 of the list:

empList[[2]]

# Get the inner component 3 in the element 2 of the list:

empList[[2]][3]

# Named list
empList_named = list(Id = empId, name = empName, count = numberOfEmp)

print(empList_named)

# Get named element "count" of the list:
empList_named$count

#------------------------------------------------------------------------------
# Data wrangling

View(mtcars)

library(tidyverse)
# very good package for data wrangling
# consists of 8 core packages (listed when loading the package)

# average number of cylinders
mean(mtcars$cyl)

mtcars$cyl[2] <- NA

mean(mtcars$cyl, na.rm = TRUE)
# If your data contains missing values, use na.rm argument

# Data wrangling with tidyverse package

# Data set mpg

library(ggplot2)
data(mpg)
?mpg
View(mpg)

glimpse(mpg)

str(mpg)

# mpg is a tibble


# 1. filter the data

# filter the data to "city miles per gallon" above 20:

filter(mpg, cty >= 20)
# this will print the filtered data into the console

# Instead, store it in a new object:
mpg_sub_cty20 <- filter(mpg, cty >= 20)

mpg_audi <- filter(mpg, manufacturer == "audi")

mpg_cty20_audi <- filter(mpg, cty >= 20 & manufacturer == "audi")


# 2. create a new variable

mpg_metric <- mutate(mpg_cty20_audi, cty_km_l = 0,425144*cty)


# 3. The pipe

# If you want to do several data wrangling steps on the same datset,
# instead of saving each step into a new datset, you can use the "pipe":
# the pipe %>% can tie several functions together

mpg_wrangle <- mpg %>%
  filter(manufacturer == "audi") %>%
  mutate(cty_km_l = 0,425144*cty)

# mpg is given by the pipe into the first argument of filter, so that I do not 
# have to write mpg into the first argument explicitly, just leave out the first argument.
# Next, the output of filter() is given by the pipe into the first argument of mutate.
# In the end, the output is assigned to mpg_wrangle.


# 4. arrange data in the order of a variable values

mpg %>%
  arrange(cty)


# 5. Summarize a dataset

mpg %>%
  group_by(class) %>%
  summarise(mean(cty),
            sd(cty))
  

#------------------------------------------------------------------------------
# Homework in Rmd script

# Fill in your code into the code chunks
# To run the code, you can use Ctrl + Enter as always,
# or for running the whole chunk, 
# either use "Run" = the arrow at top of the chunk,
# or Ctrl + Shift + Enter



