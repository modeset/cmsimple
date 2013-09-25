require 'spec_helper'
require_relative 'app'

describe 'Editing A CMSimple Page', js: true do
  let(:slug)      { 'about' }
  let(:app)       { App.new }
  let!(:cms_page) { Cmsimple::Page.create!(title: "About", slug: slug, is_root: true)}

  before do
    cms_page.publish!
    EditPage.set_url_matcher %r{/editor/#{slug}}
  end

  it 'should edit content on the page' do
    app.edit_page.load(slug: slug)
    app.edit_page.edit_content("foo")
    app.edit_page.publish_changes
    expect(cms_page.reload.content['editable1']['value']).to include('foo')
  end
end

