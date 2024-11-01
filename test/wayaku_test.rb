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
  def test_wayaku_enum_with_wrong_argment
    assert_output(<<~TEXT) { User.wayaku_enum(:hoge) }
      \e[43m何も見つかりませんでした\e[0m
    TEXT
  end

  def test_wayaku_enum_with_right_argment
    binding.pry
    assert_equal(<<~TEXT, User.wayaku_enum(:status))
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
end