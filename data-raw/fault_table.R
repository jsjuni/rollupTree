fault_table <- as.data.frame(readr::read_tsv("data-raw/fault_table.tsv", show_col_types = FALSE))

usethis::use_data(fault_table, overwrite = TRUE)
