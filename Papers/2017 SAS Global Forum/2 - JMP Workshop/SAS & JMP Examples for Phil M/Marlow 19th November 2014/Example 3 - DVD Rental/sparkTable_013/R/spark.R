# TODO: Parameter beschreiben
# type %in% c("line", "bar", "box")
# output %in% c("html", "eps")
spark <- function(filename, para, type, output, outdir=NULL) {
	#TODO: Parameter von "para" überpruefen!
	if(!type %in% c("line","bar","box")) 
		stop("wrong parameter",type,"specified!\n")
	if(!output %in% c("html","eps")) 
		stop("wrong parameter",output,"specified!\n")	
	
	if (is.null(outdir) || !file.exists(outdir) )
		outdir <- getwd()	
	
	filename <- paste(outdir, filename, sep="/")
	if(output=="eps")
		sparkEPS(filename, para, type)	
	if(output=="html") 
		sparkHTML(filename,para,type)
}