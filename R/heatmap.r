library(jsonlite)

args <- commandArgs(TRUE)

HCtoJSON<-function(hc){
  
  labels<-hc$labels
  merge<-data.frame(hc$merge)
  
  for (i in (1:nrow(merge))) {
    
    if (merge[i,1]<0 & merge[i,2]<0) {eval(parse(text=paste0("node", i, "<-list(name=\"node", i, "\", children=list(list(name=labels[-merge[i,1]]),list(name=labels[-merge[i,2]])))")))}
    else if (merge[i,1]>0 & merge[i,2]<0) {eval(parse(text=paste0("node", i, "<-list(name=\"node", i, "\", children=list(node", merge[i,1], ", list(name=labels[-merge[i,2]])))")))}
    else if (merge[i,1]<0 & merge[i,2]>0) {eval(parse(text=paste0("node", i, "<-list(name=\"node", i, "\", children=list(list(name=labels[-merge[i,1]]), node", merge[i,2],"))")))}
    else if (merge[i,1]>0 & merge[i,2]>0) {eval(parse(text=paste0("node", i, "<-list(name=\"node", i, "\", children=list(node",merge[i,1] , ", node" , merge[i,2]," ))")))}
  }
  
  eval(parse(text=paste0("JSON<-toJSON(node",nrow(merge), ")")))
  
  return(JSON)
}

theMatrix = as.matrix(read.table(args[1],header=TRUE,sep="\t",row.names = 1))
values = heatmap(theMatrix,keep.dendro=TRUE)
rowJSON = HCtoJSON(as.hclust(values$Rowv))
colJSON = HCtoJSON(as.hclust(values$Colv))
shuffledMatrix = theMatrix[values$rowInd,values$colInd]
matrixJSON = toJSON(shuffledMatrix)
finalJSON = gsub("\\","",paste0('{"matrix":', matrixJSON, ',"rowJSON":',  rowJSON,  ',"colJSON":',  colJSON,')'), fixed=TRUE)

print(finalJSON)
