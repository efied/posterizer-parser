require 'spec_helper'

describe PosterousParser do

  it "strips all html content and returns posterous tags in array" do
    PosterousParser.instance_eval {get_tags_only('{block:HeaderImage}<a href="{BlogURL}"></a>{/block:HeaderImage}')}.should \
      == ['{block:HeaderImage}', '{BlogURL}', '{/block:HeaderImage}']
  end

  it "identifies the right tag types for tags" do
    opening_block = '{block:Posts}'
    closing_block = '{/block:Posts}'
    single_block = '{block:Responses /}'
    element = '{Body}'

    # testing opening_block
    PosterousParser.instance_eval {is_opening_block?(opening_block)}.should == true
    PosterousParser.instance_eval {is_closing_block?(opening_block)}.should == false
    PosterousParser.instance_eval {is_one_tag_block?(opening_block)}.should == false
    PosterousParser.instance_eval {is_element?(opening_block)}.should == false

    # testing closing_block
    PosterousParser.instance_eval {is_opening_block?(closing_block)}.should == false
    PosterousParser.instance_eval {is_closing_block?(closing_block)}.should == true
    PosterousParser.instance_eval {is_one_tag_block?(closing_block)}.should == false
    PosterousParser.instance_eval {is_element?(closing_block)}.should == false

    # testing single_block
    PosterousParser.instance_eval {is_opening_block?(single_block)}.should == false
    PosterousParser.instance_eval {is_closing_block?(single_block)}.should == false
    PosterousParser.instance_eval {is_one_tag_block?(single_block)}.should == true
    PosterousParser.instance_eval {is_element?(single_block)}.should == false

    # testing element
    PosterousParser.instance_eval {is_opening_block?(element)}.should == false
    PosterousParser.instance_eval {is_closing_block?(element)}.should == false
    PosterousParser.instance_eval {is_one_tag_block?(element)}.should == false
    PosterousParser.instance_eval {is_element?(element)}.should == true


  end

end
