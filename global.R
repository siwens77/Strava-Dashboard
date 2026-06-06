library(shiny)
library(shinydashboard)
library(plotly)
library(DT)
library(dplyr)
library(lubridate)
library(fontawesome)
library(httr)
library(jsonlite)


if (file.exists('.env')) {
  lines <- readLines('.env', warn = FALSE)
  lines <- lines[grepl('=', lines) & !grepl('^\\s*#', lines)]
  for (ln in lines) {
    kv <- strsplit(ln, '=', fixed = TRUE)[[1]]
    if (length(kv) >= 2) {
      key <- trimws(kv[1])
      val <- paste(kv[-1], collapse = '=')
      val <- trimws(gsub('^"|"$|^\'\'|\'\'$','', val))
      do.call(Sys.setenv, setNames(list(val), key))
    }
  }
}

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
    plotly::layout(
      paper_bgcolor = "transparent",
      plot_bgcolor  = "transparent",
      font = list(family = "Inter, sans-serif", color = GREY, size = 12),
      xaxis = list(
        title      = list(text = xlab, font = list(size = 13, color = "#1f2937")),
        gridcolor  = "#f3f4f6",
        linecolor  = "#e5e7eb",
        tickfont   = list(size = 12, color = "#1f2937"),
        zeroline   = FALSE
      ),
      yaxis = list(
        title      = list(text = ylab, font = list(size = 13, color = "#1f2937")),
        gridcolor  = "#f3f4f6",
        linecolor  = "transparent",
        tickfont   = list(size = 12, color = "#1f2937"),
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
    plotly::config(displayModeBar = FALSE)
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
  df$day_of_wk <- as.integer(format(df$date, "%u"))
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


PCSS_BASE_URL <- Sys.getenv("PCSS_BASE_URL", "https://llm.hpc.psnc.pl/v1")
PCSS_API_KEY  <- Sys.getenv("PCSS_API_KEY", "")

bielik_chat <- function(messages, model = Sys.getenv("PCSS_MODEL", "bielik_11b"), max_tokens = 600, temperature = 0.3) {
  if (PCSS_API_KEY == "") stop("PCSS_API_KEY is not set in environment")
  if (!is.list(messages)) stop("messages must be a list")

  sys_instruct <- paste(
    "Jesteś doświadczonym, szczerzym trenerem wydolności w aplikacji STRAVIZ. Brzmisz naturalnie, merytorycznie i po ludzku, jak ekspert rozmawiający z podopiecznym.",
    "Otrzymasz 'Context (from Strava)'. Traktuj te informacje jako swoją naturalną pamięć o użytkowniku. Nigdy nie używaj sformułowań typu 'z mojego kontekstu', 'widzę w danych' czy 'na podstawie dostarczonych statystyk'. Po prostu wplataj tę wiedzę w rozmowę.",
    "ZASADA TONU (NAJWAŻNIEJSZA): Unikaj toksycznej pozytywności i sztucznego entuzjazmu. ZAKAZ gratulowania, chyba że użytkownik obiektywnie pobił trudny rekord, osiągnął kamień milowy lub wykazał wyjątkową konsekwencję. Jeśli wyniki są słabe, przeciętne lub użytkownik pyta o błędy, bądź szczery. Oceniaj fakty, wykazuj empatię, ale nie pudruj rzeczywistości.",
    "ZASADA KONWERSACJI: Zawsze najpierw bezpośrednio odpowiadaj na pytanie użytkownika jednym, naturalnym zdaniem, zanim przejdziesz do analizy. Zwracaj ścisłą uwagę na dyscyplinę – nie proponuj roweru, gdy pyta o bieganie.",
    "Skupiaj się na praktycznych, opartych na liczbach zaleceniach. Nie narzekaj na brakujące dane — jeśli czegoś brakuje, po prostu przyjmij logiczne założenia.",
    "ZAKAZ podawania planów treningowych i list działań na nadchodzący tydzień, CHYBA ŻE użytkownik wprost poprosi o plan, radę lub rozpisanie tygodnia.",
    "Jeśli użytkownik prosi o plan treningowy, podaj krótki, realistyczny schemat w formie zwykłych zdań (np. 3 sesje w tygodniu, z podziałem na typ i czas).",
    "Rozmawiaj wyłącznie o sporcie i regeneracji. Przy innych tematach krótko ucina dyskusję.",
    "FORMATOWANIE (RYGORSTYCZNIE PRZESTRZEGAJ): Używaj WYŁĄCZNIE czystego tekstu po polsku. Kategoryczny ZAKAZ używania Markdown (żadnych gwiazdek, pogrubień, hashtagów), list wypunktowanych/numerowanych, kodu, HTML oraz emoji (np. rakiet, biegaczy, uśmieszków).",
    sep = " \n"
  )

  if (length(messages) == 0 || messages[[1]]$role != "system") {
    messages <- c(list(list(role = "system", content = sys_instruct)), messages)
  } else {
    messages[[1]]$content <- paste(sys_instruct, messages[[1]]$content, sep = "\n")
  }

  url <- paste0(PCSS_BASE_URL, "/chat/completions")
  
  body <- list(
    model = model, 
    messages = messages, 
    max_tokens = max_tokens,
    temperature = temperature,
    frequency_penalty = 0.0,
    presence_penalty = 0.0
  )
  
  res <- httr::POST(url,
                   httr::add_headers(Authorization = paste("Bearer", PCSS_API_KEY)),
                   httr::accept_json(),
                   httr::content_type_json(),
                   body = jsonlite::toJSON(body, auto_unbox = TRUE))

  if (httr::status_code(res) >= 400) {
    stop(sprintf("LLM request failed: %s", httr::content(res, as = "text", encoding = "UTF-8")))
  }
  
  parsed <- httr::content(res, as = "parsed", type = "application/json", encoding = "UTF-8")
  if (!is.null(parsed$choices) && length(parsed$choices) > 0) {
    res_text <- as.character(parsed$choices[[1]]$message$content)
    
    res_text <- gsub("\\\\n", "\n", res_text, perl=TRUE)
    res_text <- gsub("\\\\r\\\\n", "\n", res_text, perl=TRUE)
    res_text <- gsub("`+", "", res_text)
    res_text <- gsub("\\*\\*(.*?)\\*\\*", "\\1", res_text, perl=TRUE)
    res_text <- gsub("\\*([^\\n]+)\\*", "\\1", res_text, perl=TRUE)
    res_text <- gsub("^\\s*#+\\s*", "", res_text, perl=TRUE)
    res_text <- gsub("\\n\\s*\\d+\\.\\s*", "\n", res_text, perl=TRUE)
    res_text <- gsub("\\n\\s*[-*+]\\s*", "\n", res_text, perl=TRUE)
    res_text <- gsub("[•▪︎◆►◦]", "", res_text)
    res_text <- gsub("<[^>]+>", "", res_text)
    res_text <- gsub("[\\*_]{2,}", "", res_text)
    res_text <- gsub("\\[([^\\]]+)\\]\\([^\\)]+\\)", "\\1", res_text, perl=TRUE)
    res_text <- gsub("(\n){2,}", "\n\n", res_text, perl=TRUE)
    
    res_text <- paste(trimws(strsplit(res_text, "\n")[[1]]), collapse = "\n")
    res_text <- trimws(res_text)
    return(res_text)
  }
  stop("No response from LLM")
}