# Get keys from a data frame

`df_get_keys` gets all values from a designated column in a data frame.

## Usage

``` r
df_get_keys(df, key)
```

## Arguments

- df:

  a data frame

- key:

  name of the column used as key

## Value

All values of the key column

## Examples

``` r
df_get_keys(wbs_table, "id")
#>  [1] "top" "1"   "2"   "3"   "1.1" "1.2" "2.1" "2.2" "3.1" "3.2"
```
