library(shiny)
library(shinydashboard)

library(kronawidget)
testset<-read.csv2("../inst/extdata/MARS_stressors.csv", stringsAsFactors = F)

df_to_krona_c <- df_to_krona_cached(cache_type = "filesystem",
                                    cache_fs_path = "~/.cache")

ui <- dashboardPage(
  dashboardHeader(title = "kronawidget"),
  dashboardSidebar(
    uiOutput("select_l1"),
    uiOutput("select_l2"),
    uiOutput("select_l3"),
    uiOutput("select_l4"),
    actionButton("generate", "Generate")
  ),
  dashboardBody(
    fluidRow(
      box(width = 12,
          kronawidgetOutput("krona", height = 700)
      )
      # box(width = 12,
      #     kronawidgetOutput("krona2", height = 700)
      # )
    )
  )
)

server <- function(input, output) {

  krona_doc <- reactive({
    input$generate
    df_to_krona_c(df = testset,
                  name = "test",
                  magnitude = "area",
                  isolate(input$select_l1),
                  isolate(input$select_l2),
                  isolate(input$select_l3),
                  isolate(input$select_l4))

  })

  output$krona <- renderKronawidget({
    # kronawidget.mem(doc)
    kronawidget(krona_doc())
  })

  provider_levels <- reactive({
    l <- colnames(testset)

    l[3:length(l)]
  })

  output$select_l1 <- renderUI({
    values <- provider_levels()
    selectInput("select_l1", "Level 1", values)
  })

  output$select_l2 <- renderUI({
    values <- dplyr::setdiff(provider_levels(), c(input$select_l1))
    selectInput("select_l2", "Level 2", values)
  })

  output$select_l3 <- renderUI({
    values <- dplyr::setdiff(provider_levels(), c(input$select_l1, input$select_l2))
    selectInput("select_l3", "Level 3", values)
  })

  output$select_l4 <- renderUI({
    values <- dplyr::setdiff(provider_levels(), c(input$select_l1, input$select_l2, input$select_l3))
    selectInput("select_l4", "Level 4", values)
  })

}

shinyApp(ui = ui, server = server)


