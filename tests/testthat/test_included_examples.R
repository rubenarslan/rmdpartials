context("Test simple")

setup_files <- function() {
  test_dir <- tempfile("test_rmdpartials")
  stopifnot(dir.create(test_dir))
  setwd(test_dir)
  test_dir <- getwd() # dumb trick to get a proper path without double slashes

  test_dir
}

test_that("enlarge_plot", {
  test_dir <- setup_files()
  on.exit({
    unlink(test_dir, recursive = TRUE)
  })

  expect_silent(md <- knitr::knit(text = "
test0
```{r}
enlarge_plot('1', '100')
```
", quiet = TRUE))

  expect_match(md, "trigger modal", fixed = TRUE)
  expect_match(md, "100", fixed = TRUE)
})

test_that("knit_child_debug", {
  test_dir <- setup_files()
  on.exit({
    unlink(test_dir, recursive = TRUE)
  })

  expect_silent(md <- knitr::knit(text = "
test0
```{r}
knit_child_debug()
```
", quiet = TRUE))

  expect_match(md, "getOption", fixed = TRUE)
})

test_that("regression_diagnostics", {
  test_dir <- setup_files()
  on.exit({
    unlink(test_dir, recursive = TRUE)
  })



  expect_silent(md <- knitr::knit(text = "
test0
```{r}
set.seed(1)
x <- rnorm(100)
y <- x + rnorm(100) + 0.5 * x^2
reg <- lm(y ~ x)
regression_diagnostics(reg)
```
", quiet = TRUE))

  expect_match(md, "figure/", fixed = TRUE)
  expect_match(md, "Values vs. fitted", fixed = TRUE)
})

