require 'spec_helper'

describe PosterousParser do

  it "strips all html content and returns posterous tags in array" do
    PosterousParser.get_tags_only('{block:HeaderImage}<a href="{BlogURL}"></a>{/block:HeaderImage}').should \
      == ['{block:HeaderImage}', '{BlogURL}', '{/block:HeaderImage}']
  end

end
