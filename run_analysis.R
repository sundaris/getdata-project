
## Assume that the data already available in your working directory
## data.table & reshape2 package is loaded in your directory
## create an vector of directory names to merge the data

library(data.table)
library(reshape2)
dirnames=c("train","test")
len=length(dirnames)
## Loop the data thru each directory

## Initialize the dataset
dataset=data.table()

## read the features file to get the feature and column info
  features=read.table("./UCI HAR Dataset/features.txt")
## Get the columns names which has mean and std variable
  feature1=features[grep("mean()|std",features$V2),]
  
## Ignore the coumns which has meanFreq
  feature2=feature1[- grep("meanFreq",feature1$V2),]
  rows=nrow(feature2)
  ## Initializing the null vector to store the column number to read it
  featurecolmns=c()
 ## Initialize the vector to store the column names 
  featurecolnames=c()
  ## save the column number 
  featurecolmns=feature2$V1
  ## Save the column names
  featurecolnames=feature2$V2
 ## for (rs in 1:rows)
  ##{
   ## featurecolmns=c(featurecolmns,feature2[rs,"V1"])
	##featurecolnames=c(featurecolnames,feature2[rs,"V2"])
  ##}
  ## replace the columns names which has () and - with null 
  ## For instance tBodyAcc-mean()-X name will become tBodyAccmeanX
  fcolnames=gsub("[:():]|-","",featurecolnames)
  
  ## Below for loop will loop thru train and test data directories
for (i in 1:len)
{
  
  
  ## Construct the train data file name 
  xdatafilename=paste("X_",dirnames[i],".txt",sep="")
  filename=paste("./UCI HAR Dataset",dirnames[i],xdatafilename,sep="/")
  ## Read the Training data
  xdata=read.table(filename)
  
  ## construct the file name
  subdatafilename=paste("subject_",dirnames[i],".txt",sep="")
  filename=paste("./UCI HAR Dataset",dirnames[i],subdatafilename,sep="/")
  ## Read subject data
  subdata=read.table(filename)
  
  ## construct the activity data label file name
  actfilename=paste("y_",dirnames[i],".txt",sep="")
  filename=paste("./UCI HAR Dataset",dirnames[i],actfilename,sep="/")
  ## Read Activity label data
  actdata=read.table(filename)
  
  ## Below code will replace the activity numbers with descriptive activity names
  activity_labels<-c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")
  actlabeldata=data.table(actdata=activity_labels[actdata$V1])
  ## Combine the subject, activity and train data sets
  actdataset=cbind(subdata,actlabeldata,xdata[,featurecolmns])
  
  ## At the end of the loop, two data set train and test will be merged into dataset
  dataset=rbind(dataset,actdataset)
  
}
colnames(dataset)<-c("SUBJECT","ACTIVITY",fcolnames)
#write.csv(dataset,file="formatted_data.csv",row.names=FALSE)

## Melt the data based on subject and activity
testmelt<-melt(dataset,id=c("SUBJECT","ACTIVITY"))

## Calculate the mean based on the subject and activity
subcast=dcast(testmelt,SUBJECT+ACTIVITY~variable,mean)
tidycolnames=gsub("^t","MEANOFTIME",colnames(subcast))
colnames(subcast)=gsub("^f","MEANOFFREQ",tidycolnames)
write.table(subcast,file="tidydataset.txt",row.names=FALSE)
