% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot-methods.R
\name{plot_placebos}
\alias{plot_placebos}
\title{plot_placebos}
\usage{
plot_placebos(data, time_window = NULL, prune = TRUE)
}
\arguments{
\item{data}{nested data of type \code{tbl_df}.}

\item{time_window}{time window of the tbl_df plot.}

\item{prune}{boolean flag; if TRUE, then all placebo cases with a pre-period
RMSPE exceeding two times the treated unit pre-period RMSPE are pruned;
Default is TRUE.}
}
\value{
\code{ggplot} object of the difference between the observed and synthetic
trends for the treated and placebo units.
}
\description{
Plot the difference between the observed and sythetic control unit for the
treated and the placebo units. The difference captures the causal quantity
(i.e. the magnitude of the difference between the observed and counterfactual
case). Plotting the actual treated observation against the placebos captures
the likelihood (or rarity) of the observed differenced trend.
}
\details{
The function provides a pruning rule where all placebo cases with a
pre-period root mean squared predictive error (RMSPE) exceeding two times the
treated unit pre-period RMSPE are pruned. This helps overcome scale issues
when a particular placebo case has poor fit in the pre-period.

See documentation on \code{?synthetic_control} on how to generate placebo cases.
When initializing a synth pipeline, set the \code{generate_placebos} argument to
\code{TRUE}. The processing pipeline remains the same.
}
\examples{

\donttest{

# Smoking example data
data(smoking)

smoking_out <-
smoking \%>\%

# initial the synthetic control object
synthetic_control(outcome = cigsale,
                  unit = state,
                  time = year,
                  i_unit = "California",
                  i_time = 1988,
                  generate_placebos=TRUE) \%>\%

# Generate the aggregate predictors used to generate the weights
  generate_predictor(time_window=1980:1988,
                     lnincome = mean(lnincome, na.rm = TRUE),
                     retprice = mean(retprice, na.rm = TRUE),
                     age15to24 = mean(age15to24, na.rm = TRUE)) \%>\%

  generate_predictor(time_window=1984:1988,
                     beer = mean(beer, na.rm = TRUE)) \%>\%

  generate_predictor(time_window=1975,
                     cigsale_1975 = cigsale) \%>\%

  generate_predictor(time_window=1980,
                     cigsale_1980 = cigsale) \%>\%

  generate_predictor(time_window=1988,
                     cigsale_1988 = cigsale) \%>\%


  # Generate the fitted weights for the synthetic control
  generate_weights(optimization_window =1970:1988,
                   Margin.ipop=.02,Sigf.ipop=7,Bound.ipop=6) \%>\%

  # Generate the synthetic control
  generate_control()

# Plot the observed and synthetic trend
smoking_out \%>\% plot_placebos(time_window = 1970:2000)

}

}
