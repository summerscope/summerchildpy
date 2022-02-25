library(dplyr)
library(tidyr)
library(stringr)
library(jsonlite)
library(shiny)
library(shinysurveys)

import_json_for_shinysurvey <- function(){

  # Question logic
  question_logic <- jsonlite::fromJSON("../questions.json", flatten = TRUE) %>%
    mutate(qn_text = text, .keep = "unused")

  columns_to_numeric <- question_logic %>%
    mutate(across(ends_with("score"), ~ as.numeric(.x)),
           across(ends_with("multiplier"), ~ as.numeric(.x)))

  questions_to_long <- columns_to_numeric %>%
    pivot_longer(cols = starts_with("answers"),
                 names_to = c("Response", ".value"),
                 names_pattern = "answers\\.(\\w+)\\.(\\w+)"
    ) %>%
    filter (!is.na(text))

  # Create required data structure for survey ---------------------------------------------------------
  # change column names as per shinysurveys
  survey_qns <- questions_to_long %>%
    mutate(input_type = ifelse(Response == "Ok", "instructions", "mc"),
           question = str_replace(qn_text,"To continue, type 'Ok'", ""),
           option = text,
           input_id = id,
           required = TRUE,
           dependence = NA,
           dependence_value = NA,
           # page = str_extract(question, "Section #[0-9]+"),
           page = input_id,
           .keep = "unused") %>%
    fill(page) %>% as.data.frame()

  # determine questions with dependencies
  qns_with_dependencies <- survey_qns %>%
    select(input_id, nextq) %>%
    group_by(input_id) %>%
    summarise(num_nextq = n_distinct(nextq)) %>%
    filter(num_nextq > 1)

  dependencies <- survey_qns %>%
    filter(input_id %in% qns_with_dependencies$input_id) %>%
    select(input_id, option, nextq)

  # assign dependencies
  qns_id_with_depend <- sort(unique(dependencies$input_id), decreasing = FALSE)
  for (qn in qns_id_with_depend){
    question_range <- dependencies %>%
      filter(input_id == qn) %>%
      mutate(nextq = as.numeric(str_extract(nextq, "([0-9]+)")))

    next_option <- question_range %>%
      filter(nextq == min(nextq)) %>%
      select(option)

    question_ranges <- paste0("Q", min(question_range$nextq):(max(question_range$nextq - 1)))

    survey_qns <- survey_qns %>%
      mutate(
        dependence = ifelse(input_id %in% question_ranges,
                            qn,
                            dependence),
        dependence_value = ifelse(input_id %in% question_ranges,
                                  next_option,
                                  dependence_value),
        page = ifelse((input_id %in% question_ranges) & (page == input_id),
                      paste0("Q", min(question_range$nextq) - 1),
                      page)
      )
  }

  return(survey_qns)

}
