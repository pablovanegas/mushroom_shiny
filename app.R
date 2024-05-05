# Import libraries
library(shiny)
library(data.table)
library(randomForest)

# Read in the RF model
model <- readRDS("model.rds")

# Training set
TrainSet <- read.csv("training.csv", header = TRUE)
TrainSet <- TrainSet[,-1]

ui <- fluidPage(
  # Page header
  headerPanel('Mushroom Predictor'),
  
  # Input values
  sidebarPanel(
    HTML("<h3>Input parameters</h4>"),
    
    numericInput('cap.diameter', label = 'cap diameter', value = 1461),
    
    
    sliderInput("cap.shape", label = "cap shape", value = 2,
                min = min(TrainSet$cap.shape),
                max = max(TrainSet$cap.shape)
    ),
    sliderInput("gill.attachment", label = "gill attachment", value = 2,
                min = min(TrainSet$gill.attachment),
                max = max(TrainSet$gill.attachment)),
    sliderInput("gill.color", label = "gill color", value = 10,
                min = min(TrainSet$gill.color),
                max = max(TrainSet$gill.color)),
    
    numericInput('stem.height', label = 'stem height', value = 3.80746675),
    
    numericInput('stem.width', label = 'stem width', value = 1557),
    
    
    sliderInput("stem.color", label = "stem color", value = 11,
                min = min(TrainSet$stem.color),
                max = max(TrainSet$stem.color)),
    
    numericInput('season', label = 'season', value = 1.8042727),
    actionButton("submitbutton", "Submit", class = "btn btn-primary")),
  
  mainPanel(
    tags$label(h3('Status/Output')), # Status/Output Text Box
    verbatimTextOutput('contents'),
    tableOutput('tabledata') # Prediction results table
  )
)



server <- function(input, output, session) {
  
  datasetInput <- reactive({  
    
    df <- data.frame(
      Name = c("cap diameter",
               "cap shape",
               "gill attachment",
               "gill color",
               'stem height',
               "stem width",
               "stem color",
               'season'),
      Value = c(input$cap.diameter,
                input$cap.shape,
                input$gill.attachment,
                input$gill.color,
                input$stem.height,
                input$stem.width,
                input$stem.color,
                input$season),
      stringsAsFactors = FALSE)
    
    df$cap.shape <- factor(df$cap.shape)
    df$cap.shape <- factor(df$cap.shape, levels = levels(TrainSet$cap.shape))
    dfgill.attachment <- factor(df$gill.attachment)
    df$gill.attachment <- factor(df$gill.attachment, levels = levels(TrainSet$gill.attachment))
    df$gill.color <- factor(df$gill.color)
    df$gill.color <- factor(df$gill.color, levels = levels(TrainSet$gill.color))
    df$stem.color <- factor(df$stem.color)
    df$stem.color <- factor(df$stem.color, levels = levels(TrainSet$stem.color))
    
    
    clase <- 0
    df <- rbind(df, clase)
    input <- transpose(df)
    write.table(input,"input.csv", sep=",", quote = FALSE, row.names = FALSE, col.names = FALSE)
    
    test <- read.csv(paste("input", ".csv", sep=""), header = TRUE)
    
    Output <- data.frame(Prediction=predict(model,test), round(predict(model,test,type="prob"), 3))
    print(Output)
    
  })
  
  # Status/Output Text Box
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Calculation complete.") 
    } else {
      return("Server is ready for calculation.")
    }
  })
  
  # Prediction results table
  output$tabledata <- renderTable({
    if (input$submitbutton>0) { 
      isolate(datasetInput()) 
    } 
  })
}

shinyApp(ui = ui, server = server)