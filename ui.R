custom_css <- "
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap');


.chat-wrap { display: flex; flex-direction: column; gap: 12px; padding: 4px 0; }
.chat-row { display: flex; align-items: flex-end; gap: 8px; }
.user-row  { flex-direction: row-reverse; }
.chat-bubble {
  max-width: 72%; padding: 10px 14px; border-radius: 18px;
  font-size: 13px; line-height: 1.6; word-wrap: break-word;
  font-family: 'Inter', sans-serif;
}
.chat-bubble.user {
  background: #FC4C02; color: white;
  border-bottom-right-radius: 4px;
}
.chat-bubble.assistant {
  background: #f3f4f6; color: #111827;
  border-bottom-left-radius: 4px;
}
.chat-avatar {
  width: 30px; height: 30px; border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  font-size: 13px; font-weight: 700; flex-shrink: 0;
}
.avatar-user      { background: #FC4C02; color: white; }
.avatar-assistant { background: #e5e7eb; color: #374151; }


.chat-input-area {
  margin-top: 12px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.chat-input-area .form-group { margin-bottom: 0 !important; }
.chat-input-area textarea {
  border-radius: 14px !important;
  border: 1.5px solid #e5e7eb !important;
  padding: 14px 16px !important;
  font-size: 14px !important;
  resize: none !important;
  transition: border-color 0.2s, box-shadow 0.2s;
}
.chat-input-area textarea:focus {
  border-color: #FC4C02 !important;
  box-shadow: 0 0 0 3px rgba(252,76,2,.1) !important;
}
.chat-send-btn {
  width: 100%;
  padding: 12px 24px !important;
  border: none !important;
  border-radius: 14px !important;
  background: linear-gradient(135deg, #FC4C02, #ff7a42) !important;
  color: white !important;
  font-family: 'Inter', sans-serif !important;
  font-size: 14px !important;
  font-weight: 600 !important;
  letter-spacing: 0.5px;
  cursor: pointer;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1) !important;
  box-shadow: 0 4px 14px rgba(252,76,2,.25) !important;
}
.chat-send-btn:hover {
  transform: translateY(-2px) !important;
  box-shadow: 0 6px 20px rgba(252,76,2,.4) !important;
  background: linear-gradient(135deg, #e54400, #FC4C02) !important;
}
.chat-send-btn:active {
  transform: translateY(0) !important;
  box-shadow: 0 2px 8px rgba(252,76,2,.3) !important;
}


.metric-toggle { display:flex; gap:8px; }
.metric-pill {
  padding: 8px 16px; border-radius: 24px; font-size: 12px;
  font-weight: 700; text-transform: uppercase; letter-spacing: 1px;
  border: 1.5px solid #e5e7eb; background: white; color: #9ca3af;
  cursor: pointer; transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1); line-height: 1.4;
  font-family: 'Inter', sans-serif;
  box-shadow: 0 2px 6px rgba(0,0,0,.05);
}
.metric-pill:hover { 
  border-color: #FC4C02; 
  color: #FC4C02;
  box-shadow: 0 4px 12px rgba(252,76,2,.15);
  transform: translateY(-2px);
}
.metric-pill.active {
  background: linear-gradient(135deg, #FC4C02, #ff7a42);
  border-color: #FC4C02; 
  color: white;
  box-shadow: 0 6px 20px rgba(252,76,2,.35);
}



body, .main-header, .main-sidebar, .content-wrapper, .box, .value-box, h1, h2, h3, p, span { 
  font-family: 'Inter', -apple-system, sans-serif !important; 
}


.fa, .fas, .far, .fab {
  font-family: 'Font Awesome 5 Free' !important;
  font-weight: 900 !important;
}

body, .wrapper { background: linear-gradient(135deg, #f0f2f5 0%, #e8eaef 100%) !important; }


.sidebar-toggle { display: none !important; }

.skin-black .main-header .logo {
  background: #FC4C02 !important; padding: 0 14px;
}
.skin-black .main-header .logo:hover { background: #e04400 !important; }
.skin-black .main-header .navbar     { background: #FC4C02 !important; border: none !important; }
.navbar-custom-menu > .nav > li > a  { color: white !important; }
.logo-wrap { display:flex; align-items:center; gap:9px; }
.logo-img {
  width: 34px; height: 34px; border-radius: 9px; flex-shrink: 0;
  object-fit: cover;
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
.content-wrapper { background: linear-gradient(135deg, #f0f2f5 0%, #e8eaef 100%) !important; }
.content          { padding: 20px 24px !important; }
.box {
  border-radius: 16px !important;
  box-shadow: 0 8px 24px rgba(0,0,0,.12) !important;
  border: 1px solid rgba(255,255,255,.4) !important;
  border-top: none !important;
  overflow: visible !important;
  background: linear-gradient(135deg, #ffffff 0%, #fafbfc 100%) !important;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
.box:hover {
  box-shadow: 0 16px 40px rgba(0,0,0,.15) !important;
  transform: translateY(-2px);
}
.box.box-orange { 
  border-top: 4px solid #FC4C02 !important;
  border-top-left-radius: 16px;
  border-top-right-radius: 16px;
}
.box-header {
  border-bottom: 1px solid rgba(244, 244, 245, .6) !important;
  padding: 16px 20px !important; 
  border-radius: 16px 16px 0 0 !important;
  background: transparent !important;
}
.box-title {
  font-size: 13px !important; 
  font-weight: 700 !important;
  text-transform: uppercase; 
  letter-spacing: 1.2px; 
  color: #1f2937 !important;
}
.box-title .fa, .box-title .fas { 
  color: #FC4C02 !important; 
  margin-right: 8px;
  font-size: 14px;
}
.box-body { 
  padding: 18px 20px !important; 
  overflow: visible !important;
}
.value-box {
  border-radius: 16px !important;
  box-shadow: 0 8px 24px rgba(0,0,0,.12) !important;
  border: none !important;
  background: linear-gradient(135deg, #ffffff 0%, #fafbfc 100%) !important;
  backdrop-filter: blur(10px);
  position: relative;
  overflow: hidden;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  border: 1px solid rgba(255,255,255,.6);
}
.value-box:hover {
  box-shadow: 0 16px 40px rgba(0,0,0,.15) !important;
  transform: translateY(-4px);
}
.value-box::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, #FC4C02, #ff7a42);
  border-radius: 16px 16px 0 0;
}
.value-box .value-box-inner  { 
  padding: 18px 20px !important; 
  display: flex;
  align-items: center;
  gap: 16px;
  justify-content: space-between;
}
.value-box p.value            { 
  font-size: 28px !important; 
  font-weight: 900 !important; 
  background: linear-gradient(135deg, #FC4C02, #ff7a42);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin: 0 !important;
}
.value-box p.value-box-text   { 
  font-size: 11px !important; 
  text-transform: uppercase; 
  letter-spacing: 1.2px; 
  opacity: .7;
  color: #6b7280 !important;
  font-weight: 600;
  margin: 4px 0 0 0 !important;
}
.value-box .value-box-icon    { 
  font-size: 44px !important; 
  width: 80px !important;
  height: 80px !important;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, rgba(252,76,2,.1), rgba(255,122,66,.08));
  border-radius: 14px;
  color: #FC4C02;
  flex-shrink: 0;
}
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
  border-radius: 10px !important; 
  border: 1.5px solid #e5e7eb !important;
  font-size: 13px !important;
  background: white !important;
  padding: 10px 12px !important;
  transition: all 0.2s;
  box-shadow: 0 2px 6px rgba(0,0,0,.04) !important;
}
.form-control:focus, .selectize-input.focus { 
  border-color: #FC4C02 !important; 
  box-shadow: 0 0 0 3px rgba(252,76,2,.1) !important; 
}
.selectize-dropdown-content .option.selected,
.selectize-dropdown-content .option.active {
  background: rgba(252,76,2,.09) !important; color: #FC4C02 !important;
}
.selectize-dropdown {
  z-index: 1050 !important;
  position: absolute !important;
}
.selectize-input {
  position: relative !important;
}
.col-sm-3 {
  position: relative;
}
.checkbox label, .radio label { font-size: 12px !important; color: #4b5563 !important; }

.irs { height: 60px !important; }
.irs-line {
  height: 4px !important; top: 16px !important;
  background: #e5e7eb !important; border: none !important;
  border-radius: 4px !important; overflow: hidden;
}
.irs-bar, .irs-bar-edge {
  height: 4px !important; top: 16px !important;
  background: linear-gradient(90deg, #FC4C02, #ff7a42) !important;
  border: none !important; border-radius: 4px !important;
}
.irs-handle {
  width: 16px !important; height: 16px !important;
  top: 10px !important;
  background: #fff !important;
  border: 2px solid #FC4C02 !important;
  border-radius: 50% !important;
  box-shadow: 0 2px 6px rgba(252,76,2,.25) !important;
  cursor: pointer !important;
  transition: box-shadow .2s, transform .2s;
}
.irs-handle:hover, .irs-handle.state_hover {
  box-shadow: 0 3px 10px rgba(252,76,2,.4) !important;
  transform: scale(1.15);
}
.irs-from, .irs-to, .irs-single {
  background: #FC4C02 !important;
  font-size: 10px !important; padding: 2px 6px !important;
  border-radius: 6px !important;
  font-family: 'Inter', sans-serif !important;
  font-weight: 600 !important; letter-spacing: .3px;
  top: -4px !important;
}
.irs-min, .irs-max {
  font-size: 9px !important; color: #9ca3af !important;
  background: transparent !important;
  font-family: 'Inter', sans-serif !important;
}
.irs-grid-text { font-size: 10px !important; color: #4b5563 !important; font-family: 'Inter', sans-serif !important; }
.slider-col { margin-left: 0.2cm; }
.irs-grid-pol { background: #9ca3af !important; }
.about-hero {
  background: linear-gradient(135deg,#FC4C02 0%,#ff7a42 100%);
  color:white; border-radius:16px; padding:38px;
  text-align:center; margin-bottom:18px;
  box-shadow:0 4px 22px rgba(252,76,2,.28);
}
.about-logo-img {
  width: 78px; height: 78px; border-radius: 20px;
  margin: 0 auto 14px; display: block;
  object-fit: cover;
}
.about-hero h1  { font-size:50px; font-weight:900; letter-spacing:5px; margin:0 0 7px; }
.about-hero p   { font-size:15px; opacity:.9; margin:0; }
.about-card {
  background:white; border-radius:13px; padding:22px;
  margin-bottom:18px; box-shadow:0 1px 5px rgba(0,0,0,.08);
  height: calc(100% - 18px);
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


.overview-controls {
  margin-bottom: 20px;
}
.overview-controls .col-sm-3 {
  margin-bottom: 12px;
}


.kpi-card {
  border-radius: 16px;
  padding: 22px;
  margin-bottom: 16px;
  background: linear-gradient(135deg, #ffffff 0%, #fafbfc 100%);
  border: 1px solid rgba(255, 255, 255, 0.6);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
  min-height: 155px;
  display: flex;
  align-items: center;
}
.kpi-card:hover {
  box-shadow: 0 16px 40px rgba(0, 0, 0, 0.15);
  transform: translateY(-6px);
}
.kpi-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  border-radius: 16px 16px 0 0;
}
.kpi-card.kpi-activities::before { background: linear-gradient(90deg, #3b82f6, #1d4ed8); }
.kpi-card.kpi-distance::before { background: linear-gradient(90deg, #10b981, #059669); }
.kpi-card.kpi-calories::before { background: linear-gradient(90deg, #FC4C02, #ff7a42); }
.kpi-card.kpi-elevation::before { background: linear-gradient(90deg, #8b5cf6, #6d28d9); }

.kpi-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}
.kpi-icon {
  flex-shrink: 0;
  width: 72px;
  height: 72px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 14px;
  font-size: 32px;
}
.kpi-card.kpi-activities .kpi-icon {
  background: linear-gradient(135deg, rgba(59, 130, 246, 0.15), rgba(29, 78, 216, 0.08));
  color: #3b82f6;
}
.kpi-card.kpi-distance .kpi-icon {
  background: linear-gradient(135deg, rgba(16, 185, 129, 0.15), rgba(5, 150, 105, 0.08));
  color: #10b981;
}
.kpi-card.kpi-calories .kpi-icon {
  background: linear-gradient(135deg, rgba(252, 76, 2, 0.15), rgba(255, 122, 66, 0.08));
  color: #FC4C02;
}
.kpi-card.kpi-elevation .kpi-icon {
  background: linear-gradient(135deg, rgba(139, 92, 246, 0.15), rgba(109, 40, 217, 0.08));
  color: #8b5cf6;
}

.kpi-text {
  flex: 1;
}
.kpi-value {
  font-size: 28px;
  font-weight: 900;
  margin: 0;
  line-height: 1.2;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
.kpi-card.kpi-activities .kpi-value { 
  background: linear-gradient(135deg, #3b82f6, #1d4ed8);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
.kpi-card.kpi-distance .kpi-value { 
  background: linear-gradient(135deg, #10b981, #059669);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
.kpi-card.kpi-calories .kpi-value { 
  background: linear-gradient(135deg, #FC4C02, #ff7a42);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
.kpi-card.kpi-elevation .kpi-value { 
  background: linear-gradient(135deg, #8b5cf6, #6d28d9);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.kpi-label {
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 1.2px;
  color: #9ca3af;
  margin-top: 6px;
  line-height: 1.2;
}

.kpi-empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 8px;
  color: #9ca3af;
  font-size: 13px;
  font-weight: 500;
  text-align: center;
  width: 100%;
}
.kpi-empty-state .kpi-empty-icon {
  font-size: 28px;
  opacity: 0.4;
  margin-bottom: 4px;
}
"

ui <- dashboardPage(
  skin  = "black",
  title = "ProjectK",
  
  dashboardHeader(
    titleWidth = 220,
    title = tags$div(
      class = "logo-wrap",
      tags$img(src = "logo.png", class = "logo-img"),
      tags$span(class = "logo-name", "ProjectK")
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
      menuItem("AI Chatbot", tabName = "ai_chatbot", icon = icon("robot")),
      menuItem("About & Help",tabName = "about",       icon = icon("info-circle"))
    )
  ),
  
  dashboardBody(
    
    tags$head(
      tags$link(rel = "shortcut icon", href = "logo.png"),
      tags$style(HTML(custom_css)),
      tags$script(HTML("

        $(document).on('click', '.metric-pill', function() {
          $('.metric-pill').removeClass('active');
          $(this).addClass('active');
          Shiny.setInputValue('ov_metric', $(this).data('val'), {priority: 'event'});
        });


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


        Shiny.addCustomMessageHandler('scrollChatBottom', function(msg) {
          var el = document.getElementById('chat_history_wrap_conv');
          if (!el) return;
          el.scrollTop = el.scrollHeight;
        });
      "))
    ),
    
    tabItems(
      tabItem(tabName = "overview",
              

              fluidRow(
                class = "overview-controls",
                column(3,
                       tags$span(class = "filter-label", "Sport"),
                       selectInput("ov_type", NULL,
                                   choices  = c("All"),
                                   selected = "All", width = "100%")
                ),
                column(3,
                       tags$span(class = "filter-label", "Year"),
                       selectInput("ov_year", NULL,
                                   choices  = c(format(Sys.Date(), "%Y")),
                                   selected = format(Sys.Date(), "%Y"), width = "100%")
                )
              ),
              
              fluidRow(
                uiOutput("kpi_acts_custom",  width = 3),
                uiOutput("kpi_dist_custom",  width = 3),
                uiOutput("kpi_cals_custom",  width = 3),
                uiOutput("kpi_elev_custom",  width = 3)
              ),
              
              fluidRow(
                box(
                  title = tagList(icon("calendar"), "Activity Calendar"),
                  width = 12, class = "box-orange",
                  plotlyOutput("heatmap_cal", height = "210px")
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
                  title = tagList(icon("chart-pie"), "Activity Split (Total Sessions)"),
                  width = 4, class = "box-orange",
                  plotlyOutput("ov_donut",     height = "276px")
                )
              )
      ),
      
      tabItem(tabName = "performance",
               

               fluidRow(
                 class = "overview-controls",
                 column(3,
                        tags$span(class = "filter-label", "Sport"),
                        selectInput("pf_type", NULL,
                                    choices = c("All", "Run","Ride","Swim","Hike","Walk","Workout"),
                                    selected = "All", width = "100%")),
                 column(8, class = "slider-col",
                        tags$span(class = "filter-label", "Date Range"),
                        uiOutput("pf_date_ui"))
               ),
               

               fluidRow(
                 box(title = tagList(icon("heartbeat"), "Max HR Distribution by Sport"),
                     width = 6, class = "box-orange",
                     plotlyOutput("pf_violin", height = "320px")),
                 box(title = tagList(icon("bullseye"), "Sport Profile Radar"),
                     width = 6, class = "box-orange",
                     plotlyOutput("pf_radar", height = "320px"))
               ),
                fluidRow(
                  box(title = tagList(icon("crosshairs"), "Efficiency Quadrant"),
                      width = 6, class = "box-orange",
                      plotlyOutput("pf_quadrant", height = "320px")),
                  box(title = tagList(icon("fire"), "Calories Over Time"),
                      width = 6, class = "box-orange",
                      plotlyOutput("pf_cals", height = "320px"))
                )
      ),
      
      tabItem(tabName = "insights",
              

              fluidRow(
                class = "overview-controls",
                column(3,
                       tags$span(class = "filter-label", "Sport"),
                       selectInput("ins_type", NULL,
                                   choices = c("All","Run","Ride","Swim","Hike","Walk","Workout"),
                                   selected = "All", width = "100%")),
                column(8, class = "slider-col",
                       tags$span(class = "filter-label", "Date Range"),
                       uiOutput("ins_date_ui"))
              ),
              

              fluidRow(style = "display:flex; flex-wrap:wrap; align-items:stretch;",
                box(title = tagList(icon("chart-line"), "Average Speed"),
                    width = 8, class = "box-orange",
                    plotlyOutput("ins_pace", height = "420px")),
                box(title = tagList(icon("trophy"), "Personal Records"),
                    width = 4, class = "box-orange",
                    uiOutput("personal_records"))
              ),
              

              fluidRow(
                box(title = tagList(icon("medal"), "Top Activities"),
                    width = 12, class = "box-orange",
                    uiOutput("ins_hover_info"),
                    div(id = "ins_table_wrap",
                        DTOutput("ins_top_table")
                    )
                )
              )
      ),
      
      tabItem(tabName = "ai_chatbot",
               
               fluidRow(
                 column(12,
                        
                        box(
                          title = tagList(icon("robot"), "AI Chatbot"),
                          width = 12, class = "box-orange",
                          div(id = "chat_history_wrap_conv", style = "white-space: pre-wrap; max-height: 560px; overflow: auto; padding: 12px; background: #ffffff; border-radius: 6px;",
                              uiOutput("chat_history")
                          ),
                          div(class = "chat-input-area",
                              textAreaInput("chat_prompt", NULL, placeholder = "Write a message...", width = "100%", height = "80px"),
                              actionButton("chat_send", tagList(icon("paper-plane"), " Send"), class = "chat-send-btn")
                          )
                        )
                 )
               )
      ),

      tabItem(tabName = "about",
              
              fluidRow(
                column(12,
                       
                       tags$div(class = "about-hero",
                                 tags$img(src = "logo.png", class = "about-logo-img"),
                                 tags$h1("ProjectK"),
                                 tags$p("Your Personal Athletic Intelligence Dashboard")
                        ),
                       
                       fluidRow(style = "display: flex; flex-wrap: wrap;",
                                column(6,
                                        tags$div(class = "about-card",
                                                 tags$h3(icon("bullseye"), " About ProjectK"),
                                                 tags$p(
                                                   "ProjectK is an R Shiny dashboard that transforms your exported ",
                                                   tags$strong("Strava activity data"), " into actionable intelligence. ",
                                                   "Track training patterns, monitor performance trends, contact a personalized AI coach and celebrate ",
                                                   "personal achievements — all in one beautiful, interactive interface."
                                                   ),
                                                 tags$p(tags$em("Developed by Krzysztof Nowak and Kajetan Wojnicki.")),
                                                tags$hr(),
                                                tags$h3(icon("database"), " Data"),
                                                tags$p(
                                                  "Place your ", tags$code("activities.csv"),
                                                  " (Strava bulk export) in the app directory or run ", tags$code("scrapper.py"), " with your API keys in ", tags$code(".env"), " file. ",
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
                                                          " All-time statistics, a GitHub-style activity calendar, monthly ",
                                                          "activity bars, and an activity pie chart. Filterable by year and dynamically detected sports."),
                                                   tags$li(tags$strong("Performance:"),
                                                           " Violin plot of max heart rate distribution by sport, Efficiency Quadrant showing effort vs speed with quadrant labels, Sport Profile Radar with normalized metrics for elevation, speed, distance, effort, calories, and max HR, and a sleek Calories Over Time area chart. Filterable by sport and date range."),
                                                  tags$li(tags$strong("Insights:"),
                                                          " Average-speed timeline with pacing jitter, ",
                                                          "personal records leaderboard, and ranked top-activities table. Filterable by year and sport."),
                                                  tags$li(tags$strong("AI Chatbot:"),
                                                          " A personal chatbot powered by your training data, ",
                                                          "designed to act as your ultimate motivational coach (Powered by BielikAI).")
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