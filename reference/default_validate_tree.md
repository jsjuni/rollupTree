# Validate a tree for use with `rollup()`

`default_validate_tree()` ensures that a tree is acyclic, loop-free,
single-edged, connected, directed, and single-rooted with edge direction
from child to parent.

## Usage

``` r
default_validate_tree(tree)
```

## Arguments

- tree:

  `igraph` directed graph that is a valid single-rooted in-tree and
  whose vertex names are keys from the data set

## Value

single root vertex identifier if tree is valid; stops otherwise

## Examples

``` r
default_validate_tree(wbs_tree)
#> top 
#>   2 
```
