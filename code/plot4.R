# plot4.R

# Download dataset
temp <- tempfile()
f <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip" 
download.file(f, temp)
data <- read.table(unz(temp, "household_power_consumption.txt"), sep = ";", header = TRUE,
                   stringsAsFactors = FALSE)
unlink(temp)

# Subset data to days of interest
data$Date <- as.Date(data$Date, "%d/%m/%Y")
power <- subset(data, Date == "2007-02-01" | Date == "2007-02-02")
power$Global_active_power <- as.numeric(power$Global_active_power)

# Create combined datetime field
power$datetime <- strptime(paste(power$Date, power$Time), format = "%Y-%m-%d %H:%M:%S")

# Convert desired columns into numerics
nums <- c("Global_active_power", "Global_reactive_power", "Voltage", "Sub_metering_1", 
          "Sub_metering_2", "Sub_metering_3")
power[, nums] <- apply(power[, nums], 2, function (x) as.numeric(as.character(x)))

# Create graphics device
png(filename = "plot4.png", width = 480, height = 480)

# Create 4 panel layout and plot
par(mfcol = c(2, 2))
plot(power$datetime, power$Global_active_power, type = "l", ylab = "Global Active Power",
     xlab = "")
plot(power$datetime, power$Sub_metering_1, type = "l", ylab = "Energy Sub Metering",
     xlab = "")
lines(power$datetime, power$Sub_metering_2, col = "red")
lines(power$datetime, power$Sub_metering_3, col = "blue")
legend("topright", c("Sub Metering 1", "Sub Metering 2", "Sub Metering 3"),
       lty = 1, col = c("black", "red", "blue"))
plot(power$datetime, power$Voltage, type = "l", ylab = "Voltage", xlab = "")
plot(power$datetime, power$Global_reactive_power, type = "l",
     ylab = "Global Reactive Power", xlab = "")

# Cleanup
dev.off()
