import pandas
import matplotlib.pyplot as plot
import numpy as np

#---------------------------
#Q1 read the csv file
#---------------------------

df = pandas.read_csv('e-scooter-trips-2019.csv', header=0, names=['Date', 'Time', 'AM-PM', 'Dist', 'Duration'])#, parse_dates=[['Date','Time']])

#print first 5 rows to check
#print(df.head())


print(f'Question 1 complete.')

#---------------------------
#Q2
#calculate time interger
#insert into new column
#calculate speed and insert into new column
#---------------------------


#create two new columns and set each value to 0
timeint = [0 for i in range(len(df.index))]
speed = [0 for i in range(len(df.index))]


#print first 5 rows to check
#print(df.head())

for i, r in df.iterrows():
    print('Calculating for row no: ', i)
    
    #calculate interger time as per either AM or PM
    if r['AM-PM'] == 'AM':
        timeint[i] = int(r['Time'][:2]) 
    else:
        timeint[i] = int(r['Time'][:2]) + 12
    
    #calculate speed. if Duration (Denominator) is 0, catch the error and set value to 0, else code will break 
    try:
        speed[i] = r['Dist'] / r['Duration']
    except ZeroDivisionError:
        speed[i] = 0

#set the timeint and speed lists values to their respective data fram columns
df['TimeInt'] = timeint
df['Speed'] = speed 

#print first 5 rows to check
#print(df.head())

print(f'Question 2 complete.')

#---------------------------
#Q3 histogram
#---------------------------

timeint = df['TimeInt'].to_list()


plot.hist(timeint, density=False, bins=range(0,26,2))
plot.xticks(list(range(0,26,2)))
plot.xlabel('Time Bins')
plot.ylabel('Frequency')
plot.title('Q3 - Time Frequency Histogram')
plot.grid()
plot.show()
 
print(f'Question 3 complete.')

#---------------------------
#Q4 
# histogram
#---------------------------
#print first 5 rows to check before sorting
#print(df.head())
df = df.sort_values('TimeInt')
#print first 5 rows to check if sorting worked
#print(df.head())

print(f'Question 4 complete.')

#---------------------------
# Q5 
# Calculate Averge and maximum speed
#---------------------------
print(f"Max speed in the dataset is: {df['Speed'].max():.4f} m/s") #rounding up values to 4 decimals
print(f"Average speed in the dataset is: {df['Speed'].mean():.4f} m/s")

print(f'Question 5 complete.')

#---------------------------
# q6 
# Scatter plot
#---------------------------
yval = df['Speed'].to_list()
colors = np.arange(len(yval))
plot.clf()
plot.scatter(timeint, yval, c=colors, cmap='viridis')
plot.xlabel('TimeInt')
plot.ylabel('Speed')
plot.title('Q6 TimeInt vs Speed Scatter Plot')
plot.grid()
plot.show()
print(f'Question 6 complete.')