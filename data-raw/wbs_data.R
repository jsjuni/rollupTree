## code to prepare `wbs_data` dataset goes here
library(igraph)

## Example adapted from https://www.workbreakdownstructure.com

wbs_table <- data.frame(
  id = c("top", "1", "2", "3", "1.1", "1.2", "2.1", "2.2", "3.1", "3.2"),
  pid = c(NA, "top", "top", "top", "1", "1", "2", "2", "3", "3"),
  name = c("Construction of a House", "Internal", "Foundation", "External",
           "Electrical", "Plumbing", "Excavate", "Steel Erection", "Masonry Work", "Building Finishes"),
  work = c(NA, NA, NA, NA, 11.80, 33.80, 18.20, 5.80, 16.20, 14.20),
  budget = c(NA, NA, NA, NA, 25000, 61000, 37000, 9000, 62000, 21500)
)

wbs_table_rollup <- wbs_table
wbs_table_rollup[wbs_table_rollup$id == "1", "work"] <- 45.6
wbs_table_rollup[wbs_table_rollup$id == "2", "work"] <- 24.0
wbs_table_rollup[wbs_table_rollup$id == "3", "work"] <- 30.4
wbs_table_rollup[wbs_table_rollup$id == "top", "work"] <- 100
wbs_table_rollup[wbs_table_rollup$id == "1", "budget"] <- 86000
wbs_table_rollup[wbs_table_rollup$id == "2", "budget"] <- 46000
wbs_table_rollup[wbs_table_rollup$id == "3", "budget"] <- 83500
wbs_table_rollup[wbs_table_rollup$id == "top", "budget"] <- 215500

wbs_tree <- igraph::graph_from_edgelist(
  as.matrix(wbs_table[!is.na(wbs_table$pid), c("id", "pid")]),
  directed = TRUE
)

usethis::use_data(wbs_table, overwrite = TRUE)
usethis::use_data(wbs_table_rollup, overwrite = TRUE)
usethis::use_data(wbs_tree, overwrite = TRUE)
