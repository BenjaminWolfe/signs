.onLoad <- function(libname, pkgname) {
  op <- options()
  home <- path.expand('~')

  op.signs <- list(
    signs.format = scales::number,
    signs.add.plusses = FALSE,
    signs.strip.leading.zeros = FALSE,
    signs.blank.at.zero = FALSE
  )
  toset <- !(names(op.signs) %in% names(op))
  if(any(toset)) options(op.signs[toset])

  invisible()
}
