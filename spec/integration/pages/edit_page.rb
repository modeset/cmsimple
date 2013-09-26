require_relative 'editor'
require_relative 'edit_page_actions'

class EditPage < SitePrism::Page
  include EditPageActions

  set_url "/editor{/slug}"

  element :save_button,            '.mercury-save-button'
  element :publish_button,         '.mercury-publish-button'
  element :sitemap_button,         '.mercury-sitemap-button'
  element :page_info_button,       '.mercury-editMetadata-button'
  element :confirm_publish_button, 'form.edit_page input.btn-primary'

  iframe   :editor,         Editor,       '#mercury_iframe'

  section  :new_page_form,  PageForm,     '#new_page'
  section  :edit_page_form, PageForm,     'form'
  sections :mercury_panels, MercuryPanel, '.mercury-panel'

end

