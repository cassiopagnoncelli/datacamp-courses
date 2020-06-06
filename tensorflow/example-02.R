library('tensorflow')

# Tensor flow has 3 APIs:
# - Core API: low-level to API (written in C++) giving access to all
#             tensorflow features, especially when needed more control.
# - Keras API: high level interface to empower neural network in a more
#              friendly way than Core API.
# - Estimators API: high level implementation to common machine learning
#                   including classifiers and regressors.

# LINEAR REGRESSION.
# Estimate the amount of beer consumption of a given day given daily precipitation.
# 1. First, split dataset into 80/20 for testing.

beer_rows <- sample(1:nrow(beer_consumption), size = 0.8 * nrow(beer_consuption))
beer_consumption_train <- beer_consumption[beer_rows,]
beer_consumtpion_test <- beer_consumption[-beer_rows,]

x_actual <- beer_consumption_train$precip
y_actual <- beer_consumption_train$beer_consumed

# Define w, b, y variables from linear regression model y = w*x + b
w <- tf$Variable(tf$random_uniform(shape(1L), -1, 1))
b <- tf$Variable(tf$zeros(shape(1L)))

y_predict <- w * x_data + b


# Another lm model.

# Define your w variable
w <- tf$Variable(tf$random_uniform(shape(1L), -1.0, 1.0))

# Define your b variable
b <- tf$Variable(tf$zeros(shape(1L)))

# Define your linear equation
y <- w * x_data + b

# STEP 2.
# Now we have to define a cost/loss function.
# There are plenty: MSE, gradient descent, etc.
loss <- tf$reduce_mean((y_predict - y_actual)^2)

optimizer <- tf$train$GradientDescentOptimizer(0.001)

train <- optimizer$minimize(loss)

final_grades_session <- tf$Session()
final_grades_session$run(tf$global_variables_initializer())

# Training a linear regression model
train <- optimizer(minimize(loss))

for (step in 1:2000) {
  sess$run(train)
  if (step %% 500 == 0)
    cat("Step = ", step, 'Estimate w = ', sess$run(w), 'Estimate b = ', sess$run(b))
}

beer_actualconsumption <- beer_consumption_test$beer_consumed
beer_predictedconsumption <- sess$run(w) * beer_consumption_test$precip + sess$run(b)
plot(beer_actualconsumption, beer_predictedconsumption)
lines(beer_actualconsumption, beer_actualconsumption)

meandiff <- data.frame(cbind(beer_actualconsumption, beer_predictedconsumption))
correlation_accuracy <- cor(meandiff)
correlation_accuracy


# Another model.
# Calculate the predicted grades
grades_actual <- studentgradeprediction_test$Finalpercent
grades_predicted <- as.vector(Finalgradessession$run(w)) * 
  studentgradeprediction_test$minstudytime +
  as.vector(Finalgradessession$run(b))

# Plot the actual and predicted grades
plot(grades_actual, grades_predicted, pch=19, col='red')

# Run a correlation 
cor(grades_actual, grades_predicted)