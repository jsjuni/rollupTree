#
# rollup(tree, update, ds, validate_ds)
#
#     tree:           igraph dag
#     ds:             dataset to update
#     update:         called depth-first at each node as update(ds, parent_key, child_keys)
#     validate_ds:    called as validate_ds(tree, ds)
#     validate_tree:  called as validate_tree(tree)

rollup <- function(tree, ds, update, validate_ds, validate_tree = default_validate_tree) {
  root <- validate_tree(tree)
  validate_ds(tree, ds)
  Reduce(
    f = function(s, v) update(s, names(V(tree))[v], names(neighbors(tree, v, "in"))),
    x = dfs(tree, root, mode="in", order=FALSE, order.out=TRUE)$order.out,
    init = ds
  )
}
