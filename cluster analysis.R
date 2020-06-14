all_games <- read.csv("all_games.csv")
library(tictoc)
library(caret)
library(randomForest)
library(doParallel)

# data preparation --------------------------------------------------------
# remove rank variables
reduced_games <- subset(all_games, select = -c(a_coach_Def_RankeFG_Pct
                                               , a_coach_Def_RankFT_Rate
                                               , a_coach_Def_RankOR_Pct
                                               , a_coach_Def_RankTO_Pct
                                               , a_coach_RankAdjDE
                                               , a_coach_RankAdjEM
                                               , a_coach_RankAdjOE
                                               , a_coach_RankAdjTempo
                                               , a_coach_RankARate
                                               , a_coach_RankBlockPct
                                               , a_coach_RankDE
                                               , a_coach_RankDef_1
                                               , a_coach_RankDef_2
                                               , a_coach_RankDef_3
                                               , a_coach_RankeFG_Pct
                                               , a_coach_RankFG2Pct
                                               , a_coach_RankFG3Pct
                                               , a_coach_RankFG3Rate
                                               , a_coach_RankFT_Rate
                                               , a_coach_RankFTPct
                                               , a_coach_RankOE
                                               , a_coach_RankOff_1
                                               , a_coach_RankOff_2
                                               , a_coach_RankOff_3
                                               , a_coach_RankOppARate
                                               , a_coach_RankOppBlockPct
                                               , a_coach_RankOppFG2Pct
                                               , a_coach_RankOppFG3Pct
                                               , a_coach_RankOppFG3Rate
                                               , a_coach_RankOppFTPct
                                               , a_coach_RankOppStlRate
                                               , a_coach_RankOR_Pct
                                               , a_coach_RankStlRate
                                               , a_coach_RankTempo
                                               , a_coach_RankTO_Pct
                                               , a_morningof_kprank
                                               , a_morningof_RankAdjTempo
                                               , a_morningof_RankDE
                                               , a_morningof_RankOE
                                               , a_prev_season_BenchRank
                                               , a_prev_season_d_RankeFG_pct
                                               , a_prev_season_d_RankFT_rate
                                               , a_prev_season_d_RankOR_pct
                                               , a_prev_season_d_RankTO_pct
                                               , a_prev_season_DR1Rank
                                               , a_prev_season_DR2Rank
                                               , a_prev_season_DR3Rank
                                               , a_prev_season_DR4Rank
                                               , a_prev_season_DR5Rank
                                               , a_prev_season_ExpRank
                                               , a_prev_season_Hgt1Rank
                                               , a_prev_season_Hgt2Rank
                                               , a_prev_season_Hgt3Rank
                                               , a_prev_season_Hgt4Rank
                                               , a_prev_season_Hgt5Rank
                                               , a_prev_season_HgtEffRank
                                               , a_prev_season_o_RankeFG_pct
                                               , a_prev_season_o_RankFT_rate
                                               , a_prev_season_o_RankOR_pct
                                               , a_prev_season_o_RankTO_pct
                                               , a_prev_season_OR1Rank
                                               , a_prev_season_OR2Rank
                                               , a_prev_season_OR3Rank
                                               , a_prev_season_OR4Rank
                                               , a_prev_season_OR5Rank
                                               , a_prev_season_Pts1Rank
                                               , a_prev_season_Pts2Rank
                                               , a_prev_season_Pts3Rank
                                               , a_prev_season_Pts4Rank
                                               , a_prev_season_Pts5Rank
                                               , a_prev_season_RankAdjDE
                                               , a_prev_season_RankAdjOE
                                               , a_prev_season_RankAdjTempo
                                               , a_prev_season_RankARate
                                               , a_prev_season_RankBlockPct
                                               , a_prev_season_RankDef_1
                                               , a_prev_season_RankDef_2
                                               , a_prev_season_RankDef_3
                                               , a_prev_season_RankF3GRate
                                               , a_prev_season_RankFG2Pct
                                               , a_prev_season_RankFG3Pct
                                               , a_prev_season_RankFTPct
                                               , a_prev_season_RankOff_1
                                               , a_prev_season_RankOff_2
                                               , a_prev_season_RankOff_3
                                               , a_prev_season_RankOppARate
                                               , a_prev_season_RankOppBlockPct
                                               , a_prev_season_RankOppF3GRate
                                               , a_prev_season_RankOppFG2Pct
                                               , a_prev_season_RankOppFG3Pct
                                               , a_prev_season_RankOppFTPct
                                               , a_prev_season_RankOppStlRate
                                               , a_prev_season_RankStlRate
                                               , a_prev_season_SizeRank
                                               , h_coach_Def_RankeFG_Pct
                                               , h_coach_Def_RankFT_Rate
                                               , h_coach_Def_RankOR_Pct
                                               , h_coach_Def_RankTO_Pct
                                               , h_coach_RankAdjDE
                                               , h_coach_RankAdjEM
                                               , h_coach_RankAdjOE
                                               , h_coach_RankAdjTempo
                                               , h_coach_RankARate
                                               , h_coach_RankBlockPct
                                               , h_coach_RankDE
                                               , h_coach_RankDef_1
                                               , h_coach_RankDef_2
                                               , h_coach_RankDef_3
                                               , h_coach_RankeFG_Pct
                                               , h_coach_RankFG2Pct
                                               , h_coach_RankFG3Pct
                                               , h_coach_RankFG3Rate
                                               , h_coach_RankFT_Rate
                                               , h_coach_RankFTPct
                                               , h_coach_RankOE
                                               , h_coach_RankOff_1
                                               , h_coach_RankOff_2
                                               , h_coach_RankOff_3
                                               , h_coach_RankOppARate
                                               , h_coach_RankOppBlockPct
                                               , h_coach_RankOppFG2Pct
                                               , h_coach_RankOppFG3Pct
                                               , h_coach_RankOppFG3Rate
                                               , h_coach_RankOppFTPct
                                               , h_coach_RankOppStlRate
                                               , h_coach_RankOR_Pct
                                               , h_coach_RankStlRate
                                               , h_coach_RankTempo
                                               , h_coach_RankTO_Pct
                                               , h_prev_season_BenchRank
                                               , h_prev_season_d_RankeFG_pct
                                               , h_prev_season_d_RankFT_rate
                                               , h_prev_season_d_RankOR_pct
                                               , h_prev_season_d_RankTO_pct
                                               , h_prev_season_DR1Rank
                                               , h_prev_season_DR2Rank
                                               , h_prev_season_DR3Rank
                                               , h_prev_season_DR4Rank
                                               , h_prev_season_DR5Rank
                                               , h_prev_season_ExpRank
                                               , h_prev_season_Hgt1Rank
                                               , h_prev_season_Hgt2Rank
                                               , h_prev_season_Hgt3Rank
                                               , h_prev_season_Hgt4Rank
                                               , h_prev_season_Hgt5Rank
                                               , h_prev_season_HgtEffRank
                                               , h_prev_season_o_RankeFG_pct
                                               , h_prev_season_o_RankFT_rate
                                               , h_prev_season_o_RankOR_pct
                                               , h_prev_season_o_RankTO_pct
                                               , h_prev_season_OR1Rank
                                               , h_prev_season_OR2Rank
                                               , h_prev_season_OR3Rank
                                               , h_prev_season_OR4Rank
                                               , h_prev_season_OR5Rank
                                               , h_prev_season_Pts1Rank
                                               , h_prev_season_Pts2Rank
                                               , h_prev_season_Pts3Rank
                                               , h_prev_season_Pts4Rank
                                               , h_prev_season_Pts5Rank
                                               , h_prev_season_RankAdjDE
                                               , h_prev_season_RankAdjOE
                                               , h_prev_season_RankAdjTempo
                                               , h_prev_season_RankARate
                                               , h_prev_season_RankBlockPct
                                               , h_prev_season_RankDef_1
                                               , h_prev_season_RankDef_2
                                               , h_prev_season_RankDef_3
                                               , h_prev_season_RankF3GRate
                                               , h_prev_season_RankFG2Pct
                                               , h_prev_season_RankFG3Pct
                                               , h_prev_season_RankFTPct
                                               , h_prev_season_RankOff_1
                                               , h_prev_season_RankOff_2
                                               , h_prev_season_RankOff_3
                                               , h_prev_season_RankOppARate
                                               , h_prev_season_RankOppBlockPct
                                               , h_prev_season_RankOppF3GRate
                                               , h_prev_season_RankOppFG2Pct
                                               , h_prev_season_RankOppFG3Pct
                                               , h_prev_season_RankOppFTPct
                                               , h_prev_season_RankOppStlRate
                                               , h_prev_season_RankStlRate
                                               , h_prev_season_SizeRank
                                               , h_morningof_kprank
                                               , h_morningof_RankOE
                                               , h_morningof_RankDE
                                               , h_morningof_RankAdjTempo
                                               , a_morningof_kprank
                                               , a_morningof_RankOE
                                               , a_morningof_RankDE
                                               , a_morningof_RankAdjTempo
))

# remove results of games
reduced_games <- subset(reduced_games, select = -c(a_score
                                                   , h_score
                                                   , numot
                                                   , a_fgm
                                                   , a_fga
                                                   , a_fgm3
                                                   , a_fga3
                                                   , a_ftm
                                                   , a_fta
                                                   , a_or
                                                   , a_dr
                                                   , a_ast
                                                   , a_to
                                                   , a_stl
                                                   , a_blk
                                                   , a_pf
                                                   , h_fgm
                                                   , h_fga
                                                   , h_fgm3
                                                   , h_fga3
                                                   , h_ftm
                                                   , h_fta
                                                   , h_or
                                                   , h_dr
                                                   , h_ast
                                                   , h_to
                                                   , h_stl
                                                   , h_blk
                                                   , h_pf
                                                   , a_total_margin
                                                   , a_spread_margin
                                                   , a_spread_result))

# remove other misc variables
reduced_games <- subset(reduced_games, select = -c(date
                                                   , h_team_id
                                                   , season # toggle this off if you want to use the season variable
                                                   , a_team_id
                                                   , a_spread_open # removing these two spread vars because there are some missing values
                                                   , a_spread_close))
# coerce some columns into factors
reduced_games$a_school <- as.factor(reduced_games$a_school)
reduced_games$h_school <- as.factor(reduced_games$h_school)
reduced_games$a_coach_coach_id <- as.factor(reduced_games$a_coach_coach_id)
reduced_games$h_coach_coach_id <- as.factor(reduced_games$h_coach_coach_id)

# remove original variables which are being replaced with dummies 
reduced_games <- subset(reduced_games, select = -c(a_school
                                                   , h_school
                                                   , a_coach_coach_id
                                                   , h_coach_coach_id
                                                   , a_Conf
                                                   , h_Conf))

# split trianing and testing
set.seed(1)

training_index <- sample(1:nrow(reduced_games), 0.75*nrow(reduced_games))
train <- reduced_games[training_index,]
test <- reduced_games[-training_index,]

# kmeans clustering
games_w_na <- reduced_games
games_w_na[games_w_na == -69] <- NA
games_w_na_without_y <- subset(games_w_na, select = -c(total_score))
scaled_games_w_na_without_y <- scale(games_w_na_without_y)

summary(scaled_games_w_na_without_y[,"a_morningof_o_TOpct"])

clust <- kmeans(scaled_reduced_games_without_y, centers = 5,
                iter.max = 200,
                nstart = 200)

round(t(clust$centers)[var_imp_order_index,][1:50,],1)
round(clust$size / sum(clust$size),2) 


write.table(round(t(clust$centers)[var_imp_order_index,],2),
            file = "cluster_table.csv",
            sep = ",",
            append = F,
            row.names=T)

### filter cluster centers with top variables from RF analysis

game_cluster <- as.factor(clust$cluster)
train_cluster <- game_cluster[training_index]
test_cluster <- game_cluster[-training_index]
