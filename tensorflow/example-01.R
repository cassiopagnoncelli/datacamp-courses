library('tensorflow')

tf_config()

##
## First session.
##

# Create your session
sess <- tf$Session()

# Define a constant (you'll learn this next!)
HiThere <- tf$constant('Hi DataCamp Student!')

# Run your session with the HiThere constant
print(sess$run(HiThere))

# Close the session
sess$close()

##
## Constants, variables.
##

# Constants.
a <- tf$constant(3)
b <- tf$constant(7)
a + b
a * b

# Vars.
tf$Variable('initial value', 'optional name')

EmptyMatrix <- tf$Variable(tf$zeros(shape(4, 3)))

# Placeholders.
# Just like variables, but will assign data at later stage.
# Used when we know the shape of the tensor, but will use data from a previous
# pipeline execution (or an external source).
# tf$placeholder...

# Create two constant tensors
myfirstconstanttensor <- tf$constant(152)
mysecondconstanttensor <- tf$constant('I am a tensor master!')

# Create a matrix of zeros
myfirstvariabletensor <- tf$Variable(tf$zeros(shape(5, 1)))

##
## Tensor Board.
## See in browser the behind the scenes of the model.
tensorboard('/tmp/tensorboard')

a <- tf$constant(5, name = 'NumAdults')
b <- tf$constant(6, name = 'NumChildren')
c <- tf$add(a, b)
print(sess$run(c))

write_graph <- tf$summary$SummaryWriter('./graphs', sess$graph)
tensorboard(log_dir = './graphs')


# Set up your session
EmployeeSession <- tf$Session()

# Add your constants
female <- tf$constant(150, name = 'FemaleEmployees')
male <- tf$constant(135, name = 'MaleEmployees')
total <- tf$add(female, male)
print(EmployeeSession$run(total))

# Write to file
towrite <- tf$summary$FileWriter('./graphs', EmployeeSession$graph)

# Open Tensorboard
tensorboard(log_dir = './graphs')