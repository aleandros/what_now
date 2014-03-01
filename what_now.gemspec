Gem::Specification.new do |s|
  s.name        = 'what_now'
  s.version     = '0.0.1'
  s.date        = '2014-02-27'
  s.summary     = 'Find todo comments in your code'
  s.description = 'Executable for finding todo comments on directories'
  s.authors     = ['Edgar Cabrera']
  s.email       = 'edgar@cafeinacode.com'
  s.license			= 'MIT'
  s.homepage    = 'https://github.com/aleandros/what_now'
  s.files       = Dir['lib/*.rb'] + Dir['bin/*']
  s.executables << 'wnow'
end
