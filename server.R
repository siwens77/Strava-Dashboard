server <- function(input, output, session) {
  
  empty_plot <- function(msg = "No data for selected filters") {
    plotly::plot_ly(type = "scatter", mode = "markers") %>%
      plotly::layout(
        paper_bgcolor = "transparent",
        plot_bgcolor  = "transparent",
        xaxis = list(visible = FALSE, showgrid = FALSE, zeroline = FALSE),
        yaxis = list(visible = FALSE, showgrid = FALSE, zeroline = FALSE),
        annotations = list(list(
          text      = paste0("<b>", msg, "</b>"),
          xref      = "paper", yref = "paper",
          x = 0.5, y = 0.5, showarrow = FALSE,
          font      = list(size = 13, color = "#d1d5db",
                           family = "Inter, sans-serif")
        )),
        margin = list(l = 10, r = 10, t = 10, b = 10)
      ) %>%
      plotly::config(displayModeBar = FALSE)
  }

  layout <- plotly::layout
  config <- plotly::config
  activities_raw <- reactive({
    load_activities("activities.csv")
  })
  
  observe({
    df <- activities_raw()
    years <- sort(unique(df$year), decreasing = TRUE)
    types <- sort(unique(df$type))
    
    updateSelectInput(session, "ov_year",
                      choices  = c("All", as.character(years)),
                      selected = "All")
    updateSelectInput(session, "ov_type",
                      choices  = c("All", types),
                      selected = "All")
    updateSelectInput(session, "pf_type",
                      choices  = c("All", types),
                      selected = "All")
    updateSelectInput(session, "ins_type",
                      choices  = c("All", types),
                      selected = "All")
  })
  
  ov_data <- reactive({
    df <- activities_raw()
    if (!is.null(input$ov_year) && input$ov_year != "All")
      df <- df[df$year == as.integer(input$ov_year), ]
    if (!is.null(input$ov_type) && input$ov_type != "All")
      df <- df[df$type == input$ov_type, ]
    df
  })
  
  output$pf_date_ui <- renderUI({
    df <- activities_raw()
    sliderInput("pf_dates", NULL,
                min       = min(df$date, na.rm = TRUE),
                max       = max(df$date, na.rm = TRUE),
                value     = c(min(df$date, na.rm = TRUE), max(df$date, na.rm = TRUE)),
                timeFormat = "%Y-%m",
                step      = 30)
  })
  
  pf_filtered <- reactive({
    df <- activities_raw()
    if (!is.null(input$pf_type) && input$pf_type != "All")
      df <- df[df$type == input$pf_type, ]
    if (!is.null(input$pf_dates))
      df <- df[df$date >= input$pf_dates[1] & df$date <= input$pf_dates[2], ]
    df
  })
  output$ins_date_ui <- renderUI({
    df <- activities_raw()
    sliderInput("ins_dates", NULL,
                min       = min(df$date, na.rm = TRUE),
                max       = max(df$date, na.rm = TRUE),
                value     = c(min(df$date, na.rm = TRUE), max(df$date, na.rm = TRUE)),
                timeFormat = "%Y-%m",
                step      = 30)
  })

  ins_filtered <- reactive({
    df <- activities_raw()
    if (!is.null(input$ins_type) && input$ins_type != "All")
      df <- df[df$type == input$ins_type, ]
    if (!is.null(input$ins_dates))
      df <- df[df$date >= input$ins_dates[1] & df$date <= input$ins_dates[2], ]
    df
  })

  output$kpi_acts_custom <- renderUI({
    n <- nrow(ov_data())
    if (n == 0) {
      div(class = "col-sm-3",
          div(class = "kpi-card kpi-activities",
              div(class = "kpi-empty-state",
                  div(class = "kpi-empty-icon", icon("inbox")),
                  p("No activities for selected filters", style = "margin: 0;")
              )
          )
      )
    } else {
      div(class = "col-sm-3",
          div(class = "kpi-card kpi-activities",
              div(class = "kpi-content",
                  div(class = "kpi-icon", icon("running")),
                  div(class = "kpi-text",
                      p(class = "kpi-value", formatC(n, format = "d", big.mark = ",")),
                      p(class = "kpi-label", "Total Activities")
                  )
              )
          )
      )
    }
  })
  
  output$kpi_dist_custom <- renderUI({
    d <- sum(ov_data()$distance_km, na.rm = TRUE)
    if (nrow(ov_data()) == 0 || d == 0) {
      div(class = "col-sm-3",
          div(class = "kpi-card kpi-distance",
              div(class = "kpi-empty-state",
                  div(class = "kpi-empty-icon", icon("inbox")),
                  p("No distance data available", style = "margin: 0;")
              )
          )
      )
    } else {
      div(class = "col-sm-3",
          div(class = "kpi-card kpi-distance",
              div(class = "kpi-content",
                  div(class = "kpi-icon", icon("road")),
                  div(class = "kpi-text",
                      p(class = "kpi-value", paste0(formatC(round(d), format = "d", big.mark = ","), " km")),
                      p(class = "kpi-label", "Total Distance")
                  )
              )
          )
      )
    }
  })
  
  output$kpi_cals_custom <- renderUI({
    c <- sum(ov_data()$calories, na.rm = TRUE)
    if (nrow(ov_data()) == 0 || c == 0) {
      div(class = "col-sm-3",
          div(class = "kpi-card kpi-calories",
              div(class = "kpi-empty-state",
                  div(class = "kpi-empty-icon", icon("inbox")),
                  p("No calories data available", style = "margin: 0;")
              )
          )
      )
    } else {
      div(class = "col-sm-3",
          div(class = "kpi-card kpi-calories",
              div(class = "kpi-content",
                  div(class = "kpi-icon", icon("fire")),
                  div(class = "kpi-text",
                      p(class = "kpi-value", paste0(formatC(round(c), format = "d", big.mark = ","), " kcal")),
                      p(class = "kpi-label", "Calories Burned")
                  )
              )
          )
      )
    }
  })
  
  output$kpi_elev_custom <- renderUI({
    e <- sum(ov_data()$elevation_gain, na.rm = TRUE)
    if (nrow(ov_data()) == 0 || e == 0) {
      div(class = "col-sm-3",
          div(class = "kpi-card kpi-elevation",
              div(class = "kpi-empty-state",
                  div(class = "kpi-empty-icon", icon("inbox")),
                  p("No elevation data available", style = "margin: 0;")
              )
          )
      )
    } else {
      div(class = "col-sm-3",
          div(class = "kpi-card kpi-elevation",
              div(class = "kpi-content",
                  div(class = "kpi-icon", icon("mountain")),
                  div(class = "kpi-text",
                      p(class = "kpi-value", paste0(formatC(round(e), format = "d", big.mark = ","), " m")),
                      p(class = "kpi-label", "Elevation Gained")
                  )
              )
          )
      )
    }
  })

  output$kpi_acts <- renderValueBox({
    n <- nrow(ov_data())
    valueBox(
      value    = formatC(n, format = "d", big.mark = ","),
      subtitle = "Total Activities",
      icon     = icon("running"),
      color    = "aqua"
    )
  })
  
  output$kpi_dist <- renderValueBox({
    d <- sum(ov_data()$distance_km, na.rm = TRUE)
    valueBox(
      value    = paste0(formatC(round(d), format = "d", big.mark = ","), " km"),
      subtitle = "Total Distance",
      icon     = icon("road"),
      color    = "green"
    )
  })
  
  output$kpi_cals <- renderValueBox({
    c <- sum(ov_data()$calories, na.rm = TRUE)
    valueBox(
      value    = paste0(formatC(round(c), format = "d", big.mark = ","), " kcal"),
      subtitle = "Calories Burned",
      icon     = icon("fire"),
      color    = "orange"
    )
  })
  
  output$kpi_elev <- renderValueBox({
    e <- sum(ov_data()$elevation_gain, na.rm = TRUE)
    valueBox(
      value    = paste0(formatC(round(e), format = "d", big.mark = ","), " m"),
      subtitle = "Elevation Gained",
      icon     = icon("mountain"),
      color    = "red"
    )
  })
  
  output$heatmap_cal <- renderPlotly({
    df <- ov_data()
    if (nrow(df) == 0) return(empty_plot())
    
    yr <- if (!is.null(input$ov_year) && input$ov_year != "All")
      as.integer(input$ov_year)
    else as.integer(format(max(df$date, na.rm = TRUE), "%Y"))
    
    daily <- df %>%
      filter(year == yr) %>%
      group_by(date) %>%
      summarise(n = n(), dist = sum(distance_km, na.rm = TRUE), .groups = "drop")
    
    all_days <- data.frame(
      date = seq(as.Date(paste0(yr, "-01-01")),
                 as.Date(paste0(yr, "-12-31")), by = "day")
    )
    all_days <- all_days %>%
      left_join(daily, by = "date") %>%
      mutate(
        n    = replace(n, is.na(n), 0),
        dist = replace(dist, is.na(dist), 0),
        wk   = as.integer(format(date, "%V")),
        dow  = as.integer(format(date, "%u")),
        lbl  = format(date, "%d %b %Y")
      )
    
    m_val <- max(3, max(all_days$n))
    plotly::plot_ly(all_days,
            x = ~wk, y = ~dow, z = ~n,
            type          = "heatmap",
            colorscale    = list(c(0,"#f3f4f6"), c(0.01,"#ffd4c2"), c(1, ORANGE)),
            showscale     = TRUE,
            colorbar      = list(
              title = "",
              orientation = "h",
              x = 1.0, y = -0.25,
              xanchor = "right", yanchor = "top",
              thickness = 10, len = 0.25,
              tickmode = "array",
              tickvals = c(0, m_val),
              ticktext = c("Less", "More"),
              outlinewidth = 0,
              tickfont = list(size = 13, color = "#374151")
            ),
            hovertemplate = "<b>%{customdata}</b><br>Activities: %{z}<extra></extra>",
            customdata    = ~lbl,
            zmin = 0, zmax = m_val
    ) %>%
      layout(
        paper_bgcolor = "transparent",
        plot_bgcolor  = "transparent",
        xaxis = list(
          tickmode = "array",
          tickvals = c(3, 7, 11, 16, 20, 24, 29, 33, 38, 42, 46, 51),
          ticktext = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"),
          showline = FALSE,      
          title = "", showgrid = FALSE, zeroline = FALSE,
          tickfont = list(size = 10, color = "#9ca3af")
        ),
        yaxis = list(
          tickvals  = 1:7,
          ticktext  = c("Mon","","Wed","","Fri","","Sun"),
          title     = "", autorange = "reversed",
          showgrid  = FALSE, zeroline = FALSE,
          tickfont  = list(size = 10, color = "#9ca3af")
        ),
        margin = list(l = 35, r = 10, t = 5, b = 10)
      ) %>%
      config(displayModeBar = FALSE)
  })
  
  output$monthly_dist <- renderPlotly({
    df <- ov_data()
    if (nrow(df) == 0) return(empty_plot())
    
    metric <- if (!is.null(input$ov_metric)) input$ov_metric else "distance"
    
    min_year <- min(year(df$date), na.rm = TRUE)
    max_year <- max(year(df$date), na.rm = TRUE)
    
    all_months_seq <- seq(as.Date(paste0(min_year, "-01-01")), 
                          as.Date(paste0(max_year, "-12-01")), 
                          by = "month")
    all_months <- data.frame(ym = all_months_seq)
    
    if (metric == "elevation") {
      monthly <- df %>%
        mutate(ym = as.Date(paste0(format(date, "%Y-%m"), "-01"))) %>%
        group_by(ym, type) %>%
        summarise(elev = sum(elevation_gain, na.rm = TRUE), .groups = "drop")
      
      all_types <- unique(df$type)
      
      complete_monthly <- data.frame(
        ym = rep(all_months$ym, times = length(all_types)),
        type = rep(all_types, each = length(all_months$ym))
      ) %>%
        left_join(monthly, by = c("ym", "type")) %>%
        mutate(elev = ifelse(is.na(elev), 0, elev))
      
      p <- plotly::plot_ly()
      for (t in all_types) {
        sub <- complete_monthly[complete_monthly$type == t, ]
        p <- plotly::add_trace(p,
                       x = sub$ym, y = sub$elev, name = t,
                       type   = "bar",
                       marker = list(color = activity_color(t)),
                       hovertemplate = paste0("<b>", t, "</b><br>%{x|%b %Y}<br>%{y:.0f} m<extra></extra>")
        )
      }
      
      strava_layout(p, xlab = "", ylab = "meters") %>%
        layout(
          barmode = "stack",
          legend  = list(orientation = "h", y = -0.18, x = 0,
                         font = list(size = 13, color = "#1f2937")),
          xaxis   = list(type = "date", tickformat = "%b '%y",
                         tickfont = list(size = 12, color = "#1f2937"), showgrid = FALSE),
          yaxis   = list(title = list(font = list(size = 13, color = "#1f2937")),
                         tickfont = list(size = 12, color = "#1f2937"), showgrid = FALSE, showline = TRUE, linecolor = "#d1d5db", linewidth = 1)
        )
    } else {
      monthly <- df %>%
        mutate(ym = as.Date(paste0(format(date, "%Y-%m"), "-01"))) %>%
        group_by(ym, type) %>%
        summarise(dist = sum(distance_km, na.rm = TRUE), .groups = "drop")
      
      all_types <- unique(df$type)
      
      complete_monthly <- data.frame(
        ym = rep(all_months$ym, times = length(all_types)),
        type = rep(all_types, each = length(all_months$ym))
      ) %>%
        left_join(monthly, by = c("ym", "type")) %>%
        mutate(dist = ifelse(is.na(dist), 0, dist))
      
      p <- plotly::plot_ly()
      for (t in all_types) {
        sub <- complete_monthly[complete_monthly$type == t, ]
        p <- plotly::add_trace(p,
                       x = sub$ym, y = sub$dist, name = t,
                       type   = "bar",
                       marker = list(color = activity_color(t)),
                       hovertemplate = paste0("<b>", t, "</b><br>%{x|%b %Y}<br>%{y:.1f} km<extra></extra>")
        )
      }
      
      strava_layout(p, xlab = "", ylab = "km") %>%
        layout(
          barmode = "stack",
          legend  = list(orientation = "h", y = -0.18, x = 0,
                         font = list(size = 13, color = "#1f2937")),
          xaxis   = list(type = "date", tickformat = "%b '%y",
                         tickfont = list(size = 12, color = "#1f2937"), showgrid = FALSE),
          yaxis   = list(title = list(font = list(size = 13, color = "#1f2937")),
                         tickfont = list(size = 12, color = "#1f2937"), showgrid = FALSE, showline = TRUE, linecolor = "#d1d5db", linewidth = 1)
        )
    }
  })
  
  output$ov_donut <- renderPlotly({
    df <- ov_data()
    if (nrow(df) == 0) return(empty_plot())
    
    split <- df %>%
      count(type, name = "n") %>%
      arrange(desc(n))
    
    plotly::plot_ly(split,
            labels  = ~type, values = ~n,
            type    = "pie",
            marker  = list(colors = activity_color(split$type),
                           line   = list(color = "white", width = 2)),
            texttemplate  = "%{label}<br>%{percent:.1%}",
            textfont      = list(size = 14, color = "white", family = "Inter, sans-serif"),  
            insidetextfont = list(size = 14, color = "white", family = "Inter, sans-serif"),       
            hovertemplate = "<b>%{label}</b><br>%{value} activities (%{percent:.1%})<extra></extra>"
    ) %>%
      layout(
        paper_bgcolor = "transparent",
        showlegend    = FALSE,
        margin        = list(l = 5, r = 5, t = 5, b = 5),
        hoverlabel    = list(bgcolor = DARK, bordercolor = ORANGE,
                             font = list(color = "white", size = 12))
      ) %>%
      config(displayModeBar = FALSE)
  })
  
  output$pf_hr <- renderPlotly({
    df <- pf_filtered() %>%
      filter(!is.na(max_hr)) %>%
      arrange(date)
    if (nrow(df) < 2) return(empty_plot("No heart rate data available"))
    
    p <- plotly::plot_ly() %>%
      plotly::add_trace(data = df,
                x = ~date, y = ~max_hr, name = "Max HR in Training",
                type   = "scatter", mode = "markers",
                marker = list(color = paste0(ORANGE, "55"), size = 5),
                hovertemplate = "<b>%{x|%d %b %Y}</b><br>Max HR: %{y} bpm<extra></extra>"
      )
    
    strava_layout(p, xlab = "Training Date", ylab = "Heart Rate (bpm)") %>%
      layout(legend = list(orientation = "h", x = 0, y = -0.18,
                           font = list(size = 13, color = "#1f2937")),
              xaxis  = list(type = "date"))
  })
  
  output$pf_scatter <- renderPlotly({
    df <- pf_filtered() %>%
      filter(!is.na(avg_speed), !is.na(distance_km), avg_speed > 0) %>%
      mutate(avg_speed = avg_speed * 3.6)
    if (nrow(df) == 0) return(empty_plot())
    
    types <- unique(df$type)
    p     <- plotly::plot_ly()
    
    for (t in types) {
      sub <- df[df$type == t, ]
      p <- plotly::add_trace(p,
                     data   = sub,
                     x      = ~distance_km, y = ~avg_speed,
                     name   = t, type = "scatter", mode = "markers",
                     marker = list(color = activity_color(t), size = 6, opacity = 0.6),
                     hovertemplate = paste0("<b>", t, "</b><br>%{x:.1f} km @ %{y:.1f} km/h<extra></extra>")
      )
    }
    
    if (nrow(df) >= 5) {
      df_sorted <- df %>% arrange(distance_km)
      lo <- loess(avg_speed ~ distance_km, data = df_sorted, span = 0.6)
      df_sorted$trend <- predict(lo)
      p <- plotly::add_trace(p,
                     data = df_sorted,
                     x = ~distance_km, y = ~trend,
                     name = "Trend", type = "scatter", mode = "lines",
                     line = list(color = ORANGE, width = 2.5, dash = "solid"),
                     hoverinfo = "skip", showlegend = TRUE
      )
    }
    
    strava_layout(p, xlab = "Distance (km)", ylab = "Average Speed (km/h)") %>%
      layout(
           showlegend = FALSE,
           margin = list(b = 60, l = 50)
         )
  })
  
  output$pf_duration <- renderPlotly({
    df <- pf_filtered() %>%
      filter(!is.na(moving_time_min), moving_time_min > 0)
    if (nrow(df) == 0) return(empty_plot("No duration data"))
    
    plotly::plot_ly(df, x = ~moving_time_min,
            type = "histogram", nbinsx = 25,
            marker = list(color = ORANGE, opacity = 0.8,
                          line = list(color = "white", width = 0.5)),
            hovertemplate = "%{x:.0f} min<br>%{y} activities<extra></extra>") %>%
      strava_layout(xlab = "Duration (min)", ylab = "Count") %>%
      layout(showlegend = FALSE, margin = list(l = 45, b = 45))
  })
  
  output$pf_cals <- renderPlotly({
    df <- pf_filtered() %>%
      filter(!is.na(calories), calories > 0)
    if (nrow(df) == 0) return(empty_plot("No calorie data"))
    
    weekly <- df %>%
      mutate(week = lubridate::floor_date(date, "week", week_start = 1)) %>%
      group_by(week) %>%
      summarise(cals = sum(calories, na.rm = TRUE), .groups = "drop") %>%
      arrange(week)
      
    if (nrow(weekly) < 2) return(empty_plot("Not enough weeks for trend"))
    
    start_date <- if (!is.null(input$pf_dates)) lubridate::floor_date(as.Date(input$pf_dates[1]), "week", week_start = 1) else min(weekly$week)
    end_date   <- if (!is.null(input$pf_dates)) lubridate::floor_date(as.Date(input$pf_dates[2]), "week", week_start = 1) else max(weekly$week)
    end_date   <- max(start_date, end_date)
    
    timeline <- data.frame(week = seq(start_date, end_date, by = "week"))
    timeline <- timeline %>%
      left_join(weekly, by = "week") %>%
      mutate(cals = ifelse(is.na(cals), 0, cals))
    
    p <- plotly::plot_ly(timeline) %>%
      plotly::add_trace(x = ~week, y = ~cals,
                type = "scatter", mode = "lines+markers",
                line = list(color = ORANGE, width = 3),
                marker = list(color = ORANGE, size = 8, line = list(color = "white", width = 1.5)),
                fill = "tozeroy", fillcolor = paste0(ORANGE, "33"),
                hovertemplate = "<b>Week of %{x|%d %b %Y}</b><br>%{y:.0f} kcal<extra></extra>",
                showlegend = FALSE)
    
    strava_layout(p, xlab = "Weeks", ylab = "Calories (kcal)") %>%
       layout(
         xaxis = list(
           type = "date", 
           tickformat = "%b",
           showticklabels = TRUE, 
           showgrid = FALSE, showline = TRUE, linecolor = "#d1d5db", linewidth = 1
         ),
         yaxis = list(rangemode = "tozero", showgrid = FALSE, showline = TRUE, linecolor = "#d1d5db", linewidth = 1),
         margin = list(b = 75),
         showlegend = FALSE
       )
  })
  
  output$pf_violin <- renderPlotly({
    df <- pf_filtered() %>%
      filter(!is.na(max_hr), max_hr > 0)
    if (nrow(df) == 0) return(empty_plot("No heart rate data"))
    
    type_counts <- table(df$type)
    valid_types <- names(type_counts[type_counts >= 5])
    df <- df %>% filter(type %in% valid_types)
    if (nrow(df) == 0) return(empty_plot("Not enough data per sport (need 5+)"))
    
    p <- plot_ly()
    for (sport in valid_types) {
      sport_data <- df[df$type == sport, ]

      med_val  <- round(median(sport_data$max_hr))
      min_val  <- round(min(sport_data$max_hr))
      max_val  <- round(max(sport_data$max_hr))
      mean_val <- round(mean(sport_data$max_hr))
      q1_val   <- round(quantile(sport_data$max_hr, 0.25))
      q3_val   <- round(quantile(sport_data$max_hr, 0.75))
      n_val    <- nrow(sport_data)

      ht <- paste0(
        "<b>", sport, "</b><br>",
        "n: ", n_val, "<br>",
        "Min: ", min_val, " bpm<br>",
        "Q1: ", q1_val, " bpm<br>",
        "Median: ", med_val, " bpm<br>",
        "Mean: ", mean_val, " bpm<br>",
        "Q3: ", q3_val, " bpm<br>",
        "Max: ", max_val, " bpm",
        "<extra></extra>"
      )

      p <- p %>% add_trace(
        x          = rep(sport, nrow(sport_data)),
        y          = sport_data$max_hr,
        type       = "violin",
        name       = sport,
        box        = list(visible = TRUE),
        meanline   = list(visible = FALSE),
        points     = FALSE,
        fillcolor  = paste0(activity_color(sport), "33"),
        line       = list(color = activity_color(sport)),
        hoverinfo  = "skip",
        showlegend = FALSE
      )

      p <- p %>% add_trace(
        x             = rep(sport, 5),
        y             = c(min_val, q1_val, med_val, q3_val, max_val),
        type          = "scatter", mode = "markers",
        marker        = list(size = 14, color = "transparent",
                             line = list(color = "transparent")),
        hovertemplate = ht,
        showlegend    = FALSE
      )
    }

    p %>%
      strava_layout(xlab = "", ylab = "Max HR (bpm)") %>%
      layout(
        showlegend = FALSE,
        xaxis      = list(showgrid = FALSE, showline = TRUE),
        yaxis      = list(showgrid = FALSE, showline = TRUE, linecolor = "#d1d5db", linewidth = 1),
        margin     = list(l = 50, b = 50, t = 20)
      )
  })
  
  output$pf_deadtime <- renderPlotly({
    df <- pf_filtered() %>%
      filter(!is.na(elapsed_time_s), !is.na(moving_time_s),
             elapsed_time_s > 0, moving_time_s > 0) %>%
      mutate(
        elapsed_min = round(elapsed_time_s / 60, 1),
        moving_min  = round(moving_time_s / 60, 1),
        dead_min    = round((elapsed_time_s - moving_time_s) / 60, 1),
        pct_moving  = round(100 * moving_time_s / elapsed_time_s, 1)
      )
    if (nrow(df) == 0) return(empty_plot("No time data"))
    
    max_val <- max(c(df$elapsed_min, df$moving_min), na.rm = TRUE)
    
    p <- plot_ly()
    for (sport in unique(df$type)) {
      sport_df <- df[df$type == sport, ]
      p <- p %>% add_trace(
        x = sport_df$elapsed_min,
        y = sport_df$moving_min,
        type = "scatter", mode = "markers",
        name = sport,
        marker = list(
          size = 8, opacity = 0.7,
          color = activity_color(sport),
          line = list(color = "white", width = 1)
        ),
        text = paste0(
          sport_df$name,
          "\nElapsed: ", round(sport_df$elapsed_min), " min",
          "\nMoving: ", round(sport_df$moving_min), " min",
          "\nRest: ", round(sport_df$dead_min), " min",
          "\nActive: ", sport_df$pct_moving, "%"
        ),
        hoverinfo = "text"
      )
    }
    
    p <- p %>% add_trace(
      x = c(0, max_val * 1.1), y = c(0, max_val * 1.1),
      type = "scatter", mode = "lines",
      line = list(color = "#d1d5db", width = 1.5, dash = "dash"),
      hoverinfo = "skip", showlegend = FALSE
    )
    
    p %>%
      strava_layout(xlab = "Total Elapsed (min)", ylab = "Moving Time (min)") %>%
      layout(
        margin = list(l = 50, b = 50, t = 20),
        legend = list(
          orientation = "h", x = 0, y = -0.22,
          font = list(size = 10)
        ),
        annotations = list(
          list(
            x = max_val * 0.85, y = max_val * 0.92,
            text = "No breaks line",
            showarrow = FALSE,
            font = list(size = 9, color = "#9ca3af", family = "Inter")
          )
        )
      )
  })
  
  output$pf_radar <- renderPlotly({
    df <- pf_filtered() %>%
      filter(!is.na(avg_speed))
    if (nrow(df) == 0) return(empty_plot("No data for radar"))
    
    metrics <- c("elevation_gain", "avg_speed", "distance_km",
                 "relative_effort", "calories", "max_hr")
    labels  <- c("Elevation", "Speed", "Distance",
                 "Effort", "Calories", "Max HR")
    
    type_counts <- table(df$type)
    valid_types <- names(type_counts[type_counts >= 2])
    if (length(valid_types) == 0) return(empty_plot("Not enough data per sport"))
    
    agg <- df %>%
      filter(type %in% valid_types) %>%
      group_by(type) %>%
      summarise(
        avg_speed       = mean(avg_speed, na.rm = TRUE),
        max_hr          = mean(max_hr, na.rm = TRUE),
        calories        = mean(calories, na.rm = TRUE),
        elevation_gain  = mean(elevation_gain, na.rm = TRUE),
        relative_effort = mean(relative_effort, na.rm = TRUE),
        distance_km     = mean(distance_km, na.rm = TRUE),
        .groups = "drop"
      )
    
    for (m in metrics) {
      rng <- range(agg[[m]], na.rm = TRUE)
      if (rng[2] - rng[1] > 0) {
        agg[[m]] <- round(100 * (agg[[m]] - rng[1]) / (rng[2] - rng[1]))
      } else {
        agg[[m]] <- 50
      }
    }
    
    p <- plot_ly(type = "scatterpolar")
    
    for (sport in valid_types) {
      vals <- unlist(agg[agg$type == sport, metrics], use.names = FALSE)
      vals <- as.numeric(vals)
      vals <- c(vals, vals[1])
      theta <- c(labels, labels[1])
      
      p <- add_trace(p,
        r = vals, theta = theta,
        type = "scatterpolar",
        fill = "toself",
        fillcolor = paste0(activity_color(sport), "22"),
        line = list(color = activity_color(sport), width = 2),
        marker = list(size = 4, color = activity_color(sport)),
        name = sport,
        hovertemplate = paste0(
          "<b>", sport, "</b><br>",
          "%{theta}: %{r:.0f}/100<extra></extra>"
        )
      )
    }
    
    p %>% layout(
      polar = list(
        radialaxis = list(
          visible = TRUE, range = c(0, 105),
          showticklabels = FALSE,
          gridcolor = "#e5e7eb",
          linecolor = "transparent"
        ),
        angularaxis = list(
          gridcolor = "#e5e7eb",
          linecolor = "#e5e7eb",
          tickfont = list(size = 13, color = "#1f2937", family = "Inter", weight = "600")
        ),
        bgcolor = "transparent"
      ),
      paper_bgcolor = "transparent",
      plot_bgcolor  = "transparent",
      font = list(family = "Inter, sans-serif", color = GREY),
      hoverlabel = list(
        bgcolor = DARK, bordercolor = ORANGE,
        font = list(color = "white", size = 12, family = "Inter")
      ),
      legend = list(
        orientation = "h", x = 0, y = -0.15,
        font = list(size = 10, family = "Inter")
      ),
      margin = list(l = 50, r = 50, t = 30, b = 50),
      showlegend = TRUE
    ) %>%
      plotly::config(displayModeBar = FALSE)
  })
  
  output$pf_quadrant <- renderPlotly({
    df <- pf_filtered() %>%
      filter(!is.na(relative_effort), relative_effort > 0,
             !is.na(avg_speed), avg_speed > 0)
    if (nrow(df) == 0) return(empty_plot("No effort/speed data"))
    
    df$jittered_speed <- jitter(df$avg_speed, amount = 0.2)
    df$jittered_effort <- jitter(df$relative_effort, amount = 7.5)
    
    med_speed  <- median(df$avg_speed, na.rm = TRUE)
    med_effort <- median(df$relative_effort, na.rm = TRUE)
    
    p <- plot_ly()
    for (sport in unique(df$type)) {
      sport_df <- df[df$type == sport, ]
      p <- p %>% add_trace(
        x = sport_df$jittered_speed,
        y = sport_df$jittered_effort,
        type = "scatter", mode = "markers",
        name = sport,
        marker = list(
          size = 9, opacity = 0.75,
          color = activity_color(sport),
          line = list(color = "white", width = 1)
        ),
        text = paste0(
          sport_df$name,
          "\nSpeed: ", round(sport_df$avg_speed, 2), " m/s",
          "\nEffort: ", round(sport_df$relative_effort)
        ),
        hoverinfo = "text"
      )
    }
    
    speed_range <- range(df$avg_speed, na.rm = TRUE)
    effort_range <- range(df$relative_effort, na.rm = TRUE)
    
    annotations <- list(
      list(x = speed_range[2], y = effort_range[2],
           text = "Hard + Fast", showarrow = FALSE,
           font = list(size = 11, color = "#ef4444", family = "Inter"),
           xanchor = "right", yanchor = "top"),
      list(x = speed_range[1], y = effort_range[2],
           text = "Hard + Slow", showarrow = FALSE,
           font = list(size = 11, color = "#f59e0b", family = "Inter"),
           xanchor = "left", yanchor = "top"),
      list(x = speed_range[2], y = effort_range[1],
           text = "Easy + Fast", showarrow = FALSE,
           font = list(size = 11, color = "#10b981", family = "Inter"),
           xanchor = "right", yanchor = "bottom"),
      list(x = speed_range[1], y = effort_range[1],
           text = "Easy + Slow", showarrow = FALSE,
           font = list(size = 11, color = "#6b7280", family = "Inter"),
           xanchor = "left", yanchor = "bottom")
    )
    
    shapes <- list(
      list(type = "line",
           x0 = med_speed, x1 = med_speed,
           y0 = effort_range[1] * 0.9, y1 = effort_range[2] * 1.05,
           line = list(color = "#d1d5db", width = 1, dash = "dot")),
      list(type = "line",
           x0 = speed_range[1] * 0.95, x1 = speed_range[2] * 1.05,
           y0 = med_effort, y1 = med_effort,
           line = list(color = "#d1d5db", width = 1, dash = "dot"))
    )
    
    strava_layout(p, xlab = "Avg Speed (m/s)", ylab = "Relative Effort") %>%
      layout(
        annotations = annotations,
        shapes = shapes,
        xaxis = list(showgrid = FALSE, showline = TRUE, linecolor = "#d1d5db", linewidth = 1),
        yaxis = list(rangemode = "tozero", showgrid = FALSE, showline = TRUE, linecolor = "#d1d5db", linewidth = 1),
        legend = list(orientation = "h", x = 0, y = -0.28, font = list(size = 13, color = "#1f2937"))
      )
  })
  

  ins_pace_df <- reactive({
    ins_filtered() %>%
      filter(!is.na(avg_speed), avg_speed > 0) %>%
      mutate(avg_speed = avg_speed * 3.6,
             avg_speed_jitter = jitter(avg_speed, amount = 0.3)) %>%
      arrange(date) %>%
      mutate(row_key = row_number())
  })
  
  output$ins_pace <- renderPlotly({
    df <- ins_pace_df()
    if (nrow(df) < 5) return(empty_plot("Not enough data — need at least 5 activities"))
    
    sel_year <- input$ins_year
    if (!is.null(sel_year) && sel_year != "All") {
      yr <- as.integer(sel_year)
      x_range <- list(paste0(yr, "-01-01"), paste0(yr, "-12-31"))
      x_dtick <- "M1"
      x_format <- "%b '%y"
    } else {
      x_range <- NULL
      x_dtick <- "M2"
      x_format <- "%b '%y"
    }
    
    plotly::plot_ly(source = "ins_pace") %>%
      plotly::add_trace(data = df,
                x = ~date, y = ~avg_speed_jitter,
                customdata = ~avg_speed,
                key = ~row_key,
                type   = "scatter", mode = "markers",
                marker = list(color = activity_color(df$type), size = 9, opacity = 0.75,
                              line = list(color = "white", width = 1)),
                hovertemplate = "<b>%{x|%d %b %Y}</b><br>%{customdata:.1f} km/h<extra></extra>",
                showlegend = FALSE
      ) %>%
      strava_layout(xlab = "", ylab = "") %>%
      layout(
        xaxis = list(
          type = "date",
          range = x_range,
          tickformat = x_format,
          tickfont = list(size = 14, color = "#1f2937", family = "Inter"),
          dtick = x_dtick,
          title = list(text = "Date", font = list(size = 15, color = "#1f2937", family = "Inter"), standoff = 20),
          gridcolor = "#f1f5f9", showline = TRUE, linecolor = "#d1d5db", linewidth = 1
        ),
        yaxis = list(
          rangemode = "tozero",
          tickfont = list(size = 14, color = "#1f2937", family = "Inter"),
          title = list(text = "Avg Speed (km/h)", font = list(size = 15, color = "#1f2937", family = "Inter"), standoff = 20),
          gridcolor = "#f1f5f9", showline = TRUE, linecolor = "#d1d5db", linewidth = 1
        ),
        margin = list(l = 75, r = 20, t = 20, b = 65)
      )
  })
  
  observe({
    sel <- input$ins_top_table_rows_selected
    proxy <- plotlyProxy("ins_pace", session)
    
    plotlyProxyInvoke(proxy, "deleteTraces", list(1L))
    
    if (!is.null(sel) && length(sel) > 0) {
      pace_df  <- ins_pace_df()
      tbl_df   <- ins_filtered() %>% arrange(desc(date))
      if (sel > nrow(tbl_df)) return()
      
      clicked_date <- tbl_df$date[sel]
      hit <- pace_df %>% filter(date == clicked_date)
      if (nrow(hit) == 0) return()
      
      plotlyProxyInvoke(proxy, "addTraces", list(
        x          = list(as.character(hit$date[1])),
        y          = list(hit$avg_speed[1]),
        type       = "scatter",
        mode       = "markers",
        marker     = list(color = "#FF2D00", size = 18, opacity = 1,
                          line = list(color = "white", width = 3),
                          symbol = "circle"),
        hovertemplate = paste0("<b>", hit$date[1], "</b><br>",
                               round(hit$avg_speed[1], 1), " km/h<extra></extra>"),
        showlegend = FALSE
      ))
    }
  })
  
  ins_hover_key <- reactive({
    ev <- event_data("plotly_hover", source = "ins_pace")
    if (is.null(ev)) return(NULL)
    ev$key[1]
  })
  
  output$ins_hover_info <- renderUI({
    key <- ins_hover_key()
    if (is.null(key)) return(NULL)
    
    df <- ins_filtered() %>%
      filter(!is.na(avg_speed), avg_speed > 0) %>%
      arrange(date)
    if (as.integer(key) > nrow(df)) return(NULL)
    row <- df[as.integer(key), ]
    
    tags$div(
      style = paste0(
        "background: rgba(252,76,2,.07); border-left: 3px solid #FC4C02;",
        "border-radius: 8px; padding: 8px 14px; margin-bottom: 10px;",
        "display: flex; gap: 18px; align-items: center; flex-wrap: wrap;",
        "font-size: 12px; font-family: 'Inter', sans-serif;"
      ),
      tags$span(style = "font-weight:700; color:#FC4C02;",
                icon("crosshairs"), " ", format(row$date, "%d %b %Y")),
      tags$span(style = "color:#374151;",
                tags$b(row$name)),
      tags$span(style = "color:#6b7280;",
                icon("road"), " ", round(row$distance_km, 1), " km"),
      tags$span(style = "color:#6b7280;",
                icon("tachometer-alt"), " ", round(row$avg_speed * 3.6, 1), " km/h"),
      if (!is.na(row$elevation_gain) && row$elevation_gain > 0)
        tags$span(style = "color:#6b7280;",
                  icon("mountain"), " ", row$elevation_gain, " m")
    )
  })
  
  output$ins_top_table <- renderDT({
    df <- ins_filtered()
    if (nrow(df) == 0) return(datatable(
      data.frame(Message = "No data for selected filters"),
      rownames = FALSE, options = list(dom = "t")
    ))
    
    table_data <- df %>%
      arrange(desc(date)) %>%
      mutate(
        Date        = format(date, "%d %b %Y"),
        Name        = name,
        Type        = type,
        `Dist (km)` = round(distance_km, 2),
        `Elev (m)`  = elevation_gain,
        Calories    = ifelse(!is.na(calories) & calories > 0, as.character(calories), "—"),
        `Duration (min)` = ifelse(!is.na(moving_time_min), as.character(moving_time_min), "—"),
        `Max HR`    = ifelse(!is.na(max_hr), as.character(max_hr), "—")
      ) %>%
      select(Date, Name, Type, `Dist (km)`, `Elev (m)`, Calories, `Duration (min)`, `Max HR`)
    
    datatable(
      table_data,
      rownames  = FALSE,
      selection = list(mode = "single", target = "row"),
      class     = "compact hover",
      options   = list(
        pageLength = 6,
        scrollX    = FALSE,
        dom        = "tip",
        columnDefs = list(
          list(className = "dt-center", targets = 3:7)
        )
      )
    ) %>%
      formatStyle(
        "Type",
        backgroundColor = styleEqual(names(TYPE_COLORS), paste0(unlist(TYPE_COLORS), "22")),
        color           = styleEqual(names(TYPE_COLORS), unlist(TYPE_COLORS)),
        fontWeight      = "bold"
      )
  })
  
  observe({
    key <- ins_hover_key()
    df <- ins_filtered()
    if (is.null(key) || nrow(df) == 0) return()
    
    pace_df <- df %>%
      filter(!is.na(avg_speed), avg_speed > 0) %>%
      arrange(date)
    
    k <- as.integer(key)
    if (k < 1 || k > nrow(pace_df)) return()
    hovered_date <- pace_df$date[k]
    
    table_sorted <- df %>% arrange(desc(date))
    row_idx <- which(table_sorted$date == hovered_date)   # 1-indexed
    if (length(row_idx) == 0) return()
    
    session$sendCustomMessage("highlightInsRow", list(row = row_idx[1] - 1))  # 0-indexed
  })
  
  output$personal_records <- renderUI({
    df <- ins_filtered()
    req(nrow(df) > 0)
    
    runs  <- df[df$type == "Run",  ]
    rides <- df[df$type == "Ride", ]
    walks <- df[df$type == "Walk", ]
    workouts <- df[df$type == "Workout", ]
    
    record_row <- function(icon_emoji, label, value) {
      tags$div(
        style = "display:flex; justify-content:space-between; align-items:center;
                 padding:14px 10px; border-bottom:1px solid #f3f4f6;",
        tags$div(
          style = "display:flex; align-items:center; gap:10px;",
          tags$span(style = "font-size:20px; line-height:1;", icon_emoji),
          tags$span(style = "color:#4b5563; font-size:13px; font-weight:500;", label)
        ),
        tags$span(style = "font-weight:800; color:#FC4C02; font-size:15px;
                          background:rgba(252,76,2,0.08); padding:4px 10px;
                          border-radius:8px;", value)
      )
    }
    
    longest_dur <- if (nrow(df) > 0) {
      max_s <- max(df$moving_time_s, na.rm = TRUE)
      fmt_time(max_s)
    } else "—"
    
    max_effort <- if (nrow(df) > 0 && any(!is.na(df$relative_effort)))
      round(max(df$relative_effort, na.rm = TRUE)) else NA
    
    most_active_month <- if (nrow(df) > 0) {
      month_counts <- table(format(df$date, "%b %Y"))
      names(which.max(month_counts))
    } else "—"
    
    total_dist <- if (nrow(df) > 0) 
      paste0(formatC(round(sum(df$distance_km, na.rm = TRUE), 1), format = "f", digits = 1), " km") else "—"
    
    tags$div(
      style = "padding: 4px 0;",
      record_row("\U0001F3C3", "Longest Run",
                 if (nrow(runs) > 0)
                   fmt_dist(max(runs$distance_km, na.rm = TRUE))
                 else "—"),
      record_row("\U0001F6B4", "Longest Ride",
                 if (nrow(rides) > 0)
                   fmt_dist(max(rides$distance_km, na.rm = TRUE))
                 else "—"),
      record_row("\U000026F0", "Most Elevation",
                 if (nrow(df) > 0)
                   paste0(max(df$elevation_gain, na.rm = TRUE), " m")
                 else "—"),
      record_row("\U0001F525", "Most Calories",
                 if (nrow(df) > 0)
                   paste0(formatC(max(df$calories, na.rm = TRUE),
                                  format = "d", big.mark = ","), " kcal")
                 else "—"),
      record_row("\U0001F493", "Peak Heart Rate",
                 if (nrow(df) > 0 && any(!is.na(df$max_hr)))
                   paste0(max(df$max_hr, na.rm = TRUE), " bpm")
                 else "—"),
      record_row("\U0001F550", "Longest Activity",
                 longest_dur),
      record_row("\U0001F4C5", "Most Active Month",
                 most_active_month)
    )
  })
chat_history <- reactiveVal(list())
chat_request_times <- reactiveVal(list())

output$chat_history <- renderUI({
  msgs <- chat_history()
  if (length(msgs) == 0) {
    return(tags$div(
      style = "text-align:center; color:#9ca3af; font-size:13px; padding:40px 0;",
      icon("robot"), " Ask your coach anything about your training."
    ))
  }
  items <- lapply(msgs, function(m) {
    is_user <- m$role == "user"
    tags$div(
      class = if (is_user) "chat-row user-row" else "chat-row",
      tags$div(
        class = paste("chat-avatar", if (is_user) "avatar-user" else "avatar-assistant"),
        if (is_user) "K" else icon("robot")
      ),
      tags$div(class = paste("chat-bubble", m$role), m$text)
    )
  })
  tags$div(class = "chat-wrap", do.call(tagList, items))
})

observeEvent(input$chat_send, {
  req(input$chat_prompt)
  user_msg <- trimws(input$chat_prompt)
  if (user_msg == "") return()

  now <- as.numeric(Sys.time())
  times <- chat_request_times()
  times <- times[times > now - 60]
  if (length(times) >= 5) {
    showNotification("Rate limit exceeded: max 5 requests per minute", type = "error", duration = 5)
    return()
  }
  chat_request_times(c(times, now))

  msgs <- chat_history()
  msgs <- append(msgs, list(list(role = "user", text = user_msg)))
  chat_history(msgs)
  updateTextAreaInput(session, "chat_prompt", value = "")

  showNotification("Thinking...", duration = NULL, id = "chat_thinking")

  ctx <- {
    df_ctx <- pf_filtered()
    if (is.null(df_ctx) || nrow(df_ctx) == 0) {
      "No activity data available."
    } else {
      n_acts     <- nrow(df_ctx)
      total_dist <- round(sum(df_ctx$distance_km, na.rm = TRUE), 1)
      avg_speed  <- if (all(is.na(df_ctx$avg_speed))) NA else round(mean(df_ctx$avg_speed, na.rm = TRUE) * 3.6, 1)
      best_speed <- if (all(is.na(df_ctx$avg_speed))) NA else round(max(df_ctx$avg_speed, na.rm = TRUE) * 3.6, 1)
      total_elev <- round(sum(df_ctx$elevation_gain, na.rm = TRUE), 1)
      hr_min     <- if (all(is.na(df_ctx$max_hr))) NA else min(df_ctx$max_hr, na.rm = TRUE)
      hr_max     <- if (all(is.na(df_ctx$max_hr))) NA else max(df_ctx$max_hr, na.rm = TRUE)
      hr_avg     <- if (all(is.na(df_ctx$max_hr))) NA else round(mean(df_ctx$max_hr, na.rm = TRUE), 1)

      recent <- df_ctx %>% arrange(desc(date)) %>% head(3)
      recent_lines <- sapply(seq_len(nrow(recent)), function(i) {
        r <- recent[i, ]
        paste0(
          format(r$date, "%d %b %Y"), " - ", r$type, " - ", round(r$distance_km, 1), " km",
          if (!is.na(r$moving_time_min)) paste0(", ", r$moving_time_min, " min") else "",
          if (!is.na(r$avg_speed))       paste0(", avg ", round(r$avg_speed * 3.6, 1), " km/h") else "",
          if (!is.na(r$max_hr))          paste0(", HRmax ", r$max_hr, " bpm") else "",
          if (!is.na(r$elevation_gain))  paste0(", elev ", round(r$elevation_gain, 1), " m") else "",
          if (!is.na(r$calories))        paste0(", ", round(r$calories), " kcal") else "",
          if (!is.na(r$name))            paste0(" - ", r$name) else ""
        )
      })

      paste0(
        "Activities: ", n_acts, "; total ", total_dist, " km",
        if (!is.na(avg_speed))  paste0("; avg speed ", avg_speed, " km/h") else "",
        if (!is.na(best_speed)) paste0("; best avg ", best_speed, " km/h") else "",
        "; elevation total ", total_elev, " m",
        if (!is.na(hr_avg)) paste0("; HR (min/avg/max) ", hr_min, "/", hr_avg, "/", hr_max, " bpm") else "",
        "\nRecent activities:\n", paste(recent_lines, collapse = "\n")
      )
    }
  }

  msgs_payload <- list(
    list(role = "system",  content = "You are a helpful athletic performance coach. Answer concisely in Polish."),
    list(role = "user",    content = paste0("Context (from Strava):\n", ctx)),
    list(role = "user",    content = user_msg)
  )

  ans <- tryCatch({
    trimws(bielik_chat(msgs_payload))
  }, error = function(e) {
    paste0("Błąd: ", e$message)
  })

  removeNotification("chat_thinking")
  msgs <- chat_history()
  msgs <- append(msgs, list(list(role = "assistant", text = ans)))
  chat_history(msgs)
  session$sendCustomMessage("scrollChatBottom", list())
})
  
}