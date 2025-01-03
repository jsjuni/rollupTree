#' Update a data set with recursively-defined properties
#'
#' @description
#' `update_prop()` calls user-specified methods to get properties
#' of a source set of elements in a data set, combine those properties,
#' and set the properties of a target element to the combined value.
#' If the source set is empty, the data set is returned unmodified. The
#' default combine operation is addition.
#'
#' The `override` argument can be used to selectively override the
#' computed value based on the target element. By default, it simply
#' returns the value computed by combine().
#'
#' @param ds Data set to be updated
#' @param target Key of data set element to be updated
#' @param sources Keys of data set elements to be combined
#' @param set Method to set properties for a target element
#' @param get Method to get properties for source elements
#' @param combine Method to combine properties
#' @param override Method to selectively override combine() results
#'
#' @return Updated data set
#' @export
#'
#' @examples
#' update_prop(wbs_table, "1", list("1.1", "1.2"),
#'   function(d, k, v) {d[d$id == k, "work"] <- v; d},
#'   function(d, k) d[d$id == k, "work"]
#'  )
#' update_prop(wbs_table, "1", list("1.1", "1.2"),
#'   function(d, k, v) {d[d$id == k, c("work", "budget")] <- v; d},
#'   function(d, k) d[d$id == k, c("work", "budget")],
#'   function(l) Reduce("+", l)
#' )
update_prop <- function(ds, target, sources, set, get,
                        combine = function(l) Reduce('+', l),
                        override = function(ds, target, v) v) {
  if (length(sources) > 0) {
    av <- Map(f = function(s) get(ds, s), sources)
    set(ds, target, override(ds, target, combine(av)))
  } else
    ds
}

# helper methods for data frames

# get keys from data frame

df_get_keys <- function(df, key) df[, key]

# get ids from data frame (key="id")

df_get_ids <- function(df) df_get_keys(df, "id")

# get property by key from data frame

df_get_by_key <- function(df, key, r, c) df[df[, key] == r, c]

# get property by key="id" from data frame

df_get_by_id <- function(df, r, c) df[df[, "id"] == r, c]
# set property by key in data frame

df_set_by_key <- function(df, key, r, c, v) {
  df[df[, key] == r, c] <- v
  df
}

# set property by key="id" in data frame

df_set_by_id <- function(df, r, c, v) {
  df[df[, "id"] == r, c] <- v
  df
}

#' Update a property in a dataframe
#'
#' `update_df_prop_by_key()` is a convenience wrapper around `update_prop()`
#' for the common case in which the data set is a dataframe.
#'
#' @param df A data frame
#' @param key Name of the column serving as key
#' @param target Key of data set element to be updated
#' @param sources Keys of data set elements to be combined
#' @param prop Column name of the property
#' @param ... Other arguments passed to `update_prop()`
#'
#' @return The updated dataframe
#' @export
#'
#' @examples
#' update_df_prop_by_key(wbs_table, "id", "1", list("1.1", "1.2"), "work")
update_df_prop_by_key <- function(df, key, target, sources, prop, ...) {
  update_prop(df, target, sources,
              function(df, id, v) df_set_by_key(df, key, id, prop, v),
              function(df, id, v) df_get_by_key(df, key, id, prop),
              ...
  )
}

#' Update a property in a dataframe with key "id"
#'
#' `update_df_prop_by_id()` is a convenience wrapper around `update_prop()`
#' for the common case in which the data set is a dataframe whose key column
#' is named "id"
#'
#' @param df A data frame
#' @param target Key of data set element to be updated
#' @param sources Keys of data set elements to be combined
#' @param prop Column name of the property
#' @param ... Other arguments passed to `update_prop()`
#'
#' @return The updated dataframe
#' @export
#'
#' @examples
#' update_df_prop_by_id(wbs_table, "1", list("1.1", "1.2"), "work")
update_df_prop_by_id <- function(df, target, sources, prop, ...) {
  update_prop(df, target, sources,
              function(df, id, v) df_set_by_id(df, id, prop, v),
              function(df, id, v) df_get_by_id(df, id, prop),
              ...
  )
}

#' Validate a dataframe For rollup
#'
#' @description
#' `validate_df_by_key()` is a convenience wrapper for `validate_ds()` for the common case in which the
#' data set is a dataframe.
#'
#' @param tree The tree to validate against
#' @param df A datafame
#' @param key Name of the column serving as key
#' @param prop Property whose value is checked (leaf elements only)
#' @param ... Other parameters passed to validate_ds()
#'
#' @return TRUE if validation succeeds, halts otherwise
#' @export
#'
#' @examples
#' validate_df_by_key(wbs_tree, wbs_table, "id", "work")
validate_df_by_key <- function(tree, df, key, prop, ...) {
  validate_ds(tree, df, function(d) df_get_keys(d, key), function(d, r) df_get_by_key(d, key, r, prop), ...)
}

#' Validate a dataframe with key "id" for rollup
#'
#' @description
#' `validate_df_by_id()` is a convenience wrapper for `validate_ds()` for the common case in which the
#' data set is a dataframe with key column named "id".

#'
#' @param tree The tree to validate against
#' @param df A datafame
#' @param prop Property whose value is checked (leaf elements only)
#' @param ... Other parameters passed to validate_ds()
#'
#' @return TRUE if validation succeeds, halts otherwise
#' @export
#'
#' @examples
#' validate_df_by_id(wbs_tree, wbs_table, "work")
validate_df_by_id <- function(tree, df, prop, ...) {
  validate_ds(tree, df, function(d) df_get_ids(d), function(d, r) df_get_by_id(d, r, prop), ...)
}
