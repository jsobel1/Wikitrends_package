library(dplyr)
library(reshape)
library(lubridate) 
library(ggplot2) 
library(scales) 
library("reshape2")

wiki_reverts_trend=read.delim("2018_reverts_per_day.txt",sep="\t",header=F,quote="")

colnames(wiki_reverts_trend)=c("art","nb_reverts","date")
top_contr_art=wiki_reverts_trend%>% 
  dplyr::group_by(art)%>% 
  dplyr::summarise(sum_nb_reverts=sum(nb_reverts))%>%
  dplyr::arrange(desc(sum_nb_reverts))%>%
  dplyr::filter(sum_nb_reverts>0)%>%data.frame()%>%head(1000)

sum(wiki_reverts_trend$nb_reverts,na.rm = T)


write.table(top_contr_art,"top_1000_controversial_articles.csv",quote = F,row.names = F,col.names = F,sep = "\t")

get_temporal_profile=function(name_article){
donald_time=wiki_reverts_trend%>% 
  dplyr::filter(art==name_article)%>%data.frame()

donald_time$tsc=as.Date(ymd(donald_time$date))

donald_time$cut=cut( donald_time$tsc, breaks="1 week")

donald_time_month=donald_time%>%dplyr::group_by(cut)%>%summarise(freq=sum(nb_reverts))%>%data.frame()

P=ggplot(donald_time_month, aes(x =as.Date(cut),y=freq)) +scale_x_date(date_breaks = "1 month",date_labels = "%b" )+ 
  geom_line(stat="identity",size=1.2,color="red")+labs(x="Month (2018)",y="Reverts per week")+
  ggtitle(paste(name_article," weekly profile"))+theme_classic()+theme(axis.text=element_text(size=12),axis.title=element_text(size=14))
print(P)

}

pdf("temporal_profiles_samples.pdf",height=4,width=8)
get_temporal_profile("Avengers: Infinity War")
get_temporal_profile("Deaths in 2018")
get_temporal_profile("Ralph Breaks the Internet")
get_temporal_profile("Solo: A Star Wars Story")
dev.off()

pdf("temporal_profiles_top_100.pdf",height=4,width=8)
top100_art=as.character(top_contr_art$art[1:100])
for(i in 1:100){
get_temporal_profile(top100_art[i])
}
dev.off()


