# Rmarkdown partial example

## Introduction

For example, you can make enlarge-able plots:

### Graphical relationship

``` r
library(rmdpartials)
library(ggplot2)
x <- rnorm(100)
y <- x + rnorm(100) + 0.5 * x^2
curve <- ggplot(mapping = aes(x, y)) + geom_point()
enlarge_plot(curve, large_plot = curve + theme_classic(base_size = 20), plot_name = "myplot")
```

[![](rmdpartials_files/figure-html/myplot_rmdpartial-8-1.png)](#myplot)

![](rmdpartials_files/figure-html/myplot_rmdpartial-9-1.png)

Close

### Regression

``` r
reg <- lm(y ~ x)
regression_diagnostics(reg)
```

|             |         x |
|:------------|----------:|
| (Intercept) | 0.3592409 |
| x           | 1.0755503 |

Values vs. fitted values.

![](rmdpartials_files/figure-html/ff8fb0855e_rmdpartial-16-1.png)

Diagnostics (click to show)

![](rmdpartials_files/figure-html/ff8fb0855e_rmdpartial-17-1.png)![](rmdpartials_files/figure-html/ff8fb0855e_rmdpartial-17-2.png)![](rmdpartials_files/figure-html/ff8fb0855e_rmdpartial-17-3.png)![](rmdpartials_files/figure-html/ff8fb0855e_rmdpartial-17-4.png)

### Write a partial on the fly

``` r
x <- 5
y <- 9
partial(text = "`r x` `r y`")
```

5 9

### Debug

Learn about environments in partials.

``` r
knit_child_debug()
```

Debug

Working directory

    ## [1] "/home/runner/work/rmdpartials/rmdpartials/vignettes"

needs_preview()

    ## [1] FALSE

is_interactive()

    ## [1] FALSE

Knitr Output.dir

    ## [1] "/home/runner/work/rmdpartials/rmdpartials/vignettes"

Child mode

    ## [1] TRUE

Viewer null

    ## [1] TRUE

In tmp dir

    ## [1] FALSE

knitr.in.progress

    ## [1] TRUE

rstudio.notebook.executing

    ## NULL

TESTTHAT_interactive

    ## [1] ""

TESTTHAT

    ## [1] ""

interactive

    ## [1] FALSE

objects in this environment

    ## [1] "is_interactive" "needs_preview"

knitr::opts_knit

    ## $progress
    ## [1] FALSE
    ## 
    ## $verbose
    ## [1] FALSE
    ## 
    ## $eval.after
    ## [1] "fig.cap"  "fig.scap" "fig.alt" 
    ## 
    ## $base.dir
    ## NULL
    ## 
    ## $base.url
    ## NULL
    ## 
    ## $root.dir
    ## NULL
    ## 
    ## $child.path
    ## [1] ""
    ## 
    ## $upload.fun
    ## function (x) 
    ## x
    ## <bytecode: 0x55dd33b4d5b0>
    ## <environment: namespace:base>
    ## 
    ## $global.device
    ## [1] FALSE
    ## 
    ## $global.par
    ## [1] FALSE
    ## 
    ## $concordance
    ## [1] FALSE
    ## 
    ## $documentation
    ## [1] 1
    ## 
    ## $self.contained
    ## [1] TRUE
    ## 
    ## $unnamed.chunk.label
    ## [1] "rmdpartial"
    ## 
    ## $highr.opts
    ## NULL
    ## 
    ## $label.prefix
    ##  table 
    ## "tab:" 
    ## 
    ## $latex.tilde
    ## NULL
    ## 
    ## $out.format
    ## [1] "markdown"
    ## 
    ## $child
    ## [1] TRUE
    ## 
    ## $parent
    ## [1] FALSE
    ## 
    ## $tangle
    ## [1] FALSE
    ## 
    ## $aliases
    ## NULL
    ## 
    ## $header
    ## highlight      tikz    framed 
    ##        ""        ""        "" 
    ## 
    ## $global.pars
    ## NULL
    ## 
    ## $rmarkdown.pandoc.from
    ## [1] "markdown+autolink_bare_uris+tex_math_single_backslash"
    ## 
    ## $rmarkdown.pandoc.to
    ## [1] "html"
    ## 
    ## $rmarkdown.pandoc.args
    ## [1] "--standalone"                                          
    ## [2] "--section-divs"                                        
    ## [3] "--template"                                            
    ## [4] "/tmp/RtmpTX0VhV/pkgdown-rmd-template-1b7c2f25d2e8.html"
    ## [5] "--highlight-style"                                     
    ## [6] "pygments"                                              
    ## 
    ## $rmarkdown.pandoc.id_prefix
    ## [1] ""
    ## 
    ## $rmarkdown.keep_md
    ## [1] FALSE
    ## 
    ## $rmarkdown.df_print
    ## [1] "default"
    ## 
    ## $rmarkdown.version
    ## [1] 2
    ## 
    ## $rmarkdown.runtime
    ## [1] "static"
    ## 
    ## $output.dir
    ## [1] "/home/runner/work/rmdpartials/rmdpartials/vignettes"

knitr::opts_chunk

    ## $eval
    ## [1] TRUE
    ## 
    ## $echo
    ## [1] FALSE
    ## 
    ## $results
    ## [1] "markup"
    ## 
    ## $tidy
    ## [1] FALSE
    ## 
    ## $tidy.opts
    ## NULL
    ## 
    ## $collapse
    ## [1] FALSE
    ## 
    ## $prompt
    ## [1] FALSE
    ## 
    ## $comment
    ## [1] "##"
    ## 
    ## $highlight
    ## [1] TRUE
    ## 
    ## $size
    ## [1] "normalsize"
    ## 
    ## $background
    ## [1] "#F7F7F7"
    ## 
    ## $strip.white
    ## [1] TRUE
    ## 
    ## $cache
    ## [1] FALSE
    ## 
    ## $cache.path
    ## [1] "rmdpartials_cache/html/f080a7cff6_"
    ## 
    ## $cache.vars
    ## NULL
    ## 
    ## $cache.lazy
    ## [1] TRUE
    ## 
    ## $dependson
    ## NULL
    ## 
    ## $autodep
    ## [1] FALSE
    ## 
    ## $cache.rebuild
    ## [1] FALSE
    ## 
    ## $fig.keep
    ## [1] "high"
    ## 
    ## $fig.show
    ## [1] "asis"
    ## 
    ## $fig.align
    ## [1] "default"
    ## 
    ## $fig.path
    ## [1] "/home/runner/work/rmdpartials/rmdpartials/docs/articles/rmdpartials_files/figure-html/f080a7cff6_"
    ## 
    ## $dev
    ## [1] "ragg_png"
    ## 
    ## $dev.args
    ## $dev.args$bg
    ## [1] NA
    ## 
    ## 
    ## $dpi
    ## [1] 96
    ## 
    ## $fig.ext
    ## [1] "png"
    ## 
    ## $fig.width
    ## [1] 7.291667
    ## 
    ## $fig.height
    ## [1] 4.506593
    ## 
    ## $fig.env
    ## [1] "figure"
    ## 
    ## $fig.cap
    ## NULL
    ## 
    ## $fig.scap
    ## NULL
    ## 
    ## $fig.lp
    ## [1] "fig:"
    ## 
    ## $fig.subcap
    ## NULL
    ## 
    ## $fig.pos
    ## [1] ""
    ## 
    ## $out.width
    ## NULL
    ## 
    ## $out.height
    ## NULL
    ## 
    ## $out.extra
    ## NULL
    ## 
    ## $fig.retina
    ## [1] 2
    ## 
    ## $external
    ## [1] TRUE
    ## 
    ## $sanitize
    ## [1] FALSE
    ## 
    ## $interval
    ## [1] 1
    ## 
    ## $aniopts
    ## [1] "controls,loop"
    ## 
    ## $warning
    ## [1] TRUE
    ## 
    ## $error
    ## [1] FALSE
    ## 
    ## $message
    ## [1] TRUE
    ## 
    ## $render
    ## NULL
    ## 
    ## $ref.label
    ## NULL
    ## 
    ## $child
    ## NULL
    ## 
    ## $engine
    ## [1] "R"
    ## 
    ## $split
    ## [1] FALSE
    ## 
    ## $include
    ## [1] TRUE
    ## 
    ## $purl
    ## [1] TRUE
    ## 
    ## $other.parameters
    ## list()
    ## 
    ## $fig.class
    ## [1] "r-plt"

Sys.getenv()

    ## _R_CHECK_SYSTEM_CLOCK_
    ##                         FALSE
    ## ACCEPT_EULA             Y
    ## ACTIONS_ORCHESTRATION_ID
    ##                         faafd298-4e94-4dfe-b41a-8f69a463bcbb.pkgdown.__default
    ## ACTIONS_RUNNER_ACTION_ARCHIVE_CACHE
    ##                         /opt/actionarchivecache
    ## AGENT_TOOLSDIRECTORY    /opt/hostedtoolcache
    ## ANDROID_HOME            /usr/local/lib/android/sdk
    ## ANDROID_NDK             /usr/local/lib/android/sdk/ndk/27.3.13750724
    ## ANDROID_NDK_HOME        /usr/local/lib/android/sdk/ndk/27.3.13750724
    ## ANDROID_NDK_LATEST_HOME
    ##                         /usr/local/lib/android/sdk/ndk/29.0.14206865
    ## ANDROID_NDK_ROOT        /usr/local/lib/android/sdk/ndk/27.3.13750724
    ## ANDROID_SDK_ROOT        /usr/local/lib/android/sdk
    ## ANT_HOME                /usr/share/ant
    ## AZURE_EXTENSION_DIR     /opt/az/azcliextensions
    ## BIBINPUTS               ::/home/runner/work/rmdpartials/rmdpartials/vignettes:/opt/R/4.5.2/lib/R/share/texmf/tex/latex
    ## BOOTSTRAP_HASKELL_NONINTERACTIVE
    ##                         1
    ## BSTINPUTS               :/home/runner/work/rmdpartials/rmdpartials/vignettes:/opt/R/4.5.2/lib/R/share/texmf/bibtex/bst
    ## CALLR_IS_RUNNING        true
    ## CHROME_BIN              /usr/bin/google-chrome
    ## CHROMEWEBDRIVER         /usr/local/share/chromedriver-linux64
    ## CI                      true
    ## CONDA                   /usr/share/miniconda
    ## CYGWIN                  nodosfilewarning
    ## DEBIAN_FRONTEND         noninteractive
    ## DOTNET_MULTILEVEL_LOOKUP
    ##                         0
    ## DOTNET_NOLOGO           1
    ## DOTNET_SKIP_FIRST_TIME_EXPERIENCE
    ##                         1
    ## EDGEWEBDRIVER           /usr/local/share/edge_driver
    ## EDITOR                  vi
    ## ENABLE_RUNNER_TRACING   true
    ## GECKOWEBDRIVER          /usr/local/share/gecko_driver
    ## GHCUP_INSTALL_BASE_PREFIX
    ##                         /usr/local
    ## GITHUB_ACTION           __run
    ## GITHUB_ACTION_REF       
    ## GITHUB_ACTION_REPOSITORY
    ##                         
    ## GITHUB_ACTIONS          true
    ## GITHUB_ACTOR            rubenarslan
    ## GITHUB_ACTOR_ID         831109
    ## GITHUB_API_URL          https://api.github.com
    ## GITHUB_BASE_REF         
    ## GITHUB_ENV              /home/runner/work/_temp/_runner_file_commands/set_env_06a42f11-c69a-422f-983d-4770095088e5
    ## GITHUB_EVENT_NAME       push
    ## GITHUB_EVENT_PATH       /home/runner/work/_temp/_github_workflow/event.json
    ## GITHUB_GRAPHQL_URL      https://api.github.com/graphql
    ## GITHUB_HEAD_REF         
    ## GITHUB_JOB              pkgdown
    ## GITHUB_OUTPUT           /home/runner/work/_temp/_runner_file_commands/set_output_06a42f11-c69a-422f-983d-4770095088e5
    ## GITHUB_PAT              ghs_DAkWVTymJoaw91Mt7CCWAy1J02cjLo1ij6qZ
    ## GITHUB_PATH             /home/runner/work/_temp/_runner_file_commands/add_path_06a42f11-c69a-422f-983d-4770095088e5
    ## GITHUB_REF              refs/heads/master
    ## GITHUB_REF_NAME         master
    ## GITHUB_REF_PROTECTED    false
    ## GITHUB_REF_TYPE         branch
    ## GITHUB_REPOSITORY       rubenarslan/rmdpartials
    ## GITHUB_REPOSITORY_ID    184552845
    ## GITHUB_REPOSITORY_OWNER
    ##                         rubenarslan
    ## GITHUB_REPOSITORY_OWNER_ID
    ##                         831109
    ## GITHUB_RETENTION_DAYS   90
    ## GITHUB_RUN_ATTEMPT      1
    ## GITHUB_RUN_ID           22280250307
    ## GITHUB_RUN_NUMBER       3
    ## GITHUB_SERVER_URL       https://github.com
    ## GITHUB_SHA              52b0964642413cd94b9ac9933e7dbda4d8a26895
    ## GITHUB_STATE            /home/runner/work/_temp/_runner_file_commands/save_state_06a42f11-c69a-422f-983d-4770095088e5
    ## GITHUB_STEP_SUMMARY     /home/runner/work/_temp/_runner_file_commands/step_summary_06a42f11-c69a-422f-983d-4770095088e5
    ## GITHUB_TRIGGERING_ACTOR
    ##                         rubenarslan
    ## GITHUB_WORKFLOW         pkgdown.yaml
    ## GITHUB_WORKFLOW_REF     rubenarslan/rmdpartials/.github/workflows/pkgdown.yaml@refs/heads/master
    ## GITHUB_WORKFLOW_SHA     52b0964642413cd94b9ac9933e7dbda4d8a26895
    ## GITHUB_WORKSPACE        /home/runner/work/rmdpartials/rmdpartials
    ## GOROOT_1_22_X64         /opt/hostedtoolcache/go/1.22.12/x64
    ## GOROOT_1_23_X64         /opt/hostedtoolcache/go/1.23.12/x64
    ## GOROOT_1_24_X64         /opt/hostedtoolcache/go/1.24.12/x64
    ## GOROOT_1_25_X64         /opt/hostedtoolcache/go/1.25.6/x64
    ## GRADLE_HOME             /usr/share/gradle-9.3.1
    ## HOME                    /home/runner
    ## HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS
    ##                         3650
    ## HOMEBREW_NO_AUTO_UPDATE
    ##                         1
    ## ImageOS                 ubuntu24
    ## ImageVersion            20260201.15.1
    ## IN_PKGDOWN              true
    ## INVOCATION_ID           b525421406174fac8cd8f6f809f3ff57
    ## JAVA_HOME               /usr/lib/jvm/temurin-17-jdk-amd64
    ## JAVA_HOME_11_X64        /usr/lib/jvm/temurin-11-jdk-amd64
    ## JAVA_HOME_17_X64        /usr/lib/jvm/temurin-17-jdk-amd64
    ## JAVA_HOME_21_X64        /usr/lib/jvm/temurin-21-jdk-amd64
    ## JAVA_HOME_25_X64        /usr/lib/jvm/temurin-25-jdk-amd64
    ## JAVA_HOME_8_X64         /usr/lib/jvm/temurin-8-jdk-amd64
    ## JOURNAL_STREAM          9:10212
    ## LANG                    C.UTF-8
    ## LANGUAGE                en-GB
    ## LD_LIBRARY_PATH         /opt/R/4.5.2/lib/R/lib:/usr/local/lib:/usr/lib/x86_64-linux-gnu:/usr/lib/jvm/temurin-17-jdk-amd64/lib/server:/opt/R/4.5.2/lib/R/lib:/usr/local/lib:/usr/lib/x86_64-linux-gnu:/usr/lib/jvm/temurin-17-jdk-amd64/lib/server
    ## LN_S                    ln -s
    ## LOGNAME                 runner
    ## MAKE                    make
    ## MEMORY_PRESSURE_WATCH   /sys/fs/cgroup/system.slice/hosted-compute-agent.service/memory.pressure
    ## MEMORY_PRESSURE_WRITE   c29tZSAyMDAwMDAgMjAwMDAwMAA=
    ## NOT_CRAN                true
    ## NVM_DIR                 /home/runner/.nvm
    ## PAGER                   /usr/bin/pager
    ## PATH                    /opt/hostedtoolcache/pandoc/3.1.11/x64:/snap/bin:/home/runner/.local/bin:/opt/pipx_bin:/home/runner/.cargo/bin:/home/runner/.config/composer/vendor/bin:/usr/local/.ghcup/bin:/home/runner/.dotnet/tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
    ## PIPX_BIN_DIR            /opt/pipx_bin
    ## PIPX_HOME               /opt/pipx
    ## PKGCACHE_HTTP_VERSION   2
    ## POWERSHELL_DISTRIBUTION_CHANNEL
    ##                         GitHub-Actions-ubuntu24
    ## PROCESSX_PS1b7c532f1c86_1771775349
    ##                         YES
    ## PSModulePath            /root/.local/share/powershell/Modules:/usr/local/share/powershell/Modules:/opt/microsoft/powershell/7/Modules:/usr/share/az_14.6.0
    ## PWD                     /home/runner/work/rmdpartials/rmdpartials
    ## R_ARCH                  
    ## R_BROWSER               false
    ## R_BZIPCMD               /usr/bin/bzip2
    ## R_CLI_NUM_COLORS        256
    ## R_DOC_DIR               /opt/R/4.5.2/lib/R/doc
    ## R_GZIPCMD               /usr/bin/gzip
    ## R_HOME                  /opt/R/4.5.2/lib/R
    ## R_INCLUDE_DIR           /opt/R/4.5.2/lib/R/include
    ## R_LIB_FOR_PAK           /opt/R/4.5.2/lib/R/site-library
    ## R_LIBS_SITE             /opt/R/4.5.2/lib/R/site-library
    ## R_LIBS_USER             /home/runner/work/_temp/Library
    ## R_PAPERSIZE             letter
    ## R_PAPERSIZE_USER        letter
    ## R_PDFVIEWER             false
    ## R_PLATFORM              x86_64-pc-linux-gnu
    ## R_PRINTCMD              /usr/bin/lpr
    ## R_RD4PDF                times,inconsolata,hyper
    ## R_SESSION_TMPDIR        /tmp/RtmpTnB4lL
    ## R_SHARE_DIR             /opt/R/4.5.2/lib/R/share
    ## R_STRIP_SHARED_LIB      strip --strip-unneeded
    ## R_STRIP_STATIC_LIB      strip --strip-debug
    ## R_TESTS                 
    ## R_TEXI2DVICMD           /usr/bin/texi2dvi
    ## R_UNZIPCMD              /usr/bin/unzip
    ## R_ZIPCMD                /usr/bin/zip
    ## RENV_CONFIG_REPOS_OVERRIDE
    ##                         https://packagemanager.posit.co/cran/__linux__/noble/latest
    ## RSPM                    https://packagemanager.posit.co/cran/__linux__/noble/latest
    ## RUNNER_ARCH             X64
    ## RUNNER_ENVIRONMENT      github-hosted
    ## RUNNER_NAME             GitHub Actions 1000000365
    ## RUNNER_OS               Linux
    ## RUNNER_TEMP             /home/runner/work/_temp
    ## RUNNER_TOOL_CACHE       /opt/hostedtoolcache
    ## RUNNER_TRACKING_ID      github_12761bdd-9b35-4242-8178-1397f6f16585
    ## RUNNER_WORKSPACE        /home/runner/work/rmdpartials
    ## SED                     /usr/bin/sed
    ## SELENIUM_JAR_PATH       /usr/share/java/selenium-server.jar
    ## SGX_AESM_ADDR           1
    ## SHELL                   /bin/bash
    ## SHLVL                   0
    ## SWIFT_PATH              /usr/share/swift/usr/bin
    ## SYSTEMD_EXEC_PID        2023
    ## TAR                     /usr/bin/tar
    ## TEXINPUTS               :/home/runner/work/rmdpartials/rmdpartials/vignettes:/opt/R/4.5.2/lib/R/share/texmf/tex/latex
    ## TZ                      UTC
    ## USE_BAZEL_FALLBACK_VERSION
    ##                         silent:
    ## USER                    runner
    ## VCPKG_INSTALLATION_ROOT
    ##                         /usr/local/share/vcpkg
    ## XDG_CONFIG_HOME         /home/runner/.config
    ## XDG_RUNTIME_DIR         /run/user/1001

options()

    ## $add.smooth
    ## [1] TRUE
    ## 
    ## $bitmapType
    ## [1] "cairo"
    ## 
    ## $browser
    ## [1] "false"
    ## 
    ## $browserNLdisabled
    ## [1] FALSE
    ## 
    ## $callr.condition_handler_cli_message
    ## function (msg) 
    ## {
    ##     custom_handler <- getOption("cli.default_handler")
    ##     if (is.function(custom_handler)) {
    ##         custom_handler(msg)
    ##     }
    ##     else {
    ##         cli_server_default(msg)
    ##     }
    ## }
    ## <bytecode: 0x55dd34806f50>
    ## <environment: namespace:cli>
    ## 
    ## $callr.rprofile_loaded
    ## [1] TRUE
    ## 
    ## $catch.script.errors
    ## [1] FALSE
    ## 
    ## $CBoundsCheck
    ## [1] FALSE
    ## 
    ## $check.bounds
    ## [1] FALSE
    ## 
    ## $citation.bibtex.max
    ## [1] 1
    ## 
    ## $continue
    ## [1] "+ "
    ## 
    ## $contrasts
    ##         unordered           ordered 
    ## "contr.treatment"      "contr.poly" 
    ## 
    ## $defaultPackages
    ## [1] "datasets"  "utils"     "grDevices" "graphics"  "stats"     "methods"  
    ## 
    ## $demo.ask
    ## [1] "default"
    ## 
    ## $deparse.cutoff
    ## [1] 60
    ## 
    ## $device
    ## function (width = 7, height = 7, ...) 
    ## {
    ##     grDevices::pdf(NULL, width, height, ...)
    ## }
    ## <bytecode: 0x55dd33bc9bb8>
    ## <environment: namespace:knitr>
    ## 
    ## $device.ask.default
    ## [1] FALSE
    ## 
    ## $digits
    ## [1] 7
    ## 
    ## $dvipscmd
    ## [1] "dvips"
    ## 
    ## $echo
    ## [1] FALSE
    ## 
    ## $editor
    ## [1] "vi"
    ## 
    ## $encoding
    ## [1] "native.enc"
    ## 
    ## $error
    ## (function () 
    ## invokeRestart("abort"))()
    ## 
    ## $example.ask
    ## [1] "default"
    ## 
    ## $expressions
    ## [1] 5000
    ## 
    ## $help.search.types
    ## [1] "vignette" "demo"     "help"    
    ## 
    ## $help.try.all.packages
    ## [1] FALSE
    ## 
    ## $htmltools.preserve.raw
    ## [1] TRUE
    ## 
    ## $HTTPUserAgent
    ## [1] "R/4.5.2 (ubuntu-24.04) R (4.5.2 x86_64-pc-linux-gnu x86_64 linux-gnu)"
    ## 
    ## $internet.info
    ## [1] 2
    ## 
    ## $keep.parse.data
    ## [1] TRUE
    ## 
    ## $keep.parse.data.pkgs
    ## [1] FALSE
    ## 
    ## $keep.source
    ## [1] FALSE
    ## 
    ## $keep.source.pkgs
    ## [1] FALSE
    ## 
    ## $knitr.duplicate.label
    ## [1] "allow"
    ## 
    ## $knitr.graphics.rel_path
    ## [1] FALSE
    ## 
    ## $knitr.in.progress
    ## [1] TRUE
    ## 
    ## $locatorBell
    ## [1] TRUE
    ## 
    ## $mailer
    ## [1] "mailto"
    ## 
    ## $matprod
    ## [1] "default"
    ## 
    ## $max.contour.segments
    ## [1] 25000
    ## 
    ## $max.print
    ## [1] 99999
    ## 
    ## $menu.graphics
    ## [1] TRUE
    ## 
    ## $na.action
    ## [1] "na.omit"
    ## 
    ## $nwarnings
    ## [1] 50
    ## 
    ## $OutDec
    ## [1] "."
    ## 
    ## $pager
    ## [1] "/opt/R/4.5.2/lib/R/bin/pager"
    ## 
    ## $papersize
    ## [1] "letter"
    ## 
    ## $PCRE_limit_recursion
    ## [1] NA
    ## 
    ## $PCRE_study
    ## [1] FALSE
    ## 
    ## $PCRE_use_JIT
    ## [1] TRUE
    ## 
    ## $pdfviewer
    ## [1] "false"
    ## 
    ## $pkgType
    ## [1] "source"
    ## 
    ## $printcmd
    ## [1] "/usr/bin/lpr"
    ## 
    ## $prompt
    ## [1] "> "
    ## 
    ## $repos
    ##                                                          RSPM 
    ## "https://packagemanager.posit.co/cran/__linux__/noble/latest" 
    ##                                                          CRAN 
    ##                                    "https://cran.rstudio.com" 
    ## 
    ## $rl_word_breaks
    ## [1] " \t\n\"\\'`><=%;,|&{()}"
    ## 
    ## $rlang_trace_top_env
    ## <environment: 0x55dd3d008290>
    ## 
    ## $scipen
    ## [1] 0
    ## 
    ## $show.coef.Pvalues
    ## [1] TRUE
    ## 
    ## $show.error.messages
    ## [1] TRUE
    ## 
    ## $show.signif.stars
    ## [1] TRUE
    ## 
    ## $showErrorCalls
    ## [1] TRUE
    ## 
    ## $showNCalls
    ## [1] 50
    ## 
    ## $showWarnCalls
    ## [1] FALSE
    ## 
    ## $str
    ## $str$strict.width
    ## [1] "no"
    ## 
    ## $str$digits.d
    ## [1] 3
    ## 
    ## $str$vec.len
    ## [1] 4
    ## 
    ## $str$list.len
    ## [1] 99
    ## 
    ## $str$deparse.lines
    ## NULL
    ## 
    ## $str$drop.deparse.attr
    ## [1] TRUE
    ## 
    ## $str$formatNum
    ## function (x, ...) 
    ## format(x, trim = TRUE, drop0trailing = TRUE, ...)
    ## <environment: 0x55dd3205bd98>
    ## 
    ## 
    ## $str.dendrogram.last
    ## [1] "`"
    ## 
    ## $texi2dvi
    ## [1] "/usr/bin/texi2dvi"
    ## 
    ## $tikzMetricsDictionary
    ## [1] "rmdpartials-tikzDictionary"
    ## 
    ## $timeout
    ## [1] 60
    ## 
    ## $try.outFile
    ## A connection with                    
    ## description ""      
    ## class       "file"  
    ## mode        "w+b"   
    ## text        "binary"
    ## opened      "opened"
    ## can read    "yes"   
    ## can write   "yes"   
    ## 
    ## $ts.eps
    ## [1] 1e-05
    ## 
    ## $ts.S.compat
    ## [1] FALSE
    ## 
    ## $unzip
    ## [1] "/usr/bin/unzip"
    ## 
    ## $useFancyQuotes
    ## [1] FALSE
    ## 
    ## $verbose
    ## [1] FALSE
    ## 
    ## $warn
    ## [1] 0
    ## 
    ## $warning.length
    ## [1] 1000
    ## 
    ## $warnPartialMatchArgs
    ## [1] FALSE
    ## 
    ## $warnPartialMatchAttr
    ## [1] FALSE
    ## 
    ## $warnPartialMatchDollar
    ## [1] FALSE
    ## 
    ## $width
    ## [1] 80
