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
library('oilabs')

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

# Hypothesis testing errors: opportunity cost.
# 
# Two control groups of students are each given a set of
# options about buying something.
# 
#   Group 1: (1) buy, or (2) not buy.
#   Group 2: (1) buy, or (2) not buy, save $20 for next purchase.
# 
# Then we get the conversion rates (prop_buy) for each group. We
# want to know whether there is a difference in conversion rates
# by using messaging in Group 2, or messaging in Group 1 is better.
# 
# Here we have hypothesis
# 
#   H_0: Difference in conversion rates is zero.
#   H_a: Difference in conversion rates is not zero.
# 
# In other words,
# 
#   H_0: Reminding students that they can save money for later
#        purchases will not have any impact on students' spending
#        decisions.
#   H_a: Reminding students that they can save money for later
#        purchases will change the chance they will continue with
#        a purchase.
#
opportunity = read.csv("foundations-of-inference/opportunity.csv", header=T)

opp_perm <- opportunity %>%
  rep_sample_n(size = nrow(opportunity), reps = 1000) %>%
  mutate(dec_perm = sample(decision)) %>%
  group_by(replicate, group) %>%
  summarize(prop_buy_perm = mean(dec_perm == "buyDVD"),
            prop_buy = mean(decision == "buyDVD")) %>%
  summarize(diff_perm = diff(prop_buy_perm),
            diff_orig = diff(prop_buy))  # treatment - control
opp_perm

ggplot(opp_perm, aes(x = diff_perm)) + 
  geom_histogram(binwidth = .005) +
  geom_vline(aes(xintercept = diff_orig), col = "red")

# p-value, or the proportion of permuted differences less than or
# equal to the observed difference.
# 
# Conclusion is we can confidently say the different messaging
# caused the students to change their buying habits, since they
# were randomly assigned to treatment and control groups.
# 
opp_perm %>% summarize(onesided.pvalue = mean(diff_perm <= diff_orig))

opp_perm %>% summarize(twosided.pvalue = 2 * mean(diff_perm <= diff_orig))

# ERRORS IN HYPOTHESIS TESTING.
# 
#                 +-----------------------+-------------------+
#                 |   Don't reject H_0    |     Reject H_0    |
# +---------------|-----------------------+-------------------+
# | H_0 is true   |                       |    type I error   |
# |               |                       |                   |
# | H_a is true   |    type II error      |                   |
# +---------------+-----------------------+-------------------+
# 
# type II error: false negative
# type I error: false positive
# 
# Here, if you always claim there is a difference in proportions,
# you'll always reject the null hypothesis, so you'll only make
# type I errors, if any.
# In other words, always rejecting H_0 will cease type II errors.
# 
# Moreover,
# 
# Type I: There is a difference in proportions, and the observed
# difference is big enough to indicate that the proportions are
# different.
# 
# Type II: There is not a difference in proportions, and the
# observed difference is not large enough to indicate that the
# proportions are different.
# 



# PARAMETERS AND CONFIDENCE INTERVALS.
# 
# Research questions examples.
# 
# Hypothesis test (comparative): 
# - under which diet plan will participants lose more weight on avg?
# - which of two car manufacturers more likely to recommend to friends?
# - are education level and avg income linearly related?
# 
# Confidence interval (estimation):
# - how much should participants expect to lose on avg?
# - what % of users are likely to recommend Subaru to friends?
# - for each additional year of education what is predicted income?
# 
# 
# Confidence interval.
# "We are 95% sure that between 12% and 34% of US population
# recommends Subaru."
# 
# The population parameter has to do with *all* the population.
#


# BOOTSTRAPPING: resampling with replacement.
# 
# Variability of p-hat from the population.
# 
# Typically the researcher has only one sample from the population.
# Turns out bootstrapping several re-samples (with repetition, 
# of course) from the sample yields awesome results.
# Actually, we know the size of the sample we need to have to give
# a certain standard deviation.
# 
# Goal here is to find the parameter when all we have is the statistic,
# never knowing whether the sample really contains the true parameter.
# 
# Technical conditions apply:
# - Sampling distribution of the statistic is reasonably symmetric and
#   bell-shaped.
# - Sample size is reasonably large.
# 

samp = data.frame(a = rbinom(50, size = 100, prob = 0.3))
head(samp)

samp_boot = samp %>% rep_sample_n(10, replace = T, reps = 5000)
head(samp_boot)

props = samp_boot %>% summarize(prop_yes = mean(a)) # p-hat.
head(props)

props %>% summarize(sd(prop_yes)) # sd of p-hat.

# Distribution of p-hat.
# 
# Approximately 95% of samples will produce p-hats within ±2 sd,
# in other words 95% confident that the true parameter is within
# the calculated confidence interval.
# 
ggplot() + 
  geom_density(
    data = props, 
    aes(x = prop_yes), 
    col = "blue", 
    bw = .1
  )

props %>%
  mutate(lower = 30 - 2 * sd(prop_yes),
         upper = 30 + 2 * sd(prop_yes),
         in_CI = prop_yes > lower & prop_yes < upper) %>%
  summarize(mean(in_CI))

props %>% 
  summarize(
    q025 = quantile(prop_yes, 0.025),
    q925 = quantile(prop_yes, 0.975)
  )
