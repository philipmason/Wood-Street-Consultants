sparkEPS <- function(filename, para, type) {
	# scale original values
  error <- FALSE
	f.scale <- function(para, type) {
		f.availWidthHeight <- function(para, type) {
			if( type == "bar" )
				para$cw <- para$len*para$barWidth + (para$len-1)*para$barSpacing +  para$left_padding + para$right_padding
			
			para$availWidth <- para$cw - para$left_padding - para$right_padding
			para$availHeight <- para$ch - para$top_padding - para$bottom_padding
			
			if(para$availWidth < 0 | para$availHeight < 0)
				stop("error: height needs to be positive!\n")	
			
			# segment width
			if( type %in% c("line","box") ) 			
				para$sw <- (para$availWidth*1.0) / (para$len-1)	
			if( type == "bar" ) 
				para$sw <- para$barSpacing
			return(para)
		}	
		
		# scale x-values
		f.scale_width <- function(para, type) {	
			l <- para$len
			if( type %in% c("line","box") )				
				width <- (0:(l-1))*para$sw + para$left_padding 
			if( type == "bar" ) 
				width <- (0:(l-1))*para$sw + para$barWidth* (0:(l-1)) + para$left_padding
			return(width)
		}			
		f.scale.height <- function(para, type) {
			h <- para$availHeight		
			mid <- floor(para$ch / 2)		
			v <- para$v		
			if( type == "bar" ) {
				# all positive?
				if ( all(v >= 0, na.rm=TRUE) ) {
					steps <- h/max(v, na.rm=TRUE) 
					out <- v * steps + para$bottom_padding
				}
				# all negative
				else if ( all(v <= 0, na.rm=TRUE) ) {
					steps <- abs(h/min(v, na.rm=TRUE))
					out <- v * steps - para$top_padding	
				}	
				# negative and positive values
				else {
					rg <- range(v, na.rm=TRUE)
					if( abs(rg[1]) > rg[2] )
						steps <- (abs(h/min(v, na.rm=TRUE))) / 2
					else 
						steps <- (h/max(v, na.rm=TRUE)) / 2
					out <- v * steps 
				}						
			}
			else if ( type %in% c("box", "line") ) {
				if ( diff(range(v, na.rm=TRUE)) > 0 )
					v <- as.numeric(scale(v))
				rg <- range(v, na.rm=TRUE)
				if( abs(rg[1]) > rg[2] )
					steps <- (abs(h/min(v, na.rm=TRUE))) / 2
				else 
					steps <- (h/max(v, na.rm=TRUE)) / 2
				out <- v * steps + mid
			}
			return(out)				
		}		
		
		if( type=="box" ) {
			# Transpose
			cw <- para$cw
			ch <- para$ch
			para$ch <- cw
			para$cw <- ch
		}			
		para <- f.availWidthHeight(para, type)
		para$widths <- f.scale_width(para, type)
		para$heights <- f.scale.height(para, type)
		return(para)
	}	
	
	if( !type %in% c("line","bar","box") )
		stop("wrong parameters set!\n")

	para <- f.scale(para, type)
	
	zz <- file.create(filename)		
	zz <- file(filename, "w") 
	
	cat("%!PS-Adobe-3.0 EPSF-3.0\n", file = zz)		
	
	llx <- 0; lly <- 0	
	if ( type %in% c("line", "bar") ) {
		rrx <- para$cw
		rry <- para$ch			
	}
	if ( type == "box" ) {
		rrx <- para$ch
		rry <- para$cw			
	}	
	cat("%%BoundingBox: ", llx, " ", lly, " ", rrx, " ", rry, " \n", file = zz)

	x <- para$widths
	y <- para$heights 		
	
	if( type == "line" ) {
		cat(para$lineWidth, " setlinewidth\n", file = zz) 
		cat("1 setlinejoin\n", file = zz) 
		
		if( para$showIQR == TRUE ) {
			if( diff(range(y, na.rm=TRUE)) == 0 ) 
				cat("there is no variation in the input data, no IQR-box can be shown!\n")
			else {
				colBox <- as.vector(f.colors(para$fillColor))	
				#cat(colBox[1], " ",  colBox[2], " ", colBox[3], " setrgbcolor\n", file=zz) 
				v <- quantile(y, c(0.25, 0.75), na.rm=TRUE)
				cat(x[1], " ", v[1], " moveto\n", file=zz)
				cat(x[length(x)], " ", v[1], " lineto\n", file = zz) 
				cat(x[length(x)], " ", v[2], " lineto\n", file = zz) 
				cat(x[1], " ", v[2], " lineto\n", file = zz) 
				cat(x[1], " ", v[2], " moveto\n", file = zz) 	
				
        cat(paste(f.colors(para$shadowCol),collapse=" ")," setrgbcolor\n", file = zz) 
				cat("fill closepath stroke\n", file = zz) 				
			}			
		}
		# draw extreme points (min|max|current)
		if( para$showVals[[1]] == TRUE ) {
			colMin <- as.vector(f.colors(para$colVals[1]))			
			minX <- which.min(y)
			if ( length(which(y==y[minX])) == 1 ) {
				cat("newpath\n", file=zz)
				cat(x[minX], " ", y[minX], " ", para$pointWidth, " 0 360 arc\n", file=zz)
				cat(colMin[1], " ",  colMin[2], " ", colMin[3], " setrgbcolor fill closepath stroke\n", file=zz) 
			}
		}
		if( para$showVals[[2]] == TRUE ) {
			colMax <- as.vector(f.colors(para$colVals[2]))
			maxX <- which.max(y)
			if ( length(which(y==y[maxX])) == 1 ) {
				cat("newpath\n", file=zz)
				cat(x[maxX], " ", y[maxX], " ", para$pointWidth, " 0 360 arc\n", file=zz)		
				cat(colMax[1], " ",  colMax[2], " ", colMax[3], " setrgbcolor fill closepath stroke\n", file=zz) 
			}
		}
		if( para$showVals[[3]] == TRUE ) {
			colCur <- as.vector(f.colors(para$colVals[3]))
			cat("newpath\n", file=zz)
			cat(x[length(x)], " ", y[length(y)], " ", para$pointWidth, " 0 360 arc\n", file=zz)
			cat(colCur[1], " ",  colCur[2], " ", colCur[3], " setrgbcolor fill closepath stroke\n", file=zz) 
		}			
		lineCol <- as.vector(f.colors(para$lineCol))
		cat(lineCol[1], " ",  lineCol[2], " ", lineCol[3], " setrgbcolor\n", file=zz) 
		
		notNAind <- which(!is.na(y))
		startInd <- min(notNAind)
		cat("newpath\n",x[startInd], " ", y[startInd], " moveto\n", file = zz) 
		for( i in (startInd+1):length(x) ) {
			if( !is.na(y[i]) ) 
				cat(x[i], " ", y[i], " lineto\n", file = zz)	
			else {
				ind <- which(notNAind > i)
				if ( length(ind) > 0 ) {
					nextInd <- notNAind[min(ind)]
					cat(x[nextInd], " ", y[nextInd], " moveto\n", file = zz)					
				}	
			}
		}
		cat(x[i], " ", y[i], " moveto\n", file = zz) 	
	}
	if( type == "bar" ) {
		l <- para$len		
		mid <- para$ch / 2
		
		# set up colors
		colBarPos 	<- as.vector(f.colors(para$barCol[1]))		
		colBarNeg 	<- as.vector(f.colors(para$barCol[2]))		
		colBarZero 	<- as.vector(f.colors(para$barCol[3]))		
		
		# draw bars
		# case 1) all values are >= 0
		if( all(para$v >= 0, na.rm=TRUE) ) {
			for ( i in 1:length(x) ) {					
				if( !is.na(y[i]) ) {
					cat(colBarPos[1], " ",  colBarPos[2], " ", colBarPos[3], " setrgbcolor\n", file=zz) 
					cat("newpath\n", file = zz)
					cat(x[i], " ", para$bottom_padding, " moveto\n", file = zz)		
					cat(0, " ", y[i]-para$bottom_padding, " rlineto\n", file = zz)
					cat(para$barWidth, " ", 0, " rlineto\n", file = zz)
					cat(0, " ", -y[i]+para$bottom_padding, " rlineto\n", file = zz)
					
					cat("closepath fill\n", file = zz)					
				}
			}	
			cat(colBarZero[1], " ",  colBarZero[2], " ", colBarZero[3], " setrgbcolor\n", file=zz) 
			cat(x[1], " ", para$bottom_padding, " moveto\n", file = zz)		
			cat(para$barWidth+x[l]-x[1], " ", 0, " rlineto\n", file = zz)
			cat("0.3 setlinewidth\n", file = zz) 
			cat("stroke\n", file = zz)		
		}
		# case 2) all values are < 0
		else if( all(para$v < 0, na.rm=TRUE) ) {
			for ( i in 1:length(x) ) {					
				if( !is.na(y[i]) ) {
					cat(colBarNeg[1], " ",  colBarNeg[2], " ", colBarNeg[3], " setrgbcolor\n", file=zz) 
					cat("newpath\n", file = zz)
					cat(x[i], " ", para$ch-para$top_padding, " moveto\n", file = zz)		
					cat(0, " ", y[i], " rlineto\n", file = zz)
					cat(para$barWidth, " ", 0, " rlineto\n", file = zz)
					cat(0, " ", -y[i], " rlineto\n", file = zz)					
					cat("closepath fill\n", file = zz)					
				}
			}	
			cat(colBarZero[1], " ",  colBarZero[2], " ", colBarZero[3], " setrgbcolor\n", file=zz) 
			cat(x[1], " ", para$ch-para$top_padding, " moveto\n", file = zz)		
			cat(para$barWidth+x[l]-x[1], " ", 0, " rlineto\n", file = zz)
			cat("0.3 setlinewidth\n", file = zz) 
			cat("stroke\n", file = zz)					
		}
		# case 3) values are around zero
		else {
			for ( i in 1:length(x) ) {
				if( !is.na(y[i]) ) {
					if( y[i] == 0 ) 
						cat(colBarZero[1], " ",  colBarZero[2], " ", colBarZero[3], " setrgbcolor\n", file=zz) 
					if( y[i] > 0 ) 
						cat(colBarPos[1], " ",  colBarPos[2], " ", colBarPos[3], " setrgbcolor\n", file=zz) 
					if( y[i] < 0 ) 
						cat(colBarNeg[1], " ",  colBarNeg[2], " ", colBarNeg[3], " setrgbcolor\n", file=zz) 
					
					cat("newpath\n", file = zz)
					
					cat(x[i], " ", mid, " moveto\n", file = zz)		
					cat(0, " ", y[i], " rlineto\n", file = zz)
					cat(para$barWidth, " ", 0, " rlineto\n", file = zz)
					cat(0, " ", -y[i], " rlineto\n", file = zz)	
					
					cat("closepath\n", file = zz)
					cat("fill\n", file = zz)						
				}	
			}	
			# Mid-Line (TODO: paraional?)
			cat(colBarZero[1], " ",  colBarZero[2], " ", colBarZero[3], " setrgbcolor\n", file=zz) 
			cat(x[1], " ", mid, " moveto\n", file = zz)		
			cat(para$barWidth+x[l]-x[1], " ", 0, " rlineto\n", file = zz)
			cat("0.3 setlinewidth\n", file = zz) 
			cat("stroke\n", file = zz)				
		}
	}
	if( type == "box" ) {
		if( sd(y, na.rm=T) > 0 ) {
			l <- para$len
			sw <- para$sw		
			mid <- para$cw / 2
			upBox <- para$cw - para$top_padding
			downBox <- para$bottom_padding
			
			upBox1 <- (para$cw/2) + (upBox-downBox)/4
			downBox1 <- (para$cw/2) - (upBox-downBox)/4
			
			boxStats <- boxplot.stats(y)		
			
			# set up colors
			colBox <- as.vector(f.colors(para$boxCol[1]))
			colMed <- as.vector(f.colors(para$boxMedCol))
			colOut <- as.vector(f.colors(para$boxOutCol[1]))
			colMargin <- as.vector(f.colors(para$boxCol[2]))
			colWhisker <- as.vector(f.colors(para$boxCol[3]))
			
			# draw main box	
			cat("newpath\n", file = zz)
			cat(boxStats$stats[2], " ", downBox, " moveto\n", file = zz)		
			cat(0, " ", upBox-downBox, " rlineto\n", file = zz)
			cat(boxStats$stats[4]-boxStats$stats[2], " ", 0, " rlineto\n", file = zz)
			cat(0, " ", -(upBox-downBox), " rlineto\n", file = zz)
			cat("closepath\n", file = zz)
			cat("gsave\n", file = zz)
			
			cat(colBox[1], " ",  colBox[2], " ", colBox[3], " setrgbcolor\n", file=zz) 
			cat("fill\n", file = zz)
			
			cat("grestore\n", file = zz)
			cat(colMargin[1], " ",  colMargin[2], " ", colMargin[3], " setrgbcolor\n", file=zz) 
			cat("1 setlinewidth\n", file=zz)
			cat("stroke\n", file = zz)
			
			# median
			cat(colMed[1], " ",  colMed[2], " ", colMed[3], " setrgbcolor\n", file=zz) 
			cat("newpath\n", file = zz)	
			cat(boxStats$stats[3], " ", downBox, " moveto\n", file = zz)		
			cat(0, " ",upBox-downBox, " rlineto\n", file = zz)	
			cat("2 setlinewidth\n", file=zz)
			cat("stroke\n", file = zz)	
			
			# hinges
			cat(colWhisker[1], " ",  colWhisker[2], " ", colWhisker[3], " setrgbcolor\n", file=zz) 
			cat("newpath\n", file = zz)	
			cat(boxStats$stats[1], " ", downBox1, " moveto\n", file = zz)		
			cat(0, " ",upBox1-downBox1, " rlineto\n", file = zz)	
			cat("1 setlinewidth\n", file=zz)
			cat("stroke\n", file = zz)		
			
			cat("newpath\n", file = zz)	
			cat(boxStats$stats[5], " ", downBox1, " moveto\n", file = zz)		
			cat(0, " ",upBox1-downBox1, " rlineto\n", file = zz)	
			cat("1 setlinewidth\n", file=zz)
			cat("stroke\n", file = zz)			
			
			# outliers
			if( length(boxStats$out) > 0 & para$boxShowOut == TRUE ) {
				cat(colOut[1], " ",  colOut[2], " ", colOut[3], " setrgbcolor\n", file=zz) 
				for( j in 1:length(boxStats$out) ) {
					cat("newpath\n", file = zz)
					cat(boxStats$out[j], " ", (para$cw/2), " ", "1 0 360 arc\n", file = zz)
					cat("closepath stroke\n", file = zz)				
				}	
			}			
			cat(colMed[1], " ",  colMed[2], " ", colMed[3], " setrgbcolor\n", file=zz) 
			
			# dotted lines
			cat("[2 2] 0 setdash\n", file=zz)
			cat("newpath\n", file = zz)	
			cat(boxStats$stats[1], " ", mid, " moveto\n", file = zz)		
			cat((boxStats$stats[2]-boxStats$stats[1]), " ",0, " rlineto\n", file = zz)	
			cat("0.5 setlinewidth\n", file=zz)
			cat("stroke\n", file = zz)	
			
			cat("[2 2] 0 setdash\n", file=zz)
			cat("newpath\n", file = zz)	
			cat(boxStats$stats[4], " ", mid, " moveto\n", file = zz)		
			cat((boxStats$stats[5]-boxStats$stats[4]), " ",0, " rlineto\n", file = zz)	
			cat("0.5 setlinewidth\n", file=zz)
			cat("stroke\n", file = zz)
      error <- FALSE
		}
		else {
			cat("no variation in the data -> boxplot can't be drawn!\n")
			error <- TRUE
		}	
	}	
	
	if ( type %in% c("bar", "box") )
		cat("showpage\n", file = zz)
	if ( type == "line" )
		cat("closepath stroke\n", file = zz) 	
	close(zz)		
	if( error )
		file.remove(filename)
}