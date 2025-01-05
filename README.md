
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rollup

<!-- badges: start -->
<!-- badges: end -->

Rollup is a general framework for solving problems in which some
property a parent element is some combination of corresponding
properties of its child elements. The mass of an assembly, for example,
can be construed as the sum of the masses of its subassemblies, and the
mass of each subassembly is the sum of masses of its parts.

Rollup can solve problems specified by arbitrarily-shaped (but
well-formed) trees, arbitrarily-defined properties and
property-combining operations. Defaults are provided to simplify common
cases (atomic numerical properties combined by summing), but functional
programming techniques allow the caller to pass arbitrary *get*, *set*,
and *combine* methods at runtime.

## Installation

You can install the development version of rollup from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("jsjuni/rollup")
```

## Example

Consider this example Work Breakdown Structure:

[![Example Work Breakdown Structure. Source:
www.workbreakdownstructure.com](man/figures/README-wbs.jpg)](https://www.workbreakdownstructure.com)

The computations in the example are worked out already; we show here how
to reproduce them.

A Work Breakdown Structure is a tree, that is, a graph that is connected
and acyclic. It is, in addition, directed, that is, the edges have
direction. We arbitrarily chose the edge direction to go from child to
parent. Finally, it is single-rooted: every vertex but one has a single
parent vertex; the root vertex has no parent.

The leaf elements (vertices) of the tree require asserted values for the
properties (work, budget) of interest. Property values for non-leaf
elements are computed by the rollup operation.

We begin by capturing the structure of the tree and asserted values in a
data frame we call `wbs_table`. Values to be computed are initially
unknown. Each element is uniquely identified by an `id` column[^1]. We
also indicate parent id in the `pid` column but this information is not
used directly by `rollup()`.

``` r
library(rollup)
knitr::kable(wbs_table)
```

| id  | pid | name                    | work | budget |
|:----|:----|:------------------------|-----:|-------:|
| top | NA  | Construction of a House |   NA |     NA |
| 1   | top | Internal                |   NA |     NA |
| 2   | top | Foundation              |   NA |     NA |
| 3   | top | External                |   NA |     NA |
| 1.1 | 1   | Electrical              | 11.8 |  25000 |
| 1.2 | 1   | Plumbing                | 33.8 |  61000 |
| 2.1 | 2   | Excavate                | 18.2 |  37000 |
| 2.2 | 2   | Steel Erection          |  5.8 |   9000 |
| 3.1 | 3   | Masonry Work            | 16.2 |  62000 |
| 3.2 | 3   | Building Finishes       | 14.2 |  21500 |

A key feature of recursively-defined problems like this is that the
computations must be ordered in such a way that the computations for a
given element must occur after properties for it children are known
(either asserted or computed). Traversing a tree in this manner is a
well-known algorithm in graph theory known as *depth-first (postorder)
search*. For that reason, we construct a graph object in R, from which
we can conveniently (1) check that the graph is in fact a well-formed
tree, and (2) efficiently execute a depth-first search to order the
computations. (Note that, although the problems solved by rollup are
recursive-defined, the implementation is not recursive.)

It is a simple matter to construct a graph from the information in our
data frame:

``` r
library(igraph)
#> 
#> Attaching package: 'igraph'
#> The following objects are masked from 'package:stats':
#> 
#>     decompose, spectrum
#> The following object is masked from 'package:base':
#> 
#>     union
wbs_tree <- igraph::graph_from_edgelist(
  as.matrix(wbs_table[which(!is.na(wbs_table$pid)), c("id", "pid")]),
  directed = TRUE
)
E(wbs_tree)
#> + 9/9 edges from ad6d430 (vertex names):
#> [1] 1  ->top 2  ->top 3  ->top 1.1->1   1.2->1   2.1->2   2.2->2   3.1->3  
#> [9] 3.2->3
```

With `wbs_table`, `wbs_tree`, and two helper methods, we can roll up the
work values:

``` r
knitr::kable(rollup(
  tree=wbs_tree,
  ds=wbs_table,
  update=function(d, t, s) update_df_prop_by_id(df=d, target=t, sources=s, prop="work"),
  validate_ds=function(t, d) validate_df_by_id(tree=t, df=d, prop="work")
))
```

| id  | pid | name                    |  work | budget |
|:----|:----|:------------------------|------:|-------:|
| top | NA  | Construction of a House | 100.0 |     NA |
| 1   | top | Internal                |  45.6 |     NA |
| 2   | top | Foundation              |  24.0 |     NA |
| 3   | top | External                |  30.4 |     NA |
| 1.1 | 1   | Electrical              |  11.8 |  25000 |
| 1.2 | 1   | Plumbing                |  33.8 |  61000 |
| 2.1 | 2   | Excavate                |  18.2 |  37000 |
| 2.2 | 2   | Steel Erection          |   5.8 |   9000 |
| 3.1 | 3   | Masonry Work            |  16.2 |  62000 |
| 3.2 | 3   | Building Finishes       |  14.2 |  21500 |

``` r
knitr::kable(rollup(
  tree=wbs_tree,
  ds=wbs_table,
  update=function(d, t, s) update_df_prop_by_id(df=d, target=t, sources=s, prop="work"),
  validate_ds=function(t, d) validate_df_by_id(tree=t, df=d, prop="work")
) |> rollup(
  tree=wbs_tree,
  ds=_,
  update=function(d, t, s) update_df_prop_by_id(df=d, target=t, sources=s, prop="budget"),
  validate_ds=function(t, d) validate_df_by_id(tree=t, df=d, prop="budget")
))
```

| id  | pid | name                    |  work | budget |
|:----|:----|:------------------------|------:|-------:|
| top | NA  | Construction of a House | 100.0 | 215500 |
| 1   | top | Internal                |  45.6 |  86000 |
| 2   | top | Foundation              |  24.0 |  46000 |
| 3   | top | External                |  30.4 |  83500 |
| 1.1 | 1   | Electrical              |  11.8 |  25000 |
| 1.2 | 1   | Plumbing                |  33.8 |  61000 |
| 2.1 | 2   | Excavate                |  18.2 |  37000 |
| 2.2 | 2   | Steel Erection          |   5.8 |   9000 |
| 3.1 | 3   | Masonry Work            |  16.2 |  62000 |
| 3.2 | 3   | Building Finishes       |  14.2 |  21500 |

``` r
knitr::kable(rollup(
  tree=wbs_tree,
  ds=wbs_table,
  update=function(d, t, s) {
    update_df_prop_by_id(df=d, target=t, sources=s, prop="work") |>
      update_df_prop_by_id(target=t, sources=s, prop="budget")
  },
  validate_ds=function(t, d) {
    validate_df_by_id(tree=t, df=d, prop="work") &&
      validate_df_by_id(tree=t, df=d, prop="budget")
  }
))
```

| id  | pid | name                    |  work | budget |
|:----|:----|:------------------------|------:|-------:|
| top | NA  | Construction of a House | 100.0 | 215500 |
| 1   | top | Internal                |  45.6 |  86000 |
| 2   | top | Foundation              |  24.0 |  46000 |
| 3   | top | External                |  30.4 |  83500 |
| 1.1 | 1   | Electrical              |  11.8 |  25000 |
| 1.2 | 1   | Plumbing                |  33.8 |  61000 |
| 2.1 | 2   | Excavate                |  18.2 |  37000 |
| 2.2 | 2   | Steel Erection          |   5.8 |   9000 |
| 3.1 | 3   | Masonry Work            |  16.2 |  62000 |
| 3.2 | 3   | Building Finishes       |  14.2 |  21500 |

``` r
my_get <- function(d, i) c(
  w=df_get_by_id(df=d, id=i, prop="work"),
  b=df_get_by_id(df=d, id=i, prop="budget")
)
my_set <- function(d, i, v) {
  df_set_by_id(df=d, id=i, prop="work", value=v["w"]) |>
    df_set_by_id(id=i, prop="budget", value=v["b"])
}
my_check <- function(v) is.numeric(v) && !is.na(v)
knitr::kable(rollup(
  tree=wbs_tree,
  ds=wbs_table,
  update=function(d, t, s) {
    update_prop(ds=d, target=t, sources=s, set=my_set, get=my_get)
  },
  validate_ds=function(t, d) {
   validate_ds(tree=t, ds=d,
               get_keys=function(d) df_get_ids(df=d),
               get_prop=my_get,
               op=function(v) my_check(v["w"]) && my_check(v["b"]))
  }
))
```

| id  | pid | name                    |  work | budget |
|:----|:----|:------------------------|------:|-------:|
| top | NA  | Construction of a House | 100.0 | 215500 |
| 1   | top | Internal                |  45.6 |  86000 |
| 2   | top | Foundation              |  24.0 |  46000 |
| 3   | top | External                |  30.4 |  83500 |
| 1.1 | 1   | Electrical              |  11.8 |  25000 |
| 1.2 | 1   | Plumbing                |  33.8 |  61000 |
| 2.1 | 2   | Excavate                |  18.2 |  37000 |
| 2.2 | 2   | Steel Erection          |   5.8 |   9000 |
| 3.1 | 3   | Masonry Work            |  16.2 |  62000 |
| 3.2 | 3   | Building Finishes       |  14.2 |  21500 |

[^1]: `id` is the default but any valid column name can be used. Values
    should be character data.
=======
Mass rollup for a Bill of Materials is an example of a class of computations in which elements are arranged in a tree structure and some property of each element is a computed function of the corresponding values of its child elements. Leaf elements, i.e., those with no children, have values assigned. In many cases, the combining function is simply the arithmetic sum; in other cases (e.g., higher-order mass properties), the combiner may involve other information such as the geometric relationship between parent and child, or statistical relations such as root-sum-of-squares (RSS). This R package implements a general framework for such problems. It is adapted to specific recursive analyses by functional programming techniques; the caller passes _get()_, _set()_, _combine()_, and (optional) _override()_ methods at runtime to specify the desired operations.
