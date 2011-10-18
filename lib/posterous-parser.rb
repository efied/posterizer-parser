require 'tree.rb'
include Tree

class PosterousParser

  def self.parse(template)
    tags = get_tags(template)
    template_tree = parse_into_tree(tags).print_tree
  end

  def self.parse_into_tree(tags)
    # some sweet tree action
    parse_tree = TreeNode.new("template", "content")
    current_node = parse_tree
    tags.each do |tag|
      if is_opening_block?(tag)
        current_node << TreeNode.new(tag, "content")
        current_node = current_node[tag]
      elsif is_closing_block?(tag)
        current_node = current_node.parent
      else
        current_node << TreeNode.new(tag, "content")
      end
    end
    parse_tree
  end

  def self.get_tags(template)
    template.scan /\{.*?\}/ # todo: escape the html
  end

  def self.is_opening_block?(tag)
    tag =~ /\{block:[^\/]*?\}/ ? true : false
  end

  def self.is_closing_block?(tag)
    tag =~ /\{\/block:.*?\}/ ? true : false
  end

end
