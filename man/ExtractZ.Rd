% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ExtractZ.R
\name{ExtractZ}
\alias{ExtractZ}
\alias{ExtractZ.coxph}
\alias{ExtractZ.survdiff}
\alias{ExtractZ.survreg}
\title{Extracting the z-statistic from a survival object}
\usage{
ExtractZ(x, ...)

\method{ExtractZ}{survdiff}(fit, ...)

\method{ExtractZ}{coxph}(fit, arm, ...)

\method{ExtractZ}{survreg}(fit, arm, ...)
}
\arguments{
\item{fit:}{a fitted survival object : survdiff, coxph, survreg}

\item{arm:}{a character vector giving the name of the covariate representing the treatment arm.}
}
\value{
a numeric value, the z statistic for the independence test of the treatment arm
}
\description{
Generic S3 methods to extract the z-statistic from a set of survival fit objects
}
\section{Methods (by class)}{
\itemize{
\item \code{survdiff}: Method for survdiff

\item \code{coxph}: Method for coxph objects

\item \code{survreg}: Method for survreg objects
}}
\author{
Simon Bond
}

