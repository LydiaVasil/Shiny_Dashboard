
shinyServer(function(input, output) {
  
  # output$first_box <- renderInfoBox({
  #   statedf <- d %>% 
  #     filter(state == input$state) %>%
  #     select(statedf)
  #   if (statedf == TRUE) {
  #     boxInput <- c('expanded', 'green','thumbs-up')
  #   } else {
  #     boxInput <- c('did not expand', 'red', 'thumbs-down')
  #   }
  #   infoBox(input$state , paste0(boxInput[1],'statedf.'),
  #           color = boxInput[2],
  #           icon = icon(boxInput[3])
  #   )
  # })
  # 
  output$usmapplot1 <- renderPlot({
 
    
    plot_usmap(data = d, values = "corr") + 
      scale_fill_continuous(low = "white", high = "red", name = "Correlation of \n Violent Crime and \n Unemployment ", 
                            label = scales::comma) + 
      theme(legend.position = "right", legend.key.size = unit(1.75, "cm"), 
            legend.text = element_text(size = 14, face = 'bold'), legend.title=element_text(size=16, face = 'bold'))
  })
  
  output$usmapplot <- renderPlot({
    plot_usmap(data = d, values = "corr", color = "red") + 
      labs(title = " ")+
      scale_fill_continuous(low = "white", high = "red",name = "Unemployment vs. Crime \n Correlation", label = scales::comma) + 
      theme(legend.position = "right")
  })
  
  
  output$statelineplot<- renderPlot({
    
    data <- stateunemployment %>% 
      filter(state == input$state)
    ggplot(data=data, aes(x=year, y=value, group=1)) + geom_line(color='red') + geom_point()
    
  })
  
  output$yearlylineplot<- renderPlot({
    
    data <- stateunemployment %>% 
      filter(year == input$year)
    ggplot(data=data, aes(x=year, y=value, group=1)) + geom_line(color='red') + geom_point()
    
  })
  
  output$frame <- renderUI({
    HTML(paste0('<iframe width="280" height="157" src="https://www.youtube.com/embed/P5OYZ65sozw?rel=0" frameborder="0"  encrypted-media; 
        gyroscope; picture-in-picture" allowfullscreen></iframe>'))
  })
  output$datayearly <- renderDataTable(
    mytable <- crimedf %>% filter(year==input$year),
    print(mytable)
  )
  
  
  output$crimecompare <- renderPlot ({
    
    data <- crimedf %>% 
      subset(select = cbind(year,unemployment,input$crimes) ) %>% 
      gather(key = "variable", value = "value", -year)
    ggplot(data, aes(x = year, y = value)) + 
      geom_line(aes(color = variable), size = 1) +
      scale_color_manual(values = c("#00AFBB", "#E7B800" )) +
      theme_minimal()
    
  })
  output$crimeplot<- renderPlot({
    
    data <- crimedf %>% 
      subset(select = cbind(year,unemployment,input$state) ) %>% 
      gather(key = "variable", value = "value", -year)
    
    ggplot(data, aes(x = year, y = value)) + 
      geom_line(aes(color = variable), size = 1) +
      scale_color_manual(values = c("#00AFBB", "#E7B800", "#FC4E07")) +
      theme_minimal()
  })
  
  
  
  observeEvent(input$show, {
    showModal(modalDialog(return(includeHTML('crimeNashville.html'))))
  })
  
  
  
  
  output$uscorrplot <- renderPlot({
    d1<-d%>% filter(corr< -0.4) 
    ggplot(d1, aes(x = corr, y = state, color = corr)) +
      geom_point(size = 4) +
      geom_segment(aes(xend = max(corr), yend = state), size = 2)
  })
  
  
  
  
  
  output$increasinglevel<- renderPlot({
    
    
    highleveldf<- crimedf %>% filter(unemployment>input$level)
    
    tempdata<-highleveldf %>% 
      subset(select = c(year,unemployment,`violent_total`, `property_total`) )%>%
      group_by(year)%>%
      mutate(`violent_total` = mean(`violent_total`),
             unemployment= mean(unemployment)*1000,
             `property_total`=mean(`property_total`)
      )
    tempdata<-unique(tempdata)%>%
      gather(key = "variable", value = "value", -year)
    ggplot(tempdata,aes(x=year, y=value)) +
      geom_line(aes(color = variable), size = 1) +
      ggtitle("High Unemployment Rate Dataset") +
      xlab("value") +
      ylab("year") +
      theme(plot.title = element_text(color="darkred",
                                      size=18,hjust = 0.5),
            axis.text.y = element_text(size=12),
            axis.text.x = element_text(size=12,hjust=.5),
            axis.title.x = element_text(size=14),
            axis.title.y = element_text(size=14))
    
    
  })
  
  output$decreasinglevel<- renderPlot({
    
    lowleveldf <- crimedf %>% filter(unemployment<input$level)
    
    
    tempdata<-lowleveldf %>% 
      subset(select = c(year,unemployment,`violent_total`, `property_total`) )%>%
      group_by(year)%>%
      mutate(`violent_total` = mean(`violent_total`),
             unemployment= mean(unemployment)*1000,
             `property_total`=mean(`property_total`)
      )
    tempdata<-unique(tempdata)%>%
      gather(key = "variable", value = "value", -year)
    ggplot(tempdata,aes(x=year, y=value)) +
      geom_line(aes(color = variable), size = 1) +
      ggtitle("Low Unemployment Rate Dataset") +
      xlab("value") +
      ylab("year") +
      theme(plot.title = element_text(color="darkred",
                                      size=18,hjust = 0.5),
            axis.text.y = element_text(size=12),
            axis.text.x = element_text(size=12,hjust=.5),
            axis.title.x = element_text(size=14),
            axis.title.y = element_text(size=14))
    
    
  })
  #crime type graphs
  
  output$statecrime<- renderPlot({
  
  data <- crimedf %>% 
    filter(state ==input$state)%>%
    select(year,unemployment,violent_total)
  
  ggplot(data, aes(x=year, y=violent_total)) + geom_line(color='red') + geom_point()
  
  })
  
  
  output$uscrime<- renderPlot({
    
    dataus <- crimedf %>% 
      group_by(year)%>% 
      mutate(violent_total==mean(violent_total))%>%
      select(year,unemployment,violent_total)
    
    ggplot(dataus, aes(x=year, y=violent_crime)) + geom_line(color='red') + geom_point()
    
  })
})

