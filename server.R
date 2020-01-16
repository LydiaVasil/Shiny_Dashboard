
shinyServer(function(input, output) {
    
    output$usmapplot <- renderPlotly({
       
     
        data <- state_unemploymentyearly %>% 
            filter(year == input$year)
        
        plot_usmap(data = data, values = "value", color = "red") + 
            labs(title = "Unemployment Rate of US States for the Selected Year",
                 subtitle = "States with Darker color have higher rate of unemployment")+
            scale_fill_continuous(low = "white", high = "red",name = "Unemployment Rate", label = scales::comma) + 
            theme(legend.position = "right")
        })
    
   
    
    
    output$statelineplot<- renderPlot({
        
        data <- state_unemploymentyearly %>% 
            filter(state == input$state)
        ggplot(data=data, aes(x=year, y=value, group=1)) + geom_line(color='red') + geom_point()
        
    })
    
    output$yearlylineplot<- renderPlot({
        
        data <- state_unemploymentyearly %>% 
            filter(year == input$year)
        ggplot(data=data, aes(x=year, y=value, group=1)) + geom_line(color='red') + geom_point()
        
    })
    
    output$frame <- renderUI({
        HTML(paste0('<iframe width="280" height="157" src="https://www.youtube.com/embed/P5OYZ65sozw?rel=0" frameborder="0"  encrypted-media; 
        gyroscope; picture-in-picture" allowfullscreen></iframe>'))
        })
    output$datayearly <- renderDataTable(
        mytable <- crimevsunemployment %>% filter(year==input$year),
        print(mytable)
    )
    
    
    output$crimecompare <- renderPlotly ({
    
    data <- crimevsunemployment %>% 
        subset(select = c(year,unemployment,input$crime) ) %>% 
        gather(key = "variable", value = "value", -year)
    ggplot(data, aes(x = year, y = value)) + 
        geom_line(aes(color = variable), size = 1) +
        scale_color_manual(values = c("#00AFBB", "#E7B800" )) +
        theme_minimal()
    
    })
    output$crimeplot<- renderPlot({
        
        data <- crimevsunemployment %>% 
            subset(select = c(year,unemployment,input$state) ) %>% 
            gather(key = "variable", value = "value", -year)
    
        ggplot(data, aes(x = year, y = value)) + 
            geom_line(aes(color = variable), size = 1) +
            scale_color_manual(values = c("#00AFBB", "#E7B800", "#FC4E07")) +
            theme_minimal()
    })
    

     

})

