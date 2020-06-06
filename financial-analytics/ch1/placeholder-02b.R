# explore dataset
names(freemium)
head(freemium)

# freemium business models
freemium_model <- freemium
freemium_model$SONGS_PLAYED <- freemium$ACTIVITY_RATE * freemium$___ * freemium$PROP_MUSIC / freemium$SONG_LENGTH
freemium_model$ADS_PLAYED <- freemium$ACTIVITY_RATE * freemium$HOURS_PER_MONTH * (1-freemium$___) / freemium$AD_LENGTH
freemium_model$REV_AD_PLAYED <- freemium_model$ADS_PLAYED * freemium$___
freemium_model$COST_SONG_PLAYED <- freemium_model$SONGS_PLAYED * freemium$COST_PER_SONG

# examine output
head(freemium_model)
