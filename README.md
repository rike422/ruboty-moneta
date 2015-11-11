# Ruboty::Moneta

Store Ruboty's memory in backend via [moneta](https://github.com/minad/moneta).


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruboty-moneta'
```

## Usage

### setting moneta backend

please setting [backend_type](https://github.com/minad/moneta#supported-backends) to MONETA_BACKEND


```shell
 MONETA_BACKEND="{backend_type}"
```

### setting initialize options

please setting [options](http://www.rubydoc.info/gems/moneta/Moneta/Adapters)

MONETA_#{バックエンドの形式}_{initialize時のoptionパラメータに渡したいキー名}で
指定してください。

Sqlite3のfileパラメータを指定したいときは下記のようになります。

```shell
 # MONETA_#{Backend}_#{Options Hash}
 MONETA_SQLITE_FILE = "{file path}"
```

### example

#### use memory

```ruby
gem 'ruboty-moneta'
```

#### use File

```ruby
gem 'ruboty-moneta'
```

```shell
MONETA_BACKEND="File"
MONETA_FILE_DIR="./db"
```

#### use Sqlite

```ruby
gem 'ruboty-moneta'
gem 'sqlite3'
```

```shell
MONETA_BACKEND="Sqlite"
MONETA_SQLITE_FILE="./ruboty.db"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rike422/ruboty-moneta. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
