Final Project
==============================

| **Name**  | Ashish Thakur  |
|----------:|:-------------|
| **Email** | athakur2@dons.usfca.edu |

#Global Remittance Visualization#

Following R packages must be installed before running the app:

`library(d3Network)`
`library(leafletR)`
`library(ggplot2)`
`library(shiny)`
`library(sqldf)`
`library(scales)`
`library(maps)`
`library(ggmap)`
`library(reshape)`

Use the following command for running the app:
 `shiny::runGitHub('msan622', 'ashishthakur1296', subdir='final-project')`

##Introduction##

As part of practicum I am currently working for a global money transfer company and thats what got me interested into money transfers across globe. I did some research and found a UN dataset which tracks the remittances across the world for 2010-2012. Here is the link for the dataset:
 
http://econ.worldbank.org/WBSITE/EXTERNAL/EXTDEC/EXTDECPROSPECTS/0,,contentMDK:22759429~pagePK:64165401~piPK:64165026~theSitePK:476883,00.html#Remittances

I have 3 years of data from 2010-2012 about the money transfers. Its basically an excel sheet matrix of around 200 rows * 200 columns and there are 3 excel sheets in total one for each year. 

In this Project


Technique 1 - Bar Plot
Technique 2 - Heat Map
Technique 3 - World Heat Map
Technique 4 - Network Visualization - Single Node
Technique 5 - Sankey Diagram
Technique 6 - Network Visualization - Multi Node


Things that i tried that didn't work out :
Theme
LeafletR



Challenges:
Inconsistent Names between in maps package and dataset
Getting rid of the commas in values
Data Munging


What Other things i would have done if i had more time :

Chord Diagrams
Use LeafletR world map