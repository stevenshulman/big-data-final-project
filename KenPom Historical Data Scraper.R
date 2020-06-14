library(rvest)
library(rapportools)
library(anytime)
library(matrixStats)
library(tictoc)
library(lubridate)
library(rvest)
library(rapportools)
library(anytime)
library(matrixStats)
library(tictoc)
library(lubridate)
library(dplyr)
library(tidyr)
library(keras)
library(anytime)
library(caret)
library(gdata)

setwd("C:/Users/shulm/Google Drive/4. Misc/NCAA Basketball Model")

# log in to KenPom

login_url <- "https://kenpom.com/"
session <- html_session(login_url)
form <- html_form(read_html(login_url))[[1]]

filled_form <- set_values(form
                          , email = # insert email login
                          , password = ) # insert pw

submit_form(session, filled_form)

# scrape ratings archive

start_date <- anytime("2018-10-25")
end_date <- anytime("2019-04-15")

the_date <- start_date
while (the_date <= end_date) {
  tic()
  
  ratings_archive <- NULL
  
  page_to_scrape <- jump_to(session, paste("https://kenpom.com/archive.php?d=",format(the_date, "%Y-%m-%d"), sep=""))
  
  summary <- html_nodes(page_to_scrape, "td")
  clean <- html_text(summary)
  
  if (clean == "No ratings available for this date") {} else {
    summary <- html_nodes(page_to_scrape, "td.hard_left")
    clean <- html_text(summary)
    ratings_archive <- data.frame("rank" = as.integer(clean))
    
    ratings_archive$date <- the_date
    
    summary <- html_nodes(page_to_scrape, "td.next_left a")
    clean <- html_text(summary)
    ratings_archive$team_name <- clean
    
    summary <- html_nodes(page_to_scrape, ".next_left+ td a")
    clean <- html_text(summary)
    ratings_archive$conf <- clean
    
    summary <- html_nodes(page_to_scrape, "td:nth-child(4)")
    clean <- html_text(summary)
    ratings_archive$AdjEM <- clean
    
    summary <- html_nodes(page_to_scrape, ".td-left:nth-child(5)")
    clean <- html_text(summary)
    ratings_archive$AdjOE <- clean
    
    summary <- html_nodes(page_to_scrape, ".td-right:nth-child(6) .seed")
    clean <- html_text(summary)
    ratings_archive$RankOE <- clean
    
    summary <- html_nodes(page_to_scrape, ".td-left:nth-child(7)")
    clean <- html_text(summary)
    ratings_archive$AdjDE <- clean
    
    summary <- html_nodes(page_to_scrape, ".td-right:nth-child(8) .seed")
    clean <- html_text(summary)
    ratings_archive$RankDE <- clean
    
    summary <- html_nodes(page_to_scrape, ".td-left:nth-child(9)")
    clean <- html_text(summary)
    ratings_archive$AdjTempo <- clean
    
    summary <- html_nodes(page_to_scrape, ".td-right:nth-child(10) .seed")
    clean <- html_text(summary)
    ratings_archive$RankAdjTempo <- clean
    
    write.table(ratings_archive, "kp_ratings_archive_v2.csv", sep = ",", col.names = !file.exists("kp_ratings_archive_v2.csv"), append = T, row.names=FALSE)
  }
  
  print(the_date)
  toc()
  the_date <- the_date + days(1)
}

# scrape end of season metrics

start_season <- 2020
end_season <- 2020

the_season <- start_season
while (the_season <= end_season) {
  # scrape effiency metrics
  
  efficiency_data = NULL
  
  page_to_scrape <- jump_to(session, paste("https://kenpom.com/stats.php?y=", the_season, sep=""))
  summary <- html_nodes(page_to_scrape, "td:nth-child(1) a")
  clean <- html_text(summary)
  efficiency_data <- data.frame("team_name" = clean)
  
  summary <- html_nodes(page_to_scrape, "td+ td a")
  clean <- html_text(summary)
  efficiency_data$conf <- clean
  
  summary <- html_nodes(page_to_scrape, ".td-left:nth-child(3)")
  clean <- html_text(summary)
  efficiency_data$AdjTempo <- clean
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(4) .seed")
  clean <- html_text(summary)
  efficiency_data$RankAdjTempo <- clean
  
  summary <- html_nodes(page_to_scrape, ".td-left:nth-child(5)")
  clean <- html_text(summary)
  efficiency_data$AdjOE <- clean
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(6) .seed")
  clean <- html_text(summary)
  efficiency_data$RankAdjOE <- clean
  
  summary <- html_nodes(page_to_scrape, ".td-left:nth-child(7)")
  clean <- html_text(summary)
  efficiency_data$o_eFG_pct <- clean
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(8) .seed")
  clean <- html_text(summary)
  efficiency_data$o_RankeFG_pct <- clean
  
  summary <- html_nodes(page_to_scrape, ".td-left:nth-child(9)")
  clean <- html_text(summary)
  efficiency_data$o_TO_pct <- clean
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(10) .seed")
  clean <- html_text(summary)
  efficiency_data$o_RankTO_pct <- clean
  
  summary <- html_nodes(page_to_scrape, ".td-left:nth-child(11)")
  clean <- html_text(summary)
  efficiency_data$o_OR_pct <- clean
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(12) .seed")
  clean <- html_text(summary)
  efficiency_data$o_RankOR_pct <- clean
  
  summary <- html_nodes(page_to_scrape, ".td-left:nth-child(13)")
  clean <- html_text(summary)
  efficiency_data$o_FT_rate <- clean
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(14) .seed")
  clean <- html_text(summary)
  efficiency_data$o_RankFT_rate <- clean
  
  summary <- html_nodes(page_to_scrape, ".td-left:nth-child(15)")
  clean <- html_text(summary)
  efficiency_data$AdjDE <- clean
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(16) .seed")
  clean <- html_text(summary)
  efficiency_data$RankAdjDE <- clean
  
  summary <- html_nodes(page_to_scrape, ".td-left:nth-child(17)")
  clean <- html_text(summary)
  efficiency_data$d_eFG_pct <- clean
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(18)")
  clean <- html_text(summary)
  efficiency_data$d_RankeFG_pct <- clean
  
  summary <- html_nodes(page_to_scrape, ".td-left:nth-child(19)")
  clean <- html_text(summary)
  efficiency_data$d_TO_pct <- clean
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(20) .seed")
  clean <- html_text(summary)
  efficiency_data$d_RankTO_pct <- clean
  
  summary <- html_nodes(page_to_scrape, ".td-left:nth-child(21)")
  clean <- html_text(summary)
  efficiency_data$d_OR_pct <- clean
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(22) .seed")
  clean <- html_text(summary)
  efficiency_data$d_RankOR_pct <- clean
  
  summary <- html_nodes(page_to_scrape, ".td-left:nth-child(23)")
  clean <- html_text(summary)
  efficiency_data$d_FT_rate <- clean
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(24) .seed")
  clean <- html_text(summary)
  efficiency_data$d_RankFT_rate <- clean
  
  efficiency_data$team_name <- as.character(efficiency_data$team_name)
  efficiency_data$team_name[efficiency_data$team_name == "N.C. State"] <- "North Carolina St."
  efficiency_data$team_name[efficiency_data$team_name == "Louisiana Lafayette"] <- "Louisiana"
  efficiency_data$team_name[efficiency_data$team_name == "IPFW"] <- "Purdue Fort Wayne"
  efficiency_data$team_name[efficiency_data$team_name == "Fort Wayne"] <- "Purdue Fort Wayne"
  efficiency_data$team_name[efficiency_data$team_name == "College of Charleston"] <- "Charleston"
  efficiency_data$team_name[efficiency_data$team_name == "Texas Pan American"] <- "UT Rio Grande Valley"
  efficiency_data$team_name[efficiency_data$team_name == "Arkansas Little Rock"] <- "Little Rock"
  
  ##### download and read in csv files
  
  browseURL(paste("https://kenpom.com/getdata.php?file=misc", sub("^([0-9][0-9])", "", the_season),sep=""))
  Sys.sleep(3)
  misc_data <- read.csv(file =paste("C:/Users/shulm/Downloads/misc",sub("^([0-9][0-9])", "", the_season),".csv", sep=""), row.names=NULL)
  misc_data$TeamName <- as.character(misc_data$TeamName)
  
  misc_data $following_season<- misc_data$Season + 1
  
  browseURL(paste("https://kenpom.com/getdata.php?file=pointdist", sub("^([0-9][0-9])", "", the_season),sep=""))
  Sys.sleep(3)
  pointdist_data <- read.csv(file =paste("C:/Users/shulm/Downloads/pointdist",sub("^([0-9][0-9])", "", the_season),".csv", sep=""), row.names=NULL)
  pointdist_data$TeamName <- as.character(pointdist_data$TeamName)
  pointdist_data$Season <- as.integer(pointdist_data$Season)

  browseURL(paste("https://kenpom.com/getdata.php?file=height", sub("^([0-9][0-9])", "", the_season),sep=""))
  Sys.sleep(3)
  height_data <- read.csv(file =paste("C:/Users/shulm/Downloads/height",sub("^([0-9][0-9])", "", the_season),".csv", sep=""), row.names=NULL)
  height_data$TeamName <- as.character(height_data$TeamName)
  
  # aggregate team data
  
  end_of_season_snapshot <- efficiency_data

  end_of_season_snapshot <- left_join(end_of_season_snapshot, misc_data, by=c("team_name"="TeamName"))
  end_of_season_snapshot <- left_join(end_of_season_snapshot, pointdist_data, by=c("team_name"="TeamName", "Season"))
  end_of_season_snapshot <- left_join(end_of_season_snapshot, height_data, by=c("team_name"="TeamName", "Season"))
  end_of_season_snapshot$AdjEM <- as.numeric(end_of_season_snapshot$AdjOE) - as.numeric(end_of_season_snapshot$AdjDE)  

  write.table(end_of_season_snapshot, "end_of_season_snapshots.csv", sep = ",", col.names = !file.exists("end_of_season_snapshots.csv"), append = T, row.names=FALSE)
  the_season <- the_season + 1
}
