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
# <- "C:/Users/kreut/Projekte/thesis/autoplot/"
#export_path <- "C:/Users/kreut/Projekte/thesis/autoplot/export"

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
      xlab("Time (min)") +
      ylab("") +
      theme_ipsum() +
      theme(
        axis.title.x = element_text(color = axisLabelColor, size=35),
        axis.text.x = element_text(size=15),
        axis.text.y = element_text(size=15),
        legend.position = "none",
        plot.title = element_text(size=45)
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
time_in_seconds <- time_in_seconds / 60


# call drawPlot function for each plot
cpu_usage_plot <- drawPlot("CPU-Verbrauch (%)", "CPU utilization (%)", cpu_usage / 1000, time_in_seconds)
dsk_R_plot <- drawPlot("Gelesene Bytes (KB)", "Gelesene Bytes (KB)", measurements$X.DSK.ReadKBTot, time_in_seconds)
dsk_T_plot <- drawPlot("Geschriebene Bytes (KB)", "Geschriebene Bytes (KB)", measurements$X.DSK.WriteKBTot, time_in_seconds)
mem_used_plot <- drawPlot("Arbeitsspeicher-Verbrauch (MB)", "RAM used (MB)", measurements$X.MEM.Used / 1000, time_in_seconds)
network_R_plot <- drawPlot("Empfangene Bytes (KB)", "Empfangene Bytes (KB)", measurements$X.NET.RxKBTot, time_in_seconds)
network_T_plot <- drawPlot("Übertragene Bytes (KB)", "Übertragene Bytes (KB)", measurements$X.NET.TxKBTot, time_in_seconds)


# Build figures with multiple plots
cpu_figure <- ggarrange(
  cpu_usage_plot, nrow = 1
)
dsk_figure <- ggarrange(
  dsk_R_plot, dsk_T_plot, nrow = 2
)
mem_figure <- ggarrange(
  mem_used_plot, nrow = 1
)
net_figure <- ggarrange(
  network_R_plot, network_T_plot, nrow = 2
)


# Create directories for exports with todays date and save figures into it
dir.create(file.path(export_path), showWarnings = FALSE)

dir.create(file.path(export_path, app_name), showWarnings = FALSE)
dir.create(file.path(app_name_path, date_path), showWarnings = FALSE)
setwd(file.path(app_name_path, date_path))

# get filenames
cpu_output_name <- removeWhitespaceAndColon(paste(Sys.time(), "CPU_figure.png"))
dsk_output_name <- removeWhitespaceAndColon(paste(Sys.time(), "DSK_figure.png"))
mem_output_name <- removeWhitespaceAndColon(paste(Sys.time(), "MEM_figure.png"))
net_output_name <- removeWhitespaceAndColon(paste(Sys.time(), "NET_figure.png"))


ggexport(cpu_figure, filename = paste(cpu_output_name), width=1920, height=1080)
ggexport(dsk_figure, filename = paste(dsk_output_name), width=1920, height=1080)
ggexport(mem_figure, filename = paste(mem_output_name), width=1920, height=1080)
ggexport(net_figure, filename = paste(net_output_name), width=1920, height=1080)
