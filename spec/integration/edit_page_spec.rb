require 'spec_helper'
require_relative 'app'

describe 'Editing A CMSimple Page', js: true do
  let(:slug)      { 'about' }
  let(:app)       { App.new }
  let!(:cms_page) { Cmsimple::Page.create!(title: "About", slug: slug, is_root: true)}

  before do
    cms_page.publish!
  end

  it 'creates a new page' do
    app.edit_page.load
    app.edit_page.create_new_page(slug: 'contact', title: 'Contact')
    expect(Cmsimple::Page.where(slug: 'contact')).to_not be_empty
  end

  it 'should update the page metadata' do
    app.edit_page.load(slug: slug)
    app.edit_page.update_page_info(slug: 'about_us')
    expect(cms_page.reload.slug).to eq('about_us')
  end

  it 'should edit content on the page' do
    EditPage.set_url_matcher %r{/editor/#{slug}}
    app.edit_page.load(slug: slug)
    app.edit_page.edit_content("foo")
    app.edit_page.publish_changes
    expect(cms_page.reload.content['editable1']['value']).to include('foo')
  end

end

