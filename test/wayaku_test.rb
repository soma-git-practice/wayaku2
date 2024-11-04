require_relative 'test_helper'

I18n.load_path = [File.dirname(__FILE__) + '/test_data/ja.yml']
I18n.locale = :ja

class User < ActiveRecord::Base
  establish_connection adapter: "sqlite3", database: ':memory:'
  self.logger = ::Logger.new(STDOUT, level: Logger::DEBUG)

  connection.create_table table_name do |t|
    t.string :name
    t.string :status
  end unless table_exists?

  extend Enumerize
  enumerize :status, in: [:sleeping, :working, :mystery]
end

class WayakuTest < Minitest::Test
  def test_wayaku
    assert_output(<<~TEXT) { User.wayaku(color: false) }
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

  def test_wayaku_enum
    assert_output(<<~TEXT) { User.wayaku_enum(:status, color:false) }
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

  def test_wayaku_logicals
    skip '未完成'
    assert_output(<<~TEXT) { User.wayaku_logicals }
      ユーザー
        ID
        名前
        ステータス
          寝ている
          働いている
          謎に包まれている
    TEXT
  end

  def test_wayaku_physicals
    skip '未完成'
    assert_output(<<~TEXT) { User.wayaku_physicals }
      user
        id
        name
        status
          sleeping
          working
          mystery
    TEXT
  end

  # TODO 削除する
  def test_get_attribute_with_right_symbol
    assert_equal(['ステータス', 'status'], User.get_attribute(:status))
  end

  def test_get_attribute_with_wrong_symbol
    assert_equal([], User.get_attribute(:hoge))
  end

  def test_get_attribute_with_array
    assert_equal(['ID','id','名前','name','ステータス','status'], User.get_attribute(User.column_names))
  end
end