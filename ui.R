

fluidPage(theme = shinytheme("simplex"),
          tags$script(HTML("document.body.style.backgroundColor = 'black';")),
          #style = 'border:4px double white',
          titlePanel( "Unemployment and Crime Rate in the US, 1976 - 2014"),
          sidebarLayout (
            
            sidebarPanel(
              
              #style = "border: 4px double red;",
              selectInput("year",label = "year",choices = state_unemploymentyearly$year)
              ),
          
            mainPanel(
              
              tabsetPanel(
                tabPanel("Unemployment Map", id = "tab1",
                         mainPanel(style = 'border:4px double brown;',
                                   plotlyOutput("usmapplot"))),
                
                tabPanel("States Historical Rate", id = "tab2",
                         selectInput("state", label = "state",
                                     choices = state_unemploymentyearly$state,
                                     selected =state_unemploymentyearly$state[1] ),
                         plotOutput("statelineplot")),
                
                tabPanel("Video", id = "tab3",style = 'border:4px double red;',"Time Serious Forcast on Criminal Activities in the US ", uiOutput("frame")),
                tabPanel("compare variables", id = "tab4",
                         style = 'border:4px double red;',
                         selectInput("crime", label = "Crime type",
                                     choices = c("Murder and nonnegligent Manslaughter", "Legacy rape /1", "Robbery","Aggravated assault",
                                                 "Larceny-theft","vehicle_theft", "property_total","Burglary","violent_total"),
                                     selected = 'property_total'),
                                     plotlyOutput('crimecompare')
                         ))
              )))
