# signs 0.1.2 (submitted 2020-01-15)

* Fixed issue where `signs_format` would not work if package was not loaded.

# signs 0.1.1 (released 2019-11-25)

* Fixed [issue #2](https://github.com/BenjaminWolfe/signs/issues/2);
  tests had assumed a default accuracy of 1,
  and [`scales 1.1.0`](https://github.com/r-lib/scales/issues/229)
  changed default to .1.
* In the unlikely event a user explicitly sets `format`, `add_plusses`,
  `trim_leading_zeros`, or `label_at_zero` to `NULL`, functions will now
  throw an error.
* Improved intro / summary language and updated hex logo with enlarged font.

# signs 0.1.0 (released 2019-10-01)

* `signs` is on CRAN!
