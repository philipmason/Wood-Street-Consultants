\name{spark_init}
\alias{spark_init}
\title{Create sparkline as EPS graphics or HTML code}
\description{
  Producing different plot types of data with personalized graphical options for later use in Latex or HTML.
}
\usage{
#default settings:
spark_init(v, cw=100, ch=50, top_padding=5, bottom_padding=5, left_padding=5, 
	right_padding=5, showIQR=TRUE, showVals=rep(TRUE, 3), 
	colVals=c("#f00", "#0f0", "#00f"), fillColor="#ccc", pointWidth=1.5, 
	lineWidth=1, lineCol="#000", shadow=FALSE, shadowCol="#ccc",
	barCol=c("#00f", "#f00", "#000"), barWidth=3, barSpacing=1,
	boxOutCol=c("#f00","#f00"), boxMedCol="#000",boxShowOut=TRUE,
	boxCol=c("#fff","#00f","#00f"), type)
}
\arguments{
  \item{v }{a data vector}
  \item{cw }{width of the sparkline}
  \item{ch }{height of the sparkline}
  \item{top_padding }{distance between the bar with the highest value to the boarder}
  \item{bottom_padding }{distance between the bar with the lowest value to the boarder}
  \item{left_padding }{distance between the left boarder and the first bar}
  \item{right_padding }{distance between the last bar and the right boarder}
  \item{showIQR }{a logical value indicating whether the IQR (interquartile range) box should be drawn or not}
  \item{showVals }{a logical vector of length 3 indicating which values should be shown: highest, lowest, last}
  \item{colVals }{a vector of length 3 defining the used colors for the values above}
  \item{fillColor }{the fill color for the IQR box}
  \item{pointWidth }{the width of the points}
  \item{lineWidth }{the width of the line}
  \item{lineCol }{the color of the line}
  \item{shadow }{fills the area under the line}
  \item{shadowCol }{color of the shaded area}
  \item{barCol }{a vector of length 3 defining the colors for positive, negative or values of zero}
  \item{barWidth }{the width of each bar}
  \item{barSpacing }{the space between bars}
  \item{boxOutCol }{color of the outliers}
  \item{boxMedCol }{color of the median}
  \item{boxShowOut }{a logical value whether the outliers should be drawn or not}
  \item{boxCol }{a vector of length 3 defining colors for the box: fill color, box color, end of the whisker }
  \item{type }{either "line", "bar", or "box"}
}
\details{With the type setting one of the following three graphical options can be chosen:
\itemize{
\item{line:}{ draws a classical sparkline, several options can be set like a IQR box, 
		different colors for the box, points or line as well as the line width}
\item{bar:}{ draws a bar plot, the size of the plot can be affected by the barWidth and barSpacing values.}
\item{box:}{ draws a classical horizontal boxplot, with the option to hide outliers in order to get a better looking output}
}
}
\value{
\code{spark_init} returns a list containing information and properties depending on the chosen type. 
}
\author{Bernhard Meindl, Alexander Kowarik, Statistics Austria }
\seealso{\code{\link{print.sparkTable}}, \code{\link{setPara}}, \code{\link{sparkTable_Config}}, \code{\link{spark}}, 
		\code{\link{spark_init}}, \code{\link{sparkHTML}},, \code{\link{sparkEPS}}}
\examples{

#  

data(brp)

brp_abs <- brp[1:34,]
brp$Land <- "Oesterreich"

# creating HTML file, type = "line"
para <- spark_init(brp_abs$Tert_Sekt, type="line")
spark("examples/line.html",para,type="line",output="html")

# creating EPS file, type = "bar"
para <- spark_init(brp_abs$Sek_Sekt,type="bar", ch=200, 
		barCol=c("#0f0","#f00","#00f"), barWidth=5, barSpacing=1, 
		top_padding=20, right_padding=20, left_padding=20, bottom_padding=20)
spark("examples/bar.eps",para,type="bar",output="eps")
}
