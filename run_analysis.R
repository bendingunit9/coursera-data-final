library(dplyr)

xtest <- read.table("./test/X_test.txt")
ytest <- read.table("./test/y_test.txt")
testsubject <- read.table("./test/subject_test.txt")

xtrain <- read.table("./train/X_train.txt")
ytrain <- read.table("./train/y_train.txt")
trainsubject <- read.table("./train/subject_train.txt")

features <- read.table("features.txt")
activitycodes <- read.table("activity_labels.txt")

colnames(xtest) <- gsub("\\.", "", make.names( tolower( features[,2] ) ) )
colnames(xtrain) <- gsub("\\.", "", make.names( tolower( features[,2] ) ) )

activitylabel <- activitycodes[match(ytest$V1, activitycodes$V1),2]
xtest <- data.frame(activitylabel, testsubject, xtest)
names(xtest)[2] <- "subject"

activitylabel <- activitycodes[match(ytrain$V1, activitycodes$V1),2]
xtrain <- data.frame(activitylabel, trainsubject, xtrain)
names(xtrain)[2] <- "subject"

merged <- rbind(xtest,xtrain)

meanstd <- merged[,grep("mean|std",names(merged))]

activitygroup <- merged %>% group_by(activitylabel) %>% summarise_each(funs(mean))
activitygroup$subject <- NA
subjectgroup <- merged %>% group_by(subject) %>% summarise_each(funs(mean))
subjectgroup$activitylabel <- NA

both <- rbind(activitygroup, subjectgroup)

write.table(both, file="data.txt", row.name=FALSE)

#xtest[c(1,100,500,1000,1500,2000),1:5]
#xtrain[c(1,100,500,1000,1500,2000),1:5]
#merged[c(1,1000,5000,10000),1:5]
meanstd[c(1,1000,5000,10000),1:5]
both[,1:5]
