require_relative 'editor'
class EditPage < SitePrism::Page
  element :save_button,            '.mercury-save-button'
  element :publish_button,         '.mercury-publish-button'
  element :confirm_publish_button, 'form.edit_page input.btn-primary'

  set_url "/editor{/slug}"

  iframe :editor, Editor, '#mercury_iframe'

  def edit_content(content="")
    wait_for_editor(5)
    e = Editable.new(page, '#editable')
    e.execute_script <<-JAVASCRIPT
      var region = document.getElementById('mercury_iframe').contentDocument.getElementById('editable1');
      region.innerHTML = '#{content}';
    JAVASCRIPT
    save_button.click
    publish_button.click
    wait_for_confirm_publish_button
  end

  def publish_changes
    confirm_publish_button.click
    wait_until_confirm_publish_button_invisible
    wait_for_editor(5)
  end

end
