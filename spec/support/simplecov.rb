require 'simplecov'

SimpleCov.start 'rails' do
  minimum_coverage 90
  refuse_coverage_drop

  add_filter %r{^/(?!app|lib)/}
  add_filter %r{^/app/channels/}
end