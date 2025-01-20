fault_tree <-igraph::graph_from_edgelist(as.matrix(readr::read_tsv("data-raw/fault_tree.tsv", show_col_types = FALSE)[, c("child", "parent")]))

usethis::use_data(fault_tree, overwrite = TRUE)
