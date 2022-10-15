# Energy Demand Evolution in Spain (2020-2022)

## Why did I choose this topic

When I was starting the project, I was looking for a topic of interest for me and with some social relevance. Also, I wanted a topic with a lot of data and easily accessible.

One of the main problems nowadays worldwide is the energy crisis: today’s society consumes huge quantities of energy. These energy quantities must be generated, preferably, through renewable energy sources, respectful of the environment.

The topic of energy has always fascinated me, especially renewable energies. The future of energy lies in renewable energy sources and their applications. That’s why I am very interested in studying their development.

The information on demand, generation, and CO2 emissions can be downloaded through the “Red Eléctrica Española” web (https://www.ree.es/es). This platform allows you to explore different types of data, like the hours or months in which people consume electricity and the source of energy that contaminates the most or produces the highest amount of energy.

## Creating the ETL process

An important advantage of downloading this dataset was the absence of null values, although this dataset generated a lot of duplicates. Each file contains the data from the previous day at 21:00 to the next day at 02:55. 

For example, if I download the data from July 14th, I would find the data from July 13th 9:00 PM to July 15th 2:55 AM. If we arrange all of the files, that would generate a lot of hours overlapped. That’s why it’s very important to drop duplicates. They were removed with the function drop. duplicates().

For every day of the year we have three different files:

* The first file contains the energy demand. 
* The second file contains information about the energy generation for every energy source.
* The last file contains the emissions for every energy source.

The data from two years corresponds to 730 files. That’s why I used the .glob() function, so Pandas could read all the files inside the folder and concatenates them properly. 

One of the first transformations I had to do is related to the title of the columns. Each file has the following structure:

* The first row contains the title of the document.
* The second row is empty
* The third row contains the titles of the different columns.

To solve this: I did the following steps:

* Creating a list with the titles of the columns (3rd row).
* Converting that list in the first row.
* Removing the second and third rows since they don’t have relevant information anymore.
* Resetting the index, so they make sense with the new structure.

Since the data is in Spanish, I had to **translate the name of the column titles into English**. To do this I followed the next steps:

* Creating a list with the original titles of the columns, in Spanish.
* Creating a list with the titles translated into English.
* Creating a dictionary using both lists. That dictionary was used to translate the names of the columns.

Every file had a column for date and time. However, due to the structure of the questions I wanted to ask, the best was having one column for the date and other one for the hour. First of all, I created a column with the date and time in DateTime format. From that column, I subtracted the date and time, creating two new columns and dropping the initial column.

While I was doing the previous steps, I realized that some times were written like “2A:XX” and “2B:XX”. This was due to the hour change done on the last Saturday of October, where the “2A” corresponds to the first 02:00-02:55 and the “2B” corresponds to the second 02:00-02:55. 

To solve this, I converted all of the elements of the column into string. After that, I replaced the “2A” term with 02 and the rows with “2B” were removed. Once this is done, I converted the elements of the column back to DateTime.

After this, I will explain the most important processes done in each type of file.

### Demand

Other than the previously explained processes, no other transformations were required on the demand script. The last step was downloading a CSV file with the data from the DataFrame.

### Generation and Emission

The files for generation and emission contain an additional column for each source of energy. To use this dataset properly, the structure should be different: the dataset should have one column with the name of the energy source. To do this, I used the .melt() function. After this, both tables have the desired structure.

### Challenges

During the ETL process of these datasets, some issues came up. I will explain those issues and how did I solve them. 

As explained before, every file has duplicated data from the previous file and the next one. This was easily solved through a Pandas .drop_duplicates() function.

The next issue comes from the first one. Although some of the data were duplicated, so was the DateTime column, the values from the other columns sometimes were slightly different. In that case, .drop_duplicates() didn’t remove them.

For this, first I had to find which dates and times generated this circumstance. After that, the duplicated rows shall be removed. Since the difference in the values is so slight, the bias generated is contemptible.

To detect the days and times that happened, I grouped the dataset by date and time, counting the rows in each group using .count(). After that, I filtered for those values higher than 1. That gave me the dates and times of the duplicated rows. To remove them, I used the .drop_duplicates() function with the parameter subset in date and time. 

In the demand files, the last row of each file contains only values for DateTime and real demand, but not for 'Expected' or 'Scheduled'. Since this is not a duplicate value, it wasn’t removed by .drop_duplicates(). To solve this, I looked for the rows in which the value expected was null, but the value in the 'Real' column wasn’t. After that, I removed those rows. 

## Adding Views in Google BigQuery

The next step of the project was creating the appropriate views in SQL. The goal of this is to create tables with the information already gathered in a more suitable structure, making the EDA easier.  These are the views I created:

* **View 1**: Contains the data of the demand file with a granularity of day, month, season, and year.
* **View 2**: Left join among the demand, generation, and emission table with a daily granularity. Since generation and emission have a different structure than demand, a previous group by date and time was required in generation and emission. This view would not be useful for a study that contains different energy sources. 
* **View 3**: Left join from the tables of generation and emission by date and time.
* **View 4**: This view has the same structure as view 3, including the energy source and the energy source class. 
* **View 5**: The fifth view has the same structure as the fourth, but includes the season and year granularity.
* **View 6**: The sixth and last view includes the generation, emission, and dimension table. This table also contains the addition of all the renewable and all non-renewable sources.
