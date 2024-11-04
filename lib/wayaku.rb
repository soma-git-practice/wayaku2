# frozen_string_literal: true

module Wayaku
  autoload :VERSION, 'lib/wayaku/version'

  extend_object ActiveRecord::Base

  def wayaku(bool: true)
    array = [model_name.human, model_name.singular, parse_attribute(column_names)]
    puts bool ? format(array) : format_simply(array)
  end

  def wayaku_enum(attr, bool: true)
    unless enumerized_attributes[attr]
      puts "\e[38;5;196m知らない属性\e[0m"
      return
    end
    array = parse_attribute(attr)
    puts bool ? format(array) : format_simply(array)
  end

  def wayaku_logicals
    puts <<~TEXT
      ユーザー
        ID
        名前
        ステータス
          寝ている
          働いている
          謎に包まれている
    TEXT
  end

  def wayaku_physicals
    puts <<~TEXT
      user
        id
        name
        status
          sleeping
          working
          mystery
    TEXT
  end

  protected

  def parse_attribute(args)
    [*args].inject([]) do |array, arg|
      additions = []
      scope = "activerecord.attributes.#{model_name.singular}"
      word  = I18n.backend.send(:lookup, I18n.locale, arg, scope)
      
      additions += [word, arg.to_s] unless word.nil?

      if respond_to?(:enumerize) && enumerized_attributes[arg]
        additions << enumerized_attributes[arg].values.inject([]) { |rst, val| rst + [val.text, val] }
      end

      array + additions
    end
  end

  def format_simply(array)
    _add_indent(array).flatten
  end

  def format(array)
    array = format_simply(array)
    color_switch = _init_color_switch
    array.map { |value| color_switch.call(value) }
  end

  private

  def _add_indent(array, indent: 0)
    array.map do |value|
      value.is_a?(Array) ? _add_indent(value, indent: indent + 1) : "\s\s" * indent + value
    end
  end

  def _init_color_switch
    count = 0
    bool  = false
    lambda do |word|
      bool = !bool if count.even?
      count += 1

      color = bool ? 114 : 177
      "\e[38;5;#{color}m#{word}\e[0m"
    end
  end
end
