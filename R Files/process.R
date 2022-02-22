library(dplyr)
library(tidyr)
library(magrittr)
library(readr)


quest = read_csv("questions.csv")
sub <- quest %>% 
  select(id, text, contains("text")) %>%
  select(-answers.Ok.text)

sub_long <- sub %>% 
  pivot_longer(quest, 
               cols = answers.A.text:answers.G.text,
               names_to = "option_name",
               values_to = "option") %>%
  rename(question = text)
