library('shiny')

# There are times when you want to perform an action in response to an event.
# For example, you might want to let the app user download a table as a CSV
# file, when they click on a "Download" button. Or, you might want to display
# a notification or modal dialog, in response to a click.
# 
# The observeEvent() function allows you to achieve this. It accepts two
# arguments:
# 
# 1. The event you want to respond to.
# 2. The function that should be called whenever the event occurs.
# 
# In this exercise, you will use observeEvent() to display a modal dialog
# with help text, when the user clicks on a button labelled "Help".
# The help text has already been assigned to the variable bmi_help_text.

# So in the end of the day we have
#   isolate(): stop
#   eventReactive(): delay (tied to render), executed only once
#   observeEvent(): trigger (observer), used for side effects

bmi_help_text = "Body Mass Index is a simple calculation using a person's
height and weight. The formula is BMI = kg/m2 where kg is a person's
weight in kilograms and m2 is their height in metres squared.
A BMI of 25.0 or more is overweight, while the healthy range is 18.5 to 24.9."

server <- function(input, output, session) {
  observeEvent(input$show_help, {
    showModal(modalDialog(bmi_help_text))
  })
  
  rv_bmi <- eventReactive(input$show_bmi, {
    input$weight/(input$height^2)
  })

  output$bmi <- renderText({
    paste("Hi", input$name, ". Your BMI is", round(rv_bmi(), 1))
  })
}

ui <- fluidPage(
  titlePanel('BMI Calculator'),
  sidebarLayout(
    sidebarPanel(
      textInput('name', 'Enter your name'),
      numericInput('height', 'Enter your height in meters', 1.5, 1, 2),
      numericInput('weight', 'Enter your weight in Kilograms', 60, 45, 120),
      actionButton("show_bmi", "Show BMI"),
      actionButton('show_help', 'Help')
    ),
    mainPanel(
      textOutput("bmi")
    )
  )
)

shinyApp(ui = ui, server = server)