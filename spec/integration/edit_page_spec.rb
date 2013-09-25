require 'spec_helper'

# gives us more visibility in the stack trace in the log if something goes wrong
ActionController::Base.class_eval do
  cattr_accessor :allow_rescue
end

class ActionDispatch::ShowExceptions
  alias __cucumber_orig_call__ call

  def call(env)
    env['action_dispatch.show_exceptions'] = !!ActionController::Base.allow_rescue
    __cucumber_orig_call__(env)
  end
end
ActionController::Base.allow_rescue = true


class Editable < SitePrism::Section
end

class Editor < SitePrism::Page
  section :editable, Editable, '#editable1'
end

class EditPage < SitePrism::Page
  element :save_button,            '.mercury-save-button'
  element :publish_button,         '.mercury-publish-button'
  element :confirm_publish_button, 'form.edit_page input.btn-primary'

  set_url "/editor{/slug}"

  iframe :editor, Editor, '#mercury_iframe'
end

Capybara.default_driver = :selenium

describe 'Editing A CMSimple Page', js: true do
  let(:slug) { 'about' }
  let(:page) { EditPage.new }
  before do
    @cms_page = Cmsimple::Page.create!(title: "About", slug: slug, is_root: true)
    @cms_page.publish!
    EditPage.set_url_matcher %r{/editor/#{slug}}
  end

  it 'should edit content on the page' do
    page.load(slug: slug)
    edit_content(page, "foo")
    assert_content(@cms_page.id, 'foo')
  end
end

def assert_content(page_id, content="", section="editable1")
  page = Cmsimple::Page.where(id: page_id).first
  expect(page.content[section]['value']).to include(content)
end

def edit_content(page,content="")
  page.wait_for_editor(5)
  expect(page).to have_editor
  e = Editable.new(page, '#editable')
  e.execute_script <<-JAVASCRIPT
    var region = document.getElementById('mercury_iframe').contentDocument.getElementById('editable1');
    region.innerHTML = '#{content}';
  JAVASCRIPT
  page.save_button.click
  page.publish_button.click
  page.wait_for_confirm_publish_button
  page.confirm_publish_button.click
  page.wait_until_confirm_publish_button_invisible
  page.wait_for_editor(5)
end
