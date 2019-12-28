# Mathematical epidemiology in a data-rich world
This repository contains the data and sources for the paper *Mathematical epidemiology in a data-rich world*, by myself (J. Arino). This paper was published in Infectious Disease Modelling in 20xx.

### To generate the pdf file
Here are a few remarks concerning the production of the PDF from the RMD file. Please note that the version here is slightly different from the article itself: I am not using the `elsarticle.cls` class, just the standard `article.cls`.

1. The option to tidy the code in the echoed chunks does not cut lines properly. A workaround is to use a forked formatR function that can be found by issuing the following 2 `R` commands. See details [here](https://stackoverflow.com/questions/20778635/formatr-width-cutoff-issue).
```
library(devtools)
install_github("pablo14/formatR")
```
