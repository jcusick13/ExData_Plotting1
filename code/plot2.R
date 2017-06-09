# plot2.R

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

# Create graphics device
png(filename = "plot2.png", width = 480, height = 480)

# Plot graph
plot(power$datetime, power$Global_active_power, type = "l",
     ylab = "Global Active Power (kiolwatts)", xlab = "")

# Cleanup
dev.off()
