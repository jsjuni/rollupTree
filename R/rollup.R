#' Perform Recursive Analysis
#'
#' @description `rollup()` traverses a tree in depth-first postorder and calls a
#' user-specified update method on each vertex, passing it a data set, the id of
#' that vertex in the data set, and a list of child ids for that vertex. The
#' update method should perform the desired operation, update the data set, and
#' return the updated data set.
#'
#' An `update_prop()` helper function is available to simplify building
#' compliant update methods.
#'
#' Before beginning the traversal, `rollup()` ensures that the tree is
#' well-formed. It also ensures (by default, see `default_validate_tree()`) that
#' the id sets of the tree and data set are identical, and that data set
#' elements corresponding to leaf vertices in the tree satisfy some
#' user-specified predicate, e.g., `is.numeric()`.
#'
#' @param tree An igraph directed graph that is a valid single-rooted in-tree
#' @param ds A data set to be updated; can be any object
#' @param update The update method called at each vertex as update(ds,
#'   parent_key, child_keys)
#' @param validate_ds The data set validator called as validate_ds(tree, ds)
#' @param validate_tree The tree validator called as validate_tree(tree)
#'
#' @return The updated data set
#' @export
#'
#' @examples
#'
#' ds <- data.frame(id=c("a", "b", "c", "d", "e"), mass=c(NA,18.2,NA,5.2,9.9))
#' tree <- graph(c("b", "a", "c", "a", "d", "c", "e", "c"), directed = TRUE)
#' rollup(tree, ds,
#'   update = function(d, p, c) { if (length(c) > 0) d[d$id == p, "mass"] <- sum(d[is.element(d$id, c), "mass"]); d },
#'   validate_ds = function(tree, ds) TRUE
#' )
#'
rollup <- function(tree, ds, update, validate_ds, validate_tree = default_validate_tree) {
  root <- validate_tree(tree)
  validate_ds(tree, ds)
  Reduce(
    f = function(s, v) update(s, names(igraph::V(tree))[v], names(igraph::neighbors(tree, v, "in"))),
    x = igraph::dfs(tree, root, mode="in", order=FALSE, order.out=TRUE)$order.out,
    init = ds
  )
}

#' Validate a tree for use with rollup()
#'
#' @description default_validate_tree() ensures that a tree is acyclic,
#' loop-free, single-edged, connected, directed, and single-rooted with edge
#' direction from child to parent.
#'
#' @param tree An igraph directed graph to be validated
#'
#' @return single root element if tree is valid; stops otherwise
#' @export
#'
#' @examples
default_validate_tree <- function(tree) {
  if (igraph::girth(tree, circle = FALSE)$girth != Inf) stop("graph is cyclic")
  if (any(igraph::which_loop(tree))) stop("graph contains loops")
  if (any(igraph::which_multiple(tree))) stop("graph contains multiple edges")
  if (!igraph::is_connected(tree)) stop("graph is disconnected")
  if (!igraph::is_directed(tree)) stop("graph is undirected")
  roots <- which(igraph::degree(tree, mode = "out") == 0)
  if (length(roots) > 1) stop("graph contains multiple roots")
  roots[1]
}
