library("NbClust")
library(proxy)


Indices <- c("kl", "ch", "hartigan", "ccc", "scott", "marriot", "trcovw", "tracew", "friedman", "rubin", "cindex",
             "db", "silhouette", "duda", "pseudot2", "beale", "ratkowsky", "ball", "ptbiserial", "gap", "frey", 
             "mcclain", "gamma", "gplus", "tau", "dunn", "hubert", "sdindex", "dindex", "sdbw")

Outdir <- './GroupMeanFC_dbch/Cluster_cos'
data <- read.csv('./GroupMeanFC_dbch/PA.csv',header = FALSE)


# compute distance between gradients
cosine_similarity <- as.matrix(simil(data, method = "cosine"))
cosine_dissimilarity <- 1 - cosine_similarity
diag(cosine_dissimilarity) <- 0
mds_data <- cmdscale(cosine_dissimilarity, k = 2)

# determine the best clustering scheme 
for (Index in Indices){
  
  res <- NbClust(data = mds_data, min.nc = 2, max.nc = 10, method = "kmeans",
                 index = Index)
  res$All.index
  res$Best.nc
  res$All.CriticalValues
  res$Best.partition
  
  save(res, file = paste0(Outdir, "/res_", Index ,".RData"))
  write.csv(res$Best.partition,paste0(Outdir, "/best.partition_kmeans_", Index ,".csv"))
  write.csv(res$All.index,paste0(Outdir, "/all_index_", Index ,".csv"))
  write.csv(res$Best.nc,paste0(Outdir, "/Best.nc_", Index ,".csv"))
  
}
