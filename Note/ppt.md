# Notes From the course

## **Week 2**

## Data analytics 
1. Descriptive: What happened?
2. Diagnostic : Why did it happened?
3. Predictive : What will happen?
4.Prescriptive: What should we do?

## Types of experiments
1. A/B testing: Seperate the population (users) into Control Group and Treament Group
    +:
      * Product features
      * Marketing messages
      * Incentive spend
    - A/B testing is not always possible
     1. Unable to unobtrusively assign to treatment and control groups
     2. Network effects: The network effect is a phenomenon whereby increased numbers of people or participants improve the value of a good or service.）-> e.g.Internet,social media,
     3. Spillover effects/contamination: Spillover effect refers to the impact that seemingly unrelated events in one nation can have on the economies of other nations.
2. Switchback experiments
    +：
      * Algorithm changes that do not affect the UI
     1. ![](/image/1.PNG)
     2. [clear example] (https://medium.com/@DoorDash/switchback-tests-and-randomized-experimentation-under-network-effects-at-doordash-f1d938ab7c2a)
3. Staged rollouts or quasi-experiments
    +： 
      * Testing a new policy in one or more cities, and constructing a ‘synthetic’ control city/cities from historical data and/or other cities 
      (Uber calls this ‘synthetic control’)
      1. Treatment and control groups can be (quasirandomly) determined based on
        * Location, team, project, etc.
        * Randomization imperfections can be controlled ’synthetically’
