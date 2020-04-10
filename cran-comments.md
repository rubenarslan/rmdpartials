## Submission
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
