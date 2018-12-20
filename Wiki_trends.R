#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

for (package in c('XML', 'dplyr','reshape','lubridate','httr','jsonlite','curl','ggplot2','reshape2')) {
  if (!require(package, character.only=T, quietly=T)) {
    install.packages(package, repos="http://cran.us.r-project.org")
    library(package, character.only=T)
  }
}

print(paste("Wiki_trends_", args[1],"_", args[2],".txt",sep=""))

get_All_article_nb_edits_full_day=function(currentdate,pastdate){

  output_table=c()
  cmd=paste("https://en.wikipedia.org/w/api.php?action=query&list=allrevisions&arvprop=ids|timestamp|flags|comment|user|size|tags&arvdir=older&arvlimit=max&format=json&arvend=",pastdate,"&arvstart=",currentdate,sep="")
  resp=GET(cmd)
  parsed <- jsonlite::fromJSON(httr::content(resp, "text"), simplifyVector = T)
  
  get_nb_rev=function(rev){return(
    dim(dplyr::filter(rev,tags %in% c("mw-undo","mv-rollback")))[1])}
  
  output_table=data.frame(art=parsed$query$allrevisions$title,nb_edits=sapply(parsed$query$allrevisions$revisions,get_nb_rev))
  
  while(length(parsed$continue$arvcontinue)==1){
    output_table_load=c()
    print(parsed$continue$arvcontinue)
    rvc=parsed$continue$arvcontinue
    cmd=paste("https://en.wikipedia.org/w/api.php?action=query&list=allrevisions&arvprop=ids|timestamp|flags|comment|user|size|tags&arvdir=older&arvlimit=max&format=json&arvend=",pastdate,"&arvstart=",currentdate,"&arvcontinue=",rvc,sep="")
    resp=GET(cmd)
    parsed <- jsonlite::fromJSON(httr::content(resp, "text"), simplifyVector = T)
    output_table_load=cbind(art=parsed$query$allrevisions$title,nb_edits=sapply(parsed$query$allrevisions$revisions,get_nb_rev))
    
    output_table=try(rbind(output_table,output_table_load),silent=T)
  }
  output_table$nb_edits=as.numeric(as.character(output_table$nb_edits))
  output_table=output_table%>% dplyr::group_by(art)%>% dplyr::summarise(sum_nb_edits=sum(nb_edits))%>%dplyr::arrange(desc(sum_nb_edits))%>%dplyr::filter(sum_nb_edits>0)%>%data.frame()
  output_table=cbind(output_table,date=rep(substr(args[2], 1, 8),dim(output_table)[1]))
  return(output_table)
}

write.table(get_All_article_nb_edits_full_day(args[1],args[2]),paste("Wiki_trends_", args[1],"_", args[2],".txt",sep=""),quote = F,row.names = F,col.names = F,sep = "\t")


# make confing file 
# for(d in 1:365){
#   current_date=today()-ddays(d)
#   past_date=today()-ddays(d+1)
#   dt=paste(gsub("-","",current_date),"000000"," ",gsub("-","",past_date),"000000",sep="")
#   write(dt, file="config_dates.txt", append=T)
# }
###########
# Call Example:
# Rscript --vanilla Wiki_trends.R 20181212010000 20181212000000

