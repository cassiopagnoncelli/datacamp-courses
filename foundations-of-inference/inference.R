# PARLANCE.
# 
# Null hypothesis (H_0): The claim that is not interesting.
# 
# Alternative hypothesis (H_a): The claim corresponding to the research
#   hypothesis.
# 

# Example 1.
# 
# Research: Compare the speed of two different species of cheetah. 
# (Population measure.)
# 
# H_0: Asian and African cheetah run at the same speed. (Not interesting)
# H_a: African > Asian, on average. (Research)

# Example 2.
# 
# Research: Candidate X will win.
# (Population measure.)
# 
# H_0: Candidate X will get half of the votes.
# H_a: Candidate X gets more than half of the votes.

# Exploratory inference.
library('dplyr')
library('ggplot2')
library('NHANES')
library('infer')

data('NHANES')

names(NHANES)

ggplot(NHANES, aes(x = Gender, fill = HomeOwn)) + 
  geom_bar(position = "fill") +
  ylab("Relative frequencies")

ggplot(NHANES, aes(x = SleepHrsNight, col = SleepTrouble)) + 
  geom_density(adjust = 2) + 
  facet_wrap(~ HealthGen)

# Study 1.
# Home ownership example.
homes <- NHANES %>%
  select(Gender, HomeOwn) %>%
  filter(HomeOwn %in% c("Own", "Rent"))

homes %>%
  mutate(HomeOwn_perm = sample(HomeOwn)) %>%
  group_by(Gender) %>%
  summarize(prop_own_perm = mean(HomeOwn_perm == "Own"), 
            prop_own = mean(HomeOwn == "Own")) %>%
  summarize(diff_perm = diff(prop_own_perm),
            diff_orig = diff(prop_own))


homeown_perm <- homes %>%
  rep_sample_n(size = nrow(homes), reps = 10) %>%
  mutate(HomeOwn_perm = sample(HomeOwn)) %>%
  group_by(replicate, Gender) %>%
  summarize(prop_own_perm = mean(HomeOwn_perm == "Own"), 
            prop_own = mean(HomeOwn == "Own")) %>%
  summarize(diff_perm = diff(prop_own_perm),
            diff_orig = diff(prop_own)) # male - female

homeown_perm

ggplot(homeown_perm, aes(x = diff_perm)) + 
  geom_dotplot(binwidth = .001)


homeown_perm <- homes %>%
  rep_sample_n(size = nrow(homes), reps = 100) %>%
  mutate(HomeOwn_perm = sample(HomeOwn)) %>%
  group_by(replicate, Gender) %>%
  summarize(prop_own_perm = mean(HomeOwn_perm == "Own"), 
            prop_own = mean(HomeOwn == "Own")) %>%
  summarize(diff_perm = diff(prop_own_perm),
            diff_orig = diff(prop_own)) # male - female

ggplot(homeown_perm, aes(x = diff_perm)) + 
  geom_dotplot(binwidth = 1e-3)


homeown_perm <- homes %>%
  rep_sample_n(size = nrow(homes), reps = 1000) %>%
  mutate(HomeOwn_perm = sample(HomeOwn)) %>%
  group_by(replicate, Gender) %>%
  summarize(prop_own_perm = mean(HomeOwn_perm == "Own"), 
            prop_own = mean(HomeOwn == "Own")) %>%
  summarize(diff_perm = diff(prop_own_perm),
            diff_orig = diff(prop_own)) # male - female

ggplot(homeown_perm, aes(x = diff_perm)) + 
  geom_density()


# Here, 228 out of 1000 differences are more extreme than the
# observed differences. 
# 
# This represents only 23% of the null statistics. 
# 
# In other words, 228 permutations are smaller than the original
# 
# Thus, the observed difference is consistent with the permuted
# difference.
# 
# So we failed to reject the null hypothesis,
# 
#   H_0: proportions are equal.
#   H_a: proportions are not equal.
# 
# That means proportions are likely to be equal.
# 
# That means if gender played no role in home ownership we'd
# likely get data similar to those observed. However this does
# not mean that we know for sure gender does not play a role,
# it is possible the true difference in home ownership rates is
# 0.1 and surely our population would be consistent with that
# population as well.
# 
# We fail to reject the null hypothesis: there is no evidence
# that our data is inconsistent with the null hypothesis.
# 
# There is no claim to generalize in larger population,
# there is nothing to report.
# 
ggplot(homeown_perm, aes(x = diff_perm)) + 
  geom_density() +
  geom_vline(aes(xintercept = diff_orig),
             col = "red")

homeown_perm %>%
  summarize(sum(diff_orig >= diff_perm))


# Why 0.05?
# 
# "It is a common practice to judge a result significant if
# it is of such a magnitude that it would have been produced
# by chance not more frequently than once in twenty trials.
# 
# "This is an arbitrary, but convenient, level of significance
# for the practical investigator, but it doesn't mean he allows
# himself to be deceived once in every twenty experiments.
# 
# "The test of significance only tells him what to ignore,
# namely all experiments in which significant results are not
# obtained.
# 
# "He should only claim that a phenomenon is experimentally
# demonstrable when he knows how to design an experiment so
# so that it will rarely fail to give a significant result.
# 
# "Consequently, isolated significant results which he doesn't
# know how to reproduce are left in suspense pending further
# investigation."
# 
# R.A. Fischer, 1929.
# 

# p-value.
# 
# Probability of observing data as or more extreme than what
# we actually got given that the null hypothesis is true.
# 
# In other words, suppose null hypothesis is true. Then p-value
# is the likelihood that we find data as or more extreme than
# that observed.
# 
# It is the proportion of times the observed difference is less
# than or equal to the permuted difference.
# 

# Study 2.
# Gender discrimination on promotion.
# 
# H_0: gender and promotion are unrelated variables.
# H_a: men are more likely to be promoted.
# 
# Using rep_sample_n(), you took 5 repeated samples 
# (i.e. Replications) of the disc data, then shuffled
# these using sample() to break any links between gender
# and getting promoted. Then for each replication, you
# calculated the proportions of promoted males and females
# in the dataset along with the difference in proportions.
# 
# Probability of observing a difference of 0.2917 or greater
# in promotion rates do not vary across gender is 0.03 = p-value.
# 
# Because 0.03 < 0.05 we REJECT H_0 in favour of H_a.
# 
