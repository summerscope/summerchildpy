library(dplyr)
library(tidyr)
library(magrittr)
library(readr)
library(stringr)
library(shinysurveys)
library(jsonlite)

# Give the input file name to the function.
# If you wanna read it from json and not csv
# you can run this code and wrangle it from there! :)

survey_input <- jsonlite::fromJSON(txt = "questions.json", 
                                   flatten = TRUE, 
                                   simplifyDataFrame = TRUE  )

quest = read_csv("questions.csv")
sub <- quest %>% 
  select(id, text, contains("text")) %>%
  select(-answers.Ok.text)

sub_long <- sub %>% 
  pivot_longer(quest, 
               cols = answers.A.text:answers.G.text,
               names_to = "option_name",
               values_to = "option") %>%
  rename(question = text) %>%
  mutate(input_type = ifelse(str_detect(question, "Section"), "select", "mc"))
