library(tidyr)
library(dplyr)
library(ggplot2)
library(scales)

K<-read.csv('ITS_L.csv')
K<-subset(K, Ecology != 'delete') 
fontes <- gsub(";__", "", K[,1])
fontes <- sub("k__Fungi;p__", "", fontes)
K$index<- fontes 
K_pr<-K
K_pr$L4<-K$L4/sum(K$L4)*100
K_pr$L11<-K$L11/sum(K$L11)*100
K_pr$L12<-K$L12/sum(K$L12)*100

K_pr<-K_pr[,1:4]
names(K_pr)[1] ="Taxa"

# Transferm the table 
d3 <- K_pr %>%
  gather("Samples", "Relative abundance, %",-Taxa) %>%
  group_by(Taxa) %>% 
  mutate(
    mean = mean(`Relative abundance, %`)
  ) %>% 
  ungroup() %>% 
  arrange(desc(mean)) %>% 
  mutate(
    Taxa = factor(Taxa, levels = unique(Taxa))
  )


# Graphics

pallete<-c("#a60d2e","#560076","#00ca1e","#7597ff",
           "#ae3d52","#002c72","#2d625d","#950048",
           "#3f3f5d","#f83700","#00a4c3","#b2310a",
           "#b6cb53","#ff84ae","#02b687","#dec2ff",
           "#3a5b00","#c772cb","#001c23","#abffe2",
           "#7b4d00","#004f2b")

show_col(pallete)

positions <- c("L4", "L11", "L12")

ggp <-
  ggplot(d3, aes(Samples, `Relative abundance, %`,  fill = Taxa)) +
  geom_bar(stat="identity") +
  scale_x_discrete(limits = positions) 

ggp +
  geom_text(aes(label = ifelse(`Relative abundance, %` <= 1, "", scales::percent(`Relative abundance, %`/100, .1))),
            position=position_stack(vjust = 0.5), angle = 0, col="white", fontface=1) +
  scale_fill_manual(values = alpha(pallete, 0.9)) +
  theme_classic(base_size=12) 



