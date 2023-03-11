print.sparkTable <- function(x, outdir=NULL, outfile=NULL, rowVec=NULL, colVec=NULL, digits=2,...) {
  objMeta <- x
	if( class(objMeta) != "sparkTable" )
		stop("wrong class!\n")
	
	savedir <- getwd()
	newdir <- paste(savedir,"/",outdir, sep="")
	if ( is.null(outdir) )
		outdir <- getwd()
	if( (outdir != getwd()) & !file.exists(outdir) ) 
		dir.create(outdir)
	
	setwd(outdir)
	plotDat <- objMeta$metaData
	metaInfo <- objMeta$metaInfo
	nRows <- length(plotDat)
	nCols <- length(metaInfo$colsType)
	m <- matrix(NA, nrow=nRows, ncol=nCols)	
	
	if( metaInfo$output=="eps" ) 
		metaInfo$html_header <- metaInfo$htmlTable <- list()

	if( metaInfo$output=="html" ) 
		metaInfo$epsTable <- list()

  	metaInfo$html_header <- list()
  	for( i in 1:nRows ) {
		metaInfo$filenames[[i]] <- list()
		for( j in 1:nCols ) {
			if( metaInfo$output=="eps" ) {
        		metaInfo$filenames[[i]][[j]] <- paste("out",i,j,".eps", sep="")
				if(is.numeric(plotDat[[i]][[j]])&&length(plotDat[[i]][[j]])==1){
          			m[i,j] <- paste("$",round(plotDat[[i]][[j]],digits),"$",sep= "")
        		}
				else if(plotDat[[i]][[j]][1]=="summary") {
					x <- plotDat[[i]][[j]]
					x <- as.numeric(x[2:length(x)])
					x <- round(x, digits)
					m[i,j] <- paste("$",x[1],"|",x[2],"|", x[3],"$", sep="")
				}
				else{
          			m[i,j] <- paste("\\includegraphics[height=1.8em]{", metaInfo$filenames[[i]][[j]], "}",sep="")
          			spark(metaInfo$filenames[[i]][[j]], plotDat[[i]][[j]], type=metaInfo$colsType[j], output=metaInfo$output)
        		}
			}
			if( metaInfo$output=="html" ) {
        		if(is.numeric(plotDat[[i]][[j]])&&length(plotDat[[i]][[j]])==1){
         			m[i,j] <- round(plotDat[[i]][[j]],digits)
        		}
				else if(plotDat[[i]][[j]][1]=="summary") {
					x <- plotDat[[i]][[j]]
					x <- as.numeric(x[2:length(x)])
					x <- round(x, digits)
					m[i,j] <- paste(x[1],"|",x[2],"|", x[3], sep="")
				}					
				else{
          			out <- sparkHTML("",plotDat[[i]][[j]], type=metaInfo$colsType[j], return=TRUE, fixedIndex=j)
				  	m[i,j] <- out$body
				  	if(i==1)
            			metaInfo$html_header[[length(metaInfo$html_header)+1]] <- out$head
        		}
			}			
		}
	}		
	
	#setwd(savedir)
	if (!is.null(rowVec) & length(rowVec) == nrow(m))
		rownames(m) <- rowVec
	else
		rownames(m) <- replaceStr(metaInfo$groups,"underline")
	
	if (!is.null(colVec) & length(colVec) == ncol(m))
		colnames(m) <- colVec
	else
		colnames(m) <- paste(metaInfo$colsVar,metaInfo$colsType,sep=" - ")	

	# quick and dirty
	if ( metaInfo$output == "eps" ) {
		indexValues <- which(as.character(sapply(m[1,], substr, 1, 1))=="$")
		indexGraphs <- setdiff(1:ncol(m), indexValues)
		m <- m[,c(indexGraphs,indexValues)]
		#colnames(m) <- colnames(m)[c(indexGraphs,indexValues)]
	}	
	
	m <- xtable(m)
	
	if( metaInfo$output=="eps" )
		metaInfo$epsTable <- print(m, sanitize.text.function = function(x){x})
	else if( metaInfo$output=="html" )	
		metaInfo$htmlTable <- print(m, sanitize.text.function = function(x){x}, type="html")
	objMeta$metaInfo <- metaInfo
	objMeta	
  out <- list()
  if( metaInfo$output=="eps" ){
    out$epsTable <- metaInfo$epsTable
    if(!is.null(outfile)){
     ###TODO: OUTPUT small tex file [partially]
     textCon<- file(outfile, "w")
     cat("\\documentclass[a4paper,12pt,landscape]{article}","\n",file=textCon)
     cat("\\usepackage{graphicx}","\n",file=textCon)
     cat("\\usepackage{lmodern}","\n",file=textCon) 
	 cat("\\usepackage[landscape]{geometry}","\n",file=textCon) 
     cat("\\begin{document}","\n",file=textCon)
     cat(out$epsTable,"\n",file=textCon)
     cat("\\end{document}","\n",file=textCon)
     close(textCon)
    }
  }else if( metaInfo$output=="html" ){
    out$html_header <- metaInfo$html_header  
    out$htmlTable <- metaInfo$htmlTable
    if(!is.null(outfile)){
      lines <- vector()
      textCon<- file(outfile, "w")
      lines[length(lines)+1] <- "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">"
      lines[length(lines)+1] <- "<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\"><head>"
      lines[length(lines)+1] <- "<script type=\"text/javascript\" src=\"jquery-1.4.2.js\"></script>"
      lines[length(lines)+1] <- "<script type=\"text/javascript\" src=\"jquery.sparkline.js\"></script>"
      lines[length(lines)+1] <- "<script type=\"text/javascript\">"
      for(i in 1:length(lines)){
        writeLines(lines[i],textCon)    
      }
      for(i in 1:length(out$html_header)){
        for(j in 1:length(out$html_header[[i]])){
          cat(out$html_header[[i]][j],"\n",file=textCon)
        }
        cat(paste(out$html_header[[i]],collapse=" \n "))
      }
      cat("</script></head><body> \n",file=textCon)
      cat(out$htmlTable,file=textCon)
      cat("</body></html>",file=textCon)
      close(textCon)
      pathEtc <- paste(searchpaths()[grep("sparkTable", searchpaths())], "/etc", sep="")
      file.copy(paste(pathEtc,"/jquery.sparkline.js",sep=""), paste(getwd(),"/jquery.sparkline.js",sep=""))
      file.copy(paste(pathEtc,"/jquery-1.4.2.js",sep=""), paste(getwd(),"/jquery-1.4.2.js",sep=""))
    }
  }
  setwd(savedir)
  out   
}
