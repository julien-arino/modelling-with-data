library(readr)
library(stringi)

pieces_to_cut = list()
pieces_to_cut[[1]] = list()
pieces_to_cut[[1]]$beg = "%%% Change title format to be more compact"
pieces_to_cut[[1]]$end = "\\predate{}\\postdate{}"
pieces_to_cut[[2]] = list()
pieces_to_cut[[2]]$beg = "\\hypertarget{references}{%"
pieces_to_cut[[2]]$end = "\n\\end{document}"


myLaTeXFile <- read_file("~/Documents/Publications/ModellingInDataRichWorld/Submission/ModellingInADataRichWorld_elsart.tex")

for (i in 1:length(pieces_to_cut)) {
  pieces_to_cut[[i]]$beg_cut = 
    stri_locate_all_fixed(myLaTeXFile,pieces_to_cut[[i]]$beg)[[1]]
  pieces_to_cut[[i]]$end_cut = 
    stri_locate_all_fixed(myLaTeXFile,pieces_to_cut[[i]]$end)[[1]]
}

myNewLaTeXFile <- stri_join(substr(myLaTeXFile,
                                   1,
                                   pieces_to_cut[[1]]$beg_cut[1]),
                            substr(myLaTeXFile,
                                   pieces_to_cut[[1]]$end_cut[2],
                                   pieces_to_cut[[2]]$beg_cut[1]),
                            substr(myLaTeXFile,
                                   pieces_to_cut[[2]]$end_cut[1],
                                   length(myLaTeXFile)),
                            "bibliographystyle{plain}",
                            "\\bibliography{bibliography}",
                            "\n\\end{document}")

references = list()
references[["Arino 2017"]] = "Arino2017"
references[["Arino, Bajeux, and Kirkland 2019"]] = "ArinoBajeuxKirkland2019"
references[["Arino et al. 2006"]] = "ArinoBrauerVdDWatmoughWu2006"
references[["Arino et al. 2007"]] = "ArinoBrauerVdDWatmoughWu2007"
references[["Arino and Driessche 2003"]] = "ArinoVdD2003a"
references[["Arino and Khan 2014"]] = "ArinoKhan2014"
references[["Arino and Portet 2015"]] = "ArinoPortet2015"
references[["McCallum, Barlow, and Hone 2001"]] = "McCallumBarlowHone2001"
references[["Valleron et al. 1986"]] = "ValleronBouvetGarnerinMenares_etal1986"
references[["Thieme 2003"]] = "Thieme2003"
#"WHORespTeam2015"

for (i in 1:length(references)) {
  myNewLaTeXFile <- gsub(pattern = sprintf("\\(%s\\)",names(references)[i]),
                         replacement = sprintf("\\\\cite{%s}",references[[i]]),
                         x = myNewLaTeXFile)
}

write_file(myNewLaTeXFile,
           "~/Documents/Publications/ModellingInDataRichWorld/Submission/ModellingInADataRichWorld_elsart_trimmed.tex")
