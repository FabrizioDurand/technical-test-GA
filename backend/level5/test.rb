require_relative "main"

# Reading the json excepcted output file and parsing it into a hash
expected_output = JSON.parse(File.read('data/expected_output.json'))

# Reading the json output file created and parsing it into a hash
output = JSON.parse(File.read('data/output.json'))

# Comparing the two files and print if they are equal or not
if expected_output == output
  p "Test validated! The expected_output and output json files are equal"
else
  p "Test not validated! The expected_output and output json files are not equal"
end
