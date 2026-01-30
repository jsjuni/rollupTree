# Perform recursive computation

`rollup()` traverses a tree depth-first (post order) and calls a
user-specified update function at each vertex, passing the method a data
set, the unique key of that target vertex in the data set, and a list of
source keys. The update method typically gets some properties of the
source elements of the data set, combines them, sets some properties of
the target element of the data set to the combined value, and returns
the updated data set as input to the update of the next vertex. The
final operation updates the root vertex.

An
[`update_prop()`](https://jsjuni.github.io/rollupTree/reference/update_prop.md)
helper function is available to simplify building compliant update
methods.

Before beginning the traversal, `rollup()` calls a user-specified method
to validate that the tree is well-formed (see
[`default_validate_tree()`](https://jsjuni.github.io/rollupTree/reference/default_validate_tree.md)).
It also calls a user-specified method to ensure that the id sets of the
tree and data set are identical, and that data set elements
corresponding to leaf vertices in the tree satisfy some user-specified
predicate, e.g., [`is.numeric()`](https://rdrr.io/r/base/numeric.html).

## Usage

``` r
rollup(tree, ds, update, validate_ds, validate_tree = default_validate_tree)
```

## Arguments

- tree:

  `igraph` directed graph that is a valid single-rooted in-tree and
  whose vertex names are keys from the data set

- ds:

  data set to be updated; can be any object

- update:

  function called at each vertex as update(ds, parent_key, child_keys)

- validate_ds:

  data set validator function called as validate_ds(tree, ds)

- validate_tree:

  tree validator function called as validate_tree(tree)

## Value

updated input data set

## Details

The data set passed to `rollup()` can be any object for which an update
function can be written. A common and simple example is a data frame,
but lists work as well.

## Examples

``` r
rollup(wbs_tree, wbs_table,
  update = function(d, p, c) {
    if (length(c) > 0)
      d[d$id == p, c("work", "budget")] <-
        apply(d[is.element(d$id, c), c("work", "budget")], 2, sum)
      d
  },
  validate_ds = function(tree, ds) TRUE
)
#>     id  pid                    name  work budget
#> 1  top <NA> Construction of a House 100.0 215500
#> 2    1  top                Internal  45.6  86000
#> 3    2  top              Foundation  24.0  46000
#> 4    3  top                External  30.4  83500
#> 5  1.1    1              Electrical  11.8  25000
#> 6  1.2    1                Plumbing  33.8  61000
#> 7  2.1    2                Excavate  18.2  37000
#> 8  2.2    2          Steel Erection   5.8   9000
#> 9  3.1    3            Masonry Work  16.2  62000
#> 10 3.2    3       Building Finishes  14.2  21500
```
