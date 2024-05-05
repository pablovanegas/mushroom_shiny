library(shiny)
library(data.table)

model <- readRDS("model.rds")
TrainSet <- read.csv("training.csv", header = TRUE)
TrainSet <- TrainSet[,-1]


TrainSet$cap.shape <- as.factor(TrainSet$cap.shape)
TrainSet$gill.attachment <- as.factor(TrainSet$gill.attachment)
TrainSet$gill.color <- as.factor(TrainSet$gill.color)
TrainSet$stem.color <- as.factor(TrainSet$stem.color)



# ui.R
ui <- fluidPage(
  
  # Page header
  headerPanel('Mushroom Predictor'),
  
  # Input values
  sidebarPanel(
    HTML("<h3>Input parameters</h4>"),
    
    numericInput('cap.diameter', label = 'cap diameter', value = 1461),
    
    selectInput("cap.shape", label = "cap shape", choices = levels(TrainSet$cap.shape)),
    selectInput("gill.attachment", label = "gill attachment", choices = levels(TrainSet$gill.attachment)),
    selectInput("gill.color", label = "gill color", choices = levels(TrainSet$gill.color)),
    
    numericInput('stem.height', label = 'stem height', value = 3.80746675),
    numericInput('stem.width', label = 'stem width', value = 1557),
    
    selectInput("stem.color", label = "stem color", choices = levels(TrainSet$stem.color)),
    
    numericInput('season', label = 'season', value = 1.8042727),
    actionButton("submitbutton", "Submit", class = "btn btn-primary")),
  
  mainPanel(
    tags$label(h3('Status/Output')), # Status/Output Text Box
    verbatimTextOutput('contents'),
    tableOutput('tabledata') # Prediction results table
  )
)
shinyApp(ui = ui, server = server)
