# Notes for Zyme devs!

- Use the `--skip-prompts` flag to automatically accept all changes with the default keys.
- The default i18n path is built from the file path, if you add a path with the `-n` option it will fully overwrite the default path.
- On each prompt, enter `x` for skipping the candidate string, nothing to use the default (displayed) key or enter something to overwrite the key.
- If you overwrite the key, it will still prepend the full path (either default or `-n`-specified) to your key.
- You can add dots to further nest the key.

Example usage (watch the paths):

```
> ~/src/extract_i18n/exe/extract-i18n -l en -n my.custom.namespace ~/src/zymewire-rails-app/app/views/event_feed/all_events.html.erb

Processing: /home/lucia/src/zymewire-rails-app/app/views/event_feed/all_events.html.erb
reading /home/lucia/src/zymewire-rails-app/app/views/event_feed/all_events.html.erb

replace:  Zymewire - Event Feed
with:      t('my.custom.namespace.zymewire_event_feed')
Enter i18n key (blank to keep default, x to skip): titles.event_feed

# results in t('my.custom.namespace.titles.event_feed')
```

You can also build and install the gem (watch the paths and the gem version that was built):

```
cd ~/src/extract_i18n
gem build extract_i18n.gemspec
gem install --local ~/src/extract-i18n/extract_i18n-0.5.0.gem
```

# ExtractI18n

[![Gem Version](https://badge.fury.io/rb/extract_i18n.svg)](https://badge.fury.io/rb/extract_i18n)

[Read my blog post if you'd like more about the development of ExtractI18n](https://www.stefanwienert.de/blog/2020/07/26/internationalize-medium-rails-app-with-tooling/).

CLI helper program to automatically extract bare text strings into Rails I18n interactively.

Useful when adding i18n to a medium/large Rails app.

This Gem **supports** the following source files:

- Ruby files (controllers, models etc.) via Ruby-Parser, e.g. walking all Ruby Strings
- Slim Views (via Regexp parser by [SlimKeyfy](https://github.com/phrase/slimkeyfy) (MIT License))
- Vue Pug views
  - Pug is very similar to slim and thus relatively good extractable via Regexp.
- ERB views
  - by vendoring/extending https://github.com/ProGM/i18n-html_extractor (MIT License)

CURRENTLY THERE IS **NO SUPPORT** FOR:

- haml ( integrating https://github.com/shaiguitar/haml-i18n-extractor)
- vue html templates ([Check out my vue pug converting script](https://gist.github.com/zealot128/6c41df1d33a810856a557971a04989f6))

But I am open to integrating PRs for those!

I strongly recommend using a Source-Code-Management (Git) and ``i18n-tasks`` for checking the key consistency.
I've created a scanner to make that work with vue $t structures too: https://gist.github.com/zealot128/e6ec1767a40a6c3d85d7f171f4d88293

## Installation

install:

    $ gem install extract_i18n

## Usage

DO USE A SOURCE-CODE-MANAGEMENT-SYSTEM (Git). There is no guarantee that programm will not destroy your workspace :)


```
extract-i18n --help

extract-i18n --locale de --yaml config/locales/unsorted.de.yml app/views/user
```

If you prefer relative keys in slim views use ``--slim-relative``, e.g. ``t('.title')`` instead of ``t('users.index.title')``.
I prefer absolute keys, as it makes copy pasting/ moving files much safer.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zealot128/extract_i18n.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
