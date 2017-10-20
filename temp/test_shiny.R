library(shiny)
library(shinydashboard)
library(kronawidget)


ui <- dashboardPage(
  dashboardHeader(title = "kronawidget"),
  dashboardSidebar(),
  dashboardBody(
    fluidRow(
      box(width = 12, height="700px",
          div(style="height: 700px;",
        kronawidgetOutput("krona", height="700px"))
      )
    )
  )
)
#
# ui <- fluidPage(
#   sidebarLayout(
#     sidebarPanel(
#       sliderInput("obs", "Number of observations:", min = 10, max = 500, value = 100)
#     ),
#     mainPanel(
#       kronawidgetOutput("krona")
#       )
#   )
# )


server <- function(input, output) {

  output$krona <- renderKronawidget({
    kronawidget(doc)
  })
}

shinyApp(ui = ui, server = server)


