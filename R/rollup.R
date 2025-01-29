#' Perform recursive computation
#'
#' @description `rollup()` traverses a tree depth-first (post order) and calls a
#'   user-specified update function at each vertex, passing the method a data set,
#'   the unique key of that target vertex in the data set, and a list of source
#'   keys. The update method typically gets some properties of the source
#'   elements of the data set, combines them, sets some properties of the
#'   target element of the data set to the combined value, and returns the
#'   updated data set as input to the update of the next vertex. The final
#'   operation updates the root vertex.
#'
#'   An `update_prop()` helper function is available to simplify building
#'   compliant update methods.
#'
#'   Before beginning the traversal, `rollup()` calls a user-specified method to
#'   validate that the tree is well-formed (see [default_validate_tree()]). It
#'   also calls a user-specified method to ensure that the id sets of the tree
#'   and data set are identical, and that data set elements corresponding to
#'   leaf vertices in the tree satisfy some user-specified predicate, e.g.,
#'   `is.numeric()`.
#'
#' @details The data set passed to `rollup()` can be any object for which an
#'   update function can be written. A common and simple example is a data
#'   frame, but lists work as well.
#'
#' @param tree `igraph` directed graph that is a valid single-rooted in-tree
#'   and whose vertex names are keys from the data set
#' @param ds data set to be updated; can be any object
#' @param update function called at each vertex as update(ds,
#'   parent_key, child_keys)
#' @param validate_ds data set validator function called as validate_ds(tree, ds)
#' @param validate_tree tree validator function called as validate_tree(tree)
#'
#' @returns updated input data set
#' @export
#'
#' @examples
#' rollup(wbs_tree, wbs_table,
#'   update = function(d, p, c) {
#'     if (length(c) > 0)
#'       d[d$id == p, c("work", "budget")] <-
#'         apply(d[is.element(d$id, c), c("work", "budget")], 2, sum)
#'       d
#'   },
#'   validate_ds = function(tree, ds) TRUE
#' )
#'
rollup <- function(tree, ds, update, validate_ds, validate_tree = default_validate_tree) {
  validate_tree(tree)
  validate_ds(tree, ds)
  Reduce(
    f = function(s, v) update(s, names(igraph::V(tree)[v]), names(igraph::neighbors(tree, v, "in"))),
    x = igraph::topo_sort(tree, mode="out"),
    init = ds
  )
}

#' Update a rollup from a single leaf vertex
#'
#' @description
#' `update_rollup()` performs a minimal update of a data set assuming a single leaf element property
#' has changed. It performs updates along the path from that vertex to the root. There should be no difference
#' in the output from calling `rollup()` again. `update_rollup()` is perhaps more efficient and useful in an interactive context.
#'
#' @inheritParams rollup
#' @param vertex The start vertex
#'
#' @returns updated input data set
#' @export
#'
#' @examples
#' update_rollup(wbs_tree, wbs_table, igraph::V(wbs_tree)["3.2"],
#'   update = function(d, p, c) {
#'     if (length(c) > 0)
#'       d[d$id == p, c("work", "budget")] <-
#'         apply(d[is.element(d$id, c), c("work", "budget")], 2, sum)
#'       d
#'   }
#' )
#'
update_rollup <- function(tree, ds, vertex, update) {
  if (igraph::degree(tree, vertex, mode="in") > 0) stop("update_rollup on non-leaf")
  vertices_above <- igraph::subcomponent(tree, vertex, mode = "out")[-1]
  subtree <- igraph::subgraph(tree, vertices_above)
  Reduce(
    f = function(s, v) update(s, v, names(igraph::neighbors(tree, igraph::V(tree)[v], "in"))),
    x = names(igraph::topo_sort(subtree, mode = "out")),
    init = ds
  )
}

#' Validates a data set for use with `rollup()`
#'
#' @description
#' `validate_ds()` ensures that a data set contains the same identifiers as a specified tree and that
#' elements of the data set corresponding to leaf vertices in the tree satisfy a user-specified predicate.
#'
#' @inheritParams rollup
#' @param get_keys function to get keys of the data set called as `get_keys(ds)`
#' @param get_prop function to get the property value to validate for leaf element with id `l`, called as `get_prop(ds, l)`
#' @param op logical function to test return value of `get_prop()` (default `is.numeric()`); returns `TRUE` if OK
#'
#' @returns TRUE if validation succeeds, halts otherwise
#' @export
#'
#' @examples
#' validate_ds(wbs_tree, wbs_table, function(d) d$id, function(d, l) d[d$id == l, "work"])
#'
validate_ds <- function(tree, ds, get_keys, get_prop, op=function(x) is.numeric(x) & !is.na(x)) {
  tree_ids <- names(igraph::V(tree))
  ds_ids <- get_keys(ds)
  if (!setequal(tree_ids, ds_ids)) stop("mismatched ids")
  leaves <- names(which(igraph::degree(tree, mode = "in") == 0))
  if (any(sapply(leaves, FUN=function(l) !op(get_prop(ds, l)))))
    stop (paste("leaf with invalid value"))
  TRUE
}

#' Validate a tree for use with `rollup()`
#'
#' @description `default_validate_tree()` ensures that a tree is acyclic,
#' loop-free, single-edged, connected, directed, and single-rooted with edge
#' direction from child to parent.
#'
#' @inheritParams rollup
#'
#' @returns single root vertex identifier if tree is valid; stops otherwise
#' @export
#'
#' @examples
#' default_validate_tree(wbs_tree)
default_validate_tree <- function(tree) {
  if (any(igraph::which_multiple(tree))) stop("graph contains multiple edges")
  if (!igraph::is_forest(tree, mode = "all")) stop("graph is cyclic")
  if (!igraph::is_connected(tree)) stop("graph is disconnected")
  if (!igraph::is_directed(tree)) stop("graph is undirected")
  roots <- which(igraph::degree(tree, mode = "out") == 0)
  if (length(roots) > 1) stop("graph contains multiple roots")
  roots[1]
}

#' Create a tree for use with `rollup()`
#'
#' @description
#' `create_rollup_tree()` creates a tree suitable for use with `rollup()`
#' by applying helper functions to construct vertices and edges.
#'
#' @param get_keys A function() that returns a collection of names for vertices.
#' @param get_parent_key_by_child_key A function(key) that returns for each child key the key of its parent.
#'
#' @returns An `igraph` directed graph with vertices and edges as supplied
#' @export
#'
#' @examples
#' get_keys <- function() wbs_table$id
#' get_parent_key_by_child_key <- function(key) wbs_table[which(wbs_table$id == key), "pid"]
#' create_rollup_tree(get_keys, get_parent_key_by_child_key)
#'
create_rollup_tree <- function(get_keys, get_parent_key_by_child_key) {
  keys <- get_keys()
  Reduce(
    f = function(g, e) igraph::add_edges(g, igraph::V(g)[c(e[1], e[2])]),
    x = Filter(
      f = function(e) !is.na(e[2]),
      Map(
        f = function(id) c(id, get_parent_key_by_child_key(id)),
        keys
      )
    ),
    init = igraph::add_vertices(
      graph = igraph::make_empty_graph(directed = TRUE),
      nv = length(keys),
      name = keys
    )
  )
}
