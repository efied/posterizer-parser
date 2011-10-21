require 'spec_helper'
require 'yaml'

describe PosterousParser do

  before(:each) do
    @template = <<-INPUT
    <body>
      <div id="header-container">
        <div id="header">
          {block:HeaderImage}
          <a href="{BlogURL}" class="author-image"><img src="{HeaderImageURL}" alt="{Title}"/><span></span></a>
          {/block:HeaderImage}
          <h1 class="site-name"><a href="{BlogURL}">{Title}</a></h1>
          <p class="site-description">{Description}</p>
        </div>
      </div>
      {block:HasPages}
      <div id="pages-container">
        <div id="pages">
          <ul>
            {block:Pages}
            <li><a href="{URL}" title="{Label}" class="{Current}">{Label}</a></li>
            {/block:Pages}
          </ul>
        </div>
      </div>
      {/block:HasPages}
    INPUT
  end

  it "strips all html content and returns posterous tags in array" do

    PosterousParser.get_tags(@template)[0].should == '{block:HeaderImage}'
    PosterousParser.get_tags(@template)[2].should == '{HeaderImageURL}'
    PosterousParser.get_tags(@template)[8].should == '{block:HasPages}'

  end

  it "identifies the right tag types for tags" do

    opening_block = '{block:Posts}'
    closing_block = '{/block:Posts}'

    PosterousParser.is_closing_block?(opening_block).should == false
    PosterousParser.is_closing_block?(closing_block).should == true
    PosterousParser.is_opening_block?(closing_block).should == false

  end

  it "builds a parse tree from tags" do

    tags = PosterousParser.get_tags(@template)
    template_tree = PosterousParser.parse_into_tree(tags)
    template_tree["{block:HasPages}"]["{block:Pages}"]["{URL}"].name.should == "{URL}"
    template_tree["{block:HasPages}"]["{block:Pages}"]["{URL}"].content.should == "template/{block:HasPages}/{block:Pages}/{URL}"

  end

  it "checks for ancestry" do

    tags = PosterousParser.get_tags(@template)
    template_tree = PosterousParser.parse_into_tree(tags)
    ancestor = template_tree["{block:HasPages}"]
    element = template_tree["{block:HasPages}"]["{block:Pages}"]["{Current}"]
    PosterousParser.has_ancestor(ancestor, element).should == true

  end

  it "reads values from the template.yml" do
    data = YAML::load(File.open(File.join("#{File.dirname(__FILE__)}", "..", "posterous", "template.yml")))
    PosterousParser.get_value("template/{block:HasPages}/{block:Pages}/{URL}", data).should == "http://www.example.com"
  end

end
