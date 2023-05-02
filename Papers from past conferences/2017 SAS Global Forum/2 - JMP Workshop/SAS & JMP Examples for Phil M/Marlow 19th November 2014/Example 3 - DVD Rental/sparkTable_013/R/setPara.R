setPara <- function(metaObj, para, val, col=NULL) {
	for (i in 1:length(metaObj)) {
		if (is.null(col))
			col <- 1:length(metaObj[[i]])
		for (j in col) {
			index <- which(para == names(metaObj[[i]][[j]]))	
			if (length(index) > 0)
				metaObj[[i]][[j]][index] <- val			
		}
	}
	metaObj
}	