# Validates a data set for use with `rollup()`

`validate_ds()` ensures that a data set contains the same identifiers as
a specified tree and that elements of the data set corresponding to leaf
vertices in the tree satisfy a user-specified predicate.

## Usage

``` r
validate_ds(
  tree,
  ds,
  get_keys,
  get_prop,
  op = function(x) is.numeric(x) & !is.na(x)
)
```

## Arguments

- tree:

  `igraph` directed graph that is a valid single-rooted in-tree and
  whose vertex names are keys from the data set

- ds:

  data set to be updated; can be any object

- get_keys:

  function to get keys of the data set called as `get_keys(ds)`

- get_prop:

  function to get the property value to validate for leaf element with
  id `l`, called as `get_prop(ds, l)`

- op:

  logical function to test return value of `get_prop()` (default
  [`is.numeric()`](https://rdrr.io/r/base/numeric.html)); returns `TRUE`
  if OK

## Value

TRUE if validation succeeds, halts otherwise

## Examples

``` r
validate_ds(wbs_tree, wbs_table, function(d) d$id, function(d, l) d[d$id == l, "work"])
#> [1] TRUE
```
