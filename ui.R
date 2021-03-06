library(shiny)

fluidPage(
  titlePanel("TCGA breast cancer data explorer"),
  fluidRow(
    column(12,
      p(
        "Basic exploration of", 
        a("TCGA",
          href = "http://cancergenome.nih.gov",
          target = "_blank"),
        "breast cancer data retrieved from",
        a("cBioPortal",
          href = "http://www.cbioportal.org/",
          target = "_blank")),
      p("Please adhere to the", 
        a("TCGA publication guidelines", 
          href = "http://cancergenome.nih.gov/abouttcga/policies/publicationguidelines",
          target = "_blank"), 
        "when using TCGA data in publications.", 
        br(),
        "Please cite",
        a("Gao et al. Sci. Signal. 2013", 
          href = "https://dx.doi.org/10.1126/scisignal.2004088",
          target = "_blank"), 
        "and", 
        a("Cerami et al. Cancer Discov. 2012", 
          href = "https://dx.doi.org/10.1158/2159-8290.CD-12-0095",
          target = "_blank"), 
        "when publishing results based on cBioPortal."))
  ),  
  h3("Data retrieval"),
  fluidRow(
    column(4,
      wellPanel(
        textInput("query_str", "Genes", value = "CDKN2A RB1 TP53"),
        actionButton("retrieve_data_button", "Retrieve data")), 
      htmlOutput("retrieved_genes") 
    ),
    column(4,
      wellPanel(
        uiOutput("var_y_ui"),
        uiOutput("var_x_ui")
      ))), 
  h3("Data visualisation"),
  checkboxInput("mark_mut", "Mark mutations in all graphics", value = FALSE),
  checkboxInput("by_subtype", "Facet by molecular subtype", value = FALSE),
  fluidRow(
    column(4,
      p("Predicted somatic non-silent mutations"),
      plotOutput("fig1"), 
      checkboxInput("show_mut", "Show mutations in graphics", value = FALSE),
      tableOutput("tab1")),
    column(4,
      p("Putative copy-number alterations (CNA)"),
      plotOutput("fig2")),
    column(4,
      p("mRNA expression"),
      plotOutput("fig3"), 
      selectInput("fig3_smooth_method", "Smoother",
        choices = c(
          "(none)" = "(none)", 
          "Linear regression" = "lm", 
          "Local polynomial regression (loess)" = "loess"), 
        selected = "loess"),
      p("Spearman's rank correlation coefficient, r"),
      tableOutput("tab2"))
  ),
  p('To save a figure to file, left-click/ctrl-click on the image and "Save Image As..." (or similar, depending on web browser).'),
  hr(),
  p(
    "© 2016 John Lövrot",
    br(),
    "This data retrieval and visualisation tool is licensed under a",
    a("Creative Commons Attribution 4.0 International License",
      href = "http://creativecommons.org/licenses/by/4.0/",
      target = "_blank"),
    br(),
    "The source code is available at",
    a("github.com/lovrot/tcga-brca-explorer",
      href = "https://github.com/lovrot/tcga-brca-explorer",
      target = "_blank"),
    br(),
    "Version 0.1.0")
)
