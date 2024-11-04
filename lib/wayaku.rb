# frozen_string_literal: true

module Wayaku
  autoload :VERSION, 'lib/wayaku/version'

  if const_defined? :ActiveRecord
    extend_object ActiveRecord::Base
  end

  def wayaku(color: true)
    items = _add_indent_recursion(_attribute_index)
    items = items.flatten
    if !!color
      color_switch = _color_switch
      items = items.map{|item| color_switch.call(item) }
    end
    puts items
  end

  def wayaku_enum(attr, color: true)
    unless enumerized_attributes[attr]
      puts "\e[38;5;196m知らない属性\e[0m"
      return
    end
    result = []
    result << human_attribute_name(attr)
    result << attr
    enumerized_attributes[attr].values.each do |value|
      result << "\s\s" + value.text
      result << "\s\s" + value
    end 
    if !!color
      color_switch = _color_switch
      result = result.map{|value| color_switch.call(value) }
    end
    puts result
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

  # TODO プライベートメソッドに移動する
  def get_attribute(args)
    [*args].inject([]) do |rst, arg|
      scope = "activerecord.attributes.#{model_name.singular}"
      word  = I18n.backend.send(:lookup, I18n.locale, arg, scope)
      word.nil? ? rst : rst + [word, arg]
    end
  end

  private

  def _color_switch
    count = 0
    bool  = false
    ->(word) do
      bool  =  !bool if count % 2 == 0
      count += 1

      color = bool ? 114 : 177
      "\e[38;5;#{color}m#{word}\e[0m"
    end
  end

  def _add_indent_recursion(array, indent: 0)
    array.map do |data|
      data.is_a?(Array) ? _add_indent_recursion(data, indent: indent + 1) : "\s\s" * indent + data
    end
  end

  def _attribute_index
    results =  []

    results << model_name.human
    results << model_name.singular
    
    attributes = []
    column_names.each do |item|
      attributes << human_attribute_name(item)
      attributes << item
      if respond_to?(:enumerize) && enumerized_attributes[item]
        enum_attributes = []
        enumerized_attributes[item].values.each do |value|
          enum_attributes << value.text
          enum_attributes << value
        end
        attributes << enum_attributes
      end
    end
    results << attributes.compact
    results
  end
end
