require("data.table")
require("reshape2")

al <- read.table("UCI HAR Dataset/activity_labels.txt")
fe <- read.table("UCI HAR Dataset/features.txt")

Xtr<- read.table("UCI HAR Dataset/train/X_train.txt")
ytr <- read.table("UCI HAR Dataset/train/y_train.txt")
str <- read.table("UCI HAR Dataset/train/subject_train.txt")

Xte<- read.table("UCI HAR Dataset/test/X_test.txt")
yte <- read.table("UCI HAR Dataset/test/y_test.txt")
ste <- read.table("UCI HAR Dataset/test/subject_test.txt")

names(Xtr)<-fe[,2]
names(Xte)<-fe[,2]

# Xtr1<-Xtr[,grepl(".*mean*.|.*std*.", fe$V2)]  
# Xte1<-Xte[,grepl(".*mean*.|.*std*.", fe$V2)] 
Xtr1<-Xtr[,grepl("mean|std", fe$V2)]
Xte1<-Xte[,grepl("mean|std", fe$V2)]

al1<-al$V2 

ytr[,2]<-al1[ytr[,1]]
yte[,2]<-al1[yte[,1]]

names(ytr)<-c("Act_ID", "Act_Label")
names(str) <- "subject"

names(yte)<-c("Act_ID", "Act_Label")
names(ste) <- "subject"

dtr<-cbind(str,ytr,Xtr1)
dte<-cbind(ste,yte,Xte1)


X<-rbind(dte,dtr)

idl   = c("subject", "Act_ID", "Act_Label")
dal = setdiff(colnames(X), idl)
med      = melt(X, id = idl, measure.vars = dal)
med$value<-as.numeric(med$value)
tidy   <- dcast(med, subject + Act_Label ~ variable, mean)

write.table(tidy, file = "tidy_data.txt",row.name=FALSE )