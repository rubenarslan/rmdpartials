context("Test partials")

knitr::opts_chunk$set(error = FALSE)

test_that("Nesting documents", {
  wd <- getwd()
  test_dir <- tempfile("testing_rmdpartials")
  dir.create(test_dir)
  setwd(test_dir)
  on.exit({
    setwd(wd)
    unlink(test_dir, recursive = TRUE)
  })
  cat(
"
0
```{r}
partial('one.Rmd')
```
", file = "zero.Rmd")

  cat(
"
1
```{r}
partial('two.Rmd')
```
", file = "one.Rmd")

  cat(
    "
2
```{r}
partial('three.Rmd')
```
", file = "two.Rmd")

  cat(
    "
3
", file = "three.Rmd")

  text <- paste0(readLines("zero.Rmd"), collapse = "\n")

  expect_silent(md <- knitr::knit(text = text, quiet = TRUE))

  expect_match(md, "0")
  expect_match(md, "1")
  expect_match(md, "2")
  expect_match(md, "3")

  unlink(test_dir, recursive = TRUE)
})


test_that("Nesting with plots", {
  wd <- getwd()
  test_dir <- tempfile("testing_rmdpartials")
  dir.create(test_dir)
  setwd(test_dir)
  on.exit({
    setwd(wd)
    unlink(test_dir, recursive = TRUE)
  })
  cat(
    "
0
```{r}
plot(0)
partial('one.Rmd')
```
", file = "zero.Rmd")

  cat(
    "
1
```{r}
plot(1)
partial('two.Rmd')
```
", file = "one.Rmd")

  cat(
    "
2
```{r}
plot(2)
partial('three.Rmd')
```
", file = "two.Rmd")

  cat(
    "
3
```{r}
plot(3)
```
", file = "three.Rmd")

  text <- paste0(readLines("zero.Rmd"), collapse = "\n")

  expect_silent(md <- knitr::knit(text = text, quiet = TRUE))

  expect_match(md, "0")
  expect_match(md, "1")
  expect_match(md, "2")
  expect_match(md, "3")
  output.dir <- getwd()
  expect_equal(4, length(list.files(
    file.path(output.dir, "figure"))))

  expect_message(md <- rmarkdown::render("zero.Rmd"))
  list.files(dirname(md))

  expect_silent(md <- partial("zero.Rmd"))
  output.dir <- attributes(partial_result)$knit_meta$output.dir

  expect_match(md, "0")
  expect_match(md, "1")
  expect_match(md, "2")
  expect_match(md, "3")
  output.dir <- getwd()
  expect_equal(4, length(list.files(
    file.path(output.dir, "figure"))))

  unlink(test_dir, recursive = TRUE)
})
