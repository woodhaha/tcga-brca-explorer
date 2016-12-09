library(shiny)
library(dplyr)
library(ggplot2)
library(cgdsr)

source("helpers.R")

function(input, output) {
  
  retrive_tcga_data <- reactive({
    input$retreive_button
    ids <- isolate(c(input$var_x, input$var_y))
    retreive_data(ids)
  })
  
  assemble_graph_data <- reactive({
    var_x <- isolate(input$var_x)
    var_y <- isolate(input$var_y)
    
    graph_data <- retrive_tcga_data() %>%
      mutate_(
        x_mut = paste0(var_x, "_mutations"), 
        x_gistic = paste0(var_x, "_gistic"), 
        x_rna = paste0(var_x, "_rna"), 
        y = paste0(var_y, "_rna")) %>%
        mutate(
          x_mutcat = 
            factor(x_mut == "(none)",
              levels = c(TRUE, FALSE),
              labels = c("(none)", "mutated")))
      n_mutations <- length(levels(graph_data[, paste0(var_x, "_mutations")]))
      if (n_mutations <= 5) {
        graph_data <- mutate(graph_data, x_mutations = x_mut)
      } else {
        graph_data <- mutate(graph_data, x_mutations = x_mutcat)
      }
      return(graph_data)
  })
  
  output$plot1 <- renderPlot({
    var_x <- isolate(input$var_x)
    var_y <- isolate(input$var_y)
    
    gg1 <- assemble_graph_data() %>%
      filter(!is.na(x_mutations) & !is.na(y)) %>%
      ggplot(aes(x = x_mutations, y = y)) + 
      geom_point(shape = 1, alpha = 0.5, 
        position = position_jitter(h = 0,  w = 0.1)) + 
      geom_boxplot(col = "darkred", varwidth = TRUE,
        fill = "transparent", outlier.colour = "transparent") +
      theme(axis.text.x=element_text(angle = 45, hjust = 1)) + 
      labs(
        x = paste0(var_x, ", mutations"), 
        y = paste0(var_y, ", mRNA expression (log2 RNA-seq)"))
    plot(gg1)
  })
  
  output$plot2 <- renderPlot({
    var_x <- isolate(input$var_x)
    var_y <- isolate(input$var_y)
    
    gg2 <- assemble_graph_data() %>%
      filter(!is.na(x_gistic) & !is.na(y)) %>%
      ggplot(aes(x = x_gistic, y = y)) + 
      geom_point(shape = 1, alpha = 0.5, 
        position = position_jitter(h = 0,  w = 0.1)) + 
      geom_boxplot(col = "darkred", varwidth = TRUE,
        fill = "transparent", outlier.colour = "transparent") +
      theme(axis.text.x=element_text(angle=45, hjust=1)) + 
      labs(
        x = paste0(var_x, ", putative CNA (GISTIC)"), 
        y = paste0(var_y, ", mRNA expression (log2 RNA-seq)"))
    plot(gg2)
  })
  
  output$plot3 <- renderPlot({
    var_x <- isolate(input$var_x)
    var_y <- isolate(input$var_y)
    
    gg3 <- assemble_graph_data() %>%
      filter(!is.na(x_rna) & !is.na(y)) %>%
      ggplot(aes(x = x_rna, y = y)) + 
      geom_point(shape = 1, alpha = 0.5) + 
      geom_smooth(col = "darkred", method = "loess") +
      labs(
        x = paste0(var_x, ", mRNA expression (log2 RNA-seq)"), 
        y = paste0(var_y, ", mRNA expression (log2 RNA-seq)"))
    plot(gg3)
  })
  
  output$text3 <- renderText({ 
    graph_data <- assemble_graph_data() 
    r <- cor(graph_data$x_rna, graph_data$y, 
      use = "complete.obs", method = "spearman")
    paste("Spearman's rank correlation coefficient:", format(r, digits = 2))
  })
  
}