library(shiny)
library(tidyverse)
library(data.table)

######## concentration f(x)s for log- and alternative dose spacing ########
log.conc.range <- function(top, bottom, steps, conc.no){
    conc <- top/((top/bottom)^(1/(steps)))^(conc.no-1)
    return(conc)
}

alt.conc.range <- function(top, bottom, steps, conc.no, dose.spacing.factor){
    conc <- top/((top/bottom)^(1/(steps)))^((conc.no-1)^1/(steps+2-conc.no)^dose.spacing.factor)
    return(conc)
}
###########################################################################

shinyServer(function(input, output) {

    output$conc <- renderDataTable({
        
        
    if(input$radio == 1){
        d <- data.frame()
        range = c(1:input$step)
        
        for (i in range) {
            d <- rbind(d,c(log.conc.range(input$topconc, input$bottomconc, input$step, i)))}
        colnames(d) = "Log Concentration"
        round(d, digits = 4)
        data.table(d) %>% mutate_if(is.numeric, ~round(., 3))
    }
        
    else if(input$radio == 2){
        d1 <- data.frame()
        range = c(1:input$step)
        
        for (i in range) {
            d1 <- rbind(d1,c(alt.conc.range(input$topconc, input$bottomconc, input$step, i, input$factor)))}
        colnames(d1) = "Alt-Log Concentration"
        round(d1, digits = 4)
        data.table(d1) %>% mutate_if(is.numeric, ~round(., 3)) 
    }    
        
        else if(input$radio == 3){
            d <- data.frame()
            d1 <- data.frame()
            d2 <- data.frame()
            range = c(1:input$step)
            
            for (i in range) {
                d <- rbind(d,c(log.conc.range(input$topconc, input$bottomconc, input$step, i)))}
            colnames(d) = "Log Concentration"
            round(d, digits = 4)
            
            for (i in range) {
                d1 <- rbind(d1,c(alt.conc.range(input$topconc, input$bottomconc, input$step, i, input$factor)))}
            colnames(d1) = "Alt-Log Concentration"
            round(d1, digits = 4)
            
            d2 <- cbind(d,d1)
            data.table(d2) %>% mutate_if(is.numeric, ~round(., 3))
            
        }
    })
    
    
    
    ############Only keep if running local##################
    ############ShinyIO doesn't store local#################
   #     observe({if(input$save == 0){} 
   #         else if(input$save == 1){
   #             if(input$radio == 1){
   #                 d <- data.frame()
   #                 range = c(1:input$step)
#                    
#                    for (i in range) {
#                        d <- rbind(d,c(log.conc.range(input$topconc, input$bottomconc, input$step, i)))}
#                    colnames(d) = "Log Concentration"
#                    d <- round(d, digits = 4) 
#                    d <- data.table(d) %>% mutate_if(is.numeric, ~round(., 3))
#                    write.csv(d, file = paste0(input$filepath, input$filename,".csv"), row.names = FALSE)
#                }
#                
#                if(input$radio == 2){
#                    d1 <- data.frame()
#                    range = c(1:input$step)
#                    
#                    for (i in range) {
#                        d1 <- rbind(d1,c(alt.conc.range(input$topconc, input$bottomconc, input$step, i, input$factor)))}
#                    colnames(d1) = "Alt-Log Concentration"
#                    d1 <- round(d1, digits = 4)  
#                    d1 <- data.table(d1) %>% mutate_if(is.numeric, ~round(., 3))
#                    write.csv(d1, file = paste0(input$filepath, input$filename,".csv"), row.names = FALSE)
#                }
#        
 #               if(input$radio == 3){
 #                   d <- data.frame()
 #                   d1 <- data.frame()
 #                   d2 <- data.frame()
 #                   range = c(1:input$step)
 #                   
 #                   for (i in range) {
 #                       d <- rbind(d,c(log.conc.range(input$topconc, input$bottomconc, input$step, i)))}
 #                   colnames(d) = "Log Concentration"
 #                   d <- round(d, digits = 4)
 #                   
 #                   for (i in range) {
 #                       d1 <- rbind(d1,c(alt.conc.range(input$topconc, input$bottomconc, input$step, i, input$factor)))}
 ##                   colnames(d1) = "Alt-Log Concentration"
  #                  d1 <- round(d1, digits = 4)
  #                  
  #                  d2 <- cbind(d,d1)  
  #                  d2 <- data.table(d2) %>% mutate_if(is.numeric, ~round(., 3))
  #                  write.csv(d2, file = paste0(input$filepath, input$filepath, input$filename,".csv"), row.names = FALSE)
  #              }
  #              }
  #          })
})



































