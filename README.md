# ProjectK - Strava Interactive Dashboard

[![R Version](https://img.shields.io/badge/R-%3E%3D%204.0-blue)](https://www.r-project.org/)
[![Shiny](https://img.shields.io/badge/Shiny-1.8+-orange)](https://shiny.rstudio.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Live Demo](https://img.shields.io/badge/Live%20Demo-ProjectK-FC4C02)](https://krzychunowak.shinyapps.io/strava-dashboard/)

> **Personal Athletic Intelligence Dashboard** — Transform your Strava data into actionable training insights with interactive visualizations and an AI-powered coach.

---

# PROJECT IS NOT UPDATING ANYMORE DUE TO MISSING STRAVA SUBSCRIPTION

## Features

### Overview
- **KPI Cards**: Activities, Distance, Calories, Elevation
- **Activity Calendar**: GitHub-style yearly heatmap
- **Monthly Trends**: Stacked bars by sport (distance/elevation toggle)
- **Sport Split**: Donut chart with activity type distribution

### Performance
- **Effort Distribution**: Violin plots of relative effort by sport
- **Efficiency Quadrant**: Effort vs Speed with quadrant labels (Hard+Fast, Easy+Slow, etc.)
- **Sport Profile Radar**: 6 normalized metrics (Elevation, Speed, Distance, Effort, Calories, Max HR)
- **Calories Timeline**: Scatter plot with LOESS trend

### Insights
- **Speed Trend**: Rolling average speed over time
- **Personal Records**: Longest run/ride, most elevation, peak HR, most active month
- **Top Activities**: Sortable table with chart hover synchronization

### AI Chatbot
- **Bielik-powered coach** (via PCSS/PSNC LLM)
- Context-aware: knows your training history, recent activities, PRs
- Polish language responses, honest coaching tone

### About & Help
- Documentation, data setup guide, feature explanations

---

## Quick Start

### Option 1: Local R (Recommended)
```r
# 1. Generate demo data (or use your own activities.csv or use default activities.csv)
Rscript generate_data.R 1000

# 2. Launch app
shiny::runApp()
```

### Option 2: With Your Strava Data
```bash
# 1. Copy .env.template to .env and fill in credentials
cp .env.template .env

# 2. Fetch activities via Strava API
python scrapper.py

# 3. Launch app
shiny::runApp()
```


---

## Data Setup

| Method | Description |
|--------|-------------|
| **Auto-sync (CI/CD)** | GitHub Action runs `scrapper.py` every 6h + on push (`.github/workflows/sync_strava.yaml`) |
| **Manual fetch** | Run `python scrapper.py` with `.env` configured |
| **Strava export** | Place bulk export `activities.csv` in app root |
| **Demo data** | `Rscript generate_data.R` |

### Strava API Credentials
1. Create app at [developers.strava.com](https://developers.strava.com/)
2. Get `CLIENT_ID`, `CLIENT_SECRET`
3. Generate `REFRESH_TOKEN` via OAuth flow
4. Add to `.env` (see Configuration)

---

## AI Chatbot Setup

The chatbot uses **Bielik** - Polish LLM hosted on **PCSS/PSNC** infrastructure.

### Required Environment Variables
```bash
PCSS_API_KEY=your_api_key          # Required
PCSS_BASE_URL=https://llm.hpc.psnc.pl/v1  # Default
PCSS_MODEL=bielik_11b              # Default
```

Get API access from [PCSS](https://pcss.pl/).

---

## Configuration

Create `.env` from template:
```bash
cp .env.template .env
```

### `.env.template`
```bash
# Strava API
STRAVA_CLIENT_ID=
STRAVA_CLIENT_SECRET=
STRAVA_REFRESH_TOKEN=

# LLM (Bielik/PCSS)
PCSS_API_KEY=
PCSS_BASE_URL=https://llm.hpc.psnc.pl/v1
PCSS_MODEL=bielik_11b
```

---

## Project Structure

```
├── ui.R                 # Dashboard UI: tabs, layout, custom CSS
├── server.R             # Reactive logic, plots, chatbot handler
├── global.R             # Shared utils: data loading, LLM client, helpers
├── scrapper.py          # Strava API v3 → activities.csv (detailed)
├── generate_data.R      # Realistic demo data generator
├── requirements.txt     # Python: requests, python-dotenv
├── .github/workflows/   # CI/CD: auto-sync Strava data
├── www/logo.png         # App logo (34×34 for header, 78×78 for about)
└── .env                 # Secrets (gitignored)
```

---

## Dependencies

### R Packages
```r
shiny, shinydashboard, plotly, DT, dplyr, lubridate,
fontawesome, httr, jsonlite, stringr
```

### Python Packages
```txt
requests
python-dotenv
```

Install R deps: `install.packages(c("shiny","shinydashboard","plotly","DT","dplyr","lubridate","fontawesome","httr","jsonlite","stringr"))`

Install Python deps: `pip install -r requirements.txt`

---

## License

MIT License — see [LICENSE](LICENSE) for details.

