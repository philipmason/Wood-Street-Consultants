\name{sparkEPS}
\alias{sparkEPS}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Create a sparkline as EPS graphic}
\description{
The function creates an EPS file of the selected type and with given parameters.
}
\usage{
sparkEPS(filename, para, type)
}
\arguments{
  \item{filename}{the name of the file where the data will be saved.}
  \item{para}{list of parameters produces by the \code{\link{spark_init}} function}
  \item{type}{either "line", "bar", or "box"}
}
\author{
Bernhard Meindl, Alexander Kowarik, Statistics Austria }

\seealso{\code{\link{print.sparkTable}}, \code{\link{setPara}}, \code{\link{sparkTable_Config}}, \code{\link{spark}}, 
		\code{\link{spark_init}}, \code{\link{sparkHTML}},, \code{\link{sparkEPS}}}

\examples{


# GDP per capita in Purchasing Power Standards (PPS) (EU-27 = 100)

data(gdp)

meta <- sparkTable_Config(gdp, groups=c("EU27","AT","DE","TR"), 
		groupVar="region", 
		vars=c("gdp"), 
		typeNumeric=list(c("min","max","last"))	, 
		typePlot=c("line","bar"),
		output="eps")

# creating a tex-document in the directory examples
obj <- print(meta,outdir="examples",outfile="gdp.tex")

# --------------------------------

# production index 
data(dat)

pi_konsum <- dat$Konsumgueter[6:67]

# creating a line, box plot and bar plot
para <- spark_init(pi_konsum, type="line")
sparkEPS("examples/pi_konsum_line.eps",para,type="line")

para <- spark_init(pi_konsum, type="box")
sparkEPS("examples/pi_konsum_box.eps",para,type="box")

para <- spark_init(pi_konsum, type="bar")
sparkEPS("examples/pi_konsum_bar.eps",para, type="bar")
}
