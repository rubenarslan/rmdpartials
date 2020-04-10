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

  expect_silent(files <- partial(template, output = "myplot.html",
                                 preview_output_format =
                                   rmarkdown::html_document(
                                     self_contained = FALSE))
                )
  output.dir <- attributes(files)$knit_meta$output.dir
  list.files(output.dir)
  # if making a partial from top level, switch to a new temp
  expect_error(expect_equal(output.dir, output_dir))

  files <- c("index_files", "myplot.html")
  list.files(output_dir)
  expect_equal(files, list.files(output_dir))

})


test_that("No file, but figure", {
  test_dir <- tempfile("partial_file")
  dir.create(test_dir)
  on.exit({
    unlink(test_dir, recursive = TRUE)
    Sys.unsetenv("TESTTHAT_interactive")
  })

  Sys.setenv(TESTTHAT_interactive = "true")

  setwd(test_dir)
  cat(
    "
1

```{r}
plot(1:100)
```
", file = "oneplot.Rmd")
  template <- file.path(getwd(), "oneplot.Rmd")

  expect_silent(partial_result <- partial(template,
                                          render_preview = TRUE,
                                          preview_output_format =
                                            rmarkdown::html_document(
                                              self_contained = FALSE))
  )
  output.dir <- attributes(partial_result)$knit_meta$output.dir
  # list.files(output.dir)
  # list.files(test_dir)
  # if making a partial from top level, switch to a new temp
  expect_error(expect_equal(output.dir, test_dir))

  files <- c("index_files", "index.html", "index.knit.md", "index.Rmd",
             "index.utf8.md")
  expect_equal("oneplot.Rmd", list.files(test_dir))
  expect_equal(files, list.files(output.dir))
  expect_equal(1, length(list.files(
    file.path(output.dir, "index_files", "figure-html"))))

})

