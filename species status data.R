library(dplyr)
library(readr)

np_url <- "https://docs.google.com/spreadsheets/d/1hfK3ptAkMU4AiM5PknHe4IebFl29wEWNdMKpc5nEC4M/edit#gid=0"
np_data <-
  read_sheet(np_url) %>% 
  left_join(read_sheet(np_url, sheet = 2)) %>% 
  print()

houston_url <- "https://docs.google.com/spreadsheets/d/1-VpDe1FBQKK1nWYI_HOV8qVGD1fSHKUoe65E11iqOEU/edit#gid=1776011343"

houston_data <-
  read_sheet(houston_url) %>% 
  left_join(read_sheet(houston_url, sheet = 2)) %>% 
  print()

bind_rows(houston_data, np_data)