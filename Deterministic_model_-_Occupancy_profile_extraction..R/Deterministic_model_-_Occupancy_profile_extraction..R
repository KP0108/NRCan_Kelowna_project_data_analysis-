#The following codes are for extracting the occupancy profiles from the ecobee data. To understand the steps followed to extract occupancy, refer to the PPT and PDF file attached to the repository. 

setwd("C:\\DYD\\total") ## set the working directory

meta_data <- read.csv("K:/Concordia/Ecobee 2019/meta_data.csv")#Reading the metadata file

file.List = list.files(pattern = "*.csv", recursive = F) ## Extracting only the name of the files in the directory

file.List <- as.data.frame(file.List) ## converting list to dataframe

q_1 <- meta_data[which(meta_data$Country=='CA'& meta_data$ProvinceState=='BC'),]  ## selecting the house list located in Canada from the meta data file

q_11 <- q_1[!duplicated(q_1$Identifier), ]##Deleting the duplicate entires (Execute only if there are duplicates)


common_BC <- intersect(q_11$filename, file.List$file.List) ## Finding the common files in 2016 data directory and meta data file

#In total, data is available for 461 houses in BC. Since the data is large, data processing was done in small portions. 
common_BC_1 <- common_BC[c(1:50)]
common_BC_2 <- common_BC[c(51:100)]
common_BC_3 <- common_BC[c(101:150)]
common_BC_4 <- common_BC[c(151:250)]
common_BC_5 <- common_BC[c(251:350)]
common_BC_6 <- common_BC[c(351:461)]

#reading/imporing the files in common_BC_6 from local machine to the global environment (R). 
files_to_read_4 = list.files(
  for (i in 1:length(common_BC_6)) assign(common_BC_6[i], read.csv(common_BC_6[i])))#We need to execute this for each portion of data (example, common_BC_1, common_BC_2...)

l.df <- lapply(ls(), function(x) if (class(get(x)) == "data.frame") get(x)) ###Creating a list (i.e. combining dataframes as list)

l.df <- l.df[lengths(l.df) != 0] ###Deleting dataframes with 0 entries/data. FOr example, there won't be any data for some houses, and it is better to delete those data

l.df = l.df[-c(112:115)]###The dataframes other than the data are deleted. Example, in the global environment, there are other data like metadata, filenames, etc. To further process the occupancy or setpoint temperature data, it is better to delete the other files. User must be careful while defining the entries that to be deleted. In this list, the entries from 112 to 115 are not the data frames that contains the actual data. It might be the meta data or some other files. Hence the dataframe from 112 to 115 are deleted. 

l <- ls()#reading only the name of lists. Again this will read all the files. Hence, in the next line, the names of dataframes that has occupancy and thermostat data is read. This value stored as characters
l =l[sapply(l, function(x) is.data.frame(get(x)))]

source_BC_1 <- as.list(l)#lines 39 to 51 is to make sure that only appropriate dataframes are considered for the analysis. 

source_BC_1 = source_BC_1[-c(112:115)]#similar to line 34, deleting the names of unwanted files. 


library(dplyr)

library(purrr)

library(lubridate)


df_BC_1 <- Map(cbind, l.df, id = source_BC_1)


df_BC_1 <- map_if(df_BC_1, ~ "X" %in% names(.x), ~ .x %>% select(-"X"), .depth = 1)#Sometimes an empty column could be generated at the start. So to delete that extra column, this line must be executed. It is important to delete the extra column because all the dataframes should has same number of columns, but shall have different number of rows.

#Creating different time attributes for the entire list
y_BC_1_1 <-map(df_BC_1, ~ .x %>%
                 mutate(Day_of_week = weekdays(as.POSIXct(strptime(DateTime, "%Y-%m-%d %H:%M"))),
                        hour_of_day = hour(as.POSIXct(strptime(DateTime, "%Y-%m-%d %H:%M"))),
                        day = day(as.POSIXct(strptime(DateTime, "%Y-%m-%d %H:%M"))),
                        date =date(as.POSIXct(strptime(DateTime, "%Y-%m-%d %H:%M"))),
                        month = month(as.POSIXct(strptime(DateTime, "%Y-%m-%d %H:%M"))),
                        year = year(as.POSIXct(strptime(DateTime, "%Y-%m-%d %H:%M")))))

#getting the average occupancy profile from all the motion sensors.
df <- y_AB_1_1 %>%
  group_by(id) %>%
  select(Thermostat_Motion,Remote_Sensor_1_Motion,Remote_Sensor_2_Motion,Remote_Sensor_3_Motion,Remote_Sensor_4_Motion,Remote_Sensor_5_Motion,
        Remote_Sensor_6_Motion,Remote_Sensor_7_Motion,Remote_Sensor_8_Motion,Remote_Sensor_9_Motion,Remote_Sensor_10_Motion) %>% 
  mutate(avg= rowMeans(., na.rm=TRUE))

#Aggregating the average occupancy by id, year, month, day, date, hour_of_day
y_BC_351_461_data <-map(y_BC_1_1_1, ~ .x %>%
                          group_by(id, year, month, day, date, hour_of_day) %>%
                          summarise(Motion=mean(avg, na.rm = T)))

#combining all the dataframes in the list as one dataframe
tweets.df_BC_1_1_1 <- do.call("rbind", lapply(y_BC_351_461_data, as.data.frame))

#deleting the rows with complete NA
BC_occ_last111<-tweets.df_BC_1_1_1[complete.cases(tweets.df_BC_1_1_1), ]

#Finding the days with NA in each id
Complete_days_BC_occ_1_1 <- BC_occ_last111 %>%
  mutate(Day = floor_date(date, unit = "day")) %>%
  group_by(id, Day) %>%
  mutate(nObservation = n()) %>%
  filter(nObservation == max(nObservation))

#Deleting the incomplete days in each id
dfNew <- Complete_days_BC_occ_1_1[Complete_days_BC_occ_1_1$nObservation == 288,] 

#Rounding the digits of the average occupancy to 2. Note that the colummn number will change based on your data
dfNew[c(7)] <- round(dfNew[c(7)], digits = 2)


#Considering the data related to occupancy (The data included are id, hour of the day, date, type of day, average occupancy). Again the column number still change based on the data
dfNew <- dfNew[c(1,5,6, 2:4, 7:9)]

#Creating a new ID for each house and each date. Note that before the 'id' is the anonymous id provided by ecobee and it is a large character. 
dfNew$ID <- cumsum(!duplicated(dfNew[1:2]))

#Creating a new ID for each house. Note that before the 'id' is the anonymous id provided by ecobee and it is a large character. Hence generated a short ID for each  house
dfNew$IDD <- cumsum(!duplicated(dfNew[1]))

#Data transpose (Each row will have 24 columns representing hourly average occupancy for each day and ID, respectively)
library('reshape2')

Transformed_Therm_motion_data <- dcast(dfNew, ID~hour_of_day, value.var = 'avg')

New <- merge(Transformed_Therm_motion_data, dfNew, by.x = 'ID', by.y = 'ID')

Real_new <- New[!duplicated(New$ID), ]


#Getting mean,median, 1st and 3rd quantiles
Therm_motion_df.sum <- Real_new %>%
  rowwise() %>%
  group_by(IDD) %>%
  select('0','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23') %>% # select variables to summarise
  summarise_each(funs(min = min, 
                      q25 = quantile(., 0.25), 
                      median = median, 
                      q75 = quantile(., 0.75), 
                      max = max,
                      mean = mean))

##As the threshold is selected as median, getting the hourly median for each id and each day (Lines 128 to 145 are simple data adjustments, self explanatory)
we_1 <- melt(Therm_motion_df.sum, id.vars=c("0_median", "1_median", "2_median", "3_median", "4_median", "5_median", "6_median", 
                                            "7_median", "8_median", "9_median", "10_median", "11_median", "12_median", "13_median", 
                                            "14_median", "15_median", "16_median", "17_median", "18_median", "19_median", "20_median", 
                                            "21_median", "22_median", "23_median"))


we_1 <- we_1[1:79,]

we_median <- t(we_1)

we_median <- as.data.frame(we_median)

we_median$ID <- cumsum(!duplicated(we_median[1:2]))

xy.list <- setNames(split(we_1[c(1:24)], seq(nrow(we_1[c(1:24)]))), rownames(we_1[c(1:24)]))

xy.list_t <-t(xy.list)

library(tidyr)

y <- xy.list %>%
  t()


y_try <- do.call("cbind", lapply(y, as.data.frame))

y_try_t <- t(y_try)

y_try_t <- as.data.frame(y_try_t)

y_try_t$Hour <- seq(0,23,1)#rep(0:23, each=24)

y_try_t$IDD <- rep(1:40, each=24)

#changing the median name as Value
colnames(y_try_t)[1] <- 'Value'

##### Merging median and original data

by.x <- c('hour_of_day', 'IDD')
by.y <- c('Hour','IDD')

df <- merge(dfNew[c(by.x, 'Day', 'avg', 'id')], y_try_t[c(by.y, 'Value')],
            all.x = TRUE, all.y = FALSE, by.x = by.x, by.y = by.y)

###arranging the data based on day of the week
a <- df[order(as.Date(df$Day, format="%y-%m-%d")),]

dates_mos <- df %>%
  arrange(date = as.Date(Day, "%y-%m-%d"))

###arranging the data based on IDD
dates_mos <-dates_mos[with(dates_mos,order(IDD)),]

###arranging the data based on hour of the day
dates_mos <-dates_mos[with(dates_mos,order("hour_of_day")),]


write.csv(dates_mos, 'dates_mos.csv') ### If the above code does not work, the data shall be ordered based on hour using ECXEL functions

##Applying the threshold (Chnaging the avergae occupancy (which is in decimal value between 0 to 1), to either 0 or 1 based on the median value)
dates_mos$NewTemp <- ifelse(dates_mos$avg>dates_mos$Value, 1, 0)###This is a simple check to see whether the idea of converting the average occupancy to binary values. Later on the occupancy is changed considering differnt scenarios. Jump to line 258, to see the different scenarios


#Adding the day of the week attribute to the data
weekday1 <- c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday')

dates_mos <- dates_mos %>%
  
  mutate(DayOfWeek = weekdays(dates_mos$Day,abbreviate = FALSE),
         
         Weekday_weekend=factor((DayOfWeek %in% weekday1),
                                
                                levels=c(FALSE, TRUE), labels=c('weekend', 'weekday')))


#Taking average of the data based on weekday/weekend. According to the user, if they want to do the analysis for each day, instead of weekday/weekend, they can average the data based on days instead of weekday/weekend column. 
dates_mos_wd_we <- dates_mos %>%
  group_by(IDD, hour_of_day, Weekday_weekend) %>%
  summarise(Average=mean(NewTemp))

#splitting data into weekdays and weekend
dates_mos_weekday <- filter(dates_mos_wd_we, Weekday_weekend=='weekday')

dates_mos_weekday$IDD <- as.factor(dates_mos_weekday$IDD)
dates_mos_weekday$hour_of_day <- as.integer(dates_mos_weekday$hour_of_day)

library(ggplot2)
ggplot(dates_mos_weekday, aes(x= hour_of_day, y=Average, color= IDD)) + geom_line() + labs(x = "Time of day", y= "Total number of movements")+ ggtitle("Type A - Weekdays occupant movement data") + theme(legend.position = "none", panel.background = element_blank()+  theme(axis.line = element_line(color = 'black')))

library(reshape2)
T_dates_mos_weekday <- dcast(dates_mos_weekday, IDD~hour_of_day, value.var = 'Average')

IDD_1 <- filter(dates_mos, IDD==1)


IDD_1$seq <- seq(1, 8496,1)


IDD_1$Weekday <- weekdays(IDD_1$Day)

weekday1 <- c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday')

IDD_1 <- IDD_1 %>%
  
  mutate(DayOfWeek = weekdays(IDD_1$Day,abbreviate = FALSE),
         
         Weekday_weekend=factor((DayOfWeek %in% weekday1),
                                
                                levels=c(FALSE, TRUE), labels=c('weekend', 'weekday')))

IDD_1$New_Temp_1 <- IDD_1$NewTemp

IDD_1$New_Temp_1[IDD_1$hour_of_day==c(0,1,2,3,4,5,22,23)] = 1


write.csv(IDD_1, 'IDD_1.csv')

##plotting
plot(IDD_1$seq, IDD_1$New_Temp_1, type='l', col=alpha('red'), xlab = 'Hours', ylab = 'Occupant presence state', main = 'Occupant schedule as 0 AND 1')
plot(IDD_1$seq, IDD_1$NewTemp, type='l', col=alpha('red'), xlab = 'Hours', ylab = 'Occupant presence state', main = 'Occupant schedule as 0 AND 1')
plot(IDD_1$seq, a_2019_graph$New_Temp_1, type='l', col=alpha('red'), xlab = 'Hours', ylab = 'Occupant presence state', main = 'Occupant schedule as 0 AND 1')
plot(IDD_1$seq, a_2019$NewTemp, type='l', col=alpha('blue'), xlab = 'Hours', ylab = 'Occupant presence state')

plot(IDD_1$seq, IDD_1$Therm_motion, type = 'l', col=alpha('green'), xlab = 'Hours', ylab = 'Average occupancy for each hour',main = 'Occupant schedule varying between 0 to 1')
write.csv(a_2019, 'a_2019.csv')
getwd()


###Once the data is generated, scenarios can be tested (For information regarding the scenrios, refer to PPT or PDF in the repository)

##Day is seperated based on the occupancy & energy CPA

Func.Day_Energy <- function(time){
  
  Morning <- c("8","9","10","11","12","13","14","15",'16','17','18','19','20','21')
  
  Night <- c('22',"23", "0", "1", "2", "3", "4", "5", "6", "7")
  
  day_division <- c("Morning","Night")
  
  x <- vector()
  
  for(i in 1:length(time)){
    
    if(time[i] %in% Morning){
      
      x[i]= day_division[1]
      
    }else{
      
      x[i] = day_division[2]
      
    }
    
  }
  
  
  
  return(x)
  
}


#average_388_date_mos is the data name.
average_388_date_mos$Day.period <- Func.Day_Energy(average_388_date_mos_s7$hour)


####SCENARIO 1:For both nighttime* (22:00h to 07:00h) and daytime* (08:00h to 21:00h): Converting the average occupancy values based on the median of each hour and for each dwelling, respectively. 
####In other words, if the average value is less than the median, then the modified occupancy value is 0, else 1

##This is already done in the prevous work. SO just aggregating all date_mos and finding the percentage occupied

library(zoo)
library(dplyr)

###---------###

average_388_date_mos_s7$S_1_1_occ <- ifelse(average_388_date_mos_s7$average_occupancy>average_388_date_mos_s7$Median, 1, 0)


Percentageofoccupied_S1 <-average_388_date_mos_s7 %>%
  group_by(id) %>%
  summarise(occ_count=length(which(S_1_1_occ==1)),
            occ_prob=length(which(S_1_1_occ==1))/length(S_1_1_occ))

Percentageofoccupied_S1$Percentage <- Percentageofoccupied_S1$occ_prob*100


write.csv(Percentageofoccupied_S1, "Percentageofoccupied_S1_Mar29.csv")


####SCENARIO 2:For nighttime: The average occupancy value is modified to 1 based on the median value. 
####Additionally, a condition was applied such that if the modified occupancy was found to be '1' in any of the night hours of the day, the entire night is changed to '1' or vice versa. 
##### For daytime: The median value is considered as the threshold as Scenario 1.

average_388_date_mos_s7$S_2_1_occ <- ifelse(average_388_date_mos_s7$average_occupancy>average_388_date_mos_s7$Median, 1, 0)

average_388_date_mos_s7 = average_388_date_mos_s7 %>%
  mutate(Date_ends_on = date + if_else(hour >= 22, 1, 0)) %>%
  group_by(id, Date_ends_on, Day.period) %>%
  mutate(S_2_final_occ = if_else(Day.period == "Night", max(S_2_1_occ), S_2_1_occ)) %>%
  ungroup()

Percentageofoccupied_S_2 <-average_388_date_mos_s7 %>%
  group_by(id) %>%
  summarise(occ_count=length(which(S_2_final_occ==1)),
            occ_prob=length(which(S_2_final_occ==1))/length(S_2_final_occ))

Percentageofoccupied_S_2$Percentage <- Percentageofoccupied_S_2$occ_prob*100

hist(Percentageofoccupied_S_2$Percentage)

write.csv(Percentageofoccupied_S_2, "Percentageofoccupied_S_2_mar29.csv")


####SCENARIO 3:For nighttime: The average value is modified to '1' if the average value itself is found to be greater than 0. 
####Additionally, the condition was applied such that if the modified occupancy was found to be '1' during any of the night hours of the day, the entire night is changed to '1' and vice versa. 
####For daytime: The median value is considered as the threshold as Scenario 1.


#converting 0 to 1 in night hours

average_388_date_mos_s7$S_3_1_occ <- average_388_date_mos_s7$average_occupancy

average_388_date_mos_s7$S_3_1_occ <- ifelse(average_388_date_mos_s7$average_occupancy>0, 1, 0)

average_388_date_mos_s7$S_3_2_occ <- ifelse(average_388_date_mos_s7$average_occupancy>average_388_date_mos_s7$Median, 1, 0)


average_388_date_mos_s7$S_3_2_occ[average_388_date_mos_s7$hour == c(22,23)] <- average_388_date_mos_s7$S_3_1_occ[average_388_date_mos_s7$hour == c(22,23)]

average_388_date_mos_s7$S_3_2_occ[average_388_date_mos_s7$hour == c(0,1,2,3,4,5)] <- average_388_date_mos_s7$S_3_1_occ[average_388_date_mos_s7$hour == c(0,1,2,3,4,5)]

average_388_date_mos_s7$S_3_2_occ[average_388_date_mos_s7$hour == c(6,7)] <- average_388_date_mos_s7$S_3_1_occ[average_388_date_mos_s7$hour == c(6,7)]

average_388_date_mos_s7 = average_388_date_mos_s7 %>%
  mutate(Date_ends_on = date + if_else(hour >= 22, 1, 0)) %>%
  group_by(id, Date_ends_on, Day.period) %>%
  mutate(S_3_final_occ = if_else(Day.period == "Night", max(S_3_2_occ), S_3_2_occ)) %>%
  ungroup()

Percentageofoccupied_S_3 <-average_388_date_mos_s7 %>%
  group_by(id) %>%
  summarise(occ_count=length(which(S_3_final_occ==1)),
            occ_prob=length(which(S_3_final_occ==1))/length(S_3_final_occ))

Percentageofoccupied_S_3$Percentage <- Percentageofoccupied_S_3$occ_prob*100



write.csv(Percentageofoccupied_S_3, "Percentageofoccupied_S_3_mar29.csv")


#####SCENARIO:4
###For nighttime:  The average value is modified to '1' if the average value itself is found to be greater than 0. Additionally, the condition was applied such that if the modified occupancy was found to be '1' during any of the night hours of the day, the entire night is changed to '1' and vice versa. 
###For the daytime: The average value during the daytime is also modified to '1' if the average value itself is found to be greater than 0.

average_388_date_mos_s7$S_4_1_occ <- average_388_date_mos_s7$average_occupancy

average_388_date_mos_s7$S_4_1_occ <- ifelse(average_388_date_mos_s7$average_occupancy>0, 1, 0)

average_388_date_mos_s7 = average_388_date_mos_s7 %>%
  mutate(Date_ends_on = date + if_else(hour >= 22, 1, 0)) %>%
  group_by(id, Date_ends_on, Day.period) %>%
  mutate(S_4_final_occ = if_else(Day.period == "Night", max(S_4_1_occ), S_4_1_occ)) %>%
  ungroup()

Percentageofoccupied_S_4 <-average_388_date_mos_s7 %>%
  group_by(id) %>%
  summarise(occ_count=length(which(S_4_final_occ==1)),
            occ_prob=length(which(S_4_final_occ==1))/length(S_4_final_occ))

Percentageofoccupied_S_4$Percentage <- Percentageofoccupied_S_4$occ_prob*100



write.csv(Percentageofoccupied_S_4, "Percentageofoccupied_S_4_mar29.csv")

####Scenario 5
###For nighttime: The average occupancy value is changed to 1 for the entire nighttime, irrespective of the average occupancy values. 
####For the daytime:  The median value is considered as the threshold as Scenario 1.

average_388_date_mos_s7$S_5_1_occ <- ifelse(average_388_date_mos_s7$average_occupancy>average_388_date_mos_s7$Median, 1, 0)

average_388_date_mos_s7$S_5_1_occ[average_388_date_mos_s7$hour == c(22,23)] <- 1

average_388_date_mos_s7$S_5_1_occ[average_388_date_mos_s7$hour == c(0,1,2,3,4,5)] <- 1

average_388_date_mos_s7$S_5_1_occ[average_388_date_mos_s7$hour == c(6,7)] <- 1

Percentageofoccupied_S_5 <-average_388_date_mos_s7 %>%
  group_by(id) %>%
  summarise(occ_count=length(which(S_5_1_occ==1)),
            occ_prob=length(which(S_5_1_occ==1))/length(S_5_1_occ))

Percentageofoccupied_S_5$Percentage <- Percentageofoccupied_S_5$occ_prob*100

hist(Percentageofoccupied_S_5$Percentage)

write.csv(Percentageofoccupied_S_5, "Percentageofoccupied_S_5_mar29.csv")



####Scenario 6
####For nighttime: The average occupancy value is modified to 1 based on the 1st quartile value. Additionally, a condition was applied such that if the modified occupancy was found to be '1' in any of the night hours of the day, the entire night is changed to '1' or vice versa. 
####For daytime: The 1st quartile value is considered as the threshold, accordingly, the average occupancy value is modified to either 0 or 1. 

####SCENARIO 6:If "1" is detected in any of the night hours for the particular day, then the entire night is changed to "1". DUring daytime, 1stquartile is considered as threshold######

###---------###

q_25_average_388_date_mos$q25NewTemp <- ifelse(q_25_average_388_date_mos$average_occupancy>q_25_average_388_date_mos$`1st Quartile`, 1, 0)


q_25_average_388_date_mos$Day.period <- Func.Day_Energy(q_25_average_388_date_mos$hour)


q_25_average_388_date_mos = q_25_average_388_date_mos %>%
  mutate(Date_ends_on = date + if_else(hour >= 22, 1, 0)) %>%
  group_by(id, Date_ends_on, Day.period) %>%
  mutate(S_6_Temp = if_else(Day.period == "Night", max(q25NewTemp), q25NewTemp)) %>%
  ungroup()

Percentageofoccupied_S6_1_388 <-q_25_average_388_date_mos %>%
  group_by(id) %>%
  summarise(occ_count=length(which(S_6_Temp==1)),
            occ_prob=length(which(S_6_Temp==1))/length(S_6_Temp))

Percentageofoccupied_S6_1_388$Percentage <- Percentageofoccupied_S6_1_388$occ_prob*100

barplot(Percentageofoccupied_S6_1_388$Percentage, ylim = c(0,100), col = 'green')
text(220,90,"Scenario 6 - All houses- 388 house",cex=1.5,font=2, col = 'black')
box()
write.csv(Percentageofoccupied_S6_1_388, "Percentageofoccupied_S6_mar29.csv")


