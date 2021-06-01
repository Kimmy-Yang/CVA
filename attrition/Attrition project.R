
library(readr)
library(caret)

# 1.1 Loading the data set
Employee_attrition_dataset <- read_csv("Employee attrition dataset.csv")
# View(Employee_attrition_dataset)

# 1.2 Check for missing data
sum(is.na(Employee_attrition_dataset))

# 1.3 Data split to training and testing 
# I took 80% for the training part
set.seed(31)
indeces <- sample(nrow(Employee_attrition_dataset),nrow(Employee_attrition_dataset)*0.8)

train <- Employee_attrition_dataset[indeces,]
test <- Employee_attrition_dataset[-indeces,]

summary(train)
names(train)

## Q1: why employees leave the company and identify potential actions to reduce employee attrition.

# 2.1 I first check how different factors correlate with each other, 
# I cleaned the categorical and binary data out

train_a <- train[c(1:2,5:10)]
#View(train_a)

(correlations <- cor(train_a))


# interactive visualization
library(ggcorrplot)

ggcorrplot(correlations,method="circle",
           ggtheme = ggplot2::theme_bw,
           colors = c("#6D9EC1", "white", "#E46726")) +
  labs(title="Variables Correlation")

# Key insight:
#attrition positively correlates with overtime, 
# but negatively with performance, training spend and boss rating


#2.2 Build logistic regression, because of categorical dependent variable
# note that the variables attrition and gender_male are Boolean, 
# as the function treats these as binary, 
# and as the variables education_level and job_title are factors, 
# so it treats each level as a separate variable with Boolean values.
fit_logistic <- glm(attrition ~., family=binomial(logit),
                    data = train, maxit=1000)
summary(fit_logistic)

fit_logistic1 <- glm(attrition ~.-job_title - gender_male - salary, family=binomial(logit),
                     data = train, maxit=1000)
summary(fit_logistic1)

sig_coeff <- fit_logistic$coefficients[ summary(fit_logistic)$coefficients[,4] < .05]
sig_coeff
sig_coeff <- data.frame(b=round(sig_coeff,2), exp_b=round(exp(sig_coeff),2)); sig_coeff



tr_d <- train
te_d <- test

tr_d$seniority <- tr_d$job_title == "Lead designer" | tr_d$job_title == "Lead developer" | tr_d$job_title == "Principal consultant" | tr_d$job_title == "Senior designer" | tr_d$job_title == "Senior developer"
te_d$seniority <- te_d$job_title == "Lead designer" | te_d$job_title == "Lead developer" | te_d$job_title == "Principal consultant" | te_d$job_title == "Senior designer" | te_d$job_title == "Senior developer"
tr_d <- tr_d[,-4]
te_d <- te_d[,-4]
#View(tr_d)
tr_d$performance_rating <- as.factor(tr_d$performance_rating)
te_d$performance_rating <- as.factor(te_d$performance_rating)
# tr_d$salary <- as.factor(tr_d$salary)
# View(tr_d)

fit_logistic2 <- glm(attrition ~ . - gender_male - salary, family = binomial(logit), data= tr_d, maxit=1000)
summary(fit_logistic2)

fit_logistic3 <- glm(attrition ~ . - gender_male - salary - seniority, family = binomial(logit), data= tr_d, maxit=1000)
summary(fit_logistic3)


## Q2: Predict employee attrition
# Check the prediction for the 3rd model
predictions_logistic <-  predict(fit_logistic3, newdata = te_d, type = 'response')
head(round(predictions_logistic,4))
head(te_d$attrition)


#confusion matrix
(conf_matrix <- confusionMatrix(as.factor(te_d$attrition==1), 
                                data=as.factor(predictions_logistic > 0.5), positive="TRUE") )
(ctable <-  conf_matrix$table)

# visualization
fourfoldplot(ctable, color = c("#CC6666", "#99CC99"),
             conf.level = 0, margin = 1, main = "Confusion Matrix")


#comparing with other models
predictions_logistic_original <-  predict(fit_logistic, newdata = test, type = 'response')

(conf_matrix_original <- confusionMatrix(as.factor(test$attrition==1), 
                                data=as.factor(predictions_logistic_original > 0.5), positive="TRUE") )

predictions_logistic_1<-  predict(fit_logistic1, newdata = test, type = 'response')
(conf_matrix_1 <- confusionMatrix(as.factor(test$attrition==1),
                                  data=as.factor(predictions_logistic_1>0.5), positive='TRUE'))


## Using some other methods
library(randomForest)

# preprocessing: For the neural network model, we need to do some preprocessing,
#scaling all the variables to rang [0,1]

prep <- preProcess(Employee_attrition_dataset, method="range")
train_scaled <- predict(prep,train)  
test_scaled <-  predict(prep,test)
# View(train)
# View(train_scaled)


# Random Forest

rf_fit <- randomForest(as.factor(Test.Result)~ ., data=train, 
                       method='class',ntree=500)





#sensitivity= true positives/ (true positives + false negatives)
#specificity =  true negatives/ (true negatives+ false positives)

# Recall: 
#Null deviance shows how well the target is predicted with just the intercept and the residual one with the given coefficients.

##( R^2, l, AIC, BIC)
# R^2 the larger the better
# l, goodness of fit using log-likelihood, the larger l (implying the smaller the residual variance), the better the model explains the behavior of the response variable
# Both R^2 and l never decrease when we add predictors to the model. They cannot be dependent on variable selection, as they would always be in favor of adding more variables to the model
# Generally, AIC is Akaike information criterion:
#   Small for simple models (using few variables) that explain the response well (large `).
#   Large for complex models (using many variables) that fail to explain the response (small `).
# the smaller the better

# BIC: Bayesian information criterion, the smaller the better



