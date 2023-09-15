# Lade die erforderlichen Bibliotheken
library("ggplot2")

# Einlesen der CSV-Dateien in Datenrahmen
measurements <- read.csv("csv/solidjs.csv", na="NA", skip=0)
measurements2 <- read.csv("csv/sveltekit.csv", na="NA", skip=0)
measurements3 <- read.csv("csv/nextjs.csv", na="NA", skip=0)

# function to convert timestamp rownames-strings to numbers
convertStringToNumeric <- function(str) {
  str <- as.numeric(str)
}

# function to draw line plots
drawPlot <- function(title, yAxisLabel, xAxisLabel, metric) {
  if(metric == "X.MEM.Used") {
    measurements[, metric] <- measurements[, metric] / 1000
    measurements2[, metric] <- measurements2[, metric] / 1000
    measurements3[, metric] <- measurements3[, metric] / 1000
  }
  ggplot() +
    geom_line(data = measurements, aes(x = convertStringToNumeric(rownames(measurements)) -1, y = measurements[, metric], color = "Solid.js"), show.legend = TRUE) +
    geom_hline(yintercept = mean(measurements[, metric]), color="blue") +
    geom_line(data = measurements2, aes(x = convertStringToNumeric(rownames(measurements2)) -1, y = measurements2[, metric], color = "SvelteKit"), show.legend = TRUE) +
    geom_hline(yintercept = mean(measurements2[, metric]), color="orange") +
    geom_line(data = measurements3, aes(x = convertStringToNumeric(rownames(measurements3)) -1, y = measurements3[, metric], color = "Next.js"), show.legend = TRUE) +
    geom_hline(yintercept = mean(measurements3[, metric]), color="green") +
    labs(x = xAxisLabel, y = yAxisLabel) +
    theme(
      axis.title.x = element_text(size=15),
      axis.title.y = element_text(size=15),
      axis.text.x = element_text(size=15),
      axis.text.y = element_text(size=15),
      legend.position = "top",
      plot.title = element_text(size=18)
    ) +
    ggtitle(title) +
    scale_color_manual(values = c("Solid.js" = "blue", "SvelteKit" = "orange", "Next.js" = "green")) +
    guides(color = guide_legend(title = NULL))
}

# call drawPlot function for each plot
cpu_usage_plot <- drawPlot("CPU-Inanspruchnahme", "CPU-Inanspruchnahme (%)", "Zeit (s)", "X.CPU.Totl.")
dsk_R_plot <- drawPlot("Gelesene Bytes", "Gelesene Bytes (KB)",  "Zeit (s)", "X.DSK.ReadKBTot")
dsk_T_plot <- drawPlot("Geschriebene Bytes", "Geschriebene Bytes (KB)","Zeit (s)",  "X.DSK.WriteKBTot")
mem_used_plot <- drawPlot("Arbeitsspeicher-Inanspruchnahme", "RAM used (MB)", "Zeit (s)",  "X.MEM.Used")
network_R_plot <- drawPlot("Empfangene Bytes", "Empfangene Bytes (KB)", "Zeit (s)",  "X.NET.RxKBTot")
network_T_plot <- drawPlot("Uebertragene Bytes", "Uebertragene Bytes (KB)", "Zeit (s)",  "X.NET.TxKBTot")

# print(cpu_usage_plot)
# print(dsk_R_plot)
# print(dsk_T_plot)
print(mem_used_plot)
# print(network_R_plot)
# print(network_T_plot)