Gem::Specification.new do |s|
  s.name = "state_attr"
  s.version = "0.1.12"
  s.date = "2011-05-16"
  s.summary = "Minimalistic state machine approach allowing multiple state attributes at the same time."
  s.email = "mpapis@gmail.com"
  s.homepage = "http://github.com/mpapis/state_attr/tree/master"
  s.description = "Minimalistic state machine."
  s.has_rdoc = false
  s.authors = ["Michal Papis"]
  s.files = [
              "lib/state_attr.rb",
              "lib/state_attr/state.rb",
              "rails/init.rb",
              "Rakefile",
              "README.md",
              "state_attr.gemspec",
              "test/test_helper.rb",
              "test/unit/state_attr_test.rb",
            ]
  #s.add_dependency("rails",["~>2","~>3"])
end
