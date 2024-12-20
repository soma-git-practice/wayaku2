# frozen_string_literal: true

module Wayaku
  autoload :VERSION, 'lib/wayaku/version'

  extend_object ActiveRecord::Base

  def wayaku
    array = [model_name.human, model_name.singular, parse_attribute(column_names)]
    puts format(array)
  end

  def wayaku_enum(attr)
    unless enumerized_attributes[attr]
      puts "\e[38;5;196m知らない属性\e[0m"
      return
    end
    array = parse_attribute(attr)
    puts format(array)
  end

  def wayaku_logicals
    array = parse_attribute(column_names)
    array = format(array)
    puts array.each_slice(2).map(&:first)
  end

  def wayaku_physicals
    array = parse_attribute(column_names)
    array = format(array)
    puts array.each_slice(2).map(&:second)
  end

  private

  def parse_attribute(args)
    [*args].inject([]) do |array, arg|
      additions = []

      # attribute
      word = I18n.translate(arg, scope: "activerecord.attributes.#{model_name.singular}")
      additions += [word, arg.to_s]

      # enumerized_attribute
      if respond_to?(:enumerize) && enumerized_attributes[arg]
        additions << enumerized_attributes[arg].values.inject([]) { |rst, val| rst + [val.text, val] }
      end

      array + additions
    end
  end

  def format(array)
    array = _add_indent(array).flatten
    array
  end

  def _add_indent(array, indent: 0)
    array.map do |value|
      value.is_a?(Array) ? _add_indent(value, indent: indent + 1) : "\s\s\s\s" * indent + value
    end
  end
end
