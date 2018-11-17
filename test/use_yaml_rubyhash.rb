require 'yaml'
# Example of save as hash to be tried
# write hash out as a YAML file
movies = { Memento: 1, Primer: 4, Ishtar: 1 }
File.write('movies.yml', movies.to_yaml)

# read back in from file
from_file = YAML.load_file('movies.yml')

# use it
from_file[:Memento]
# => 1
from_file[:Primer]
# => 4
