# Get row by key "id" from data frame

`df_get_by_key` returns the value of specified property (column) in a
specified row of a data frame. The row is specified by a key column and
a value from that column.

## Usage

``` r
df_get_by_key(df, key, keyval, prop)
```

## Arguments

- df:

  a data frame

- key:

  name of the column used as key

- keyval:

  value of the key for the specified row

- prop:

  column name of the property value to get

## Value

The requested value

## Examples

``` r
df_get_by_key(wbs_table, "id", "1.1", "work")
#> [1] 11.8
```
