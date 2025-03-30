
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rollupTree

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/rollupTree)](https://CRAN.R-project.org/package=rollupTree)
[![R-CMD-check](https://github.com/jsjuni/rollupTree/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jsjuni/rollupTree/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/jsjuni/rollupTree/graph/badge.svg)](https://app.codecov.io/gh/jsjuni/rollupTree)
<!-- badges: end -->

rollupTree implements a general function for computations in which some
property of a parent element is a combination of corresponding
properties of its child elements. The mass of an assembly, for example,
is the sum of the masses of its subassemblies, and the mass of each
subassembly is the sum of masses of its parts, etc.

rollupTree can perform computations specified by arbitrarily-shaped (but
well-formed) trees, arbitrarily-defined properties and
property-combining operations. Defaults are provided to simplify common
cases (atomic numerical properties combined by summing), but functional
programming techniques allow the caller to pass arbitrary update methods
as required.

Despite its name, rollupTree can operate on directed acyclic graphs that
are not trees if instructed to apply less stringent validation rules to
its input.

## Installation

``` r
install.packages("rollupTree")
```

You can install the development version of rollupTree from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("jsjuni/rollupTree")
```

## Example

Suppose we have this data frame representing a work breakdown structure:

``` r
library(rollupTree)
wbs_table
#>     id  pid                    name budget
#> 1  top <NA> Construction of a House     NA
#> 2    1  top                Internal     NA
#> 3    2  top              Foundation     NA
#> 4    3  top                External     NA
#> 5  1.1    1              Electrical  25000
#> 6  1.2    1                Plumbing  61000
#> 7  2.1    2                Excavate  37000
#> 8  2.2    2          Steel Erection   9000
#> 9  3.1    3            Masonry Work  62000
#> 10 3.2    3       Building Finishes  21500
```

and this tree with edges representing child-parent relations in the
breakdown:

``` r
igraph::E(wbs_tree)
#> + 9/9 edges from dd17ef5 (vertex names):
#> [1] 1  ->top 2  ->top 3  ->top 1.1->1   1.2->1   2.1->2   2.2->2   3.1->3  
#> [9] 3.2->3
```

We can sum the budget numbers as follows:

``` r
rollup(
  tree=wbs_tree,
  ds=wbs_table,
  update=function(d, t, s) update_df_prop_by_id(df=d, target=t, sources=s, prop="budget"),
  validate_ds=function(t, d) validate_df_by_id(tree=t, df=d, prop="budget")
)
#>     id  pid                    name budget
#> 1  top <NA> Construction of a House 215500
#> 2    1  top                Internal  86000
#> 3    2  top              Foundation  46000
#> 4    3  top                External  83500
#> 5  1.1    1              Electrical  25000
#> 6  1.2    1                Plumbing  61000
#> 7  2.1    2                Excavate  37000
#> 8  2.2    2          Steel Erection   9000
#> 9  3.1    3            Masonry Work  62000
#> 10 3.2    3       Building Finishes  21500
```
