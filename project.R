library("tibble")
library("dplyr")
library("tidyverse")
library("tidyr")


data(covid19_data)

covid19_data %>%
  extract(case_month, c("year", "month"), "([^,]+)-([^)]+)") %>%
  filter(year == 2021, current_status == 'Laboratory-confirmed case') %>%
  select(month, current_status) %>%
  group_by(month) %>%
  summarize(monthly_cases = n()) %>%
  select(month, monthly_cases) %>%
  ggplot() +
    geom_point(aes(x=month, y=monthly_cases))

  
covid19_data %>%
  extract(case_month, c("year", "month"), "([^,]+)-([^)]+)") %>%
  filter(year == 2021, race != 'Missing') %>%
  group_by(race) %>%
  mutate(total_race = n()) %>%
  filter(year == 2021, race != 'Missing', current_status == 'Laboratory-confirmed case') %>%
  select(month, current_status, race, total_race) %>%
  group_by(race, month) %>%
  mutate(monthly_cases = n()) %>%
  distinct() %>%
  summarise(percent_infected = monthly_cases/total_race) %>%
  ggplot() +
    geom_point(aes(x=month, y=(percent_infected), color=race))

covid19_data %>%
  extract(case_month, c("year", "month"), "([^,]+)-([^)]+)") %>%
  filter(year == 2021, race != 'Missing') %>%
  group_by(race) %>%
  mutate(total_race = n()) %>%
  filter(year == 2021, race != 'Missing', current_status == 'Laboratory-confirmed case') %>%
  select(month, current_status, race, total_race) %>%
  group_by(month, race) %>%
  mutate(monthly_cases = n()) %>%
  distinct() %>%
  mutate(percent_infected  = monthly_cases/total_race) %>%
  group_by(month) %>%
  mutate(max_percent  = max(percent_infected)) %>%
  select(month, race, percent_infected, max_percent) %>%
  filter(percent_infected == max_percent) %>%
  select(month, race, percent_infected) %>%
  arrange(month)
