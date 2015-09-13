##Read Data
data=read.table("household_power_consumption.txt",sep=";",stringsAsFactors=FALSE,header=TRUE)
names(data)=c("DATE","TIME","GAP","GRP","VOLT","GINT","SM1","SM2","SM3")
## Read the data from 2007-02-01 and 2007-02-02
strdate=data[which(as.Date(data$DATE,"%m/%d/%Y")>= "2007-02-01" & as.Date(data$DATE,"%m/%d/%Y")<="2007-02-02"),]
hist(as.numeric(strdate$GAP),col="red",xlab="Global Active Power (kilowatts)", main="Global Active Power",breaks=12,xlim=c(0,6),ylim=c(0,1200))
dev.copy(png,file="plot1.png")
dev.off()
