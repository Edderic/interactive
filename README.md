# Interactive
[![Gem Version](https://badge.fury.io/rb/interactive.svg)](http://badge.fury.io/rb/interactive)
[![Build Status](https://travis-ci.org/Edderic/interactive.svg)](https://travis-ci.org/Edderic/interactive)
[![Code Climate](https://codeclimate.com/github/Edderic/interactive/badges/gpa.svg)](https://codeclimate.com/github/Edderic/interactive)

This is a helper module to assist in interactive question-answering events in the command line.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'interactive'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install interactive

## Usage

### Questions With Lazy Shortcut Explanations
If you want to ask a user a question expecting certain answers:

```ruby
question = Interactive::Question.new do |ques|
  ques.question = "Which item do you want to use?"
  ques.options = [1..3, :cancel, :quit]
end
```

You can run the loop and wait for a valid response and do query methods on the
response:

```ruby
question.ask_and_wait_for_valid_response do |response|
  if response.whole_num_1?
    # do stuff if user responded with "1"
  elsif response.whole_num?
    # do stuff if user responded with "1", "2", or "3"
  elsif response.cancel?
    # do stuff if user responded with "c", etc.
  elsif response.quit?
    # do stuff if user responded with "q", etc.
  end
end
```

That will ask the question appended by the shortcuts (without full explanation):

```ruby
# => "Which item do you want to use? [1/2/3/c/q]"
```

If the response is valid:

```ruby
$ a
# => response.add? will return true
```

If the response is invalid, it prints out the question and goes into detail as
to what the shortcuts stand for:

```ruby
$ bad-response
  => Which item do you want to use? [1/2/3/c/q]
  =>   1 -- 1
  =>   2 -- 2
  =>   3 -- 3
  =>   c -- cancel
  =>   q -- quit
``

### Questions With Eager Shortcut Explanations

Providing an array of options to the options array will trigger the shortcut
explanation right after asking the question:

```ruby

options_list = ["/some/path", "/some/other/path"]
iq = Interactive::Question.new do |q|
  q.question = "Which path do you want to use?"
  q.options = [options_list, :cancel]
end

iq.ask_and_wait_for_valid_response do |response|
  if response.whole_number?
    # response.to_i will convert the response string to an integer.
    # useful for getting the index (i.e. options_list[response.to_i])
  elsif response.cancel?
    # do stuff to cancel...
  end
end
```

This will ask the question and show the explanation eagerly:

```ruby
# Which path do you want to use? [0/1/c]
#   0 -- /some/path
#   1 -- /some/other/path
#   c -- cancel
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/edderic/interactive/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
