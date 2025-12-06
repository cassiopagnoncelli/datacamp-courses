library('dplyr')
library('tibble')

set.seed(123)

View(attrition_pop)
attrition_samp <- attrition_pop %>% 
  rowid_to_column() %>% # Add a row ID column
  slice_sample(n = 200) # Get 200 rows using simple random sampling
View(attrition_samp)

# Shuffle.
attrition_shuffled <- attrition_pop %>%
  slice_sample(prop = 1) %>%
  rowid_to_column()
ggplot(attrition_shuffled, aes(rowid, YearsAtCompany)) +
  geom_point() +
  geom_smooth()

# Stratified sampling.
# Split the pop into subgroups.
# Use simple random sampling within each subgroup.
#
attrition_pop %>% 
  count(Education, sort = TRUE) %>% 
  mutate(percent = 100 * n / sum(n))
attrition_strat <- attrition_pop %>% 
  group_by(Education) %>% 
  slice_sample(prop = 0.4) %>% 
  ungroup()

attrition_eq <- attrition_pop %>%
  group_by(Education) %>% 
  slice_sample(n = 30) %>%
  ungroup()

attrition_pop %>% 
  count(Education, sort = TRUE) %>% 
  mutate(percent = 100 * n / sum(n))
attrition_strat <- attrition_pop %>% 
  group_by(Education) %>% 
  slice_sample(prop = 0.4) %>% 
  ungroup()
education_counts_strat <- attrition_strat %>% 
  count(Education, sort = TRUE) %>% 
  mutate(percent = 100 * n / sum(n))

attrition_eq <- attrition_pop %>%
  group_by(Education) %>% 
  slice_sample(n = 30) %>%
  ungroup()
education_counts_eq <- attrition_eq %>% 
  count(Education, sort = TRUE) %>% 
  mutate(percent = 100 * n / sum(n))

# Sample 400 employees weighted by YearsAtCompany
attrition_weight <- attrition_pop %>% 
  slice_sample(n = 400, weight_by = YearsAtCompany)
ggplot(attrition_weight, aes(x = YearsAtCompany)) +
  geom_histogram(binwidth = 1)


# Cluster sampling.
# Use simple random sampling to pick some subgroups.
# Use simple random sampling on only those subgroups.

coffee_ratings %>%
  filter(variety %in% varieties_samp) %>%
  group_by(variety) %>%
  slice_sample(n = 5) %>%
  ungroup()

















