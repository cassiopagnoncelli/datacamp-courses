library('shiny')
library('shinydashboard')

header = dashboardHeader(
  dropdownMenu(
    type = 'notifications',
    notificationItem("You've got a message", status = 'success')
  )
)

sidebar = dashboardSidebar(
  sidebarMenu(
    menuItem('Data', tabName = 'data'),
    menuItem('Dashboard', tabName = 'dashboard')
  )
)

body = dashboardBody(
  tabItems(
    tabItem(tabName = 'data', "Data here"),
    tabItem(
      tabName = 'dashboard', 
      tabBox(
        title = 'My first box',
        tabPanel('Tab 1', 'Tab 1 contents'),
        tabPanel('Tab 2', 'Tab 2 contents')
      )
    )
  )
)

ui = dashboardPage(header, sidebar, body)
server = function(input, output) {}

shinyApp(ui, server)
