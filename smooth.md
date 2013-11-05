



Read input data


```r
rm(list = ls())
dat <- read.table("~/Downloads/DataPoints_TargetFunction_Home.txt")
colnames(dat) <- c("x", "y")
dat <- dat[-543, ]  # delete duplicate observation
```


Count rows


```r
nrow(dat)
```

```
## [1] 734
```


Estimate "ideal" degrees of freedom


```r
(dat.ss <- smooth.spline(dat))
```

```
## Call:
## smooth.spline(x = dat)
## 
## Smoothing Parameter  spar= 0.06506  lambda= 1.187e-10 (15 iterations)
## Equivalent Degrees of Freedom (Df): 133.2
## Penalized Criterion: 0.0005835
## GCV: 1.186e-06
```

```r
dat.ss.df <- dat.ss$df
```


From that, we estimate splines with the following degrees of freedom:
13.3174, 26.6347, 39.9521, 53.2695, 66.5868, 79.9042, 93.2216, 106.5389, 119.8563, 133.1737
Estimate and simulate, result is a data frame of the following form:


```r
library(plyr)
dat.sim <- ldply(setNames(dfs, format(dfs)), function(df.in) {
    dat.ss <- smooth.spline(dat, df = df.in)
    data.frame(x = dat$x, y = dat.ss$y, resid = dat.ss$y - dat$y)
}, .id = "df")
head(dat.sim)
```

```
##       df       x      y   resid
## 1  13.32 0.00000 0.6895 0.03544
## 2  13.32 0.02778 0.6894 0.03509
## 3  13.32 0.08333 0.6891 0.03439
## 4  13.32 0.16667 0.6888 0.03334
## 5  13.32 0.19444 0.6887 0.03300
## 6  13.32 0.41667 0.6879 0.03025
```


Append the original data:


```r
dat.full <- rbind(dat.sim, transform(dat, df = "Input data", resid = 0))
```


The fit:


```r
library(ggplot2)
```

```
## Loading required package: methods
```

```r
ggplot(dat.full) + geom_line(aes(x = x, y = y, color = df))
```

![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7.png) 


The residuals:


```r
ggplot(dat.full) + geom_line(aes(x = x, y = resid, color = df))
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8.png) 


