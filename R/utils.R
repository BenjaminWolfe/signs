check_args <- function(format,
                       add_plusses,
                       trim_leading_zeros,
                       blank_at_zero) {

  if (!is.function(format) || !is.character(format(1))) {
    stop(
      paste0(
        "`format` should be a function that returns a character vector, ",
        "such as `as.character` or `scales::number`. ",
        "Consider setting a default with `options(signs.format=your_function)`."
      )
    )
  }
  if (!is.logical(add_plusses) | length(add_plusses) > 1) {
    stop("`add_plusses` should be a logical vector of length 1.")
  }
  if (!is.logical(trim_leading_zeros) | length(trim_leading_zeros) > 1) {
    stop("`trim_leading_zeros` should be a logical vector of length 1.")
  }
  if (!is.logical(blank_at_zero) | length(blank_at_zero) > 1) {
    stop("`blank_at_zero` should be a logical vector of length 1.")
  }
}
