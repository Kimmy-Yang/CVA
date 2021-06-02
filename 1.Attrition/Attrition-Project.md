:mag:Attrition Project :running:
================
Jiaqi Yang
2021/6/1

# I. Summary

### Background:

Employees are the key to a company. Employee attrition refers to a
gradual but deliberate reduction in staff number due to employees retire
or resign. Yet, it is not replaced, as an employer will not fill the
vacancy left by the former employee. Frequently, from an organization
perspective, a high employee attrition rate is not ideal, because it:

-   wastes the cost in recruiting, assessing, hiring, and training the
    person

-   makes the company lose the experienced employees

-   lows workplace morale

By analyzing and predicting the attrition, the company can know why
employees leave the company and identify potential actions to reduce
employee attrition.

### Objectives

-   Investigate the factors that drive employee attrition

-   Predict employee attrition

-   Discuss how to use the prediction results in practice

### Methodology

-   Logistic regression

-   Random forest

# II. Exploratory Data Analysis

    ## Loading required package: lattice

    ## Loading required package: ggplot2

    ## 
    ## Attaching package: 'plyr'

    ## The following object is masked from 'package:ggpubr':
    ## 
    ##     mutate

    ## Type 'citation("pROC")' for a citation.

    ## 
    ## Attaching package: 'pROC'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     cov, smooth, var

    ## randomForest 4.6-14

    ## Type rfNews() to see new features/changes/bug fixes.

    ## 
    ## Attaching package: 'randomForest'

    ## The following object is masked from 'package:ggplot2':
    ## 
    ##     margin

### 2.1 Loading the data set

``` r
Employee_attrition_dataset <- read_csv("Employee attrition dataset.csv")
```

    ## 
    ## -- Column specification --------------------------------------------------------
    ## cols(
    ##   attrition = col_logical(),
    ##   training_spend = col_double(),
    ##   education_level = col_character(),
    ##   job_title = col_character(),
    ##   gender_male = col_logical(),
    ##   performance_rating = col_double(),
    ##   boss_rating_avg = col_double(),
    ##   salary = col_double(),
    ##   overtime_per_week = col_double(),
    ##   traveldays_per_year = col_double(),
    ##   lastpromotion_months = col_double()
    ## )

``` r
head(Employee_attrition_dataset)
```

    ## # A tibble: 6 x 11
    ##   attrition training_spend education_level job_title        gender_male
    ##   <lgl>              <dbl> <chr>           <chr>            <lgl>      
    ## 1 FALSE               1942 MSc or MBA      Business analyst TRUE       
    ## 2 FALSE               2032 BSc             Junior developer TRUE       
    ## 3 TRUE                2115 MSc or MBA      Junior developer FALSE      
    ## 4 FALSE               2028 MSc or MBA      Junior designer  FALSE      
    ## 5 FALSE               1946 MSc or MBA      Associate        FALSE      
    ## 6 TRUE                1743 BSc             Developer        TRUE       
    ## # ... with 6 more variables: performance_rating <dbl>, boss_rating_avg <dbl>,
    ## #   salary <dbl>, overtime_per_week <dbl>, traveldays_per_year <dbl>,
    ## #   lastpromotion_months <dbl>

### 2.2 Check for missing data

``` r
sum(is.na(Employee_attrition_dataset))
```

    ## [1] 0

### 2.3 Data split to training and testing

I took 80% for the training part.

``` r
set.seed(31)
indeces <- sample(nrow(Employee_attrition_dataset),nrow(Employee_attrition_dataset)*0.8)

train <- Employee_attrition_dataset[indeces,]
test <- Employee_attrition_dataset[-indeces,]
```

</details>

## 2.4 Overview

``` r
summary(train)
```

    ##  attrition       training_spend education_level     job_title        
    ##  Mode :logical   Min.   :1238   Length:1720        Length:1720       
    ##  FALSE:1389      1st Qu.:1848   Class :character   Class :character  
    ##  TRUE :331       Median :2008   Mode  :character   Mode  :character  
    ##                  Mean   :2008                                        
    ##                  3rd Qu.:2171                                        
    ##                  Max.   :2823                                        
    ##  gender_male     performance_rating boss_rating_avg     salary     
    ##  Mode :logical   Min.   :1.000      Min.   :1.00    Min.   : 3584  
    ##  FALSE:720       1st Qu.:2.000      1st Qu.:2.30    1st Qu.: 4022  
    ##  TRUE :1000      Median :3.000      Median :3.00    Median : 4419  
    ##                  Mean   :2.974      Mean   :2.96    Mean   : 4980  
    ##                  3rd Qu.:4.000      3rd Qu.:3.60    3rd Qu.: 5606  
    ##                  Max.   :5.000      Max.   :5.00    Max.   :10553  
    ##  overtime_per_week traveldays_per_year lastpromotion_months
    ##  Min.   : 0.000    Min.   : 0.0        Min.   : 0.00       
    ##  1st Qu.: 2.000    1st Qu.:14.0        1st Qu.:12.00       
    ##  Median : 4.000    Median :20.0        Median :18.00       
    ##  Mean   : 4.872    Mean   :20.6        Mean   :18.59       
    ##  3rd Qu.: 7.000    3rd Qu.:27.0        3rd Qu.:25.00       
    ##  Max.   :16.000    Max.   :53.0        Max.   :51.00

``` r
summary(test)
```

    ##  attrition       training_spend education_level     job_title        
    ##  Mode :logical   Min.   :1298   Length:430         Length:430        
    ##  FALSE:351       1st Qu.:1806   Class :character   Class :character  
    ##  TRUE :79        Median :1986   Mode  :character   Mode  :character  
    ##                  Mean   :1989                                        
    ##                  3rd Qu.:2171                                        
    ##                  Max.   :2848                                        
    ##  gender_male     performance_rating boss_rating_avg     salary     
    ##  Mode :logical   Min.   :1.000      Min.   :1.000   Min.   : 3605  
    ##  FALSE:215       1st Qu.:2.000      1st Qu.:2.400   1st Qu.: 4016  
    ##  TRUE :215       Median :3.000      Median :2.900   Median : 4397  
    ##                  Mean   :3.033      Mean   :2.988   Mean   : 4950  
    ##                  3rd Qu.:4.000      3rd Qu.:3.600   3rd Qu.: 5694  
    ##                  Max.   :5.000      Max.   :5.000   Max.   :10604  
    ##  overtime_per_week traveldays_per_year lastpromotion_months
    ##  Min.   : 0.000    Min.   : 0.00       Min.   : 0.00       
    ##  1st Qu.: 2.000    1st Qu.:14.00       1st Qu.:11.00       
    ##  Median : 4.000    Median :20.00       Median :18.00       
    ##  Mean   : 4.949    Mean   :20.95       Mean   :18.03       
    ##  3rd Qu.: 7.000    3rd Qu.:27.00       3rd Qu.:24.00       
    ##  Max.   :17.000    Max.   :48.00       Max.   :43.00

    ## Warning: package 'wesanderson' was built under R version 4.0.5

![](Attrition-Project_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

    ## Warning: package 'ggcorrplot' was built under R version 4.0.5

![](Attrition-Project_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

It can be concluded that attrition positively correlates with overtime,
but negatively with performance, training spends and boss rating.

# III. Logistic regression

### 3.1 Build the model

As there are categorical dependent variables, I build a logistic
regression using the training data set.

``` r
fit_logistic <- glm(attrition ~., family=binomial(logit),
                    data = train, maxit=1000)
summary(fit_logistic)
```

    ## 
    ## Call:
    ## glm(formula = attrition ~ ., family = binomial(logit), data = train, 
    ##     maxit = 1000)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -1.6475  -0.6677  -0.4586  -0.2398   2.8757  
    ## 
    ## Coefficients:
    ##                                 Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept)                    1.7363956  4.1665396   0.417 0.676863    
    ## training_spend                -0.0009460  0.0002869  -3.297 0.000977 ***
    ## education_levelDSc or PhD     -1.2207098  0.6281453  -1.943 0.051973 .  
    ## education_levelMSc or MBA      0.3069033  0.1371203   2.238 0.025208 *  
    ## job_titleBusiness analyst     -0.6143517  1.0845703  -0.566 0.571090    
    ## job_titleConsultant           -0.0408480  2.1008135  -0.019 0.984487    
    ## job_titleDesigner              0.5663419  0.6106653   0.927 0.353710    
    ## job_titleDeveloper             0.9054075  0.5709740   1.586 0.112802    
    ## job_titleJunior designer       0.2409908  1.0802660   0.223 0.823470    
    ## job_titleJunior developer      0.2499053  1.0728769   0.233 0.815816    
    ## job_titleLead designer         1.3786008  3.1163951   0.442 0.658221    
    ## job_titleLead developer        1.9056669  3.6959823   0.516 0.606130    
    ## job_titlePrincipal consultant  0.8309494  4.1186944   0.202 0.840112    
    ## job_titleSenior designer       0.7088010  1.5935180   0.445 0.656462    
    ## job_titleSenior developer      0.3144047  1.6044196   0.196 0.844640    
    ## gender_maleTRUE                0.1510139  0.1369206   1.103 0.270057    
    ## performance_rating            -0.3947727  0.2054264  -1.922 0.054641 .  
    ## boss_rating_avg               -0.4717009  0.0766940  -6.150 7.73e-10 ***
    ## salary                        -0.0003101  0.0009056  -0.342 0.732017    
    ## overtime_per_week              0.1107597  0.0194138   5.705 1.16e-08 ***
    ## traveldays_per_year            0.0335763  0.0069784   4.811 1.50e-06 ***
    ## lastpromotion_months           0.0451119  0.0070345   6.413 1.43e-10 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for binomial family taken to be 1)
    ## 
    ##     Null deviance: 1684.7  on 1719  degrees of freedom
    ## Residual deviance: 1443.6  on 1698  degrees of freedom
    ## AIC: 1487.6
    ## 
    ## Number of Fisher Scoring iterations: 5

``` r
fit_logistic1 <- glm(attrition ~.-job_title - gender_male - salary, family=binomial(logit),
                     data = train, maxit=1000)
summary(fit_logistic1)
```

    ## 
    ## Call:
    ## glm(formula = attrition ~ . - job_title - gender_male - salary, 
    ##     family = binomial(logit), data = train, maxit = 1000)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -1.7729  -0.6699  -0.4719  -0.2862   2.7673  
    ## 
    ## Coefficients:
    ##                             Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept)                0.7685402  0.6119961   1.256   0.2092    
    ## training_spend            -0.0009152  0.0002826  -3.238   0.0012 ** 
    ## education_levelDSc or PhD -1.4602489  0.6198791  -2.356   0.0185 *  
    ## education_levelMSc or MBA  0.2752029  0.1331694   2.067   0.0388 *  
    ## performance_rating        -0.4489357  0.0726646  -6.178 6.48e-10 ***
    ## boss_rating_avg           -0.4553532  0.0749237  -6.078 1.22e-09 ***
    ## overtime_per_week          0.1051181  0.0190804   5.509 3.60e-08 ***
    ## traveldays_per_year        0.0318625  0.0068609   4.644 3.42e-06 ***
    ## lastpromotion_months       0.0448719  0.0069394   6.466 1.00e-10 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for binomial family taken to be 1)
    ## 
    ##     Null deviance: 1684.7  on 1719  degrees of freedom
    ## Residual deviance: 1482.2  on 1711  degrees of freedom
    ## AIC: 1500.2
    ## 
    ## Number of Fisher Scoring iterations: 5

``` r
sig_coeff <- fit_logistic$coefficients[ summary(fit_logistic)$coefficients[,4] < .05]
sig_coeff
```

    ##            training_spend education_levelMSc or MBA           boss_rating_avg 
    ##             -0.0009460341              0.3069032934             -0.4717009010 
    ##         overtime_per_week       traveldays_per_year      lastpromotion_months 
    ##              0.1107597443              0.0335762737              0.0451119081

``` r
sig_coeff <- data.frame(b=round(sig_coeff,2), exp_b=round(exp(sig_coeff),2)); sig_coeff
```

    ##                               b exp_b
    ## training_spend             0.00  1.00
    ## education_levelMSc or MBA  0.31  1.36
    ## boss_rating_avg           -0.47  0.62
    ## overtime_per_week          0.11  1.12
    ## traveldays_per_year        0.03  1.03
    ## lastpromotion_months       0.05  1.05

In short, the fit\_logistic1 model is developed from the first model, by
eliminating insignificant attributes. It performs better, with a smaller
AIC (AIC = 1500.2.) Yet, instead of excluding the variable of job title,
it is a good idea to separate it by seniority and see how the length of
time working in a company can influence employee attrition. Besides, the
performance rating is discrete, so it might be the case that different
levels of rating have a different impact on attrition.

``` r
tr_d <- train
te_d <- test

tr_d$seniority <- tr_d$job_title == "Lead designer" | tr_d$job_title == "Lead developer" | tr_d$job_title == "Principal consultant" | tr_d$job_title == "Senior designer" | tr_d$job_title == "Senior developer"
te_d$seniority <- te_d$job_title == "Lead designer" | te_d$job_title == "Lead developer" | te_d$job_title == "Principal consultant" | te_d$job_title == "Senior designer" | te_d$job_title == "Senior developer"
tr_d <- tr_d[,-4]
te_d <- te_d[,-4]
#View(tr_d)

tr_d$performance_rating <- as.factor(tr_d$performance_rating)
te_d$performance_rating <- as.factor(te_d$performance_rating)

# View(tr_d)

fit_logistic2 <- glm(attrition ~ . - gender_male - salary, family = binomial(logit), data= tr_d, maxit=1000)
summary(fit_logistic2)
```

    ## 
    ## Call:
    ## glm(formula = attrition ~ . - gender_male - salary, family = binomial(logit), 
    ##     data = tr_d, maxit = 1000)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -1.6753  -0.6531  -0.4628  -0.2741   2.8666  
    ## 
    ## Coefficients:
    ##                             Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept)               -0.0500134  0.6536436  -0.077 0.939010    
    ## training_spend            -0.0008880  0.0002873  -3.091 0.001996 ** 
    ## education_levelDSc or PhD -1.3827133  0.6309016  -2.192 0.028405 *  
    ## education_levelMSc or MBA  0.3076610  0.1346849   2.284 0.022354 *  
    ## performance_rating2        0.1376297  0.2539337   0.542 0.587825    
    ## performance_rating3       -0.8798427  0.2570370  -3.423 0.000619 ***
    ## performance_rating4       -0.9612392  0.2788986  -3.447 0.000568 ***
    ## performance_rating5       -1.0794130  0.4358564  -2.477 0.013267 *  
    ## boss_rating_avg           -0.4597916  0.0754928  -6.091 1.13e-09 ***
    ## overtime_per_week          0.1097142  0.0193163   5.680 1.35e-08 ***
    ## traveldays_per_year        0.0316794  0.0068950   4.595 4.34e-06 ***
    ## lastpromotion_months       0.0463948  0.0070009   6.627 3.43e-11 ***
    ## seniorityTRUE             -0.3345441  0.2373598  -1.409 0.158705    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for binomial family taken to be 1)
    ## 
    ##     Null deviance: 1684.7  on 1719  degrees of freedom
    ## Residual deviance: 1463.7  on 1707  degrees of freedom
    ## AIC: 1489.7
    ## 
    ## Number of Fisher Scoring iterations: 5

``` r
fit_logistic3 <- glm(attrition ~ . - gender_male - salary - seniority, family = binomial(logit), data= tr_d, maxit=1000)
summary(fit_logistic3)
```

    ## 
    ## Call:
    ## glm(formula = attrition ~ . - gender_male - salary - seniority, 
    ##     family = binomial(logit), data = tr_d, maxit = 1000)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -1.6491  -0.6528  -0.4650  -0.2785   2.7862  
    ## 
    ## Coefficients:
    ##                             Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept)               -0.0699609  0.6523476  -0.107 0.914595    
    ## training_spend            -0.0009015  0.0002864  -3.148 0.001646 ** 
    ## education_levelDSc or PhD -1.4599942  0.6265594  -2.330 0.019797 *  
    ## education_levelMSc or MBA  0.2933671  0.1342212   2.186 0.028838 *  
    ## performance_rating2        0.1563841  0.2529669   0.618 0.536444    
    ## performance_rating3       -0.8604189  0.2558623  -3.363 0.000772 ***
    ## performance_rating4       -0.9460150  0.2777946  -3.405 0.000661 ***
    ## performance_rating5       -1.0604603  0.4353360  -2.436 0.014852 *  
    ## boss_rating_avg           -0.4580061  0.0752385  -6.087 1.15e-09 ***
    ## overtime_per_week          0.1091202  0.0192919   5.656 1.55e-08 ***
    ## traveldays_per_year        0.0318866  0.0068934   4.626 3.73e-06 ***
    ## lastpromotion_months       0.0463641  0.0069990   6.624 3.49e-11 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for binomial family taken to be 1)
    ## 
    ##     Null deviance: 1684.7  on 1719  degrees of freedom
    ## Residual deviance: 1465.8  on 1708  degrees of freedom
    ## AIC: 1489.8
    ## 
    ## Number of Fisher Scoring iterations: 5

Now, the model 2 seems better, with a lower AIC (1489.7.)

# IV. Random Forest

## 4.1 Build the model

``` r
model_forest1 <- randomForest(attrition ~ ., data=train,
                              method="class", ntree=500)
```

    ## Warning in randomForest.default(m, y, ...): The response has five or fewer
    ## unique values. Are you sure you want to do regression?

``` r
model_forest2 <- randomForest(attrition~.-job_title - gender_male - salary, data=train, method="class", ntree=500)
```

    ## Warning in randomForest.default(m, y, ...): The response has five or fewer
    ## unique values. Are you sure you want to do regression?

``` r
par(mfrow=c(1,2))
plot(model_forest1, main="random forest 1")
plot(model_forest2, main="random forest 2")
```

![](Attrition-Project_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

# V. Predict the result

``` r
# Check the prediction for the 3rd model
predictions_logistic_3 <-  predict(fit_logistic3, newdata = te_d, type = 'response')

#head(round(predictions_logistic,4))
#head(te_d$attrition)

#confusion matrix
conf_matrix <- confusionMatrix(as.factor(te_d$attrition==1), 
                                data=as.factor(predictions_logistic_3 > 0.5), positive="TRUE") 
ctable3 <-  conf_matrix$table


#comparing with other models

# no kick out
predictions_logistic_0 <-  predict(fit_logistic, newdata = test, type = 'response')

conf_matrix_0 <- confusionMatrix(as.factor(test$attrition==1), 
                                data=as.factor(predictions_logistic_0 > 0.5), positive="TRUE") 
ctable0 <-  conf_matrix_0$table

# kick out everything
predictions_logistic_1<-  predict(fit_logistic1, newdata = test, type = 'response')
conf_matrix_1 <- confusionMatrix(as.factor(test$attrition==1),
                                  data=as.factor(predictions_logistic_1>0.5), positive='TRUE')
ctable1 <-  conf_matrix_1$table
# 2
predictions_logistic_2<-  predict(fit_logistic2, newdata = te_d, type = 'response')
conf_matrix_2 <- confusionMatrix(as.factor(te_d$attrition==1),
                                  data=as.factor(predictions_logistic_2>0.5), positive='TRUE')
ctable2 <-  conf_matrix_2$table


prediction_forest1 <- predict(model_forest1, newdata = test, type = 'class')
conf_matrix_21 <- confusionMatrix(as.factor(test$attrition==1),
                                  data=as.factor(prediction_forest1 >0.5), positive='TRUE')
ctable21 <-  conf_matrix_21$table

#conf_matrix_21

prediction_forest2 <- predict(model_forest2, newdata = test, type = 'class')
conf_matrix_22 <- confusionMatrix(as.factor(test$attrition==1),
                                  data=as.factor(prediction_forest2 >0.5), positive='TRUE')
#conf_matrix_22
ctable22 <-  conf_matrix_22$table
```

# VI. Analyze the predictions

You can see the Confusion Matrix below, with a threshold of 0.5. And
then, I compared the key results into a histogram. It seems that random
forest performed the best. Finally, ROC plots suggest that the second
model of the random forest is the best, as it has the largest AUC.

![](Attrition-Project_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

    ##    condition        type  value
    ## 1      log_0    accuracy 0.8093
    ## 2      log_l    accuracy 0.8140
    ## 3      log_2    accuracy 0.8163
    ## 4      log_3    accuracy 0.8140
    ## 5   forest_1    accuracy 0.8209
    ## 6   forest_2    accuracy 0.8279
    ## 7      log_0 sensitivity 0.1300
    ## 8      log_l sensitivity 0.0900
    ## 9      log_2 sensitivity 0.1400
    ## 10     log_3 sensitivity 0.1400
    ## 11  forest_1 sensitivity 0.2200
    ## 12  forest_2 sensitivity 0.2700
    ## 13     log_0 specificity 0.9600
    ## 14     log_l specificity 0.9800
    ## 15     log_2 specificity 0.9700
    ## 16     log_3 specificity 0.9700
    ## 17  forest_1 specificity 0.9600
    ## 18  forest_2 specificity 0.9500

![](Attrition-Project_files/figure-gfm/unnamed-chunk-12-2.png)<!-- -->

    ## Setting levels: control = FALSE, case = TRUE

    ## Setting direction: controls < cases

    ## Setting levels: control = FALSE, case = TRUE

    ## Setting direction: controls < cases

    ## Setting levels: control = FALSE, case = TRUE

    ## Setting direction: controls < cases

    ## Setting levels: control = FALSE, case = TRUE

    ## Setting direction: controls < cases

    ## Setting levels: control = FALSE, case = TRUE

    ## Setting direction: controls < cases

    ## Setting levels: control = FALSE, case = TRUE

    ## Setting direction: controls < cases

![](Attrition-Project_files/figure-gfm/unnamed-chunk-12-3.png)<!-- -->

    ## Setting levels: control = FALSE, case = TRUE
    ## Setting direction: controls < cases

    ## Setting levels: control = FALSE, case = TRUE

    ## Setting direction: controls < cases

    ## Setting levels: control = FALSE, case = TRUE

    ## Setting direction: controls < cases

    ## Setting levels: control = FALSE, case = TRUE

    ## Setting direction: controls < cases

    ## Setting levels: control = FALSE, case = TRUE

    ## Setting direction: controls < cases

    ## Setting levels: control = FALSE, case = TRUE

    ## Setting direction: controls < cases

![](Attrition-Project_files/figure-gfm/unnamed-chunk-12-4.png)<!-- -->

# VII. Conclusion:

The second random forest model gives the best prediction. Yet, the
company needs to evaluate between type I error and type II error, and
consider which type of error is the most unacceptable. The model shows
that
*j**o**b*<sub>*t*</sub>*i**t**l**e*,*g**e**n**d**e**r*,*s**a**l**a**r**y*
are not essentially relevant to employee attrition. In other words,
those factors cannot make an employee stay in the company. The model and
results are useful for the top management team and HR.

1.  HR: - can prepare actions to retain the employees. For example, HR
    may arrange a face-to-face conversation to identify the reasons. So
    if it turns out that they think the traveling days are overwhelming,
    HR can inform the supervisor and suggest reorganizing the working
    schedule slightly.

    -   can prepare for the next round of recruitment. If the company
        can find someone else to replace the position, the attrition
        will become normal employee turnover.

2.  top management team: - As the results show that both
    *t**r**a**i**n**i**n**g*<sub>*s*</sub>*p**e**n**d* and
    *b**o**s**s*<sub>*r*</sub>*a**t**i**n**g*<sub>*a*</sub>*v**g* are
    one of the factors to attrition, the top management can balance the
    overall company profits and decide the increase the employee spend
    in the next year.

    -   Besides, the top management team can have another project to
        identify how to improve the boss rating.
    -   Since employees prefer to stay in a company without an obvious
        hierarchy, the top manager can evaluate and improve the company
        culture to become more transparent and agile.
