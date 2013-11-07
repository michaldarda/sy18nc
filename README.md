# Sy18nc

Simple tool to synchronize Rails .ymls with locales.

## Installation

Add this line to your application's Gemfile:

    gem 'sy18nc', '~> 0.0.2'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sy18nc

## Auto mode

If you are using this gem with Rails app, you may create an initializer under your `config/initializers` named `sy18nc.rb`

This command will create it for you:

    $ rails generate sy18nc:install

Sample initializer looks like this

```ruby
Sy18nc.configure do |c|
  c.base_locale = "en"
  c.locales_dir = "config/locales/"
  c.locales = ["de", "es", "fr", "pl"]
  c.files = ["application", "devise", "doorkeeper"]
end
```

`base_locale` - your base locale, the rest of locales will be synchronized to this one (`en` by default).

`locales_dir` - path to your .ymls with locales (`config/locales` by default).

`locales` - the rest of your locales which you would like to keep in sync with the base one.

`files` - all the files you want to keep in sync with the base one.

`backup` - will save synchronized locales as `.bak` leaving originals untouched (is set to `false` by default).

Then you can execute:

    $ rake sy18nc

It will look for every file in `files` list. For example, for `application` file it will find the `application.en` treating this as base and sync every `application.<lang>` which is listed in `locales` config.

## Manual mode

    sy18nc config/locales/ en.yml ru.yml

Will synchronize the `ru` locale, treating `en` as base.

If run with `-b` or `--backup` option it will add the `.bak` extension to the output files instead of modifying original locale files.

Example:

    sy18nc -b config/locales/ en.yml ru.yml

or:

    sy18nc --backup config/locales/ en.yml ru.yml

## Example

Lets assume we have two locales:

en.yml:

    en:
      application:
        link1: "Hello"
        link2: "Hello"

ru.yml:

    ru:
      application:
        link1: "привет"

Command:

    sy18nc config/locales/ en.yml ru.yml

Will result in:

    ru:
      application:
        link1: "привет"
        link2: "Hello" # FIXME

As you can see, it imported missing locales from base (en.yml in this case) and added useful `# FIXME` notice,
informing you that there is something missing in this locales and you need to fix it.

## Issues

Please post any issues via Github Issues. If you want to contribute, see [Contributing](#contributing).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Licence

MIT Licence. &copy; 2013 Michał Darda <michaldarda@gmail.com>
