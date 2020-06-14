library(rvest)
library(rapportools)
library(anytime)
library(matrixStats)
library(dplyr)
library(tidyr)
setwd("C:/Users/shulm/Google Drive/4. Misc/NCAA Basketball Model")

# get schools and URLs

schools <- NULL

page_to_scrape <- read_html("https://www.sports-reference.com/cbb/seasons/2020-school-stats.html")
summary <- html_nodes(page_to_scrape, "#basic_school_stats a")
clean <- html_text(summary)
schools <- data.frame("school" = clean)

summary <- html_nodes(page_to_scrape, "#basic_school_stats a")
clean <- noquote(sub("(.*/cbb/schools/)", "", summary))
clean <- sub('(/.*)', "", clean)
schools$url <- clean

#

all_games <- NULL
for (i in 1:nrow(schools_2020)) {
    
  page_to_scrape <- read_html(paste("https://www.sports-reference.com/cbb/schools/",schools$url[i],"/2020-gamelogs.html",sep=""))
  summary <- html_nodes(page_to_scrape, ".right:nth-child(1)")
  clean <- html_text(summary)
  game_data <- data.frame("game_num" = clean)
  
  game_data$school <- schools[i,1]
  
  summary <- html_nodes(page_to_scrape, ".right+ .left a")
  clean <- html_text(summary)
  game_data$date <- anytime(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(3)")
  clean <- html_text(summary)
  clean[clean == "@"] <- 1
  clean[clean == ""] <- 0
  game_data$is_away <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(3)")
  clean <- html_text(summary)
  clean[clean == "N"] <- 1
  clean[clean == "@"] <- 0
  clean[clean == ""] <- 0
  game_data$neutral_site <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(4)")
  clean <- html_text(summary)
  game_data$opp <- clean
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(4)")
  clean <- sub('<a href=.*', '\\1', summary)
  clean <- sub('^.*(opp_id\\\">)', '', clean)
  clean[clean==""] <- 1
  clean[clean!=1] <- 0
  game_data$has_link <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(5)")
  clean <- html_text(summary)
  clean[clean=="W"] <- "0" 
  clean[clean=="L"] <- "0"
  clean <- sub('^.*\\(', '', clean)
  clean <- sub('( OT\\))', '', clean)
  game_data$numot <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, ".left+ td.right")
  clean <- html_text(summary)
  game_data$school_points <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(7)")
  clean <- html_text(summary)
  game_data$opp_points <- as.integer(clean)
  
  # school
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(8)")
  clean <- html_text(summary)
  game_data$school_fgm <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(9)")
  clean <- html_text(summary)
  game_data$school_fga <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(11)")
  clean <- html_text(summary)
  game_data$school_fgm3 <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(12)")
  clean <- html_text(summary)
  game_data$school_fga3 <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(14)")
  clean <- html_text(summary)
  game_data$school_ftm <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(15)")
  clean <- html_text(summary)
  game_data$school_fta <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(17)")
  clean <- html_text(summary)
  game_data$school_or <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(18)")
  clean <- html_text(summary)
  game_data$school_dr <- as.integer(clean) - game_data$school_or
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(19)")
  clean <- html_text(summary)
  game_data$school_ast <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(22)")
  clean <- html_text(summary)
  game_data$school_to <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(20)")
  clean <- html_text(summary)
  game_data$school_stl <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(21)")
  clean <- html_text(summary)
  game_data$school_blk <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(23)")
  clean <- html_text(summary)
  game_data$school_pf <- as.integer(clean)
  
  # opponent
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(25)")
  clean <- html_text(summary)
  game_data$opp_fgm <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(26)")
  clean <- html_text(summary)
  game_data$opp_fga <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(28)")
  clean <- html_text(summary)
  game_data$opp_fgm3 <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(29)")
  clean <- html_text(summary)
  game_data$opp_fga3 <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(31)")
  clean <- html_text(summary)
  game_data$opp_ftm <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(32)")
  clean <- html_text(summary)
  game_data$opp_fta <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(34)")
  clean <- html_text(summary)
  game_data$opp_or <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(35)")
  clean <- html_text(summary)
  game_data$opp_dr <- as.integer(clean) - game_data$opp_or
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(36)")
  clean <- html_text(summary)
  game_data$opp_ast <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(39)")
  clean <- html_text(summary)
  game_data$opp_to <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(37)")
  clean <- html_text(summary)
  game_data$opp_stl <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(38)")
  clean <- html_text(summary)
  game_data$opp_blk <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(40)")
  clean <- html_text(summary)
  game_data$opp_pf <- as.integer(clean)

  all_games <- rbind(all_games, game_data)
  print(i)
}
all_games$school <- as.character(all_games$school)
all_games$game_num <- as.integer(as.character(all_games$game_num))
# 
# str(all_games)
# order_index <- order(all_games$school)
# all_games[order_index,]
# 
# names(table(all_games$school))
# 
# write.csv(names(table(all_games$school)), "test.csv")
#

scraped_school_names <- as.character(schools$school)

br_kp_lookup <- read.csv("BR_KP_TeamLookup.csv", stringsAsFactors = FALSE)

find_kp_name <- function(scraped_br_name) {
  kp_name <- br_kp_lookup[br_kp_lookup[,"BR_School_Name_SS"] == scraped_br_name,"KP.School.Name"]
  return(kp_name)
}

find_team_id <- function(scraped_br_name) {
  team_id <- br_kp_lookup[br_kp_lookup[,"BR_School_Name_SS"] == scraped_br_name,"team_id"]
  return(team_id)
}

find_conf <- function(scraped_br_name) {
  conf <- br_kp_lookup[br_kp_lookup[,"BR_School_Name_SS"] == scraped_br_name,"Conference"]
  return(conf)
}

kp_school_name <- unlist(apply(X = all_games, MARGIN = 1, FUN = function(x) find_kp_name(x["school"])))
team_id <- unlist(apply(X = all_games, MARGIN = 1, FUN = function(x) find_team_id(x["school"])))
conf <- unlist(apply(X = all_games, MARGIN = 1, FUN = function(x) find_conf(x["school"])))

opp_kp_school_name <- unlist(apply(X = all_games, MARGIN = 1, FUN = function(x) find_kp_name(x["opp"])))
opp_team_id <- unlist(apply(X = all_games, MARGIN = 1, FUN = function(x) find_team_id(x["opp"])))
opp_conf <- unlist(apply(X = all_games, MARGIN = 1, FUN = function(x) find_conf(x["opp"])))

str(all_games)
str(kp_school_name)
str(opp_kp_school_name)


clean_games <- left_join(all_games, br_kp_lookup, by = c("school"="BR_School_Name_SS"))
clean_games <- left_join(clean_games, br_kp_lookup, by = c("opp"="BR_School_Name_SS"))

write.csv(clean_games, "games_2020.csv")

