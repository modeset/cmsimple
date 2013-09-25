require_relative 'editable'
class Editor < SitePrism::Page
  section :editable, Editable, '#editable1'
end
