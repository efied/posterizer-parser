require 'spec_helper'

describe PosterousParser do

  it "strips all html content and returns posterous tags in array" do
    PosterousParser.get_tags('{block:HeaderImage}<a href="{BlogURL}"></a>{/block:HeaderImage}').should \
      == ['{block:HeaderImage}', '{BlogURL}', '{/block:HeaderImage}']
  end

  it "identifies the right tag types for tags" do

    opening_block = '{block:Posts}'
    closing_block = '{/block:Posts}'

    # testing opening_block
    PosterousParser.is_opening_block?(opening_block).should == true
    PosterousParser.is_closing_block?(opening_block).should == false

    # testing closing_block
    PosterousParser.is_closing_block?(closing_block).should == true
    PosterousParser.is_opening_block?(closing_block).should == false

  end

  it "builds a parse tree from tags" do
    template = "{block:Title} {Title} {/block:Title} {block:ShowOrList} {ShortMonth} {Year} {Year} \
    {block:TagList} {block:TagListing} {TagLink} {/block:TagListing} {/block:TagList}"
    tags = PosterousParser.get_tags(template)
    template_tree = PosterousParser.parse_into_tree(tags)
    template_tree["{block:ShowOrList}"]["{block:TagList}"]["{block:TagListing}"]["{TagLink}"].name.should == "{TagLink}"
    template_tree["{block:Title}"]["{Title}"].content.should == "template/{block:Title}/{Title}"
  end

  it "should replace tags in template with content from the YAML file"  do
    pending
  end

end
