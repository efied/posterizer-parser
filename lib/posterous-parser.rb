require File.join("#{File.dirname(__FILE__)}", "..", "vendor", "lib", "tree.rb")
include Tree

class PosterousParser

  def self.parse(template)
    tags = get_tags(template)
    template_tree = parse_into_tree(tags)
  end

  def self.parse_into_tree(tags)
    # some sweet tree action
    parse_tree = TreeNode.new("template")
    current_node = parse_tree
    tags.each do |tag|
      if is_opening_block?(tag)
        node_content = generate_node_path(current_node, tag)
        current_node << TreeNode.new(tag, node_content)
        current_node = current_node[tag]
      elsif is_closing_block?(tag)
        current_node = current_node.parent
      else
        node_content = generate_node_path(current_node, tag)
        current_node << TreeNode.new(tag, node_content)
      end
    end
    parse_tree
  end

  def self.generate_node_path(node, tag)
    if is_root_node?(node)
      return ""
    else
      # create the parentage string in a path format
      return node.parentage.map {|p_node| p_node.name}.reverse.join("/") + "/#{node.name}/#{tag}"
    end
  end

  def self.is_root_node?(node)
    node.parentage ? false : true
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
