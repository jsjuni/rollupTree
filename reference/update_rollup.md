# Update a rollup from a single leaf vertex

`update_rollup()` performs a minimal update of a data set assuming a
single leaf element property has changed. It performs updates along the
path from that vertex to the root. There should be no difference in the
output from calling
[`rollup()`](https://jsjuni.github.io/rollupTree/reference/rollup.md)
again. `update_rollup()` is perhaps more efficient and useful in an
interactive context.

## Usage

``` r
update_rollup(tree, ds, vertex, update)
```

## Arguments

- tree:

  `igraph` directed graph that is a valid single-rooted in-tree and
  whose vertex names are keys from the data set

- ds:

  data set to be updated; can be any object

- vertex:

  The start vertex

- update:

  function called at each vertex as update(ds, parent_key, child_keys)

## Value

updated input data set

## Examples

``` r
update_rollup(wbs_tree, wbs_table, igraph::V(wbs_tree)["3.2"],
  update = function(d, p, c) {
    if (length(c) > 0)
      d[d$id == p, c("work", "budget")] <-
        apply(d[is.element(d$id, c), c("work", "budget")], 2, sum)
      d
  }
)
#>     id  pid                    name work budget
#> 1  top <NA> Construction of a House   NA     NA
#> 2    1  top                Internal   NA     NA
#> 3    2  top              Foundation   NA     NA
#> 4    3  top                External 30.4  83500
#> 5  1.1    1              Electrical 11.8  25000
#> 6  1.2    1                Plumbing 33.8  61000
#> 7  2.1    2                Excavate 18.2  37000
#> 8  2.2    2          Steel Erection  5.8   9000
#> 9  3.1    3            Masonry Work 16.2  62000
#> 10 3.2    3       Building Finishes 14.2  21500
```
