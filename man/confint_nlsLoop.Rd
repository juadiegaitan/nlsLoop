% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/confint_nlsLoop.R
\name{confint_nlsLoop}
\alias{confint_nlsLoop}
\title{Calculate the confidence intervals from an nlsLoop object}
\usage{
confint_nlsLoop(data, param_data)
}
\arguments{
\item{data}{the data frame containing the data used in the nlsLoop argument}

\item{param_data}{the nlsLoop object}
}
\value{
returns a dataframe in stacked format with columns \code{id_col}, \code{param}, \code{CI_lwr}, \code{CI_higher}, \code{mean} that give the confidence intervals and mean estimate of each model fit.
}
\description{
Determines the confidence intervals of a set of non-linear regressions fitted with nlsLoop.
}
\details{
calculates the confidence intervals of each fit using \code{\link[nlstools]{confint2}} and the "asymptotic" approach. This method cannot be changed to "profile" as it the model is fitted with \code{\link[minpack.lm]{nlsLM}}
}
\examples{
# load in data

data("Chlorella_TRC")
Chlorella_TRC_test <- Chlorella_TRC[Chlorella_TRC$curve_id \%in\% c(1:10),]

# run nlsLoop()

# define the Sharpe-Schoolfield equation
schoolfield_high <- function(lnc, E, Eh, Th, temp, Tc) {
 Tc <- 273.15 + Tc
 k <- 8.62e-5
 boltzmann.term <- lnc + log(exp(E/k*(1/Tc - 1/temp)))
 inactivation.term <- log(1/(1 + exp(Eh/k*(1/Th - 1/temp))))
 return(boltzmann.term + inactivation.term)
}

fits <- nlsLoop(ln.rate ~ schoolfield_high(lnc, E, Eh, Th, temp = K, Tc = 20),
                data = Chlorella_TRC_test,
                tries = 100,
                id_col = 'curve_id',
                supp_errors = 'Y',
                param_bds = c(-10, 10, 0.1, 2, 0.5, 5, 285, 330),
                lower = c(lnc=-10, E=0, Eh=0, Th=0))

CI <- confint_nlsLoop(Chlorella_TRC_test, fits)

}
\seealso{
\code{\link[nlsLoop]{nlsLoop}} for details of fitting the initial nlsLoop object.

\code{\link[nlstools]{confint2}} for details of calculating CI from non-linear regressions
}
\author{
Daniel Padfield
}
