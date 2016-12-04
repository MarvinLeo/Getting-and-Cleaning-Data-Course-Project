library(dplyr)
curwd <- getwd()

#read the feature names and activity labels
features <- read.table('features.txt')
features <- as.character(features$V2)
activity_labels <- read.table('activity_labels.txt')

#read the train and test datasets
setwd('train')
Xtrain <- read.table('X_train.txt')
Ytrain <- read.table('y_train.txt')
sub_train <- read.table('subject_train.txt')
setwd(curwd)
setwd('test')
Xtest <- read.table('X_test.txt')
Ytest <- read.table('y_test.txt')
sub_test <- read.table('subject_test.txt')

#merge the train and test together
Y_data <- rbind(Ytrain, Ytest)
X_data <- rbind(Xtrain, Xtest)
sub_data <- rbind(sub_train, sub_test)

#name the columns with a descriptive name
colnames(X_data) <- features
X_data <- X_data[,c(grep('mean', features) , grep('std', features) )]

#combine the subject and activity into the dataset and give activity descriptive labels
df <- cbind(sub_data, X_data)
colnames(df) <- c('subject', colnames(X_data))
df_name <- colnames(df)
df <- cbind(Y_data, df)
df1 <- merge(df, activity_labels, by = 'V1')
df1 <- df1[, c(82, 2:81)]
colnames(df1) <- c('activity', df_name)

#clean the step 4 data, obtain average of each measument of each subject of each activity
Df2<-aggregate(. ~subject + activity, df1, mean)
Df2<-Df2[order(Df2$subject,Df2$activity),]
setwd(curwd)

#save the table
write.table(df1, file = "tidydata1.txt",row.name=FALSE)
write.table(Df2, file = "tidydata2.txt",row.name=FALSE)
