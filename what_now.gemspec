Gem::Specification.new do |s|
  s.name        = 'what_now'
  s.version     = '0.0.3'
  s.date        = '2014-02-27'
  s.summary     = 'Find todo comments in your code'
  s.description = 'Executable for finding todo comments on directories'
  s.authors     = ['Edgar Cabrera']
  s.email       = 'edgar@cafeinacode.com'
  s.license			= 'MIT'
  s.homepage    = 'https://github.com/aleandros/what_now'
  s.files       = %w(what_now.gemspec LICENSE README.md)
  s.files       += Dir['lib/*.rb'] + Dir['bin/*']
  s.test_files  = Dir['spec/*']
  s.executables << 'wnow'

  s.add_dependency 'thor'
  s.add_dependency 'colorize'
  s.add_dependency 'ptools'

  s.add_development_dependency 'minitest-reporters'
  s.add_development_dependency 'rake'
end
