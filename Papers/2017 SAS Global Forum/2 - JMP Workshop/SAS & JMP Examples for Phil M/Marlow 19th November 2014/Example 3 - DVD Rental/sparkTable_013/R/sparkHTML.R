sparkHTML <-
    function(filename, para,type,return=FALSE,fixedIndex=FALSE)
{
  data <- para$v
  lines <- vector()
  lines[length(lines)+1] <- "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">"
  lines[length(lines)+1] <- "<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\"><head>"
  lines[length(lines)+1] <- "<script type=\"text/javascript\" src=\"jquery-1.4.2.js\"></script>"
  lines[length(lines)+1] <- "<script type=\"text/javascript\" src=\"jquery.sparkline.js\"></script>"
  
  if(!any(search()=="sparksENV")){
    sparksENV <- new.env()
    attach(sparksENV)
  }
  if(!exists(".sparklineIndex",which(search()=="sparksENV"))){
    assign(".sparklineIndex",1,which(search()=="sparksENV"))
    sparklineIndex <- 1
  }else if(is.numeric(fixedIndex)){
    sparklineIndex <- fixedIndex
    assign(".sparklineIndex",sparklineIndex,which(search()=="sparksENV"))
  }else if(!fixedIndex){
    sparklineIndex <- get(".sparklineIndex",which(search()=="sparksENV"))+1
    assign(".sparklineIndex",sparklineIndex,which(search()=="sparksENV"))
  }else if(fixedIndex)
    sparklineIndex <- get(".sparklineIndex",which(search()=="sparksENV"))
  lines[length(lines)+1] <- "<script type=\"text/javascript\">"
  lines[length(lines)+1] <- "$(function() {"
  start1 <- length(lines)

  
  
  if(para$cw!="auto")
    para$cw <- paste(para$cw,"px",sep="")
  if(para$ch!="auto")
    para$ch <- paste(para$ch,"px",sep="")
  if(type=="line"){
    if(para$showIQR){
      rectlim <- vector()
      rectlim[1] <- quantile(data,.25, na.rm=TRUE)
      rectlim[2] <- quantile(data,.75, na.rm=TRUE)
      para$fillColor
      normalRange <- paste(",normalRangeMin:'",rectlim[1],"',normalRangeMax:'",rectlim[2],"',normalRangeColor:'",para$fillColor,"'",sep="")
    }else
      normalRange <- ""

    if(para$showVals[2])
      minSpotColor <- paste("'",para$colVals[1],"'",sep="")
    else
      minSpotColor <- "false"
    if(para$showVals[1])
      maxSpotColor <- paste("'",para$colVals[2],"'",sep="")
    else
      maxSpotColor <- "false"
    if(para$showVals[3])
      spotColor <- paste("'",para$colVals[3],"'",sep="")
    else
      spotColor <- "false"
    if(para$shadow)
      fillColor <- paste("'",para$shadowCol,"'",sep="")
    else
      fillColor <- "false"
    lines[length(lines)+1] <- paste("$('",paste(".inlinesparkline",sparklineIndex,sep=""),"').sparkline('html',{lineColor:'",para$lineCol,
        "',minSpotColor:",minSpotColor,",maxSpotColor:",maxSpotColor,",spotColor:",spotColor,
        ",fillColor:",fillColor,"",normalRange,",",
        "lineWidth:",para$lineWidth,",","spotRadius:",para$pointWidth,",",
        "height:'",para$ch,"',","width:'",para$cw,"'",
        "});",sep="")
  }else if(type=="bar"){
    
    
    lines[length(lines)+1] <- paste("$('",paste(".inlinesparkline",sparklineIndex,sep=""),"').sparkline('html', { type:'bar',",
    "barColor:'",para$barCol[1],"'",",",
    "negBarColor:'",para$barCol[2],"'",",",
    "zeroColor:'",para$barCol[3],"'",",",
    "barWidth:",para$barWidth,"",",",
    "barSpacing:",para$barSpacing,"",

    "});",sep="")
  }else if(type=="box"){
    if(para$boxShowOut)
      showOutliers <- "true"
    else
      showOutliers <- "false"
    lines[length(lines)+1] <- paste("$('",paste(".inlinesparkline",sparklineIndex,sep=""),"').sparkline('html', { type:'box',",
    "boxFillColor :'",para$boxCol[1],"'",",",
    "boxLineColor:'",para$boxCol[2],"'",",",
    "whiskerColor :'",para$boxCol[3],"'",",",
    "outlierFillColor:'",para$boxOutCol[1],"'",",",
    "outlierLineColor:'",para$boxOutCol[2],"'",",",
    "showOutliers:",showOutliers,"",",",
    "medianColor :'",para$boxMedCol,"'",
    "});",sep="")
  }else
    stop(paste(type,"type not supported"))
  lines[length(lines)+1] <- "});"
  end1 <- length(lines)
  lines[length(lines)+1] <- "</script>"
  lines[length(lines)+1] <- "</head><body><p>Your sparkline:<br>"
  data[is.na(data)] <- "null"
  lines[length(lines)+1] <- paste("<span class=\"",paste("inlinesparkline",sparklineIndex,sep=""),"\">",paste(data,collapse=","),"</span>",sep="")
  start2 <- length(lines)
  #filename1 <- unlist(strsplit(filename,"\\."))[1]
  #textCon<- file(paste(filename1,".html",sep=""), "w")
  if(!return){
    textCon<- file(filename, "w")
    for(i in 1:length(lines)){
      writeLines(lines[i],textCon)    
    }
    close(textCon)
    path2etc <- paste(searchpaths()[grep("sparkline", searchpaths())], "\\etc", sep="")
    file.copy(paste(path2etc,"/jquery.sparkline.js",sep=""), paste(getwd(),"/jquery.sparkline.js",sep=""), overwrite = TRUE)
    file.copy(paste(path2etc,"/jquery-1.4.2.js",sep=""), paste(getwd(),"/jquery-1.4.2.js",sep=""), overwrite = TRUE)
    cat("HTML Output written in: \n")
    #cat(paste(filename1,".html",sep=""),"\n")
    cat(filename,"\n")
  }else{
    #cat("HTML-Text is returned for further use inside of R\n")
    list(head=lines[start1:end1],body=lines[start2])    
  }
}



