######################################################################
#
# process.R
#
# This file is used to generate a survey to estimate experimental risk
# 
# Created by RLadies Melbourne 
# 22/2/2022
# 
######################################################################

# Load libraries ----------------------------------------------------------
library(jsonlite) ## version 1.7.3
# check that the version of jsonlite installed has the required capability
if(packageVersion("jsonlite") < "1.7.3") {
  stop("Please install the most recent version of the jsonlite package for this code to run correctly")
}
library(tidyverse)
library(shiny)
library(shinysurveys)


# Read in JSON file -------------------------------------------------------
dat <- jsonlite::fromJSON("questions.json", flatten = TRUE) %>%
  mutate(qn_text = text, .keep = "unused")

dat_long <- dat %>% 
  mutate(across(ends_with("score"), ~ as.numeric(.x)),
         across(ends_with("multiplier"), ~ as.numeric(.x))) %>%
  pivot_longer(cols = starts_with("answers"),
                          names_to = c("Response", ".value"),
                          names_pattern = "answers\\.(\\w+)\\.(\\w+)"
) %>%
  filter (!is.na(text))


# Generate survey ---------------------------------------------------------
survey_qns <- dat_long %>%
  mutate(input_type = ifelse(Response == "Ok", "y/n", "mc"),
         question = qn_text,
         option = text,
         input_id = id,
         required = TRUE,
         dependence = FALSE, 
         .keep = "unused") %>%
  as.data.frame()

## below code is not yet working
## also don't know whether shinysurveys can be used to dynamically define next question
ui <- fluidPage(
  surveyOutput(df = survey_qns,
               survey_title = "Sweet Summer Child Score (SSCS)",
               survey_description = "SSCS is a scoring mechanism for latent risk. It will help you quickly and efficiently scan for the possibility of harm to people and communities by a socio-technical system. Note that harms to animals and the environment are not considered.")
)

server <- function(input, output, session) {
  renderSurvey()
  
  observeEvent(input$submit, {
    showModal(modalDialog(
      title = "Congrats, you completed your first shinysurvey!",
      "You can customize what actions happen when a user finishes a survey using input$submit."
    ))
  })
}

shinyApp(ui, server)



