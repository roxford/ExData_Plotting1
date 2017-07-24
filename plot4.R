Plot4 <- function()
{
    power <- EDAPower();
    
    Plot4_internal(power);
}

EDAPower <- function()
{
    library(lubridate)
    
    # Precondition: Electric power consumption dataset is located at "./household_power_consumption/household_power_consumption.txt"
    # Skip the header and all rows prior to those dated 2/1/2007 ( so 1 + 66636 rows), then add back in the column headers.
    # Relevant data occupies rows 66638 through 69517 inclusive.  Hence skip 66637 rows (the first of which is a header) and load 69517 - 66638 + 1 = 2880 rows.
    power <- read.table("./household_power_consumption/household_power_consumption.txt", sep=";", header=FALSE, skip=66637, nrows=2880, na.strings=c("?"),
                        colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"),  
                        col.names = c("Date", "Time", "GlobalActivePower", "GlobalReactivePower", "Voltage", "GlobalIntensity", "SubMetering1", "SubMetering2", "SubMetering3"))
    
    # Convert the Date and Time columns
    power$DateTime <- dmy_hms(paste(power$Date,  power$Time))
    
    power
}

Plot4_internal <- function(power)
{
    png("plot4.png", width=480, height=480)
    par(mfrow=c(2,2))
    
    plot(power$GlobalActivePower ~ power$DateTime, type="l", xlab="", ylab="Global Active Power")
    
    plot(power$Voltage ~ power$DateTime, type="l", xlab="datetime", ylab="Voltage")
    
    plot(power$DateTime, power$SubMetering1, type="n", xlab="", ylab="Energy sub metering")
    points(power$DateTime, power$SubMetering1, type="l", col="Black")
    points(power$DateTime, power$SubMetering2, type="l", col="Red")
    points(power$DateTime, power$SubMetering3, type="l", col="Blue")
    legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"), lwd=1.5, bty="n")
    
    plot(power$GlobalReactivePower ~ power$DateTime, type="l", xlab="datetime", ylab="Global_reactive_power" )
    
    dev.off()
}
