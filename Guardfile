notification :tmux,
  :display_message => true,
  :timeout => 3 # in seconds

# ignore /doc/

guard 'rspec', cmd: "bundle exec rspec --color --format p", all_after_pass: true do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})               { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')            { 'spec' }
  watch('spec/factories.rb')              { 'spec' }
  watch(%r{^spec/factories/(.+)\.rb})     { 'spec' }
  watch(%r{^spec/support/(.+)\.rb})  { |m| "spec/svm_helper/#{m[1]}s/*" }
end

# guard 'yard' do
#   watch(%r{lib/.+\.rb})
# end
