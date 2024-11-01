# frozen_string_literal: true

module Wayaku
  autoload :VERSION, 'lib/wayaku/version'

  if const_get :ActiveRecord
    extend_object ActiveRecord::Base
  end

  def wayaku_enum(attr)
    if respond_to?(:enumerize) && enumerized_attributes[attr].nil?
      puts no_result
      return
    end
    text  = human_attribute_name(attr) + "\n"
    text += attr.to_s + "\n"
    enumerized_attributes[attr].values.each do |value|
      text += "\s\s#{value.text}\n"
      text += "\s\s#{value}\n"
    end
    text
  end

  private

  def no_result
    "\e[43m何も見つかりませんでした\e[0m"
  end
end
