## Resubmission
* I added dontrun to two examples that make figures again. In interactive use, files are only generated in temporary directories, but I have been unable to figure out how to detect that the documentation is being checked (non-interactive, but also shouldn't make files). This is difficult here, because I cannot switch to a temporary directory, if the functions are run as child documents in a knit document.

## Last resubmission
* I added \value documentation for all functions.
* I added an example for `as.partial`
* The initial submission already called `on.exit` after any change to options or WD, now I always call `on.exit` immediately before changing something, as recommended. 
  I understand I should avoid changing the working directory and options for the user.
  I looked for ways to avoid changing options/WD for a long time and could not find any, because of how 'rmarkdown' 
  is implemented (it generates files in the working directory and it's not perfectly predictable that they will not 
  overwrite anything, and it cannot be made to render all files in a temporary directory without loss of function). 
  The same holds true for the options that I set. 
  In addition, I had already written extensive tests (tests/testthat/test_unloading.R) to ensure
  that all function calls unload cleanly (i.e., reset all options and working directory to their previous state, don't
  leave behind files in the working directory). I hope it's okay with CRAN with this additional explanation. Should
  there be a way to avoid setting the options and working directories as I do, I'd be glad to learn, but I found none.

## Old submission notes
* First release
* This is pretty much a re-implementation of knit_child with 
  - more reasonable defaults (work more often)
  - ability to preview rendered results in a viewer
* Currently very similar code is part of my codebook package, I want to factor it out

## Test environments
* local OS X install, R 3.5.2, 3.6.3
* win-builder (release)
* Rhub
  * Windows Server 2008 R2 SP1, R-devel, 32/64 bit

## R CMD check results

0 errors | 0 warnings | 1 notes

## Particularities
* This package implements rmarkdown partials, i.e. some of the functions are designed
  to render Rmd files as children of larger Rmd files. I put these files in
  the inst/ folder, their names start with _ (suggested convention in the
  rmarkdown documentation).
  I tried to make sure that these were still well-tested and they are part 
  of the testing run. 
