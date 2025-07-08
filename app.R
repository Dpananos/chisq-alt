library(shiny)
library(DT)
library(shinydashboard)

# Define UI
ui <- dashboardPage(
  dashboardHeader(title = "Contingency Table Analysis"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Analysis", tabName = "analysis", icon = icon("table"))
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "analysis",
        fluidRow(
          box(
            title = "Contingency Table Input", 
            status = "primary", 
            solidHeader = TRUE,
            width = 6,
            p("Enter your contingency table data below. Double-click on cells to edit them."),
            p("Maximum size: 3x3 table"),
            DTOutput("contingency_table"),
            br(),
            fluidRow(
              column(4, 
                numericInput("rows", "Number of Rows:", 
                           value = 2, min = 2, max = 3, step = 1)
              ),
              column(4,
                numericInput("cols", "Number of Columns:", 
                           value = 2, min = 2, max = 3, step = 1)
              ),
              column(4,
                actionButton("reset_table", "Reset Table", 
                           class = "btn-warning")
              )
            )
          ),
          
          box(
            title = "Statistical Test Results", 
            status = "success", 
            solidHeader = TRUE,
            width = 6,
            
            h4("Test Results:"),
            
            h5("Chi-square Test (without Yates correction)"),
            verbatimTextOutput("chi_square_no_yates"),
            
            h5("Chi-square Test (with Yates correction)"),
            verbatimTextOutput("chi_square_yates"),
            
            h5("Fisher's Exact Test"),
            verbatimTextOutput("fisher_exact")
          )
        ),
        
        fluidRow(
          box(
            title = "Table Summary", 
            status = "info", 
            solidHeader = TRUE,
            width = 12,
            verbatimTextOutput("table_summary")
          )
        )
      )
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Initialize reactive values
  values <- reactiveValues(
    table_data = matrix(c(10, 20, 30, 40), nrow = 2, ncol = 2)
  )
  
  # Create initial table based on dimensions
  observeEvent(c(input$rows, input$cols), {
    if (!is.null(input$rows) && !is.null(input$cols)) {
      values$table_data <- matrix(1, nrow = input$rows, ncol = input$cols)
      rownames(values$table_data) <- paste("Row", 1:input$rows)
      colnames(values$table_data) <- paste("Col", 1:input$cols)
    }
  })
  
  # Reset table
  observeEvent(input$reset_table, {
    values$table_data <- matrix(1, nrow = input$rows, ncol = input$cols)
    rownames(values$table_data) <- paste("Row", 1:input$rows)
    colnames(values$table_data) <- paste("Col", 1:input$cols)
  })
  
  # Render editable table
  output$contingency_table <- renderDT({
    datatable(
      values$table_data,
      editable = TRUE,
      options = list(
        pageLength = 5,
        dom = 't',
        ordering = FALSE,
        searching = FALSE,
        info = FALSE,
        paging = FALSE
      ),
      rownames = TRUE
    )
  })
  
  # Handle table edits
  observeEvent(input$contingency_table_cell_edit, {
    info <- input$contingency_table_cell_edit
    i <- info$row
    j <- info$col
    v <- info$value
    
    # Convert to numeric and validate
    v <- as.numeric(v)
    if (is.na(v) || v < 0) {
      showNotification("Please enter a non-negative number", type = "error")
      return()
    }
    
    values$table_data[i, j] <- v
  })
  
  # Perform statistical tests
  perform_tests <- reactive({
    if (is.null(values$table_data)) return(NULL)
    
    # Ensure all values are non-negative integers
    table_matrix <- round(abs(values$table_data))
    
    # Check if table has valid data
    if (sum(table_matrix) == 0) {
      return(list(
        error = "Table cannot be empty or contain only zeros"
      ))
    }
    
    tests <- list()
    
    # Chi-square test without Yates correction
    tryCatch({
      tests$chi_no_yates <- chisq.test(table_matrix, correct = FALSE)
    }, error = function(e) {
      tests$chi_no_yates <- paste("Error:", e$message)
    })
    
    # Chi-square test with Yates correction
    tryCatch({
      tests$chi_yates <- chisq.test(table_matrix, correct = TRUE)
    }, error = function(e) {
      tests$chi_yates <- paste("Error:", e$message)
    })
    
    # Fisher's exact test
    tryCatch({
      tests$fisher <- fisher.test(table_matrix)
    }, error = function(e) {
      tests$fisher <- paste("Error:", e$message)
    })
    
    return(tests)
  })
  
  # Display chi-square test without Yates correction
  output$chi_square_no_yates <- renderPrint({
    tests <- perform_tests()
    if (is.null(tests)) return("Enter data to see results")
    if (!is.null(tests$error)) return(tests$error)
    
    if (is.character(tests$chi_no_yates)) {
      cat(tests$chi_no_yates)
    } else {
      print(tests$chi_no_yates)
    }
  })
  
  # Display chi-square test with Yates correction
  output$chi_square_yates <- renderPrint({
    tests <- perform_tests()
    if (is.null(tests)) return("Enter data to see results")
    if (!is.null(tests$error)) return(tests$error)
    
    if (is.character(tests$chi_yates)) {
      cat(tests$chi_yates)
    } else {
      print(tests$chi_yates)
    }
  })
  
  # Display Fisher's exact test
  output$fisher_exact <- renderPrint({
    tests <- perform_tests()
    if (is.null(tests)) return("Enter data to see results")
    if (!is.null(tests$error)) return(tests$error)
    
    if (is.character(tests$fisher)) {
      cat(tests$fisher)
    } else {
      print(tests$fisher)
    }
  })
  
  # Display table summary
  output$table_summary <- renderPrint({
    if (is.null(values$table_data)) return("No data")
    
    cat("Current Contingency Table:\n")
    print(values$table_data)
    cat("\nRow totals:", rowSums(values$table_data), "\n")
    cat("Column totals:", colSums(values$table_data), "\n")
    cat("Grand total:", sum(values$table_data), "\n")
  })
}

# Run the application
shinyApp(ui = ui, server = server) 