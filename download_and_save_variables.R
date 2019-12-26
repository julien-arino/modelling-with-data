# DOWNLOAD_AND_SAVE_VARIABLES.R
#
# This script downloads from the internet all the variables required to compile
# the Rmd file for the paper "Modelling in a data-rich world", Infectious Disease
# Modelling 2019.
#
# Run this script if you want to update the variables.

# Required libraries
library(XML)
library(htmltab)
library(wbstats)
library(countrycode)
# Load additional functions not included in this file
source("useful_functions.R")

# The base URL for wikipedia pages
wiki_url <- "https://en.wikipedia.org/wiki/"
# URL for Sante Publique France document
SPF_url <- "https://www.santepubliquefrance.fr/determinants-de-sante/vaccination/articles/donnees-regionales-de-couverture-vaccinale-grippe-par-saison-et-dans-chaque-groupe-d-age"

# Measles
base_url_who = "http://apps.who.int/gho/athena/data/GHO/"
indicator = "WHS3_62"
options1 = "?filter=COUNTRY:*;REGION:*"
options2 = "&x-sideaxis=COUNTRY&x-topaxis=GHO;YEAR"
options3 = "&profile=crosstable"
options4 = "&format=csv"
full_url = paste0(base_url_who,indicator,options1,options2,options3,options4)
measles_data <- read.csv(full_url, header = TRUE, skip = 1)
saveRDS(measles_data, "DATA/measles_data_original.Rds")

# WHO GHO indicators
GHO_xml = xmlParse(base_url_who)
GHO_root = xmlRoot(GHO_xml)[["Metadata"]][["Dimension"]]
GHO_label = as.character(xmlSApply(GHO_root, xmlGetAttr, "Label"))
GHO_url = xmlSApply(GHO_root, xmlGetAttr, "URL")
GHO_display = mat.or.vec(nr = xmlSize(GHO_root), nc = 1)
for (i in 1:xmlSize(GHO_root)) {
  if (length(xmlChildren(GHO_root[[i]])[["Display"]]) > 0) {
    tmp <- xmlChildren(GHO_root[[i]])[["Display"]]
    GHO_display[i] =
      as.character(xmlValue(tmp))
  }
}
GHO_indices = as.data.frame(cbind(GHO_display,GHO_label,GHO_url))
GHO_indices = GHO_indices[which(GHO_indices$GHO_display != "0"),]
colnames(GHO_indices) = c("Description","Name","URL")
rownames(GHO_indices) = 1:dim(GHO_indices)[1]
saveRDS(GHO_indices, "DATA/GHO_indices.Rds")

# World Bank data
new_cache_wb <- wbcache()
lifeExpectancy_vars_wb <- wbsearch(pattern = "expectancy", cache = new_cache_wb)
saveRDS(lifeExpectancy_vars_wb, "DATA/lifeExpectancy_vars_wb.Rds")
pop_vars1_wb <- wbsearch(pattern = "population", cache = new_cache_wb)
saveRDS(pop_vars1_wb, "DATA/pop_vars1_wb.Rds")
pop_vars2_wb <- wbsearch(pattern = "total population", cache = new_cache_wb)
saveRDS(pop_vars2_wb, "DATA/pop_vars2_wb.Rds")
lifeExpectancy_data_wb = wb(indicator = "SP.DYN.LE00.IN",
                            startdate = 2000,
                            enddate = 2019)
saveRDS(lifeExpectancy_data_wb, "DATA/lifeExpectancy_data_wb.Rds")
pop_data_wb <- wb(indicator = "SP.POP.TOTL",
                  startdate = 2000,
                  enddate = 2019)
saveRDS(pop_data_wb, "DATA/pop_data_wb.Rds")
pop_data_CHN_wb <- wb(country = c("CHN"),
                      indicator = "SP.POP.TOTL",
                      mrv = 100)
saveRDS(pop_data_CHN_wb, "DATA/pop_data_CHN_wb.Rds")
prop_over65_CHN_wb <- wb(country = c("CHN"),
                         indicator = "SP.POP.65UP.TO.ZS",
                         mrv = 1)
saveRDS(prop_over65_CHN_wb, "DATA/prop_over65_CHN_wb.Rds")
tourism_data_arrivals_wb = wb(indicator = "ST.INT.ARVL",
                              startdate = 2000,
                              enddate = 2018)
saveRDS(tourism_data_arrivals_wb, "DATA/tourism_data_arrivals_wb.Rds")
PAX_transported_wb = wb(indicator = "IS.AIR.PSGR",
                        startdate = 2000,
                        enddate = 2018)
saveRDS(PAX_transported_wb, "DATA/PAX_transported_wb.Rds")
aircraft_departures_wb = wb(indicator = "IS.AIR.DPRT",
                            startdate = 2000,
                            enddate = 2018)
saveRDS(aircraft_departures_wb, "DATA/aircraft_departures_wb.Rds")
countries <- c("Canada","China","India","Pakistan","Philippines")
countries_iso3c <- countrycode(countries,
                               origin = "country.name",
                               destination = "iso3c")
pop_data_5ctr_wb <- wb(country = countries_iso3c,
                       indicator = "SP.POP.TOTL")
saveRDS(pop_data_5ctr_wb, "DATA/pop_data_5ctr_wb.Rds")

# Data from Wikipedia
page_url <- "List_of_countries_and_dependencies_by_population"
url <- paste0(wiki_url, page_url)
pop_wiki <- htmltab(url,
                    which = 1,
                    stringsAsFactors = FALSE)
saveRDS(pop_wiki, "DATA/pop_wiki.Rds")
page_url <- "List_of_countries_and_dependencies_by_area"
url <- paste0(wiki_url, page_url)
surf_wiki <- htmltab(url,
                     which = 2,
                     rm_nodata_cols = FALSE,
                     stringsAsFactors = FALSE)
saveRDS(surf_wiki, "DATA/surf_wiki.Rds")
us_census <- htmltab(paste0(wiki_url,
                            "United_States_Census"),
                     which = 3)
saveRDS(us_census, "DATA/us_census_original.Rds")
page_url <- "Ranked_list_of_French_regions"
pop_regions_FR <- htmltab(paste0(wiki_url, page_url),
                          which = 1)
saveRDS(pop_regions_FR, "DATA/pop_regions_FR.Rds")

# Data from SNCF open portal
base_url_sncf <- "https://data.sncf.com/explore/dataset/"
data_set <- "trafic-de-voyageurs-et-marchandises-depuis-1841"
options1 <- "/download/?format=csv&use_labels_for_header=true"
url = paste0(base_url_sncf,data_set,options1)
SNCF_volume = read.csv(url, sep = ";")
saveRDS(SNCF_volume, "DATA/SNCF_volume.Rds")
data_set = "meilleurs-temps-des-parcours-des-trains"
url = paste0(base_url_sncf,data_set,options1)
SNCF_time = read.csv(url, sep = ";")
saveRDS(SNCF_time, "DATA/SNCF_time.Rds")

# Data from France INVS
coverage_influenza_FR <- htmltab(SPF_url, which = 1)
saveRDS(coverage_influenza_FR, "DATA/coverage_influenza_FR.Rds")

# Data from Reseau Sentinelles
influenza_FR = nice_load(file = "DATA/incidence-RDD-3.csv",
                         web = "https://www.sentiweb.fr/datasets/incidence-RDD-3.csv",
                         update_days = 30,
                         skip = 1,
                         stringsAsFactors = FALSE)
saveRDS(influenza_FR, "DATA/influenza_FR.Rds")
