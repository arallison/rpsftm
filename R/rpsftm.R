#'Main Function used for estmating causal parameters under the Rank Preserving Sturctural Failure Time Model
#'
#'@export
#'@title Rank Preserving Sturctural Failure Time Model
#'@name rpsftm
#' @param time the observed failure or censoring time.
#' @param censor_time the theoretical censoring time, either observed or set after Time.
#' @param rx the proportion of Time spent on treatment
#' @param data a data.frame object containing the variables 
#' @param arm the randomisation that is independent of the recensored survival times
#' @param adjustors a forumula object of covariates to adjust for: \code{~strata(A)+B*C}
#' @param target the value to subtract off from the z-statistic 
#' @param test the survival regression function to calculate the z-statistic: survdiff, coxph, survreg
#' @param lowphi the lower limit of the range to search for the causal parameter
#' @param hiphi the upper limit of the range to search for the causal paramater
#' @param alpha the significance level used to calculate confidence intervals
#' @param \code{...} arguments to supply to the test function.
#' @return a list of
#' \itemize{
#' \item phi the estimated parameter
#' \item fit the fitted survival object
#' \item Sstar the recensored \code{Surv()} data using the estimate parameter
#' \item ans the object return from \code{uniroot} 
#' \item CI a vector of the confidence interval around phi
#' \item call the R call object
#' }
#' @author Simon Bond

rpsftm=function(time, censor_time, rx, arm,data, adjustors=NULL, 
                test=survdiff, lowphi=-10,hiphi=10, alpha=0.05,...){
  
  #create formula for fitting, and to feed into model.frame()
  if(is.null(adjustors)){
    adjustors=as.formula("~1")
  }
  update_formula=paste("~.",substitute(arm),sep="+")
  fit_formula=update.formula(adjustors, update_formula)
  update_formula=paste("~.",substitute(time), substitute(censor_time),substitute(rx),sep="+")
  data_formula=update.formula(fit_formula, update_formula)
  #this solves issues with strata(..),
  df=get_all_vars(data_formula,data=data)
  #Check that the number of arms is 2.
  if( length(unique(df[,deparse(substitute(arm))]))!=2){
    stop("arm must have exactly 2 observed values")
  }
    
  #check or handle missing data.
  
  
  # Work out argument passing for uniroot. Why is test= different to the others???
  
  
  #solve to find the value of phi that gives the root to z=0
  
  #turn this into a function in utils, with the argument target.
  ans=uniroot(EstEqn, c(lowphi,hiphi), 
              time=time, censor_time=censor_time, rx=rx, arm=arm, 
              data=df, formula=fit_formula, test=deparse(substitute(test)),
              target=0)
  lower=uniroot(EstEqn, c(lowphi,hiphi), 
                time=time, censor_time=censor_time, rx=rx, arm=arm, 
                data=df, formula=fit_formula,test=deparse(substitute(test)),
                target=qnorm(1-alpha/2))
  
  #check out upper- it disagrees with stata, but not the point estimate or the lower bound?
  
  upper=uniroot(EstEqn, c(lowphi,hiphi), 
                time=time, censor_time=censor_time, rx=rx, arm=arm, 
                data=df, formula=fit_formula,test=deparse(substitute(test)),
                target=qnorm(alpha/2))
  
  
  
  phiHat=ans$root
  Sstar=recensor(phiHat, time, censor_time,rx, data=df)
  fit=survival::survfit(update(fit_formula, Sstar~.), df)
  
  
  list(phi=phiHat, 
       fit=fit, 
       Sstar=Sstar, 
       ans=ans, 
       CI=c(lower$root,upper$root),
       call=match.call())
  
}