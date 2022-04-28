library(dplyr)
library(readr)
library(tidyverse)
library(googlesheets4)

#read in data
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

#manipulate rows
data <-
  bind_rows(
    np_data, 
    houston_data
  ) %>% 
  mutate(
    plot = factor(plot)
  )


data_presence_site <- 
  data %>% 
  distinct(site, status) %>% 
  mutate(present = TRUE) %>% 
  pivot_wider(
    names_from = "site", 
    values_from = "present", 
    values_fill = FALSE
  ) %>% 
  print()

filter(
  data_presence_site,
  !Houston,
  !NP
) %>% 
  arrange(status)

#bar chart that is not proportionate
data %>% 
  count(site, plot, status, name = "n_spp") %>% 
  ggplot() +
  geom_col(mapping = aes(x = status, y = n_spp, fill = status)) +
  facet_wrap(~ site)

# same thing using geom_bar shortcut
# data %>% 
#   ggplot() +
#   geom_bar(mapping = aes(x = status, fill = status)) +
#   facet_wrap(~ site)

#proportionate bar chart
data %>% 
  count(site, plot, status, name = "n_spp") %>% 
  group_by(site) %>% 
  mutate(n_site = sum(n_spp), p = n_spp/n_site) %>% 
  group_by(status, site) %>% 
  summarise(sum_p = sum(p)) %>% 
  ggplot() +
  geom_col(mapping = aes(x = site, y = sum_p, fill = status),
           position = "stack")

#Save bar chart
ggsave("bar chart.png",
       height = 8,
       width = 12,
       units = "in",
       dpi = 400)
 

#chi-squared test
data %>% 
  count(site, status) %>% 
  pivot_wider(names_from = "status", values_from = "n") %>% 
  select(-site) %>% 
  as.matrix() %>% 
  unname() %>% 
  chisq.test()
