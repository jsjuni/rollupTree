# Set property by key "id" in data frame

Set property by key "id" in data frame

## Usage

``` r
df_set_by_id(df, idval, prop, val)
```

## Arguments

- df:

  a data frame

- idval:

  id of the specified row

- prop:

  column name of the property value to get

- val:

  value to set

## Value

updated data frame

## Examples

``` r
df_set_by_id(wbs_table, "1", "work", 45.6)
#>     id  pid                    name work budget
#> 1  top <NA> Construction of a House   NA     NA
#> 2    1  top                Internal 45.6     NA
#> 3    2  top              Foundation   NA     NA
#> 4    3  top                External   NA     NA
#> 5  1.1    1              Electrical 11.8  25000
#> 6  1.2    1                Plumbing 33.8  61000
#> 7  2.1    2                Excavate 18.2  37000
#> 8  2.2    2          Steel Erection  5.8   9000
#> 9  3.1    3            Masonry Work 16.2  62000
#> 10 3.2    3       Building Finishes 14.2  21500
```
