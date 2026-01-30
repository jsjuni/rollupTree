# Update a property in a data frame

`update_df_prop_by_key()` is a convenience wrapper around
[`update_prop()`](https://jsjuni.github.io/rollupTree/reference/update_prop.md)
for the common case in which the data set is a data frame.

## Usage

``` r
update_df_prop_by_key(df, key, target, sources, prop, ...)
```

## Arguments

- df:

  a data frame

- key:

  name of the column serving as key

- target:

  key of data set element to be updated

- sources:

  keys of data set elements to be combined

- prop:

  column name of the property

- ...:

  other arguments passed to
  [`update_prop()`](https://jsjuni.github.io/rollupTree/reference/update_prop.md)

## Value

The updated data frame

## Examples

``` r
update_df_prop_by_key(wbs_table, "id", "1", list("1.1", "1.2"), "work")
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
