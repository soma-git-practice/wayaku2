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
      t.string :unknown
    end
  end

  extend Enumerize
  enumerize :status, in: %i[sleeping working mystery]
end

class WayakuTest < Minitest::Test
  def test_wayaku
    assert_output(<<~TEXT) { User.wayaku }
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
          Translation missing: ja.activerecord.attributes.user.unknown
          unknown
    TEXT
  end

  def test_wayaku_enum_with_right_argment
    assert_output(<<~TEXT) { User.wayaku_enum(:status) }
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
    assert_output("\e[38;5;196m知らない属性\e[0m\n") { User.wayaku_enum(:hoge) }
  end

  def test_wayaku_logicals
    assert_output(<<~TEXT) { User.wayaku_logicals }
      ID
      名前
      ステータス
          寝ている
          働いている
          謎に包まれている
      Translation missing: ja.activerecord.attributes.user.unknown
    TEXT
  end

  def test_wayaku_physicals
    assert_output(<<~TEXT) { User.wayaku_physicals }
      id
      name
      status
          sleeping
          working
          mystery
      unknown
    TEXT
  end
end
