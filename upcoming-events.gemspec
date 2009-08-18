# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{upcoming-events}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Wynn Netherland"]
  s.date = %q{2009-08-18}
  s.description = %q{Find cool events and things to do.}
  s.email = %q{wynn@squeejee.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown"
  ]
  s.files = [
    ".autotest",
     ".document",
     ".gitignore",
     "LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION.yml",
     "lib/upcoming.rb",
     "lib/upcoming/auth.rb",
     "lib/upcoming/category.rb",
     "lib/upcoming/country.rb",
     "lib/upcoming/event.rb",
     "lib/upcoming/group.rb",
     "lib/upcoming/metro.rb",
     "lib/upcoming/state.rb",
     "lib/upcoming/user.rb",
     "lib/upcoming/venue.rb",
     "lib/upcoming/watchlist.rb",
     "test/fixtures/categories.json",
     "test/fixtures/countries.json",
     "test/fixtures/event.json",
     "test/fixtures/events.json",
     "test/fixtures/new_event.json",
     "test/fixtures/new_event.xml",
     "test/fixtures/saved_event.json",
     "test/fixtures/tagged_event.json",
     "test/fixtures/token.json",
     "test/test_helper.rb",
     "test/upcoming/auth_test.rb",
     "test/upcoming/category_test.rb",
     "test/upcoming/country_test.rb",
     "test/upcoming/event_test.rb"
  ]
  s.homepage = %q{http://github.com/pengwynn/upcoming-events}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Ruby wrapper for the Yahoo! Upcoming API}
  s.test_files = [
    "test/test_helper.rb",
     "test/upcoming/auth_test.rb",
     "test/upcoming/category_test.rb",
     "test/upcoming/country_test.rb",
     "test/upcoming/event_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
