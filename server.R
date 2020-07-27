library(shiny)
library(ggplot2)
library(caret)
library(lattice)
library(randomForest)
library(e1071)

data(mtcars)
mdata <- mtcars
mdata$am <- factor(mdata$am, labels = c("Automatic", "Manual"))
set.seed(7826)
inTrain <- createDataPartition(mdata$am, p = 0.7, list = FALSE)
train <- mdata[inTrain, ]
valid <- mdata[-inTrain, ]

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    k <- reactive({
        k <- input$kfoldn
    })

    formulaText <- reactive({
        if(length(input$checkGroup) > 0){
            paste("am ~", paste(input$checkGroup, collapse = " + "), collapse = " ")
        } else {
            paste("am ~", "mpg", collapse = " ")
        }
    })

    fit_model <- reactive({
        control <- trainControl(method = "cv", number = k())
            train(as.formula(formulaText()),
              data = train,
              method = "rf",
              trControl = control)
    })

    predict_rf <- reactive({
        predict_rf <- predict(results, valid)
        conf_rf <- confusionMatrix(valid$cyl, predict_rf)
        print(conf_rf)
    })

    observeEvent(input$do,{

        removeUI({
            selector = "div#welcome"
            }
        )

        results <- fit_model()
        predict_rf <- predict(results, valid)
        conf_rf <- confusionMatrix(valid$am, predict_rf)

        if (results$method == 'rf')
            output$fitmethod <- renderText("Random Forest")
        output$methodHeadings <- renderUI({
            h4("Training Method:")
        })
        output$methodControls <- renderUI({
            textOutput("fitmethod")
        })

        output$coeffs <- renderText(input$checkGroup)
        output$coeffsHeadings <- renderUI({
            h4("Predictors used for Training:")
        })
        output$coeffsControls <- renderUI({
            textOutput("coeffs")
        })

        output$fitresult <-renderTable(results$results)
        output$fitHeadings <- renderUI({
            h4("Results from Training:")
        })
        output$fitControls <- renderUI({
            tableOutput("fitresult")
        })

        output$predtable <-renderTable(conf_rf$table)
        output$predHeadings <- renderUI({
            h4("Results from Predictions on validation data:")
        })
        output$predControls <- renderUI({
            tableOutput("predtable")
        })

        output$byclass <-renderPrint(conf_rf$byClass)
        output$classHeadings <- renderUI({
            h4("Predictions on Validation data: By Class:")
        })
        output$classControls <- renderUI({
            textOutput("byclass")
        })

    })

})
