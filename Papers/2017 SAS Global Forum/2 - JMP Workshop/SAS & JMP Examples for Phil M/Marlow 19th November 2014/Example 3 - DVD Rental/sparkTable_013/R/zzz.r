.onLoad <- function(lib, pkg) {
  ver <- "0.1.0"
  if(!any(search()=="sparksENV")){
    sparksENV <- new.env()
    attach(sparksENV)
  }
  if(!exists(".sparklineIndex",which(search()=="sparksENV"))){
    assign(".sparklineIndex",1,which(search()=="sparksENV"))
    sparklineIndex <- 1
  }
  cat(paste("Package sparkTable ",ver," has been loaded!\n",sep=""))
}