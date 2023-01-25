# Require class ruby files
require "./car"
require "./rental"
require "./option"
require "./json_methods"

# cars array containing all cars objects
cars = Car.cars_list

# options array containing all options objects
options = Option.options_list

# Building json output with filepath and rentals_list containing all rentals objects
JsonMethods.json_output('data/output.json', Rental.rentals_list(cars, options))
