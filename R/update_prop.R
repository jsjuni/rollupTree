#' Update a Data Set With Recursively-Defined Properties
#'
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
