# First load the data file then load the shiny seperately 

# A simple Machine Learning mode Predicting weather to Play Outside or not 
# based on weather condition

# Importing Libraries

library(shiny)
library(shinythemes)
library(data.table)
#library(RCurl)
library(randomForest)

# Step 1: Read the Trial set data from the CSV file kept in local 

# getwd()

data <- read.csv("data.csv",TRUE,",")
class(data)
head(data)

# Step 2: Fir Random Forest algorithm with the data 

#converted the Y variable to factor class

data$play <- as.factor(data$play)
data$outlook <- as.factor(data$outlook)


str(data) # command gave the data type of all the variable

model <- randomForest(play ~ ., data=data, ntree= 500, mtry= 4, importance=TRUE)

print(model)
plot(model)

# Step 3: Developing the user Interface for the Shiny Apps 

    ui <- fluidPage(
      theme = ("sandstone"),
      headerPanel("Football Today ?"),
      sidebarPanel(
        tags$h3("Input Parameters"),
        selectInput("outlook",label = "Select Weather:", 
                    choices = list("Sunny" = "sunny", "Rainy" = "rainy", "Overcast" = "overcast"),
                    selected = "Sunny"),
        sliderInput("temperature","Temperature",min = 20,max = 100, value = 70),
        sliderInput("humidity", "Humidity", min = 20, max = 100, value = 50),
        selectInput("windy","Is it Windy ?", choices = list("Yes" = "True", "No" = "False"),selected = "Yes"),
        actionButton("submitbutton", "Submit", class = "btn btn-primary")
        
      ),#sidebar Panel
      
      mainPanel(
         tags$label(h3("Status Of the Model")),
         verbatimTextOutput("contents"),
         tableOutput("resulttable")
      
      )#main panel
      
    )#Fluid page
    
    
    # Step 4 : Defining server for the web page 
    
    server <- function(input,output,session){
      
      inputdata <- reactive({
        
        df <- data.frame(
          Name = c("outlook", "temperature", "humidity", "windy"),
          Value = as.character(c(input$outlook, input$temperature, input$humidity, input$windy)),
          stringsAsFactors = FALSE
        )
       play <- "play"
       df <- rbind(df,play)
        input <- transpose(df)
        write.table(input,"input.csv", sep = ",", quote = FALSE, row.name = FALSE, col.name = FALSE)
        test <- read.csv(paste("input",".csv", sep = ""),TRUE)
        test$outlook <- factor(test$outlook, levels = c("overcast", "rainy", "sunny"))
        
        Output <- data.frame(Prediction = predict(model,test),round((predict(model,test,type = "prob")), 3))
        print(Output)
      })
      
      #status of model output
      output$contents <- renderPrint({
        
        if(input$submitbutton>0){
          isolate("Calculation Compleated")
        }else{
          return("Server Ready For Calculation")
        }
      })
      
      #Output Table From Model
      
      output$resulttable <- renderTable({
        if(input$submitbutton>0){
          isolate(inputdata())
        }
        
      })
      
    }#Server
    
    #Step 5: Shiny App
    
    shinyApp(ui = ui, server = server)
