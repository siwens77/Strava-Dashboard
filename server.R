server <- function(input, output, session) {
  
  activities_raw <- reactive({
    load_activities("activities.csv")
  })
  
  observe({
    df <- activities_raw()
    years <- sort(unique(df$year), decreasing = TRUE)
    types <- sort(unique(df$type))
    
    updateSelectInput(session, "ov_year",
                      choices  = c("All Years", as.character(years)),
                      selected = "All Years")
    updateSelectInput(session, "ov_type",
                      choices  = c("All Types", types),
                      selected = "All Types")
    updateSelectInput(session, "ins_year",
                      choices  = c("All", as.character(years)),
                      selected = "All")
  })
  
  ov_data <- reactive({
    df <- activities_raw()
    if (!is.null(input$ov_year) && input$ov_year != "All Years")
      df <- df[df$year == as.integer(input$ov_year), ]
    if (!is.null(input$ov_type) && input$ov_type != "All Types")
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
  ins_filtered <- reactive({
    df <- activities_raw()
    if (!is.null(input$ins_year) && input$ins_year != "All")
      df <- df[df$year == as.integer(input$ins_year), ]
    if (!is.null(input$ins_type) && input$ins_type != "All")
      df <- df[df$type == input$ins_type, ]
    df
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
    req(nrow(df) > 0)
    
    yr <- if (!is.null(input$ov_year) && input$ov_year != "All Years")
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
    
    plot_ly(all_days,
            x = ~wk, y = ~dow, z = ~n,
            type          = "heatmap",
            colorscale    = list(c(0,"#f3f4f6"), c(0.01,"#ffd4c2"), c(1, ORANGE)),
            showscale     = FALSE,
            hovertemplate = "<b>%{customdata}</b><br>Activities: %{z}<extra></extra>",
            customdata    = ~lbl,
            zmin = 0, zmax = max(3, max(all_days$n))
    ) %>%
      layout(
        paper_bgcolor = "transparent",
        plot_bgcolor  = "transparent",
        xaxis = list(
          showticklabels = FALSE, 
          ticks = "",        
          showline = FALSE,      
          title = "", showgrid = FALSE, zeroline = FALSE
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
    req(nrow(df) > 0)
    
    metric <- if (!is.null(input$ov_metric)) input$ov_metric else "distance"
    
    if (metric == "elevation") {
      monthly <- df %>%
        mutate(ym = as.Date(paste0(format(date, "%Y-%m"), "-01"))) %>%
        group_by(ym) %>%
        summarise(val = sum(elevation_gain, na.rm = TRUE), .groups = "drop")
      
      p <- plot_ly(monthly,
                   x = ~ym, y = ~val, type = "bar",
                   marker = list(color = ORANGE, opacity = 0.85),
                   hovertemplate = "%{x|%b %Y}<br>%{y:.0f} m<extra></extra>"
      )
      
      strava_layout(p, xlab = "", ylab = "meters") %>%
        layout(xaxis = list(type = "date", tickformat = "%b '%y",
                            tickfont = list(size = 10)))
    } else {
      monthly <- df %>%
        mutate(ym = as.Date(paste0(format(date, "%Y-%m"), "-01"))) %>%
        group_by(ym, type) %>%
        summarise(dist = sum(distance_km, na.rm = TRUE), .groups = "drop")
      
      types <- unique(monthly$type)
      
      p <- plot_ly()
      for (t in types) {
        sub <- monthly[monthly$type == t, ]
        p <- add_trace(p,
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
                         font = list(size = 11)),
          xaxis   = list(type = "date", tickformat = "%b '%y",
                         tickfont = list(size = 10))
        )
    }
  })
  
  output$ov_donut <- renderPlotly({
    df <- ov_data()
    req(nrow(df) > 0)
    
    split <- df %>%
      count(type, name = "n") %>%
      arrange(desc(n))
    
    plot_ly(split,
            labels  = ~type, values = ~n,
            type    = "pie", hole = 0.55,
            marker  = list(colors = activity_color(split$type),
                           line   = list(color = "white", width = 2)),
            textinfo      = "label+percent",
            textfont      = list(size = 11, color = "white"),  
            insidetextfont = list(color = "white"),       
            hovertemplate = "<b>%{label}</b><br>%{value} activities (%{percent})<extra></extra>"
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
    req(nrow(df) >= 2)
    
    p <- plot_ly() %>%
      add_trace(data = df,
                x = ~date, y = ~max_hr, name = "Max HR in Training",
                type   = "scatter", mode = "markers",
                marker = list(color = paste0(ORANGE, "55"), size = 5),
                hovertemplate = "<b>%{x|%d %b %Y}</b><br>Max HR: %{y} bpm<extra></extra>"
      )
    
    strava_layout(p, xlab = "", ylab = "bpm") %>%
      layout(legend = list(orientation = "h", x = 0, y = -0.2,
                           font = list(size = 11)),
             xaxis  = list(type = "date"))
  })
  
  output$pf_scatter <- renderPlotly({
    df <- pf_filtered() %>%
      filter(!is.na(avg_speed), !is.na(distance_km), avg_speed > 0)
    req(nrow(df) > 0)
    
    types <- unique(df$type)
    p     <- plot_ly()
    
    for (t in types) {
      sub <- df[df$type == t, ]
      p <- add_trace(p,
                     data   = sub,
                     x      = ~distance_km, y = ~avg_speed,
                     name   = t, type = "scatter", mode = "markers",
                     marker = list(color = activity_color(t), size = 7, opacity = 0.7),
                     hovertemplate = paste0(
                       "<b>", t, "</b><br>",
                       "%{x:.1f} km @ %{y:.1f} km/h<extra></extra>")
      )
    }
    
    strava_layout(p, xlab = "<b>Distance (km)</b>", ylab = "<b>Avg Speed (km/h)</b>") %>%
      layout(
        legend = list(orientation = "h", y = -0.5, x = 0, font = list(size = 11)),
        xaxis = list(
          tickfont = list(family = "Inter, sans-serif", color = "#4b5563", size = 11, weight = "bold"),
          showline = TRUE,
          linecolor = "#e5e7eb",
          linewidth = 2,
          mirror = FALSE
        ), 
        yaxis = list(
          tickfont = list(family = "Inter, sans-serif", color = "#4b5563", size = 11, weight = "bold"),
          showline = TRUE,
          linecolor = "#e5e7eb",
          linewidth = 2,
          mirror = FALSE
        ),
        margin = list(b = 80, l = 60)
      )
  })
  
  # ---- VIZ 6: ELEVATION BAR (Performance) --------------------
  output$pf_elev <- renderPlotly({
    df <- pf_filtered()
    req(nrow(df) > 0)
    
    col_use <- "elevation_gain"
    
    monthly <- df %>%
      mutate(ym = as.Date(paste0(format(date, "%Y-%m"), "-01"))) %>%
      group_by(ym) %>%
      summarise(val = sum(.data[[col_use]], na.rm = TRUE), .groups = "drop")
    
    p <- plot_ly(monthly,
                 x = ~ym, y = ~val, type = "bar",
                 marker = list(color = ORANGE, opacity = 0.85),
                 hovertemplate = "%{x|%b %Y}<br>%{y:.0f} m<extra></extra>"
    )
    
    strava_layout(p, xlab = "", ylab = "meters") %>%
      layout(xaxis = list(type = "date", tickformat = "%b '%y",
                          tickfont = list(size = 10)))
  })
  
  output$ins_pace <- renderPlotly({
    df <- ins_filtered() %>%
      filter(!is.na(avg_speed), avg_speed > 0) %>%
      arrange(date)
    req(nrow(df) >= 5)
    
    window <- min(30, nrow(df))
    df$roll_speed <- stats::filter(df$avg_speed,
                                   rep(1/window, window), sides = 1)
    
    p <- plot_ly() %>%
      add_trace(data = df,
                x = ~date, y = ~avg_speed, name = "Per Activity",
                type   = "scatter", mode = "markers",
                marker = list(color = paste0(ORANGE, "44"), size = 5),
                hovertemplate = "<b>%{x|%d %b %Y}</b><br>%{y:.1f} km/h<extra></extra>"
      ) %>%
      add_trace(data = df[!is.na(df$roll_speed), ],
                x = ~date, y = ~roll_speed, name = "30-day avg",
                type = "scatter", mode = "lines",
                line = list(color = ORANGE, width = 2.5),
                hoverinfo = "skip"
      )
    
    strava_layout(p, xlab = "", ylab = "km/h") %>%
      layout(
        legend = list(orientation = "h", x = 0, y = -0.2,
                      font = list(size = 11)),
        xaxis  = list(type = "date")
      )
  })
  
  output$ins_top_table <- renderDT({
    df <- ins_filtered()
    req(nrow(df) > 0) 
    
    table_data <- df %>%
      arrange(desc(date)) %>% 
      transmute(
        Date        = format(date, "%d %b %Y"),
        Name        = name,
        Type        = type,
        `Dist (km)` = round(distance_km, 2),
        `Elev (m)`  = elevation_gain,
        Calories    = ifelse(!is.na(calories) & calories > 0, calories, "—"),
        Duration    = ifelse(!is.na(moving_time_min), moving_time_min, "—"),
        `Max HR`    = ifelse(!is.na(max_hr), max_hr, "—")
      )
    
    datatable(
      table_data,
      rownames  = FALSE,
      selection = "none",
      class     = "compact hover",
      options   = list(
        pageLength = 10, 
        scrollX    = FALSE,
        dom        = "tip",
        columnDefs = list(
          list(className = "dt-center", targets = 3:7) 
        )
      )
    ) %>%
      formatStyle("Type",
                  backgroundColor = styleEqual(
                    names(TYPE_COLORS),
                    paste0(unlist(TYPE_COLORS), "22")),
                  color = styleEqual(
                    names(TYPE_COLORS),
                    unlist(TYPE_COLORS)),
                  fontWeight = "bold"
      )
  })
  
  output$personal_records <- renderUI({
    df <- ins_filtered()
    req(nrow(df) > 0)
    
    runs  <- df[df$type == "Run",  ]
    rides <- df[df$type == "Ride", ]
    
    record_row <- function(label, value) {
      tags$div(
        style = "display:flex; justify-content:space-between; align-items:center;
                 padding:7px 0; border-bottom:1px solid #f3f4f6; font-size:12px;",
        tags$span(style = "color:#6b7280;", label),
        tags$span(style = "font-weight:700; color:#FC4C02;", value)
      )
    }
    
    tags$div(
      record_row("🏃 Longest Run",
                 if (nrow(runs) > 0)
                   fmt_dist(max(runs$distance_km, na.rm = TRUE))
                 else "—"),
      record_row("🏃 Fastest Run (avg)",
                 if (nrow(runs) > 0)
                   paste0(round(max(runs$avg_speed, na.rm = TRUE), 1), " km/h")
                 else "—"),
      record_row("🚴 Longest Ride",
                 if (nrow(rides) > 0)
                   fmt_dist(max(rides$distance_km, na.rm = TRUE))
                 else "—"),
      record_row("🚴 Most Elevation",
                 if (nrow(df) > 0)
                   paste0(max(df$elevation_gain, na.rm = TRUE), " m")
                 else "—"),
      record_row("🔥 Most Calories",
                 if (nrow(df) > 0)
                   paste0(formatC(max(df$calories, na.rm = TRUE),
                                  format = "d", big.mark = ","), " kcal")
                 else "—"),
      record_row("💓 Peak Heart Rate",
                 if (nrow(df) > 0 && any(!is.na(df$max_hr)))
                   paste0(max(df$max_hr, na.rm = TRUE), " bpm")
                 else "—")
    )
  })
  
}