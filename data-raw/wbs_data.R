## code to prepare `wbs_data` dataset goes here

## Example adapted from https://www.workbreakdownstructure.com

wbs_table <- data.frame(
  id = c("top", "1", "2", "3", "1.1", "1.2", "2.1", "2.2", "3.1", "3.2"),
  name = c("Construction of a House", "Internal", "Foundation", "External",
           "Electrical", "Plumbing", "Excavate", "Steel Erection", "Masonry Work", "Building Finishes"),
  work = c(NA, NA, NA, NA, 11.80, 33.80, 18.20, 5.80, 16.20, 14.20),
  budget = c(NA, NA, NA, NA, 25000, 61000, 37000, 9000, 62000, 21500)
)

wbs_tree <- igraph::graph(
  c(
    "1", "top", "2", "top", "3", "top",
    "1.1", "1", "1.2", "1", "2.1", "2", "2.2", "2", "3.1", "3", "3.2", "3"
  ), directed = TRUE
)

usethis::use_data(wbs_table, overwrite = TRUE)
usethis::use_data(wbs_tree, overwrite = TRUE)
