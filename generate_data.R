
args <- commandArgs(trailingOnly = TRUE)
n    <- if (length(args) >= 1) as.integer(args[1]) else 650

source("global.R")

cat(sprintf("Generating %d sample activities...\n", n))
df <- generate_sample_data(n = n)

write.csv(df, "activities.csv", row.names = FALSE)
cat(sprintf("Saved activities.csv  (%d rows, %d columns)\n",
            nrow(df), ncol(df)))
cat("Run shiny::runApp() to start the dashboard.\n")