model <- readRDS("model.rds")
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