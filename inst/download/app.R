# Setting up data and config ----------------------------------------------
if (!is.null(getOption("shiny.testmode"))) {
  if (getOption("shiny.testmode") == TRUE) {
    source("./global/config_tests.R", local = TRUE)
  }
} else {
  source("./global/config.R", local = TRUE)
}
# **UI** ------------------------------------------------------------------

ui <- function(request) {
  shinydashboard::dashboardPage(
    skin = "purple",
    title = "Document extraction tool",


    # Header ------------------------------------------------------------------
    shinydashboard::dashboardHeader(
      title = 'Document extraction\ntool',
      titleWidth = 275,
      shinydashboard::dropdownMenuOutput("dropdownmenu")
    ),

    # Sidebar -----------------------------------------------------------------
    source("./ui/ui_sidebar.R", local = TRUE)$value,

    # Body --------------------------------------------------------------------
    shinydashboard::dashboardBody(

    # CSS and JS files --------------------------------------------------------
    source("./ui/css_js_import.R", local = TRUE)$value,

    # Fluid row ---------------------------------------------------------------
    shiny::fluidRow(
      shiny::column(width = 6,

     # Info box ----------------------------------------------------------------
     source("./ui/ui_info_box.R", local = TRUE)$value,
     # Download box ------------------------------------------------------------
     source("./ui/ui_download_box.R", local = TRUE)$value)
                  ),
    shinyjs::useShinyjs())
  )
}

# **SERVER** --------------------------------------------------------------

server <- function(input, output, session) {

# Conditional sidebar UI elements -----------------------------------------
source("./ui/render_ui_sidebar_date_filtering.R", local = TRUE)

# Loading functions -------------------------------------------------------
source("server/functions_term_collection.R", local = TRUE)
source("server/function_subset.R", local = TRUE)
source("server/function_corpus_info.R", local = TRUE)
source("server/function_subset_arguments.R", local = TRUE)

# Session variables -------------------------------------------------------
source("./server/session_variabler.R", local = TRUE)

# Element control ---------------------------------------------------------
source("./server/server_element_control.R", local = TRUE)

# Info on start-up --------------------------------------------------------
source("./server/server_info_on_startup.R", local = TRUE)

# Event: search button ----------------------------------------------------
source("./server/server_event_search_button.R", local = TRUE)

# HTML --------------------------------------------------------------------
source("./server/server_download_html.R", local = TRUE)

# Cleaning up the session -------------------------------------------------
shiny::onSessionEnded(function() {
  shiny::shinyOptions("corporaexplorer_download_data" = NULL)
  shiny::shinyOptions("corporaexplorer_download_max_html" = NULL)
})
}

# Run app -----------------------------------------------------------------

shiny::shinyApp(ui, server)
