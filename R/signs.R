#' Add proper minus signs
#'
#' The true minus sign (Unicode 2212) --
#' neither an em dash, nor an en dash, nor the usual hyphen-minus --
#' is highly underrated.
#' It makes everything look better!
#'
#' \code{add_plusses}, \code{trim_leading_zeros}, and \code{label_at_zero}
#' are offered for convenience.
#'
#' The options \code{signs.format}, \code{signs.add.plusses},
#' \code{signs.trim.leading.zeros}, and \code{signs.label.at.zero}
#' are set when the package is loaded
#' to \code{scales::number}, \code{FALSE}, \code{FALSE}, and \code{"none"},
#' respectively.
#' If the package is not loaded and the these options are not otherwise set,
#' \code{signs} will use those defaults.
#'
#' \code{label_at_zero} is applied \emph{after} \code{format};
#' that is, if it is \code{"blank"}
#' and you've specified an accuracy of \code{0.1},
#' \code{-0.04} will show as blank.
#'
#' @param x Numeric vector.
#' @param ... Other arguments passed on to \code{format}.
#' @param format Any function that takes a numeric vector
#'   and returns a character vector,
#'   such as \code{scales::number},
#'   \code{scales::comma}, or
#'   \code{scales::percent}
#'   (all of which are documented at \code{\link[scales]{number_format}}).
#' @param add_plusses Logical. Should positive values have plus signs?
#' @param trim_leading_zeros Logical. Should \code{signs} trim leading zeros
#'   from values of \code{x} between -1 and 1?
#' @param label_at_zero Character. What should be returned
#'   when \code{x = 0}? Options \code{"none"} (no change),
#'   \code{"blank"} (a zero-length string),
#'   or \code{"symbol"} (add a plus-minus symbol).
#'
#' @return A \code{UTF-8} character vector
#' @import scales
#' @export
#'
#' @examples
#' x <- seq(-5, 5)
#' scales::number(x)
#' signs(x)
#' signs(x, accuracy = 1, scale = 1, format = scales::percent)
#' signs(x, add_plusses = TRUE)
#' signs(x, add_plusses = TRUE, label_at_zero = "blank")
#' signs(x, add_plusses = TRUE, label_at_zero = "symbol")
#' signs(x, accuracy = .1, scale = .1, trim_leading_zeros = TRUE)
signs <- function(x,
                  ...,
                  format = getOption("signs.format", scales::number),
                  add_plusses = getOption("signs.add.plusses", FALSE),
                  trim_leading_zeros = getOption("signs.trim.leading.zeros", FALSE),
                  label_at_zero = getOption("signs.label.at.zero", "none")) {

  if (!is.numeric(x)) stop("`x` should be a numeric vector.")
  check_args(
    format,
    add_plusses,
    trim_leading_zeros,
    label_at_zero
  )

  response <- format(x, ...)
  significand <- sub("e.*", "", response)
  considered_zero <- !grepl("[1-9]", significand)

  if (add_plusses) {
    missing_plus <- x > 0 & !considered_zero & !grepl("(^|[^e])\\+", response)
    response[missing_plus] <- paste0("+", response[missing_plus])
  }
  if (trim_leading_zeros) {
    response <- sub("(\\+|-)?0+\\.", "\\1.", response)
  }
  response[considered_zero] <- switch(
    label_at_zero,
    none   = response[considered_zero],
    blank  = "",
    symbol = paste0("\u00b1", response[considered_zero])
  )
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
#' @param ... Other arguments passed on to \code{format}.
#' @param format Any function that takes a numeric vector
#'   and returns a character vector,
#'   such as \code{scales::number},
#'   \code{scales::comma}, or
#'   \code{scales::percent}
#'   (all of which are documented at \code{\link[scales]{number_format}}).
#' @param add_plusses Logical. Should positive values have plus signs?
#' @param trim_leading_zeros Logical. Should \code{signs} trim leading zeros
#'   from values of \code{x} between -1 and 1?
#' @param label_at_zero Character. What should be returned
#'   when \code{x = 0}? Options \code{"none"} (no change),
#'   \code{"blank"} (a zero-length string),
#'   or \code{"symbol"} (add a plus-minus symbol).
#'
#' @return A function that takes a numeric vector
#'   and returns a \code{UTF-8} character vector
#' @import scales rlang
#' @export
#'
#' @examples
#' x <- seq(-5, 5)
#' scales::number(x)
#'
#' f1 <- signs_format()
#' f1(x)
#'
#' f2 <- signs_format(accuracy = 1, scale = 1, format = scales::percent)
#' f2(x)
#'
#' f3 <- signs_format(add_plusses = TRUE)
#' f3(x)
#'
#' f4 <- signs_format(add_plusses = TRUE, label_at_zero = "blank")
#' f4(x)
#'
#' f5 <- signs_format(add_plusses = TRUE, label_at_zero = "symbol")
#' f5(x)
#'
#' f6 <- signs_format(accuracy = .1, scale = .1, trim_leading_zeros = TRUE)
#' f6(x)
signs_format <-
  function(...,
           format = getOption("signs.format", scales::number),
           add_plusses = getOption("signs.add.plusses", FALSE),
           trim_leading_zeros = getOption("signs.trim.leading.zeros", FALSE),
           label_at_zero = getOption("signs.label.at.zero", "none")) {

  dots <- rlang::list2(...)
  check_args(
    format,
    add_plusses,
    trim_leading_zeros,
    label_at_zero
  )

  rlang::new_function(
    as.pairlist(alist(x = )),
    rlang::expr({
      signs::signs(x                  = x,
                   !!!dots,
                   format             = !!format,
                   add_plusses        = !!add_plusses,
                   trim_leading_zeros = !!trim_leading_zeros,
                   label_at_zero      = !!label_at_zero)
      }),
    rlang::caller_env()
  )
}
