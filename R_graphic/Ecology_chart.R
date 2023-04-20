library(tidyr)
library(dplyr)
library(ggplot2)
library(scales)

L<-read.csv('ITS_L.csv')
L<-L[,2:ncol(L)]
L<-subset(L, Ecology != 'delete') 

L_pr<-L
L_pr$L11<-L$L11/sum(L$L11)*100
L_pr$L12<-L$L12/sum(L$L12)*100
L_pr$L4<-L$L4/sum(L$L4)*100


# Transferm the table 
d1 <- L_pr %>%
  gather("Samples", "Relative abundance, %",-Ecology) %>%
  group_by(Ecology) 

# Create a summary table 
d2<-aggregate(d1$`Relative abundance, %`, by=list(Ecology=d1$Ecology, Samples=d1$Samples ), FUN=sum)

# Graphics
positions <- c("L4", "L11", "L12")

ggp <-
  ggplot(d2, aes(x, Samples, fill = Ecology)) +
  geom_bar(stat="identity") +
  scale_y_discrete(limits = positions) + 
  scale_x_continuous("Relative abundance, %") 


mypal<-c("#65b672",  "#cd5959", "#9d72c1","#7fa3e6")
show_col(mypal)

ggp +
  geom_text(aes(label = ifelse(x == 0, "", scales::percent(x/100, .1))),
            position=position_stack(vjust = 0.5), angle = 0, col="white", fontface=1) +
  scale_fill_manual(values = alpha(mypal, 0.9)) +
  theme_classic(base_size=12) 



