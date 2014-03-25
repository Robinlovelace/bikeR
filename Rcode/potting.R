# Nice plotting theme
qplot(ac$Road_Tf) + xlab("Type of road") + ylab("Count") + 
  theme(axis.text.x = element_text(angle=20, color = "black"),
        panel.background = element_rect(fill = "white"),
        panel.grid.major.y = element_line(color = "grey", linetype=3)) 
colors()

## give that theme a name!
bikeR_theme_1 <-  theme(axis.text.x = element_text(angle=20, color = "black"),
        panel.background = element_rect(fill = "white"),
        panel.grid.major.y = element_line(color = "grey", linetype=3))
