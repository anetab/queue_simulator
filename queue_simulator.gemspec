Gem::Specification.new do |s|
  s.name        = 'queue_simulator'
  s.version     = '0.0.1'
  s.date        = '2012-08-08'
  s.summary     = "Queue Simulator"
  s.description = "Queue Simulator for Libramon monitor"
  s.authors     = ["Aneta Barbos", "Christoph Mertz"]
  s.email       = 'aneta.barbos@kaeuferportal.de'
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = "https://github.com/anetab/queue_simulator"
  s.add_dependency('redis')
end
