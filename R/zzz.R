.onLoad <- function(libname, pkgname) {
  op <- options()
  op.signs <- list(
    signs.format             = scales::number,
    signs.add.plusses        = FALSE,
    signs.trim.leading.zeros = FALSE,
    signs.label.at.zero      = "none"
  )
  toset <- !(names(op.signs) %in% names(op))
  if(any(toset)) options(op.signs[toset])

  invisible()
}
