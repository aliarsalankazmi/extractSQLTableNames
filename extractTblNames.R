extractTableNames <- function(myDirectory, myEncoding, myFileExtension){
myDir <- myDirectory
fileExt <- myFileExtension
fileExt <- gsub(',', '|', fileExt)
fileExt <- gsub('^', '.*(', fileExt)
fileExt <- gsub('$', ')$', fileExt)
myFilesName <- list.files(path = myDir, pattern = fileExt, ignore.case = TRUE)
myFilesPath <- paste(myDir, myFilesName, sep = '/')
if(myEncoding != 'Unicode'){
sqlFiles <- lapply(myFilesPath, function(x) paste(scan(file = x, what = '', blank.lines.skip = TRUE, sep = '\n'), collapse = ' '))
} else{
sqlFiles <- sapply(myFilesPath, function(x) paste(readLines(con <- file(x, encoding = "UCS-2LE")), collapse = '\n'))
}
names(sqlFiles) <- myFilesName
sqlMod <- gsub(pattern = '\n|\t', replacement = ' ', x= sqlFiles)
sqlMod <- gsub(pattern = '\\s+', replacement = ' ', x = sqlMod)
##a regex to extract table names follows, and was formulated with help of: http://goo.gl/qMpCAy
#tableNames1 <- lapply(sqlMod, function(y) gsub(pattern = '.*?(from|join)\\s*([[:alnum:]]+_|\\.*[[:alnum:]]+)', replacement = '\\1 : \\2~', x = y, ignore.case = TRUE))
##the above was discontinued in favour of the following, more adequate regex
tableNames1 <- lapply(sqlMod, function(y) gsub(pattern = '.*?(from|join)\\s*([[:alnum:]]+)(_|\\.|@)*([[:alnum:]]+)', replacement = '\\1 : \\2\\3\\4~', x = y, ignore.case = TRUE))
tableNames2 <- sapply(tableNames1, function(x) strsplit(x, split = '~'))
namesLength <- lapply(tableNames2, function(x) nchar(x) < 50)
tableNames3 <- mapply(function(x,y) x[y], tableNames2, namesLength)
finalFileName <- 'tableNames.txt'
finalFilePath <- paste(myDir, finalFileName, sep = '/')
###----add if here?
###finalResult <- for (i in seq_along(tableNames3)){
###	for (j in seq_along(tableNames3[[i]])){
###		cat(names(tableNames3[i]), tableNames3[[i]][j], sep = '\n', append = TRUE, file = finalFilePath)}}
###file.show(finalFilePath)
###-----end if here
tblsInSqlFile <- sapply(tableNames3, length)
tblsInSql <- rep(names(tableNames3), times = tblsInSqlFile)
df1 <- data.frame(sqlFileName = tblsInSql, tableNames = unlist(tableNames3))
write.table(x = df1, file = finalFilePath)
}


##running the function
extractTableNames(myDir, 'Unicode', 'sql|txt')
