class PosterousParser

  def self.parse(template)
    template_tree = parse_into_tree(template)
  end

  private

    def self.parse_into_tree(template)
      get_tags_only(template)
      # do more stuff
    end

    def self.get_tags_only(template)
      template.scan /\{.*?\}/ # todo: escape the html
    end

    def self.is_opening_block?(tag)
      tag =~ /\{block:[^\/]*?\}/ ? true : false
    end

    def self.is_closing_block?(tag)
      tag =~ /\{\/block:.*?\}/ ? true : false
    end

    def self.is_one_tag_block?(tag)
      tag =~ /\{block:.*?\/\}/ ? true : false
    end

    def self.is_element?(tag)
      tag =~ /\{[^\/?block:].*?\}/ ? true : false
    end


end
