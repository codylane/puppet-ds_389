# This must be here according to https://tickets.puppetlabs.com/browse/PDK-916
RSpec.configure do |c|
  # to avoid this deprecation warning
  # puppetlabs_spec_helper: defaults `mock_with` to `:mocha`. See https://github.com/puppetlabs/puppetlabs_spec_helper#mock_with to choose a sensible value for you
  c.mock_with :rspec
end

require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts

default_facts = {
  puppetversion: Puppet.version,
  facterversion: Facter.version,
}

default_facts_path = File.expand_path(File.join(File.dirname(__FILE__), 'default_facts.yml'))
default_module_facts_path = File.expand_path(File.join(File.dirname(__FILE__), 'default_module_facts.yml'))

if File.exist?(default_facts_path) && File.readable?(default_facts_path)
  default_facts.merge!(YAML.safe_load(File.read(default_facts_path)))
end

if File.exist?(default_module_facts_path) && File.readable?(default_module_facts_path)
  default_facts.merge!(YAML.safe_load(File.read(default_module_facts_path)))
end

RSpec.configure do |c|
  c.default_facts = default_facts
  c.after(:suite) do
    RSpec::Puppet::Coverage.report!
  end
end
