test_that("rollup works", {
  expected <- wbs_table |>
    df_set_by_id("top", "work", 100.0) |>
    df_set_by_id("1", "work", 45.6) |>
    df_set_by_id("2", "work", 24.0) |>
    df_set_by_id("3", "work", 30.4) |>
    df_set_by_id("top", "budget", 215500) |>
    df_set_by_id("1", "budget", 86000) |>
    df_set_by_id("2", "budget", 46000) |>
    df_set_by_id("3", "budget", 83500)
  result <- rollup(
    wbs_tree,
    wbs_table,
    update = function(d, p, c) {
      if (length(c) > 0)
        d[d$id == p, c("work", "budget")] <-
          apply(d[is.element(d$id, c), c("work", "budget")], 2, sum)
      d
    },
    validate_ds = function(tree, ds)
      TRUE
  )

  expect_equal(result, expected)
})

test_that("default_validate_tree() finds the root of a valid tree", {
  expect_equal(names(default_validate_tree(wbs_tree)), "top")
})

test_that("default_validate_tree() rejects a cyclic graph (1)", {
  bad_graph <- wbs_tree |> add_edges(c("top", "1.2"))
  expect_error(default_validate_tree(bad_graph), "graph is cyclic")
})

test_that("default_validate_tree() rejects a cyclic graph (2)", {
  bad_graph <- wbs_tree |> add_edges(c("1", "1.2"))
  expect_error(default_validate_tree(bad_graph), "graph is cyclic")
})

test_that("default_validate_tree() rejects a graph with loops", {
  bad_graph <- wbs_tree |> add_edges(c("top", "top"))
  expect_error(default_validate_tree(bad_graph), "graph is cycl")
})

test_that("default_validate_tree() rejects a graph with multiple edges", {
  bad_graph <- wbs_tree |> add_edges(c("1", "top"))
  expect_error(default_validate_tree(bad_graph), "graph contains multiple edges")
})
