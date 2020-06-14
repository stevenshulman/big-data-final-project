library(rvest)
library(rapportools)
library(anytime)
library(matrixStats)
setwd("C:/Users/shulm/Google Drive/4. Misc/NCAA Basketball Model")

# log in to KenPom

login_url <- "https://kenpom.com/"
session <- html_session(login_url)
form <- html_form(read_html(login_url))[[1]]

filled_form <- set_values(form
                          , email = # insert email login
                            , password = ) # insert pw

submit_form(session, filled_form)

# scrape summary ratings

  summary_data <- NULL
  
  page_to_scrape <- jump_to(session, "https://kenpom.com/index.php?s=TeamName")
  summary <- html_nodes(page_to_scrape, "td.hard_left")
  clean <- noquote(html_text(summary))
  summary_data <- data.frame("rank" = as.integer(clean))
  
  summary_data$date <- Sys.Date()
  
  summary <- html_nodes(page_to_scrape, "td.next_left a")
  clean <- noquote(html_text(summary))
  summary_data$team_name <- clean
  
  summary <- html_nodes(page_to_scrape, ".conf a")
  clean <- noquote(html_text(summary))
  summary_data$conf <- as.factor(clean)
  
  summary <- html_nodes(page_to_scrape, "td.wl")
  clean <- noquote(html_text(summary))
  clean <- sub("-.*", "", clean)
  summary_data$win_count <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, "td.wl")
  clean <- noquote(html_text(summary))
  clean <- sub(".*-", "", clean)
  summary_data$loss_count <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, ".wl+ td")
  clean <- noquote(html_text(summary))
  summary_data$AdjEM <- as.numeric(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-left:nth-child(6)")
  clean <- noquote(html_text(summary))
  summary_data$AdjOE <- as.numeric(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(7) .seed")
  clean <- noquote(html_text(summary))
  summary_data$adj_o_rank <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-left:nth-child(8)")
  clean <- noquote(html_text(summary))
  summary_data$AdjDE <- as.numeric(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(9) .seed")
  clean <- noquote(html_text(summary))
  summary_data$adj_d_rank <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-left:nth-child(10)")
  clean <- noquote(html_text(summary))
  summary_data$AdjTempo <- as.numeric(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(11) .seed")
  clean <- noquote(html_text(summary))
  summary_data$adj_t_rank <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, ".divide:nth-child(12)")
  clean <- noquote(html_text(summary))
  summary_data$luck <- as.numeric(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(13) .seed")
  clean <- noquote(html_text(summary))
  summary_data$luck_rank <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, ".divide:nth-child(14)")
  clean <- noquote(html_text(summary))
  summary_data$sos_adj_em <- as.numeric(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(15) .seed")
  clean <- noquote(html_text(summary))
  summary_data$sos_adj_em_rank <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-left:nth-child(16)")
  clean <- noquote(html_text(summary))
  summary_data$sos_opp_o <- as.numeric(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(17) .seed")
  clean <- noquote(html_text(summary))
  summary_data$sos_opp_o_rank <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-left:nth-child(18)")
  clean <- noquote(html_text(summary))
  summary_data$sos_opp_d <- as.numeric(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(19) .seed")
  clean <- noquote(html_text(summary))
  summary_data$sos_opp_d_rank <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, ".divide:nth-child(20)")
  clean <- noquote(html_text(summary))
  summary_data$ncsos_adj_em <- as.numeric(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(21) .seed")
  clean <- noquote(html_text(summary))
  summary_data$ncsos_adj_em_rank <- as.integer(clean)
  
  # scrape effiency stats
  
  efficiency_data = NULL
  
  page_to_scrape <- jump_to(session, "https://kenpom.com/summary.php?s=TeamName")
  summary <- html_nodes(page_to_scrape, "td:nth-child(1) a")
  clean <- noquote(html_text(summary))
  efficiency_data <- data.frame("team_name" = clean)
  
  summary <- html_nodes(page_to_scrape, "td+ td a")
  clean <- noquote(html_text(summary))
  efficiency_data$conf <- as.factor(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-left:nth-child(3)")
  clean <- noquote(html_text(summary))
  efficiency_data$adj_tempo <- as.numeric(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(4) .seed")
  clean <- noquote(html_text(summary))
  efficiency_data$adj_tempo_rank <- as.numeric(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-left:nth-child(5)")
  clean <- noquote(html_text(summary))
  efficiency_data$raw_tempo <- as.numeric(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(6) .seed")
  clean <- noquote(html_text(summary))
  efficiency_data$raw_tempo_rank <- as.numeric(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-left:nth-child(7)")
  clean <- noquote(html_text(summary))
  efficiency_data$o_avg_poss_length <- as.numeric(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(8) .seed")
  clean <- noquote(html_text(summary))
  efficiency_data$o_avg_poss_length_rank <- as.numeric(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-left:nth-child(9)")
  clean <- noquote(html_text(summary))
  efficiency_data$d_avg_poss_length <- as.numeric(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(10) .seed")
  clean <- noquote(html_text(summary))
  efficiency_data$d_avg_poss_length_rank <- as.numeric(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-left:nth-child(11)")
  clean <- noquote(html_text(summary))
  efficiency_data$o_eff_adj <- as.numeric(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(12) .seed")
  clean <- noquote(html_text(summary))
  efficiency_data$o_eff_adj_rank <- as.numeric(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-left:nth-child(13)")
  clean <- noquote(html_text(summary))
  efficiency_data$OEffRaw <- as.numeric(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(14) .seed")
  clean <- noquote(html_text(summary))
  efficiency_data$o_eff_raw_rank <- as.numeric(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-left:nth-child(15)")
  clean <- noquote(html_text(summary))
  efficiency_data$d_eff_adj <- as.numeric(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(16) .seed")
  clean <- noquote(html_text(summary))
  efficiency_data$d_eff_adj_rank <- as.numeric(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-left:nth-child(17)")
  clean <- noquote(html_text(summary))
  efficiency_data$DE <- as.numeric(clean)
  
  summary <- html_nodes(page_to_scrape, ".td-right:nth-child(18) .seed")
  clean <- noquote(html_text(summary))
  efficiency_data$d_eff_raw_rank <- as.numeric(clean)
  
  ##### download and read in csv files
  
  browseURL("https://kenpom.com/getdata.php?file=misc20")
  Sys.sleep(5)
  misc_data <- read.csv(file ="C:/Users/shulm/Downloads/misc20.csv")
  
  browseURL("https://kenpom.com/getdata.php?file=offense20")
  Sys.sleep(5)
  offense_data <- read.csv(file ="C:/Users/shulm/Downloads/offense20.csv")
  colnames(offense_data) <- paste("off", colnames(offense_data),sep="_")
  
  browseURL("https://kenpom.com/getdata.php?file=defense20")
  Sys.sleep(5)
  defense_data <- read.csv(file ="C:/Users/shulm/Downloads/defense20.csv")
  colnames(defense_data) <- paste("def", colnames(defense_data),sep="_")
  
  browseURL("https://kenpom.com/getdata.php?file=pointdist20")
  Sys.sleep(5)
  pointdist_data <- read.csv(file ="C:/Users/shulm/Downloads/pointdist20.csv")
  
  browseURL("https://kenpom.com/getdata.php?file=height20")
  Sys.sleep(5)
  height_data <- read.csv(file ="C:/Users/shulm/Downloads/height20.csv")
  
  # aggregate team data
  
  team_snapshot <- NULL
  team_snapshot
  team_snapshot <- cbind("date" = summary_data$date
                         , "rank" = summary_data$rank
                         , summary_data[,3:ncol(summary_data)]
                         , efficiency_data[,3:ncol(efficiency_data)]
                         , misc_data[,3:ncol(misc_data)]
                         , offense_data[,3:ncol(offense_data)]
                         , defense_data[,3:ncol(defense_data)]
                         , pointdist_data[,3:ncol(pointdist_data)]
                         , height_data[,3:ncol(height_data)]
  )
  
  team_snapshot
  
  write.table(team_snapshot, "team_snapshots.csv", sep = ",", col.names = !file.exists("team_snapshots.csv"), append = T, row.names=FALSE)
  
  # scrape todays games from KenPom
  
  game_data <- NULL
  
  page_to_scrape <- jump_to(session, "https://kenpom.com/fanmatch.php")
  summary <- html_nodes(page_to_scrape, ".seed-gray:nth-child(1)")
  clean <- noquote(html_text(summary))
  game_data <- data.frame("away_rank" = as.integer(clean))
  
  game_data$date <- Sys.Date()
  
  summary <- html_nodes(page_to_scrape, ".seed-gray+ a:nth-child(2)")
  clean <- noquote(html_text(summary))
  game_data$away_team <- clean
  
  summary <- html_nodes(page_to_scrape, ".desktopHide+ .seed-gray")
  clean <- noquote(html_text(summary))
  game_data$home_rank <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, ".desktopHide~ a")
  clean <- noquote(html_text(summary))
  game_data$home_team <- clean
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(4)")
  clean <- noquote(html_text(summary))
  clean <- sub("(, [A-Z][A-Z]).*", "\\1", clean)
  game_data$city <- clean
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(4)")
  clean <- noquote(html_text(summary))
  clean <- sub(".*(, [A-Z][A-Z])", "", clean)
  game_data$arena <- clean
  
  summary <- html_nodes(page_to_scrape, ".stats:nth-child(5)")
  clean <- noquote(html_text(summary))
  clean <- sub("(....).*", "\\1", clean)
  game_data$thrill_score <- as.numeric(clean)
  
  write.table(game_data, "games.csv", sep = ",", col.names = !file.exists("games.csv"), append = T, row.names=FALSE)
  
  # scrape todays spreads
  
  spread_data <- NULL
  
  target_date <- Sys.Date()-0
  
  page_to_scrape <- read_html(paste("https://www.donbest.com/ncaab/odds/spreads/",format(target_date, "%Y%m%d"),".html",sep=""))
  summary <- html_nodes(page_to_scrape, ".alignLeft+ .alignCenter div")
  clean <- html_text(summary)
  spread_data <- data.frame("game_time" = clean)
  
  spread_data$date <- target_date
  
  summary <- html_nodes(page_to_scrape, "nobr:nth-child(1) .oddsTeamWLink")
  clean <- html_text(summary)
  spread_data$away_team <- clean
  
  summary <- html_nodes(page_to_scrape, "br+ nobr .oddsTeamWLink")
  clean <- html_text(summary)
  spread_data$home_team <- clean
  
  #####       cleaning up team names to match KenPom         #######
  spread_data$away_team[spread_data$away_team=="Youngstown State"] <- "Youngstown St."
  spread_data$home_team[spread_data$home_team=="Youngstown State"] <- "Youngstown St."
  spread_data$away_team[spread_data$away_team=="Wisc Green Bay"] <- "Green Bay"
  spread_data$home_team[spread_data$home_team=="Wisc Green Bay"] <- "Green Bay"
  spread_data$away_team[spread_data$away_team=="Wichita State"] <- "Wichita St."
  spread_data$home_team[spread_data$home_team=="Wichita State"] <- "Wichita St."
  spread_data$away_team[spread_data$away_team=="Weber State"] <- "Weber St."
  spread_data$home_team[spread_data$home_team=="Weber State"] <- "Weber St."
  spread_data$away_team[spread_data$away_team=="Washington State"] <- "Washington St."
  spread_data$home_team[spread_data$home_team=="Washington State"] <- "Washington St."
  spread_data$away_team[spread_data$away_team=="Va Commonwealth"] <- "VCU"
  spread_data$home_team[spread_data$home_team=="Va Commonwealth"] <- "VCU"
  spread_data$away_team[spread_data$away_team=="Utah State"] <- "Utah St."
  spread_data$home_team[spread_data$home_team=="Utah State"] <- "Utah St."
  spread_data$away_team[spread_data$away_team=="Tennessee State"] <- "Tennessee St."
  spread_data$home_team[spread_data$home_team=="Tennessee State"] <- "Tennessee St."
  spread_data$away_team[spread_data$away_team=="St. Peter's"] <- "Saint Peter's"
  spread_data$home_team[spread_data$home_team=="St. Peter's"] <- "Saint Peter's"
  spread_data$away_team[spread_data$away_team=="Seattle U"] <- "Seattle"
  spread_data$home_team[spread_data$home_team=="Seattle U"] <- "Seattle"
  spread_data$away_team[spread_data$away_team=="San Diego State"] <- "San Diego St."
  spread_data$home_team[spread_data$home_team=="San Diego State"] <- "San Diego St."
  spread_data$away_team[spread_data$away_team=="Prairie View AM"] <- "Prairie View A&M"
  spread_data$home_team[spread_data$home_team=="Prairie View AM"] <- "Prairie View A&M"
  spread_data$away_team[spread_data$away_team=="Portland State"] <- "Portland St."
  spread_data$home_team[spread_data$home_team=="Portland State"] <- "Portland St."
  spread_data$away_team[spread_data$away_team=="Pennsylvania"] <- "Penn"
  spread_data$home_team[spread_data$home_team=="Pennsylvania"] <- "Penn"
  spread_data$away_team[spread_data$away_team=="Oregon State"] <- "Oregon St."
  spread_data$home_team[spread_data$home_team=="Oregon State"] <- "Oregon St."
  spread_data$away_team[spread_data$away_team=="Ohio State"] <- "Ohio St."
  spread_data$home_team[spread_data$home_team=="Ohio State"] <- "Ohio St."
  spread_data$away_team[spread_data$away_team=="North Carolina AT"] <- "North Carolina A&T"
  spread_data$home_team[spread_data$home_team=="North Carolina AT"] <- "North Carolina A&T"
  spread_data$away_team[spread_data$away_team=="Norfolk State"] <- "Norfolk St."
  spread_data$home_team[spread_data$home_team=="Norfolk State"] <- "Norfolk St."
  spread_data$away_team[spread_data$away_team=="No. Colorado"] <- "Northern Colorado"
  spread_data$home_team[spread_data$home_team=="No. Colorado"] <- "Northern Colorado"
  spread_data$away_team[spread_data$away_team=="New Mexico State"] <- "New Mexico St."
  spread_data$home_team[spread_data$home_team=="New Mexico State"] <- "New Mexico St."
  spread_data$away_team[spread_data$away_team=="NC State"] <- "N.C. State"
  spread_data$home_team[spread_data$home_team=="NC State"] <- "N.C. State"
  spread_data$away_team[spread_data$away_team=="NC Asheville"] <- "UNC Asheville"
  spread_data$home_team[spread_data$home_team=="NC Asheville"] <- "UNC Asheville"
  spread_data$away_team[spread_data$away_team=="Murray State"] <- "Murray St."
  spread_data$home_team[spread_data$home_team=="Murray State"] <- "Murray St."
  spread_data$away_team[spread_data$away_team=="Morgan State"] <- "Morgan St."
  spread_data$home_team[spread_data$home_team=="Morgan State"] <- "Morgan St."
  spread_data$away_team[spread_data$away_team=="Montana State"] <- "Montana St."
  spread_data$home_team[spread_data$home_team=="Montana State"] <- "Montana St."
  spread_data$away_team[spread_data$away_team=="Missouri State"] <- "Missouri St."
  spread_data$home_team[spread_data$home_team=="Missouri State"] <- "Missouri St."
  spread_data$away_team[spread_data$away_team=="Miami Ohio"] <- "Miami OH"
  spread_data$home_team[spread_data$home_team=="Miami Ohio"] <- "Miami OH"
  spread_data$away_team[spread_data$away_team=="MD Eastern Shore"] <- "Maryland Eastern Shore"
  spread_data$home_team[spread_data$home_team=="MD Eastern Shore"] <- "Maryland Eastern Shore"
  spread_data$away_team[spread_data$away_team=="Long Beach State"] <- "Long Beach St."
  spread_data$home_team[spread_data$home_team=="Long Beach State"] <- "Long Beach St."
  spread_data$away_team[spread_data$away_team=="Kent State"] <- "Kent St."
  spread_data$home_team[spread_data$home_team=="Kent State"] <- "Kent St."
  spread_data$away_team[spread_data$away_team=="Jackson State"] <- "Jackson St."
  spread_data$home_team[spread_data$home_team=="Jackson State"] <- "Jackson St."
  spread_data$away_team[spread_data$away_team=="Indiana State"] <- "Indiana St."
  spread_data$home_team[spread_data$home_team=="Indiana State"] <- "Indiana St."
  spread_data$away_team[spread_data$away_team=="Illinois State"] <- "Illinois St."
  spread_data$home_team[spread_data$home_team=="Illinois State"] <- "Illinois St."
  spread_data$away_team[spread_data$away_team=="Idaho State"] <- "Idaho St."
  spread_data$home_team[spread_data$home_team=="Idaho State"] <- "Idaho St."
  spread_data$away_team[spread_data$away_team=="Grambling"] <- "Grambling St."
  spread_data$home_team[spread_data$home_team=="Grambling"] <- "Grambling St."
  spread_data$away_team[spread_data$away_team=="Florida AM"] <- "Florida A&M"
  spread_data$home_team[spread_data$home_team=="Florida AM"] <- "Florida A&M"
  spread_data$away_team[spread_data$away_team=="Delaware State"] <- "Delaware St."
  spread_data$home_team[spread_data$home_team=="Delaware State"] <- "Delaware St."
  spread_data$away_team[spread_data$away_team=="CS Fullerton"] <- "Cal St. Fullerton"
  spread_data$home_team[spread_data$home_team=="CS Fullerton"] <- "Cal St. Fullerton"
  spread_data$away_team[spread_data$away_team=="Coppin State"] <- "Coppin St."
  spread_data$home_team[spread_data$home_team=="Coppin State"] <- "Coppin St."
  spread_data$away_team[spread_data$away_team=="Chicago State"] <- "Chicago St."
  spread_data$home_team[spread_data$home_team=="Chicago State"] <- "Chicago St."
  spread_data$away_team[spread_data$away_team=="Charleston Sou"] <- "Charleston Southern"
  spread_data$home_team[spread_data$home_team=="Charleston Sou"] <- "Charleston Southern"
  spread_data$away_team[spread_data$away_team=="California Baptist"] <- "Cal Baptist"
  spread_data$home_team[spread_data$home_team=="California Baptist"] <- "Cal Baptist"
  spread_data$away_team[spread_data$away_team=="Cal Santa Barbara"] <- "UC Santa Barbara"
  spread_data$home_team[spread_data$home_team=="Cal Santa Barbara"] <- "UC Santa Barbara"
  spread_data$away_team[spread_data$away_team=="Cal Poly SLO"] <- "Cal Poly"
  spread_data$home_team[spread_data$home_team=="Cal Poly SLO"] <- "Cal Poly"
  spread_data$away_team[spread_data$away_team=="Boston U"] <- "Boston University"
  spread_data$home_team[spread_data$home_team=="Boston U"] <- "Boston University"
  spread_data$away_team[spread_data$away_team=="Boise State"] <- "Boise St."
  spread_data$home_team[spread_data$home_team=="Boise State"] <- "Boise St."
  spread_data$away_team[spread_data$away_team=="Ball State"] <- "Ball St."
  spread_data$home_team[spread_data$home_team=="Ball State"] <- "Ball St."
  spread_data$away_team[spread_data$away_team=="Arizona State"] <- "Arizona St."
  spread_data$home_team[spread_data$home_team=="Arizona State"] <- "Arizona St."
  spread_data$away_team[spread_data$away_team=="Alcorn State"] <- "Alcorn St."
  spread_data$home_team[spread_data$home_team=="Alcorn State"] <- "Alcorn St."
  spread_data$away_team[spread_data$away_team=="Alabama State"] <- "Alabama St."
  spread_data$home_team[spread_data$home_team=="Alabama State"] <- "Alabama St."
  spread_data$away_team[spread_data$away_team=="Alabama AM"] <- "Alabama A&M"
  spread_data$home_team[spread_data$home_team=="Alabama AM"] <- "Alabama A&M"
  spread_data$away_team[spread_data$away_team=="St. Josephs"] <- "Saint Joseph's"
  spread_data$home_team[spread_data$home_team=="St. Josephs"] <- "Saint Joseph's"
  spread_data$away_team[spread_data$away_team=="East Tenn State"] <- "East Tennessee St."
  spread_data$home_team[spread_data$home_team=="East Tenn State"] <- "East Tennessee St."
  spread_data$away_team[spread_data$away_team=="Arkansas State"] <- "Arkansas St."
  spread_data$home_team[spread_data$home_team=="Arkansas State"] <- "Arkansas St."
  spread_data$away_team[spread_data$away_team=="St. Johns"] <- "St. John's"
  spread_data$home_team[spread_data$home_team=="St. Johns"] <- "St. John's"
  spread_data$away_team[spread_data$away_team=="MD Baltimore Co"] <- "UMBC"
  spread_data$home_team[spread_data$home_team=="MD Baltimore Co"] <- "UMBC"
  spread_data$away_team[spread_data$away_team=="Long Island"] <- "LIU"
  spread_data$home_team[spread_data$home_team=="Long Island"] <- "LIU"
  spread_data$away_team[spread_data$away_team=="Texas San Antonio"] <- "UTSA"
  spread_data$home_team[spread_data$home_team=="Texas San Antonio"] <- "UTSA"
  spread_data$away_team[spread_data$away_team=="Northwestern State"] <- "Northwestern St."
  spread_data$home_team[spread_data$home_team=="Northwestern State"] <- "Northwestern St."
  spread_data$away_team[spread_data$away_team=="Northwestern St"] <- "Northwestern St."
  spread_data$home_team[spread_data$home_team=="Northwestern St"] <- "Northwestern St."
  spread_data$away_team[spread_data$away_team=="NC Wilmington"] <- "UNC Wilmington"
  spread_data$home_team[spread_data$home_team=="NC Wilmington"] <- "UNC Wilmington"
  spread_data$away_team[spread_data$away_team=="Oklahoma State"] <- "Oklahoma St."
  spread_data$home_team[spread_data$home_team=="Oklahoma State"] <- "Oklahoma St."
  spread_data$away_team[spread_data$away_team=="Kansas State"] <- "Kansas St."
  spread_data$home_team[spread_data$home_team=="Kansas State"] <- "Kansas St."
  spread_data$away_team[spread_data$away_team=="Iowa State"] <- "Iowa St."
  spread_data$home_team[spread_data$home_team=="Iowa State"] <- "Iowa St."
  spread_data$away_team[spread_data$away_team=="Penn State"] <- "Penn St."
  spread_data$home_team[spread_data$home_team=="Penn State"] <- "Penn St."
  spread_data$away_team[spread_data$away_team=="Texas AM"] <- "Texas A&M"
  spread_data$home_team[spread_data$home_team=="Texas AM"] <- "Texas A&M"
  spread_data$away_team[spread_data$away_team=="Texas AM Corpus"] <- "Texas A&M Corpus Chris"
  spread_data$home_team[spread_data$home_team=="Texas AM Corpus"] <- "Texas A&M Corpus Chris"
  spread_data$away_team[spread_data$away_team=="Florida State"] <- "Florida St."
  spread_data$home_team[spread_data$home_team=="Florida State"] <- "Florida St."
  spread_data$away_team[spread_data$away_team=="Mississippi Valley State"] <- "Mississippi Valley St."
  spread_data$home_team[spread_data$home_team=="Mississippi Valley State"] <- "Mississippi Valley St."
  spread_data$away_team[spread_data$away_team=="Ark Pine Bluff"] <- "Arkansas Pine Bluff"
  spread_data$home_team[spread_data$home_team=="Ark Pine Bluff"] <- "Arkansas Pine Bluff"
  spread_data$away_team[spread_data$away_team=="Sam Houston St"] <- "Sam Houston St."
  spread_data$home_team[spread_data$home_team=="Sam Houston St"] <- "Sam Houston St."
  spread_data$away_team[spread_data$away_team=="McNeese State"] <- "McNeese St."
  spread_data$home_team[spread_data$home_team=="McNeese State"] <- "McNeese St."
  spread_data$away_team[spread_data$away_team=="Charlotte U"] <- "Charlotte"
  spread_data$home_team[spread_data$home_team=="Charlotte U"] <- "Charlotte"
  spread_data$away_team[spread_data$away_team=="Middle Tenn St"] <- "Middle Tennessee"
  spread_data$home_team[spread_data$home_team=="Middle Tenn St"] <- "Middle Tennessee"
  spread_data$away_team[spread_data$away_team=="Cal Riverside"] <- "UC Riverside"
  spread_data$home_team[spread_data$home_team=="Cal Riverside"] <- "UC Riverside"
  spread_data$away_team[spread_data$away_team=="Mississippi State"] <- "Mississippi St."
  spread_data$home_team[spread_data$home_team=="Mississippi State"] <- "Mississippi St."
  spread_data$away_team[spread_data$away_team=="Depaul"] <- "DePaul"
  spread_data$home_team[spread_data$home_team=="Depaul"] <- "DePaul"
  spread_data$away_team[spread_data$away_team=="North Dakota State"] <- "North Dakota St."
  spread_data$home_team[spread_data$home_team=="North Dakota State"] <- "North Dakota St."
  spread_data$away_team[spread_data$away_team=="Florida Intl"] <- "FIU"
  spread_data$home_team[spread_data$home_team=="Florida Intl"] <- "FIU"
  spread_data$away_team[spread_data$away_team=="Albany NY"] <- "Albany"
  spread_data$home_team[spread_data$home_team=="Albany NY"] <- "Albany"
  spread_data$away_team[spread_data$away_team=="SE Louisiana"] <- "Southeastern Louisiana"
  spread_data$home_team[spread_data$home_team=="SE Louisiana"] <- "Southeastern Louisiana"
  spread_data$away_team[spread_data$away_team=="CS Bakersfield"] <- "Cal St. Bakersfield"
  spread_data$home_team[spread_data$home_team=="CS Bakersfield"] <- "Cal St. Bakersfield"
  spread_data$away_team[spread_data$away_team=="NC Greensboro"] <- "UNC Greensboro"
  spread_data$home_team[spread_data$home_team=="NC Greensboro"] <- "UNC Greensboro"
  spread_data$away_team[spread_data$away_team=="IPFW"] <- "Purdue Fort Wayne"
  spread_data$home_team[spread_data$home_team=="IPFW"] <- "Purdue Fort Wayne"
  spread_data$away_team[spread_data$away_team=="South Dakota State"] <- "South Dakota St."
  spread_data$home_team[spread_data$home_team=="South Dakota State"] <- "South Dakota St."
  spread_data$away_team[spread_data$away_team=="CS Northridge"] <- "Cal St. Northridge"
  spread_data$home_team[spread_data$home_team=="CS Northridge"] <- "Cal St. Northridge"
  spread_data$away_team[spread_data$away_team=="Sacramento State"] <- "Sacramento St."
  spread_data$home_team[spread_data$home_team=="Sacramento State"] <- "Sacramento St."
  spread_data$away_team[spread_data$away_team=="Miami FL"] <- "Miami FL"
  spread_data$home_team[spread_data$home_team=="Miami FL"] <- "Miami FL"
  spread_data$away_team[spread_data$away_team=="Miami Florida"] <- "Miami FL"
  spread_data$home_team[spread_data$home_team=="Miami Florida"] <- "Miami FL"
  spread_data$away_team[spread_data$away_team=="UL - Lafayette"] <- "Louisiana"
  spread_data$home_team[spread_data$home_team=="UL - Lafayette"] <- "Louisiana"
  spread_data$away_team[spread_data$away_team=="St. Francis (PA)"] <- "St. Francis PA"
  spread_data$home_team[spread_data$home_team=="St. Francis (PA)"] <- "St. Francis PA"
  spread_data$away_team[spread_data$away_team=="Saint Marys CA"] <- "Saint Mary's"
  spread_data$home_team[spread_data$home_team=="Saint Marys CA"] <- "Saint Mary's"
  spread_data$away_team[spread_data$away_team=="Central Florida"] <- "UCF"
  spread_data$home_team[spread_data$home_team=="Central Florida"] <- "UCF"
  spread_data$away_team[spread_data$away_team=="Coll Of Charleston"] <- "Charleston"
  spread_data$home_team[spread_data$home_team=="Coll Of Charleston"] <- "Charleston"
  spread_data$away_team[spread_data$away_team=="Michigan State"] <- "Michigan St."
  spread_data$home_team[spread_data$home_team=="Michigan State"] <- "Michigan St."
  spread_data$away_team[spread_data$away_team=="William  Mary"] <- "William & Mary"
  spread_data$home_team[spread_data$home_team=="William  Mary"] <- "William & Mary"
  spread_data$away_team[spread_data$away_team=="south Dakota"] <- "South Dakota"
  spread_data$home_team[spread_data$home_team=="south Dakota"] <- "South Dakota"
  spread_data$away_team[spread_data$away_team=="Appalachian State"] <- "Appalachian St."
  spread_data$home_team[spread_data$home_team=="Appalachian State"] <- "Appalachian St."
  spread_data$away_team[spread_data$away_team=="Wright State"] <- "Wright St."
  spread_data$home_team[spread_data$home_team=="Wright State"] <- "Wright St."
  spread_data$away_team[spread_data$away_team=="So Carolina St"] <- "South Carolina St."
  spread_data$home_team[spread_data$home_team=="So Carolina St"] <- "South Carolina St."
  spread_data$away_team[spread_data$away_team=="Texas State"] <- "Texas St."
  spread_data$home_team[spread_data$home_team=="Texas State"] <- "Texas St."
  spread_data$away_team[spread_data$away_team=="IPFW"] <- "Purdue Fort Wayne"
  spread_data$home_team[spread_data$home_team=="IPFW"] <- "Purdue Fort Wayne"
  spread_data$away_team[spread_data$away_team=="Albany NY"] <- "Albany"
  spread_data$home_team[spread_data$home_team=="Albany NY"] <- "Albany"
  spread_data$away_team[spread_data$away_team=="Georgia State"] <- "Georgia St."
  spread_data$home_team[spread_data$home_team=="Georgia State"] <- "Georgia St."
  
  ##################################################################
  
  summary <- html_nodes(page_to_scrape, ".oddsOpener div")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  spread_data$aspread_open <- clean
  
  summary <- html_nodes(page_to_scrape, ".alignCenter+ .bookColumn div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_1 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(8) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_2 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(9) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_3 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(10) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_4 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(11) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_5 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(12) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_6 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(13) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_7 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(14) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_8 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(15) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_9 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(16) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_10 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(17) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_11 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(18) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_12 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(19) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_13 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(20) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_14 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(21) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_15 <- clean
  
  summary <- html_nodes(page_to_scrape, "tr:nth-child(2) h3") #TODO save the name of the book with the best spread
  clean <- html_text(summary)
  
  all_spreads <- data.frame(aspread_close_1
                            , aspread_close_2
                            , aspread_close_3
                            , aspread_close_4
                            , aspread_close_5
                            , aspread_close_6
                            , aspread_close_7, aspread_close_8, aspread_close_9
                            , aspread_close_10
                            , aspread_close_11
                            , aspread_close_12
                            , aspread_close_13
                            , aspread_close_14
                            , aspread_close_15
  )
  
  spread_data$aspread_close <- as.numeric(rowMedians(as.matrix(all_spreads), na.rm = TRUE)) # find the best spread
  spread_data$aspread_close[spread_data$aspread_close == -Inf] <- NA
  
  spread_data
  
  write.table(spread_data, "spreads.csv", sep = ",", col.names = !file.exists("spreads.csv"), append = T, row.names=FALSE)
  
  # scrape yesterday results
  
  results_data <- NULL
  
  target_date <- Sys.Date()-1
  
  page_to_scrape <- read_html(paste("https://www.donbest.com/ncaab/odds/spreads/",format(target_date, "%Y%m%d"),".html",sep=""))
  summary <- html_nodes(page_to_scrape, ".alignLeft+ .alignCenter div")
  clean <- html_text(summary)
  results_data <- data.frame("game_time" = clean)
  
  results_data$date <- target_date
  
  summary <- html_nodes(page_to_scrape, "nobr:nth-child(1) .oddsTeamWLink")
  clean <- html_text(summary)
  results_data$away_team <- clean
  
  summary <- html_nodes(page_to_scrape, "br+ nobr .oddsTeamWLink")
  clean <- html_text(summary)
  results_data$home_team <- clean
  
  #####       cleaning up team names to match KenPom         #######
  results_data$away_team[results_data$away_team=="Youngstown State"] <- "Youngstown St."
  results_data$home_team[results_data$home_team=="Youngstown State"] <- "Youngstown St."
  results_data$away_team[results_data$away_team=="Wisc Green Bay"] <- "Green Bay"
  results_data$home_team[results_data$home_team=="Wisc Green Bay"] <- "Green Bay"
  results_data$away_team[results_data$away_team=="Wichita State"] <- "Wichita St."
  results_data$home_team[results_data$home_team=="Wichita State"] <- "Wichita St."
  results_data$away_team[results_data$away_team=="Weber State"] <- "Weber St."
  results_data$home_team[results_data$home_team=="Weber State"] <- "Weber St."
  results_data$away_team[results_data$away_team=="Washington State"] <- "Washington St."
  results_data$home_team[results_data$home_team=="Washington State"] <- "Washington St."
  results_data$away_team[results_data$away_team=="Va Commonwealth"] <- "VCU"
  results_data$home_team[results_data$home_team=="Va Commonwealth"] <- "VCU"
  results_data$away_team[results_data$away_team=="Utah State"] <- "Utah St."
  results_data$home_team[results_data$home_team=="Utah State"] <- "Utah St."
  results_data$away_team[results_data$away_team=="Tennessee State"] <- "Tennessee St."
  results_data$home_team[results_data$home_team=="Tennessee State"] <- "Tennessee St."
  results_data$away_team[results_data$away_team=="St. Peter's"] <- "Saint Peter's"
  results_data$home_team[results_data$home_team=="St. Peter's"] <- "Saint Peter's"
  results_data$away_team[results_data$away_team=="Seattle U"] <- "Seattle"
  results_data$home_team[results_data$home_team=="Seattle U"] <- "Seattle"
  results_data$away_team[results_data$away_team=="San Diego State"] <- "San Diego St."
  results_data$home_team[results_data$home_team=="San Diego State"] <- "San Diego St."
  results_data$away_team[results_data$away_team=="Prairie View AM"] <- "Prairie View A&M"
  results_data$home_team[results_data$home_team=="Prairie View AM"] <- "Prairie View A&M"
  results_data$away_team[results_data$away_team=="Portland State"] <- "Portland St."
  results_data$home_team[results_data$home_team=="Portland State"] <- "Portland St."
  results_data$away_team[results_data$away_team=="Pennsylvania"] <- "Penn"
  results_data$home_team[results_data$home_team=="Pennsylvania"] <- "Penn"
  results_data$away_team[results_data$away_team=="Oregon State"] <- "Oregon St."
  results_data$home_team[results_data$home_team=="Oregon State"] <- "Oregon St."
  results_data$away_team[results_data$away_team=="Ohio State"] <- "Ohio St."
  results_data$home_team[results_data$home_team=="Ohio State"] <- "Ohio St."
  results_data$away_team[results_data$away_team=="North Carolina AT"] <- "North Carolina A&T"
  results_data$home_team[results_data$home_team=="North Carolina AT"] <- "North Carolina A&T"
  results_data$away_team[results_data$away_team=="Norfolk State"] <- "Norfolk St."
  results_data$home_team[results_data$home_team=="Norfolk State"] <- "Norfolk St."
  results_data$away_team[results_data$away_team=="No. Colorado"] <- "Northern Colorado"
  results_data$home_team[results_data$home_team=="No. Colorado"] <- "Northern Colorado"
  results_data$away_team[results_data$away_team=="New Mexico State"] <- "New Mexico St."
  results_data$home_team[results_data$home_team=="New Mexico State"] <- "New Mexico St."
  results_data$away_team[results_data$away_team=="NC State"] <- "N.C. State"
  results_data$home_team[results_data$home_team=="NC State"] <- "N.C. State"
  results_data$away_team[results_data$away_team=="NC Asheville"] <- "UNC Asheville"
  results_data$home_team[results_data$home_team=="NC Asheville"] <- "UNC Asheville"
  results_data$away_team[results_data$away_team=="Murray State"] <- "Murray St."
  results_data$home_team[results_data$home_team=="Murray State"] <- "Murray St."
  results_data$away_team[results_data$away_team=="Morgan State"] <- "Morgan St."
  results_data$home_team[results_data$home_team=="Morgan State"] <- "Morgan St."
  results_data$away_team[results_data$away_team=="Montana State"] <- "Montana St."
  results_data$home_team[results_data$home_team=="Montana State"] <- "Montana St."
  results_data$away_team[results_data$away_team=="Missouri State"] <- "Missouri St."
  results_data$home_team[results_data$home_team=="Missouri State"] <- "Missouri St."
  results_data$away_team[results_data$away_team=="Miami OH"] <- "Miami (OH)"
  results_data$home_team[results_data$home_team=="Miami OH"] <- "Miami (OH)"
  results_data$away_team[results_data$away_team=="MD Eastern Shore"] <- "Maryland Eastern Shore"
  results_data$home_team[results_data$home_team=="MD Eastern Shore"] <- "Maryland Eastern Shore"
  results_data$away_team[results_data$away_team=="Long Beach State"] <- "Long Beach St."
  results_data$home_team[results_data$home_team=="Long Beach State"] <- "Long Beach St."
  results_data$away_team[results_data$away_team=="Kent State"] <- "Kent St."
  results_data$home_team[results_data$home_team=="Kent State"] <- "Kent St."
  results_data$away_team[results_data$away_team=="Jackson State"] <- "Jackson St."
  results_data$home_team[results_data$home_team=="Jackson State"] <- "Jackson St."
  results_data$away_team[results_data$away_team=="Indiana State"] <- "Indiana St."
  results_data$home_team[results_data$home_team=="Indiana State"] <- "Indiana St."
  results_data$away_team[results_data$away_team=="Illinois State"] <- "Illinois St."
  results_data$home_team[results_data$home_team=="Illinois State"] <- "Illinois St."
  results_data$away_team[results_data$away_team=="Idaho State"] <- "Idaho St."
  results_data$home_team[results_data$home_team=="Idaho State"] <- "Idaho St."
  results_data$away_team[results_data$away_team=="Grambling"] <- "Grambling St."
  results_data$home_team[results_data$home_team=="Grambling"] <- "Grambling St."
  results_data$away_team[results_data$away_team=="Florida AM"] <- "Florida A&M"
  results_data$home_team[results_data$home_team=="Florida AM"] <- "Florida A&M"
  results_data$away_team[results_data$away_team=="Delaware State"] <- "Delaware St."
  results_data$home_team[results_data$home_team=="Delaware State"] <- "Delaware St."
  results_data$away_team[results_data$away_team=="CS Fullerton"] <- "Cal St. Fullerton"
  results_data$home_team[results_data$home_team=="CS Fullerton"] <- "Cal St. Fullerton"
  results_data$away_team[results_data$away_team=="Coppin State"] <- "Coppin St."
  results_data$home_team[results_data$home_team=="Coppin State"] <- "Coppin St."
  results_data$away_team[results_data$away_team=="Chicago State"] <- "Chicago St."
  results_data$home_team[results_data$home_team=="Chicago State"] <- "Chicago St."
  results_data$away_team[results_data$away_team=="Charleston Sou"] <- "Charleston Southern"
  results_data$home_team[results_data$home_team=="Charleston Sou"] <- "Charleston Southern"
  results_data$away_team[results_data$away_team=="California Baptist"] <- "Cal Baptist"
  results_data$home_team[results_data$home_team=="California Baptist"] <- "Cal Baptist"
  results_data$away_team[results_data$away_team=="Cal Santa Barbara"] <- "UC Santa Barbara"
  results_data$home_team[results_data$home_team=="Cal Santa Barbara"] <- "UC Santa Barbara"
  results_data$away_team[results_data$away_team=="Cal Poly SLO"] <- "Cal Poly"
  results_data$home_team[results_data$home_team=="Cal Poly SLO"] <- "Cal Poly"
  results_data$away_team[results_data$away_team=="Boston U"] <- "Boston University"
  results_data$home_team[results_data$home_team=="Boston U"] <- "Boston University"
  results_data$away_team[results_data$away_team=="Boise State"] <- "Boise St."
  results_data$home_team[results_data$home_team=="Boise State"] <- "Boise St."
  results_data$away_team[results_data$away_team=="Ball State"] <- "Ball St."
  results_data$home_team[results_data$home_team=="Ball State"] <- "Ball St."
  results_data$away_team[results_data$away_team=="Arizona State"] <- "Arizona St."
  results_data$home_team[results_data$home_team=="Arizona State"] <- "Arizona St."
  results_data$away_team[results_data$away_team=="Alcorn State"] <- "Alcorn St."
  results_data$home_team[results_data$home_team=="Alcorn State"] <- "Alcorn St."
  results_data$away_team[results_data$away_team=="Alabama State"] <- "Alabama St."
  results_data$home_team[results_data$home_team=="Alabama State"] <- "Alabama St."
  results_data$away_team[results_data$away_team=="Alabama AM"] <- "Alabama A&M"
  results_data$home_team[results_data$home_team=="Alabama AM"] <- "Alabama A&M"
  results_data$away_team[results_data$away_team=="Miami Ohio"] <- "Miami OH"
  results_data$home_team[results_data$home_team=="Miami Ohio"] <- "Miami OH"
  results_data$away_team[results_data$away_team=="Miami Florida"] <- "Miami FL"
  results_data$home_team[results_data$home_team=="Miami Florida"] <- "Miami FL"
  results_data$away_team[results_data$away_team=="St. Josephs"] <- "Saint Joseph's"
  results_data$home_team[results_data$home_team=="St. Josephs"] <- "Saint Joseph's"
  results_data$away_team[results_data$away_team=="East Tenn State"] <- "East Tennessee St."
  results_data$home_team[results_data$home_team=="East Tenn State"] <- "East Tennessee St."
  results_data$away_team[results_data$away_team=="Arkansas State"] <- "Arkansas St."
  results_data$home_team[results_data$home_team=="Arkansas State"] <- "Arkansas St."
  results_data$away_team[results_data$away_team=="St. Johns"] <- "St. John's (NY)"
  results_data$home_team[results_data$home_team=="St. Johns"] <- "St. John's (NY)"
  results_data$away_team[results_data$away_team=="MD Baltimore Co"] <- "UMBC"
  results_data$home_team[results_data$home_team=="MD Baltimore Co"] <- "UMBC"
  results_data$away_team[results_data$away_team=="Long Island"] <- "LIU"
  results_data$home_team[results_data$home_team=="Long Island"] <- "LIU"
  results_data$away_team[results_data$away_team=="Texas San Antonio"] <- "UTSA"
  results_data$home_team[results_data$home_team=="Texas San Antonio"] <- "UTSA"
  results_data$away_team[results_data$away_team=="Northwestern State"] <- "Northwestern St."
  results_data$home_team[results_data$home_team=="Northwestern State"] <- "Northwestern St."
  results_data$away_team[results_data$away_team=="Northwestern St"] <- "Northwestern St."
  results_data$home_team[results_data$home_team=="Northwestern St"] <- "Northwestern St."
  results_data$away_team[results_data$away_team=="NC Wilmington"] <- "UNC Wilmington"
  results_data$home_team[results_data$home_team=="NC Wilmington"] <- "UNC Wilmington"
  results_data$away_team[results_data$away_team=="Oklahoma State"] <- "Oklahoma St."
  results_data$home_team[results_data$home_team=="Oklahoma State"] <- "Oklahoma St."
  results_data$away_team[results_data$away_team=="Kansas State"] <- "Kansas St."
  results_data$home_team[results_data$home_team=="Kansas State"] <- "Kansas St."
  results_data$away_team[results_data$away_team=="Iowa State"] <- "Iowa St."
  results_data$home_team[results_data$home_team=="Iowa State"] <- "Iowa St."
  results_data$away_team[results_data$away_team=="Penn State"] <- "Penn St."
  results_data$home_team[results_data$home_team=="Penn State"] <- "Penn St."
  results_data$away_team[results_data$away_team=="Texas AM"] <- "Texas A&M"
  results_data$home_team[results_data$home_team=="Texas AM"] <- "Texas A&M"
  results_data$away_team[results_data$away_team=="Texas AM Corpus"] <- "Texas A&M Corpus Chris"
  results_data$home_team[results_data$home_team=="Texas AM Corpus"] <- "Texas A&M Corpus Chris"
  results_data$away_team[results_data$away_team=="Florida State"] <- "Florida St."
  results_data$home_team[results_data$home_team=="Florida State"] <- "Florida St."
  results_data$away_team[results_data$away_team=="Mississippi Valley State"] <- "Mississippi Valley St."
  results_data$home_team[results_data$home_team=="Mississippi Valley State"] <- "Mississippi Valley St."
  results_data$away_team[results_data$away_team=="Ark Pine Bluff"] <- "Arkansas Pine Bluff"
  results_data$home_team[results_data$home_team=="Ark Pine Bluff"] <- "Arkansas Pine Bluff"
  results_data$away_team[results_data$away_team=="Sam Houston St"] <- "Sam Houston St."
  results_data$home_team[results_data$home_team=="Sam Houston St"] <- "Sam Houston St."
  results_data$away_team[results_data$away_team=="McNeese State"] <- "McNeese St."
  results_data$home_team[results_data$home_team=="McNeese State"] <- "McNeese St."
  results_data$away_team[results_data$away_team=="Charlotte U"] <- "Charlotte"
  results_data$home_team[results_data$home_team=="Charlotte U"] <- "Charlotte"
  results_data$away_team[results_data$away_team=="Middle Tenn St"] <- "Middle Tennessee"
  results_data$home_team[results_data$home_team=="Middle Tenn St"] <- "Middle Tennessee"
  results_data$away_team[results_data$away_team=="Cal Riverside"] <- "UC Riverside"
  results_data$home_team[results_data$home_team=="Cal Riverside"] <- "UC Riverside"
  results_data$away_team[results_data$away_team=="Mississippi State"] <- "Mississippi St."
  results_data$home_team[results_data$home_team=="Mississippi State"] <- "Mississippi St."
  results_data$away_team[results_data$away_team=="Depaul"] <- "DePaul"
  results_data$home_team[results_data$home_team=="Depaul"] <- "DePaul"
  results_data$away_team[results_data$away_team=="North Dakota State"] <- "North Dakota St."
  results_data$home_team[results_data$home_team=="North Dakota State"] <- "North Dakota St."
  results_data$away_team[results_data$away_team=="Florida Intl"] <- "FIU"
  results_data$home_team[results_data$home_team=="Florida Intl"] <- "FIU"
  results_data$away_team[results_data$away_team=="Albany NY"] <- "Albany"
  results_data$home_team[results_data$home_team=="Albany NY"] <- "Albany"
  results_data$away_team[results_data$away_team=="SE Louisiana"] <- "Southeastern Louisiana"
  results_data$home_team[results_data$home_team=="SE Louisiana"] <- "Southeastern Louisiana"
  results_data$away_team[results_data$away_team=="CS Bakersfield"] <- "Cal St. Bakersfield"
  results_data$home_team[results_data$home_team=="CS Bakersfield"] <- "Cal St. Bakersfield"
  results_data$away_team[results_data$away_team=="NC Greensboro"] <- "UNC Greensboro"
  results_data$home_team[results_data$home_team=="NC Greensboro"] <- "UNC Greensboro"
  results_data$away_team[results_data$away_team=="IPFW"] <- "Purdue Fort Wayne"
  results_data$home_team[results_data$home_team=="IPFW"] <- "Purdue Fort Wayne"
  results_data$away_team[results_data$away_team=="South Dakota State"] <- "South Dakota St."
  results_data$home_team[results_data$home_team=="South Dakota State"] <- "South Dakota St."
  results_data$away_team[results_data$away_team=="CS Northridge"] <- "Cal St. Northridge"
  results_data$home_team[results_data$home_team=="CS Northridge"] <- "Cal St. Northridge"
  results_data$away_team[results_data$away_team=="Sacramento State"] <- "Sacramento St."
  results_data$home_team[results_data$home_team=="Sacramento State"] <- "Sacramento St."
  results_data$away_team[results_data$away_team=="Miami (FL)"] <- "Miami FL"
  results_data$home_team[results_data$home_team=="Miami (FL)"] <- "Miami FL"
  results_data$away_team[results_data$away_team=="UL - Lafayette"] <- "Louisiana"
  results_data$home_team[results_data$home_team=="UL - Lafayette"] <- "Louisiana"
  results_data$away_team[results_data$away_team=="St. Francis (PA)"] <- "St. Francis PA"
  results_data$home_team[results_data$home_team=="St. Francis (PA)"] <- "St. Francis PA"
  results_data$away_team[results_data$away_team=="Saint Marys CA"] <- "Saint Mary's"
  results_data$home_team[results_data$home_team=="Saint Marys CA"] <- "Saint Mary's"
  results_data$away_team[results_data$away_team=="Central Florida"] <- "UCF"
  results_data$home_team[results_data$home_team=="Central Florida"] <- "UCF"
  results_data$away_team[results_data$away_team=="Coll Of Charleston"] <- "Charleston"
  results_data$home_team[results_data$home_team=="Coll Of Charleston"] <- "Charleston"
  results_data$away_team[results_data$away_team=="Michigan State"] <- "Michigan St."
  results_data$home_team[results_data$home_team=="Michigan State"] <- "Michigan St."
  results_data$away_team[results_data$away_team=="William  Mary"] <- "William & Mary"
  results_data$home_team[results_data$home_team=="William  Mary"] <- "William & Mary"
  results_data$away_team[results_data$away_team=="south Dakota"] <- "South Dakota"
  results_data$home_team[results_data$home_team=="south Dakota"] <- "South Dakota"
  results_data$away_team[results_data$away_team=="Appalachian State"] <- "Appalachian St."
  results_data$home_team[results_data$home_team=="Appalachian State"] <- "Appalachian St."
  results_data$away_team[results_data$away_team=="Wright State"] <- "Wright St."
  results_data$home_team[results_data$home_team=="Wright State"] <- "Wright St."
  results_data$away_team[results_data$away_team=="So Carolina St"] <- "South Carolina St."
  results_data$home_team[results_data$home_team=="So Carolina St"] <- "South Carolina St."
  results_data$away_team[results_data$away_team=="Texas State"] <- "Texas St."
  results_data$home_team[results_data$home_team=="Texas State"] <- "Texas St."
  results_data$away_team[results_data$away_team=="IPFW"] <- "Purdue Fort Wayne"
  results_data$home_team[results_data$home_team=="IPFW"] <- "Purdue Fort Wayne"
  results_data$away_team[results_data$away_team=="Albany NY"] <- "Albany"
  results_data$home_team[results_data$home_team=="Albany NY"] <- "Albany"
  results_data$away_team[results_data$away_team=="Georgia State"] <- "Georgia St."
  results_data$home_team[results_data$home_team=="Georgia State"] <- "Georgia St."
  results_data$away_team[results_data$away_team=="Wright State"] <- "Wright St."
  results_data$home_team[results_data$home_team=="Wright State"] <- "Wright St."
  results_data$away_team[results_data$away_team=="St. John's (NY)"] <- "St. John's"
  results_data$home_team[results_data$home_team=="St. John's (NY)"] <- "St. John's"
  
  ##################################################################
  
  summary <- html_nodes(page_to_scrape, ".oddsOpener div")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  results_data$aspread_open <- clean
  
  ######        determine best spread             ######
  
  summary <- html_nodes(page_to_scrape, ".alignCenter+ .bookColumn div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_1 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(8) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_2 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(9) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_3 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(10) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_4 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(11) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_5 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(12) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_6 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(13) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_7 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(14) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_8 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(15) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_9 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(16) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_10 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(17) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_11 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(18) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_12 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(19) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_13 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(20) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_14 <- clean
  
  summary <- html_nodes(page_to_scrape, ".bookColumn:nth-child(21) div:nth-child(1)")
  clean <- html_text(summary)
  clean <- sub("(\n).*", "", clean)
  clean <- sub("[0-9][0-9][0-9]\\.[0-9]", "", clean)
  clean[clean == "PK"] <- 0
  clean[clean == "--"] <- NA
  clean[clean == "-"] <- NA
  clean <- as.numeric(clean, na.rm = T)
  aspread_close_15 <- clean

  all_spreads <- data.frame(aspread_close_1
                            , aspread_close_2
                            , aspread_close_3
                            , aspread_close_4
                            , aspread_close_5
                            , aspread_close_6
                            , aspread_close_7
                            , aspread_close_8
                            , aspread_close_9
                            , aspread_close_10
                            , aspread_close_11
                            , aspread_close_12
                            , aspread_close_13
                            , aspread_close_14
                            , aspread_close_15
  )
  
  results_data$aspread_close <- as.numeric(rowMedians(as.matrix(all_spreads), na.rm = TRUE)) # find the best spread
  results_data$aspread_close[results_data$aspread_close == -Inf] <- NA
  
  ### 
  
  summary <- html_nodes(page_to_scrape, ".alignCenter~ .alignCenter+ .alignCenter div+ div")
  clean <- trim.space(html_text(summary))
  clean[clean == "FINAL"] <- 1
  clean[clean == ""] <- 0
  clean[clean != 0 & clean != 1] <- 2
  
  results_data$is_final <- as.integer(clean)
    
  summary <- html_nodes(page_to_scrape, ".alignCenter:nth-child(5) div:nth-child(1)")
  clean <- html_text(summary)
  clean[clean == "-"] <- NA
  results_data$ascore <- as.integer(clean)
  
  summary <- html_nodes(page_to_scrape, ".alignCenter:nth-child(5) div:nth-child(2)")
  clean <- html_text(summary)
  clean[clean == "-"] <- NA
  results_data$hscore <- as.integer(clean)
  
  results_data$atotal_margin <- results_data$hscore-results_data$ascore
  results_data$aspread_margin <- results_data$atotal_margin-results_data$aspread_close
  results_data$aspread_result[results_data$aspread_margin < 0] <- "W"
  results_data$aspread_result[results_data$aspread_margin > 0] <- "L"
  results_data$aspread_result[results_data$aspread_margin == 0] <- "P"
  
  results_data
  
  write.table(results_data, "results.csv", sep = ",", col.names = !file.exists("results.csv"), append = T, row.names=FALSE)
  
  # scrape NCAA for neutral site data
  
  ncaa_data <- NULL
  
  target_date <- Sys.Date()
  
  if (target_date == Sys.Date()) {
    page_to_scrape <- read_html("http://stats.ncaa.org/contests/scoreboards?utf8=%E2%9C%93&sport_code=MBB&academic_year=&division=&game_date=&commit=Submit")
  } else {
    page_to_scrape <- read_html(paste("http://stats.ncaa.org/season_divisions/17060/scoreboards?utf8=%E2%9C%93&season_division_id=&game_date="
                                      ,format(target_date, "%m")
                                      ,"%2F"
                                      ,format(target_date, "%d")
                                      ,"%2F"
                                      ,format(target_date, "%Y")
                                      ,"&conference_id=0&tournament_id=&commit=Submit"
                                      , sep=""))
  }
  
  summary <- html_nodes(page_to_scrape, "td~ td+ td .skipMask")
  clean <- html_text(summary)
  clean <- sub("(#[0-9].)", "", clean)
  clean <- trim.space(clean)
  clean <- sub(" \\([0-9].*", "", clean)
  ncaa_data <- data.frame("away_team" = clean, stringsAsFactors=FALSE)
  
  ncaa_data$date <- target_date
  ncaa_data$Season <- as.integer(substring(ncaa_data$date,1,4))
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(2) .skipMask")
  clean <- html_text(summary)
  clean <- sub("(#[0-9].)", "", clean)
  clean <- trim.space(clean)
  clean <- sub(" \\([0-9].*", "", clean)
  ncaa_data$home_team <- clean
  
  #####       cleaning up team names to match KenPom         #######
  ncaa_data$away_team[ncaa_data$away_team=="UConn"] <- "Connecticut"
  ncaa_data$home_team[ncaa_data$home_team=="UConn"] <- "Connecticut"
  ncaa_data$away_team[ncaa_data$away_team=="Boston U."] <- "Boston University"
  ncaa_data$home_team[ncaa_data$home_team=="Boston U."] <- "Boston University"
  ncaa_data$away_team[ncaa_data$away_team=="Eastern Ky."] <- "Eastern Kentucky"
  ncaa_data$home_team[ncaa_data$home_team=="Eastern Ky."] <- "Eastern Kentucky"
  ncaa_data$away_team[ncaa_data$away_team=="Western Mich."] <- "Western Michigan"
  ncaa_data$home_team[ncaa_data$home_team=="Western Mich."] <- "Western Michigan"
  ncaa_data$away_team[ncaa_data$away_team=="UNI"] <- "Northern Iowa"
  ncaa_data$home_team[ncaa_data$home_team=="UNI"] <- "Northern Iowa"
  ncaa_data$away_team[ncaa_data$away_team=="UMES"] <- "Maryland Eastern Shore"
  ncaa_data$home_team[ncaa_data$home_team=="UMES"] <- "Maryland Eastern Shore"
  ncaa_data$away_team[ncaa_data$away_team=="UIC"] <- "Illinois Chicago"
  ncaa_data$home_team[ncaa_data$home_team=="UIC"] <- "Illinois Chicago"
  ncaa_data$away_team[ncaa_data$away_team=="Southern U."] <- "Southern"
  ncaa_data$home_team[ncaa_data$home_team=="Southern U."] <- "Southern"
  ncaa_data$away_team[ncaa_data$away_team=="Southern Ill."] <- "Southern Illinois"
  ncaa_data$home_team[ncaa_data$home_team=="Southern Ill."] <- "Southern Illinois"
  ncaa_data$away_team[ncaa_data$away_team=="Prairie View"] <- "Prairie View A&M"
  ncaa_data$home_team[ncaa_data$home_team=="Prairie View"] <- "Prairie View A&M"
  ncaa_data$away_team[ncaa_data$away_team=="Northern Ill."] <- "Northern Illinois"
  ncaa_data$home_team[ncaa_data$home_team=="Northern Ill."] <- "Northern Illinois"
  ncaa_data$away_team[ncaa_data$away_team=="Northern Colo."] <- "Northern Colorado"
  ncaa_data$home_team[ncaa_data$home_team=="Northern Colo."] <- "Northern Colorado"
  ncaa_data$away_team[ncaa_data$away_team=="Northern Ariz."] <- "Northern Arizona"
  ncaa_data$home_team[ncaa_data$home_team=="Northern Ariz."] <- "Northern Arizona"
  ncaa_data$away_team[ncaa_data$away_team=="NC State"] <- "N.C. State"
  ncaa_data$home_team[ncaa_data$home_team=="NC State"] <- "N.C. State"
  ncaa_data$away_team[ncaa_data$away_team=="N.C. Central"] <- "North Carolina Central"
  ncaa_data$home_team[ncaa_data$home_team=="N.C. Central"] <- "North Carolina Central"
  ncaa_data$away_team[ncaa_data$away_team=="N.C. A&T"] <- "North Carolina A&T"
  ncaa_data$home_team[ncaa_data$home_team=="N.C. A&T"] <- "North Carolina A&T"
  ncaa_data$away_team[ncaa_data$away_team=="Miami (OH)"] <- "Miami OH"
  ncaa_data$home_team[ncaa_data$home_team=="Miami (OH)"] <- "Miami OH"
  ncaa_data$away_team[ncaa_data$away_team=="Miami (FL)"] <- "Miami FL"
  ncaa_data$home_team[ncaa_data$home_team=="Miami (FL)"] <- "Miami FL"
  ncaa_data$away_team[ncaa_data$away_team=="LMU (CA)"] <- "Loyola Marymount"
  ncaa_data$home_team[ncaa_data$home_team=="LMU (CA)"] <- "Loyola Marymount"
  ncaa_data$away_team[ncaa_data$away_team=="LMU"] <- "Loyola Marymount"
  ncaa_data$home_team[ncaa_data$home_team=="LMU"] <- "Loyola Marymount"
  ncaa_data$away_team[ncaa_data$away_team=="Kansas City"] <- "UMKC"
  ncaa_data$home_team[ncaa_data$home_team=="Kansas City"] <- "UMKC"
  ncaa_data$away_team[ncaa_data$away_team=="Grambling"] <- "Grambling St."
  ncaa_data$home_team[ncaa_data$home_team=="Grambling"] <- "Grambling St."
  ncaa_data$away_team[ncaa_data$away_team=="Gardner-Webb"] <- "Gardner Webb"
  ncaa_data$home_team[ncaa_data$home_team=="Gardner-Webb"] <- "Gardner Webb"
  ncaa_data$away_team[ncaa_data$away_team=="Eastern Wash."] <- "Eastern Washington"
  ncaa_data$home_team[ncaa_data$home_team=="Eastern Wash."] <- "Eastern Washington"
  ncaa_data$away_team[ncaa_data$away_team=="Eastern Mich."] <- "Eastern Michigan"
  ncaa_data$home_team[ncaa_data$home_team=="Eastern Mich."] <- "Eastern Michigan"
  ncaa_data$away_team[ncaa_data$away_team=="Eastern Ill."] <- "Eastern Illinois"
  ncaa_data$home_team[ncaa_data$home_team=="Eastern Ill."] <- "Eastern Illinois"
  ncaa_data$away_team[ncaa_data$away_team=="Charleston So."] <- "Charleston Southern"
  ncaa_data$home_team[ncaa_data$home_team=="Charleston So."] <- "Charleston Southern"
  ncaa_data$away_team[ncaa_data$away_team=="Central Mich."] <- "Central Michigan"
  ncaa_data$home_team[ncaa_data$home_team=="Central Mich."] <- "Central Michigan"
  ncaa_data$away_team[ncaa_data$away_team=="California Baptist"] <- "Cal Baptist"
  ncaa_data$home_team[ncaa_data$home_team=="California Baptist"] <- "Cal Baptist"
  ncaa_data$away_team[ncaa_data$away_team=="Army West Point"] <- "Army"
  ncaa_data$home_team[ncaa_data$home_team=="Army West Point"] <- "Army"
  ncaa_data$away_team[ncaa_data$away_team=="Alcorn"] <- "Alcorn St."
  ncaa_data$home_team[ncaa_data$home_team=="Alcorn"] <- "Alcorn St."
  ncaa_data$away_team[ncaa_data$away_team=="ETSU"] <- "East Tennessee St."
  ncaa_data$home_team[ncaa_data$home_team=="ETSU"] <- "East Tennessee St."
  ncaa_data$away_team[ncaa_data$away_team=="Western Caro."] <- "Western Carolina"
  ncaa_data$home_team[ncaa_data$home_team=="Western Caro."] <- "Western Carolina"
  ncaa_data$away_team[ncaa_data$away_team=="Southern California"] <- "USC"
  ncaa_data$home_team[ncaa_data$home_team=="Southern California"] <- "USC"
  ncaa_data$away_team[ncaa_data$away_team=="Central Ark."] <- "Central Arkansas"
  ncaa_data$home_team[ncaa_data$home_team=="Central Ark."] <- "Central Arkansas"
  ncaa_data$away_team[ncaa_data$away_team=="UNCW"] <- "UNC Wilmington"
  ncaa_data$home_team[ncaa_data$home_team=="UNCW"] <- "UNC Wilmington"
  ncaa_data$away_team[ncaa_data$away_team=="A&M-Corpus Christi"] <- "Texas A&M Corpus Chris"
  ncaa_data$home_team[ncaa_data$home_team=="A&M-Corpus Christi"] <- "Texas A&M Corpus Chris"
  ncaa_data$away_team[ncaa_data$away_team=="Ark.-Pine Bluff"] <- "Arkansas Pine Bluff"
  ncaa_data$home_team[ncaa_data$home_team=="Ark.-Pine Bluff"] <- "Arkansas Pine Bluff"
  ncaa_data$away_team[ncaa_data$away_team=="UIW"] <- "Incarnate Word"
  ncaa_data$home_team[ncaa_data$home_team=="UIW"] <- "Incarnate Word"
  ncaa_data$away_team[ncaa_data$away_team=="SFA"] <- "Stephen F. Austin"
  ncaa_data$home_team[ncaa_data$home_team=="SFA"] <- "Stephen F. Austin"
  ncaa_data$away_team[ncaa_data$away_team=="Southern Miss."] <- "Southern Miss"
  ncaa_data$home_team[ncaa_data$home_team=="Southern Miss."] <- "Southern Miss"
  ncaa_data$away_team[ncaa_data$away_team=="Ole Miss"] <- "Mississippi"
  ncaa_data$home_team[ncaa_data$home_team=="Ole Miss"] <- "Mississippi"
  ncaa_data$away_team[ncaa_data$away_team=="Western Ky."] <- "Western Kentucky"
  ncaa_data$home_team[ncaa_data$home_team=="Western Ky."] <- "Western Kentucky"
  ncaa_data$away_team[ncaa_data$away_team=="Southeastern La."] <- "Southeastern Louisiana"
  ncaa_data$home_team[ncaa_data$home_team=="Southeastern La."] <- "Southeastern Louisiana"
  ncaa_data$away_team[ncaa_data$away_team=="South Fla."] <- "South Florida"
  ncaa_data$home_team[ncaa_data$home_team=="South Fla."] <- "South Florida"
  ncaa_data$away_team[ncaa_data$away_team=="UTRGV"] <- "UT Rio Grande Valley"
  ncaa_data$home_team[ncaa_data$home_team=="UTRGV"] <- "UT Rio Grande Valley"
  ncaa_data$away_team[ncaa_data$away_team=="CSU Bakersfield"] <- "Cal St. Bakersfield"
  ncaa_data$home_team[ncaa_data$home_team=="CSU Bakersfield"] <- "Cal St. Bakersfield"
  ncaa_data$away_team[ncaa_data$away_team=="CSUN"] <- "Cal St. Northridge"
  ncaa_data$home_team[ncaa_data$home_team=="CSUN"] <- "Cal St. Northridge"
  ncaa_data$away_team[ncaa_data$away_team=="Saint Mary's (CA)"] <- "Saint Mary's"
  ncaa_data$home_team[ncaa_data$home_team=="Saint Mary's (CA)"] <- "Saint Mary's"
  ncaa_data$away_team[ncaa_data$away_team=="Saint Francis (PA)"] <- "St. Francis PA"
  ncaa_data$home_team[ncaa_data$home_team=="Saint Francis (PA)"] <- "St. Francis PA"
  ncaa_data$away_team[ncaa_data$away_team=="Mississippi Val."] <- "Mississippi Valley St."
  ncaa_data$home_team[ncaa_data$home_team=="Mississippi Val."] <- "Mississippi Valley St."
  ncaa_data$away_team[ncaa_data$away_team=="Lamar University"] <- "Lamar"
  ncaa_data$home_team[ncaa_data$home_team=="Lamar University"] <- "Lamar"
  ncaa_data$away_team[ncaa_data$away_team=="McNeese"] <- "McNeese St."
  ncaa_data$home_team[ncaa_data$home_team=="McNeese"] <- "McNeese St."
  ncaa_data$away_team[ncaa_data$away_team=="Middle Tenn."] <- "Middle Tennessee"
  ncaa_data$home_team[ncaa_data$home_team=="Middle Tenn."] <- "Middle Tennessee"
  ncaa_data$away_team[ncaa_data$away_team=="Col. of Charleston"] <- "Charleston"
  ncaa_data$home_team[ncaa_data$home_team=="Col. of Charleston"] <- "Charleston"
  ncaa_data$away_team[ncaa_data$away_team=="Omaha"] <- "Nebraska Omaha"
  ncaa_data$home_team[ncaa_data$home_team=="Omaha"] <- "Nebraska Omaha"
  ncaa_data$away_team[ncaa_data$away_team=="Omaha"] <- "Nebraska Omaha"
  ncaa_data$home_team[ncaa_data$home_team=="Omaha"] <- "Nebraska Omaha"
  ncaa_data$away_team[ncaa_data$away_team=="Northern Ky."] <- "Northern Kentucky"
  ncaa_data$home_team[ncaa_data$home_team=="Northern Ky."] <- "Northern Kentucky"
  ncaa_data$away_team[ncaa_data$away_team=="Georgia State"] <- "Georgia St."
  ncaa_data$home_team[ncaa_data$home_team=="Georgia State"] <- "Georgia St."
  ncaa_data$away_team[ncaa_data$away_team=="Fla. Atlantic"] <- "Florida Atlantic"
  ncaa_data$home_team[ncaa_data$home_team=="Fla. Atlantic"] <- "Florida Atlantic"
  ncaa_data$away_team[ncaa_data$away_team=="Albany (NY)"] <- "Albany"
  ncaa_data$home_team[ncaa_data$home_team=="Albany (NY)"] <- "Albany"
  ncaa_data$away_team[ncaa_data$away_team=="St. John's (NY)"] <- "St. John's"
  ncaa_data$home_team[ncaa_data$home_team=="St. John's (NY)"] <- "St. John's"
  ncaa_data$away_team[ncaa_data$away_team=="Ga. Southern"] <- "Georgia Southern"
  ncaa_data$home_team[ncaa_data$home_team=="Ga. Southern"] <- "Georgia Southern"
  ncaa_data$away_team[ncaa_data$away_team=="Bethune-Cookman"] <- "Bethune Cookman"
  ncaa_data$home_team[ncaa_data$home_team=="Bethune-Cookman"] <- "Bethune Cookman"
  
  ###################################################################
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(6)")
  clean <- html_text(summary)
  clean <- sub("(\\\n          )", "", clean)
  clean <- sub("(\\\n.*)", "", clean)
  clean[clean != ""] <- 1
  clean[clean == ""] <- 0
  clean <- as.integer(clean)
  ncaa_data$neutral_site <- clean
  
  ncaa_data$daynum <- as.integer(target_date - as.Date("2019-11-05", format="%Y-%m-%d"))
  ncaa_data
  
  write.table(ncaa_data, "neutral_site_games.csv", sep = ",", col.names = !file.exists("neutral_site_games.csv"), append = T, row.names=FALSE)
  
# scrape home court advantages from KenPom
  
  home_court_data <- NULL
  page_to_scrape <- jump_to(session, "https://kenpom.com/hca.php")
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(1) a")
  clean <- html_text(summary)
  home_court_data <- data.frame("team_name" = clean, stringsAsFactors=FALSE)
  
  summary <- html_nodes(page_to_scrape, ".update a")
  clean <- sub(".*([0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]).*", "\\1", summary)
  home_court_data$date <- clean
  
  summary <- html_nodes(page_to_scrape, "td+ td a")
  clean <- html_text(summary)
  home_court_data$conf <- clean
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(3)")
  clean <- html_text(summary)
  home_court_data$hca <- clean
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(4) .seed")
  clean <- html_text(summary)
  home_court_data$hca_rank <- clean
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(5)")
  clean <- html_text(summary)
  home_court_data$pf <- clean
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(6) .seed")
  clean <- html_text(summary)
  home_court_data$pf_rank <- clean
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(7)")
  clean <- html_text(summary)
  home_court_data$pts <- clean
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(8) .seed")
  clean <- html_text(summary)
  home_court_data$pts_rank <- clean
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(9)")
  clean <- html_text(summary)
  home_court_data$nst <- clean
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(10) .seed")
  clean <- html_text(summary)
  home_court_data$nst_rank <- clean
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(11)")
  clean <- html_text(summary)
  home_court_data$blk <- clean
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(12) .seed")
  clean <- html_text(summary)
  home_court_data$blk_rank <- clean
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(13)")
  clean <- html_text(summary)
  home_court_data$elevation <- clean
  
  summary <- html_nodes(page_to_scrape, "td:nth-child(14) .seed")
  clean <- html_text(summary)
  home_court_data$elevation_rank <- clean
  
  home_court_data
  
  write.table(home_court_data, "home_court_advantages.csv", sep = ",", col.names = !file.exists("home_court_advantages.csv"), append = T, row.names=FALSE)
