require_relative 'pages/edit_page.rb'

class App
  def initialize
    Capybara.default_driver = :selenium
  end

  def edit_page
    EditPage.new
  end
end
