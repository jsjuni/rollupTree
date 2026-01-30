# Validate a data frame For `rollup()`

`validate_df_by_key()` is a convenience wrapper for
[`validate_ds()`](https://jsjuni.github.io/rollupTree/reference/validate_ds.md)
for the common case in which the data set is a dataframe.

## Usage

``` r
validate_df_by_key(tree, df, key, prop, ...)
```

## Arguments

- tree:

  tree to validate against

- df:

  data frame

- key:

  name of the column serving as key

- prop:

  property whose value is checked (leaf elements only)

- ...:

  other parameters passed to validate_ds()

## Value

TRUE if validation succeeds, halts otherwise

## Examples

``` r
validate_df_by_key(wbs_tree, wbs_table, "id", "work")
#> [1] TRUE
```
