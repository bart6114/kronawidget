library(shiny)
library(shinydashboard)
library(kronawidget)


ui <- dashboardPage(
  dashboardHeader(title = "kronawidget"),
  dashboardSidebar(),
  dashboardBody(
    fluidRow(
      box(width = 12,
              kronawidgetOutput("krona", height = 700)
      ),
      box(width = 12,
          kronawidgetOutput("krona2", height = 700)
      )
    )
  )
)

server <- function(input, output) {

  output$krona <- renderKronawidget({
    kronawidget.mem(doc)
  })

  output$krona2 <- renderKronawidget({
    kronawidget.mem(doc)
  })
}

shinyApp(ui = ui, server = server)


