library(ggridges)
library(ggplot2)
library(viridis)

G_L <- paste(dir, "Group_wr_pa.csv", sep = "/") %>% read.csv()

G_L$Age <- as.factor(G_L$Age)
G_L$G_1 <- as.numeric(G_L$G_1)

# Plot
graph <- ggplot(G_L, aes(x = G_1, y = Age, fill = after_stat(x))) +
  geom_density_ridges_gradient(scale = 3, rel_min_height = 0.01) +
  scale_fill_viridis(option = "D") +
  labs(title = 'G1 in each age group') +
  theme_ipsum() +
  theme(
    legend.position="none",
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 6)
  )
print(graph)
ggsave("G1_age_group.pdf",graph, path=paste(dir, "figure", sep = "/"), 
       width = 180, height = 360, units = "mm")
