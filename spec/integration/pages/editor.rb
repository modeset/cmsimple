class Editable < SitePrism::Section
end

class Editor < SitePrism::Page
  section :editable, Editable, '#editable1'
end

class MercuryPanel < SitePrism::Section
  element :submit_button, '.btn-primary'
end

class PageForm < SitePrism::Section
  element :title,         '#page_title'
  element :slug,          '#page_slug'
  element :submit_button, '.btn-primary'
end

