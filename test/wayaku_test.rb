# frozen_string_literal: true

require_relative 'test_helper'

I18n.load_path = ["#{File.dirname(__FILE__)}/test_data/ja.yml"]
I18n.locale = :ja

class User < ActiveRecord::Base
  establish_connection adapter: 'sqlite3', database: ':memory:'
  self.logger = ::Logger.new($stdout, level: Logger::DEBUG)

  unless table_exists?
    connection.create_table table_name do |t|
      t.string :name
      t.string :status
    end
  end

  extend Enumerize
  enumerize :status, in: %i[sleeping working mystery]
end

class WayakuTest < Minitest::Test
  def test_wayaku
    assert_output(<<~TEXT) { User.wayaku }
      \e[38;5;255mユーザー\e[0m
      \e[38;5;255muser\e[0m
      \e[38;5;2m    ID\e[0m
      \e[38;5;2m    id\e[0m
      \e[38;5;2m    名前\e[0m
      \e[38;5;2m    name\e[0m
      \e[38;5;2m    ステータス\e[0m
      \e[38;5;2m    status\e[0m
      \e[38;5;3m        寝ている\e[0m
      \e[38;5;3m        sleeping\e[0m
      \e[38;5;3m        働いている\e[0m
      \e[38;5;3m        working\e[0m
      \e[38;5;3m        謎に包まれている\e[0m
      \e[38;5;3m        mystery\e[0m
    TEXT
  end

  def test_wayaku_enum_with_right_argment
    assert_output(<<~TEXT) { User.wayaku_enum(:status) }
      \e[38;5;2mステータス\e[0m
      \e[38;5;2mstatus\e[0m
      \e[38;5;3m    寝ている\e[0m
      \e[38;5;3m    sleeping\e[0m
      \e[38;5;3m    働いている\e[0m
      \e[38;5;3m    working\e[0m
      \e[38;5;3m    謎に包まれている\e[0m
      \e[38;5;3m    mystery\e[0m
    TEXT
  end

  def test_wayaku_enum_with_wrong_argment
    assert_output("\e[38;5;196m知らない属性\e[0m\n") { User.wayaku_enum(:hoge) }
  end

  def test_wayaku_logicals
    assert_output(<<~TEXT) { User.wayaku_logicals }
      \e[38;5;2mID\e[0m
      \e[38;5;2m名前\e[0m
      \e[38;5;2mステータス\e[0m
      \e[38;5;3m    寝ている\e[0m
      \e[38;5;3m    働いている\e[0m
      \e[38;5;3m    謎に包まれている\e[0m
    TEXT
  end

  def test_wayaku_physicals
    assert_output(<<~TEXT) { User.wayaku_physicals }
      \e[38;5;2mid\e[0m
      \e[38;5;2mname\e[0m
      \e[38;5;2mstatus\e[0m
      \e[38;5;3m    sleeping\e[0m
      \e[38;5;3m    working\e[0m
      \e[38;5;3m    mystery\e[0m
    TEXT
  end
end
