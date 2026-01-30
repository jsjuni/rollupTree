# Validate a directed acyclic graph for use with rollup

Validate a directed acyclic graph for use with rollup

## Usage

``` r
default_validate_dag(dag)
```

## Arguments

- dag:

  An igraph directed acyclic graph

## Value

TRUE if valid, stops otherwise

## Examples

``` r
default_validate_dag(test_dag)
#> [1] TRUE
```
