#' Checkbox Group Input Control
#'
#' Create a group of checkboxes that can be used to toggle multiple choices
#' independently. The server will receive the input as a character vector of the
#' selected values.
#'
#' @inheritParams textInput
#' @param choices List of values to show checkboxes for. If elements of the list
#'   are named then that name rather than the value is displayed to the user. If
#'   this argument is provided, then \code{choiceNames} and \code{choiceValues}
#'   must not be provided, and vice-versa. The values should be strings; other
#'   types (such as logicals and numbers) will be coerced to strings.
#' @param selected The values that should be initially selected, if any.
#' @param inline If \code{TRUE}, render the choices inline (i.e. horizontally)
#' @param choiceNames,choiceValues List of names and values, respectively,
#'   that are displayed to the user in the app and correspond to the each
#'   choice (for this reason, \code{choiceNames} and \code{choiceValues}
#'   must have the same length). If either of these arguments is
#'   provided, then the other \emph{must} be provided and \code{choices}
#'   \emph{must not} be provided. The advantage of using both of these over
#'   a named list for \code{choices} is that \code{choiceNames} allows any
#'   type of UI object to be passed through (tag objects, icons, HTML code,
#'   ...), instead of just simple text. See Examples.
#'
#' @return A list of HTML elements that can be added to a UI definition.
#'
#' @family input elements
#' @seealso \code{\link{checkboxInput}}, \code{\link{updateCheckboxGroupInput}}
#'
#' @examples
#' ## Only run examples in interactive R sessions
#' if (interactive()) {
#'
#' ui <- fluidPage(
#'   checkboxGroupInput("variable", "Variables to show:",
#'                      c("Cylinders" = "cyl",
#'                        "Transmission" = "am",
#'                        "Gears" = "gear")),
#'   tableOutput("data")
#' )
#'
#' server <- function(input, output, session) {
#'   output$data <- renderTable({
#'     mtcars[, c("mpg", input$variable), drop = FALSE]
#'   }, rownames = TRUE)
#' }
#'
#' shinyApp(ui, server)
#'
#' ui <- fluidPage(
#'   checkboxGroupInput("icons", "Choose icons:",
#'     choiceNames =
#'       list(icon("calendar"), icon("bed"),
#'            icon("cog"), icon("bug")),
#'     choiceValues =
#'       list("calendar", "bed", "cog", "bug")
#'   ),
#'   textOutput("txt")
#' )
#'
#' server <- function(input, output, session) {
#'   output$txt <- renderText({
#'     icons <- paste(input$icons, collapse = ", ")
#'     paste("You chose", icons)
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#' @export
checkboxGroupInput <- function(inputId, label, choices = NULL, selected = NULL,
  inline = FALSE, width = NULL, choiceNames = NULL, choiceValues = NULL) {

  # keep backward compatibility with Shiny < 1.0.1 (see #1649)
  if (is.null(choices) && is.null(choiceNames) && is.null(choiceValues)) {
    choices <- character(0)
  }

  args <- normalizeChoicesArgs(choices, choiceNames, choiceValues)

  selected <- restoreInput(id = inputId, default = selected)

  # default value if it's not specified
  if (!is.null(selected)) selected <- as.character(selected)

  options <- generateOptions(inputId, selected, inline,
    'checkbox', args$choiceNames, args$choiceValues)

  divClass <- "form-group shiny-input-checkboxgroup shiny-input-container"
  if (inline)
    divClass <- paste(divClass, "shiny-input-container-inline")

  # return label and select tag
  tags$div(id = inputId,
    style = if (!is.null(width)) paste0("width: ", validateCssUnit(width), ";"),
    class = divClass,
    shinyInputLabel(inputId, label),
    options
  )
}
