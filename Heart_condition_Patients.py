import pandas
import matplotlib.pyplot as plt
from collections import Counter

df = pandas.read_csv('archive/heart.csv')

#print first 5 rows to check
#print(df.head())

#create dictionaries to store count
chestPain_count = {'0':0, '1':0, '2':0, '3':0}
sex_male_count = {'0':0, '1':0, '2':0, '3':0}
sex_female_count = {'0':0, '1':0, '2':0, '3':0}
age_count = {'<=40':0, '<=50':0, '<=60':0, '<=70':0, '<=80':0}

#extract data from df for each dictionary
for i,r in df.iterrows():
    #chest pain fig 1
    chestPain_count[str(int(r['cp']))] += 1

    #gender based fig 2
    if r['sex'] == 1:
        sex_male_count[str(int(r['cp']))] += 1
    if r['sex'] == 0:
        sex_female_count[str(int(r['cp']))] += 1
    
    #age based fig 3
    if r['age'] <= 40:
        age_count['<=40'] += 1
    elif r['age'] <= 50:
        age_count['<=50'] += 1
    elif r['age'] <= 60:
        age_count['<=60'] += 1
    elif r['age'] <= 70:
        age_count['<=70'] += 1
    elif r['age'] <= 80:
        age_count['<=80'] += 1
    
    
#print all to check
print(chestPain_count)
print(sex_male_count)
print(sex_female_count)
print(age_count)


# ---------------------------
# 
# PLOT 1: BAR GRAPH: NUMBERS OF CASES PER CHEST TYPE
#
# ---------------------------

fig,ax = plt.subplots()
xaxis = chestPain_count.keys()
yaxis = chestPain_count.values()
ax.bar(xaxis,yaxis)
ax.set_ylabel('Number of occurences')
ax.set_xlabel('Chest Pain Type')
ax.set_title('Chest Pain Type vs Occcurences')
plt.savefig('fig1_chestpain_vs_occurences.pdf', bbox_inches='tight')
plt.show()


# ---------------------------
# 
# PLOT 2: BAR GRAPH: NUMBERS OF CASES PER CHEST TYPE WITH SEX-BASED DISTRIBUTION
#
# ---------------------------
fig,ax = plt.subplots()
#width = 0.35
xaxis = chestPain_count.keys()
yaxis1 = sex_male_count.values()
yaxis2 = sex_female_count.values()
ax.bar(xaxis,yaxis1, color= 'cornflowerblue')
ax.bar(xaxis,yaxis2, bottom = list(yaxis1), color = 'orange')
ax.legend(labels=['Men', 'Women'])
ax.set_ylabel('Number of occurences')
ax.set_xlabel('Chest Pain Type')
ax.set_title('Chest Pain Type vs Occcurences (w.r.t. gender)')
plt.savefig('fig2_chestpain_vs_occurences_gender.pdf', bbox_inches='tight')
plt.show()

# ---------------------------
# 
# PLOT 3: PIE CHART: AGE-BASED DISTRIBUTION
#
# ---------------------------

fig,ax = plt.subplots()
ax.axis('equal')
xaxis = age_count.keys()
yaxis = age_count.values()
ax.pie(yaxis, labels = xaxis, autopct='%1.2f%%', size=10)
ax.set_title('Chest Pain: Age based distribution')
plt.savefig('fig3_chestpain_age.pdf', bbox_inches='tight')
plt.show()


