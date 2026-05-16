custom_css <- "
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap');

/* ===== METRIC TOGGLE PILLS ===== */
.metric-toggle { display:flex; gap:6px; }
.metric-pill {
  padding: 5px 14px; border-radius: 20px; font-size: 11px;
  font-weight: 700; text-transform: uppercase; letter-spacing: .7px;
  border: 1.5px solid #e5e7eb; background: white; color: #9ca3af;
  cursor: pointer; transition: all .18s; line-height: 1.4;
  font-family: 'Inter', sans-serif;
}
.metric-pill:hover { border-color: #FC4C02; color: #FC4C02; }
.metric-pill.active {
  background: #FC4C02; border-color: #FC4C02; color: white;
  box-shadow: 0 2px 8px rgba(252,76,2,.30);
}


/* ===== BASE ===== */
body, .main-header, .main-sidebar, .content-wrapper, .box, .value-box, h1, h2, h3, p, span { 
  font-family: 'Inter', -apple-system, sans-serif !important; 
}

/* Specifically PROTECT the icons from being overwritten */
.fa, .fas, .far, .fab {
  font-family: 'Font Awesome 5 Free' !important;
  font-weight: 900 !important;
}

body, .wrapper { background: #f0f2f5 !important; }

/* Hide the sidebar toggle hamburger button */
.sidebar-toggle { display: none !important; }

.skin-black .main-header .logo {
  background: #FC4C02 !important; padding: 0 14px;
}
.skin-black .main-header .logo:hover { background: #e04400 !important; }
.skin-black .main-header .navbar     { background: #FC4C02 !important; border: none !important; }
.navbar-custom-menu > .nav > li > a  { color: white !important; }
.logo-wrap { display:flex; align-items:center; gap:9px; }
.logo-mono {
  width:34px; height:34px; background:rgba(255,255,255,0.22);
  border-radius:9px; display:flex; align-items:center; justify-content:center;
  font-size:17px; font-weight:900; color:white; flex-shrink:0;
}
.logo-name { color:white; font-weight:900; font-size:17px; letter-spacing:3px; }
.skin-black .main-sidebar,
.skin-black .left-side    { background: #16161f !important; }
.skin-black .sidebar a    { color: #9ca3af !important; }
.sidebar-menu > li > a {
  border-left: 3px solid transparent !important;
  color: #9ca3af !important;
  font-size: 13px !important; font-weight: 500 !important;
  padding: 12px 16px 12px 20px !important;
  transition: all .2s !important;
}
.sidebar-menu > li.active > a,
.sidebar-menu > li:hover  > a {
  color: #FC4C02 !important;
  border-left-color: #FC4C02 !important;
  background: rgba(252,76,2,.08) !important;
}
.sidebar-menu > li > a > .fa,
.sidebar-menu > li > a > .fas { color: inherit !important; width: 20px; }
.sidebar-menu .header {
  color: #4b5563 !important; font-size: 10px !important;
  text-transform: uppercase; letter-spacing: 1.4px;
  padding: 16px 20px 5px !important; font-weight: 700 !important;
}
hr.sidebar-hr { border-color: #2a2a35 !important; margin: 10px 18px !important; }
.content-wrapper { background: #f0f2f5 !important; }
.content          { padding: 14px 18px !important; }
.box {
  border-radius: 13px !important;
  box-shadow: 0 1px 5px rgba(0,0,0,.09) !important;
  border: none !important; border-top: none !important;
  overflow: visible;
}
.box.box-orange { border-top: 3px solid #FC4C02 !important; }
.box-header {
  border-bottom: 1px solid #f5f5f5 !important;
  padding: 13px 17px !important; border-radius: 13px 13px 0 0 !important;
}
.box-title {
  font-size: 12px !important; font-weight: 700 !important;
  text-transform: uppercase; letter-spacing: .7px; color: #374151 !important;
}
.box-title .fa, .box-title .fas { color: #FC4C02 !important; margin-right: 6px; }
.box-body { padding: 14px 16px !important; }
.value-box {
  border-radius: 13px !important;
  box-shadow: 0 1px 5px rgba(0,0,0,.09) !important;
  border: none !important;
}
.value-box .value-box-inner  { padding: 12px 15px !important; }
.value-box p.value            { font-size: 22px !important; font-weight: 800 !important; }
.value-box p.value-box-text   { font-size: 10px !important; text-transform: uppercase; letter-spacing: .9px; opacity: .85; }
.value-box .value-box-icon    { font-size: 38px !important; width: 68px !important; }
table.dataTable { border-collapse: collapse !important; border-spacing: 0 !important; }
table.dataTable thead th {
  background: #f9fafb !important; color: #6b7280 !important;
  font-size: 10px !important; font-weight: 700 !important;
  text-transform: uppercase; letter-spacing: .5px;
  border: none !important; border-bottom: 1px solid #f3f4f6 !important;
  padding: 9px 11px !important;
}
table.dataTable tbody td {
  border: none !important; border-bottom: 1px solid #f3f4f6 !important;
  font-size: 12px !important; padding: 9px 11px !important; color: #374151 !important;
}
table.dataTable tbody tr:hover td { background: rgba(252,76,2,.04) !important; cursor: pointer; }
.dataTables_info    { font-size: 11px !important; color: #9ca3af !important; }
.dataTables_length select,
.dataTables_filter input {
  border: 1px solid #e5e7eb !important; border-radius: 7px !important;
  padding: 3px 8px !important; font-size: 12px !important;
}
.dataTables_paginate .paginate_button {
  border-radius: 7px !important; font-size: 12px !important; padding: 3px 8px !important;
}
.dataTables_paginate .paginate_button.current,
.dataTables_paginate .paginate_button.current:hover {
  background: #FC4C02 !important; color: white !important;
  border-color: #FC4C02 !important;
}
.dataTables_paginate .paginate_button:hover {
  background: rgba(252,76,2,.09) !important; color: #FC4C02 !important;
  border-color: rgba(252,76,2,.2) !important;
}
.filter-label {
  display: block; font-size: 10px; text-transform: uppercase;
  letter-spacing: .9px; color: #9ca3af; margin-bottom: 5px; font-weight: 700;
}
.form-control, .selectize-input {
  border-radius: 8px !important; border-color: #e5e7eb !important;
  font-size: 12px !important;
}
.form-control:focus { border-color: #FC4C02 !important; box-shadow: 0 0 0 2px rgba(252,76,2,.15) !important; }
.selectize-dropdown-content .option.selected,
.selectize-dropdown-content .option.active {
  background: rgba(252,76,2,.09) !important; color: #FC4C02 !important;
}
.checkbox label, .radio label { font-size: 12px !important; color: #4b5563 !important; }
.irs-bar, .irs-bar-edge               { background: #FC4C02 !important; border-color: #FC4C02 !important; }
.irs-from, .irs-to, .irs-single       { background: #FC4C02 !important; }
.irs-handle                           { border-color: #FC4C02 !important; }
.about-hero {
  background: linear-gradient(135deg,#FC4C02 0%,#ff7a42 100%);
  color:white; border-radius:16px; padding:38px;
  text-align:center; margin-bottom:18px;
  box-shadow:0 4px 22px rgba(252,76,2,.28);
}
.about-hero-mono {
  width:78px; height:78px; background:rgba(255,255,255,.2);
  border-radius:20px; font-size:38px; font-weight:900; color:white;
  display:flex; align-items:center; justify-content:center;
  margin:0 auto 14px; backdrop-filter:blur(10px);
}
.about-hero h1  { font-size:50px; font-weight:900; letter-spacing:5px; margin:0 0 7px; }
.about-hero p   { font-size:15px; opacity:.9; margin:0; }
.about-card {
  background:white; border-radius:13px; padding:22px;
  margin-bottom:18px; box-shadow:0 1px 5px rgba(0,0,0,.08);
  height: calc(100% - 18px); /* Height stretching adjustment */
}
.about-card h3  { font-size:14px; font-weight:700; color:#111827; margin:0 0 11px; }
.about-card h3 .fa { color:#FC4C02; margin-right:7px; }
.about-card p, .about-card li { font-size:12px; color:#6b7280; line-height:1.75; }
.about-card ol  { padding-left:16px; margin:0; }
.about-card li  { margin-bottom:7px; }

::-webkit-scrollbar             { width:5px; height:5px; }
::-webkit-scrollbar-track       { background:transparent; }
::-webkit-scrollbar-thumb       { background:rgba(252,76,2,.35); border-radius:3px; }
::-webkit-scrollbar-thumb:hover { background:#FC4C02; }
hr { border-color:#f3f4f6 !important; }
.shiny-notification { border-left:4px solid #FC4C02 !important; }
.row { margin-left:-8px !important; margin-right:-8px !important; }
.col-sm-1,.col-sm-2,.col-sm-3,.col-sm-4,.col-sm-5,.col-sm-6,
.col-sm-7,.col-sm-8,.col-sm-9,.col-sm-10,.col-sm-11,.col-sm-12 {
  padding-left:8px !important; padding-right:8px !important;
}

.fa, .fas, .far, .fab {
  font-family: 'Font Awesome 5 Free' !important;
  font-weight: 900 !important;
}
"

ui <- dashboardPage(
  skin  = "black",
  title = "Kstrava",
  
  dashboardHeader(
    titleWidth = 220,
    title = tags$div(
      class = "logo-wrap",
      tags$div(class = "logo-mono", "KV"),
      tags$span(class = "logo-name", "Kstrava")
    )
  ),
  
  dashboardSidebar(
    width = 220,
    sidebarMenu(
      id = "active_tab",
      tags$div(class = "header", "DASHBOARD"),
      menuItem("Overview",    tabName = "overview",    icon = icon("chart-line")),
      menuItem("Performance", tabName = "performance", icon = icon("heartbeat")),
      menuItem("Insights",    tabName = "insights",    icon = icon("lightbulb")),
      tags$hr(class = "sidebar-hr"),
      tags$div(class = "header", "INFO"),
      menuItem("About & Help",tabName = "about",       icon = icon("info-circle"))
    )
  ),
  
  dashboardBody(
    
    tags$head(
      tags$style(HTML(custom_css)),
      tags$script(HTML("
        // Metric pill toggle
        $(document).on('click', '.metric-pill', function() {
          $('.metric-pill').removeClass('active');
          $(this).addClass('active');
          Shiny.setInputValue('ov_metric', $(this).data('val'), {priority: 'event'});
        });

        // Highlight a row in ins_top_table without re-rendering
        Shiny.addCustomMessageHandler('highlightInsRow', function(msg) {
          var table = $('#ins_top_table table').DataTable();
          if (!table) return;
          $('#ins_top_table table tbody tr').css({'background-color': '', 'font-weight': ''});
          var pageLen  = table.page.len();
          var curPage  = table.page();
          var rowOnPage = msg.row - curPage * pageLen;
          if (rowOnPage >= 0 && rowOnPage < pageLen) {
            $('#ins_top_table table tbody tr').eq(rowOnPage).css({
              'background-color': 'rgba(252,76,2,.10)',
              'font-weight': '700'
            });
          }
        });
      "))
    ),
    
    tabItems(
      tabItem(tabName = "overview",
              
              # Controls row
              fluidRow(
                column(3,
                       selectInput("ov_year", NULL,
                                   choices  = c("All Years"),
                                   selected = "All Years", width = "100%")
                ),
                column(3,
                       selectInput("ov_type", NULL,
                                   choices  = c("All Types"),
                                   selected = "All Types", width = "100%")
                )
              ),
              
              fluidRow(
                valueBoxOutput("kpi_acts",  width = 3),
                valueBoxOutput("kpi_dist",  width = 3),
                valueBoxOutput("kpi_cals",  width = 3),
                valueBoxOutput("kpi_elev",  width = 3)
              ),
              
              fluidRow(
                box(
                  title = tagList(icon("calendar"), "Activity Calendar"),
                  width = 12, class = "box-orange",
                  plotlyOutput("heatmap_cal", height = "185px")
                )
              ),
              
              fluidRow(
                box(
                  title = tagList(icon("chart-bar"), "Monthly Activity"),
                  width = 8, class = "box-orange",
                  div(style = "display:flex; justify-content:flex-end; margin-bottom:10px;",
                      div(class = "metric-toggle",
                          tags$button(class = "metric-pill active", `data-val` = "distance",
                                      icon("road"), " Distance"),
                          tags$button(class = "metric-pill", `data-val` = "elevation",
                                      icon("mountain"), " Elevation")
                      )
                  ),
                  plotlyOutput("monthly_dist", height = "230px")
                ),
                box(
                  title = tagList(icon("chart-pie"), "Activity Split"),
                  width = 4, class = "box-orange",
                  plotlyOutput("ov_donut",     height = "260px")
                )
              )
      ),
      
      tabItem(tabName = "performance",
              
              fluidRow(
                column(3,
                       box(
                         title  = tagList(icon("sliders-h"), "Controls"),
                         width  = NULL, class = "box-orange",
                         
                         tags$span(class = "filter-label", "Sport"),
                         selectInput("pf_type", NULL,
                                     choices = c("All", "Run","Ride","Swim","Hike","Walk","Workout"),
                                     selected = "All", width = "100%"),
                         
                         tags$span(class = "filter-label", "Date Range"),
                         uiOutput("pf_date_ui")
                       )
                ),
                
                column(9,
                       fluidRow(
                         box(title = tagList(icon("heartbeat"), "Heart Rate Over Time"),
                             width = 6, class = "box-orange",
                             plotlyOutput("pf_hr", height = "170px")),
                         box(title = tagList(icon("tachometer-alt"), "Speed vs Distance"),
                             width = 6, class = "box-orange",
                             plotlyOutput("pf_scatter", height = "170px"))
                       ),
                       fluidRow(
                         box(title = tagList(icon("mountain"), "Elevation Gain Over Time"),
                             width = 6, class = "box-orange",
                             plotlyOutput("pf_elev_time", height = "170px")),
                         box(title = tagList(icon("clock"), "Activity Duration Distribution"),
                             width = 6, class = "box-orange",
                             plotlyOutput("pf_duration", height = "170px"))
                       ),
                       fluidRow(
                         box(title = tagList(icon("fire"), "Calories Over Time"),
                             width = 6, class = "box-orange",
                             plotlyOutput("pf_cals", height = "170px")),
                         box(title = tagList(icon("chart-bar"), "Distance Distribution"),
                             width = 6, class = "box-orange",
                             plotlyOutput("pf_dist_hist", height = "170px"))
                       )
                )
              )
      ),
      
      tabItem(tabName = "insights",
              
              fluidRow(
                
                column(3,
                       box(
                         title  = tagList(icon("sliders-h"), "Controls"),
                         width  = NULL, class = "box-orange",
                         
                         tags$span(class = "filter-label", "Year"),
                         selectInput("ins_year", NULL,
                                     choices = c("All"), selected = "All", width = "100%"),
                         
                         tags$span(class = "filter-label", "Sport"),
                         selectInput("ins_type", NULL,
                                     choices = c("All","Run","Ride","Swim","Hike","Walk","Workout"),
                                     selected = "All", width = "100%")
                       ),
                       
                       box(
                         title  = tagList(icon("trophy"), "Personal Records"),
                         width  = NULL, class = "box-orange",
                         uiOutput("personal_records")
                       )
                ),
                
                column(9,
                       fluidRow(
                         box(
                           title = tagList(icon("chart-line"), "Average Speed Trend (30-day rolling)"),
                           width = 12, class = "box-orange",
                           plotlyOutput("ins_pace", height = "200px")
                         )
                       ),
                       fluidRow(
                         box(
                           title = tagList(icon("medal"), "Top Activities"),
                           width = 12, class = "box-orange",
                           uiOutput("ins_hover_info"),
                           div(id = "ins_table_wrap",
                               DTOutput("ins_top_table")
                           )
                         )
                       )
                )
              )
      ),
      
      tabItem(tabName = "about",
              
              fluidRow(
                column(12,
                       
                       tags$div(class = "about-hero",
                                tags$div(class = "about-hero-mono", "SV"),
                                tags$h1("STRAVIZ"),
                                tags$p("Your Personal Athletic Intelligence Dashboard")
                       ),
                       
                       fluidRow(style = "display: flex; flex-wrap: wrap;",
                                column(6,
                                       tags$div(class = "about-card",
                                                tags$h3(icon("bullseye"), " About STRAVIZ"),
                                                tags$p(
                                                  "STRAVIZ is an R Shiny dashboard that transforms your exported ",
                                                  tags$strong("Strava activity data"), " into actionable intelligence. ",
                                                  "Track training patterns, monitor performance trends, and celebrate ",
                                                  "personal achievements — all in one beautiful, interactive interface."
                                                ),
                                                tags$hr(),
                                                tags$h3(icon("database"), " Data"),
                                                tags$p(
                                                  "Place your ", tags$code("activities.csv"),
                                                  " (Strava bulk export) in the app directory. ",
                                                  "If no file is found, the dashboard runs on auto-generated ",
                                                  "demo data so you can explore all features immediately."
                                                )
                                       )
                                ),
                                column(6,
                                       tags$div(class = "about-card",
                                                tags$h3(icon("question-circle"), " How to Use"),
                                                tags$ol(
                                                  tags$li(tags$strong("Overview:"),
                                                          " All-time KPIs, a GitHub-style activity calendar, monthly ",
                                                          "distance bars, and an activity-type donut. Filter by year and sport."),
                                                  tags$li(tags$strong("Performance:"),
                                                          " Heart-rate trend (smoothed), speed-vs-distance scatter ",
                                                          "(coloured by type), and monthly elevation chart."),
                                                  tags$li(tags$strong("Insights:"),
                                                          " Rolling average-speed trend, ",
                                                          "personal records leaderboard, and ranked top-activities table.")
                                                )
                                       )
                                )
                       )
                )
              )
      )
    ) 
  ) 
)