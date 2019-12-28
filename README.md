# Mathematical epidemiology in a data-rich world
This repository contains the data and sources for the paper *Mathematical epidemiology in a data-rich world*, by myself (J. Arino). This paper was published in Infectious Disease Modelling in 20xx.

### To generate the pdf file
Here are a few remarks concerning the production of the PDF from the RMD file.

1. The version here is slightly different from the article itself: I am not using the `elsarticle` class, just the standard `article` class. Later, I might put online the code needed to create the `elsarticle` version.
2. The option to tidy the code in the echoed chunks does not cut lines properly. A workaround is to use a forked formatR function that can be found by issuing the following 2 `R` commands. See details [here](https://stackoverflow.com/questions/20778635/formatr-width-cutoff-issue).
```
library(devtools)
install_github("pablo14/formatR")
```
3. The last chunk in the RMD file crops the figures before compilation. You might not need it. If you do need it and are using Windows, you will need to figure out how to install pdfcrop. (Hint: you will also have to install Perl.)
4. The file `download_and_save_variables.R` is an `R` script that .. downloads and saves variables. It puts in one single place all the downloads that are carried out in the paper and saves the result where the main RMD file gets them.
5. Beware of Wikipedia. If you run into issues when compiling the RMD file, that is most likely where your problem lies. As indicated in the text, Wikipedia editors tend to use tables for a bit everything on a page, which leads to frequent changes in the order in which tables appear in a page. If things break down because, for instance, the renaming of columns complains that the table has fewer columns than the names you are trying to assign, you might have to change the `which =` command to another value.
