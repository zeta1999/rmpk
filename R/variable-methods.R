#' @include variable-class.R
#' @include linear-expression-class.R
#' @include helper.R
setMethod("+", signature(e1 = "RLPVariable", e2 = "numeric"), function(e1, e2) {
  val <- new("RMPKLinearExpression")
  slot(val, "variables", check = FALSE) <- var_to_map(e1)
  if (e2 != 0) {
    slot(val, "constant", check = FALSE) <- e2
  }
  val
})

setMethod("+", signature(e1 = "numeric", e2 = "RLPVariable"), function(e1, e2) {
  e2 + e1
})

setMethod("+", signature(e1 = "RLPVariable", e2 = "missing"), function(e1, e2) {
  e1
})

setMethod("+", signature(e1 = "RLPVariable", e2 = "RLPVariable"), function(e1, e2) {
  val <- new("RMPKLinearExpression")
  slot(val, "variables", check = FALSE) <- merge_with_single_variable(var_to_map(e1), e2)
  val
})

setMethod("-", signature(e1 = "RLPVariable", e2 = "numeric"), function(e1, e2) {
  e1 + -1 * e2
})

setMethod("-", signature(e1 = "numeric", e2 = "RLPVariable"), function(e1, e2) {
  (-1 * e2) - (-1 * e1)
})

setMethod("-", signature(e1 = "RLPVariable", e2 = "RLPVariable"), function(e1, e2) {
  e1 + -1 * e2
})

setMethod("-", signature(e1 = "RLPVariable", e2 = "missing"), function(e1, e2) {
  (-1) * e1
})

setMethod("*", signature(e1 = "RLPVariable", e2 = "numeric"), function(e1, e2) {
  e1@coefficient <- e1@coefficient * e2
  e1
})

setMethod("*", signature(e1 = "numeric", e2 = "RLPVariable"), function(e1, e2) {
  e2 * e1
})

# --- RLPVariableList
setMethod("[", signature("RLPVariableList", i = "ANY", j = "ANY", drop = "missing"), function(x, i, j, ..., drop) {
  indexes <- list()
  if (!missing(i)) {
    indexes[[length(indexes) + 1L]] <- i
  }
  if (!missing(j)) {
    indexes[[length(indexes) + 1L]] <- j
  }
  for (arg in list(...)) {
    indexes[[length(indexes) + 1L]] <- arg
  }
  # stopifnot(all(vapply(indexes, length, integer(1L)) == 1L))
  # TODO: implement this without the linear overhead
  var_name <- paste0(x@base_name, "/", paste0(indexes, collapse = "/"), collapse = "/")
  x@variables_map$get(var_name)
})

# --- RLPVariableListBuilder
setMethod("[", signature("RLPVariableListBuilder", i = "ANY", j = "ANY", drop = "missing"), function(x, i, j, ..., drop) {
  indexes <- list()
  if (!missing(i)) {
    indexes[[length(indexes) + 1L]] <- i
  }
  if (!missing(j)) {
    indexes[[length(indexes) + 1L]] <- j
  }
  for (arg in list(...)) {
    indexes[[length(indexes) + 1L]] <- arg
  }
  # TODO: document or warn about it?
  lapply(indexes, function(x) {
    if (is.numeric(x) && !is.integer(x)) {
      as.integer(x)
    } else {
      x
    }
  })
})