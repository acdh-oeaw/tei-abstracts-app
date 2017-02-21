
# coding: utf-8

# In[24]:

import csv
from lxml.etree import Element, SubElement, QName, tostring, ElementTree


# In[25]:

file = "tei_contributors.csv"
with open(file, encoding='utf-8') as csvfile:
    data = [x for x in csv.reader(csvfile, delimiter=',')]


# In[26]:

contributors = []
for row in data[1:]:
    role = row[4]
    if role.startswith('Partic.') or role == "":
        pass
    else:
        contributors.append(row)
print(len(contributors))


# In[27]:

new_data =[]
for row in contributors:
    entry = []
    try:
        entry.append(row[1].split(',')[0])
    except:
        pass
    try:
        entry.append((row[2]).split('\n')[0])
        entry.append(((row[2]).split('\n')[1]).split(', ')[0])
        entry.append(((row[2]).split('\n')[1]).split(', ')[1])
    except:
        pass
    new_data.append(entry)
new_data = [x for x in new_data if len(x) > 2]


# In[28]:

with open('orglist-processed.csv', 'w', encoding='utf-8') as myfile:
    wr = csv.writer(myfile, quoting=csv.QUOTE_ALL)
    for x in new_data:
        wr.writerow(x)


# In[47]:

countries = [[x[3], x[2]] for x in new_data]


# In[50]:

root = Element("listPlace")
for x in countries:
    place = Element("place", id="country_{}".format(x[1]))
    placeName = Element("placeName")
    placeName.text = x[0]
    place.append(placeName)
    root.append(place)


# In[51]:

tree = ElementTree(root)
tree.write("listplace.xml")


# In[52]:

organisations = [[x[1], x[3], x[2]] for x in new_data]


# In[56]:

root = Element("listOrg")
for x in organisations:
    org = Element("org")
    orgName = Element("orgName")
    orgName.text = x[0]
    org.append(orgName)
    location = Element("location")
    country = Element("country", key=x[2])
    country.text = x[1]
    location.append(country)
    org.append(location)
    root.append(org)
tree = ElementTree(root)
tree.write("listorg.xml")

