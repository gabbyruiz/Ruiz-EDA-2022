library(tidyverse)
library(googlesheets4)

NP_Species_20 <- read_sheet("https://docs.google.com/spreadsheets/d/1rVNHuyM9z6qAGKWknkn8j7zuJhFyHJeZnLgxxVdpM-4/edit#gid=0")
NP_Species_20


Houston_Species_20 <- read_sheet("https://docs.google.com/spreadsheets/d/1E4_RjXlmtJN9BJ0-z-cDE3Mzdpym_Bl0bLrklUKAsu8/edit#gid=0")


data <-
  bind_rows(
    NP_Species_20, 
    Houston_Species_20
  ) %>% 
  mutate(
    plot = factor(plot)
  )

count(data, taxa) %>% 
  count()

count(data, site, taxa) %>% 
  count(site)

data_presence_site <- 
  data %>% 
  distinct(site, taxa) %>% 
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
  !MSUM_NP
) %>% 
  arrange(taxa)

#FOR POSTER
data %>% 
  count(site, plot, treatment, name = "n_spp") %>% 
  ggplot() +
  geom_col (size = 3) + (mapping = aes(x = plot, y = n_spp, fill = treatment)) +
  facet_wrap(~ site)
ggsave("SAC 2020.png",
       height = 8,
       width = 12,
       units = "in",
       dpi = 400)

#Comparing controls from NP and Houston
data %>% 
  count(site, plot, treatment, name = "n_spp") %>% 
  filter(treatment == "C") %>% 
  ggplot() +
  geom_jitter (mapping = aes(x = site, y = n_spp, color = treatment),
               size=2)
