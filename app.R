# Libraries
library(ggplot2)
library(viridis)
library(dplyr)
library(hms)
library(gridExtra)
library(ggpubr)


# Path
#base_path <- "C:/Users/kreut/OneDrive/Uni/Bachelor-Thesis/Quellcode/CSV-Analyser/"
#export_path <- "C:/Users/kreut/OneDrive/Uni/Bachelor-Thesis/Quellcode/CSV-Analyser/export/"

#base_path <- "/var/lib/jenkins/workspace/Autoplot/"
#export_path <- "/var/lib/jenkins/workspace/Autoplot/export/"

base_path <- "~/workspace/Autoplot/"
export_path <- "~/workspace/Autoplot/export/"

date_path <- toString(Sys.Date())


# Colors
axisLabelColor <- "#69b3a2"
yAxisColor <- "black"


# Import CSV from Collectl
measurements <- read.csv(file = "csv/collectl.csv", na="NA", stringsAsFactors = FALSE, header=TRUE, sep=",", row.names=NULL)

# function to draw line plots
drawPlot <- function(title, yAxisLabel, measurement, time) {
    ggplot(measurements, aes(x=time, y=measurement, group=1)) +
        geom_line(measurements, aes(x=time, y=measurement)) +
        scale_y_continuous(
            name = yAxisLabel,
        ) +
        ggtitle(title)
}

removeWhitespaceAndColon <- function(filename) {
  filename <- chartr(":", "-", filename)
  filename <- chartr(" ", "_", filename)
}


# call drawPlot function for each plot
# cpu_user_plot <- drawPlot("CPU User", "CPU-Verbrauch (%)", data_csv[[3]], data_csv[[2]])
# cpu_nice_plot <- drawPlot("CPU Nice", "CPU-Verbrauch (%)", data_csv[[4]], data_csv[[2]])
# cpu_system_plot <- drawPlot("CPU System", "CPU-Verbrauch (%)", data_csv[[5]], data_csv[[2]])
# cpu_wait_plot <- drawPlot("CPU Wait", "CPU-Verbrauch (%)", data_csv[[6]], data_csv[[2]])
# cpu_idle_plot <- drawPlot("CPU Idle", "CPU-Verbrauch (%)", data_csv[[15]], data_csv[[2]])
mem_used_plot <- drawPlot("Arbeitsspeicher-Verbrauch", "RAM used (MB)", measurements$X.MEM.Used, measurements$Time)

# # Build figures with multiple plots
# cpu_figure <- ggarrange(
#   cpu_user_plot, cpu_nice_plot, cpu_system_plot, cpu_wait_plot, cpu_idle_plot, nrow = 5
# )

mem_figure <- ggarrange(
  mem_used_plot, nrow = 1
)


# Create directories for exports with todays date and save figures into it
dir.create(file.path(export_path), showWarnings = FALSE)

dir.create(file.path(export_path, date_path), showWarnings = FALSE)
#setwd(file.path(export_path, date_path))


# get filenames
#cpu_output_name <- removeWhitespaceAndColon(paste(Sys.time(), "CPU_figure.png"))
mem_output_name <- removeWhitespaceAndColon(paste(Sys.time(), "MEM_figure.png"))

#ggexport(cpu_figure, filename = paste(cpu_output_name), width = 1920, height = 1080)
ggexport(mem_figure, filename = paste(mem_output_name), width = 1920, height = 1080)


mem_figure