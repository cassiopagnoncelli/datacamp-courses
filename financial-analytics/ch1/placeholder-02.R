# explore dataset
names(premium)
head(premium)

# premium business models
premium_model <- premium
premium_model$SONGS_PLAYED <- premium$ACTIVITY_RATE * premium$HOURS_PER_MONTH / premium$___
premium_model$REV_SUBSCRIPTION <- premium$___ * premium$REV_PER_SUBSCRIBER
premium_model$COST_SONG_PLAYED <- premium_model$___ * premium$COST_PER_SONG

# inspect results
head(___)
