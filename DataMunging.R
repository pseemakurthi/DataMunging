main <- rm(list=ls(all = T))
setwd("/Users/pseemakurthi/GitHub/DataMunging/DataMunging/MungingWithR")
install.packages("devtools")
devtools::install_github("rstudio/EDAWR")
install.packages("dplyr")
install.packages("nycflights13")
install.packages("tidyr")
library(EDAWR)
library(tidyr)
library(dplyr)
library(nycflights13)

## glimpse is similar to str and can work with most of the data containers
glimpse(flights) #here flights is tbl data type 

#pipes %>% similar to pipes in unix which helps in facilitating the data across multiple functions 
distance <- flights$distance 
distance %>% mean(na.rm = T) # Here the data distance is passed to mean function 
mean(distance, na.rm = T) # More Traditional way of finding the mean



#TB Dataset contains data from WHO about TB 
#Params : 100 Countries for different years age and gender

#1) finding the total number of case with in each country using dplyr
 browseVignettes(package = "dplyr")
#subsetting 
  select(flights, dep_delay,dep_time) #subsetting few columns with their names
  select(flights, ends_with("time")) #selecting all the variables that has "time" as a part of their name
  select(flights, dep_time:air_time) #selecting contiguous columns

#using pipe
    flights %>% select(starts_with("dep_")) 
    flights %>% select(ends_with("time"))
    flights %>% select(dep_time:air_time) 

#Filter Obeservation
    storms %>% filter(wind >= 50)
    storms[storms$wind >= 50,]

#finding all rows where arr_delay is != NA of flights and I'm passing it to count just for verification.
    flights %>% filter(!is.na(arr_delay)) %>% count
    count(flights[!is.na(flights$arr_delay),])

#finding all the rows where wind >50 and selecting storm and pressure
    storms %>% filter(wind >= 50) %>% select(storm,pressure) #if the order of the operations changed R cannot 
                                                            #find "wind" variable and give an error     
    storms[(storms$wind >= 50),c(1,3)]
#simialr operations of flights
    ptm <- proc.time()
    flights %>% select(carrier,arr_delay) %>% filter(!is.na(arr_delay))  %>% count
    proc.time() - ptm
    
    #Best practice first do a select and then do a filter- its almost 300% faster
    
    ptm1 <- proc.time()
    count(flights[(!is.na(flights$arr_delay)),c(7,8)])
    proc.time() - ptm1
    
    #There are a couple of advantages of using dplyr compared to normal vector functions.
    #first it increases the redability of the code and it increases the spead of execution of operations as well
    #In this case dplyr turned out to be 30.7% more faster compared to vector operations.
    
    
#Summarize and groupby
    #this is a fairly complicated operation 
    flights %>% filter(!is.na(air_time),!is.na(distance)) %>% 
      summarise( n = n(),n_carriers = n_distinct(carrier),total_time = sum(hour*60 + minute), tota_dist = sum(distance))
  #I couldn't find doing conventional way in a single line so I left that
    
#this should be relatively easy if someone is coming from SQL background.
#Calculating the average dealy by carrrier on the flights dataset
    flights %>% filter(!is.na(arr_delay)) %>% group_by(carrier) %>% 
      summarise(avg_delay = mean(arr_delay)) 
      
flights %>% group_by(origin,dest) %>% 
  summarise(n = n()) %>% filter(origin == "EWR", dest == "ALB")


#Finding the number of TB cases per year and per country 
# We need to collapse data accross various variables in order to achieve the following task
View(tb)
tb2 <- tb %>% filter(!is.na(child),!is.na(adult),!is.na(elderly)) %>% 
  mutate(case = child + adult + elderly) %>% group_by(country,year) %>% summarise(sum(case)) %>% ungroup()


rawtb %>% group_by(country,year,sex) %>% 
            summarise(n = n())

#Reshaping 
    population %>% gather()