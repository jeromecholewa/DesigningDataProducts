#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    output$distPlot <- renderPlot({
        input$show
        set.seed(input$seed )
        dist <- switch(input$dist, poisson = rpois,
                       norm = rnorm,
                       unif = runif,
                       rnorm)
        averages_distr <- c(0, 0.5)
        if (input$dist == "poisson") {
            distr <- dist(input$sampleSize, lambda = 5)
            mainTitle = "Poisson Distribution Lambda = 5"
            averages_distr <-  reactive ({
                c(5, mean(distr))
            })
        }
        else if (input$dist == "norm") {
            distr <-dist(input$sampleSize)
            mainTitle = "Normal distribution (Mean 0, Std = 1)"
            averages_distr <-  reactive ({
                c(0, mean(distr))
            })
        }
        else {
            distr <- dist(input$sampleSize)
            mainTitle = "Uniform distribution (min = 0, max = 1)"
            averages_distr <-  reactive ({
                c(.5, mean(distr))
            })
        }
        hist(distr, xlab = "Values", main = mainTitle,
             breaks = input$numBins, freq = FALSE)
        if(input$showModel1){
            abline(v = averages_distr()[1], col = "red", lwd = 2)
        }
        if(input$showModel2){
            abline(v = averages_distr()[2] , col = "blue", lwd = 2)
        }

    })

    output$distPlotError <- renderPlot({
        input$show
        set.seed(input$seed )
        nosim <- input$nosims
        # simulate data for sample size 1 to 4 dat <- data.frame(
        sampleSize <- input$sampleSize
        dist <- switch(input$dist, poisson = rpois,
                       norm = rnorm,
                       unif = runif,
                       rnorm)
        averages <- c(0, 0.5)
        if (input$dist == "poisson") {
            dat <- apply(matrix(rpois( nosim * sampleSize, lambda = 5), nosim), 1, mean)
            averages <-  reactive ({
                c(5, mean(dat))
            })
            mainTitle = "Estimated Mean of the Poisson Distribution Lambda = 5"
            xlimits <- c(3.5, 6.5)
        }
        else if (input$dist == "norm") {
            dat <- apply(matrix(rnorm( nosim * sampleSize), nosim), 1, mean)
            averages <-  reactive ({
                c(0, mean(dat))
            })
            mainTitle = "Estimated Mean of the Normal distribution (Mean 0, Std = 1)"
            xlimits <- c(-1, 1)
        }
        else {
            dat <- apply(matrix(runif( nosim * sampleSize), nosim), 1, mean)
            averages <-  reactive ({
                c(.5, mean(dat))
            })
            mainTitle = "Estimated Mean of the Uniform distribution (min = 0, max = 1)"
            xlimits <-  c(0, 1)
        }
        hist(dat, breaks = 20, freq = FALSE, xlim = xlimits, main = mainTitle, xlab = "Values")
        if(input$showModel1){
            abline(v = averages()[1], col = "red", lwd = 2)
        }
        if(input$showModel2){
            abline(v = averages()[2] , col = "blue", lwd = 2)
        }

    })


    # model1pred <- reactive({
    #         mpgInput <- input$sliderMPG
    #         predict(model1, newdata = data.frame(mpg = mpgInput))
    # })
    #
    #         if(input$showModel1){
    #                 abline(model1, col = "red", lwd = 2)
    #         }
    #         if(input$showModel2){
    #                 model2lines <- predict(model2, newdata = data.frame(
    #                         mpg = 10:35, mpgsp = ifelse(10:35 - 20 > 0,
    #                                                     10:35 - 20, 0)
    #                 ))
    #                 lines(10:35, model2lines, col = "blue", lwd = 2)
    #         }
    # output$pred2 <- renderText({
    #         model2pred()
    # })
})
