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
                         value = 50),
            h6("Note: Transfection volume should be ~ 1/10th of final mRNA target."),
            
            numericInput("tv",
                        "Transfection Volume (uL/well)",
                        value = 5),
            
            numericInput("wells",
                         "Number of Wells to Transfect",
                         value = 384, step = 1),
            
            numericInput("por",
                         "Final POR Percentage (of total mRNA)",
                         value = 0.01),
            
            numericInput("ratio",
                         "MessengerMax to mRNA Ratio (ul:ug)",
                         value = 2.5),
            
            numericInput("dilution",
                         "MessengerMax Dilution (to Opti-MEM)",
                         value = 1/20),
            checkboxInput("concs", "Edit Stock mRNA Concentrations (ug/uL)", value = FALSE),
            conditionalPanel(condition = "input.concs == '1'",
                             numericInput("bgal", "Bgal", value = 1.84),
                             numericInput("a", "Cyp1A2", value = 1.98),
                             numericInput("aa", "Cyp2A6", value = 1.86),
                             numericInput("b", "Cyp2B6", value = 1.95),
                             numericInput("c", "Cyp2C8", value = 1.91),
                             numericInput("cc", "Cyp2C9", value = 1.84),
                             numericInput("ccc", "Cyp2C19", value = 1.55),
                             numericInput("d", "Cyp2D6", value = 1.89),
                             numericInput("e", "Cyp2E1", value = 1.98),
                             numericInput("j", "Cyp2J2", value = 1.78),
                             numericInput("aaa", "Cyp3A4", value = 1.79),
                             numericInput("por2", "POR", value = 1.87)
                             ),
            h5("General Protocol:"),  
            h5("1. Prepare Tube A Mastermix (MessengerMax + Opti-MEM)"),
            h5("2. Make POR dilution (if necessary)"),
            h5("3. Mix Tube B's (mRNAs + Opti-MEM) -> vortex"),
            h5("4. Aliquot Tube A Mastermix to Tube B's -> vortex"),
            h5("5. Incubate 5 minutes"),
            h5("6. Dispense")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tableOutput("info"),
            br(),
            textOutput("text1")
        )
    ), theme = shinytheme("yeti")
))
