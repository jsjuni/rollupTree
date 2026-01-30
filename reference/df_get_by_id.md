# Get property by key "id" from data frame

`df_get_by_id` returns the value of specified property (column) in a
specified row of a data frame. The row is specified by a value for the
`id` column.

## Usage

``` r
df_get_by_id(df, idval, prop)
```

## Arguments

- df:

  a data frame

- idval:

  id of the row to get

- prop:

  name of the column to get

## Value

The requested value

## Examples

``` r
df_get_by_id(wbs_table, "1.1", "work")
#> [1] 11.8
```
