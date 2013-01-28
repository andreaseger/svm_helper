guard 'rspec', cli: "--color --format p", all_after_pass: false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/svm_helper/(.+)\.rb$})               { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')            { 'spec' }
  watch('spec/factories.rb')              { 'spec' }
  watch(%r{^spec/factories/(.+)\.rb})     { 'spec' }
  watch(%r{^spec/support/(.+)_spec\.rb})  { |m| "spec/#{m[1]}s/*" }
end

notification :tmux,
  :display_message => true,
  :timeout => 3 # in seconds

guard 'yard' do
  watch(%r{lib/.+\.rb})
end
