# So I can call "Pages.identity_stub" to return me a
# new page object LoginPage


module Pages
  extend Capybara::DSL

module_function

  # This will read the file from the pages directory
  # strip them to just the file name and then define
  # them as methods on the Pages module. In turn when
  # the method is called it will return the instantiated
  # PageObject. So if we add files to the pages directory
  # they will automatically be picked up by this method
  Dir[File.join('.', 'features/support/pages/*_page.rb')].each do |f|
    file_name = File.basename(f, '.*')
    method_name = file_name.chomp('_page')
    define_method(method_name) do
      return instance_variable_get(:"@#{method_name}") if instance_variable_defined?(:"@#{method_name}")

      instance_variable_set(:"@#{method_name}", file_name.classify.constantize.new)
    end
  end
end