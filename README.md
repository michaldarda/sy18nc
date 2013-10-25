# Sy18nc

Simple tool to synchronize Rails .ymls with translations

## Installation

Add this line to your application's Gemfile:

    gem 'sy18nc', '~> 0.0.1'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sy18nc

## Usage

    sy18nc config/locales/en.yml ru.yml

Will synchronize the `ru` locale, treating `en` as base.

**You have the guarantee that this tool will never touch and mess your original (base) translation!**

    sy18nc config/locales/en.yml

Will synchronize all translations in config/locales directory treating the `en.yml` as the base one.

If run with `-b` or `--backup` option it will add the `.bak` extension to the output files instead of modifying original translation files.

Example:

    sy18nc -b config/locales/en.yml ru.yml

or:

    sy18nc --backup config/locales/en.yml ru.yml

## Example

Lets see how it will handle these translation:

en.yml:

    en:
      promo:
        link1: Hello
        link2: Hello

ru.yml:

    ru:
      promo:
        link1: Birbevoon

Command:

    sy18nc config/locales/en.yml ru.yml

Will result in:

    ru:
      promo:
        link1: Birbevoon
        link2: Hello # FIXME

As you can see, it will import missing translation from base (en.yml in this case) and add useful `# FIXME` notice,
informing you that there is something missing in this translation and you need to fix it.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Licence

MIT Licence. &copy; 2013 Michał Darda <michaldarda@gmail.com>
