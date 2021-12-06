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
#base_path <- "C:/Users/kreut/OneDrive/Uni/Bachelor-Thesis/Quellcode/CSV-Analyser/"
#export_path <- "C:/Users/kreut/OneDrive/Uni/Bachelor-Thesis/Quellcode/CSV-Analyser/export/"

#base_path <- "/var/lib/jenkins/workspace/Autoplot/"
#export_path <- "/var/lib/jenkins/workspace/Autoplot/export/"

base_path <- "~/workspace/autoplot/"
export_path <- "~/workspace/autoplot/export/"

date_path <- toString(Sys.Date())
csv_path <- "csv/collectl.csv"

setwd(file.path(base_path))


# Colors
axisLabelColor <- "#69b3a2"
yAxisColor <- "black"


# Import CSV from Collectl
measurements <- read.csv(file = csv_path, na="NA")

# function to draw line plots
drawPlot <- function(title, yAxisLabel, measurement, time) {
    ggplot(measurements, aes(x=time, y=measurement, group=1)) +
      geom_line() +
      xlab("Time in seconds") +
      ylab(yAxisLabel) +
      theme_ipsum() +
      theme(
        axis.title.y = element_text(color = axisLabelColor, size=20),
        axis.title.x = element_text(color = axisLabelColor, size=13),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        legend.position = "none",
      ) +
      ggtitle(title)
}

removeWhitespaceAndColon <- function(filename) {
  filename <- chartr(":", "-", filename)
  filename <- chartr(" ", "_", filename)
}


# call drawPlot function for each plot
mem_used_plot <- drawPlot("Arbeitsspeicher-Verbrauch", "RAM used (MB)", measurements$X.MEM.Used / 1000, measurements$Time)

# Build figures with multiple plots


mem_figure <- ggarrange(
  mem_used_plot, nrow = 1
)

# Create directories for exports with todays date and save figures into it
dir.create(file.path(export_path), showWarnings = FALSE)

dir.create(file.path(export_path, date_path), showWarnings = FALSE)
setwd(file.path(export_path, date_path))

# get filenames
#cpu_output_name <- removeWhitespaceAndColon(paste(Sys.time(), "CPU_figure.png"))
mem_output_name <- removeWhitespaceAndColon(paste(Sys.time(), "MEM_figure.png"))

#ggexport(cpu_figure, filename = paste(cpu_output_name), width = 1920, height = 1080)
ggexport(mem_figure, filename = paste(mem_output_name), width = 1920, height = 1080)





