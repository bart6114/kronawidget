#' <Add Title>
#'
#' <Add Description>
#'
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param krona_df Dataframe
#' @param elementId Element ID
#' @import htmlwidgets
#'
#' @export
kronawidget <- function(krona_df, width = "100%", height = "500px", elementId = NULL) {

  temp_xml_file <- tempfile()
  xml2::write_xml(xml2::as_xml_document(krona_df), temp_xml_file, options = c("format", "no_declaration"))

  # forward options using x
  x = list(
    content =  paste0(readLines(temp_xml_file), collapse = "\n")
  )


  # create widget
  htmlwidgets::createWidget(
    name = 'kronawidget',
    x,
    width = width,
    height = height,
    package = 'kronawidget',
    elementId = elementId
  )
}

#' Shiny bindings for kronawidget
#'
#' Output and render functions for using kronawidget within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a kronawidget
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name kronawidget-shiny
#'
#' @export
kronawidgetOutput <- function(outputId, width = '100%', height = '500px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'kronawidget', width, height, package = 'kronawidget')
}

#' @rdname kronawidget-shiny
#' @export
renderKronawidget <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, kronawidgetOutput, env, quoted = TRUE)
}
