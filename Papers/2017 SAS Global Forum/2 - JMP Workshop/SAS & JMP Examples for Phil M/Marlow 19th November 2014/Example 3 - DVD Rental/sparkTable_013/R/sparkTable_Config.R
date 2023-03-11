# Bernhard Meindl, Alexander Kowarik, STAT
sparkTable_Config<- function(df, groups=NULL, groupVar=NULL, vars, typeNumeric, typePlot, output) {
	if(is.null(groups)&is.null(groupVar)) {
		df$gr <- 1:nrow(df)
		groups <-  1:nrow(df)
		groupVar <- "gr"
	}
	colInd1 <- which(colnames(df)%in% groupVar)
	colInd2 <- which(colnames(df)%in% vars)		
	
	dat <- df[,c(colInd1, colInd2)]; rm(colInd1, colInd2)
	colInd1 <- colnames(dat)%in% groupVar
	dat <- dat[which(dat[,colInd1] %in% groups),]
	
	tab.rows <- length(groups)
	
	if(!is.null(typeNumeric)){
		if(is.list(typeNumeric)){
			if(!length(typeNumeric)==length(vars))
				stop("The list typeNumeric must be of length equal to the numbers of variables used!\n")
			colsNumeric <- list()
			colsNumericVar <- list()
			for(i in 1:length(vars)){
				inds <- list()
				indv <- vector()
				for(t in 1:length(typeNumeric[[i]])){
					type <- typeNumeric[[i]][t]
					if(length(grep("--",type))>0){
						ind <- unlist(strsplit(type,"--"))
						inds[[length(inds)+1]] <- paste("index",ind[1]:ind[2],sep="")
						indv[length(indv)+1] <- t
					} 
				}
				if(length(indv>0)){
					for(v in 1:length(indv)){
						typeNumeric[[i]] <- append(typeNumeric[[i]],inds[[v]],indv[v])[-indv[v]]
						indv <- indv+length(inds[[v]])-1
					}
				}          
				colsNumeric[[i]] <- typeNumeric[[i]]
				colsNumericVar[[i]] <- rep(vars[i],length(typeNumeric[[i]]))
			} 
		}
		else{
			colsNumeric <- list()
			colsNumericVar <- list()
			for(i in 1:length(vars)){
				inds <- list()
				indv <- vector()
				for(t in 1:length(typeNumeric)){
					type <- typeNumeric[t]
					if(length(grep("--",type))>0){
						ind <- unlist(strsplit(type,"--"))
						inds[[length(inds)+1]] <- paste("index",ind[1]:ind[2],sep="")
						indv[length(indv)+1] <- t
					} 
				}
				if(length(indv>0)){
					for(v in 1:length(indv)){
						typeNumeric <- append(typeNumeric,inds[[v]],indv[v])[-indv[v]]
						indv <- indv+length(inds[[v]])-1
					}
				} 
				colsNumeric[[i]] <- typeNumeric
				colsNumericVar[[i]] <- rep(vars[i],length(typeNumeric))
			}
		}
	}
	else{
		colsNumeric <- list()
		for(i in 1:length(vars)){
			colsNumeric[[i]] <- vector()
		}
		colsNumericVar <- colsNumeric
	}
	if(!is.null(typePlot)){
		if(is.list(typePlot)){
			if(!length(typePlot)==length(vars))
				stop("The list typePlot must be of length equal to the numbers of variables used!\n")
			colsPlot <- list()
			colsPlotVar <- list()
			for(i in 1:length(vars)){
				colsPlot[[i]] <- typePlot[[i]]
				colsPlotVar[[i]] <- rep(vars[i],length(typePlot[[i]]))
			} 
		}
		else{
			colsPlot <- list()
			colsPlotVar <- list()
			for(i in 1:length(vars)){
				colsPlot[[i]] <- typePlot
				colsPlotVar[[i]] <- rep(vars[i],length(typePlot))
			}
		}	
	}
	else{
		colsPlot <- list()
		for(i in 1:length(vars)){
			colsPlot[[i]] <- vector()
		}
		colsPlotVar <- colsPlot
	}
	colsType <- list()
	colsVar <- list()
	
	for(i in 1:length(vars)){
		if(any(is.na(colsNumeric[[i]]))){
			cN <- vector()
			cNV <- vector()
		}else {
			cN <- colsNumeric[[i]]
			cNV <- colsNumericVar[[i]]
		}
		if(any(is.na(colsPlot[[i]]))){
			cP <- vector()
			cPV <- vector()
		}else {
			cP <- colsPlot[[i]]
			cPV <- colsPlotVar[[i]]
		}
		colsType[[i]] <- c(cN,cP)
		colsVar[[i]] <- c(cNV,cPV)
	}
	colsType <- unlist(colsType)
	colsVar <- unlist(colsVar)
	if(length(colsType)!=length(colsVar))
		stop("Something's wrong !\n")
	tab.cols <- length(colsType)
	
	metaData <- list()
	
	for (i in 1:tab.rows) {
		metaData[[i]] <-  list()
		for(j in 1:tab.cols) {
			if(colsType[j] %in% c("line", "box","bar"))
				metaData[[i]][[j]] <- spark_init(subset(dat, dat[,groupVar]==groups[i])[,colsVar[j]], type=colsType[j])
			else
				metaData[[i]][[j]] <- f.numericCol(subset(dat, dat[,groupVar]==groups[i])[,colsVar[j]], type=colsType[j])
		}
	}
	
	metaInfo <- list()
	metaInfo$vars <- vars
	metaInfo$typeNumeric <- typeNumeric
	metaInfo$typePlot <- typePlot
	metaInfo$colsType <- colsType
	metaInfo$colsVar <- colsVar
	metaInfo$groups <- groups
	metaInfo$filenames <- list()
	metaInfo$output <- output
	
	meta <- list()
	meta$metaData <- metaData
	meta$metaInfo <- metaInfo
	class(meta) <- "sparkTable"
	meta
}
