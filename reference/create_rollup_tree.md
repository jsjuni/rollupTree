# Create a tree for use with `rollup()`

`create_rollup_tree()` creates a tree suitable for use with
[`rollup()`](https://jsjuni.github.io/rollupTree/reference/rollup.md) by
applying helper functions to construct vertices and edges.

## Usage

``` r
create_rollup_tree(get_keys, get_parent_key_by_child_key)
```

## Arguments

- get_keys:

  A function() that returns a collection of names for vertices.

- get_parent_key_by_child_key:

  A function(key) that returns for each child key the key of its parent.

## Value

An `igraph` directed graph with vertices and edges as supplied

## Examples

``` r
get_keys <- function() wbs_table$id
get_parent_key_by_child_key <- function(key) wbs_table[which(wbs_table$id == key), "pid"]
create_rollup_tree(get_keys, get_parent_key_by_child_key)
#> IGRAPH fc1834e DN-- 10 9 -- 
#> + attr: name (v/c)
#> + edges from fc1834e (vertex names):
#> [1] 1  ->top 2  ->top 3  ->top 1.1->1   1.2->1   2.1->2   2.2->2   3.1->3  
#> [9] 3.2->3  
```
