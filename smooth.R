#' Read input data
rm(list=ls())
dat <- read.table("~/Downloads/DataPoints_TargetFunction_Home.txt")
colnames(dat) <- c("x", "y")
dat <- dat[-543, ] # delete duplicate observation

#' Count rows
nrow(dat)

#' Estimate "ideal" degrees of freedom
(dat.ss <- smooth.spline(dat))
dat.ss.df <- dat.ss$df

#' From that, we estimate splines with the following degrees of freedom:
{{(dfs <- dat.ss.df * (1:10) * 0.1)}}

#' Estimate and simulate, result is a data frame of the following form:
library(plyr)
ldply(
  setNames(dfs, format(dfs)),
  function(df.in) {
    dat.ss <- smooth.spline(dat, df=df.in)
    data.frame(x=dat$x, y=dat.ss$y, resid=dat.ss$y - dat$y)
  },
  .id="df"
) -> dat.sim
head(dat.sim)

#' Append the original data:
dat.full <- rbind(dat.sim, transform(dat, df="Input data", resid=0))

#' The fit:
library(ggplot2)
ggplot(dat.full) +
  geom_line(aes(x=x, y=y, color=df))

#' The residuals:
ggplot(dat.full) +
  geom_line(aes(x=x, y=resid, color=df))
