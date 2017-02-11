require 'rubygems'
require 'vcr'

VCR.configure do |c|
  c.ignore_hosts '127.0.0.1', 'localhost'
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
end
