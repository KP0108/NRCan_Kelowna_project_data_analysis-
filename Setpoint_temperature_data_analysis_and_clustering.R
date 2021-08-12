setwd("C:\\DYD\\total") ## set the working directory

file.List = list.files(pattern = "*.csv", recursive = F) ## Extracting only the name of the files in the directory

file.List <- as.data.frame(file.List) ## converting list to dataframe

q_1 <- meta_data[which(meta_data$Country=='CA'& meta_data$ProvinceState=='BC' & meta_data$City== 'Kelowna'),]  ## selecting the house list located in Canada & Kelowna from the meta data file

common_BC_Kelowna <- intersect(q_1$filename, file.List$file.List) ## Finding the common files in 2016 data directory and meta data file

library(dplyr)

library(purrr)

##Importing files to the global environment

files_to_read_4 = list.files(
  for (i in 1:length(common_BC_Kelowna)) assign(common_BC_Kelowna[i], read.csv(common_BC_Kelowna[i])))


df.set_AB_1 <- list(`cdeaa21bafd9bd8a673f18df2020835cdd167dec.csv`, `d0feedd03d581c334651c7214db5e81073a98123.csv`,
                    `afb0d0d1415e6ac8286cf720a85a67a697cf4813.csv`, `770cd549457504bbe5f12eab98e0adfab0eb2638.csv`,
                    `c460fb8ddbae03c6ac01e904a9beb7d4c17e73dd.csv`, `e314647d5690a0e2f47c3ff9bb79cacad3908ae9.csv`,
                    `5430e3d718721f78880cd07f8d9d898ada769435.csv`, `3106ee852518d09c057df961bd28117be1bfd0e0.csv`,
                    `00d2efb8eba71bc9ebfd7cba56e69fc96ed74485.csv`, `1b155026963718b948d8871eaf204ae4cab53efa.csv`,
                    `2438255ba8c25503077cb475ca087826b2c19c72.csv`, `c4141e3afffc57066e4bce6cb1010b855b2e57d0.csv`,
                    `ef4fdf98fb0b3976a7d21837e73a262d11b14f82.csv`, `4f8f272ad7cd4e4abee2704a80b910f321280693.csv`,
                    `b3e2b961e59cf67bc33408cbfd3ebd0c5ae771fe.csv`, `82a17646f79bc21c3ddb2f86d250df42c7b6bbe0.csv`,
                    `ff47dd7d42ef161f46abe684f2f62b47f8edfcf2.csv`, `f2e198cb05c0c4226234f5745a235f2269229144.csv`,
                    `adaeae15f8280b55cb06ef95f3354592e5c850ae.csv`, `f77ebbd9e6b8aba4230af9059d8813f886f79c22.csv`,
                    `40106fca76ea83b819168293efc2d724a3a163da.csv`, `bd2308ebfd0fd7a60c4836bf138b85aa8c955e90.csv`,
                    `ef5d5b31e85b500da8a0db7c81f7a51f347bb88d.csv`, `93efe1995771f2e523082a266f1d7b7c516ecead.csv`,
                    `efe6e35ba95c2d723056e34ddbdc3859779e154d.csv`, `8b1ad5e1516accfa52d0e928894dcce9740a06cc.csv`,
                    `b985dd15ef6cde1b67e1a999894205d99eb0fd4b.csv`, `1d8dc846b93e4c1b200c16f4233ae3333578be06.csv`,
                    `db5f181a87db5990ab1d0f568064e82fbf640caf.csv`, `10df7976d91c070af9ab5f348b8b2cefd3ea41a8.csv`,
                    `e432705a987a63e742fbb2d74799a4f04c792a9c.csv`)


source_AB_1 <- as.list(common_BC_Kelowna)

df_AB_1 <- Map(cbind, df.set_AB_1, id = source_AB_1)

#Deleting the first unwanted column in each dataframe

df_AB_1 <- map_if(df_AB_1, ~ "Unnamed: 0" %in% names(.x), ~ .x %>% select(-"Unnamed: 0"), .depth = 2)

#Creating date attributes

library(lubridate)

y_AB_1_1 <-map(df_AB_1, ~ .x %>%
                 mutate(Day_of_week = weekdays(as.POSIXct(strptime(DateTime, "%Y-%m-%d %H:%M"))),
                        hour_of_day = hour(as.POSIXct(strptime(DateTime, "%Y-%m-%d %H:%M"))),
                        date =date(as.POSIXct(strptime(DateTime, "%Y-%m-%d %H:%M"))),
                        day = day(as.POSIXct(strptime(DateTime, "%Y-%m-%d %H:%M"))),
                        wday = wday(as.POSIXct(strptime(DateTime, "%Y-%m-%d %H:%M"))),
                        year = year(as.POSIXct(strptime(DateTime, "%Y-%m-%d %H:%M")))))

#Aggregating temperature values

y_AB_1_1_temperature_data <-map(y_AB_1_1, ~ .x %>%
                                  group_by(hour_of_day, id, HvacMode) %>%
                                  summarise(T_stp_cool=mean(T_stp_cool, na.rm = T), 
                                            T_stp_heat=mean(T_stp_heat, na.rm = T),
                                            T_ctrl=mean(T_ctrl, na.rm = T),
                                            T_out=mean(T_out, na.rm = T)))

#Combining the list to dataframe
tweets.df_AB_1_1_temp <- do.call("rbind", lapply(y_AB_1_1_temperature_data, as.data.frame)) 

#Renaming
profile_temp_Kelown <- tweets.df_AB_1_1_temp

#Converting Farenheit to Celsius

convert_fahr_to_celsius <- function(temp) {
  Celsius <- ((temp - 32) * (5 / 9))
  return(Celsius)
}

profile_temp_Kelown[c(4:7)] <- convert_fahr_to_celsius(profile_temp_Kelown[c(4:7)])


profile_temp_Kelown[c(4:7)] <- round(profile_temp_Kelown[c(4:7)], digits = 1)


#Selecting data related to HVAC mode = Heat
Profile_heat_Kelowna <- profile_temp_Kelown[which(profile_temp_Kelown$HvacMode=='heat'),]


Profile_heat_Kelowna$id <- as.factor(Profile_heat_Kelowna$id)
Profile_heat_Kelowna$hour_of_day <- as.(Profile_heat_Kelowna$id)

#Data transpose

library(reshape2)

Profile_heat_Kelowna_transform <- dcast(Profile_heat_Kelowna, id~hour_of_day, value.var = "T_stp_heat")

Profile_heat_Kelowna_transform <- Profile_heat_Kelowna_transform[,-(26)] 

#Removing data with missing values
Profile_heat_Kelowna_transform<-Profile_heat_Kelowna_transform[complete.cases(Profile_heat_Kelowna_transform), ]

#Data export
write.csv(Profile_heat_Kelowna_transform, 'Profile_heat_Kelowna_transform.csv')

#Plots
library(ggplot2)

ggplot(Profile_heat_Kelowna, aes(x= hour_of_day, y=T_stp_heat, color= id)) + geom_line() + labs(x = "Time of day", y= "Average heating setpoint temperature")+ ggtitle("Heating setpoint temperature analysis") + theme(legend.position = "none")


boxplot(T_Stp_heat~hour_of_day, data=Profile_heat_Kelowna, main="Daily energy consumption-Minami 182", font.main=3, cex.main=1.2, xlab="Month", ylab="Total energy consumption(wh)", font.lab=3, col="yellow",outline=F)


boxplot(Profile_heat_Kelowna$T_stp_heat~Profile_heat_Kelowna$hour_of_day, outline=F, 
        col='red2', main="Heating setpoint temperature profile", font.main=3, cex.main=1.2, xlab="Hours", ylab="Temperature(C)", yaxt='n')
axis(2, seq(14,22,1))
means <- aggregate(T_stp_heat ~  hour_of_day, Profile_heat_Kelowna, mean)

lines(means$T_stp_heat, type = 'l', col='yellow', lwd=2)
points(1:24, means$T_stp_heat, col = "yellow")


#cooling plots - Kelowna city
boxplot(Profile_cool_Kelowna$T_stp_cool~Profile_cool_Kelowna$hour_of_day, outline=F, 
        col='lightblue', main="Cooling setpoint temperature profile - Kelowna City", font.main=3, cex.main=1.2, xlab="Hours", ylab="Temperature(C)", yaxt='n')
axis(2, seq(20,28,1))
means_cool <- aggregate(T_stp_cool ~  hour_of_day, Profile_cool_Kelowna, mean)

lines(means_cool$T_stp_cool, type = 'b', col='brown', lwd=2)
points(1:24, means_cool$T_stp_cool, col = "red")

#cooling plots - BC
boxplot(Profile_cool_BC_total$T_stp_cool~Profile_cool_BC_total$hour_of_day, outline=F, 
        col='lightgreen', main="Cooling setpoint temperature profile - BC", font.main=3, cex.main=1.2, xlab="Hours", ylab="Temperature(C)", yaxt='n')
axis(2, seq(20,28,1))
means_cool_BC <- aggregate(T_stp_cool ~  hour_of_day, Profile_cool_BC_total, mean)
#plot(means$T_stp_heat, type='l')
lines(means_cool_BC$T_stp_cool, type = 'b', col='brown', lwd=2)
points(1:24, means_cool_BC$T_stp_cool, col = "red")


#Selecting data related to HVAC mode = cool

Profile_cool_Kelowna <- profile_temp_Kelown[which(profile_temp_Kelown$HvacMode=='cool'),]

Profile_cool_Kelowna$id <- as.factor(Profile_cool_Kelowna$id)
Profile_cool_Kelowna$hour_of_day <- as.integer(Profile_cool_Kelowna$hour_of_day)

#Data transpose
library(reshape2)

transform_cool_Kelowna <- dcast(Profile_cool_Kelowna, id~hour_of_day, value.var = "T_stp_cool")


transform_cool_Kelowna<-transform_cool_Kelowna[complete.cases(transform_cool_Kelowna), ]

write.csv(transform_cool_Kelowna, 'transform_cool_Kelowna.csv')

library(ggplot2)

ggplot(Profile_cool_Kelowna, aes(x= hour_of_day, y=T_stp_cool, color= id)) + geom_line() + labs(x = "Time of day", y= "Average heating setpoint temperature")+ ggtitle("Heating setpoint temperature analysis") + theme(legend.position = "none")


#k-means clustering#

#  Heating Setpoint temperature clustering

#Elbow Method
#setting the maximum number of clusters. This is user defined and can be changed
k.max <- 15
#Data selection
data <- Profile_heat_BC_total_trans_comp_cases[c(2:25)]
#Finding the optimal number of clusters using Elbow method
wss1 <- sapply(1:k.max, 
               function(k){kmeans(data, k, nstart=50,iter.max = 15 )$tot.withinss})
wss1
plot(1:k.max, wss1,
     type="b", pch = 19, frame = FALSE, 
     xlab="Number of clusters K",
     ylab="Total within-clusters sum of squares",
     main = "Occupancy movement_Morning period")
box()

#Setting seed to get the same results every time the code is executed
set.seed(123)

#kmeans clustering
k_means_occupancy <- kmeans(Profile_heat_BC_total_trans_comp_cases[c(2:25)], centers = 4, nstart = 50)

#Clustrer validation index

library(clValid)
data <- Profile_heat_BC_total_trans_comp_cases[c(2:25)]
clmethods <- c("hierarchical","kmeans","pam")
intern <- clValid(data, nClust = 2:6,
                  clMethods = clmethods, validation = "internal")
summary(intern)

plot(intern)

#Getting centroids of each cluster
a<- as.data.frame(k_means_occupancy[["centers"]])

#Data export
write.csv(a, 'a.csv')

#Adding cluster column in the original data
Profile_heat_BC_total_trans_comp_cases$cluster <- k_means_occupancy[["cluster"]]

#Data export
write.csv(Profile_heat_BC_total_trans_comp_cases, 'Profile_heat_BC_total_trans_comp_cases_with_cluster_number.csv')

#Data merging for data analysis (Meta data and original data)
DT_merged_doc_BC_heat <- merge(BC_meta_data_analysis, Profile_heat_BC_total_trans_comp_cases, by.x = 'filename', by.y = 'id')

#Deleting the duplicate columns in the merged file 
DT_merged_doc_BC_heat<- DT_merged_doc_BC_heat[!duplicated(DT_merged_doc_BC_heat),]

#Data export
write.csv(DT_merged_doc_BC_heat, 'DT_merged_doc_BC_heat.csv')

#Plots
plot(K_means_plot$Hours, K_means_plot$Cluster_1, type='l', xlab='Hours', ylab='Temperature', lwd=2, ylim=c(12,24))
lines(K_means_plot$Hours, K_means_plot$Cluster_2, type='l', col='red', xlab='Hours', ylab='Temperature', lwd=2)
lines(K_means_plot$Hours, K_means_plot$Cluster_3, type='l', col='orange', xlab='Hours', ylab='Temperature', lwd=2)
lines(K_means_plot$Hours, K_means_plot$Cluster_4, type='l', col='blue', xlab='Hours', ylab='Temperature', lwd=2)
legend(
  "topleft", 
  col = c('black', 'red', 'orange', 'blue'),
  legend = c("Cluster_1", "Cluster_2", 'Cluster_3', 'Cluster_4'), lty = 1, bty = 'n', cex = 1, lwd=3)


