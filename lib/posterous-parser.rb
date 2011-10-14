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
      template.scan(/\{.*?\}/) # todo: escape the html
    end

end
