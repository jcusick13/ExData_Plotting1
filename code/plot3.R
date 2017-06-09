# plot3.R

# Download dataset
temp <- tempfile()
f <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip" 
download.file(f, temp)
data <- read.table(unz(temp, "household_power_consumption.txt"), sep = ";", header = TRUE,
                   stringsAsFactors = FALSE)
unlink(temp)

# Subset data to days of interest
data$Date <- as.Date(data$Date, "%d/%m/%Y")
meter <- subset(data, Date == "2007-02-01" | Date == "2007-02-02")

# Create combined datetime field
meter$datetime <- strptime(paste(meter$Date, meter$Time), format = "%Y-%m-%d %H:%M:%S")

# Convert desired columns into numerics
nums <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
meter[, nums] <- apply(meter[, nums], 2, function (x) as.numeric(as.character(x)))

# Create graphics device
png(filename = "plot3.png", width = 480, height = 480)

# Plot
plot(meter$datetime, meter$Sub_metering_1, type = "l", xlab = "",
     ylab = "Energy Sub Metering")
lines(meter$datetime, meter$Sub_metering_2, col = "red")
lines(meter$datetime, meter$Sub_metering_3, col = "blue")
legend("topright", c("Sub Metering 1", "Sub Metering 2", "Sub Metering 3"),
       lty = 1, col = c("black", "red", "blue"))

# Cleanup
dev.off()
