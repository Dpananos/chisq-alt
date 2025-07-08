# Contingency Table Analysis Shiny App

This R Shiny application provides an interactive interface for analyzing contingency tables using multiple statistical tests.

## Features

- **Editable Contingency Table**: Excel-style interface where you can directly edit cells by double-clicking
- **Flexible Table Size**: Support for 2x2, 2x3, 3x2, and 3x3 contingency tables
- **Multiple Statistical Tests**:
  - Chi-square test without Yates correction
  - Chi-square test with Yates correction  
  - Fisher's exact test
- **Real-time Results**: Statistical test results update automatically as you edit the table
- **Table Summary**: Shows row totals, column totals, and grand total

## Installation

1. First, install the required packages by running:
```r
source("install_packages.R")
```

2. Alternatively, install packages manually:
```r
install.packages(c("shiny", "DT", "shinydashboard"))
```

## Running the App

To run the application:

```r
shiny::runApp("app.R")
```

Or simply:
```r
source("app.R")
```

## How to Use

1. **Set Table Dimensions**: Use the "Number of Rows" and "Number of Columns" inputs to set your desired table size (2-3 for each dimension)

2. **Edit Table Data**: Double-click on any cell in the contingency table to edit its value. Enter non-negative numbers only.

3. **View Results**: The statistical test results will automatically update in the right panel as you modify the table

4. **Reset Table**: Click the "Reset Table" button to clear all data and start over

## Statistical Tests

### Chi-square Test (without Yates correction)
- Tests independence between row and column variables
- Uses the standard Pearson chi-square statistic
- Appropriate for larger sample sizes

### Chi-square Test (with Yates correction)
- Also tests independence but applies Yates' continuity correction
- More conservative than the uncorrected version
- Traditionally used for 2x2 tables

### Fisher's Exact Test
- Provides exact p-values for contingency tables
- Especially useful for small sample sizes
- Does not rely on large-sample approximations

## Example

Try entering this 2x2 table:
```
     Col1  Col2
Row1  12    8
Row2  3     17
```

The app will show you all three test results and help you interpret the association between your variables.

## Notes

- All values must be non-negative integers (the app will round decimal inputs)
- Empty tables or tables with all zeros will show an error message
- The app handles edge cases gracefully with appropriate error messages
- Results are displayed in a clean, easy-to-read format

## Dependencies

- R (>= 3.5.0)
- shiny
- DT
- shinydashboard 