require 'spec_helper'
require 'yaml'

describe PosterousParser do

  let(:template) do
    <<-INPUT
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

    PosterousParser.get_tags(template)[0].should == '{block:HeaderImage}'
    PosterousParser.get_tags(template)[2].should == '{HeaderImageURL}'
    PosterousParser.get_tags(template)[8].should == '{block:HasPages}'

  end

  it "identifies the right tag types for tags" do

    opening_block = '{block:Posts}'
    closing_block = '{/block:Posts}'

    PosterousParser.is_closing_block?(opening_block).should == false
    PosterousParser.is_opening_block?(opening_block).should == true
    PosterousParser.is_closing_block?(closing_block).should == true
    PosterousParser.is_opening_block?(closing_block).should == false

  end

  it "cleans up posterous tag syntax returns just the tag contents" do

    # we're only testing for opening blocks and elements
    PosterousParser.clean_me("{block:Posts}").should == "Posts"
    PosterousParser.clean_me("{Element}").should == "Element"
    PosterousParser.clean_me("template/{HasPages}/{Pages}/{URL}").should == "HasPages/Pages/URL"

  end

  it "builds a parse tree from tags" do

    template_tree = PosterousParser.parse_into_tree(PosterousParser.get_tags(template))
    template_tree["{block:HasPages}"]["{block:Pages}"]["{URL}"].name.should == "{URL}"
    template_tree["{block:HasPages}"]["{block:Pages}"]["{URL}"].content.should == "HasPages/Pages/URL"

  end

  it "strips parameters from tags" do
    clean_tag = PosterousParser.remove_params("{block:PostLocation uniq_by='summary'}")
    clean_tag.should == "{block:PostLocation}"
  end

  # it "checks for ancestry" do

  #   template_tree = PosterousParser.parse_into_tree(PosterousParser.get_tags(template))
  #   ancestor = template_tree["{block:HasPages}"]
  #   element = template_tree["{block:HasPages}"]["{block:Pages}"]["{Current}"]
  #   PosterousParser.has_ancestor?(ancestor, element).should == true

  # end

  # it "reads values from the template.yml" do
  #
  #   data = YAML::load(File.open(File.join("#{File.dirname(__FILE__)}", "..", "posterous", "template.yml")))
  #   PosterousParser.get_value("template/HasPages/Pages/URL", data).should == "http://www.example.com"
  #
  # end

end
