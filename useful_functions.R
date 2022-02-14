# USEFUL_FUNCTIONS.R
#
# Julien Arino
# May 2019
#
# This file contains several useful functions that I do not want to
# include in the main Rmd files.

# Table to map region names in mainland France between French and English.
# Put as many different lists as needed.
# Make sure order is the same in each sublist.
region_names_FR = list()
region_names_FR$shortFR = c("ARA","BFC","Br","Ce","Co","GE","HdF","IdF","No","Na","Oc","PL","PACA")
region_names_FR$fr1 = c("Auvergne-Rhône-Alpes",   
                        "Bourgogne-Franche-Comté",
                        "Bretagne",               
                        "Centre",
                        "Corse",
                        "Grand-Est",
                        "Haut - de-France",       
                        "Ile-de-France",
                        "Normandie",
                        "Nouvelle -Aquitaine",
                        "Occitanie",
                        "Pays-de-Loire",
                        "PACA")
region_names_FR$fr2 = c("Auvergne-Rhône-Alpes",   
                        "Bourgogne-Franche-Comté",
                        "Bretagne",               
                        "Centre",
                        "Corse",
                        "Grand-Est",
                        "Haut-de-France",       
                        "Ile-de-France",
                        "Normandie",
                        "Nouvelle-Aquitaine",
                        "Occitanie",
                        "Pays-de-Loire",                        
                        "PACA")
region_names_FR$fr3 = c("AUVERGNE-RHONE-ALPES",
                        "BOURGOGNE-FRANCHE-COMTE",
                        "BRETAGNE",
                        "CENTRE-VAL-DE-LOIRE",
                        "CORSE",
                        "GRAND EST",                 
                        "HAUTS-DE-FRANCE",
                        "ILE-DE-FRANCE",             
                        "NORMANDIE",
                        "NOUVELLE-AQUITAINE",
                        "OCCITANIE",
                        "PAYS-DE-LA-LOIRE",
                        "PROVENCE-ALPES-COTE-D-AZUR")
region_names_FR$en = c("Auvergne-Rhône-Alpes",
                       "Bourgogne-Franche-Comté",
                       "Brittany",
                       "Centre-Val de Loire",       
                       "Corsica",
                       "Grand Est",               
                       "Hauts-de-France",
                       "Île-de-France",             
                       "Normandy",
                       "Nouvelle-Aquitaine",        
                       "Occitanie",
                       "Pays de la Loire",          
                       "Provence-Alpes-Côte d'Azur")


# MAKE_Y_AXIS
# Formats the y axis ticks and labels so that they are easier to read.
# Also returns a multiplicative factor for the plot so that the plot is on the right scale.
make_y_axis <- function(yrange) {
  y_max <- yrange[2]
  if (y_max < 1000) {
    # Do almost nothing
    factor <- 1
    ticks <- pretty(yrange)
    labels <- format(ticks, big.mark=",", scientific=FALSE)    
  } else if (y_max < 10000) {
    # Label with ab,cde
    factor <- 1
    ticks <- pretty(yrange)
    labels <- format(ticks, big.mark=",", scientific=FALSE)
  } else if (y_max < 1000000) {
    # Label with K
    factor <- 1/1000
    ticks <- pretty(yrange*factor)
    labels <- paste(ticks,"K",sep="")
  } else if (y_max < 1000000000) {
    # Label with M
    factor <- 1/1000000
    ticks <- pretty(yrange*factor)
    labels <- paste(ticks,"M",sep="")
  } else {
    # Label with B
    factor <- 1/1000000000
    ticks <- pretty(yrange*factor)
    labels <- paste(ticks,"B",sep="")
  }
  # Remove 0unit, just have 0
  if ("0K" %in% labels) {
    labels[which(labels=="0K")]="0"
  }
  if ("0M" %in% labels) {
    labels[which(labels=="0M")]="0"
  }
  if ("0B" %in% labels) {
    labels[which(labels=="0B")]="0"
  }
  y_axis <- list(factor=factor,ticks=ticks,labels=labels)
  return(y_axis)
}

# PLOT_HR_YAXIS
#
# Plot data using a human readable y-axis 
plot_hr_yaxis <- function(x, y, ...) {
  y_range = range(y, na.rm = TRUE)
  y_axis <- make_y_axis(y_range)
  plot(x,y*y_axis$factor,
       yaxt = "n", ...)
  axis(2, at = y_axis$ticks, 
       labels = y_axis$labels, 
       las = 1, cex.axis=0.8)
}

# CROP_FIGURE
#
# Crop an output pdf file. Requires to have pdfcrop installed
# in the system (for example, under linux)
crop_figure = function(file) {
  command_str = sprintf("pdfcrop %s.pdf",file)
  system(command_str)
  command_str = sprintf("mv %s-crop.pdf %s.pdf",file,file)
  system(command_str)
}


# NICE_LOAD
#
# Implement a simple caching mechanism for csv data sets from the web.
# If you need to use other parameters in read.csv or write.csv, add them to
# the list of arguments of the function. (See for example skip here.)
# Here, only a weekly modification date is implemented; changing to days should be obvious.
nice_load = function(
  file,
  web,
  update_days = 7, # default update every 7 days 
  skip = 0 # default in read.csv
) 
{
  # If the file is absent, it needs to be loaded
  if (!file.exists(file)) {
    out = read.csv(file = web, 
                   skip = skip)
    write.csv(out, file = file)
  } else {
    # The file exists. We check how long ago it was modified
    load_time = difftime(Sys.time() , file.info(file)$mtime ,units = c("days"))
    if (load_time > update_days) {
      # The file is older than the required refresh interval, load it
      out = read.csv(file = web, 
                     skip = skip)
      write.csv(out, file = file)
    } else {
      # The file does not need refreshing
      out = read.csv(file = file, 
                     skip = skip)
    }
  }
  return(out)
}

# LATEST_VALUES_GENERAL
#
# For each country/country group in a data frame v, find the latest
# value
latest_values_general <- function(v,c1,c2) {
  l_c1 <- unique(v[[c1]])
  idx <- c()
  for (c in l_c1) {
    tmp <- v[which(v[[c1]] == c),]
    tmp <- tmp[order(tmp[[c2]], decreasing = TRUE),]
    idx1 <- which(v[[c2]] == tmp[[c2]][1])
    idx2 <- which(v[[c1]] == c)
    idx <- c(idx,intersect(idx1,idx2))
  }
  return(v[idx,])
}
