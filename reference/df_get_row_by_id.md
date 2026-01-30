# Title

Title

## Usage

``` r
df_get_row_by_id(df, idval)
```

## Arguments

- df:

  a data frame

- idval:

  id of the row to get

## Value

A named list of values from the requested row

## Examples

``` r
df_get_row_by_id(wbs_table, "1.1")
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
