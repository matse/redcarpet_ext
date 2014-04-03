# encoding: utf-8

require 'redcarpet_ext'

describe 'ExtendedMarkdown#parse_link' do
  before(:each) do
    @markdown = RedcarpetExt::ExtendedMarkdown.new
    @good_link1 = 'http://www.example.com "title"|class1 class2 blank nofollow'
    @good_link2 = 'http://www.example.com "title"'
    @good_link3 = 'http://www.example.com'
    @bad_link = ' le.com "tit%%$le"|class1 class2 rel nofollow'
  end
  it 'returns an hash' do
    expect(@markdown.parse_link(@good_link1)).to be_kind_of Hash
  end
  it 'extracts correct attributes (url, title and attributes if given)' do
    expect(@markdown.parse_link(@good_link1)[:url]).to eql 'http://www.example.com'
    expect(@markdown.parse_link(@good_link2)[:url]).to eql 'http://www.example.com'
    expect(@markdown.parse_link(@good_link3)[:url]).to eql 'http://www.example.com'
    expect(@markdown.parse_link(@good_link1)[:title]).to eql 'title'
    expect(@markdown.parse_link(@good_link2)[:title]).to eql 'title'
    expect(@markdown.parse_link(@good_link3)[:title]).to eql nil
    expect(@markdown.parse_link(@good_link1)[:attributes]).to eql %W(class1 class2 blank nofollow)
    expect(@markdown.parse_link(@good_link2)[:attributes]).to eql nil
    expect(@markdown.parse_link(@good_link3)[:attributes]).to eql nil
  end
  it 'ignores malformed links' do
    expect(@markdown.parse_link(@bad_link)).to eql nil
  end
end

describe 'ExtendedMarkdown#parse_attributes' do
  before(:each) do
    @markdown = RedcarpetExt::ExtendedMarkdown.new
    @good_link = 'http://www.example.com "title"|class1 class2 blank nofollow'
    @bad_link = ' le.com "tit%%$le"|class1 class2 rel nofollow'
    @parse_good = @markdown.parse_link(@good_link)
    @parse_bad = @markdown.parse_link(@bad_link)
  end
  it 'returns a Hash' do
    expect(@markdown.parse_attributes(@parse_good[:attributes])).to be_kind_of Hash
  end
end

describe 'ExtendedMarkdown#link' do
  before(:each) do
    @markdown = RedcarpetExt::ExtendedMarkdown.new
    @good_link = 'http://www.example.com "title"|class1 class2 blank nofollow'
    @bad_link = ' le.com "tit%%$le"|class1 class2 rel nofollow'
    @parse_good = @markdown.parse_link(@good_link)
    @parse_bad = @markdown.parse_link(@bad_link)
  end
  it 'returns a nice formed html link' do
    expect(@markdown.link('src', '', 'Linktext')).to eq '<a href="src">Linktext</a>'
    expect(@markdown.link('src', nil, 'Linktext')).to eq '<a href="src">Linktext</a>'
    expect(@markdown.link('src', 'title', 'Linktext')).to eq '<a href="src" title="title">Linktext</a>'
    expect(@markdown.link('http://www.example.com "title"|class1 class2 blank nofollow', '', 'Linktext')).to eq '<a class="class1 class2" href="http://www.example.com" rel="nofollow" target="_blank" title="title">Linktext</a>'
  end
  it 'returns link with GET parameters' do
    expect(@markdown.link('http://www.example.com/foobar?id=212&blah=foo "title"|class1 class2 blank nofollow', '', 'Linktext')).to eq '<a class="class1 class2" href="http://www.example.com/foobar?id=212&amp;blah=foo" rel="nofollow" target="_blank" title="title">Linktext</a>'
  end
  it 'returns link if url has umlauts' do
    expect(@markdown.link('http://www.häuser.eu/Artà "title"|class1 class2 blank nofollow', '', 'Linktext')).to eq '<a class="class1 class2" href="http://www.häuser.eu/Artà" rel="nofollow" target="_blank" title="title">Linktext</a>'
  end
  it 'respects braces ()' do
    expect(@markdown.link('http://de.wikipedia.org/wiki/Petra_(Mallorca) "title"|class1 class2 blank nofollow', '', 'Linktext')).to eq '<a class="class1 class2" href="http://de.wikipedia.org/wiki/Petra_(Mallorca)" rel="nofollow" target="_blank" title="title">Linktext</a>'
  end
end


describe 'ExtendedMarkdown' do
  before(:each) do
    @markdown = Redcarpet::Markdown.new(
      RedcarpetExt::ExtendedMarkdown.new(
        :hard_wrap => true,
        :filter_html => true,
        :safe_links_only => true),
        :no_intraemphasis => true,
        :autolink => true)
  end

  it 'renders good html' do
    foo = @markdown.render <<-EOT
#Überschrift
Lorem ipsum dolor sit amet, consectetur adipisicing elit. Optio, officiis aliquid facilis eligendi esse provident vitae sit laborum maiores illo incidunt consequatur fugiat dicta accusamus ab! Animi, et aut minus!

##Now a link
[Wunderschön](http://www.example.com "this is a title"|class1 nofollow blank)
EOT

  expect(foo).to include '<h1>'
  expect(foo).to include '<h2>'
  expect(foo).to include 'p'
  expect(foo).to include '<a'
  expect(foo).to include 'rel="nofollow"'

  end

end
