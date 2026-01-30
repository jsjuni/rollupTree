# Get ids from a data frame

The default name for a key column in `rollup` is `id`. `df_get_ids` gets
all values from the `id` column in a data frame.

## Usage

``` r
df_get_ids(df)
```

## Arguments

- df:

  a data frame

## Value

all values of the `id` column

## Examples

``` r
df_get_ids(wbs_table)
#>  [1] "top" "1"   "2"   "3"   "1.1" "1.2" "2.1" "2.2" "3.1" "3.2"
```
