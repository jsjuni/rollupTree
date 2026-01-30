# Set row by key in data frame

Set row by key in data frame

## Usage

``` r
df_set_row_by_key(df, key, keyval, list)
```

## Arguments

- df:

  a data frame

- key:

  name of the column used as key

- keyval:

  value of the key for the specified row

- list:

  named list of values to set

## Value

The updated data frame

## Examples

``` r
l <- list(id = "1.1", pid = "1", name = "Thermal", work = 11.9, budget = 25001)
df_set_row_by_key(wbs_table, "id", "1.1", l)
#>     id  pid                    name work budget
#> 1  top <NA> Construction of a House   NA     NA
#> 2    1  top                Internal   NA     NA
#> 3    2  top              Foundation   NA     NA
#> 4    3  top                External   NA     NA
#> 5  1.1    1                 Thermal 11.9  25001
#> 6  1.2    1                Plumbing 33.8  61000
#> 7  2.1    2                Excavate 18.2  37000
#> 8  2.2    2          Steel Erection  5.8   9000
#> 9  3.1    3            Masonry Work 16.2  62000
#> 10 3.2    3       Building Finishes 14.2  21500
```
