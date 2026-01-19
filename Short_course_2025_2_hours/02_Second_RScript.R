
#-----------------------------------------------------------------------------
# 2. lesson

#-----------------------------------------------------------------------------
# First: homework discussion


#-----------------------------------------------------------------------------
# Variable / Value / Data types in R

# Values can have different properties:
# • letters / text:         character, chr
# • categorical:            factor, fct
# • ordered categorical:    ordered factor, fct
# • logical (TRUE/FALSE):   logical,logi
# • continuous numbers:     numeric, num
# • whole numbers:          integer, int
# • ...

# You can transfer them with
# as.factor(), as.numeric(), as.integer(), etc.
# or tidyverse: as_factor(), etc.

data(mpg)

# 1) base R:

mpg_fac <- mpg

mpg_fac$class <- as.factor(mpg_fac$class)

levels(mpg_fac$class)

# change order of categories:
mpg_fac$class <- factor(mpg_fac$class, 
levels = c("2seater","subcompact","compact","midsize",
           "suv","minivan","pickup"))

levels(mpg_fac$class)


# 2) tidyverse:

mpg_fac <- mpg %>% mutate(class = as_factor(class))

levels(mpg_fac$class)

# change order of categories:
mpg_fac <- mpg %>% mutate(class = factor(class, levels = c("2seater","subcompact",
                                                           "compact","midsize",
                                                           "suv","minivan","pickup")))

levels(mpg_fac$class)


# -----------------------------------------------------------------------------
# Graphics with ggplot 2

library(ggplot2)

# - complex graphic are composed of single elements joined by + (end of line)
# - automatic and self-made legends and labels
# - easy to show grouped / clustered data
# - by faceting dividing onto several graphic parts possible
# - using jitter and co., you can visualize data that lie at the same place

# Points: geom_point()
# Lines: geom_line() i.e., connect points sorted by the size of x and y
# Paths: geom_path() i.e., connect points according to the order in the dataset
# Bars: geom_bar() for the popular bar chart
# Error bars, confidence intervals: geom_errorbar()
# Histograms: geom_histogram()
# Boxplots: geom_boxplot()
# Lines/segments: geom_segment()
# Irregular shapes: geom_polygon(), e.g., for maps
# Rasterized areas: geom_tile()


# Examples:

# Iris dataset 

data(iris)
str(iris)
dim(iris)[1]
dim(iris)[2]

# boxplots per Species for e.g. Petal.Length

# basic function ggplot(), dataset, x- and y-coordinates:

ggplot(data=iris, mapping=aes(y=Petal.Length, x=Species)) + 
  geom_boxplot(aes(fill=Species)) +
  theme_bw()

# points, Sepal.Length on x, Sepal.Width on y

ggplot(data=iris, mapping=aes(y=Sepal.Length, x=Petal.Length)) + 
  geom_point() +
  theme_bw()

# points, Petal.Length on x, Sepal.Length on y, faceted over Species

# There are two main functions for faceting:
# facet_grid()
# e.g. facet_grid(~FactorA), facet_grid(~ FactorA + FactorB)
# facet_wrap()
# e.g. facet_wrap(FactorA + FactorB): FactorA in rows, FactorB in cols


ggplot(data=iris, mapping=aes(y=Sepal.Length, x=Petal.Length)) + 
  geom_point() +
  theme_bw() +
  facet_wrap(~Species)

# Another example:

library(nlme)
data(Oats)

ggplot(data=Oats, mapping=aes(y=yield, x=nitro)) + geom_boxplot() +
  geom_point(mapping = aes(color=Block)) + 
  facet_wrap(~Variety)

# ggplot needs nitro to be a factor for creating the boxplots
Oats$nitro <- factor(Oats$nitro)
str(Oats$nitro)

ggplot(data=Oats, mapping=aes(y=yield, x=nitro)) + geom_boxplot() +
  geom_point(mapping = aes(color=Block)) + 
  facet_wrap(~Variety)

# Add even more stuff
ggplot(data=Oats, mapping=aes(y=yield, x=nitro)) + geom_boxplot() +
  geom_point(mapping = aes(color=Block)) + 
  geom_line(mapping = aes(color=Block, group = Block:Variety)) +
  facet_wrap(~Variety)

# Jittering:
# Jittering is useful when you have a discrete position, and a relatively
# small number of points

ggplot(mpg, aes(class, hwy)) +
  geom_boxplot(colour = "grey50") +
  geom_jitter()

ggplot(mpg, aes(class, hwy)) +
  geom_boxplot(colour = "grey50") +
  geom_point(position = position_jitter(width = 0.1, height = 0.1, seed = 0))

# jitter = random
# dodge = next to each other
# stack = above each other

ggplot(mpg, aes(class, hwy)) +
  geom_boxplot(colour = "grey50") +
  geom_point(position = position_jitter(width = 0.1, height = 0.1, seed = 0)) +
  ylab("Highway miles per gallon") + xlab("Type of car") +
  ggtitle("Boxplots of Highway per gallon per car type")



# -----------------------------------------------------------------------------
# Coding principles:

# 1.) DRY ("Don't repeat yourself") principle
# Avoid duplicating code by copy-pasting in the same script
# -> more maintainable,  
#    (if you want to change something or debug, then you need to change only in one place)
# -> more consistent, 
# -> less error-prone 
#    (you can make the error only in one place)
# Long scripts full of duplicated code make it hard for somebody else 
# or your future self to overlook and understand the code

# How to avoid duplication:
# Think of functions instead of manually repeating:
# e.g. mean(x) instead of x[1] + x[2] + x[3]
# If there is no R function or you have to repeat the same set of functions several 
# times, create your own function or use loops or apply (not in this course)

# 2.) comments (#) should not describe what is done (until it is very complex)
#     but rather WHY it is done. Someone else or your future self can figure out 
#     what is done when looking at the code, but not the why.

# 3.) names of objects should explain what is inside, 
#     e.g. epi_dat contains an epidemiological dataset


# Remember homework:

iris_mm_setosa <- iris %>% 
  mutate(Sepal.Length.mm = Sepal.Length*10,
         Sepal.Width.mm = Sepal.Width*10,
         Petal.Length.mm = Petal.Length*10,
         Petal.Width.mm = Petal.Width*10) %>%
  filter(Species == "setosa")

# Example of reducing duplication with for-loop:
# loop over all rows and the first 4 columns of iris
# to convert values to mm

iris_mm_setosa <- iris

for(i in 1:dim(iris)[1]){
  
  for(j in 1:4){
    
    iris_mm_setosa[i,j] <- iris_mm_setosa[i,j] * 10
    
  }
}

# Or: 
# For each (numeric) variable, create new variable with same name plus ".mm"
# and same values but * 10 with tidyverse

# a)

iris_mm_setosa <- iris %>%
  mutate(
    across(
      .cols = where(is.numeric),
      .fns  = ~ .x * 10,
      .names = "{.col}.mm"
    )
  ) %>%
  filter(Species == "setosa")

# b) 
# If there would be more numeric variables that you would not want to convert

vars_to_scale <- c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")

iris_mm_setosa <- iris %>%
  mutate(
    across(
      all_of(vars_to_scale),
      ~ .x * 10,
      .names = "{.col}.mm"
    )
  ) %>%
  filter(Species == "setosa")


#-----------------------------------------------------------------------------
# Other useful functions in tidyverse:

across()
matches()
case_when()
case_match()
if_else()
all_of()
any_of()

#-----------------------------------------------------------------------------
# Outlook / Further learning:

# Learning about working with strings (text in chr and fct variables within the 
# double quotes "") is very useful: https://r4ds.had.co.nz/strings.html

chr_var <- c("Märkte", "älter", "Lämmer", "Hallo", "Klasse")

library(stringr)

str_detect(chr_var, "ä")

str_replace_all(chr_var, "ä", "ae")

# Learn more about loops, apply-functions, creating own functions

# Look up the above listed tidyverse functions


# Merging two datasets:

# base R

?merge

# tidyverse

?left_join
?right_join
?full_join
?inner_join

# To join on different variables between x and y, use a join_by() specification. 
# For example, join_by(a == b) will match x$a to y$b:
# full_join(data1, data2, by = join_by(a == b))

# To join by multiple variables, use a join_by() specification with multiple 
# expressions. For example, join_by(a == b, c == d) will match x$a to y$b and 
# x$c to y$d. If the column names are the same between x and y, you can shorten 
# this by listing only the variable names, like join_by(a, c):
# full_join(data1, data2, by = join_by(a, c))

