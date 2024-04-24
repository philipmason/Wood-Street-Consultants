### Initialisierung der Optionen ###
spark_init <- function(
		v,		
		cw=100,
		ch=50,
		#scale_from=FALSE,
		#scale_to=FALSE,	
		top_padding=5,
		bottom_padding=5,	
		left_padding=5,
		right_padding=5,	
		
		# allgemein	
		showIQR=TRUE,
		
		# Line
		showVals=rep(TRUE, 3),
		colVals=c("#f00", "#0f0", "#00f"),
		fillColor="#ccc", # filling under line [now: iqr box]
		pointWidth=1.5, # point Width	
		lineWidth=1,
		lineCol="#000",
		shadow=FALSE,
		shadowCol="#ccc",
		# Bar
		barCol=c("#00f", "#f00", "#000"), # positive|negative|zero
		barWidth=3, # not used because of cw|ch
		barSpacing=1, # paddding_between_bars??
		
		# Box
		boxOutCol=c("#f00","#f00"), # outlier, filling|line [currently only para 1 used]
		boxMedCol="#000",	# median color
		boxShowOut=TRUE,	# show outliers
   	 	boxCol=c("#fff","#00f","#00f"),		
		type	
) {
	if(!type %in% c("line","bar","box"))		
		stop("wrong parameter", type,"!\n")		
	
	para <- list()
	para$cw <- cw
	para$ch <- ch	
	para$v <-  v
	para$len <- length(v)	
	#para$scale_from=scale_from
	#para$scale_to=scale_to	
	para$top_padding=top_padding
	para$bottom_padding=bottom_padding
	para$left_padding=left_padding
	para$right_padding=right_padding		
	
	if(type=="line") {
		para$showVals <- showVals
		if(	length(colVals)==3 & 
			f.checkColors(colVals[1]) & 
			f.checkColors(colVals[2]) &
			f.checkColors(colVals[3]))
			para$colVals <- colVals
		else
			stop("Error specifying parameter", colVals,"\n")
		
		if(f.checkColors(fillColor))
			para$fillColor <- fillColor # filling under line
		else
			stop("Error specifying parameter", fillColor,"\n")		
		
		para$pointWidth <- pointWidth
		para$lineWidth <- lineWidth
		
		if(f.checkColors(lineCol))
			para$lineCol <- lineCol 
		else
			stop("Error specifying parameter", lineCol,"\n")			
		
		para$showIQR <- showIQR
		para$shadow <- shadow
		
		if(f.checkColors(shadowCol))
			para$shadowCol <- shadowCol 
		else
			stop("Error specifying parameter", shadowCol,"\n")			
		
		# parameters not used in line-plots
		para$barCol <- para$barSpacing <- para$barWidth <- NULL		
		para$boxOutCol <- para$boxMedCol <- para$boxShowOut <- NULL
	}
	if(type=="bar") {
		# bar specific parameters
		if(	length(barCol)==3 & 
				f.checkColors(barCol[1]) & 
				f.checkColors(barCol[2]) &
				f.checkColors(barCol[3]))
			para$barCol <- barCol
		else
			stop("Error specifying parameter", barCol,"\n")		
		
		para$barSpacing <- barSpacing
		para$barWidth <- barWidth
		# parameters not used in bar-plots
		para$showVals <- para$colVals <- para$fillColor <- para$lineCol <- shadow <- shadowCol <- NULL
		para$showIQR <- para$boxOutCol <- para$boxMedCol <- para$boxShowOut <- NULL
	}
	if(type=="box") {
		# box specific parameters
		para$showIQR <- showIQR
		para$boxOutCol <- boxOutCol
		if(	length(boxOutCol)==2 & 
				f.checkColors(boxOutCol[1]) & 
				f.checkColors(boxOutCol[2]))
			para$boxOutCol <- boxOutCol
		else
			stop("Error specifying parameter", boxOutCol,"\n")			
		
		if(f.checkColors(boxMedCol))
			para$boxMedCol <- boxMedCol 
		else
			stop("Error specifying parameter", boxMedCol,"\n")		
		
		
		para$boxShowOut <- boxShowOut
		if(	length(boxCol)==3 & 
				f.checkColors(boxCol[1]) & 
				f.checkColors(boxCol[2]) &
				f.checkColors(boxCol[3]))
			para$boxCol <- boxCol
		else
			stop("Error specifying parameter", boxCol,"\n")	
		
		# parameters not used in box-plots
		para$showVals <- para$colVals <- para$fillColor <- para$lineCol <- shadow <- shadowCol <- NULL
		para$barCol <- para$barSpacing <- para$barWidth <- NULL
	}  
	return(para)
}
