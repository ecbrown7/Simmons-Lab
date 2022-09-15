library(shiny)
library(tidyverse)

mRNA_transfections2 = function(volTf, numWells, delWell, porPerc, mmRNARatio, messMaxDil) {
    
    #Set Cyp Map
    cyp = c("Bgal", "Cyp1A2", "Cyp2A6", "Cyp2B6", "Cyp2C8", "Cyp2C9", "Cyp2C19", "Cyp2D6", "Cyp2E1", "Cyp2J2", "Cyp3A4")
    cypconc = c(1.84, 1.98, 1.86, 1.95, 1.91, 1.84, 1.55, 1.89, 1.98, 1.78, 1.79)
    cyps = as.data.frame(cbind(cyp, cypconc))
    
    #Create empty dataframe for compiling iterations
    df = data.frame()
    
    for(i in 1:nrow(cyps)){
        #Total volume required to dispense desired # wells
        totalVol = volTf*numWells
        #Adjusted volume to account for priming, general fluid loss
        adjVol = totalVol*1.2
        #Selected cyp concentration (ug/ul)
        mRNAconc = as.numeric(cyps$cypconc[i])
        #Function to calculate appropriate volume mRNA to add to achieve final concentration that will deliver desired mRNA (ng) per well
        mRNAvol = (((delWell/1000) * adjVol/ volTf)/mRNAconc)
        
        #Por concentration
        porConc = 1.87
        
        #Make total mRNA POR inclusive: delWell = mRNA + POR
        totmRNA = mRNAvol * mRNAconc
        newPOR = totmRNA*porPerc
        adjPOR = newPOR / porConc
        newmRNA = totmRNA*(1-porPerc)
        adjmRNA = newmRNA / mRNAconc
        
        #Use if/then logic to determine which POR to deliver
        finalPor = adjPOR
        finalPor10 = finalPor*10
        finalPor20 = finalPor*20
        
        #Find vol of messmax required
        mmVol = mmRNARatio * totmRNA
        #Vol of Opti to dilute MessMax with
        mmOpti = mmVol/messMaxDil
        #Make Opti volume reactive to different POR dilutions
        optiVol2 = ifelse(finalPor < 0.1, (adjVol - mRNAvol - mmVol - finalPor10),
                          ifelse(finalPor < 1, adjVol - mRNAvol - mmVol - finalPor10, 
                                 adjVol - mRNAvol - mmVol - finalPor))
        #Volume of opti to mix mRNA in
        mRNAOpti = optiVol2 - mmOpti
        
        #Output for each cyp iteration
        output = c(cyps$cyp[i], round(as.numeric(ifelse(finalPor < 0.1, finalPor20, ifelse(finalPor < 1, finalPor10, finalPor))), digits = 2), ifelse(finalPor < 0.1, "1:20", ifelse(finalPor < 1, "1:10", "No Dilution")), round(as.numeric(mmVol), digits = 2), round(as.numeric(adjmRNA), digits = 2), round(as.numeric(mmOpti), digits = 2), round(as.numeric(mRNAOpti), digits = 2))
        
        #Compile iterations
        df = rbind(df, output)
        
        #Edit table features
        colnames(df) = c("Cyp", "POR Volume (uL)", "POR Dilution", "MessengerMax Volume (uL)", "mRNA Volume (uL)", "Opti-MEM Volume for MM Dilution (uL)", "Opti-MEM Volume for mRNAs (uL)")
    }
    
    return(df[,c(1, 5, 2, 3, 7, 4, 6)])
}


#Shiny server function to get outputs
shinyServer(function(input, output) {

    #info table output
    output$info <- renderTable({
        mRNA_transfections2(input$tv, input$wells, input$ng, input$por, input$ratio, input$dilution)
    })
    
    #Tube A instructions output
    output$text1 = renderText({
        testset = mRNA_transfections2(input$tv, input$wells, input$ng, input$por, input$ratio, input$dilution)
        MMsum = round(sum(as.numeric(testset[,6])) * 1.1, digits = 2)
        Optisum = round(sum(as.numeric(testset[,7])) *1.1/1000, digits = 2)
        
        paste0("Tube A Mastermix: Add ", MMsum, "uL MessengerMax to ", Optisum, "mL Opti-MEM.")
    })

})




