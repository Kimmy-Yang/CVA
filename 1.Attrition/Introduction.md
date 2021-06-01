# Background: #
### :briefcase: Attrition in a Company ###
Employees are the key to company. Employee attrtion refers to a gradual but deliberate reduction in staff number due to employees retire or resign. Yet, it is not replaced, as an employer will not fill the vacancy left by the former employee. Frequently, from an organizationl perspective, high employee attrtion rate is not ideal, because it:
  * wastes the cost in recruiting, assesing, hiring and training the person
  * makes company loss the experienced employees
  * lows workplace morale
  
By analyzing and predicting the attrtion, the company can know why employees leave the company and identify potential actions to reduce employee attrtion.

# Objectives #
### :mag_right: Why employees leave? ###
The objectives include :
  * Investigate the factors drive to employee attrtion
  * Predict employee attrtion
  * Discuss how to use the predcition results in practice

# Methodology #
* logistic regression
* Random forest

# :one: An overview of the dataset #

<details>
  <summary>import dataset & split training and testing data</summary>
 
```{r, echo = FALSE}
library(readr)
library(caret)
library(ggplot2)
```
### 1.1 Loading the data set ###
```{r, echo = FALSE}
Employee_attrition_dataset <- read_csv("Employee attrition dataset.csv")
View(Employee_attrition_dataset)
```
### 1.2 Check for missing data ###
```{r, echo = FALSE}                             
sum(is.na(Employee_attrition_dataset))
```
### 1.3 Data split to training and testing ###
I took 80% for the training part
```{r, echo = FALSE}                             
set.seed(31)
indeces <- sample(nrow(Employee_attrition_dataset),nrow(Employee_attrition_dataset)*0.8)

train <- Employee_attrition_dataset[indeces,]
test <- Employee_attrition_dataset[-indeces,]

summary(train)
names(train)
```
</details>

<details>
  <summary> Overview training </summary>
 
 ```{r, echo = FALSE} 
 
attrition_frame <- data.frame(
  group=c('True','False'),
  value=c(sum(train$attrition==TRUE),
          sum(train$attrition==FALSE))
)
ggplot(attrition_frame,aes(x="", y=value, fill=group,)) +
  geom_bar(stat="identity", width=1)+
  coord_polar("y", start=0) +
  scale_fill_manual( values = c( "#E46726","#6D9EC1")) +
  theme_bw()
 ```
 </details>
