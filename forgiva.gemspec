Gem::Specification.new do |gem|
  gem.name        = 'forgiva'
  gem.version     = '1.0.1.4'
  gem.date        = '2016-10-03'

  gem.summary     = 'Forgiva'
  gem.description = 'The new-age password manager.'
  gem.authors     = ['Harun Esur']
  gem.email       = 'root@sceptive.com'
  gem.homepage    = 'https://www.forgiva.com'
  gem.license     = 'CC NC-SA 4.0'
  gem.requirements << 'Ruby should be compiled with openssl support.'

  gem.executables << 'forgiva'

  gem.files = `git ls-files`.split("\n")

  gem.add_runtime_dependency 'highline', '~> 1.6', '>= 1.6.20'
  gem.add_runtime_dependency 'scrypt'


  gem.add_development_dependency 'rubocop', '~> 0.26'
end
