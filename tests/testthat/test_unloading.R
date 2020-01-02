context("Unload cleanly")

knitr::opts_chunk$set(error = FALSE)

test_that("Clean unloading", {
  opts <- options()
  optc <- knitr::opts_chunk$get()
  optk <- knitr::opts_knit$get()

  wd <- getwd()
  files <- list.files(wd)

  test_dir <- tempfile("unloading_rmdpartials")
  dir.create(test_dir)
  setwd(test_dir)
  on.exit({
    setwd(wd)
    unlink(test_dir, recursive = TRUE)
  })
  cat(
    "
No.0
```{r}
partial('one.Rmd')
```
", file = "zero.Rmd")

  cat(
    "
No.1
```{r}
plot(1:10)
```
", file = "one.Rmd")

  text <- paste0(readLines("zero.Rmd"), collapse = "\n")

  set.seed(1)
  expect_silent(md <- knitr::knit(text = text, quiet = TRUE))

  expect_match(md, "No.0")
  expect_match(md, "No.1")
  expect_match(md, "figure/")
  expect_equal(3, length(list.files(test_dir)))

  expect_identical(opts, options())
  expect_identical(optc, knitr::opts_chunk$get())
  optk_new <- knitr::opts_knit$get()
  # this is set by knitr itself even without partials
  optk_new$output.dir <- NULL
  optk$output.dir <- NULL
  expect_identical(optk, optk_new)
  expect_identical(files, list.files(wd))
})
