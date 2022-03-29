demo_table <- read.csv(file='demo.csv', check.names=F, stringsAsFactors = F)

library(jsonlite)

demo_table2 <- fromJSON(txt='demo.json')

# There are many ways to select and subset data in R, depending on what data structure is 
# being used. When it comes to vectors, the easiest way to select data is using the bracket
# ("[ ]") notation. For example, if we have a numeric vector x with 10 values and want to 
# select the third value, we would use the following statements:
x <- c(3, 3, 2, 2, 5, 5, 8, 8, 9)
x[3]

# If we want to select ion demo_table the third row of the Year column using bracket 
# notation, our statement would appear as follows:
demo_table[3,"Year"]

# Because R keeps track of both the row indices as well as the column indices as integers 
# under the hood, we can also select the same data using just number indices:
demo_table[3,3]

# There is a third way to select data from an R data frame that behaves very similarly 
# to Pandas. By using the $ operator, we can select columns from any two-dimensional R data 
# structure as a single vector, similar to selecting a series from a Pandas DataFrame. For 
# example, if we want to select the vector of vehicle classes from demo_table, we would use 
# the following statement:
demo_table$"Vehicle_Class"

#Once we have selected the single vector, we can use bracket notation to select a single 
# value.
demo_table$"Vehicle_Class"[2]

# Data and Logic operators found in Module 15.2.4

# One of the most common ways to filter and subset a dataset in R is to use bracket 
# notation. To use bracket notation to filter a data frame, we can supply a logical 
# statement to assert our row and columns.For example, if we want to filter our used car 
# data demo_table2 so that we only have rows where the vehicle price is greater than 
# $10,000, we would use the following statement:
filter_table <- demo_table2[demo_table2$price > 10000,]
# This filter statement generates a view-only data frame tab listing vehicles priced 
# greater than $10,000

# Subset() function
# Another method to filter and subset data frames in R is to use the function subset().
?subset()
# The subset() function uses a few arguments to subset and filter a two-dimensional R data 
# structure: x, subset and select. For example, if we want to create a more elaborate 
# filtered dataset from our used car data demo_table2 where price > 10000, drive == 4wd, 
# and "clean" %in% title_status, we would use the following statement:
filter_table2 <- subset(demo_table2, price > 10000 & drive == "4wd" & "clean" %in% title_status) #filter by price and drivetrain

# Sample function
# Often in data science, we need to generate a random sample of data points from a larger 
# dataset. we'll want to randomly sample our larger data to reduce bias. In these cases, 
# we can use the built-in function sample(). Let's try it now. Type the following code 
# into the R console to look at the sample() documentation in the Help pane:
?sample()
# The sample() function uses a few arguments to create a sampled vector from a larger vector:
# x - either a vector of one or more elements from which to choose, or a positive integer.
# size - a non-negative integer giving the number of items to choose. 
# replace - should sampling be with replacement?
# If we want to sample a large vector and create a smaller vector, we can set the vector 
# to "x":
sample(c("cow", "deer", "pig", "chicken", "duck", "sheep", "dog"), 4)

# Sampling a two-dimensional data structure
# we need to supply the index of each row we want to sample. This process can be completed 
# in three steps:
  # 1. Create a numerical vector that is the same length as the number of rows in the data 
  #     frame using the colon (:) operator.
  # 2. Use the sample() function to sample a list of indices from our first vector.
  # 3. Use bracket notation to retrieve data frame rows from sample list.

  # So, first capture the number of rows in demo_table in a variable. The nrow() function 
  # counts the number of rows in a dataframe.
  num_rows <- 1:nrow(demo_table)
  
  # Next, sample 3 of those rows, as shown in this code:
  sample_rows <- sample(num_rows, 3)

  # Finally, retrieve the requested data within the demo_table:
  demo_table[sample_rows,]
  
  # If we want to combine all three steps in a single R statement, our code would be as 
  # follows:
  demo_table[sample(1:nrow(demo_table), 3),]
  
# Transform
  # Usually when we are analyzing data, we want to perform calculations and incorporate the 
  # calculations back into the raw data to ease in downstream analysis. Tidyverse's dplyr 
  # (Links to an external site.) library transforms R data.
  
  # The dplyr library contains a wide variety of functions that can be chained together to 
  # transform data quickly and easily. Using dplyr is slightly more complex than the simple 
  # assignment statement in R because dplyr allows the user to chain together functions in 
  # a single statement using their own pipe operator (%>%).
  
  # By chaining functions together, the user does not need to assign intermediate vectors 
  # and tables. Instead, all of the data transformation can be performed in a single 
  # assignment function that is easy to read and interpret. To transform a data frame and 
  # include new calculated data columns, we'll use the mutate() function.
  #  library(tidyverse) is the code used to load the tidyverse packages
  library(tidyverse)
  # ?mutate() code provides the detail on the mutate() function.
  
  # The documentation for the mutate() function (generally any dplyr function) is a little 
  # obscure, but it makes more sense looking at the examples. We can think of the mutate() 
  # function as a series of smaller assignment statements that are separated by commas. 
  # Each of the assigned names appears as a new column in our raw data frame.
  
  # For example, if we want to use our coworker vehicle data from the demo_table and add 
  # a column for the mileage per year, as well as label all vehicles as active, we would 
  # use the following statement:

  #add columns to original data frame
  demo_table <- demo_table %>% mutate(Mileage_per_Year=Total_Miles/(2020-Year),IsActive=TRUE) 
  
  # Group Data
  # Just like in Python, grouping across a factor allows us to quickly summarize and 
  # characterize our dataset around a factor of interest (also known as a character vector 
  # in R, or list of strings in Python). The most straightforward way to perform a grouping 
  # on an R data frame is to use dplyr's group_by() function. The group_by() function tells 
  # dplyr which factor (or list of factors in order) to group our data frame by.
  
  # The behavior of group_by() is almost identical to that of the Pandas DataFrame.groupby() 
  # function, with the exception of using a value or vector instead of a list. Once we have 
  # our group_by data structure, we use the dplyr summarize() function to create columns in 
  # our summary data frame.
  
  # For example, if we want to group our used car data by the condition of the vehicle and 
  # determine the average mileage per condition, we would use the following dplyr statement:
  #create summary table
  summarize_demo <- demo_table2 %>% group_by(condition) %>% summarize(Mean_Mileage=mean(odometer), 
                                                                      .groups = 'keep') 
  # Note - Dplyr's pipe operator allows us to move our connected functions to a new line 
  # while computing everything in the same assignment function. This allows you to write 
  # RScripts that are not too wide for your RScript window.
  
  # Using the summarize() function is very similar to using the mutate() function on a raw 
  # data frame: for each name and summary function, we create a column in a summary data 
  # frame. Our simplest summary functions will use statistics summary functions such as 
  # mean(), median(), sd(), min(), max(), and n() (used to calculate the number of rows in 
  # each category).
  
  # However, the dplyr summarize() documentation provides a more comprehensive list of 
  # functions that can be used to summarize our data. For example, if in addition to our 
  # previous summary table we wanted to add the maximum price for each condition, as well 
  # as add the vehicles in each category, our statement would look as follows:
  #create summary table with multiple columns
  summarize_demo <- demo_table2 %>% group_by(condition) %>% summarize(Mean_Mileage=mean(odometer),
                            Maximum_Price=max(price),Num_Vehicles=n(), .groups = 'keep')
  
  # Note - The summarize() function takes an additional argument, .groups. This allows you 
  # to control the the grouping of the result. The four possible values are:
  
  #     .groups = "drop_last" drops the last grouping level (default)
  #     .groups = "drop" drops all grouping levels and returns a tibble
  #     .groups = "keep" preserves the grouping of the input
  #     .groups = "rowwise" turns each row into its own group
  
# Reshape Data
  # When performing more involved data analytics and visualizations, there may be situations 
  # where the shape and design of our data frame is overcomplicated or incompatible with the 
  # libraries and functions we wish to use. For example, a "wide" data frame with few rows 
  # and many columns and factors may be difficult to visualize. Or a "long" data frame may 
  # be difficult to analyze if it contains multiple rows for a single subject.
  
  # Thankfully, the tidyr library from the tidyverse has the gather() and spread() functions 
  # to help reshape our data. The gather() function is used to transform a wide dataset into 
  # a long dataset.
  
  # Type the following code into the R console to look at the gather() documentation in the 
  # Help pane:
  ?gather()
  
  # In addition to seeing gather() in use outside of class, you may also encounter the 
  # functions pivot_longer() and pivot_wider().
  
  # pivot_longer() lengthens the data by increasing the number rows and decreasing the 
  # number of columns, while pivot_wider() will perform an inverse transformation.
  
  # To properly reshape an R data frame, the gather() function requires a few arguments:
  
      # data
      # key
      # value
      #  .

  # Load the dmeo2.csv file into your R environment and look at the top of the dataframe
  demo_table3 <- read.csv(file='demo2.csv', check.names=F, stringsAsFactors = F)
  
  # The demo_table3 data frame contains survey results from 250 vehicles that were collected 
  # by a rental company. The rental company evaluated seven different metrics for each 
  #vehicle and rated each metric on a scale of 1 to 5, with 1 representing low and 5 
  # representing high.
  
  # This data would be considered a wide format because different metrics were collected 
  # from a single vehicle, and each metric (also known as a variable in this case) was 
  #stored as a separate column. To change this dataset to a long format, we would use 
  #gather() to reshape this dataset.
  
  # Type the following function into the R console:
  long_table <- gather(demo_table3,key="Metric",value="Score",buying_price:popularity)
  
  # By using the gather() function, we have collapsed all of the survey metrics into one Metric column and all of the values into a Score column. Because the Vehicle column was not in the arguments, it was treated as an identifier column and added to each row as a unique identifier.
  
  # Alternatively, if we have data that was collected or obtained in a long format, we 
  # can use tidyr's spread() function to spread out a variable column of multiple 
  # measurements into columns for each variable.

  # Type the following code into the R console to look at the spread() documentation in 
  # the Help pane:
  ?spread()
  
  # To properly reshape an R data frame, the spread() function requires a few arguments:
  
      # data
      # key
      # value
      # fill
  # Therefore, if we want to spread out our previous long-format data frame back to its 
  # original format, we would use the following spread() statement:
 
  
# Important - If you ever compare two data frames that you expect to be equal, and the 
# all.equal() function tells you they're not as the above example shows. Try sorting the 
# columns of both data frames using the order() and colnames() functions and bracket notation:
  
    table <-demo_table3[,order(colnames(wide_table))]
  
    #  Or, sort the columns using the colnames() functions and bracket notation only:
    
    table <- demo_table3[,(colnames(wide_table))]
  
#   (The comma in the bracket indicates that we're selecting all rows.)
    
# Introduction to ggplot2
    
# In this section, we'll learn about the ggplot library components and how to implement our 
# basic plots, such as bar, line, and scatter plots. Once we have mastered the basics of 
# plotting in ggplot2, we'll learn how to plot more advanced visualizations such as boxplots 
# and heatmaps.
    
#    All figures in ggplot2 are created using the same three components:
      
# 1.    ggplot function-tells ggplot2 what variables to use
# 2.    geom function-tells ggplot2 what plots to generate
# 3.    formatting or theme functions-tells ggplot2 how to customize the plot
#   Similar to how we generate figures using Python's Matplotlib library, we build our ggplot2 
#   visualizations by layering multiple plots and adding customized colors, scales, and labels 
#   to represent our data effectively. Also, similar to Matplotlib, the ggplot2 documentation 
#   is very clear with examples for each option and function, which makes ggplot2 far more 
#   approachable than many programming languages.

# Before we start to build our basic figures, we need to declare our input data and variables 
#    using the ggplot() function. Type the following code into the R console to look at the 
#    ggplot()documentation in the Help pane:
    ?ggplot()
    
# The ggplot() function only requires two arguments to declare the input data:
    
#    data default dataset to use for plot
#    mapping -default list of aestheic mappings to use for plot

# Important - There are a number of optional aes() arguments to assign such as color, fill, 
# shape, and size to customize the plots. We'll cover these optional assignments in this module.
    
# The return value of the ggplot() function is our ggplot object, which is used as the base to 
# build our visualizations. Once we have established a base ggplot object, we can add any 
# number of plotting and formatting functions using an addition (+) operator.
    
# Now that we are familiar with setting up the ggplot()function, let's build our first plot 
# using the mpg (miles per gallon) dataset. First, we'll take a moment to familiarize 
# ourselves with the mpg dataset. In the R console, type the following statement:
    head(mpg)
    
# The mpg dataset contains fuel economy data from the EPA for vehicles manufactured between 
    # 1999 and 2008. The mpg dataset is built into R and is used throughout R documentation 
    # due to its availability, diversity of variables, and overall cleanliness of data. For 
    # our purposes, we'll use the mpg data to demonstrate how to implement each of our 
    # ggplot visualizations. 
    
# The mpg dataset contains fuel economy data from the EPA for vehicles manufactured between 
    # 1999 and 2008. The mpg dataset is built into R and is used throughout R documentation 
    # due to its availability, diversity of variables, and overall cleanliness of data. For 
    # our purposes, we'll use the mpg data to demonstrate how to implement each of our 
    # ggplot visualizations.
    
# The first plots we'll generate using ggplot2 will be bar plots. Bar plots are used to 
    # visualize categorical data. They can be used to represent the frequency of each 
    # categorical value in a list of categorical data. For example, if we want to create a 
    # bar plot that represents the distribution of vehicle classes from the mpg dataset, we 
    # would use the following statements in R:
    plt <- ggplot(mpg,aes(x=class)) #import dataset into ggplot2
    plt + geom_bar() #plot a bar plot
    
  # In this example, we're only trying to visualize univariate (single variable) data. 
    # Therefore, we only need to assign our x argument within the aes() function. After 
    # creating our ggplot object, we then generate a bar plot using geom_bar().
    
   # Type the following code into the R console to look at the geom_bar() documentation in 
    # the Help pane:
    ?geom_bar()
    
  # Unlike most of our previous R functions that we have explored, the geom functions from 
    # ggplot2 are very large. However, in most cases, we can leave all of the arguments alone 
    # and use the geom () function by itself.
    
  #  Another use for bar plots is to compare and contrast categorical results. For example, 
  #  if we want to compare the number of vehicles from each manufacturer in the dataset, we 
  #  can use dplyr's summarize() function to summarize the data, and ggplot2's geom_col() 
  #  to visualize the results:
    # create summary table  
    mpg_summary <- mpg %>% group_by(manufacturer) %>% summarize(Vehicle_Count=n(), 
                                            .groups = 'keep') 
    # import dataset into ggplot2
    plt <- ggplot(mpg_summary,aes(x=manufacturer,y=Vehicle_Count)) 
    
    # plot a bar plot
    plt + geom_col()
    
# Adding formatting functions
    # To address the issues with the plot, we'll need to add formatting functions to our 
    # plotting statement. To change the titles of our x-axis and y-axis, we can use the xlab() 
    # and ylab()functions, respectively:
    # plot bar plot with labels
    
    plt + geom_col() + xlab("Manufacturing Company") + ylab("Number of Vehicles in Dataset") 
    
    #  For our figure, rotate the x-axis labels 45 degrees so they no longer overlap. Our new
    # plotting statement would be as follows, using a "+" sign at the end of the first line 
    # to indicate to the interpreter that the code continues onto the next line (note that 
    # your CLI prompt character will change from ">" to "+" after the first line to indicate 
    # that it expects additional input):
    # #plot a boxplot with labels
    # and rotate the x-axis label 45 degrees
    
    plt + geom_col() + xlab("Manufacturing Company") + ylab("Number of Vehicles in Dataset") + 
      theme(axis.text.x=element_text(angle=45,hjust=1)) 
    
    # In this case, we set the angle argument of our element_text() function to 45 degrees 
    # and our hjust argument to 1. The hjust argument tells ggplot that our rotated labels 
    # should be aligned horizontally to our tick marks.
    
    # Similarly, if we want to adjust our y-axis labels, we would do so by using the 
    # axis.text.y argument of the theme() function. Now that we have adjusted our axis 
    # labels and titles, our figure is far easier to read and ready for print. 
    
# 15.3.4 Build a line plot in ggplot2
# Line plots are used to visualize the relationship between a categorical variable and a 
  #  continuous numerical variable.
    
#    When creating the ggplot object for our line data, we need to set the categorical 
    # variable to the x value and our continuous variable to the y value within our aes() 
    # function. For example, if we want to compare the differences in average highway 
    # fuel economy (hwy) of Toyota vehicles as a function of the different cylinder sizes 
    # (cyl), our R code would look like the following:
    # create summary table
    
    mpg_summary <- subset(mpg,manufacturer=="toyota") %>% group_by(cyl) %>% summarize(Mean_Hwy=mean(hwy), .groups = 'keep') 
    
    # import dataset into ggplot2
    
    plt <- ggplot(mpg_summary,aes(x=cyl,y=Mean_Hwy)) 
    
    # Once we set up our ggplot object, we can generate our line plot using geom_line():
    
    plt + geom_line() 
    
        # Question - how does the code know what object to call? It calls the object created
          # in above line, 361
    
    # In this example, we can observe the general trend in the data: as the number of cylinders
    # in Toyota vehicles increases, the average highway fuel economy decreases.
    
    # However, the default x-axis misrepresents the data because there are no five- and 
    # seven-cylinder vehicles. In addition, the default y-axis tick marks are too general 
    # and do not allow the reader to determine average fuel economy values.
    
    # To adjust the x-axis and y-axis tick values, we'll use the scale_x_discrete() and 
    # scale_y_continuous() functions:
    #  #add line plot with labels
   
    # Note - In general, R is much more aggressive with warning messages than Python. The 
    # warning message you might see here is benign.
    
    # The scale_x_discrete() function tells ggplot to use explicit values for the x-axis 
    # ticks. In other words, the scale_x_discrete() function will generate x-axis ticks 
    # for each value in a list. In contrast, the scale_y_continuous()function tells ggplot 
    # to rescale the y-axis based on a defined range, here from 15 through 30 using breaks 
    # = c(15:30).
    
    # Implementing scatter plots in ggplot2 is just as easy as line plots. To set up our 
    # ggplot object for our scatter plot, we'll need to set the independent variable as 
    # our x value and the dependent variable as our y value within our aes() function. 
    # For example, if we want to create a scatter plot to visualize the relationship 
    # between the size of each car engine (displ) versus their city fuel efficiency (cty), 
    # we would create the following ggplot object:
    
    plt <- ggplot(mpg,aes(x=displ,y=cty)) # import dataset into ggplot2
    
    # Once we successfully create our ggplot object, we can generate our scatter plot using 
    # the geom_point() function:
    # add scatter plot with labels
    
    plt + geom_point() + xlab("Engine Size (L)") + ylab("City Fuel-Efficiency (MPG)") 
    
    # By customizing our data points with aesthetic changes, we can add additional context 
    # to our scatter plots to help convey more information within a single visualization. 
    # Let's see this in action.
    
    # There are a number of customizing aesthetics we can add to our aes() function to 
    # change our scatter plot data points, such as:
      
      # alpha changes the transparency of each data point
      # color changes the color of each data point
      # shape changes the shape of each data point
      # size changes the size of each data point
    
    # If we apply these custom aesthetics to our previous example, we can use scatter 
    # plots to visualize the relationship between city fuel efficiency and engine size, 
    # while grouping by additional variables of interest:
      # import dataset into ggplot2
      plt <- ggplot(mpg,aes(x=displ,y=cty,color=class)) 
      
      # add scatter plot with labels
      plt + geom_point() + labs(x="Engine Size (L)", y="City Fuel-Efficiency (MPG)", color="Vehicle Class") 
      
    # Note - An alternative to xlabs() andylabs() is thelabs() function, which lets you 
      # customize your axis labels as well as any grouping variable labels.
      
    # By coloring each data point by its vehicle class, we can see that vehicle class 
      # data points are clustering together in regard to our engine size and city 
      # fuel efficiency. We're not limited to only adding one aesthetic either:
      #import dataset into ggplot2
      plt <- ggplot(mpg,aes(x=displ,y=cty,color=class,shape=drv)) 
      
      #add scatter plot with multiple aesthetics
      plt + geom_point() + labs(x="Engine Size (L)", y="City Fuel-Efficiency (MPG)", 
                                color="Vehicle Class",shape="Type of Drive") 
      
      #add scatter plot with multiple aesthetics including MPG to determine data point size
      # Could not get this to work - check with office hours
      plt + geom_point() + labs(x="Engine Size (L)", y="City Fuel-Efficiency (MPG)", 
                                color="Vehicle Class",shape="Type of Drive", size="cty")
      
  # 15.3.5 Create Advanced Box plots in ggplot2
      # For instance, when performing statistical analysis, we may want to visualize 
      # summary statistics using boxplots, or unpack the relationship across multiple 
      # variables using a heatmap. Fortunately, ggplot2 has functions such as 
      # geom_boxplot() and geom_tile()that generate more advanced visualizations with ease.
      
      # The boxplot is also known as a box-and-whisker-plot, named for the lines extending 
      # from the boxes. It's used to visualize a variety of summary statistics for a 
      # continuous numerical vector. Boxplots are very common in data science due to the 
      # density of information contained within a single visualization, as well as the 
      # boxplot's ability to compare measurements across grouping factors.
      
      # To generate a boxplot in ggplot2, we must supply a vector of numeric values. For 
      # example, if we want to generate a boxplot to visualize the highway fuel efficiency 
      # of our mpg dataset, our R code would look as follows:
      #import dataset into ggplot2
      plt <- ggplot(mpg,aes(y=hwy)) 
      
      # add boxplot
      plt + geom_boxplot() 
      
      # Unlike the previous ggplot objects, geom_boxplot()expects a numeric vector assigned 
      # to the y-value. This is due to the ggplot accounting for multiple boxplots in a 
      # single figure. If we supply our categorical grouping factor to x, we can create a 
      # boxplot that compares measurements from a variety of groups.
      
      # Expanding on our previous example, if we want to create a set of boxplots that 
      # compares highway fuel efficiency for each car manufacturer, our new R code would 
      # look as follows:
      #import dataset into ggplot2
      plt <- ggplot(mpg,aes(x=manufacturer,y=hwy)) 
      
      # add boxplot and rotate x-axis labels 45 degrees
      plt + geom_boxplot() + theme(axis.text.x=element_text(angle=45,hjust=1)) 
      
      # These grouped boxplots are fantastic to use in technical reports and presentations 
      # due to how easy they are to read and interpret as well as how much information can 
      # be conveyed.
      
# 15.3.6 Create Heatmap plots
  # Heatmap plots help visualize the relationship between one continuous numerical 
      #variable and two other variables (categorical or numerical). Heatmaps display 
      # numerical values as colors on a two-dimensional grid so that value clusters and 
      # trends are readily identifiable. For example, if we want to visualize the average 
      # highway fuel efficiency across the type of vehicle class from 1999 to 2008, our 
      # R code would look as follows:
      
      # create summary table
      mpg_summary <- mpg %>% group_by(class,year) %>% summarize(Mean_Hwy=mean(hwy),
                  .groups = 'keep')
      
      # #import dataset into ggplot2
      plt <- ggplot(mpg_summary, aes(x=class,y=factor(year),fill=Mean_Hwy))
      
      # add heatmap with labels
      plt + geom_tile() + labs(x="Model",y="Vehicle Year",fill="Mean Highway (MPG)") +  
        
      #rotate x-axis labels 90 degrees
      theme(axis.text.x = element_text(angle=90,hjust=1,vjust=.5)) 
      
  # Our heatmap shows that the majority of the vehicle classes experienced an average 
      # improvement in highway fuel efficiency from 1999 to 2008. Unlike our previous 
      # ggplot visualizations, heatmaps are used to look at large trends in a dataset. 
      # Therefore, we can use heatmaps to visualize variables with a large number of 
      # values/categories. For example, if we want to look at the difference in average 
      # highway fuel efficiency across each vehicle model from 1999 to 2008, our R code 
      # would look as follows:
      
      #create summary table
      mpg_summary <- mpg %>% group_by(model,year) %>% summarize(Mean_Hwy=mean(hwy), 
                          .groups = 'keep') 
      
      #import dataset into ggplot2
      plt <- ggplot(mpg_summary, aes(x=model,y=factor(year),fill=Mean_Hwy)) 
      
      #add heatmap with labels
      plt + geom_tile() + labs(x="Model",y="Vehicle Year",fill="Mean Highway (MPG)") +
      
        #rotate x-axis labels 90 degrees  
      theme(axis.text.x = element_text(angle=90,hjust=1,vjust=.5))
      
# 15.3.7 Add layers to plots
      # Often when we're building visualizations for data analysis, we'll want to produce 
      # layered plots or combine very similar plots into a single visualization (also 
      # referred to as faceting.
      
      # There are two types of plot layers:
        
        # 1 Layering additional plots that use the same variables and input data as the 
        # original plot.
        # 2 Layering of additional plots that use different but complementary data to 
        # the original plot.
      
      # We can add additional plots to our visualization by adding additional geom functions 
      # to our plotting statement. Layering plots that share input variables can be 
      # beneficial when you want to add context to your initial visualization.
      
      # For example, to recreate our previous boxplot example comparing the highway fuel 
      # efficiency across manufacturers, add our data points using the geom_point() function:
      
      #import dataset into ggplot2
      plt <- ggplot(mpg,aes(x=manufacturer,y=hwy)) 
      
      #add boxplot
      plt + geom_boxplot() + 
      
      # rotate x-axis labels 45 degrees 
      theme(axis.text.x=element_text(angle=45,hjust=1)) +
      
      #overlay scatter plot on top  
      geom_point() 
      
      # By layering our data points on top of our boxplot, we can see the general distribution 
      # of values within each box as well as the number of data points. This new information 
      # can provide the reader better context when comparing two manufacturers with similarly 
      # shaped boxplots.
      
      # Although layering plots with visualizations using the same input variables is a more 
      # common approach, there may be instances when we would want to add additional plotting 
      # layers with new and complementary data.
      
      # For example, what if we want to compare average engine size for each vehicle class? 
      # In this case, we would supply our new data and variables directly to our new geom 
      # function using the optional mapping and data arguments.
      
      # The mapping argument functions exactly the same as our ggplot() function, where our 
      # mapping argument uses the aes() function to identify the variables to use. 
      # Additionally, the data argument can be used to provide a new input data structure; 
      # otherwise, the mapping function will reference the data structure provided in the 
      # ggplot object.
      
      # Our R code would be as follows:
      # create summary table
      mpg_summary <- mpg %>% group_by(class) %>% summarize(Mean_Engine=mean(displ), 
                    .groups = 'keep') 
      
      # import dataset into ggplot2
      plt <- ggplot(mpg_summary,aes(x=class,y=Mean_Engine)) 
      
      #add scatter plot
      plt + geom_point(size=4) + labs(x="Vehicle Class",y="Mean Engine Size") 
      
      # Although this plot sufficiently visualizes the means, it's critical that we provide 
      # context around the standard deviation of the engine size for each vehicle class. If 
      # we compute the standard deviations in our dplyr summarize() function, we can layer 
      # the upper and lower standard deviation boundaries to our visualization using the 
      # geom_errorbar() function:
      
      
      mpg_summary <- mpg %>% group_by(class) %>% summarize(Mean_Engine=mean(displ),SD_Engine=sd(displ), .groups = 'keep')
      
      #import dataset into ggplot2
      plt <- ggplot(mpg_summary,aes(x=class,y=Mean_Engine))   
      
      #add scatter plot with labels
      plt + geom_point(size=4) + labs(x="Vehicle Class",y="Mean Engine Size") + 
        
      #overlay with error bars
      geom_errorbar(aes(ymin=Mean_Engine-SD_Engine,ymax=Mean_Engine+SD_Engine)) 
      
      # Layering plots can be very helpful visualizing wide-format data or summary data when 
      # there are multiple variables and metrics used to describe a single subject. As the 
      # number of subjects increases, or if the input data is in a long format, layering 
      # might not be as effective.
      
      # Caution - Not all visualizations will benefit from layering plots. Before adding 
      # layers of information, ask yourself if the new layer will add context without 
      # distracting or taking away from the original plot.
      
      # Often when our data is in a long format, we want to avoid visualizing all data within 
      # a single plot. Rather, we want to plot all our measurements but keep each level 
      # (or category) of our grouping variable separate. This process of separating out plots 
      # for each level is known as faceting in ggplot2.
      
      # Faceting is performed by adding a facet() function to the end of our plotting 
      # statement. Consider, if instead of the wide format, our mpg dataset was obtained 
      # where city and highway fuel efficiency data was provided in a long format:
      
      # convert to long format
      mpg_long <- mpg %>% gather(key="MPG_Type",value="Rating",c(cty,hwy)) 
      
      head(mpg_long)
      
      # If we want to visualize the different vehicle fuel efficiency ratings by manufacturer, 
      # our R code would be as follows:
      
      # import dataset into ggplot2
      plt <- ggplot(mpg_long,aes(x=manufacturer,y=Rating,color=MPG_Type)) 
      
      # add boxplot with labels rotated 45 degree
      plt + geom_boxplot() + theme(axis.text.x=element_text(angle=45,hjust=1)) 
      
      # The produced boxplot is optimal for comparing the city versus highway fuel efficiency 
      # for each manufacturer, but it is more difficult to compare all of the city fuel 
      # efficiency across manufacturers. One solution would be to facet the different types 
      # of fuel efficiency within the visualization using the facet_wrap() function.
      
      # Type the following code into the R console to look at the facet_wrap() documentation 
      # in the Help pane:
      ?facet_wrap()
      
      # Similar to any of ggplot2's geom functions, the facet_wrap() function has many 
      # optional variables to tweak the direction and type of faceting. However, the most 
      # basic use cases for faceting only require us to provide the annotation for the 
      # facets argument. The facets argument expects a list of grouping variables to facet 
      # by using the vars() function. Therefore, to facet our previous example by the 
      # fuel-efficiency type, our R code could be as follows:
      
      # import dataset into ggplot2
      plt <- ggplot(mpg_long,aes(x=manufacturer,y=Rating,color=MPG_Type)) 
      
      # create multiple boxplots, one for each MPG type
      plt + geom_boxplot() + facet_wrap(vars(MPG_Type)) + 
        
      # rotate x-axis labels
      theme(axis.text.x=element_text(angle=45,hjust=1),
            legend.position = "none") + xlab("Manufacturer") 
      
      # By faceting our boxplots by fuel-efficiency type, it's easier to make comparisons 
      # across manufacturers. In this example, we faceted two levels/groups, but more 
      # complicated long-format datasets may contain measurements for multiple levels. 
      # Using faceting can help make data exploration of these complex datasets easier or 
      # can help isolate factors of interest for our audience.
      
      # Caution - Although there is no hard limit to the number of faceted plots that can 
      # be generated, too many faceted plots can render a visualization useless. Generally 
      # speaking, the more axis ticks you need to convey your data, the fewer facets you 
      # should use.
      
      # Note - There are many ways to implement the facet_wrap()function, and the 
      # documentation can be fairly involved. Thankfully, there are plenty of very simple 
      # examples online that can help you customize your faceting.
      
# 15.4.4 Test for Normality
      # Qualitative Test for Normality
      # The qualitative test for normality is a visual assessment of the distribution of 
      # data, which looks for the characteristic bell curve shape across the distribution. 
      # In R, we would use ggplot2 to plot the distribution using the geom_density() function.
      
      # For example, if we want to test the distribution of vehicle weights from the built-in 
      # mtcars dataset, our R code would be as follows:
      
      #visualize distribution using density plot
      ggplot(mtcars,aes(x=wt)) + geom_density() 
      
      # Quantitative Test for Normality
      # The quantitative test for normality uses a statistical test to quantify the 
      # probability of whether or not the test data came from a normally distributed dataset.
      # In most cases, data scientists will use the Shapiro-Wilk test for normality, though 
      # there are many other statistical tests available. In R, we can use the built-in stats 
      # library to perform our quantitative test with the shapiro.test() function.
      
      # Type the following code into the R console to look at the shapiro.test() 
      #documentation in the Help pane:
      ?shapiro.test()
      
      # The shapiro.test() function only requires the numeric vector of values you wish to 
      # test. Therefore, if we want to perform a quantitative Shapiro-Wilk test on our 
      # previous example, our R code would look as follows:
      shapiro.test(mtcars$wt)
      
      # If the p-value is greater than 0.05, the data is considered normally distributed.
      
      # Remember that most basic statistical tests assume an approximate normal distribution. 
      # Therefore, if our p-value is around 0.05 or more, we would say that our input data 
      # meets this assumption. But what happens if our data distribution does not look like 
      #a bell curve, or the p-value of the Shapiro-Wilk tests is too small?
      
# 15.6.1 Sample Versus Population Dataset
      # To produce a sample dataset that has a similar distribution to the population data, 
      # most statisticians suggest using random sampling. Random sampling is a technique in 
      # data science in which every subject or data point has an equal chance of being 
      # included in the sample. This technique increases the likelihood that even a small 
      # sample size will include individuals from each "group" within the population.
      ?sample_n()
      
      # Using the sample_n()function only requires two arguments:
      
        # tbl is the name of the input table, which is typically the name of a data frame. 
          # Optionally, we can use a dplyr pipe (%>%) to provide the data frame object directly,
          # in which case, this argument is optional.
        # size is the number of rows to return. As noted in the documentation, if we are 
          # providing a data frame that was grouped using the group_by()function, the size 
          # argument is the number of groups to return.
      
    # If we want to visualize the distribution of driven miles for our entire population 
      # dataset, we can use the geom_density()function from ggplot2:
      
      # import used car dataset
      population_table <- read.csv('used_car_data.csv',check.names = F,stringsAsFactors = F) 
      
      
      #import dataset into ggplot2
      plt <- ggplot(population_table,aes(x=log10(Miles_Driven))) 
      
      #visualize distribution using density plot
      plt + geom_density() 
      
      
    # Important - In this example, we want to transform our miles driven using a log10 
      # transformation. This is because the distribution of raw mileage is right skewed-a 
      # few used vehicles have more than 100,000 miles, while the majority of used vehicles 
      # have less than 50,000 miles. The log10 transformation makes our mileage data more 
      # normal.
      
      # Now that we characterized our population data using our density plot, we'll create 
      # a sample dataset using dplyr's sample_n()function. Type the following code in the 
      # R console:
      
      # randomly sample 50 data points
      sample_table <- population_table %>% sample_n(50)  
      
      #import dataset into ggplot2
      plt <- ggplot(sample_table,aes(x=log10(Miles_Driven))) 
      
      #visualize distribution using density plot
      plt + geom_density() 
      
# 15.6.2 Use the One_Sample t-test
      
      # The one-sample t-test is used to determine whether there is a statistical difference 
      # between the means of a sample dataset and a hypothesized, potential population dataset.
      # In other words, a one-sample t-test is used to test the following hypotheses:
      
        # H0 : There is no statistical difference between the observed sample mean and its 
          # presumed population mean.
        # Ha : There is a statistical difference between the observed sample mean and its 
          # presumed population mean.
      
      # Use the help functin to review the t.test() function
      ?t.test()
      
      # To use the t.test()function to perform our one-sample t-test, we have to use a few arguments:
      
        # x - a (non-empty) numeric vector of data values.
        # mu - 	a number indicating the true value of the mean
        # alternative - a character string specifying the alternative hypothesis
      
      # if we want to test if the miles driven from our previous sample dataset is 
      # statistically different from the miles driven in our population data, we would use 
      # our t.test()function as follows:
      
      #compare sample versus population means
      t.test(log10(sample_table$Miles_Driven),mu=mean(log10(population_table$Miles_Driven)))
      
      # Results: t = -0.94166, df = 49, p-value = 0.351, among others
      # Assuming our significance level was the common 0.05 percent, our p-value is above 
      # our significance level. Therefore, we do not have sufficient evidence to reject 
      # the null hypothesis, and we would state that the two means are statistically similar.

# 15.6.3 Use the Two-Sample t-Test
      # The second main form of the t-Test is a two-sample t-Test. Instead of testing whether 
      # a sample mean is statistically different from its population mean, the two-sample 
      # t-Test determines whether the means of two samples are statistically different. In 
      # other words, a two-sample t-Test is used to test the following hypotheses:
      
        # H0 : There is no statistical difference between the two observed sample means.
        # Ha : There is a statistical difference between the two observed sample means.
      
      # In R, we use the same t.test() function to calculate both a one-sample t-Test and 
      # two-sample t-Test. However, the two-sample t-Test arguments are slightly different:
        
        # x is the first numeric vector of sample data.
        # y is the second numeric vector of sample data.
        # alternative tells the t.test() function if the hypothesis is one-sided (one-tailed) or two-sided (two-tailed). The options for the alternative argument are "two.sided,""less," or "greater." By default, the t.test() function assumes a two-sided t-Test.
      
      # Once we have provided the necessary numeric vectors for each sample, the t.test() 
      # function will calculate our two-sample t-Test and return the same output as before. 
      # As practice, let's test whether the mean miles driven of two samples from our used 
      # car dataset are statistically different.
      

      # First, we produce our two samples using the following R statements:
      
      #generate 50 randomly sampled data points
      sample_table <- population_table %>% sample_n(50) 
      
      #generate another 50 randomly sampled data points
      sample_table2 <- population_table %>% sample_n(50) 
      
      # Because our samples should not contain bias , we would expect our null hypothesis to 
      # be true-our samples should not be statistically different. To confirm, we'll use the 
      # t.test() function as follows:
      
      # compare means of two samples
      t.test(log10(sample_table$Miles_Driven),log10(sample_table2$Miles_Driven)) 
      
      # Since the p-value is greater than .05, fail to reject the Null hypothesis. That is,
      # our samples should not be statistically different.
      
# 15.6.4 Use the Two-Sample t-Test to Compare Samples
      # In many cases, the two-sample t-test will be used to compare two samples from a single 
      # population dataset. However, two-sample t-tests are flexible and can be used for 
      # another purpose: to compare two samples, each from a different population. This is 
      # known as a pair t-test, because we pair observations in one dataset with observations 
      # in another. We use the pair t-test when:
      
        # Comparing measurements on the same subjects across a single span of time (e.g., fuel 
          #efficiency before and after an oil change)
        # Comparing different methods of measurement (e.g., testing tire pressure using two 
          # different tire pressure gauges)
        # The biggest difference between paired and unpaired t-tests is how the means are 
          # calculated. In an unpaired t-test, the means are calculated by adding up all 
          # observations in a dataset, and dividing by the number of data points. In a paired 
          # t-test, the means are determined from the difference between each paired 
          # observation. As a result of the new mean calculations, our paired t-test 
          # hypotheses will be slightly different:
        
            # H0 : The difference between our paired observations (the true mean difference, 
              # or "??d") is equal to zero.
            # Ha : The difference between our paired observations (the true mean difference, 
              # or "??d") is not equal to zero.
      
        # When it comes to implementing a paired t-test in R, we'll use the t.test() function.
      
      ?t.test()
      
      # The "paired" argument differ between an unpaired versus a paired t-test
      
      # To practice calculating a paired t-test in R, download the modified mpg dataset 
      # (Links to an external site.) data file contains a modified version of R's built-in 
      # mpg dataset, where each 1999 vehicle was paired with a corresponding 2008 vehicle.
      
      # First, let's generate our two data samples using the following code:
      
      #import dataset
      mpg_data <- read.csv('mpg_modified.csv') #import dataset

      
      #select only data points where the year is 1999
      mpg_1999 <- mpg_data %>% filter(year==1999) 
      
      #select only data points where the year is 2008
      mpg_2008 <- mpg_data %>% filter(year==2008) 
      
      # Now that we have our paired datasets, we can use a paired t-test to determine if there 
      # is a statistical difference in overall highway fuel efficiency between vehicles 
      # manufactured in 1999 versus 2008. In other words, we are testing our null 
      # hypothesis-that the overall difference is zero. Using our t.test() function in R, 
      # our code would be as follows:
      
      #compare the mean difference between two samples
      t.test(mpg_1999$hwy,mpg_2008$hwy,paired = T)
      
  # 15.6.5 Us the ANOVA Test
      
      # When dealing with large real-world numerical data, we're often interested in 
      # comparing the means across more than two samples or groups. The most straightforward 
      # way to do this is to use the analysis of variance (ANOVA) test, which is used to 
      # compare the means of a continuous numerical variable across a number of groups (or 
      #factors in R).
      
      # we'll concentrate on two different types of ANOVA tests:

# A one-way ANOVA is used to test the means of a single dependent variable across a single 
      # independent variable with multiple groups. (e.g., fuel efficiency of different cars 
      # based on vehicle class).
# A two-way ANOVA does the same thing, but for two different independent variables (e.g., 
      # vehicle braking distance based on weather conditions and transmission type).

# Regardless of whichever type of ANOVA test we use, the statistical hypotheses of an ANOVA 
      # test are the same:

  # H0 : The means of all groups are equal, or µ1 = µ2 = . = µn.

  # Ha : At least one of the means is different from all other groups.
      
# In R, we can use the aov() function to perform both the one-way and two-way ANOVA test. 
      # Type the following code into the R console to look at the aov() documentation in the 
      # Help pane:    
      ?aov()
      
      # To perform an ANOVA test in R, we have to provide the aov()function two arguments:
        
        # formula - A formula specifying the model.
        # data - A data frame in which the variables specified in the formula will be found.

# To practice our one-way ANOVA, return to the mtcars dataset. For this statistical test, 
      # we'll answer the question, "Is there any statistical difference in the horsepower of 
      # a vehicle based on its engine type?"
      
      # In this case, we will use the "hp" and "cyl" columns from our mtcars dataset:
        
      #  horsepower (the "hp" column) will be our dependent, measured variable
      # number of cylinders (the "cyl" column) will be our independent, categorical variable.
      # However, in the mtcars dataset, the cyl is considered a numerical interval vector, 
      # not a categorical vector. Therefore, we must clean our data before we begin, using 
      # the following code:  
      
      #filter columns from mtcars dataset
      mtcars_filt <- mtcars[,c("hp","cyl")] 
      
      #convert numeric column to factor
      mtcars_filt$cyl <- factor(mtcars_filt$cyl) 

      # Now that we have our cleaned dataset, we can use our aov()function as follows:
      
      #compare means across multiple levels
      aov(hp ~ cyl,data=mtcars_filt) 
      
      # Due to the fact that the ANOVA model is used in many forms, the initial output of 
      # our aov() function does not contain our p-values. To retrieve our p-values, we have 
      # to wrap our aov()function in a summary() function as follows:
      
      summary(aov(hp ~ cyl,data=mtcars_filt))
      
      # For our purposes, we are only concerned with the "Pr(>F)" column, which is the same 
      # as our p-value statistic. In this case, our p-value is 1.32 ??? 10^-8^, which is much 
      # smaller than our assumed 0.05 percent significance level. Therefore, we would state 
      # that there is sufficient evidence to reject the null hypothesis and accept that 
      # there is a significant difference in horsepower between at least one engine type and 
      # the others.
      
  # 15.7.1 The Correlation Conundrum
      
      # n R, we can use our geom_point() plotting function combined with the cor() function 
      # to quantify the correlation between variables. Type the following code into the R 
      # console to look at the cor() documentation in the Help pane:
      ?cor()
      
      # To use the cor() function to perform a correlation analysis between two numeric 
      # variables, we need to provide the following arguments:
      
        # x is the first variable, which would be plotted on the x-axis.
        # y is the second variable, which would be plotted on the y-axis.
      
      # As long as we are using two numeric variables, there are no other assumptions 
      # regarding our input data. To practice calculating the Pearson correlation coefficient, 
      # we'll use the mtcars dataset. Type the following in the R console:
      
      head(mtcars)
      
      # In the mtcars dataset, there are a number of numeric columns that we can use to test 
      # for correlation such as mpg, disp, hp, drat, wt, and qsec. For our example, we'll 
      # test whether or not horsepower (hp) is correlated with quarter-mile race time (qsec).
      
      # First, let's plot our two variables using the geom_point() function as follows:
      
      #import dataset into ggplot2
      plt <- ggplot(mtcars,aes(x=hp,y=qsec)) 
      
      #create scatter plot
      plt + geom_point() 
      
      # Looking at our plot, it appears that the quarter-mile time is negatively correlated 
      # with horsepower. In other words, as vehicle horsepower increases, vehicle 
      # quarter-mile time decreases.
      
      # Next, we'll use our cor() function to quantify the strength of the correlation between 
      # our two variables:
      
      #calculate correlation coefficient
      cor(mtcars$hp,mtcars$qsec) 
      
      # From our correlation analysis, we have determined that the r-value between horsepower 
      # and quarter-mile time is -0.71, which is a strong negative correlation.
      
      # For another example, let's reuse our used_cars dataset:
      
      #read in dataset
      used_cars <- read.csv('used_car_data.csv',stringsAsFactors = F) 
      
      head(used_cars)
      
      # For this example, we'll test whether or not vehicle miles driven and selling price 
      # are correlated. Once again, we'll plot our two variables using the geom_point() 
      # function:
      
      #import dataset into ggplot2
      plt <- ggplot(used_cars,aes(x=Miles_Driven,y=Selling_Price)) 
      
      #create a scatter plot
      plt + geom_point() 
      
      # Compared to our previous example, our scatter plot did not help us determine 
      # whether or not our two variables are correlated. However, let's see what happens 
      # if we calculate the Pearson correlation coefficient using the cor() function:
      
      #calculate correlation coefficient
      cor(used_cars$Miles_Driven,used_cars$Selling_Price) 
      
      # Our calculated r-value is 0.02, which means that there is a negligible correlation 
      # between miles driven and selling price in this dataset.
      
      # In most cases, we'll use correlation analysis as a means of exploring data and 
      # looking for trends. Although we can calculate the correlation of each pair of 
      # numerical variables in a dataset, this process can be highly time-consuming.
      
      # Instead of computing each pairwise correlation, we can use the cor() function 
      # to produce a correlation matrix. A correlation matrix is a lookup table where 
      # the variable names of a data frame are stored as rows and columns, and the 
      # intersection of each variable is the corresponding Pearson correlation 
      # coefficient. We can use the cor() function to produce a correlation matrix by 
      # providing a matrix of numeric vectors.
      
      # For example, if we want to produce a correlation matrix for our used_cars 
      # dataset, we would first need to select our numeric columns from our data frame 
      # and convert to a matrix. Then we can provide our numeric matrix to the cor() 
      # function as follows:
      
      #convert data frame into numeric matrix
      used_matrix <- as.matrix(used_cars[,c("Selling_Price","Present_Price","Miles_Driven")]) 
      
      
      cor(used_matrix)
      
      # If we look at the correlation matrix using either rows or columns, we can identify 
      # pairs of variables with strong correlation (such as selling price versus present 
      # price), or no correlation (like our previous example of miles driven versus 
      # selling price).
      
      # The correlation matrix is a very powerful data exploration tool that allows an 
      # analyst to scan large numerical datasets for variables of interest. Once the 
      # variables of interest have been identified, the analyst can move on to more 
      # rigorous data analysis and hypothesis testing.

# Return to Linear Regression
      
      # linear regression is a statistical model that is used to predict a continuous 
      # dependent variable based on one or more independent variables fitted to the 
      # equation of a line.
      
      # In school, most students learned that the equation of a line is written as 
      # y = mx + b:
      
      # The job of a linear regression analysis is to calculate the slope and y intercept values (also known as coefficients) that minimize the overall distance between each data point from the linear model. There are two basic types of linear regression:
      
      # Simple linear regression builds a linear regression model with one independent 
      # variable.
      
      # Multiple linear regression builds a linear regression model with two or more 
      # independent variables.
      
      # Linear regression is popular in data science because it has multiple applications. 
      # First and foremost, linear regression can be used as a predictive modeling tool 
      # where future observations and measurements can be predicted and extrapolated from 
      # a linear model. Linear regression can also be used as an exploratory tool to 
      # quantify and measure the variability of two correlated variables.
      
      # A good linear regression model should approximate most data points accurately if 
      # two variables are strongly correlated. In other words, linear regression can be 
      # used as an extension of correlation analysis. In contrast to correlation analysis, 
      # which asks whether a relationship exists between variables A and B, linear 
      # regression asks if we can predict values for variable A using a linear model and 
      # values from variable B.
      
      # To answer this question, linear regression tests the following hypotheses:
        
        # H0 : The slope of the linear model is zero, or m = 0
      
        # Ha : The slope of the linear model is not zero, or m ??? 0
      
      # If there is no significant linear relationship, each dependent value would be 
      # determined by random chance and error. Therefore, our linear model would be a flat 
      # line with a slope of 0.
      
      # To quantify how well our linear model can be used to predict future observations, 
      # our linear regression functions will calculate an r-squared value. The r-squared 
      # (r2) value is also known as the coefficient of determination and represents how 
      # well the regression model approximates real-world data points. In most cases, the 
      # r-squared value will range between 0 and 1 and can be used as a probability metric 
      # to determine the likelihood that future data points will fit the linear model.
      
      # When using a simple linear regression model, the r-squared metric can be 
      # approximated by calculating the square of the Pearson correlation coefficient 
      # between the two variables of interest.
      
      # By combining the p-value of our hypothesis test with the r-squared value, the 
      # linear regression model becomes a powerful statistics tool that both quantifies a 
      # relationship between variables and provides a meaningful model to be used in any 
      # decision-making process.
      
      # Although the interpretation of a simple linear regression is different from a 
      # multiple linear regression, their model implementation is the same. In R, we'll 
      # build our linear models using the built-in lm()function. Type the following code 
      # into the R console to look at the lm() documentation in the Help pane:
      
      ?lm()
      
      # Even though there are many optional arguments for the lm()function, the lm() function only requires us to provide two arguments:
        
        # formula - a symbolic description of the model to be fitted.
        # data - an optional data frame, list or environment containing the variables in 
        # the model
      
      # Once we have our data in a single data frame that meets the assumptions of our 
      # linear regression analysis, we're ready to implement the lm() function.
      
      # For practice, let's revisit our correlation example using the mtcars dataset. Using 
      # our simple linear regression model, we'll test whether or not quarter-mile race 
      # time (qsec) can be predicted using a linear model and horsepower (hp).
      
      # Remember from our correlation example that our Pearson correlation coefficient's 
      # r-value was -0.71, which means there is a strong negative correlation between our 
      # variables. Therefore, we anticipate that the linear model will perform well.

      # To create a linear regression model, our R statement would be as follows:
      
      #create linear model
      lm(qsec ~ hp,mtcars) 
      
      # The output of the lm() function will be the metrics from our model. Specifically, 
      # the lm() function returns our y intercept (Intercept) and slope (hp) coefficients. 
      # Therefore, the linear regression model for our dataset would be 
      # qsec = -0.02hp + 20.56.
      
      # To determine our p-value and our r-squared value for a simple linear regression model,
      # we'll use the summary() function:
      
      #summarize linear model
      summary(lm(qsec~hp,mtcars)) 
      
      # Although there are a number of quantitative metrics produced by the summary(lm()) 
      # function, we are only concerned with the r-squared and p-value metrics at the 
      # bottom of the output.
      
      # From our linear regression model, the r-squared value is 0.50, which means that 
      # roughly 50% of the variablilty of our dependent variable (quarter-mile time 
      # predictions) is explained using this linear model. Compared to the Pearson 
      # correlation coefficient between quarter-mile race time and horsepower of -0.71, 
      # we can confirm that our r-squared value is approximately the square of our r-value.
      # In a simple linear regression model, the higher the correlation is between two 
      # variables, the more that one variable can explain/predict the value of the other.
      
      # In addition, the p-value of our linear regression analysis is 5.77 x 10-6, which is 
      # much smaller than our assumed significance level of 0.05%. Therefore, we can state 
      # that there is sufficient evidence to reject our null hypothesis, which means that 
      # the slope of our linear model is not zero.
      
      # Once we have calculated our linear regression model, we can visualize the fitted 
      # line against our dataset using ggplot2.
      
      # First, we need to calculate the data points to use for our line plot using our 
      # lm(qsec ~ hp,mtcars) coefficients as follows:
      
      #create linear model
      model <- lm(qsec ~ hp,mtcars) 
      
      #determine y-axis values from linear model
      yvals <- model$coefficients['hp']*mtcars$hp +
        model$coefficients['(Intercept)'] 
      
      # Once we have calculated our line plot data points, we can plot the linear model 
      # over our scatter plot:
      
      #import dataset into ggplot2
      plt <- ggplot(mtcars,aes(x=hp,y=qsec))
      
      #plot scatter and linear model
      plt + geom_point() + geom_line(aes(y=yvals), color = "red") 
      
      # Using our visualization in combination with our calculated p-value and r-squared 
      # value, we have determined that there is a significant relationship between 
      # horsepower and quarter-mile time.
      
      # Although the relationship between both variables is statistically significant, 
      # this linear model is not ideal. According to the calculated r-squared value, using 
      # only quarter-mile time to predict horsepower is roughly as accurate as guessing 
      # using a coin toss. In other words, the variability we observed within our 
      # horsepower data must come from multiple sources of variance. To accurately predict 
      # future horsepower observations, we need to use a more robust model.
      
  # Perform Multiple Linear Regression
      
      # Multiple linear regression is a statistical model that extends the scope and 
      # flexibility of a simple linear regression model. Instead of using a single 
      # independent variable to account for all variability observed in the dependent 
      # variable, a multiple linear regression uses multiple independent variables to 
      # account for parts of the total variance observed in the dependent variable.
      
      # As a result, the linear regression equation is no longer y = mx + b. Instead, the 
      # multiple linear regression equation becomes y = m1x1 + m2x2 + . + mnxn + b, for 
      # all independent x variables and their m coefficients.
      
      # In actuality, a multiple linear regression is a simple linear regression in 
      # disguise-all of the assumptions, hypotheses, and outputs are the same. The only 
      # difference between multiple linear regression and simple linear regression is how 
      # we will evaluate the outputs.
      
      # When it comes to multiple linear regression, we'll look at each independent variable
      # to determine if there is a significant relationship with the dependent variable. 
      # Once we have evaluated each independent variable, we'll evaluate the r-squared value
      # of the model to determine if the model sufficiently predicts our dependent variable.
      
      # To practice multiple linear regression, let's revisit our mtcars dataset. From our 
      # last example, we determined that quarter-mile time was not adequately predicted from
      # just horsepower. To better predict the quarter-mile time (qsec) dependent variable, 
      # we can add other variables of interest such as fuel efficiency (mpg), engine size 
      # (disp), rear axle ratio (drat), vehicle weight (wt), and horsepower (hp) as 
      # independent variables to our multiple linear regression model.

      # In R, our multiple linear regression statement is as follows:
      
      #generate multiple linear regression model
      lm(qsec ~ mpg + disp + drat + wt + hp,data=mtcars) 
      
      # Similar to the simple linear regression, the output of multiple linear regression 
      # using the lm() function produces the coefficients for each variable in the linear 
      # equation.
      
      # Note - Because multiple linear regression models use multiple variables and 
      # dimensions, they are almost impossible to plot and visualize.
      
      # Now that we have our multiple linear regression model, we need to obtain our 
      # statistical metrics using the summary()function. In your R console, use the 
      # following statement:
      
      #generate summary statistics
      summary(lm(qsec ~ mpg + disp + drat + wt + hp,data=mtcars)) 
      
      # In addition to overall model fit and the statistical test for slope, most data 
      # scientists would be curious about the contribution of each variable to the multiple 
      # linear regression model. To determine which variables provide a significant 
      # contribution to the linear model, we must look at the individual variable p-values.
      
      # In the summary output, each Pr(>|t|) value represents the probability that each 
      # coefficient contributes a random amount of variance to the linear model. According 
      # to our results, vehicle weight and horsepower (as well as intercept) are 
      # statistically unlikely to provide random amounts of variance to the linear model. 
      # In other words the vehicle weight and horsepower have a significant impact on 
      # quarter-mile race time. When an intercept is statistically significant, it means 
      # that the intercept term explains a significant amount of variability in the 
      # dependent variable when all independent variables are equal to zero. Depending on 
      # our dataset, a significant intercept could mean that the significant features (such
      # as weight and horsepower) may need scaling or transforming to help improve the 
      # predictive power of the model. Alternatively, it may mean that there are other 
      # variables that can help explain the variability of our dependent variable that 
      # have not been included in our model. Depending on the dataset and desired 
      # performance of the model, you may want to change your independent variables and/or 
      # transform them and then re-evaluate your coefficients and significance.
      
      # Despite the number of significant variables, the multiple linear regression model 
      # outperformed the simple linear regression. According to the summary output, the 
      # r-squared value has increased from 0.50 in the simple linear regression model to 
      # 0.71 in our multiple linear regression model while the p-value remained 
      # significant.
      
      # CAUTION - Although the multiple linear regression model is far better at predicting
      # our current dataset, the lack of significant variables is evidence of overfitting. 
      # Overfitting means that the performance of a model performs well with a current 
      # dataset, but fails to generalize and predict future data correctly. Later in this 
      # course we'll learn more about overfitting and ways to avoid it.

      # Depending on the dataset, the questions being asked, and the audience, a simple 
      # linear regression model may be more appropriate than a multiple linear regression 
      # model. However, the amount of information that can be obtained and analyzed will 
      # be far greater using a multiple linear regression.

      # As with any data model, it takes practice to learn how to identify variables of 
      # interest, select an appropriate model, and refine a model to increase performance. 
      # Before moving to the next section, take some time to perform correlation analysis 
      # on our previous datasets. Then use the correlation analysis to identify potential 
      # variables of interest. Once you have variables of interest, practice generating 
      # simple and multiple linear regression models to try and create accurate predictive 
      # models.
      
# 15.81 Category Complexities
      # As we learned previously, categorical data is generally any data that is not 
      # measured, or qualitative data. Even though categorical data may not require an 
      # instrument to measure, it can be just as informative as numerical data.
      
      # One common form of categorical data is frequency data, where we record how often 
      # something was observed within a single variable. For example, in the mpg dataset, 
      # if we were to count up the number of vehicles for each vehicle class, the output 
      # would be a form of frequency data.
      
      # In data science, we'll often compare frequency data across another dichotomous 
      # factor such as gender, A/B groups, member/non-member, and so on. In these cases, 
      # we may ask ourselves, "Is there a difference in frequency between our first and 
      # second groups?" To test this question, we can perform a chi-squared test.

      # The chi-squared test is used to compare the distribution of frequencies across two 
      # groups and tests the following hypotheses:

        # H0 : There is no difference in frequency distribution between both groups.

        # Ha : There is a difference in frequency distribution between both groups
      
      # Once we have confirmed our categorical dataset meets all of the assumptions of the 
      # chi-square analysis, we can perform our chi-squared test.
      
      # In R, we'll compute our chi-squared test using the chisq.test() function. Type the 
      # following code into the R console to look at the chisq.test() documentation in the 
      # Help pane.
      
      ?chisq.test()
      
      # Depending on the structure of your dataset, you can implement the chisq.test() 
      # function in multiple ways using the optional arguments. The most straightforward 
      # implementation of chisq.test() function is passing the function to a contingency 
      # table. A contingency table is another name for a frequency table produced using R's
      # table() function. R's table() function does all the heavy lifting for us by 
      # calculating frequencies across factors.
      
      # For example, if we want to test whether there is a statistical difference in the 
      # distributions of vehicle class across 1999 and 2008 from our mpg dataset, we would 
      # first need to build our contingency table as follows:
      
      #generate contingency table
      table(mpg$class,mpg$year) 
      
      # Then, pass the contingency table to the chisq.test()function:
      
      #generate contingency table
      tbl <- table(mpg$class,mpg$year) 
      
      #compare categorical distributions
      chisq.test(tbl) 
      
      # he p-value is above the assumed significance level. Therefore, we would state that 
      # there is not enough evidence to reject the null hypothesis, and there is no 
      #difference in the distribution of vehicle class across 1999 and 2008 from the mpg
      # dataset.
      
      # Important - The chi-squared warning message is due to the small sample size. Because the 
      # p-value is so large, we are not too concerned that our interpretation may be 
      # incorrect.
      
      # Despite having no quantitative input, the chi-squared test enables data scientists 
      # to quantify the distribution of categorical variables. Although this test can be 
      # applied to more groups and larger datasets, it does have a limit. Increasing the 
      # number of groups also increases the likelihood that insignificant changes will 
      # incorrectly be considered significant. Therefore, it's important to keep the number
      # of unique values and groups relatively low. A good rule of thumb is to keep the 
      # number of unique values and groups lower than 20, which means the degrees of 
      # freedom (df in the output) is less than or equal to 19.
      
# 15.9.1 Practice A/B Testing
      # Often when performing analysis and testing on a well-established product, website, 
      # or software, making changes can be difficult. Well-established products typically 
      # have a large consumer base and reliable sales and usage metrics, and are highly 
      # valued by their company. As a result, it's too risky to implement changes directly 
      # to the product without proper evaluation of the consequences.
      
      # To properly evaluate potential product changes, companies can use a technique 
      # called A/B testing. A/B testing is a randomized controlled experiment that uses 
      # a control (unchanged) and experimental (changed) group to test potential changes 
      # using a success metric. A/B testing is used to test whether or not the distribution
      # of the success metric increases in the experiment group instead of the control 
      # group; we would not want to make changes to the product that would cause a 
      # decrease in the success metric.
      
      # Although A/B testing has been around for almost a century, giant software and tech 
      # companies such as Google and Amazon have popularized the practice by providing 
      # in-depth analytic metrics for their Google AdSense and AWS platforms.
      
      # Regardless of the industry or product, the process of A/B testing is the same. 
      # First, we must decide what changes will be made to the experimental group. 
      # Typically, the number of changes will be very limited to ensure comparisons are 
      # equal; however, more substantial changes can also be tested using an A/B framework.
      
      # Once a consensus has been made on the changes to be made to the experimental group,
      # a success metric should be determined. The success metric can vary widely, 
      # depending on what is being tested. For example, a website might use consumer 
      # engagement as a success metric (e.g., number of visitors, clicked links, or time 
      # spent on a page). Alternatively, an automotive design team might want to know how 
      # performance changes after a slight design change to a vehicle's form factor, so the
      # team's success metric might be mpg fuel efficiency.
      
      # Once we have decided on our experimental changes and the success metric, we must 
      # determine which statistical test is most appropriate. In this course, we'll only 
      # concern ourselves with normally distributed data and categorical data, which limits
      # the number of statistical tests we'll need. However, if the A/B test groups are 
      # disproportionately uneven, or if the success metric distribution is non-normal, 
      # more elaborate statistical analysis may be required.
      
      # For our purposes, we can apply the following logic to determine the most 
      # appropriate statistical test:
        
        # If the success metric is numerical and the sample size is small, a z-score 
          # summary statistic can be sufficient to compare the mean and variability of 
          # both groups.
        # If the success metric is numerical and the sample size is large, a two-sample 
          # t-test should be used to compare the distribution of both groups.
        # If the success metric is categorical, you may use a chi-squared test to compare 
          # the distribution of categorical values between both groups.
      
      # After determining the testing conditions and statistical test, the next 
      # consideration in A/B testing is sample size. It's important to collect a 
      # sufficient number of data points for each group to ensure that the A/B test 
      # results are meaningful.

    # There are multiple ways to determine optimal sample size, such as quantitative power 
      # analyses, but often a qualitative estimate is sufficient. If the changes made to 
      # the experimental group are expected to have a strong effect on the success metric 
      # (often referred to in data science as an effect size), fewer data points are 
      # necessary for the test. In contrast, if the effect size is small, a larger sample 
      # size will be necessary for meaningful statistical findings.

    # For example, if we were testing purchase rates on an experiment group that receives 
      # a pop-up notification when visiting the AutosRUs website, we may use historical 
      # purchase rates as an indicator of effect size. If in general people who visit the 
      # site are likely to purchase a vehicle, our A/B test sample size can be small. 
      # However, if most people who visit the site are not likely to purchase a vehicle, 
      # we would need a large number of data points to confirm if the pop-up notifications 
      # make a statistical difference.

  # NOTE - Using a quantitative power analysis can be helpful to determine sample size 
      # when effect size is unknown or resources are limited. Although performing a power 
      # analysis is outside the scope of this course, there is robust documentation online 
      # regarding implementation (Links to an external site.) and interpretation (Links to 
      # an external site.).

  # Due to its simple design and flexible application, the A/B testing framework is 
      # quickly becoming a go-to standard in the data science industry and one of the most 
      # highly desired data skills for Fortune 500 companies. Regardless, if you have 
      # experience in product design or optimization, you can use A/B testing to make 
      # informed design changes and confident development decisions.
      
# 15.10.1 Whose Analysis is it Anyway? 
# When using data to make informed decisions in a professional environment, implementing 
      # a statistics function is not the biggest challenge. Rather, it's determining what 
      # questions to ask.
      
      # In data science, researchers use retrospective analysis to analyze and interpret a 
      # previously generated dataset where the outcome is already known. Retrospective 
      # analyses are helpful because there are no upfront costs to generate data and 
      # statistical results can be compared to the known outcomes. Depending on the 
      # dataset and input variables, there is a (potentially) limitless number of 
      # statistical questions that can be asked from the data:
        
        # Are two groups statistically different? Use a t-test with one dichotomous 
          # independent variable and one continuous dependent variable.
        # Can one continuous dependent variable be predicted using another independent 
          # variable? What about multiple independent variables and one dependent variable?
          # Use regression analysis.
        # Are there multiple categorical variables tightly linked in a dataset? Are the 
          # distributions of the different categorical variables equal? We can test with 
          # chi-squared.
      
      # In contrast, researchers can design their own study to answer their own specific 
        # questions. In this case, the data types and size of the dataset will be directly 
        # reflective of how complicated their hypotheses are, and what statistical analyses
        # are required to answer the question.
      
      # For example, if we want to verify that a car battery ages at an appropriate rate, 
      # we would need to test our question with a regression model. If we were to use a 
      # multiple linear regression model, we would need to collect numerical variables, 
      # such as number of uses, time, battery capacity, tire tread, and engine horsepower. 
      # Once we select the variables to collect, we would estimate sample size based on how
      # low of a significance level is necessary and how sensitive the measurements are.
      
      # Regardless, if we collect and measure the data ourselves, or if the data has been 
      # curated from a previous dataset, statistical tests can help us provide quantitative
      # interpretation to the results. 