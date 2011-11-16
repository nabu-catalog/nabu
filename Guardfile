# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'cucumber', :cli => "--profile guard" do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$})          { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }

  # Watch rails files
  # TODO Should we try and be more clever about which features are run?
  watch('config/routes.rb')                          { 'features' }
  watch('app/controllers/application_controller.rb') { 'features' }
  watch(%r{^app/(.+)\.(rb|haml|erb)})                { 'features' }
  watch(%r{^lib/(.+)\.rb})                           { 'features' }
  watch(%r{^app/controllers/(.+)_(controller)\.rb})  { 'features' }
end

guard 'bundler' do
  watch('Gemfile')
end

guard 'rails' do
  watch('Gemfile.lock')
  watch(%r{^(config|lib)/.*})
end


guard 'spork', :cucumber_env => { 'RAILS_ENV' => 'test' }, :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb')
  watch('test/test_helper.rb')
end
