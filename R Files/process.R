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

# Set WD to source file location  -------------------------------------------------------
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Read in JSON file -------------------------------------------------------
dat <- jsonlite::fromJSON("https://raw.githubusercontent.com/summerscope/summer-child/main/questions.json", flatten = TRUE) %>%
  mutate(qn_text = text, .keep = "unused")

dat_long <- dat %>%
  mutate(across(ends_with("score"), ~ as.numeric(.x)),
         across(ends_with("multiplier"), ~ as.numeric(.x))) %>%
  pivot_longer(cols = starts_with("answers"),
               names_to = c("Response", ".value"),
               names_pattern = "answers\\.(\\w+)\\.(\\w+)"
  ) %>%
  filter (!is.na(text))


# Create required data structure for survey ---------------------------------------------------------
# change column names as per shinysurveys
survey_qns <- dat_long %>%
  mutate(input_type = ifelse(Response == "Ok", "instructions", "mc"),
         question = str_replace(qn_text,"To continue, type 'Ok'", ""),
         option = text,
         input_id = id,
         required = TRUE,
         dependence = NA,
         dependence_value = NA,
         page = str_extract(question, "Section #[0-9]+"),
         .keep = "unused") %>%
  fill(page) %>% as.data.frame()

# determine questions with dependencies
dependencies <- survey_qns %>%
  select(input_id, nextq) %>%
  group_by(input_id) %>%
  summarise(num_nextq = n_distinct(nextq)) %>%
  filter(num_nextq > 1)
dependencies <- survey_qns %>%
  filter(input_id %in% dependencies$input_id) %>%
  select(input_id, option, nextq)

# assign dependencies
<<<<<<< HEAD
for (qn in sort(unique(dependencies$input_id), decreasing = FALSE)){
  question_range <- dependencies %>% 
    filter(input_id == qn) %>% 
=======
for (qn in sort(unique(depend$input_id), decreasing = FALSE)){
  question_range <- dependencies %>%
    filter(input_id == qn) %>%
>>>>>>> 12975c5fde5731fe46b062da27e7abb720e82569
    mutate(nextq = as.numeric(str_extract(nextq, "([0-9]+)")))
  next_option <- question_range %>%
    filter(nextq == min(nextq)) %>%
    select(option)
  survey_qns <- survey_qns %>%
    mutate(
      dependence = ifelse(input_id %in% paste0("Q", min(question_range$nextq):(max(question_range$nextq - 1))),
                          qn,
                          dependence),
      dependence_value = ifelse(input_id %in% paste0("Q", min(question_range$nextq):(max(question_range$nextq - 1))),
                                next_option,
                                dependence_value)
    )
}

# Launch survey --------------------------------------------------------------
ui <- fluidPage(
  surveyOutput(df = survey_qns,
               survey_title = "Sweet Summer Child Score (SSCS)",
               survey_description = "SSCS is a scoring mechanism for latent risk. It will help you quickly and efficiently scan for the possibility of harm to people and communities by a socio-technical system. Note that harms to animals and the environment are not considered.
               Please note that all questions are mandatory and you will not be able to submit the survey if there are questions left uncompleted.")
)

server <- function(input, output, session) {
  renderSurvey()
  observeEvent(input$submit, {
    showModal(modalDialog(
      title = "Congrats, you completed your first shinysurvey!",
      "You can customize what actions happen when a user finishes a survey using input$submit."
    ))
    response_data <- getSurveyData()
    print(response_data %>% 
            left_join(survey_qns,
                      by = c("question_id" = "input_id", 
                             "response" = "option"  )) %>%
            select(question_id, multiplier, score) %>% 
            summarise(risk = sum(multiplier, na.rm = TRUE) * sum(score, na.rm = T)) %>%
            pull(risk) %>% 
            cat()
    )
  })
}

shinyApp(ui, server)
