
ny = read.csv('new_york_city.csv')
wash = read.csv('washington.csv')
chi = read.csv('chicago.csv')

# Importing library
library(ggplot2)
library(lubridate) # To extract month from date

head(ny) 

head(wash)

head(chi)


# Creating null columns of 'Gender' and 'Birth.Year' in the Washington dataset to be able to concatenate all
wash$Gender <- NA
wash$Birth.Year <-NA



# Adding a new column 'City' to each dataset to retain info about city after concatenation
ny$City <- 'New York City'
wash$City <- 'Washington'
chi$City <- 'Chicago'



#Creating a function for concatenation
concatenation <- function(d1, d2) {
  return(rbind(d1, d2))
}



# Concatenating all three datasets together as "city"
city <- concatenation(ny,wash)     #city <- rbind(ny, wash)
city <- concatenation(city,chi)    #city <- rbind(city, chi)
head(city)

# Your solution code goes here
# Count of users in City
total_city = sort(table(city$City))
print(total_city)

# percentage of users in City
round((total_city / sum(total_city) * 100), digits = 2)

# Visualizing data with ggplot
ggplot(aes(x = City, y = Trip.Duration), data = city) +
    geom_bar(position = 'dodge', stat = "summary", fun.y = "mean", fill = "blue", colour="black") + 
    ggtitle('The average travel time for users in different cities') +
    labs(y = 'Average Trip Duration', x = 'City') +
    coord_flip()

my.summary <- with(city, aggregate(list(Trip.Duration), by = list(City), 
                   FUN = function(x) { mon.mean = mean(x, na.rm = TRUE) } ))

colnames(my.summary) <- c('City', 'Average.Trip.Duration')
my.summary


# Your solution code goes here
# Creating new city2 by binding 'New York City' and 'Chicago' data
# Here omitting Washington data is done due to lack of information about 'Gender' and 'Birth.Year'

city2 <- concatenation(chi,ny)      #city2 <- rbind(chi, ny)


# Count of Gender (Male and Female)
total = sort(table(city2$Gender))
print(total)

# percentage of Gender (Male and Female)
round((total / length(city2$Gender) * 100), digits = 2)

# Visualizing data with ggplot
ggplot(aes(x = Gender, fill = City), data = city2) +
    geom_bar(position = 'dodge', colour="black") +
    ggtitle('Counts of each gender') +
    scale_x_discrete(labels = c('Not mentioned', 'Female', 'Male')) +
    labs(y = 'Number of Riders', x = 'Gender') +
    scale_fill_manual("legend", values = c("Chicago" = "black", "New York City" = "orange"))

# Count of Gender(Male and Female) in Chicago
total_chi = sort(table(city2$Gender[city2$City == 'Chicago']))
print(total_chi)

# percentage of Gender(Male and Female) in Chicago
round((total_chi / length(city2$Gender[city2$City == 'Chicago']) * 100), digits = 2)


# Count of Gender(Male and Female) in New York City
total_ny = sort(table(city2$Gender[city2$City == 'New York City']))
print(total_ny)

# percentage of Gender(Male and Female) in Chicago
round((total_ny / length(city2$Gender[city2$City == 'New York City']) * 100), digits = 2)

Here omitting Washington data is done due to lack of information about 'Gender' and 'Birth.Year'.

In Chicago and New York City, number of users:
Male : 42360 (66.81%)
Female : 13882 (21.90%)
Not Mentioned: 7158 (11.29%)
In New York City, among all users there are 67.92% of Male , 22.20% of Female and `9.88% of Not Mentioned'.
In Chicago, among all users there are 59.78% of Male , 19.97% of Female and 20.25% of Not Mentioned.
By a large magnitude Males (42360) tends to rent more bikes than Females (13882) do, across both Chicago and New York City.
Number of data points were null and for some reason riders did not disclose their gender.

# Your solution code goes here
# Re-formatting of date columns
city$Start.Time <- ymd_hms(city$Start.Time)
city$End.Time <- ymd_hms(city$End.Time)

# Creating new column 'Month' extracting from Start.Time
city$Month <- month(city$Start.Time)

# Visualizing data with ggplot
ggplot(aes(x = Month, fill = City), data = city) +
    geom_bar(position = 'dodge', colour="black") +
    scale_x_continuous(breaks = c(1,2,3,4,5,6), labels = c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun')) +
    ggtitle('Number of Rides in different Months') +
    labs(y = 'Number of Rides', x = 'Month') +
    scale_fill_manual("legend", values = c("Chicago" = "black", "New York City" = "orange", "Washington" = "blue"))


system('python -m nbconvert Explore_bikeshare_data.ipynb')
