## Installation

Add this line to your Gemfile:

    gem 'wayaku', '~> 0.1.2'

And then execute:

    $ bundle

## set_up

#### migration

```ruby
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :status
    end
  end
end
```

#### model

```ruby
class User < ActiveRecord::Base
  extend Enumerize
  enumerize :status, in: %i[sleeping working mystery]
end
```

#### locale

```yml
ja:
  activerecord:
    models:
      user: ユーザー
    attributes:
      user:
        id: ID
        name: 名前
        status: ステータス

  enumerize:
    user:
      status:
        sleeping: 寝ている
        working: 働いている
        mystery: 謎に包まれている
```

## Usage

how to use in rails console.

#### User.wayaku

```yml
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
```

#### User.wayaku_enum(:status)

```yml
ステータス
status
  寝ている
  sleeping
  働いている
  working
  謎に包まれている
  mystery
```

#### User.wayaku_logicals

```yml
ID
名前
ステータス
  寝ている
  働いている
  謎に包まれている
```

#### User.wayaku_physicals

```yml
id
name
status
  sleeping
  working
  mystery
```

## Development

how to run test code.

    bundle exec rake test TESTOPTS='-v'
