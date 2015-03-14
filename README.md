# Interactive
This is a helper module to assist in interactive question-answering events in the command line.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'interactive_question'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install interactive_question

## Usage

If you want to ask a user a question expecting certain answers:

```ruby
question = Interactive::Question.new do |ques|
  ques.question = "What do you want to do?"
  ques.options = [:add, :edit, :update, :remove]
end
```

You can run the loop and wait for a valid response:

```ruby
question.ask_and_wait_for_valid_response do |response|
  if response.add?
    # add the thingymajigger
  elsif response.edit?
    # edit the thingymajigger
  elsif response.update?
    # etc...
  end
end
```

That will ask the question appended by the shortcuts:

```ruby
# => What do you want to do? [a/e/u/r]
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
# => What do you want to do? [a/e/u/r]
# =>   a -- add
# =>   e -- edit
# =>   u -- update
# =>   r -- remove
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
