run_Analysis <- function () {
    
    # Load libraries used for this analysis. 
    library(dplyr)
    library(data.table)
    
    # Prepare all the variables 
    #w_Dir               <- "~/mycloud/Private_DataScience/Coursera/10 Data Science Specialisation/20 Getting and Cleaning Data/99 assignment"
    #file_Target         <- "getdata_projectfiles_UCI HAR Dataset.zip"
    #file_Source         <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    file_Timestamp      <- "getdata_projectfiles_UCI_download_date.csv"
    data_Training       <- "./UCI HAR Dataset/train/X_train.txt"
    data_Testing        <- "./UCI HAR Dataset/test/X_test.txt"
    data_TrainSubject   <- "./UCI HAR Dataset/train/subject_train.txt"
    data_TestSubject    <- "./UCI HAR Dataset/test/subject_test.txt"
    
    # Position and pull the file
    #setwd(w_Dir)
    #download.file(file_Source, file_Target, method = "curl")

    # Mark download date
    date_Downloaded = c("Date Downloaded", date())
    write.csv(date_Downloaded, file = file_Timestamp )
    
    # Unzip the file
    unzip("getdata_projectfiles_UCI HAR Dataset.zip", overwrite = TRUE)
    
    # load the variable names for the data sets
    # Use read.csv here as we are going to subset the cols -> data.table NoGo
    df_Features <- read.csv("./UCI HAR Dataset/features.txt", header = FALSE, sep = " ")
    

    # TEST DATA
    
        # Inspect the column classes first and pre-load to speed up the larger load
        dt_Testing  <- fread(data_Testing, header = FALSE, sep = " ", nrows = 10)
        c_Classes   <- sapply(dt_Testing,  class)
        dt_Testing  <- fread(data_Testing, header = FALSE, sep = " ", colClasses = c_Classes)
    
        # Assign as column names to the test data set
        colnames(dt_Testing) <- as.character(df_Features[,2])
        
        # Load the file with the subjects who created the data set. Numeric for pretty-sort
        dt_Subject <- fread(data_TestSubject, header = FALSE, colClasses = "numeric")
        colnames(dt_Subject) <- c("Subject")
    
        # Add the subject column
        dt_Testing <- cbind(dt_Testing, dt_Subject)
        
        # Use dplyr to calculate the mean, and standard deviation of each variable
        # commented this out as was not sure how to deliver this
        #dt_Summary <- dt_Testing %>%
        #    group_by(Subject) %>%
        #    summarise_each(funs(mean,sd)) %>%
        #    arrange(Subject)
    
    # TRAINING DATA
   
        # Inspect the column classes first and pre-load to speed up the larger load
        dt_Training  <- fread(data_Testing, header = FALSE, sep = " ", nrows = 10)
        c_Classes   <- sapply(dt_Training,  class)
        dt_Training  <- fread(data_Training, header = FALSE, sep = " ", colClasses = c_Classes)
        
        # Assign as column names to the test data set
        colnames(dt_Training) <- as.character(df_Features[,2])
        
        # Load the file with the subjects who created the data set. Numeric for pretty-sort
        dt_Subject <- fread(data_TrainSubject, header = FALSE, colClasses = "numeric")
        colnames(dt_Subject) <- c("Subject")
        
        # Add the subject column
        dt_Training <- cbind(dt_Training, dt_Subject)
        
        # Use dplyr to calculate the mean, and standard deviation of each variable
        # commented this out as was not sure how to deliver this
        #dt_Summary <- dt_Training %>%
        #    group_by(Subject) %>%
        #    summarise_each(funs(mean,sd)) %>%
        #    arrange(Subject)
        
    # Merge the two data sets
    dt_Merged <- rbind(dt_Testing,dt_Training)
    
    # Use dplyr to calculate the mean of each variable
    dt_Summary <- dt_Merged %>%
        group_by(Subject) %>%
        summarise_each(funs(mean)) %>%
        arrange(Subject)
    
    # Save the results to disk
    write.table(dt_Summary,"./data_tidy/mean_TestTrain.txt", append = FALSE, row.name = FALSE)
    
    message("The aggregated means of test and training data can be found here ./data_tidy/mean_TestTrain.txt")

}