library(shiny)
library(magrittr)
library(knitr)
library(lattice)
library(DT)
library(V8)

source("storage.R")
source("helpers.R")

shinyServer(function(input, output, session) {
        # Give an initial value to the timestamp field
        updateTextInput(session, "timestamp", value = get_time_epoch())
        
        # Enable the Submit button when all mandatory fields are filled out
        observe({
                fields_filled <-
                        fields_mandatory %>%
                        sapply(function(x) !is.null(input[[x]]) && input[[x]] != "") %>%
                        all
                
                shinyjs::toggleState("submit", fields_filled)
        })
        
        # Gather all the form inputs
        form_data <- reactive({
                sapply(fields_all, function(x) x = input[[x]])
        })

        # When the Refresh button is clicked 
        observeEvent(input$refresh, {
                shinyjs::js$refresh()
        })
        # When the Back To Survey button is clicked 
        observeEvent(input$backSurvey, {
                shinyjs::js$refresh()
        })
        
        # When the Submit button is clicked 
        observeEvent(input$submit, {
                # Update the timestamp field to be the current time
                updateTextInput(session, "timestamp", value = get_time_epoch())
                
                # User-experience stuff
                shinyjs::disable("submit")
                shinyjs::show("submitMsg")
                shinyjs::hide("error")
                on.exit({
                        shinyjs::hide("submit")
                        shinyjs::hide("submitMsg")
                        shinyjs::hide("scope")
                        shinyjs::hide("scopeEstimateText")
                        shinyjs::show("resultScopeMsg")
                        shinyjs::hide("quality")
                        shinyjs::hide("qualityEstimateText")
                        shinyjs::show("resultQualityMsg")
                })
                
                # Save the data (show an error message in case of error)
                tryCatch({
                        save_data(form_data(), "s3")
                        all_data <- load_data_s3()
                        output$resultScope <- renderText({ mean(all_data$scope) })
                        output$countScope <- renderText({ paste("from", length(all_data$scope), "participants") })
                        output$resultQuality <- renderText({ mean(all_data$quality) })
                        output$countQuality <- renderText({ paste("from", length(all_data$quality), "participants") })
                },
                error = function(err) {
                        shinyjs::text("errorMsg", err$message)
                        shinyjs::show(id = "error", anim = TRUE, animType = "fade")      
                        shinyjs::logjs(err)
                })
        })
        
        # When the Show Analysis button is clicked 
        observeEvent(input$analyse, {
                # User-experience stuff
                shinyjs::disable("analyse")
                shinyjs::show("adminMsg")
                shinyjs::hide("info")
                on.exit({
                        shinyjs::hide("adminMsg")
                        shinyjs::enable("analyse")
                })

                # show survey analysis
                shinyjs::hide("mainPanel") 
                shinyjs::show("analysisPanel")
                actualScope <- input$actualScope
                actualQuality <- input$actualQuality
                all_data <- load_data_s3()
                filename <- "analysis.Rmd"
                content <- readChar(filename, file.info(filename)$size)
                output$analysisReport <- renderText({ knitr::knit2html(text = content, fragment.only = TRUE) })
        })
        
        # When the Reset Survey button is clicked 
        observeEvent(input$reset, {
                # User-experience stuff
                shinyjs::disable("reset")
                shinyjs::show("adminMsg")
                shinyjs::hide("info")
                on.exit({
                        shinyjs::hide("adminMsg")
                        shinyjs::enable("reset")
                })
                
                # reset survey
                count <- clear_data_s3()
                shinyjs::text("infoMsg", paste(count, "record(s) deleted"))
                shinyjs::show(id = "info", anim = TRUE, animType = "fade")      
        })
        
        # When the Populate Survey button is clicked 
        observeEvent(input$populate, {
                # User-experience stuff
                shinyjs::disable("populate")
                shinyjs::show("adminMsg")
                shinyjs::hide("info")
                on.exit({
                        shinyjs::hide("adminMsg")
                        shinyjs::enable("populate")
                })

                # re-populate survey
                count <- clear_data_s3()
                create_data_s3()
                shinyjs::text("infoMsg", paste(count, "record(s) deleted and 20 records created"))
                updateNumericInput(session, "actualScope", value=32)
                updateNumericInput(session, "actualQuality", value=7)
                shinyjs::show(id = "info", anim = TRUE, animType = "fade")      
        })
        
})