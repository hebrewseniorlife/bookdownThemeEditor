bdTheme_ui <- miniPage(
  gadgetTitleBar("Bookdown Theme Editor", left = NULL),
  miniContentPanel(
    div(
      class = "row", style = "margin-bottom: 10px;",
      div(
        class = "col-xs-8",
        span(style = "font-size: 10px", "Load this css file by putting ",
             tags$code("css: style.css"), "in ", tags$code("_output.yml"),
             "under", tags$code("bookdown::gitbook"), ". See",
             tags$a("here",
                    href = "https://bookdown.org/yihui/rmarkdown/custom-css-1.html"),
             "for details.")
      ),
      div(
        class = "col-xs-4",
        actionButton("generateCSS", "Generate style.css")
      )
    ),
    div(
      class = "well",
      fillRow(
        flex = c(1, 4), height = "50px",
        h5(tags$a("Google Fonts:", href = "https://fonts.google.com/",
                  target = "_blank"),
           tags$a(icon("question-circle-o"), target = "_blank",
                  href = "https://developers.google.com/fonts/docs/getting_started")),
        uiOutput("font_google")
      ),
      fillRow(
        flex = c(1, 5), height = "45px", h5("Serif:"),
        uiOutput("font_serif")
      ),
      fillRow(
        flex = c(1, 5), height = "45px", h5("Sans:"),
        uiOutput("font_sans")
      )
    ),
    fillRow(
      flex = c(1, 1), height = "100px",
      uiOutput("toc_width"),
      uiOutput("line_height")
    )
  )
)

bdTheme_server <- function(input, output, session) {
  observeEvent(input$done, {
    invisible(stopApp())
  })

  if (file.exists("~/.bdTheme")) {
    init_meta <- read.dcf("~/.bdTheme")
  } else {
    init_meta <- matrix(c(
      "",
      "Georgia, serif",
      '"Helvetica Neue", Helvetica, Arial, sans-serif',
      "300",
      "1.7"
    ), nrow = 1)
    colnames(init_meta) <- c("google", "serif", "sans", "tocWidth", "lineHeight")
  }

  meta <- reactive({
    req(input$tocWidth)
    out <- matrix(c(input$google, input$serif, input$sans,
                    input$tocWidth, input$lineHeight), nrow = 1)
    colnames(out) <- c("google", "serif", "sans", "tocWidth", "lineHeight")
    return(out)
  })

  observeEvent(meta(), {
    write.dcf(meta(), "~/.bdTheme")
    updateActionButton(session, "generateCSS",
                       label = "Generate style.css",
                       icon = character(0))
  })


  output$font_google <- renderUI({
    textInput("google", NULL, value = init_meta[, "google"], width = "95%",
              placeholder = "Example: Charmonman|Source+Sans+Pro")
  })

  output$font_serif <- renderUI({
    textInput("serif", NULL, width = "95%", value = init_meta[, "serif"],
              placeholder = "Georgia, serif")
  })

  output$font_sans <- renderUI({
    textInput(
      "sans", NULL, width = "95%", value = init_meta[, "sans"],
      placeholder = '"Helvetica Neue", Helvetica, Arial, sans-serif'
    )
  })

  output$toc_width <- renderUI({
    sliderInput(
      "tocWidth", "TOC Width", value = init_meta[, "tocWidth"], width = "95%",
      min = 100, max = 500, step = 10
    )
  })

  output$line_height <- renderUI({
    sliderInput(
      "lineHeight", "Line Height", value = init_meta[, "lineHeight"],
      width = "95%", min = 1, max = 2, step = 0.1
    )
  })

  css <- reactive({
    out <- c()
    out <- c(out, bd_google_font(input$google))
    out <- c(out, bd_font(input$serif, input$sans))
    if (as.numeric(input$tocWidth) != 300) {
      out <- c(out, bd_toc_width(as.numeric(input$tocWidth)))
    }
    if (as.numeric(input$lineHeight) != 1.7) {
      out <- c(out, bd_line_height(as.numeric(input$lineHeight)))
    }
    out <- paste(out, collapse = "\n")
    return(out)
  })

  observeEvent(input$generateCSS, {
    write(css(), "style.css")
    updateActionButton(session, "generateCSS",
                       label = "Generated",
                       icon = icon("check" , class = "text-success"))
  })
}

#' r2cluster RStudio Addin
#'
#' @import shiny miniUI glue
#' @export
bdTheme_addin <- function() {
  shiny::runGadget(bdTheme_ui, bdTheme_server, viewer = paneViewer())
}
