#' Update a Data Set With Recursively-Defined Properties
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
#'   function(d, k) d[d$id == k, "work"],
#'   function(l) Reduce("+", l)
#' )
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
