% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/benders.R
\name{benders}
\alias{benders}
\title{Launch benders decomposition}
\usage{
benders(path_solver, display = TRUE, report = TRUE, opts = simOptions())
}
\arguments{
\item{path_solver}{Character containing the Antares Solver path}

\item{display}{Logical. If \code{TRUE} the advancement of the benders decomposition
if displayed in the console}

\item{report}{Logical. If \code{TRUE} an html report of the expansion results will
be generated.}

\item{opts}{list of simulation parameters returned by the function
\code{antaresRead::setSimulationPath}}
}
\value{

}
\description{
Launch benders decomposition
}

