# explore dataset
names(premium)
head(premium)

# premium business models
premium_model <- premium
premium_model$SONGS_PLAYED <- premium$ACTIVITY_RATE * premium$HOURS_PER_MONTH / premium$SONG_LENGTH
premium_model$REV_SUBSCRIPTION <- premium$ACTIVITY_RATE * premium$REV_PER_SUBSCRIBER
premium_model$COST_SONG_PLAYED <- premium_model$SONGS_PLAYED * premium$COST_PER_SONG

# inspect results
head(premium_model)
