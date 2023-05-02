\name{sparkHTML}
\alias{sparkHTML}
\title{Create sparklines for HTML}
\description{
This function creates a HTML file of the selected type and with given parameters.
}
\usage{
sparkHTML(filename, para, type, return = FALSE, fixedIndex = FALSE)
}
\arguments{
  \item{filename }{the name of the HTML file}
  \item{para }{list of parameters produces by the \code{\link{spark_init}} function}
  \item{type }{either "line", "bar", or "box"}
  \item{return }{returns HTML code in \R }
  \item{fixedIndex}{TRUE/FALSE parameter if the javascript function index should be raised or be fixed.}
}
\value{
If return=TRUE a list containing two components is returned.
  \item{head }{Definition of the sparkline function including parameters}
  \item{body }{HTML table of the sparkline including the values}

}
\author{
Bernhard Meindl, Alexander Kowarik, Statistics Austria }
%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{\code{\link{print.sparkTable}}, \code{\link{setPara}}, \code{\link{sparkTable_Config}}, \code{\link{spark}}, 
		\code{\link{spark_init}}, \code{\link{sparkHTML}},, \code{\link{sparkEPS}}}
\examples{

# BRP data
data(brp)

brp$Land <- "Oesterreich"
brp_change <- brp[35:67,]

meta <- sparkTable_Config(brp_change,groups=c("Oesterreich"),groupVar="Land",
		vars="BRP", 
		typeNumeric=c("min","median","max","30--32")
		, 
		typePlot=c("line","bar","box"),
		output="html")

obj <- print(meta,outfile="examples/test.html") 



# production index 
data(dat)

pi_konsum <- dat$Energie[6:67]

# creating a line, box plot and bar plot in different HTML files

para <- spark_init(pi_konsum, type="line")
sparkHTML("examples/pi_energie_line.html",para,type="line")

para <- spark_init(pi_konsum, type="box")
sparkHTML("examples/pi_energie_box.html",para,type="box")

para <- spark_init(pi_konsum, type="bar")
sparkHTML("examples/pi_energie_bar.html",para, type="bar")

}
