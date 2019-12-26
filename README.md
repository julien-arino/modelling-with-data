# Mathematical epidemiology in a data-rich world
Data and sources for the paper *Mathematical epidemiology in a data-rich world*, by J. Arino. Infectious Disease Modelling, 2019.

## To generate the pdf file
Here are a few remarks concerning the production of the PDF from the RMD file.

1. The option to tidy the code in the echoed chunks does not work properly. A workaround is to use a forked formatR function that can be found by issuing the following 2 `R` commands.
  ```
  library(devtools)
  install_github("pablo14/formatR")
  ```
(See details here: https://stackoverflow.com/questions/20778635/formatr-width-cutoff-issue)

2. The `elsarticle.cls` article class does not coexist well with the default Pandoc style used to create a PDF. There is probably a way to override the production of the title and related information, but until I work out the details, you can get the front matter to work properly by finding and deleting some code in the LaTeX file. I include an `R` script, `process_latex_file.R`, which does this.
