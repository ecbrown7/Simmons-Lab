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
        
        #Por concentration is fixed
        porConc = 1.87
        totmRNA = mRNAvol * mRNAconc
        #Calculate target amount (ug) of POR to add
        porTarget = totmRNA * porPerc
        #Calculate uL POR to add from stock
        #Use if/then logic to determine which POR to deliver
        finalPor = porTarget/porConc
        finalPor10 = finalPor*10
        finalPor20 = finalPor*20
        
        #Find vol of messmax required
        mmVol = mmRNARatio * totmRNA
        
        #Find total opti vol
        optiVol = adjVol - mRNAvol - mmVol - finalPor10
        #Vol of Opti to dilute MessMax with
        mmOpti = mmVol/messMaxDil
        #Volume of opti to mix mRNA in
        mRNAOpti = optiVol - mmOpti
        
        #Output for each iteration
        output = c(cyps$cyp[i], round(as.numeric(ifelse(finalPor < 0.1, finalPor20, ifelse(finalPor < 1, finalPor10, finalPor))), digits = 3), ifelse(finalPor < 0.1, "1:20", ifelse(finalPor < 1, "1:10", "No Dilution")), round(as.numeric(mmVol), digits = 3), round(as.numeric(mRNAvol), digits = 3), round(as.numeric(mmOpti), digits = 3), round(as.numeric(mRNAOpti), digits = 3))
        
        #Compile iterations
        df = rbind(df, output)
        
        #Edit table feature
        colnames(df) = c("Cyp", "POR Volume (uL)", "POR Dilution", "MessengerMax Volume (uL)", "mRNA Volume (uL)", "Opti-MEM Volume for MM Dilution (uL)", "Opti-MEM Volume for mRNAs (uL)")
    }
    
    return(df[,c(1, 5, 2, 3, 7, 4, 6)])
}


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$info <- renderTable({
        
        mRNA_transfections2(input$tv, input$wells, input$ng, input$por, input$ratio, input$dilution)

    })

})