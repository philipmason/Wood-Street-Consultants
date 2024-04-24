replaceStr <- function(strIn, type="underline") {
  if(!is.character(strIn))
    stop("wrong input\n")
  if(type=="underline")
    out <- as.character(sapply(strIn, function(x) { gsub("_", "\\\\textunderscore ", x)} ))
  if (type == "slash")
    out <- as.character(sapply(strIn, function(x) { gsub("\\\\", "/", x)} ))
  out
}

#x1 <- c("_abc_", "_ab_cd_", "abcd_", "abcd")
#x2 <- "D:\\Users\\meindl\\Desktop"
#replaceStr(x1, type="underline")
#replaceStr(x2, type="slash")

# Farben fuer eps umkodieren
f.colors <- function(ina) {
  a <- c(as.character(0:9), letters[1:6])
  ss <- unlist(strsplit(ina,""))[2:4] 
  out <- (17*as.numeric(unlist(sapply(ss, function(x) { which(x==a) } ))-1))
  round(out/255,2)
}

f.checkColors <- function(col) {
  cNeu <- f.colors(col)
  all(cNeu >= 0) | all(cNeu <= 255)
}

last <- function(x,na.rm=TRUE){
  if(length(x)>0){
    out <- x[length(x)]
    if(is.na(out)){
      if(na.rm){
        x <- na.omit(x)
        if(length(x)>0)
          out <- x[length(x)]
        else stop("all values are NAs \n")
      }else
        stop("Please set na.rm for using last with NA in your data \n")
    }
  }else 
    stop("Please provide a vector for the last function \n")
  out
}
f.numericCol <- function(dat, type){
  if(length(grep("index",type))>0){
    index <- as.numeric(substring(type,first=6))
    out <- dat[index]
  }else if (type=="mean"){
    out <- mean(dat,na.rm="TRUE")
  }else if (type=="min"){
    out <- min(dat,na.rm="TRUE")
  }else if (type=="max"){
    out <- max(dat,na.rm="TRUE")
  }else if (type=="median"){
    out <- median(dat,na.rm="TRUE")
  }else if (type=="summary") {
	m1 <- min(dat,na.rm="TRUE")
	m2 <- mean(dat,na.rm="TRUE")
	m3 <- max(dat,na.rm="TRUE")
	out <- c("summary",m1,m2,m3)
  }else{
    eval(parse(text=paste("out <- ",type,"(dat)",sep="")))
  }
  out  
}