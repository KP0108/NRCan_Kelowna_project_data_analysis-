###Step1: Text mining
###Step2: Keywords mapping 
###Step3: Data merging/consolidation

#Merging CEE_map data and Permit data based on KID

Combined_data <- merge(CEEMap_table_of_attributes, KelownaPermitData, by.x = "KID", by.y = "KID")


#xporting data to csv files
write.csv(Combined_data, "Combined_data.csv")


#Merging BCAA data and combined data produced in line #3 based on civic address and print_address

Permit_and_BCA_merged <- merge(BCAA_Building_Info, Combined_data, by.x = 'CivicAddre', by.y = "PRINT_ADDRESS")

#Merging Address point data and BCAA data

Address_t_and_BCAA_merged <- merge(Address_points_Pi_NH, BCAA_Building_Info, by.x = 'CAPS_ADD', by.y = 'CivicAddre')

#Finding unique object ID in Address_t_and_BCAA_merged

c <- unique(Address_t_and_BCAA_merged$OBJECTID)

write.xlsx(Address_t_and_BCAA_merged, "Address_t_and_BCAA_merged.xlsx")

#Data merging

Mergedd_doc_2 <- merge(Address_t_and_BCAA_merged, KelownaPermitData, by.x = 'FULL_ADD', by.y = 'PRINT_ADDRESS')


Mergedd_doc_3 <- merge(Mergedd_doc_2, CEEMap_table_of_attributes, by.x = 'KID', by.y = 'KID')


getwd()

new_joint <- merge(Outline_ResClass_ResUni_HavAdd_newJoin_Karthik, KelownaPermitData, by.x = 'KID', by.y = 'KID')



write.csv(new_joint, 'new_joint.csv')
new_joint_1 <- merge(new_joint_1, BCAA_Building_Info)

unique(new_joint$KID)


###################

#Analysis based on new data received from Rabeeh

#Finding unique IDs in each dataset
Uni_Rabeeh <- unique(BuildingOutlineWID_M6_Add$Building_PK)
uni_R_CEEMAP <- unique(R_CEEMAp$Building_PK)
uni_R_CEEMAP_Permit <- unique(R_CEEMAp_Permit$Building_PK)


a <- unique(Res_HP_All$Building_PK)


#Only residential data

stack <- Res_HP_All [!duplicated(Res_HP_All[c(8,94)]),]

Uni_Res_HP_ALL <- unique(Res_HP_All$Building_PK)

Uni_stack <- unique(stack$Building_PK)

write.csv(stack, 'stack.csv')

#Replacing NA values to "No description"

stack$WORK_DESCR[is.na(stack$WORK_DESCR)] <- "No Description"

#Data aggregattion
JU <- aggregate(WORK_DESCR ~ Building_PK, data = stack, c)


#converting work sedcription column to character type

JU$WORK_DESCR <- as.character(JU$WORK_DESCR)

#Based on the identified keyword, the work description is categorized as the following "Furnace, Gas, HWT, Poolheater, fireplace"
#In specific, if either one of the above mentioned keyword is identified in the work description, it is identified that the some kind of heating permit is applied related to any of the above mentioned keyword. 
#For more details, read the following paper--------

JU$FURNACE[str_detect(JU$WORK_DESCR, "FURNACE")] <- "FURNACE"

JU$FURNACE[str_detect(JU$WORK_DESCR, "furnace")] <- "FURNACE"

JU$FURNACE[str_detect(JU$WORK_DESCR, "Furnace")] <- "FURNACE"

JU$GAS[str_detect(JU$WORK_DESCR, "gas")] <- "GAS"

JU$GAS[str_detect(JU$WORK_DESCR, "Gas")] <- "GAS"

JU$GAS[str_detect(JU$WORK_DESCR, "GAS")] <- "GAS"

JU$HWT[str_detect(JU$WORK_DESCR, "hwt")] <- "HWT"

JU$HWT[str_detect(JU$WORK_DESCR, "Hwt")] <- "HWT"

JU$HWT[str_detect(JU$WORK_DESCR, "HWT")] <- "HWT"

JU$Fireplace[str_detect(JU$WORK_DESCR, "fireplace")] <- "FIREPLACE"

JU$Pool_Heater[str_detect(JU$WORK_DESCR, "Pool Heater")] <- "Pool_Heater"

JU$Pool_Heater[str_detect(JU$WORK_DESCR, "pool heater")] <- "Pool_Heater"

JU[is.na(JU)] <- " "

#data merging
Single_ID_data <- merge(stack, JU, by.x = 'Building_PK', by.y = 'Building_PK')

uni_single_id_data <-unique(Single_ID_data$Building_PK)

Unique_Single_ID_DOC <- Single_ID_data [!duplicated(Single_ID_data$Building_PK),]


write.csv(Unique_Single_ID_DOC, 'Unique_Single_ID_DOC.csv')


#Residential & Farm data

uni_Res_farm <- unique(RES_Farm_HP_All$Building_PK)


stack <- RES_Farm_HP_All [!duplicated(RES_Farm_HP_All[c(9,95)]),]

uni_Res_farm <- unique(uni_Res_farm$Building_PK)

Uni_stack <- unique(stack$Building_PK)

write.csv(stack, 'stack.csv')

stack$WORK_DESCR[is.na(stack$WORK_DESCR)] <- "No Description"

JU <- aggregate(WORK_DESCR ~ Building_PK, data = stack, c)


JU$WORK_DESCR <- as.character(JU$WORK_DESCR)

JU$FURNACE[str_detect(JU$WORK_DESCR, "FURNACE")] <- "FURNACE"

JU$FURNACE[str_detect(JU$WORK_DESCR, "furnace")] <- "FURNACE"

JU$FURNACE[str_detect(JU$WORK_DESCR, "Furnace")] <- "FURNACE"

JU$GAS[str_detect(JU$WORK_DESCR, "gas")] <- "GAS"

JU$GAS[str_detect(JU$WORK_DESCR, "Gas")] <- "GAS"

JU$GAS[str_detect(JU$WORK_DESCR, "GAS")] <- "GAS"

JU$HWT[str_detect(JU$WORK_DESCR, "hwt")] <- "HWT"

JU$HWT[str_detect(JU$WORK_DESCR, "Hwt")] <- "HWT"

JU$HWT[str_detect(JU$WORK_DESCR, "HWT")] <- "HWT"

JU$Fireplace[str_detect(JU$WORK_DESCR, "fireplace")] <- "FIREPLACE"

JU$Pool_Heater[str_detect(JU$WORK_DESCR, "Pool Heater")] <- "Pool_Heater"

JU$Pool_Heater[str_detect(JU$WORK_DESCR, "pool heater")] <- "Pool_Heater"

JU[is.na(JU)] <- " "


# Data merging

H_Date_merge_try <- merge(RES_Farm_HP_All, JU, by.x = 'Building_PK', by.y = 'Building_PK')


# Getting the date applied for each permit, respectively
H_Date_merge_try$DATE_APPLIED <-  strftime(H_Date_merge_try$DATE_APPLIED, format="%Y-%m-%d", tz="Quebec")


H_Date_merge_try$DATE_APPLIED <- as.character(H_Date_merge_try$DATE_APPLIED)

##Aggregating the date applied to each permit in a single row for each unique ID

H_HI_1 <- aggregate(DATE_APPLIED ~ Building_PK, data = H_Date_merge_try, c)

Ju_withdate <- merge(JU, H_HI_1, by.x = 'Building_PK', by.y = 'Building_PK')

H_Single_ID_data <- merge(stack, Ju_withdate, by.x = 'Building_PK', by.y = 'Building_PK')

uni_H_single_id_data <-unique(H_Single_ID_data$Building_PK)

Unique_H_Single_ID_DOC <- H_Single_ID_data [!duplicated(H_Single_ID_data$Building_PK),]

Unique_H_Single_ID_DOC$DATE_APPLIED.y <- vapply(Unique_H_Single_ID_DOC$DATE_APPLIED.y, paste, collapse = ", ", character(1L))

unique(Unique_H_Single_ID_DOC$Building_PK)
write.csv(Unique_H_Single_ID_DOC, 'Unique_H_Single_ID_DOC_HP_both_RES&FARMS.csv')



HI_1 <- aggregate(DATE_APPLIED ~ Building_PK, data = NH_Date_merge_try, c)


Ju_withdate <- merge(JU, HI_1, by.x = 'Building_PK', by.y = 'Building_PK')



Single_ID_data <- merge(stack, JU, by.x = 'Building_PK', by.y = 'Building_PK')

uni_single_id_data <-unique(Single_ID_data$Building_PK)

Unique_Single_ID_DOC <- Single_ID_data [!duplicated(Single_ID_data$Building_PK),]


write.csv(Unique_Single_ID_DOC, 'Unique_Single_ID_DOC_HP_both_RES&FARMS.csv')


############ Non heated areas


R_NH_CEEMAp <- merge(BuildingOutlineWID_M6_AddNull, CEEMap_table_of_attributes, by.x = 'KID', by.y = 'KID')

R_NH_CEEMAp_Permit <- merge(R_NH_CEEMAp, KelownaPermitData, by.x = 'KID', by.y = 'KID')

library(xlsx)

write.csv(R_NH_CEEMAp_Permit, 'R_NH_CEEMAp_Permit.csv')

Uni_Rabeeh_NH <- unique(BuildingOutlineWID_M6_AddNull$Building_PK)
uni_R_NH_CEEMAP <- unique(R_NH_CEEMAp$Building_PK)
uni_R_NH_CEEMAP_Permit <- unique(R_NH_CEEMAp_Permit$Building_PK)


t <- unique(Res_Farm_HP_Non_heated$Building_PK)


#Residential & Farm data

#uni_Res_farm_NH <- unique(RES_Farm_HP_All$Building_PK)


stack <- Res_Farm_HP_Non_heated [!duplicated(Res_Farm_HP_Non_heated[c(8,96)]),]  ####8-Building PK, 9-Work description

Uni_ReFarm_NH_HP_ALL <- unique(Res_HP_All$Building_PK)

Uni_stack <- unique(stack$Building_PK)

write.csv(stack, 'stack.csv')

stack$WORK_DESCR[is.na(stack$WORK_DESCR)] <- "No Description"

JU <- aggregate(WORK_DESCR ~ Building_PK, data = stack, c)

library(tidyverse)

#uni_JU <- unique(JU$Building_PK)


JU$WORK_DESCR <- as.character(JU$WORK_DESCR)

JU$FURNACE[str_detect(JU$WORK_DESCR, "FURNACE")] <- "FURNACE"

JU$FURNACE[str_detect(JU$WORK_DESCR, "furnace")] <- "FURNACE"

JU$FURNACE[str_detect(JU$WORK_DESCR, "Furnace")] <- "FURNACE"

JU$GAS[str_detect(JU$WORK_DESCR, "gas")] <- "GAS"

JU$GAS[str_detect(JU$WORK_DESCR, "Gas")] <- "GAS"

JU$GAS[str_detect(JU$WORK_DESCR, "GAS")] <- "GAS"

JU$HWT[str_detect(JU$WORK_DESCR, "hwt")] <- "HWT"

JU$HWT[str_detect(JU$WORK_DESCR, "Hwt")] <- "HWT"

JU$HWT[str_detect(JU$WORK_DESCR, "HWT")] <- "HWT"

JU$Fireplace[str_detect(JU$WORK_DESCR, "fireplace")] <- "FIREPLACE"

JU$Pool_Heater[str_detect(JU$WORK_DESCR, "Pool Heater")] <- "Pool_Heater"

JU$Pool_Heater[str_detect(JU$WORK_DESCR, "pool heater")] <- "Pool_Heater"

#JU[is.na(JU)] <- " "

Ju_withdate <- merge(JU, HI_1, by.x = 'Building_PK', by.y = 'Building_PK')

NH_Single_ID_data <- merge(stack, Ju_withdate, by.x = 'Building_PK', by.y = 'Building_PK')

uni_NH_single_id_data <-unique(NH_Single_ID_data$Building_PK)

Unique_NH_Single_ID_DOC <- NH_Single_ID_data [!duplicated(NH_Single_ID_data$Building_PK),]

Unique_NH_Single_ID_DOC$DATE_APPLIED.y <- vapply(Unique_NH_Single_ID_DOC$DATE_APPLIED.y, paste, collapse = ", ", character(1L))


write.csv(Unique_NH_Single_ID_DOC, 'Unique_NH_Single_ID_DOC_HP_both_RES&FARMS.csv')

### Trying to merge the date for not heated area


NH_Date_merge_try <- merge(Res_Farm_HP_Non_heated, JU, by.x = 'Building_PK', by.y = 'Building_PK')

NH_Date_merge_try$DATE_APPLIED <-  strftime(NH_Date_merge_try$DATE_APPLIED, format="%Y-%m-%d", tz="Quebec")


NH_Date_merge_try$DATE_APPLIED <- as.character(NH_Date_merge_try$DATE_APPLIED)


write.csv(NH_Date_merge_try, 'NH_Date_merge_try.csv')



HI_1 <- aggregate(DATE_APPLIED ~ Building_PK, data = NH_Date_merge_try, c)


Ju_withdate <- merge(JU, HI_1, by.x = 'Building_PK', by.y = 'Building_PK')




JU$FURNACE[str_detect(JU$WORK_DESCR, "FURNACE")] <- "FURNACE"

JU$FURNACE[str_detect(JU$WORK_DESCR, "furnace")] <- "FURNACE"

JU$FURNACE[str_detect(JU$WORK_DESCR, "Furnace")] <- "FURNACE"


library(tidyverse)

stack$FURNACE[str_detect(stack$WORK_DESCR, "furnace")] <- "FURNACE"

stack$HWT[str_detect(stack$WORK_DESCR, "HWT")] <- "HWT"

stack$GAS[str_detect(stack$WORK_DESCR, "Gas")] <- "GAS"

write.csv(stack, 'stack_try.csv')


Duplicate_stack <- stack[duplicated(stack$Building_PK),]


stack$HP <- paste(stack$FURNACE, stack$HWT, stack$GAS)


(stack$HP <- aggregate(stack[c(103,104,105)], unique))


stack$HP <- aggregate(stack[c(103,104,105)],  
                      FUN = function(X) paste(unique(X), collapse=", "))



library(dplyr)


stack$HP <- stack %>%
  group_by(Building_PK) %>%
  summarise(id = paste(stack[c(103:105)], collapse = ","))



stack_few <- stack[1:10, ]

stack_few[is.na(stack_few)] <- " "

HP_1 <- stack_few %>%
  group_by(Building_PK) %>%
  summarise(id = paste(stack_few[c(103:105)], collapse = ","))

HP_1$id<- gsub( "[^0-9A-Za-z/// ]", "", as.character(HP_1$id))

stack_few$HP_1 <- stack_few[ , .(id = list(stack_few[c(103:105)])), by = stack_few$Building_PK]

write.csv(HP_1, "HP_1.csv")

stack_few <- as.data.frame(stack_few)

stack_few$HP_1 <-stack_few[ , .(id = paste(FURNACE), collapse=","), by = list(Building_PK)]

stack_few$HP_1 <- aggregate(stack_few[c(103:105)] ~., stack_few, toString)


library(dplyr)
HP_1 <- stack_few %>%
  group_by(Building_PK) %>%
  summarise(test = toString(stack_few[c(103:105)])) %>%
  ungroup()

stack_few$Building_PK <- as.factor(stack_few$Building_PK)

aggregate(stack_few[c(103:105)] ~ stack_few$Building_PK, c)

library(data.table)
setDT(stack_few)

V <- stack_few[ , .(id = paste(stack_few[c(103:105)], collapse=",")), by = Building_PK]

stack_few <- as.data.frame(stack_few)

aggregate(stack_few[103:105]~Building_PK, data = stack_few, FUN = 'sum')



#### Finding the date for Furnace_heated area

stack_new <- stack
stack_new$WORK_DESCR <- as.character(stack_new$WORK_DESCR)

stack_new$FURNACE[str_detect(stack_new$WORK_DESCR, "FURNACE")] <- "FURNACE"

stack_new$FURNACE[str_detect(stack_new$WORK_DESCR, "furnace")] <- "FURNACE"

stack_new$FURNACE[str_detect(stack_new$WORK_DESCR, "Furnace")] <- "FURNACE"


library(dplyr)

Latest_date <- Furnace_alone %>% 
  group_by(Building_PK) %>%
  filter(DATE_APPLIED == max(DATE_APPLIED))


Unique_Latest_date <- Latest_date [!duplicated(Latest_date$Building_PK),]


write.csv(Unique_Latest_date, 'Unique_Latest_date.csv')

Data_with_furnace_date_heated_area <- merge.data.frame(Unique_H_Single_ID_DOC, two_variables_Unique_Latest_date, all.x=TRUE)

write.csv(Data_with_furnace_date_heated_area, 'Data_with_furnace_date_heated_area.csv')

library(tidyverse)

#### Finding the date for Furnace_non_heated area

stack_new_NH <- stack
stack_new_NH$WORK_DESCR <- as.character(stack_new_NH$WORK_DESCR)

stack_new_NH$FURNACE[str_detect(stack_new_NH$WORK_DESCR, "FURNACE")] <- "FURNACE"

stack_new_NH$FURNACE[str_detect(stack_new_NH$WORK_DESCR, "furnace")] <- "FURNACE"

stack_new_NH$FURNACE[str_detect(stack_new_NH$WORK_DESCR, "Furnace")] <- "FURNACE"

write.csv(stack_new_NH, 'stack_new_NH.csv')


library(dplyr)


Latest_date_NH <- Furnace_alone_NH %>% 
  group_by(Building_PK) %>%
  filter(DATE_APPLIED == max(DATE_APPLIED))



Unique_Latest_date_NH <- Latest_date_NH [!duplicated(Latest_date_NH$Building_PK),]


write.csv(Unique_Latest_date_NH, 'Unique_Latest_date_NHe.csv')

Data_with_furnace_date_nonheated_area <- merge.data.frame(Unique_NH_Single_ID_DOC, NH_two_variables_Unique_Latest_date_csv, all.x=TRUE)

write.csv(Data_with_furnace_date_nonheated_area, 'Data_with_furnace_date_nonheated_area.csv')


#### Finding the date for HWT_heated area

stack_new <- stack
stack_new$WORK_DESCR <- as.character(stack_new$WORK_DESCR)

stack_new$HWT[str_detect(stack_new$WORK_DESCR, "hwt")] <- "HWT"

stack_new$HWT[str_detect(stack_new$WORK_DESCR, "Hwt")] <- "HWT"

stack_new$HWT[str_detect(stack_new$WORK_DESCR, "HWT")] <- "HWT"

write.csv(stack_new, 'stack_new_H_HWT.csv')


library(dplyr)


Latest_date_HWT_H <- HWT_alone_H %>% 
  group_by(Building_PK) %>%
  filter(DATE_APPLIED == max(DATE_APPLIED))


Unique_Latest_date_HWT_H <- Latest_date_HWT_H [!duplicated(Latest_date_HWT_H$Building_PK),]


write.csv(Unique_Latest_date_HWT_H, 'Unique_Latest_date_HWT_H.csv')

Data_with_HWT_date_heated_area <- merge.data.frame(Data_with_furnace_date_heated_area, Unique_Latest_date_HWT_H, all.x=TRUE)

write.csv(Data_with_HWT_date_heated_area, 'Data_with_HWT_date_heated_area.csv')


#### Finding the date for HWT_non_heated area

stack_new <- stack
stack_new$WORK_DESCR <- as.character(stack_new$WORK_DESCR)

stack_new$HWT[str_detect(stack_new$WORK_DESCR, "hwt")] <- "HWT"

stack_new$HWT[str_detect(stack_new$WORK_DESCR, "Hwt")] <- "HWT"

stack_new$HWT[str_detect(stack_new$WORK_DESCR, "HWT")] <- "HWT"

write.csv(stack_new, 'stack_new_NH_HWT.csv')


library(dplyr)

Latest_date_HWT_NH <- HWT_alone_NH %>% 
  group_by(Building_PK) %>%
  filter(DATE_APPLIED == max(DATE_APPLIED))

Unique_Latest_date_HWT_NH <- Latest_date_HWT_NH [!duplicated(Latest_date_HWT_NH$Building_PK),]


write.csv(Unique_Latest_date_HWT_NH, 'Unique_Latest_date_HWT_NH.csv')

Data_with_HWT_date_non_heated_area <- merge.data.frame(Data_with_furnace_date_nonheated_area, Unique_Latest_date_HWT_NH, all.x=TRUE)

write.csv(Data_with_HWT_date_non_heated_area, 'Data_with_HWT_date_non_heated_area.csv')


