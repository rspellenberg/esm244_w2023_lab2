library(shiny)
library(tidyverse)
library(palmerpenguins)

### Create the user interface (shiny uses camelCase)
ui <- fluidPage(
  titlePanel("I am adding a title!"),
  sidebarLayout(
    sidebarPanel("Put my widgets here!",
                 radioButtons(inputId = 'penguin_species',
                              label = "Chose penguin species!",
                              choices = c("Adelie", "Gentoo", "Cool Chinstrap" = "Chinstrap")),
                 "Choose a color",
                 selectInput(inputId = 'pt_color',
                             label = 'choose your favorite color!',
                             choices = c('Awesome Red' = 'red',
                             'pretty purple' = 'purple',
                             'OOOOOrange' = 'orange'))
                 ), ### end sidebarPanel
    mainPanel("Put my graph here!",
              plotOutput(outputId = 'penguin_plot'),
              tableOutput(outputId = 'penguin_table')
              ) ### end mainPanel
  ) ### end sidebarLayout here
) ### end fluidPage here

### Create the server function
server <- function(input, output){
  penguin_select <- reactive({
    penguins %>%
      filter(species == input$penguin_species)
  })

  penguin_table <- reactive({
    penguins %>%
      filter(species == input$penguin_species) %>%
      group_by(sex) %>%
      summarize(mean_flip = mean(flipper_length_mm),
                mean_mass = mean(body_mass_g))
  }) ### end penguin_table

  output$penguin_plot <- renderPlot({

    ggplot(data = penguin_select(),
           aes(x = flipper_length_mm, y = body_mass_g)) +
      geom_point(color = input$pt_color) +
      theme_minimal()
  })

  output$penguin_table <- renderTable({
    penguin_table()
  })
}

### Combine these into an app
shinyApp(ui = ui, server = server)
