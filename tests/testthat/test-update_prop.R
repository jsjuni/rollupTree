test_that("update_prop() works", {
  expected1 <- wbs_table
  expected1[expected1$id == "1", "work"] <- 45.6
  result1 <- update_prop(wbs_table, "1", list("1.1", "1.2"), function(d, k, v) {
    d[d$id == k, "work"] <- v
    d
  }, function(d, k)
    d[d$id == k, "work"])
  expect_equal(result1, expected1)

  expected2 <- expected1
  expected2[expected2$id == "1", "budget"] <- 86000
  result2 <- update_prop(wbs_table, "1", list("1.1", "1.2"), function(d, k, v) {
    d[d$id == k, c("work", "budget")] <- v
    d
  }, function(d, k)
    d[d$id == k, c("work", "budget")], function(l)
      Reduce("+", l))
  expect_equal(result2, expected2)
})

test_that("update_prop() on leaf target has no effect", {
  result <- update_prop(wbs_table, "1.1", list(), function(d, k, v) {
    d[d$id == k, c("work", "budget")] <- v
    d
  }, function(d, k)
    d[d$id == k, c("work", "budget")], function(l)
      Reduce("+", l))
  expect_equal(result, wbs_table)
})

test_that("df_get_keys() and df_get_ids() work", {
  expected <- c("top", "1", "2", "3", "1.1", "1.2", "2.1", "2.2", "3.1", "3.2")
  expect_equal(df_get_keys(wbs_table, "id"), expected)
  expect_equal(df_get_ids(wbs_table), expected)
})

test_that("df_get_by_key() works", {
  expect_equal(df_get_by_key(wbs_table, "id", "1.1", "work"), 11.8)
  expect_equal(df_get_by_key(wbs_table, "id", "1.1", "budget"), 25000)
})

test_that("df_get_by_id() works", {
  expect_equal(df_get_by_id(wbs_table, "1.1", "work"), 11.8)
  expect_equal(df_get_by_id(wbs_table, "1.1", "budget"), 25000)
})

test_that("df_set_by_key() works", {
  result <- df_set_by_key(wbs_table, "id", "1.1", "budget", 26000)
  expect_equal(result[result$id == "1.1", "budget"], 26000)
  expect_equal(result[result$id == "1.2", "budget"], 61000) # unchanged
  expect_equal(result[result$id == "1.1", "work"], 11.8) # unchanged
})

test_that("df_set_by_id() works", {
  result <- df_set_by_id(wbs_table, "1.1", "budget", 26000)
  expect_equal(result[result$id == "1.1", "budget"], 26000)
  expect_equal(result[result$id == "1.2", "budget"], 61000) # unchanged
  expect_equal(result[result$id == "1.1", "work"], 11.8) # unchanged
})

test_that("update_df_prop_by_key()and update_df_prop_by_id() work", {
  expected <- wbs_table
  expected[expected$id == "1", "work"] <- 45.6
  result1 <- update_df_prop_by_key(wbs_table, "id", "1", list("1.1", "1.2"), "work")
  result2 <- update_df_prop_by_id(wbs_table, "1", list("1.1", "1.2"), "work")
  expect_equal(result1, expected)
  expect_equal(result2, expected)
})

test_that("validate_df_by_key() works", {
  expect_true(validate_df_by_key(wbs_tree, wbs_table, "id", "work"))
})

test_that("validate_df_by_id() works", {
  expect_true(validate_df_by_id(wbs_tree, wbs_table, "work"))
})
