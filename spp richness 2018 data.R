
library(tidyverse)
library(googlesheets4)

NP_Species_18 <- read_sheet("https://docs.google.com/spreadsheets/d/1bBaDxI7PnZIbDDT4N_kmLap8wHPJO6cyj4Qaxv3xwvI/edit#gid=0")
NP_Species_18

houston_url <-"https://docs.google.com/spreadsheets/d/1dE-9shHj4D0H8DHCF25JeJpycBEBOA5x38j4uQILnJs/edit#gid=0"

Houston_Species_18 <- 
read_sheet(houston_url, sheet = "data")


data <-
  bind_rows(
    NP_Species_18, 
    Houston_Species_18
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
  !NP
) %>% 
  arrange(taxa)

#FOR POSTER
data %>% 
  count(site, plot, treatment, name = "n_spp") %>% 
  ggplot() +
  geom_col (size = 3) + (mapping = aes(x = plot, y = n_spp, fill = treatment)) +
  facet_wrap(~ site)
ggsave("SAC.png",
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
