library(shiny)
library(shinythemes)

shinyUI(fluidPage(

    # Application title
    titlePanel("Simmons Lab mRNA Transfections Application"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            numericInput("ng",
                         "Final mRNA Target (ng/well)",
                         value = 15),
            h6("Note: Transfection volume should be ~ 1/10th of final mRNA target."),
            
            numericInput("tv",
                        "Transfection Volume (uL/well)",
                        value = 1.0),
            
            numericInput("wells",
                         "Number of Wells to Transfect",
                         value = 1536, step = 1),
            
            numericInput("por",
                         "Final POR Percentage (of total mRNA)",
                         value = 0.01),
            
            numericInput("ratio",
                         "MessengerMax to mRNA Ratio (ul:ug)",
                         value = 2.5),
            
            numericInput("dilution",
                         "MessengerMax Dilution (to Opti-MEM)",
                         value = 1/20)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tableOutput("info")
        )
    ), theme = shinytheme("yeti")
))
