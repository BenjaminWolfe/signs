library(signs)
x <- seq(-1, 1)

test_that(
  "the basics work",
  {
    expect_equal(
      signs_format(1)(x),
      c("\u22121", "0", "1")
    )
    expect_equal(
      signs_format(1, scale = 1, format = scales::percent)(x),
      c("\u22121%", "0%", "1%")
    )
    expect_equal(
      signs_format(1, add_plusses = TRUE)(x),
      c("\u22121", "0", "+1")
    )
    expect_equal(
      signs_format(1, label_at_zero = "blank")(x),
      c("\u22121", "", "1")
    )
    expect_equal(
      signs_format(1, label_at_zero = "symbol")(x),
      c("\u22121", "\u00b10", "1")
    )
    expect_equal(
      signs_format(.1, scale = .1, trim_leading_zeros = TRUE)(x),
      c("\u2212.1", ".0", ".1")
    )
  }
)

test_that(
  "errors work",
  {
    expect_error(
      signs_format(format = "goobers")(x),
      cat(
        "`format` should be a function that returns a character vector,",
        "such as `scales::number` or even `as.character`.",
        "Consider setting a default with",
        "`options(signs.format = your_function)`."
      )
    )
    expect_error(
      signs_format(format = exp)(x),
      cat(
        "`format` should be a function that returns a character vector,",
        "such as `scales::number` or even `as.character`.",
        "Consider setting a default with",
        "`options(signs.format = your_function)`."
      )
    )
    expect_error(
      signs_format(add_plusses = "TRUE")(x),
      "`add_plusses` should be a logical vector of length 1."
    )
    expect_error(
      signs_format(add_plusses = c(TRUE, FALSE))(x),
      "`add_plusses` should be a logical vector of length 1."
    )
    expect_error(
      signs_format(trim_leading_zeros = "TRUE")(x),
      "`trim_leading_zeros` should be a logical vector of length 1."
    )
    expect_error(
      signs_format(trim_leading_zeros = c(TRUE, FALSE))(x),
      "`trim_leading_zeros` should be a logical vector of length 1."
    )
    expect_error(
      signs_format(label_at_zero = TRUE)(x),
      "`label_at_zero` should be either 'none', 'blank', or 'symbol'."
    )
    expect_error(
      signs_format(label_at_zero = c("none", "blank"))(x),
      "`label_at_zero` should be either 'none', 'blank', or 'symbol'."
    )
    expect_error(
      signs_format(label_at_zero = "goober")(x),
      "`label_at_zero` should be either 'none', 'blank', or 'symbol'."
    )
  }
)

test_that(
  "formatted as zero counts as zero",
  {
    expect_equal(
      signs_format(1, scale = .1, label_at_zero = "none")(x),
      c("0", "0", "0")
    )
    expect_equal(
      signs_format(1, scale = .1, label_at_zero = "blank")(x),
      c("", "", "")
    )
    expect_equal(
      signs_format(1, scale = .1, label_at_zero = "symbol")(x),
      c("\u00b10", "\u00b10", "\u00b10")
    )
  }
)

test_that(
  "scientific notation works",
  {
    expect_equal(
      signs_format(1, scale = 1e-3, format = scales::scientific)(x),
      c("\u22121e\u221203", "0e+00", "1e\u221203")
    )
    expect_equal(
      signs_format(
        accuracy    = 1,
        scale       = 1e+3,
        format      = scales::scientific,
        add_plusses = TRUE
      )(x),
      c("\u22121e+03", "0e+00", "+1e+03")
    )
  }
)

test_that(
  "janky scientific notation works",
  {
    expect_equal(
      signs_format(1, suffix = "e+03", label_at_zero = "none")(x),
      c("\u22121e+03", "0e+03", "1e+03")
    )
    expect_equal(
      signs_format(1, suffix = "e+03", label_at_zero = "blank")(x),
      c("\u22121e+03", "", "1e+03")
    )
    expect_equal(
      signs_format(1, suffix = "e+03", label_at_zero = "symbol")(x),
      c("\u22121e+03", "\u00b10e+03", "1e+03")
    )
  }
)
