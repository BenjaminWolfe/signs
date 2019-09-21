#' Add proper minus signs
#'
#' The true minus sign (Unicode 2212) -- neither an em dash, nor an en dash,
#' nor the usual hyphen-minus -- is highly underrated.
#' It makes everything look better!
#'
#' \code{add_plusses}, \code{strip_leading_zeros}, and \code{blank_at_zero}
#' are offered for convenience.
#'
#' The options \code{signs.format}, \code{signs.add.plusses},
#' \code{signs.strip.leading.zeros}, and \code{signs.blank.at.zero}
#' are set when the package is loaded
#' to \code{scales::number}, \code{FALSE}, \code{FALSE}, and \code{FALSE},
#' respectively.
#' If the package is not loaded and the these options are not otherwise set,
#' \code{signs} will use those defaults.
#'
#' @param x Numeric vector.
#' @param format Any function that takes a numeric vector
#'   and returns a character vector,
#'   such as \code{scales::number},
#'   \code{scales::comma}, or
#'   \code{scales::percent}
#'   (all of which are documented at \code{\link[scales]{number_format}}).
#' @param add_plusses Logical. Should positive values have plus signs?
#' @param strip_leading_zeros Logical. Should \code{signs} strip leading zeros
#'   from values of \code{x} between -1 and 1?
#' @param blank_at_zero Logical. Should \code{signs} return a blank string
#'   when \code{x} is exactly zero?
#' @param ... Other arguments passed on to \code{format}.
#'
#' @return A \code{UTF-8} character vector
#' @import scales
#' @importFrom rlang "%||%"
#' @export
#'
#' @examples
#' x <- seq(-5, 5)
#' scales::number(x)
#' signs(x)
#' signs(x, format = scales::percent, scale = .01)
#' signs(x, add_plusses = TRUE)
#' signs(x, add_plusses = TRUE, blank_at_zero = TRUE)
#' signs(x, strip_leading_zeros = TRUE, scale = .1, accuracy = .1)
signs <- function(x,
                  format = getOption("signs.format"),
                  add_plusses = getOption("signs.add.plusses"),
                  strip_leading_zeros = getOption("signs.strip.leading.zeros"),
                  blank_at_zero = getOption("signs.blank.at.zero"),
                  ...) {

  format              <- format              %||% scales::number
  add_plusses         <- add_plusses         %||% FALSE
  strip_leading_zeros <- strip_leading_zeros %||% FALSE
  blank_at_zero       <- blank_at_zero       %||% FALSE

  if (!is.numeric(x)) stop("`x` should be a numeric vector.")
  check_args(
    format,
    add_plusses,
    strip_leading_zeros,
    blank_at_zero
  )

  response <- format(x, ...)
  if (add_plusses) {
    missing_plusses <- x > 0 & !grepl("(^|[^e])\\+", response)
    response[missing_plusses] <- paste0("+", response[missing_plusses])
  }
  if (strip_leading_zeros) {
    response <- sub("(\\+|-)?0+\\.", "\\1.", response)
  }
  if (blank_at_zero) {
    response[x == 0] <- ""
  }
  response <- gsub("-", "\u2212", response)

  Encoding(response) <- "UTF-8"
  response
}

#' A function factory to add proper minus signs
#'
#' Returns a \emph{function} that will format numeric vectors
#' with proper minus signs.
#'
#' See \code{\link{signs}} for details.
#'
#' @param format Any function that takes a numeric vector
#'   and returns a character vector,
#'   such as \code{scales::number},
#'   \code{scales::comma}, or
#'   \code{scales::percent}
#'   (all of which are documented at \code{\link[scales]{number_format}}).
#' @param add_plusses Logical. Should positive values have plus signs?
#' @param strip_leading_zeros Logical. Should \code{signs} strip leading zeros
#'   from values of \code{x} between -1 and 1?
#' @param blank_at_zero Logical. Should \code{signs} return a blank string
#'   when \code{x} is exactly zero?
#' @param ... Other arguments passed on to \code{format}.
#'
#' @return A function that takes a numeric vector
#'   and returns a \code{UTF-8} character vector
#' @import scales rlang
#' @importFrom rlang "%||%"
#' @export
#'
#' @examples
#' x <- seq(-5, 5)
#' scales::number(x)
#'
#' f1 <- signs_format()
#' f1(x)
#'
#' f2 <- signs_format(format = scales::percent, scale = .01)
#' f2(x)
#'
#' f3 <- signs_format(add_plusses = TRUE)
#' f3(x)
#'
#' f4 <- signs_format(add_plusses = TRUE, blank_at_zero = TRUE)
#' f4(x)
#'
#' f5 <- signs_format(strip_leading_zeros = TRUE, scale = .1, accuracy = .1)
#' f5(x)
signs_format <-
  function(format = getOption("signs.format"),
           add_plusses = getOption("signs.add.plusses"),
           strip_leading_zeros = getOption("signs.strip.leading.zeros"),
           blank_at_zero = getOption("signs.blank.at.zero"),
           ...) {
  format              <- format              %||% scales::number
  add_plusses         <- add_plusses         %||% FALSE
  strip_leading_zeros <- strip_leading_zeros %||% FALSE
  blank_at_zero       <- blank_at_zero       %||% FALSE

  dots <- rlang::list2(...)
  check_args(
    format,
    add_plusses,
    strip_leading_zeros,
    blank_at_zero
  )

  rlang::new_function(
    as.pairlist(alist(x = )),
    rlang::expr({
      signs(x                   = x,
            format              = !!format,
            add_plusses         = !!add_plusses,
            strip_leading_zeros = !!strip_leading_zeros,
            blank_at_zero       = !!blank_at_zero,
            !!!dots)
      }),
    rlang::caller_env()
  )
}
