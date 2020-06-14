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

# visualizations ----------------------------------------------------------

# pie chart
library(ggplot2)

game_type <- c()
game_type[reduced_games$is_conf_rivalry==1] <- "Standard format, in-conference"
game_type[reduced_games$is_conf_rivalry==0] <- "Standard format, non-conference"
game_type[as.logical(reduced_games$is_neutral_site)] <- "Neutral site"
game_type[as.logical(reduced_games$ncaa_tourney)] <- "NCAA Tournament"

table(game_type)/length(game_type)

pie(as.vector(table(game_type)), labels=c("NCAA tournament (1%)",
                                          "Other neutral site (9%)",
                                          "Standard format, in-conf (57%)",
                                          "Standard format, non-conf (33%)"))

#daynum histogram
day_vs_type <- data.frame("Game Format" = game_type, "daynum" = reduced_games$daynum) 

ggplot(data = day_type, aes(x = daynum, fill = game_type)) + 
  geom_histogram(colour = 'white', binwidth = 7) + theme(legend.position="bottom",
                                                         panel.background = element_rect(fill = "white",
                                                                                         colour = "white"))
# total score by game type
plot(density(reduced_games$total_score[game_type=="Standard format, non-conference"]), xlim = c(100,180),  col = "red", lwd = 3, main = "", xlab = "Total Score")
abline(v = mean(reduced_games$total_score[game_type=="Standard format, non-conference"]), col = "red")

lines(density(reduced_games$total_score[game_type=="Standard format, in-conference"]), col = "blue", lwd = 3)
abline(v = mean(reduced_games$total_score[game_type=="Standard format, in-conference"]), col = "blue")

lines(density(reduced_games$total_score[game_type=="Neutral site"]), col = "green", lwd = 3)
abline(v = mean(reduced_games$total_score[game_type=="Neutral site"]), col = "green")

lines(density(reduced_games$total_score[game_type=="NCAA Tournament"]), col = "black", lwd = 3)
abline(v = mean(reduced_games$total_score[game_type=="NCAA Tournament"]), col = "black")

legend(x = "topright",
       legend = c("Standard format, non-conference",
                  "Standard format, in-conference",
                  "Neutral site",
                  "NCAA Tournament"),
       lwd = c(2, 2, 2, 2),
       lty = c(1, 1, 1, 1),
       col = c("red", "blue", "green", "black"))

#boxplot of total scores by season
dev.off()

boxplot(all_games$total_score~all_games$season, xlab = "season", ylab = "Total Score")

# density plot for shot clock 30

plot(density(reduced_games$total_score[reduced_games$shotclock_30==1]), xlim = c(100,180),  col = "red", lwd = 3, main = "", xlab = "Total Score")
abline(v = mean(reduced_games$total_score[reduced_games$shotclock_30==1]), col = "red")

lines(density(reduced_games$total_score[reduced_games$shotclock_30==0]), col = "blue", lwd = 3)
abline(v = mean(reduced_games$total_score[reduced_games$shotclock_30==0]), col = "blue")

legend(x = "topright",
       legend = c("30 second shot clock",
                  "35 second shot clock"),
       lwd = c(2, 2),
       lty = c(1, 1),
       col = c("red", "blue"))

# KP box and whisker plot
games_w_na <- reduced_games
games_w_na[games_w_na[,] == -69] <- NA

box_plot_games <- games_w_na[,c(136,81:111)]
colnames(box_plot_games) <- c("AdjEM", "AdjTempo", "AdjOE", "o_eFG_pct", "o_TO_pct",
                              "o_OR_pct", "o_FT_rate", "AdjDE", "d_eFG_pct", "d_TO_pct",
                              "d_OR_pct", "d_FT_rate", "FG2Pct", "FG3Pct", "FTPct", "BlockPct",
                              "OppFG2Pct", "OppFG3Pct", "OppFTPct", "OppBlockPct", "FG3rate",
                              "OppFG3Rate", "ARate", "OppARate", "StlRate", "OppStlRate", "Off_1",
                              "Off_2", "Off_3", "Def_1", "Def_2", "Def_3")

par(mar=c(7,3,1,1))
boxplot(box_plot_games, las = 2)

boxplot(games_w_na[,c(112:135)], las = 2)

par(mfrow=c(1,3), mar=c(7,3,3,1))
boxplot(games_w_na[,c(121:125)], las = 2, ylim = c(0,40), main = "Portion of Team Points Scored", names = c("Center", "P. Forward", "S. Forward", "S. Guard", "P. Guard"))
boxplot(games_w_na[,c(126:130)], las = 2, ylim = c(0,80), main = "Portion of Team Offensive Rebounds", names = c("Center", "P. Forward", "S. Forward", "S. Guard", "P. Guard"))
boxplot(games_w_na[,c(131:135)], las = 2, ylim = c(0,60), main = "Portion of Team Defensive Rebounds", names = c("Center", "P. Forward", "S. Forward", "S. Guard", "P. Guard"))


bins <- cut(games_w_na$a_prev_season_Exp,seq(0,3,0.2))
table(bins)
par(mfrow=c(1,1), mar=c(5,5,1,1))
boxplot(all_games$a_score ~ bins, las=3, ylab = "Points Scored", xlab ="", ylim = c(20,140))
boxplot(all_games$h_score ~ bins, las=3, ylab = "Points Allowed", xlab ="", ylim = c(20,140))

?boxplot
?par
?rep

# random forest -----------------------------------------------------------

# split trianing and testing

set.seed(1)

training_index <- sample(1:nrow(reduced_games), 0.75*nrow(reduced_games))
train <- reduced_games[training_index,]
test <- reduced_games[-training_index,]

# set cross validation controler
control <- trainControl(method='repeatedcv', 
                        number=5, 
                        repeats=3,
                        allowParallel = T)
tunegrid <- expand.grid(.mtry=213)

# setup parallelizaation
cores_to_use <- detectCores()-1
cl <- makePSOCKcluster(cores_to_use)
registerDoParallel(cl)

tic()
rf <- train(total_score ~ .,
            data=train,
            ntree = 150,
            method='rf', 
            metric='RMSE', 
            tuneGrid=tunegrid, 
            trControl=control)
toc()
stopCluster(cl)

# plot
plot(rf)
dev.off()
plot(1:rf$finalModel$ntree, rf$finalModel$mse^(1/2),
     xlab = "Tree Number",
     ylab = "Cross Validation RMSE",
     pch = 20)
abline(h = 17.5, col = "red", lwd = 3, lty = 2)

# variable importance
varImpPlot(rf$finalModel, main = "")
var_imp_order_index <- order(rf$finalModel$importance, decreasing = TRUE)

is_resid <- train$total_score-rf$finalModel$predicted

dev.off()
plot(rf$finalModel$predicted, train$total_score, ylab = "Total Score", xlab = "Predicted Score")
plot(rf$finalModel$predicted, is_resid, xlab = "Predicted Score", ylab = "Residual Error")

# predict / test ----------------------------------------------------------

pred <- predict(rf, newdata=test)

oos_resid <- test$total_score - pred
test_RMSE <- (mean(oos_resid^2))^(1/2)
test_RMSE

source("calcR2.R")
R2(test$total_score, pred)


dev.off()
plot(pred, test$total_score, ylab = "Total Score", xlab = "Predicted Score")
plot(pred, oos_resid, xlab = "Predicted Score", ylab = "Residual Error")


##### PULL in CLUSTER ANALYSIS
par(mfrow=c(1,2))
plot(pred, test$total_score, pch = 3, col = rainbow(length(levels(test_cluster)))[test_cluster], ylab = "Total Score", xlab = "Predicted Total Score")
plot(pred, resid, pch = 3, col = rainbow(length(levels(test_cluster)))[test_cluster], xlab = "Predicted Total Score", ylab = "Residual")

resid_by_cluster <- data.frame(resid, "resid_sq" = resid^2, test_cluster)

RMSEs <- c()
R2s <- c()
for (i in 1:length(levels(test_cluster))) {
  MSE <- mean(resid_by_cluster$resid_sq[resid_by_cluster[,"test_cluster"]==i])
  RMSE <- MSE^(1/2)
  RMSEs[i] <- RMSE
  R2s[i] <- R2(test$total_score[resid_by_cluster[,"test_cluster"]==i], pred[resid_by_cluster[,"test_cluster"]==i])
}

results_by_cluster <- data.frame("n_test" = table(test_cluster), "RMSE" = round(RMSEs,2), "R2"=R2s)
colnames(results_by_cluster) <- c("cluster", "n", "RMSE", "R2")
results_by_cluster
