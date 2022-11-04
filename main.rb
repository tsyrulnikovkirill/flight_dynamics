require_relative 'lib/atmosphere_parameters'

height = STDIN.gets.to_i
atmosphere_parameters = AtmosphereParameters.new(height)

puts atmosphere_parameters.show
