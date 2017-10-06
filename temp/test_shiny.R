library(shiny)
library(kronawidget)

# testset<-read.csv2("../inst/extdata/MARS_stressors.csv", stringsAsFactors = F)
#
# doc<-
#   df_to_krona(testset, test, area, country, river.basin.district, first.stressor, second.stressor, third.stressor)




ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("obs", "Number of observations:", min = 10, max = 500, value = 100)
    ),
    mainPanel(
      div(3),
      # kronawidgetOutput("krona"),
      widgetframeOutput("krona"),
      div(4),
      plotOutput("pl")
      )
  )
)


server <- function(input, output) {

  # output$krona <- renderKronawidget({
  #   # browser()
  #   print(333)
  #   print(input$obs)
  #   kronawidget(doc)
  # })
  output$krona <- renderWidgetframe({
    frameWidget(kronawidget(doc, width="400px", height="700px"), width="400px", height="700px")
  })
  output$pl<-renderPlot({plot(4)})

}

shinyApp(ui = ui, server = server)
