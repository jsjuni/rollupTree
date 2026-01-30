# Validate a data frame with key "id" for `rollup()`

`validate_df_by_id()` is a convenience wrapper for
[`validate_ds()`](https://jsjuni.github.io/rollupTree/reference/validate_ds.md)
for the common case in which the data set is a data frame with key
column named "id".

## Usage

``` r
validate_df_by_id(tree, df, prop, ...)
```

## Arguments

- tree:

  tree to validate against

- df:

  data frame

- prop:

  property whose value is checked (leaf elements only)

- ...:

  other parameters passed to validate_ds()

## Value

TRUE if validation succeeds, halts otherwise

## Examples

``` r
validate_df_by_id(wbs_tree, wbs_table, "work")
#> [1] TRUE
```
