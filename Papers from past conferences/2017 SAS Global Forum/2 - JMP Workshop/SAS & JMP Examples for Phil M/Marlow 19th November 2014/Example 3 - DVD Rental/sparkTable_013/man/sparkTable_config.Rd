\name{sparkTable_Config}
\alias{sparkTable_Config}
\title{Create meta objects which are later to be used as input-objects
for the plot-function.}
\description{
 Generation of a meta-object which can be used by the \code{\link{print.sparkTable}}-function. Tis
 object also contains the properties of the plots. 
 }
\usage{
sparkTable_Config(df, groups, groupVar, vars, typeNumeric, typePlot, output)
} 
\arguments{
  \item{df }{ a data.frame or matrix of input-data }
  \item{groups }{ which characteristics of the grouping variable should be used }
  \item{groupVar }{ variable name of a grouping-variable }
  \item{vars }{ variable names of variables to be plotted }
  \item{typeNumeric }{ list or vector of the same length as the number of variables used, each list element can be a vector or NULL,defines the number put into the table (see overview in details)}
  \item{typePlot }{vector or list either "line", "box" or "bar"}
  \item{output }{ output format, currently "html" and "eps" are possible }
}
\details{
typeNumeric can be:

max

min

mean

last

ind1--ind2 : e.g. 1--10 or 10--100

indexN: eg index1 gives the first value

... in principle every function that takes a vector and returns a single value (median, quantile,......)
}
\value{
Returns an object of class \code{meta} including \code{$metaData} and \code{metaInfo}
	
  \item{metaData }{List of information and properties of every single graphic, 
					for details look at the \code{\link{spark_init}} function}
  \item{metaInfo }{List of information about the output properties, chosen variables, plot type, groups. 
  	If the output is \code{"eps"} it contains filenames and the latex code.
  	If the output is \code{"html"} it contains the html-header and the html-table}

}
\author{Bernhard Meindl, Alexander Kowarik, Statistics Austria  }
\seealso{\code{\link{print.sparkTable}}, \code{\link{setPara}}, \code{\link{sparkTable_Config}}, \code{\link{spark}}, 
		\code{\link{spark_init}}, \code{\link{sparkHTML}},, \code{\link{sparkEPS}}}
\examples{

# This function produces an artificial data set of N time units

genDF <- function(N) {
	groups <- c("AT","DE","CH","UK","IT")
	nrRows <- N*length(groups)
	df <- data.frame(
			time=rep(1:N, length(groups)), 
			groups=rep(groups, each=N),
			V1=round(rnorm(nrRows, 25, 25),2),
			V2=round(rnorm(nrRows, 125, 55),2),
			V3=round(rnorm(nrRows, 100, 15),2),
			V4=round(rnorm(nrRows, 150, 65),2),
			V5=round(rnorm(nrRows, 40, 85),2)
	)
	df
}

# generate a data.frame
df <- genDF(20)

# creating EPS output:

meta <- sparkTable_Config(df, groups=c("AT","UK"), 
		groupVar="groups", 
		vars=c("V1","V2","V5"), 
		typeNumeric="mean", 
		typePlot="box",
		output="eps")

# this meta object can now be used to generate an EPS-output in R
eps.text <- print(meta, outdir="examples")

# creating HTML file

meta <- sparkTable_Config(df, groups=c("AT","UK","IT"), 
		groupVar="groups", 
		vars=c("V1","V2","V5"), 
		typeNumeric=list(c("mean","1--3","max","4--5","last"),c("mean","1--3","max"),c("mean","1--3","max"))
		, 
		typePlot=list(c("line","box"),"line","line"),
		output="html")

obj <- print(meta,outdir="examples",outfile="test.html")

### production index
data(dat)
pi_jahr <- dat[1:4,]
pi_monat <- dat[6:nrow(dat),]
transform_for_meta <- function(x,time="row",vars=NULL){
  if(time!="row"){
    x <- t(x)                
  }
  if(!is.null(vars)){
    x <- x[,vars]    
  }
  gr <- vector()
  val <- vector()
  for(i in 1:ncol(x)){
    gr <- c(gr,rep(names(x)[i],nrow(x)))
    val <- c(val,x[,i]) 
  }
  data.frame(group=gr,values=val,stringsAsFactors=FALSE)
}
pi_j2 <- transform_for_meta(pi_jahr)
pi_m2 <- transform_for_meta(pi_monat)
j <- vector()
for(i in 6:20){
  j <- c(j,paste(rep(1990+i,12),1:12,sep="-"))
}
pi_m2$values2 <- pi_m2$values
meta <- sparkTable_Config(df=pi_m2,groups=unique(pi_m2[,1]),groupVar=names(pi_m2)[1],
    vars=names(pi_m2)[2:3], 
    typeNumeric=list(NA,c("51--62"))
    , 
    typePlot=list("line",NA),
    output="html")
meta$metaData <- setPara(meta$metaData, "ch", 25,col=1)
obj <- print(meta,outfile="test.html",outdir="examples")
}
