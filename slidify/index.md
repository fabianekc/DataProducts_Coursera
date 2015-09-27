---
title       : Crowd Intelligence
subtitle    : Utilizing the wisdom of the crowd
author      : Christoph Fabianek, September 2015
job         : a Developing Data Products class project, for the Coursera Data Science Specialization
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [mathjax]            # {quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---
<style>
em {
  font-style: italic
}
strong {
  font-weight: bold;
}
</style>

## The Problem

1. People (even experts) are really bad in predicting the future.
2. Nonetheless, we are relying on this skill quite often when
    * changing our job,
    * getting married, or
    * making an investment.
3. We decide based on how we expect the future will unfold.  
   These expectations are forecasts - and often wrong!

---

## The Solution

Ask your friends / team / clients! Because a group is smarter than its experts.  
Those predictions will provide sensible results if the following 4 requirements hold:  
  * Diversity of Opinion: each person should have some private information, even if it‘s just an eccentric interpretation of the known facts  
  * Independence: people’s opinions are not determined by the opinions of those around them  
  * Decentralization: people are able to specialize and draw on local knowledge  
  * Aggregation: some mechanism exists for turning private judgments into a collective decision  

**This class project will demo the aggregation mechanism.**

---

## How does it work?

Open https://crowdstatus.shinyapps.io/project/  
1) Forecasts are collected through a simple survey  
2) Actual results are entered in the Admin Area to get a full analysis  

Bonus: Evaluate forecasts with the Diversity Prediction Theorem (by [Scott E. Page](https://www.youtube.com/watch?v=KtaaCAJjGr4) )
   $$(c-\theta)^2 = \frac{1}{n}\sum_{i=1}^n (s_i - \theta)^2 - \frac{1}{n} \sum_{i=1}^n (s_i - c)^2$$


```r
s <- rnorm(10) # n=10 individual predictions
t <- 0.3       # theta is the actual result (could be anything!)
c <- mean(s)   # c is the crowd prediciton
crowd_error <- (c-t)^2; average_error <- sum((s-t)^2)/10; diversity <- sum((s-c)^2)/10
print(c(crowd_error, average_error - diversity))
```

```
## [1] 0.1150276 0.1150276
```

Message: make sure you have a large diversity (term does not include $\theta$) to avoid bias

---

## Further Information

* Project inspired by [Crowd Status](https://www.crowdstatus.net)
* Literatur
  * The Wisdom of Crowds, 2004, by James Surowiecki
  * Superforecasting: The Art and Science of Prediction, 2015,  
    by Philip Tetlock and Dan Gardner
  * Thinking, Fast and Slow, 2011, by Daniel Kahnemann
  
* Software
  * [Shiny](http://shiny.rstudio.com/), including [Persisting Data](https://github.com/daattali/shiny-server/tree/master/persistent-data-storage)  example
  * [Knitr](http://yihui.name/knitr/) to create Analysis Report using an Rmd Template

