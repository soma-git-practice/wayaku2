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
    skip 'after physicals'
    assert_output(<<~TEXT) { User.wayaku(bool: false) }
      ユーザー
      user
          ID
          id
          名前
          name
          ステータス
          status
              寝ている
              sleeping
              働いている
              working
              謎に包まれている
              mystery
    TEXT
  end

  def test_wayaku_enum_with_right_argment
    skip 'after wayaku'
    assert_output(<<~TEXT) { User.wayaku_enum(:status, bool: false) }
      ステータス
      status
          寝ている
          sleeping
          働いている
          working
          謎に包まれている
          mystery
    TEXT
  end

  def test_wayaku_enum_with_wrong_argment
    skip 'after wayaku'
    assert_output("\e[38;5;196m知らない属性\e[0m\n") { User.wayaku_enum(:hoge, bool: false) }
  end

  def test_wayaku_logicals
    assert_output(<<~TEXT) { User.wayaku_logicals }
      \e[38;5;2mID\e[0m
      \e[38;5;2m名前\e[0m
      \e[38;5;2mステータス\e[0m
          \e[38;5;3m寝ている\e[0m
          \e[38;5;3m働いている\e[0m
          \e[38;5;3m謎に包まれている\e[0m
    TEXT
  end

  def test_wayaku_physicals
    skip 'after logicals'
    assert_output(<<~TEXT) { User.wayaku_physicals }
      id
      name
      status
          sleeping
          working
          mystery
    TEXT
  end
end
