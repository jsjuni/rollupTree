# Update a data set with recursively-defined properties

`update_prop` calls user-specified methods to get properties of a source
set of elements in a data set, combine those properties, and set the
properties of a target element to the combined value. If the source set
is empty, the data set is returned unmodified. The default combine
operation is addition.

The `override` argument can be used to selectively override the computed
value based on the target element. By default, it simply returns the
value computed by the combiner.

## Usage

``` r
update_prop(
  ds,
  target,
  sources,
  set,
  get,
  combine = function(l) Reduce("+", l),
  override = function(ds, target, v) v
)
```

## Arguments

- ds:

  data set to be updated

- target:

  key of data set element to be updated

- sources:

  keys of data set elements to be combined

- set:

  function to set properties for a target element called as set(ds, key,
  value)

- get:

  function to get properties for source elements called as get(ds, key)

- combine:

  function to combine properties called as combine(vl)

- override:

  function to selectively override combined results called as
  override(ds, key,)

## Value

updated data set

## Examples

``` r
update_prop(wbs_table, "1", list("1.1", "1.2"),
  function(d, k, v) {d[d$id == k, "work"] <- v; d},
  function(d, k) d[d$id == k, "work"]
 )
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
update_prop(wbs_table, "1", list("1.1", "1.2"),
  function(d, k, v) {d[d$id == k, c("work", "budget")] <- v; d},
  function(d, k) d[d$id == k, c("work", "budget")],
  function(l) Reduce("+", l)
)
#>     id  pid                    name work budget
#> 1  top <NA> Construction of a House   NA     NA
#> 2    1  top                Internal 45.6  86000
#> 3    2  top              Foundation   NA     NA
#> 4    3  top                External   NA     NA
#> 5  1.1    1              Electrical 11.8  25000
#> 6  1.2    1                Plumbing 33.8  61000
#> 7  2.1    2                Excavate 18.2  37000
#> 8  2.2    2          Steel Erection  5.8   9000
#> 9  3.1    3            Masonry Work 16.2  62000
#> 10 3.2    3       Building Finishes 14.2  21500
```
