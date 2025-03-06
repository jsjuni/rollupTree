## code to prepare `test_dag` dataset goes here
library(igraph)

test_dag <- wbs_tree + edge(9, 2)
usethis::use_data(test_dag, overwrite = TRUE)
