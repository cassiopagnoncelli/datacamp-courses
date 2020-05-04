library('shiny')

# Shiny's reactive programming framework is designed such that
# any changes to inputs automatically updates the outputs that
# depend on it.
# In some situations, we might want more explicitly control the
# trigger that causes the update.

# The function eventReactive() is used to compute a reactive
# value that only updates in response to a specific event.
# 
# rval_x <- eventReactive(input$event, {
#   calculations
# })
# 

ui = fluidPage(
  titlePanel('BMI Calculator'),
  sidebarLayout(
    sidebarPanel(
      textInput('name', 'Enter your name'),
      numericInput('height', 'Enter height (in m)', 1.75, 1, 2, step = 0.01),
      numericInput('weight', 'Enter weight (in Kg)', 100, 45, 120),
      actionButton("show_bmi", "Show BMI")
    ),
    mainPanel(
      textOutput("bmi")
    )
  )
)

server = function(input, output, session) {
  rval_bmi = eventReactive(input$show_bmi, {
    input$weight/(input$height^2)
  })
  
  output$bmi = renderText({
    bmi <- rval_bmi()
    paste("Hi ", input$name, ", your BMI is ", round(bmi, 1), sep='')
  })
}

shinyApp(ui = ui, server = server)
