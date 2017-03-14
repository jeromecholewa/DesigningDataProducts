#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    withMathJax(),
    titlePanel("Display the distribution of estimation of the mean"),
    sidebarLayout(
        sidebarPanel(
            h6("HELP:", br(), "- By setting the seed the sampling will be repeatable", br(),
               "- Click on the 2nd tab to see the distribution of the", br(),
               "estimated mean.", br(),
               "- The number of bins for the histogram is a suggestion only.", br(),
               "- R might choose a more suitable number of bins", br(),
               "- The number of bins will affect only the first tab"),
            radioButtons("dist", "Distribution type:",
                         c("Normal" = "norm",
                           "Uniform" = "unif",
                           "Poisson" = "poisson"), inline = TRUE
            ),
            numericInput("seed", "Choose the seed", 40),
            sliderInput("sampleSize", "Choose the sample size",
                        5, 1000, value = 300),
            sliderInput("numBins", "Choose the number of bins",
                        3, 25, value = 10),
            checkboxInput("showModel1", "Show/Hide theoretical mean (RED)",
                          value = TRUE),
            checkboxInput("showModel2", "Show/Hide sample mean (BLUE)",
                          value = TRUE),
            #submitButton("Submit"),
            submitButton("Apply Changes!"),
            #actionButton("show", label  = "Re-run now!"),
            width = 4
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(type = "tabs",
                        tabPanel("Distribution plot", plotOutput("distPlot")),
                        tabPanel("Estimation of the mean",
                                 sliderInput("nosims", "Number of simulations to be run",
                                             2, 500, value = 100),
                                 plotOutput("distPlotError"), br(),
                                 h3("As the number of samples", em("n"), "increases the estimated", br(),
                                    " mean follows a normal distribution with a decreasing", br(),
                                    " standard deviation, called the standard error", br(),
                                    " of the mean whose value is $$\\frac{stdDev }{\\sqrt{n}}$$"
                                    )
                                 )
                        )
        )
    )
))
