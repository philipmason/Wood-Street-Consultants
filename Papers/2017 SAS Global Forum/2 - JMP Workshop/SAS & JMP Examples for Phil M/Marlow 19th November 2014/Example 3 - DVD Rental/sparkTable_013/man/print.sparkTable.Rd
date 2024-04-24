\name{print.sparkTable}
\alias{print.sparkTable}
\title{Generates a EPS or HTML plot of a meta-object}
\description{
This function creates a EPS or HTML output in \R, depending on the meta object created with sparkTable_Config. 
}
\usage{
print.sparkTable(x, outdir=NULL, outfile=NULL, rowVec=NULL, colVec=NULL, digits=2,...)
}
\arguments{
  \item{x }{ an object created with \code{\link{sparkTable_Config}} }
  \item{outdir }{ optional argument to which EPS-images should be saved. If this parameter is NULL, the current work-directory is used. }
  \item{outfile}{ if set an html/tex file will be created with the output}
  \item{rowVec}{row names for the table}
  \item{colVec}{column names for the table}
  \item{digits}{ number of digits of the numerical parts in the table}
  \item{...}{ are ignored at the moment}
}
\author{Bernhard Meindl, Alexander Kowarik, Statistics Austria  }
\seealso{\code{\link{print.sparkTable}}, \code{\link{setPara}}, \code{\link{sparkTable_Config}}, \code{\link{spark}}, 
		\code{\link{spark_init}}, \code{\link{sparkHTML}},, \code{\link{sparkEPS}}}
		
\examples{

data(gini)
meta <- sparkTable_Config(gini, groups=c("AT","DE","IT"), 
		groupVar="country", 
		vars=c("gini"), 
		typeNumeric=c("mean", "median"), 
		typePlot="line",
		output="eps")

# this meta object can now be used to generate an EPS-output in R
rowVec <- c("Austria", "Germany", "Italy")
colVec <- c("Mean", "Median","Line-Plot")
eps.text <- print.sparkTable(meta, outdir="examples", rowVec=rowVec, colVec=colVec)

}
\keyword{ hplot }
