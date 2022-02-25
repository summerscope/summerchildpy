ensure_package_installed <- function (package, repos = repos) {
  if(!require(package, character.only=TRUE)) {
    install.packages(package, repos = repos)
    library(package, character.only=TRUE)
  }
}
ensure_package_installed("dplyr", repos = list("http://cran.rstudio.com/", "https://cran.ms.unimelb.edu.au/"))
ensure_package_installed("shiny", repos = list("http://cran.rstudio.com/", "https://cran.ms.unimelb.edu.au/"))
ensure_package_installed("shinysurveys", repos = list("http://cran.rstudio.com/", "https://cran.ms.unimelb.edu.au/"))
ensure_package_installed("tidyr", repos = list("http://cran.rstudio.com/", "https://cran.ms.unimelb.edu.au/"))
ensure_package_installed("jsonlite", repos = list("http://cran.rstudio.com/", "https://cran.ms.unimelb.edu.au/"))
