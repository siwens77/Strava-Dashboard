library(shiny)
library(shinydashboard)
library(plotly)
library(DT)
library(dplyr)
library(lubridate)
library(fontawesome)

options(plotly.install_msg = FALSE)

ORANGE      <- "#FC4C02"
ORANGE_LITE <- "#FFE0D4"
DARK        <- "#1a1a2e"
GREY        <- "#6b7280"

TYPE_COLORS <- c(
  "Run"     = "#FC4C02",
  "Ride"    = "#3b82f6",
  "Swim"    = "#06b6d4",
  "Hike"    = "#10b981",
  "Walk"    = "#8b5cf6",
  "Workout" = "#eab308", 
  "Other"   = "#9ca3af"
)

activity_color <- function(type) {
  unname(ifelse(type %in% names(TYPE_COLORS), TYPE_COLORS[type], TYPE_COLORS["Other"]))
}

strava_layout <- function(p, xlab = "", ylab = "", ...) {
  p %>%
    layout(
      paper_bgcolor = "transparent",
      plot_bgcolor  = "transparent",
      font = list(family = "Inter, sans-serif", color = GREY, size = 12),
      xaxis = list(
        title      = list(text = xlab, font = list(size = 11, color = GREY)),
        gridcolor  = "#f3f4f6",
        linecolor  = "#e5e7eb",
        tickfont   = list(size = 11, color = "#9ca3af"),
        zeroline   = FALSE
      ),
      yaxis = list(
        title      = list(text = ylab, font = list(size = 11, color = GREY)),
        gridcolor  = "#f3f4f6",
        linecolor  = "transparent",
        tickfont   = list(size = 11, color = "#9ca3af"),
        zeroline   = FALSE
      ),
      hoverlabel = list(
        bgcolor    = DARK,
        bordercolor = ORANGE,
        font       = list(color = "white", size = 12, family = "Inter")
      ),
      margin = list(l = 50, r = 20, t = 20, b = 45),
      ...
    ) %>%
    config(displayModeBar = FALSE)
}

load_activities <- function(path = "activities.csv") {
  if (file.exists(path)) {
    df <- read.csv(path, check.names = FALSE, stringsAsFactors = FALSE)
    
    expected <- c("activity_id","date","name","type","description",
                  "elapsed_time_s","distance_km","max_hr","relative_effort",
                  "elapsed_time2","moving_time_s","distance_m",
                  "max_speed","avg_speed","elevation_gain","elevation_loss",
                  "elevation_low","elevation_high","max_grade","avg_grade","calories")
    n_cols   <- min(ncol(df), length(expected))
    names(df)[seq_len(n_cols)] <- expected[seq_len(n_cols)]
    
    d1 <- suppressWarnings(as.Date(strptime(df$date, "%b %d, %Y, %I:%M:%S %p")))
    d2 <- suppressWarnings(as.Date(df$date, format = "%Y-%m-%d"))
    df$date <- as.Date(ifelse(is.na(d1), d2, d1), origin = "1970-01-01")
    
    if (all(is.na(df$date))) {
      df$date <- as.Date(df[[ grep("date", names(df), ignore.case=TRUE)[1] ]],
                         tryFormats = c("%Y-%m-%d","%m/%d/%Y","%d/%m/%Y"))
    }
  } else {
    df <- generate_sample_data()
    df$date <- as.Date(df$date)
  }
  
  for (col in c("distance_km","max_hr","relative_effort","moving_time_s",
                "elevation_gain","elevation_loss","max_speed","avg_speed",
                "calories","avg_grade","max_grade")) {
    if (col %in% names(df)) df[[col]] <- suppressWarnings(as.numeric(df[[col]]))
  }
  
  df$year      <- as.integer(format(df$date, "%Y"))
  df$month     <- format(df$date, "%Y-%m")
  df$month_num <- as.integer(format(df$date, "%m"))
  df$month_lbl <- format(df$date, "%b")
  df$week_num  <- as.integer(format(df$date, "%V"))
  df$day_of_wk <- as.integer(format(df$date, "%u"))   # 1=Mon … 7=Sun
  df$moving_time_min <- round(df$moving_time_s / 60, 1)
  df$calories[is.na(df$calories)]             <- 0
  df$elevation_gain[is.na(df$elevation_gain)] <- 0
  df$elevation_loss[is.na(df$elevation_loss)] <- 0
  df$type <- stringr::str_to_title(trimws(df$type))
  df$type[!df$type %in% names(TYPE_COLORS)] <- "Other"
  
  df <- df[!is.na(df$date), ]
  df
}
fmt_dist <- function(x) ifelse(x >= 1, sprintf("%.1f km", x), sprintf("%.0f m", x*1000))
fmt_time <- function(s) {
  h <- floor(s / 3600); m <- floor((s %% 3600) / 60)
  if (h > 0) sprintf("%dh %02dm", h, m) else sprintf("%dm", m)
}