
# Avoiding Loops

An introductory tutotrial on possible means to avoid loops altogether in
**R**

This tutorial introduces you some exciting alternatives to classic loops
in R. While classic `for()` and `while()` loops are quite faster now in
**R**, they still suffer considerable time lag when compared to loop
structures in other high end languages (**C++** for example). They
actually happen to most of the time not be the best option when tasks
are to be repeated on large datasets. This is due to no fault of their
own but the fact that **R** isn’t a vectorized language. The tutorial
adopts a hands-on approach to demonstrate the offerings made available
via existing functions (**apply**, **sapply()**, **lapply()**,
**tapply()** and **mclapply**) and packages (**purrr**, **repurrrsive**
and **futures**). The tutorial ends with an introduction to parallel
programming and some packages that can help achieve this essential
modern day computing technique in **R**.

## Installation of Nedded Packages

``` r
#install.packages(tidyverse)
#install.packages(repurrsive)
```

## R Session Info

``` r
sessionInfo()
#> R version 3.5.1 (2018-07-02)
#> Platform: x86_64-w64-mingw32/x64 (64-bit)
#> Running under: Windows 10 x64 (build 17134)
#> 
#> Matrix products: default
#> 
#> locale:
#> [1] LC_COLLATE=English_United Kingdom.1252 
#> [2] LC_CTYPE=English_United Kingdom.1252   
#> [3] LC_MONETARY=English_United Kingdom.1252
#> [4] LC_NUMERIC=C                           
#> [5] LC_TIME=English_United Kingdom.1252    
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> loaded via a namespace (and not attached):
#>  [1] compiler_3.5.1  magrittr_1.5    tools_3.5.1     htmltools_0.3.6
#>  [5] yaml_2.2.0      Rcpp_1.0.0      stringi_1.2.4   rmarkdown_1.11 
#>  [9] knitr_1.21      stringr_1.3.1   xfun_0.4        digest_0.6.18  
#> [13] evaluate_0.12
```

## Useful links

<https://github.com/jennybc/repurrrsive>

<https://purrr.tidyverse.org/>
