#!/usr/bin/env Rscript
# ============================================================
# generate_data.R
# Run this script to create a realistic demo activities.csv
# Usage:  Rscript generate_data.R
#         Rscript generate_data.R 1000   # custom row count
# ============================================================

args <- commandArgs(trailingOnly = TRUE)
n    <- if (length(args) >= 1) as.integer(args[1]) else 650

source("global.R")   # loads generate_sample_data()

cat(sprintf("Generating %d sample activities...\n", n))
df <- generate_sample_data(n = n)

# Write in Strava export format (date as string)
write.csv(df, "activities.csv", row.names = FALSE)
cat(sprintf("Saved activities.csv  (%d rows, %d columns)\n",
            nrow(df), ncol(df)))
cat("Run shiny::runApp() to start the dashboard.\n")