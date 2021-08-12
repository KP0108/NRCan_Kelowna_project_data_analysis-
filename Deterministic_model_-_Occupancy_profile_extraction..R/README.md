# NRCan_Kelowna_project_data_analysis

_**Data processing for deriving occupaqncy and occupant presence percentage in home (Data Driven Approach)**_

Dataset used: ecobee data

Like temperature data, the occupant movement detection data was recorded by the ecobee thermostat every 5-minutes as binary values where 1 means movement detected and 0 means no movement was detected. Among 461 houses, 164 houses do not have any data recorded by the motion sensor (recorded as NaN). Hence, occupancy data from 297 houses were used for the analysis. In the EnerGuide Rating System (Natural Resources Canada, 2020a), HOT2000, and HTAP, occupancy is standard with three people (two adults, one child) assumed to be home 50% of the time. To calculate the percentage of time each house was occupied according to the assumptions made in HTAP housing simulation, at first, the occupant movement detected for every 5 minutes was averaged to hourly values for each house, resulting in occupancy values between 0 to 1. 

The value obtained was the average occupant activity level estimated for each hour. However, to calculate the percentage of the occupants' time at home, it is meaningful to convert the average values to either 0 or 1. In this context, the median value for each hour for each house was calculated and was considered as the threshold. Then the data transformation was performed in such a way that, if the average occupancy value for a specific hour is greater than the median of the same hour, then the average value was counted as 1. Subsequently, the average occupancy value for each hour was changed to either 0 or 1. In this study, hereafter, the average occupancy converted considering median as the threshold is referred to as 'modified occupancy'.

The next step involved processing modified occupancy values for nighttime hours between 22:00h and 07:00h. Occupant movement detected at night was low, as expected. To address this challenge, modified night time occupancy was processed based on a condition that if the modified occupancy for any of the hours during the nighttime for a specific day was found to be '1', then the modified occupancy during the entire nighttime was changed to 1, assuming that occupants are at home for the entire night. Similarly, if the modified occupancy was '0' for the whole night, the modified values kept unchanged (remained as 0). The last step entailed calculating the percentage of time each house was occupied. In this study, the percentage of time each house occupied was calculated as the ratio of the number of instances when modified occupancy was found to be 1 to the total number of observations.


More information on the data and steps followed to extract occupancy can be found in the NRCan report attached to the repository (PDF file)


