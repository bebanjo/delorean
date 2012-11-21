# Delorean [![Build Status](https://secure.travis-ci.org/bebanjo/delorean.png)](http://travis-ci.org/bebanjo/delorean)

Delorean lets you travel in time with Ruby by mocking `Time.now`

![](http://dl.dropbox.com/u/645329/delorean.png)

> Marty:: Wait a minute, Doc. Ah... Are you telling me that you built a time machine... out of a DeLorean?
>
> Doc:: The way I see it, if you're gonna build a time machine into a car, why not do it with some style?

## Install

    $ [sudo] gem install delorean

Or add it to your `Gemfile`, etc.

## Usage

Let's travel in time!

    require 'delorean'

    # Date.today => Wed Feb 24
    Delorean.time_travel_to "1 month ago" # Date.today => Sun Jan 24
    Delorean.back_to_the_present          # Date.today => Wed Feb 24

With a block:

    Delorean.time_travel_to("1 month ago") do
      # Inside the block, Time.now => Sun Jan 24 00:34:32 +0100 2010
      sleep(5)
      # And the time still goes by... Time.now => Sun Jan 24 00:34:37 +0100 2010
    end

    # Outside the block, Time.now => Wed Feb 24 00:34:35 +0100 2010

You can also `jump` which is like `sleep` but without losing time

    # Time.now => Wed Feb 24 00:34:04 +0100 2010
    Delorean.jump 30
    # Time.now => Wed Feb 24 00:34:34 +0100 2010

## Testing

Time-travelling can be extremely useful when you're testing your application.

For example, in RSpec you may find convenient to include Delorean's DSL in your `spec_helper.rb`:

    RSpec.configure do |config|
      config.include Delorean
      ...

Now you can time-travel in your examples, like this:

    it "should show latest created user" do

      time_travel_to(3.minutes.ago) { create_user :name => "John"  }
      time_travel_to(5.minutes.ago) { create_user :name => "Chris" }

      get 'show'

      response.should have_text("John")
      response.should_not have_text("Chris")

    end

Don't forget to go back to the present after each example:

    after(:each) { back_to_the_present }

or its alternate syntax:

    after(:each) { back_to_1985 }

## Credits

Delorean image based on [an original](http://www.gocarlo.com/lagalerie/archives/march05.htm) by [Giancarlo Pitocco](http://www.gocarlo.com/).

Copyright (c) 2012 Luismi Cavallé, Sergio Gil and BeBanjo S.L. released under the MIT license

