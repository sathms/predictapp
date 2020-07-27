library(shiny)

# Define UI for application that does a random forest prediction
shinyUI(fluidPage(

    # Application title
    titlePanel("A simple prediction app"),

    # Sidebar for user inputs...
    sidebarLayout(
        sidebarPanel(
            radioButtons("kfoldn",
                         "Number of K-folds:",
                         choices = list(
                             "Two"  = 2,
                             "Five"  = 5,
                             "Ten" = 10
                         ),
                         selected = 5
                         ),
            checkboxGroupInput("checkGroup",
                               label = h3("Select factors for prediction"),
                               choices = list("mpg" = "mpg",
                                              "cyl" = "cyl",
                                              "disp" = "disp",
                                              "hp" = "hp",
                                              "drat" = "drat",
                                              "wt" = "wt",
                                              "qsec" = "qsec",
                                              "vs"= "vs",
                                              "gear" = "gear",
                                              "carb"= "carb"),
                               selected = 1),
            actionButton("do", "Submit")
        ),

        mainPanel(

                tags$div(id="welcome", checked=NA,
                         tags$h3("Welcome to Random Forest Classifier Demo"),
                         tags$br(),
                         tags$li(tags$a(href="https://www.rdocumentation.org/packages/datasets/versions/3.6.2/topics/mtcars",
                                              "Data: Lets use mtcars")),
                         tags$li("We want to predict if a car is Manual or Automatic"),
                         tags$li("To build a model select inputs on the left side panel"),
                         tags$li("Input1: Pick a number for k-fold cross validation"),
                         tags$li("Input2: Select one or more predictors"),
                         tags$li("Press submit and review the results displayed"),
                         tags$li("The app splits the data 70:30 for training and validation"),
                         tags$li("The training data is fed through a Random Forest Classifier"),
                         tags$li("The validation data is then run through the above trained model"),
                         tags$li("The model is then evaluated for its accuracy"),
                         tags$li("Try different predictors and see if results change")
                         ),

                uiOutput("methodHeadings"),
                uiOutput("methodControls"),

                uiOutput("coeffsHeadings"),
                uiOutput("coeffsControls"),

                uiOutput("predHeadings"),
                uiOutput("predControls"),

                uiOutput("classHeadings"),
                uiOutput("classControls"),

                uiOutput("fitHeadings"),
                uiOutput("fitControls")
        )
    )
))
