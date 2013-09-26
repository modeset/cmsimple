module EditPageActions
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

  def create_new_page(options={})
    @http_method = :post
    wait_for_editor(5)
    sitemap_button.click
    panel = mercury_panels.detect{|x| x.text.match(/Site Map/)}
    panel.submit_button.click
    submit_form(options)
    wait_for_editor(5)
  end

  def update_page_info(options={})
    @http_method = :put
    wait_for_editor(5)
    page_info_button.click
    wait_for_mercury_panels(3)
    # panel = mercury_panels.detect{|x| x.text.match(/Metadata/)}
    submit_form(options)
    wait_for_editor(5)
  end

  def new_page?
    @http_method == :post
  end

  def submit_form(options={})
    _form = new_page? ? 'new_page_form' : 'edit_page_form'
    self.send("wait_for_#{_form}", 3)
    options.each do |element, value|
      code = "self.#{_form}.#{element}.set '#{value}'"
      eval(code)
    end
    self.send(_form).submit_button.click
  end

end
