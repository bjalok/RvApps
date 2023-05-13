#Creating Interactive Histogram Via R Shiny

library(shiny)
data(airquality)

# Defining User interface 

   ui<- fluidPage(
     titlePanel("Histogram For Air Quality Index"),
     sidebarLayout(
       sidebarPanel (
         sliderInput(
           inputId = "bin",
           label = "Number of Bins",
           min = 0,
           max = 100,
           value = 50,
           step = 5)),
         #slider input
         mainPanel(
            plotOutput(outputId = "graph")
         )#main panel
      
     )#sidebar layout
   )#fluid page
   
   
   # Defining Server for the App
   
   server <-  function(input,output){
     output$graph <- renderPlot({
       x <- airquality$Ozone
       x <- na.omit(x)
       bin <- seq(min(x),max(x),length.out = input$bin+1)
       
       hist(x,breaks = bin, col="#75AADB",border="black",
            xlab="AirQuality",main="Histogram for AirQuality")
       
     
       
     })#render plot
   }
   
   # Defining Shiny App
   
   shinyApp(ui=ui,server=server)
   