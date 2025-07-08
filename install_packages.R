# Install required packages for the Contingency Table Analysis Shiny App

# List of required packages
required_packages <- c(
  "shiny",
  "DT",
  "shinydashboard"
)

# Function to install packages if not already installed
install_if_missing <- function(package) {
  if (!requireNamespace(package, quietly = TRUE)) {
    install.packages(package, dependencies = TRUE)
    cat("Installed:", package, "\n")
  } else {
    cat("Already installed:", package, "\n")
  }
}

# Install all required packages
cat("Installing required packages for Contingency Table Analysis App...\n")
lapply(required_packages, install_if_missing)

# Load packages to test installation
cat("\nTesting package loading...\n")
lapply(required_packages, function(pkg) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    cat("✓", pkg, "loaded successfully\n")
  } else {
    cat("✗", pkg, "failed to load\n")
  }
})

cat("\nPackage installation complete!\n")
cat("You can now run the Shiny app with: shiny::runApp('app.R')\n") 