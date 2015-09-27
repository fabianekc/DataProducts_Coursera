library(shiny)

shinyUI(fluidPage(
        title = "Crowd Intelligence",
        shinyjs::useShinyjs(),
        shinyjs::extendShinyjs(text = "shinyjs.refresh = function() { location.reload(); }"),
        tags$head(includeCSS(file.path("www", "app.css"))),
        
        div(
                id = "titlePanel",
                "Crowd Intelligence"
        ),
        br(),
        p("This web app demonstrates the", strong("Wisdom of the Crowd"), "-",
          a("click here for more information (slidify presentation).", href="https://fabianekc.github.io/DataProducts_Coursera/slidify/index.html"),
          br(),
          "It was developed for the",
          em("Developing Data Products"),
          "class as part of the",
          em("Coursera Data Science Specialization.")),
        p(em(strong("Scenario:")), "Assume there is a team of about 20 people working on a software",
          "product, and as the responsible manager you need to create a",
          "roadmap and assign resources. Instead of",
          "estimating", em("Scope"), "and", em("Quality"), "yourself,",
          "you can ask your team. This will lead to a much better prediction quality!"),
        # Enter actual results
        fluidRow(
                column(4, wellPanel(
                        title = "Admin Panel", id = "leftPanel", style = "padding:19px",
                        strong("2"), strong(tags$sup("nd")), strong("Step: Admin Area"),
                        br(),
                        "Enter actual results here when they become available.",
                        br(),
                        br(),
                        div(id = "analysisForm",
                            numericInput('actualScope', 'Features completed:', NA, min = 0, max = 90, step = 1),
                            br(),
                            numericInput('actualQuality', 'Bugs reported:', NA, min = 0, max = 1000, step = 1),
                            actionButton("analyse", "Show Analysis", class = "btn-success"),
                            actionButton("reset", "Reset Survey", class = "btn-danger"), br(), br(),
                            actionButton("populate", "Populate Survey with Demo Data", class = "btn-info"), br(),
                            shinyjs::hidden(
                                    span(id = "adminMsg", br(), "working... (please be patient)", style = "margin-left: 15px")
                            )
                            
                        ),
                       shinyjs::hidden(
                                div(id = "info",
                                    div(br(), tags$b("Info: "), span(id = "infoMsg")),
                                    style = "color: green;"
                                )
                        )        
                )),
                
                column(8, wellPanel(
                        title = "Submit form", id = "mainPanel", 
                        strong("1"), strong(tags$sup("st")), strong("Step: Participant Area"),
                        br(),
                        "All participants are asked to provide forecasts in the following areas:",
                        br(),br(),
                        div(id = "form",
                            numericInput('scope', 'Scope', 0, min = 0, max = 90, step = 1),
                            div(id='scopeEstimateText', "Estimate the number of new features completed until the next milestone."),
                            shinyjs::hidden(
                                span(id = "resultScopeMsg", 
                                     strong("Average estimation of new features:"),
                                     verbatimTextOutput("resultScope"),
                                     textOutput("countScope"))
                            ),
                            br(),br(),
                            numericInput('quality', 'Quality', 0, min = 0, step = 1),
                            div(id='qualityEstimateText', "Estimate the number of reported critical bugs in the first month."),
                            shinyjs::hidden(
                                    span(id = "resultQualityMsg", 
                                         strong("Average estimation of quality:"),
                                         verbatimTextOutput("resultQuality"),
                                         textOutput("countQuality"))
                            ),
                            br(),br(),
                            actionButton("submit", "Submit", class = "btn-primary"),
                            actionButton("refresh", "Refresh Page", class = "btn"),
                            shinyjs::hidden(
                                   span(id = "submitMsg", "Submitting... (this can take up to one minute)", style = "margin-left: 15px;")
                             )
                        ),
                        shinyjs::hidden(
                                div(id = "error",
                                    div(br(), tags$b("Error: "), span(id = "errorMsg")),
                                    style = "color: red;"
                                )
                        ),          
                        
                        # hidden input field tracking the timestamp of the submission
                        shinyjs::hidden(textInput("timestamp", ""))
                        ),
                       shinyjs::hidden(wellPanel(
                               id="analysisPanel",
                               htmlOutput("analysisReport"), br(),
                               actionButton("backSurvey", "Back to Survey", class = "btn")
                       ))
                )
        ),
        fluidRow(column(12,
                p(em(strong("Usage:"))), 
                tags$ul(
                        tags$li("To get a quick impression how this app works first click 'Populate Survey with Demo Data' and afterwards 'Show Analysis' in the Admin Area. This will simulate 20 responses to this survey and you will see a statistical analysis of the survey results. - This should be enough for grading this course project. However, if you are curious read on!"),br(),
                        tags$li("If you want to experiment with the survey enter a prediction in the Participant Area and click 'Submit'. After submitting you will immediately see the average response of all participants so far. If you want to submit multiple predictions you need to click 'Refresh Page' after a submission to reset the input form."),
                        tags$li("With some predictions entered you can show an initial analysis by clicking 'Show Analysis' in the Admin Area. Note, that you don't need to provide the actual result!"),
                        tags$li("In a real world scenario you would use this app again some time later when actual results for the predictions are available. Enter those actual results in the Admin Area and click again 'Show Analysis'."),
                        tags$li("If you want to start over and delete all data just click 'Reset Survey' in the Admin Area.")
                ),
                p(em(strong("Some further notes (shortcomings of this implementation):"))), 
                tags$ul(
                        tags$li("the Participants Area and the Admin Area should be separate web pages to avoid that anyone can delete all data"),
                        tags$li("this app does not include any mechanisms to avoid multiple predictions by a single person - it would be easily possible to cook the results!"),
                        tags$li("for simplicity only 2 questions are asked here; in a real team setting multiple questions should be asked and a statistical analysis would include relations between the forecasts"),
                        tags$li("for team forecasts it is most relevant to identify trends - an aspect that is also not covered in this little demo"),
                        tags$li("the actual result is only shown in the box plot if it is within the limits of available predictions")
                ),
                p(strong("Disclaimer:"), "Forecasting is my hobby and I a more mature implementation is available on", a("https://CrowdStatus.net", href="https://www.crowdstatus.net"), "- if you want to try this out with your team contact me: christoph.fabianek _at_ gmail.com :-)")
        ))
))