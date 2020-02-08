
url1 <- "https://twitter.com/intent/tweet?text=Check%out%this%awesome%shiny%app%by%@LydiaVasil%20world&url=https://lydiavasilyeva.shinyapps.io/Crime_Explorer/"

url2<- "https://twitter.com/LydiaVasil?ref_src=twsrc%5Etfw"
shinyUI(
  fluidPage(
    theme = shinythemes::shinytheme('cerulean'),
    tags$script(HTML("document.body.style.backgroundColor = 'black';")),
    style = 'border:4px double white',
    titlePanel( h1("Unemployment and Crime Rate in the United States  1976 - 2014 ", align='center') )
    ,
    dashboardPage(
      skin = 'yellow',
      
      dashboardHeader(title ='Crime Explorer'),
      dashboardSidebar( 
      width = 310,
        
     sidebarMenu( width=10,
       sidebarUserPanel(name = 'Lydia Vasilyeva'),
          div(style='display:inline-block;',
          actionLink("twitter_share",
                       label = "Follow",style = 'border:4px double white',
                       class="twitter-follow-button",
                       src="https://platform.twitter.com/widgets.js",
                       icon = icon("twitter"),
                       onclick = sprintf("window.open('%s')", url2),
                       align='left')
          ),
        
          div(style='display:inline-block;',
          actionLink("twitter_share",
                       label = "Share",style = 'border:4px double white',
                       icon = icon("twitter"),
                       onclick = sprintf("window.open('%s')", url1),
                       align='left')),
          
          div(style='display:inline-block;',
          actionLink(inputId='ab1', label="GitHub",style = 'border:4px double white', 
                     icon = icon("github"), 
                     onclick ="window.open('https://github.com/lydiavasil', '_blank')")),
          
          div(style='display:inline-block;',
          actionLink(inputId='lnkd', label="Linkedin",style = 'border:4px double white', 
                     icon = icon("linkedin"), 
                     onclick ="window.open('https://www.linkedin.com/in/lydiavasil/', '_blank')")),
          
          style = 'border:4px double black',
         
          br(),
          
          menuItem('Correlation', tabName = 'corrstate', icon = icon('database')),
          menuItem('Trend', tabName = 'crimetype', icon = icon('database')),
          menuItem('Nashville', tabName = 'nashville', icon = icon('database')),
          menuItem('Data Sources', tabName = 'data', icon = icon('database')),
          menuItem('Previous work', tabName = 'citation', icon = icon('database'))
          
        )),
      dashboardBody(
        style = 'border:4px double white',
       skin = 'yellow',
        tabItems(
          tabItem(tabName = 'corrstate',
                  title = '', status = 'warning', solidHeader = TRUE, width=3,
                  h3('Correlation based on the Entire Dataset'),
                  fluidRow(
                    box(title="Crime unemployment correlation map ", status = "warning", 
                        solidHeader = T,  plotOutput('usmapplot1', height=325)),
                    box(title="Crime unemployment correlation graph ",  status = "warning", 
                        solidHeader = T,  plotOutput('uscorrplot', height=325))
                  ),
                  br(),
                  fluidRow(
                    box(title="Correlation by Level of Unemployment Rate ", status = "warning", 
                        solidHeader = T, width = 700  , height=50),
                        selectInput('level', label = 'Select Unemployment Rate', choices = c(3:8), selected = 7), align='center'),
          
                br(),
                br(),
                  fluidRow(
                    box(title="Unemployment Level Above the Selected Rate", status = "warning",
                        solidHeader = T,  plotOutput('increasinglevel', height=325)),
                    
                    
                    box(title="Unemployment Level Below the Selected Rate", status = "warning", 
                        solidHeader = T,  plotOutput('decreasinglevel', height=325))
                    ))
          , #close corrstate 
          
          
          
          
            tabItem(tabName = 'crimetype',
                    title = '', status = 'warning', solidHeader = TRUE, width=3,
                    h3('Yearly Trend by Crime Type'),
                    tabsetPanel(
                      tabPanel("Violent Crime", id = "tab1",
                               
                               fluidRow(
                                 br(),
                                 box(title="Individual State Vs. National Violent Crime Trends ", status = "warning", 
                                     solidHeader = T, width = 700  , height=50),
  
                                 selectInput("state", label = "Select a State :",
                                             choices = d$state,
                                             selected =d$state[1] )),
                               
                               fluidRow(
                                 box(title="State Yearly Violent Crime Trend ", status = "warning", 
                                     solidHeader = T,  plotOutput('statecrime', height=325)),
                                 box(title="Nation Yearly Violent Crime Trend ",  status = "warning", 
                                     solidHeader = T,  plotOutput('uscrime', height=325))
                               )),
                      tabPanel("Property Crime", id = "tab2",
                               
                               fluidRow(
                                 box(title="Individual State Vs. National Property Crime Trends ", status = "warning", 
                                     solidHeader = T, width = 700  , height=50),
                                 
                                 selectInput("state", label = "state",
                                             choices = d$state,
                                             selected =d$state[1] )),
                               
                               fluidRow(
                                 box(title="State Yearly Property Crime Trend ", status = "warning", 
                                     solidHeader = T,  plotOutput('statecrime', height=325)),
                                 box(title="Nation Yearly Property Crime Trend ",  status = "warning", 
                                     solidHeader = T,  plotOutput('uscrime', height=325))
                               )),
                      
                      tabPanel("Murder", id = "tab3",
                               
                               fluidRow(
                                 box(title="Individual State Vs. National Murder Trends ", status = "warning", 
                                     solidHeader = T, width = 700  , height=50),
                                 
                                 selectInput("state", label = "state",
                                             choices = d$state,
                                             selected =d$state[1] )),
                               
                               fluidRow(
                                 box(title="State Yearly Murder Trend ", status = "warning", 
                                     solidHeader = T,  plotOutput('statecrime', height=325)),
                                 box(title="Nation Yearly Murder Trend ",  status = "warning", 
                                     solidHeader = T,  plotOutput('uscrime', height=325))
                               )),
                      tabPanel("rape", id = "tab4",
                               
                               fluidRow(
                                 box(title="Individual State Vs. National Rape Trends ", status = "warning", 
                                     solidHeader = T, width = 700  , height=50),
                                 
                                 selectInput("state", label = "state",
                                             choices = d$state,
                                             selected =d$state[1] )),
                               
                               fluidRow(
                                 box(title="State Yearly Rape Trend ", status = "warning", 
                                     solidHeader = T,  plotOutput('statecrime', height=325)),
                                 box(title="Nation Yearly Rape Trend ",  status = "warning", 
                                     solidHeader = T,  plotOutput('uscrime', height=325))
                               )),
                      tabPanel("Robbery", id = "tab5",
                               
                               fluidRow(
                                 box(title="Individual State Vs. National Crime Trends ", status = "warning", 
                                     solidHeader = T, width = 700  , height=50),
                                 
                                 selectInput("state", label = "state",
                                             choices = d$state,
                                             selected =d$state[1] )),
                               
                               fluidRow(
                                 box(title="State Yearly Robbery Trend ", status = "warning", 
                                     solidHeader = T,  plotOutput('statecrime', height=325)),
                                 box(title="Nation Yearly Robbery Trend ",  status = "warning", 
                                     solidHeader = T,  plotOutput('uscrime', height=325))
                               )),
                      tabPanel("Bulglary", id = "tab6",
                               
                               fluidRow(
                                 box(title="Individual State Vs. National Bulglary Trends ", status = "warning", 
                                     solidHeader = T, width = 700  , height=50),
                                 
                                 selectInput("state", label = "state",
                                             choices = d$state,
                                             selected =d$state[1] )),
                               
                               fluidRow(
                                 box(title="State Yearly Bulglary Trend ", status = "warning", 
                                     solidHeader = T,  plotOutput('statecrime', height=325)),
                                 box(title="Nation Yearly Bulgary Trend ",  status = "warning", 
                                     solidHeader = T,  plotOutput('uscrime', height=325))
                               )),
                      tabPanel("Larceny", id = "tab7",
                               
                               fluidRow(
                                 box(title="Individual State Vs. National Larceny Trends ", status = "warning", 
                                     solidHeader = T, width = 700  , height=50),
                                 
                                 selectInput("state", label = "state",
                                             choices = d$state,
                                             selected =d$state[1] )),
                               
                               fluidRow(
                                 box(title="State Yearly Larceny Trend ", status = "warning", 
                                     solidHeader = T,  plotOutput('statecrime', height=325)),
                                 box(title="Nation Yearly Larceny Trend ",  status = "warning", 
                                     solidHeader = T,  plotOutput('uscrime', height=325))
                               )),
                      tabPanel("Assault", id = "tab8",
                               
                               fluidRow(
                                 box(title="Individual State Vs. National Assault Trends ", status = "warning", 
                                     solidHeader = T, width = 700  , height=50),
                                 
                                 selectInput("state", label = "state",
                                             choices = d$state,
                                             selected =d$state[1] )),
                               
                               fluidRow(
                                 box(title="State Yearly Assault Trend ", status = "warning", 
                                     solidHeader = T,  plotOutput('statecrime', height=325)),
                                 box(title="Nation Yearly Assault Trend ",  status = "warning", 
                                     solidHeader = T,  plotOutput('uscrime', height=325))
                               )),
                      tabPanel("Vehicle_theft", id = "tab9",
                               
                               fluidRow(
                                 box(title="Individual State Vs. National Vehicle Theft Trends ", status = "warning", 
                                     solidHeader = T, width = 700  , height=50),
                                 
                                 selectInput("state", label = "state",
                                             choices = d$state,
                                             selected =d$state[1] )),
                               
                               fluidRow(
                                 box(title="State Yearly Vehicle Theft Trend ", status = "warning", 
                                     solidHeader = T,  plotOutput('statecrime', height=325)),
                                 box(title="Nation Yearly Vehicle Theft Trend ",  status = "warning", 
                                     solidHeader = T,  plotOutput('uscrime', height=325))
                               ))
                      )),
                             
               
                      
                      
                      
          tabItem(tabName = 'data',
                  title = 'Data', status = 'warning', solidHeader = TRUE, width=3,
                  h3('The Datasets are Obtained from the Following Data Sources', style = 'border:4px double white'),
                  br(),
                  fbi <- a('U.S Department of Justice', href= "https://www.ucrdatatool.gov/Search/Crime/State/StatebyState.cfm", target = "_blank"),
                  br(),
                  deptoflabor <- a('US Department of Labor and Statistics', href= "https://beta.bls.gov/dataQuery/find?st=0&r=100&s=popularity%3AD&q=unemployment&more=0&fq=cg:%5bGeography%5d", target = "_blank"),
                  br(),
                  nashvillepolice <- a('Nashville Open Data Portal', href= "https://data.nashville.gov/", target = "_blank")
                  
          ), #close data
          tabItem(tabName = 'citation',
                  title = '', status = 'warning', solidHeader = TRUE, width=3,
                  h3('Work Cited', style = 'border:4px double white'),
                  br(),
                  br(),
                  "https://www.ucrdatatool.gov/Search/Crime/State/StatebyState.cfm",
              
                  
          )#close citation
          
          
        ) #close tabItems
      ) #close dashboardBody
    ) #close dashboardPage
  ) #close fluidPage
) #close shinyUI

