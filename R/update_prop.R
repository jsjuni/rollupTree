#' Update a data set with recursively-defined properties
#'
#' @description
#' `update_prop` calls user-specified methods to get properties
#' of a source set of elements in a data set, combine those properties,
#' and set the properties of a target element to the combined value.
#' If the source set is empty, the data set is returned unmodified. The
#' default combine operation is addition.
#'
#' The `override` argument can be used to selectively override the
#' computed value based on the target element. By default, it simply
#' returns the value computed by the combiner.
#'
#' @param ds data set to be updated
#' @param target key of data set element to be updated
#' @param sources keys of data set elements to be combined
#' @param set function to set properties for a target element called as set(ds, key, value)
#' @param get function to get properties for source elements called as get(ds, key)
#' @param combine function to combine properties called as combine(vl)
#' @param override function to selectively override combined results called as override(ds, key,)
#'
#' @return updated data set
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

#' Get keys from a data frame
#'
#' @description
#' `df_get_keys` gets all values from a designated column in a data frame.
#'
#' @param df a data frame
#' @param key name of the column used as key
#'
#' @return All values of the key column
#' @export
#'
#' @examples
#' df_get_keys(wbs_table, "id")
df_get_keys <- function(df, key) df[, key]

#' Get ids from a data frame
#'
#' @description
#' The default name for a key column in `rollup` is `id`. `df_get_ids` gets all values
#' from the `id` column in a data frame.
#'
#' @param df a data frame
#'
#' @return all values of the `id` column
#' @export
#'
#' @examples
#' df_get_ids(wbs_table)
df_get_ids <- function(df) df_get_keys(df, "id")

#' Get property by key from data frame
#'
#' @description
#' `df_get_by_key` returns the value of specified property (column) in a specified row
#' of a data frame. The row is specified by a key column and a value from that column.
#'
#' @param df a data frame
#' @param key name of the column used as key
#' @param keyval value of the key for the specified row
#' @param prop column name of the property value to get
#'
#' @return The requested value
#' @export
#'
#' @examples
#' df_get_by_key(wbs_table, "id", "1.1", "work")
df_get_by_key <- function(df, key, keyval, prop) df[df[, key] == keyval, prop]

#' Get property by key "id" from data frame
#'
#' @description
#' `df_get_by_id` returns the value of specified property (column) in a specified row
#' of a data frame. The row is specified by a value for the `id` column.
#'
#' @param df a data frame
#' @param idval id of the row to get
#' @param prop name of the column to get
#'
#' @return The requested value
#' @export
#'
#' @examples
#' df_get_by_id(wbs_table, "1.1", "work")
df_get_by_id <- function(df, idval, prop) df[df[, "id"] == idval, prop]

#' Set property by key in data frame
#'
#' @param df a data frame
#' @param key name of the column used as key
#' @param keyval value of the key for the specified row
#' @param prop column name of the property value to get
#' @param val value to set
#'
#' @return The updated data frame
#' @export
#'
#' @examples
#' df_set_by_key(wbs_table, "id", "1", "work", 45.6)
df_set_by_key <- function(df, key, keyval, prop, val) {
  df[df[, key] == keyval, prop] <- val
  df
}

#' Set property by key "id" in data frame
#'
#' @param df a data frame
#' @param idval id value for the specified row
#' @param prop column name of the property value to get
#' @param val value to set
#'
#' @return updated data frame
#' @export
#'
#' @examples
#' df_set_by_id(wbs_table, "1", "work", 45.6)
df_set_by_id <- function(df, idval, prop, val) {
  df[df[, "id"] == idval, prop] <- val
  df
}

#' Update a property in a data frame
#'
#' `update_df_prop_by_key()` is a convenience wrapper around `update_prop()`
#' for the common case in which the data set is a data frame.
#'
#' @param df a data frame
#' @param key name of the column serving as key
#' @param target key of data set element to be updated
#' @param sources keys of data set elements to be combined
#' @param prop column name of the property
#' @param ... other arguments passed to `update_prop()`
#'
#' @return The updated data frame
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

#' Update a property in a data frame with key "id"
#'
#' `update_df_prop_by_id()` is a convenience wrapper around `update_prop()`
#' for the common case in which the data set is a data frame whose key column
#' is named "id"
#'
#' @param df a data frame
#' @param target key of data set element to be updated
#' @param sources keys of data set elements to be combined
#' @param prop column name of the property
#' @param ... other arguments passed to `update_prop()`
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

#' Validate a data frame For `rollup()`
#'
#' @description
#' `validate_df_by_key()` is a convenience wrapper for `validate_ds()` for the common case in which the
#' data set is a dataframe.
#'
#' @param tree tree to validate against
#' @param df data frame
#' @param key name of the column serving as key
#' @param prop property whose value is checked (leaf elements only)
#' @param ... other parameters passed to validate_ds()
#'
#' @return TRUE if validation succeeds, halts otherwise
#' @export
#'
#' @examples
#' validate_df_by_key(wbs_tree, wbs_table, "id", "work")
validate_df_by_key <- function(tree, df, key, prop, ...) {
  validate_ds(tree, df, function(d) df_get_keys(d, key), function(d, r) df_get_by_key(d, key, r, prop), ...)
}

#' Validate a data frame with key "id" for `rollup()`
#'
#' @description
#' `validate_df_by_id()` is a convenience wrapper for `validate_ds()` for the common case in which the
#' data set is a data frame with key column named "id".

#'
#' @param tree tree to validate against
#' @param df data frame
#' @param prop property whose value is checked (leaf elements only)
#' @param ... other parameters passed to validate_ds()
#'
#' @return TRUE if validation succeeds, halts otherwise
#' @export
#'
#' @examples
#' validate_df_by_id(wbs_tree, wbs_table, "work")
validate_df_by_id <- function(tree, df, prop, ...) {
  validate_ds(tree, df, function(d) df_get_ids(d), function(d, r) df_get_by_id(d, r, prop), ...)
}
