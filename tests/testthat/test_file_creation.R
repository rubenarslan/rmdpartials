context("Test file creation")

knitr::opts_chunk$set(error = FALSE)

test_that("Partial to file", {
  test_dir <- tempfile("partial_file")
  dir.create(test_dir)
  setwd(test_dir)
  cat(
    "
1

```{r}
plot(1:100)
```
", file = "oneplot.Rmd")
  template <- file.path(getwd(), "oneplot.Rmd")

  output_dir <- tempfile("partial_output")
  dir.create(output_dir)
  setwd(output_dir)

  files <- partial(template, output = "myplot.html")
  output.dir <- attributes(files)$knit_meta$output.dir
  list.files(output.dir)
  files <- c("index_files", "myplot.html")
  list.files(output_dir)
  expect_equal(files, list.files(output_dir))

})


test_that("No file, but figure", {
  test_dir <- tempfile("partial_file")
  dir.create(test_dir)
  setwd(test_dir)
  cat(
    "
1

```{r}
plot(1:100)
```
", file = "oneplot.Rmd")
  template <- file.path(getwd(), "oneplot.Rmd")

  partial_result <- partial(template)
  output.dir <- attributes(partial_result)$knit_meta$output.dir
  list.files(output.dir)

  files <- c("index_files", "index.html", "index.knit.md", "index.Rmd",
             "index.utf8.md")
  expect_equal(files, list.files(output_dir))
  expect_equal(1, length(list.files(
    file.path(output.dir, "index_files", "figure-html"))))

})