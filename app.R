# Libraries
library("ggplot2")
library("viridis")
library("dplyr")
library("hrbrthemes")
library("hms")
library("gridExtra")
library("ggpubr")
library("hms")


#Paths
#base_path <- "C:/Users/kreut/Projekte/autoplot/"
#export_path <- "C:/Users/kreut/Projekte/autoplot/export"

base_path <- "/var/lib/jenkins/workspace/Autoplot/"
export_path <- "/var/lib/jenkins/workspace/Autoplot/export/"

#base_path <- "~/workspace/autoplot/"
#export_path <- "~/workspace/autoplot/export/"

setwd(file.path(base_path))

date_path <- toString(Sys.Date())
csv_path <- "csv/collectl.csv"
app_name_file_path <- "csv/app_name.txt"

# Name of the tested application
app_name <- readLines(app_name_file_path)
app_name_path <- file.path(export_path, app_name)


# Colors
axisLabelColor <- "#e73700"
yAxisColor <- "black"


# Import CSV from Collectl
measurements <- read.csv(file = csv_path, na="NA", skip=0)

    
# function to draw line plots
drawPlot <- function(title, yAxisLabel, measurement, time) {
    ggplot(measurements, aes(x=time, y=measurement, group=1)) +
      geom_line() +
      xlab("Time (s)") +
      ylab(yAxisLabel) +
      theme_ipsum() +
      theme(
        axis.title.y = element_text(color = axisLabelColor, size=10),
        axis.title.x = element_text(color = axisLabelColor, size=10),
        axis.ticks.x = element_blank(),
        legend.position = "none",
      ) +
      ggtitle(title)
} 

# function to replace whitespace and colons
removeWhitespaceAndColon <- function(filename) {
  filename <- chartr(":", "-", filename)
  filename <- chartr(" ", "_", filename)
}


# function to convert timestamp rownames-strings to numbers
convertStringToNumeric <- function(str) {
  str <- as.numeric(str)
}

cpu_usage <- (100 - measurements$X.CPU.Idle) * 100
time_in_seconds <- convertStringToNumeric(rownames(measurements)) -1


# call drawPlot function for each plot
mem_used_plot <- drawPlot("Arbeitsspeicher-Verbrauch", "RAM used (MB)", measurements$X.MEM.Used / 1000, time_in_seconds)
cpu_usage_plot <- drawPlot("CPU-Verbrauch", "CPU utilization (%)", cpu_usage / 1000, time_in_seconds)

network_plot <- drawPlot("Netzwerk-Auslastung", "RxKBTot", measurements$X.NET.RxKBTot / 1000, time_in_seconds)
cpu_usage_plot <- drawPlot("Netzwerk-Auslastung", "TxKBTot", measurements$X.NET.TxKBTot / 1000, time_in_seconds)


# Build figures with multiple plots
mem_figure <- ggarrange(
  mem_used_plot, nrow = 1
)
cpu_figure <- ggarrange(
  cpu_usage_plot, nrow = 1
)
net_figure <- ggarrange(
  network_plot, nrow = 1
)


# Create directories for exports with todays date and save figures into it
dir.create(file.path(export_path), showWarnings = FALSE)

dir.create(file.path(export_path, app_name), showWarnings = FALSE)
dir.create(file.path(app_name_path, date_path), showWarnings = FALSE)
setwd(file.path(app_name_path, date_path))

# get filenames
cpu_output_name <- removeWhitespaceAndColon(paste(Sys.time(), "CPU_figure.png"))
mem_output_name <- removeWhitespaceAndColon(paste(Sys.time(), "MEM_figure.png"))
net_output_name <- removeWhitespaceAndColon(paste(Sys.time(), "NET_figure.png"))


ggexport(cpu_figure, filename = paste(cpu_output_name))
ggexport(mem_figure, filename = paste(mem_output_name))
ggexport(net_figure, filename = paste(net_output_name))



