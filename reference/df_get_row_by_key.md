# Get row by key from data frame

Get row by key from data frame

## Usage

``` r
df_get_row_by_key(df, key, keyval)
```

## Arguments

- df:

  a data frame

- key:

  name of the column used as key

- keyval:

  value of the key for the specified row

## Value

A named list of values from the requested row

## Examples

``` r
df_get_row_by_key(wbs_table, "id", "1.1")
#> $id
#> [1] "1.1"
#> 
#> $pid
#> [1] "1"
#> 
#> $name
#> [1] "Electrical"
#> 
#> $work
#> [1] 11.8
#> 
#> $budget
#> [1] 25000
#> 
```
