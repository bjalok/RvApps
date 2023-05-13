#creating my first app in shiny

# Load the package in R

#install.packages("shiny")

library(shiny)
library(shinythemes)

# create a simple web application which takes text input and return text output

  # Defining the user interface: The job of user interface is to take take input from the user

 # User Interface 
#several theme can be selected through R via: https://rstudio.github.io/shinythemes/

  ui<- fluidPage(h1("Let's Type It"),theme = shinytheme("superhero"),
                 navbarPage("My First App",
                            tabPanel("Names",
                            sidebarPanel(
                              tags$h3("Input:"),
                              textInput("txt1","First Name:",""),
                              textInput("txt2","Last Name:","")
                              
                            ),#Sidebar panel
                        mainPanel( h1("Output"),
                                   verbatimTextOutput("txtout"),
                          
                        )#Mainpanel
                            ),#tabpanel   
                   tabPanel("SecondTab","Kept Empty"
                     
                   )
                 )#navbarpage
  
  

                 )#Fluid page
  
  
    #Defining Server
  
    server <- function(input,output) {
      output$txtout <- renderText({
        paste(input$txt1,input$txt2,sep=" ")
      })
    }
      #create shiny app
      shinyApp(ui=ui,server=server)
       