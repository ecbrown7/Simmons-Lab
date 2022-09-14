library(shiny)
library(tidyverse)
library(shinythemes)
library(shinyWidgets)


shinyUI(fluidPage(

    # Title
    titlePanel("Simmons Log and Alt-Log Dosing Range Finder"),

    # Sidebar 
    sidebarLayout(
        sidebarPanel(
            radioButtons("radio", label = strong("Select Spacing Type"),
                         choices = list("Log" = 1, "Alt-Log" = 2, "Both" = 3), 
                         selected = 1),
            numericInput("topconc", label = strong("Top Concentration (uM)"), step = 1, value = 100),
            numericInput("bottomconc", label = strong("Bottom Concentration (uM)"), step = 0.001, value = 0.001),
            numericInput("step", label = strong("Number of Steps"), min = 5, max = 15, step = 1, value = 10),
            conditionalPanel(
                condition = "input.radio != 1",
                numericInput("factor", label = strong("Alt-Log Spacing Factor"), min = 0, max = 1, step = 0.1, value = .3)),
       
    #Web based version won't allow for local saving#             
     #       textInput("filepath", "File Path", placeholder = "ex. C:/Users/username/OneDrive - Environmental Protection Agency (EPA)/Profile/Desktop/ "),
     #       h6(em("*Note: Use forward slashes only in file path*"), style = "font-size:12px;"),
     #       textInput("filename", "File Name", placeholder = "Insert File Name"),

     #       actionButton("save", "Save as .CSV")
            ),

        # Main Panel
        mainPanel(
            dataTableOutput("conc")
        )
    ), theme = shinytheme("yeti")
))
