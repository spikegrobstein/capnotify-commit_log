# Capnotify::CommitLog

This adds a commit log to your capnotify emails.

This will list commits that are new to this deploy (compared to the previous deploy).
Currently it only supports git and uses the `git log --oneline` command internaly.

A future version should support other SCMs if you're into that kind of thing. Anyone with
repositories on other SCMs is encouraged to send me a pull request implementing that.

NOTE: This is very much a work in progress and is NOT production ready. This is the first
plugin for Capnotify and it's being used to work out aspects of the extension API.

## Installation

Add this line to your application's Gemfile:

    gem 'capnotify-commit_log'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capnotify-commit_log

## Usage

All you need to do is include the following code after requiring `capnotify`:

    require 'capnotify/commit_log'

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
