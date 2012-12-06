require 'rubygems'
require 'active_support/all'
require File.expand_path("../lib/delorean", File.dirname(__FILE__))

describe Delorean do

  before(:all) do
    @default_tz = ENV['TZ']
    ENV['TZ'] = 'UTC'
  end

  after(:all) do
    ENV['TZ'] = @default_tz
  end

  after(:each) do
    Delorean.back_to_the_present
  end

  describe "time_travel_to" do
    it "should travel through time" do
      past_date = Time.utc(2009,1,1,10,30)
      Delorean.time_travel_to past_date
      Time.now.should be_within(1).of(past_date)
    end

    it "should travel through time several times" do
      past_date = Date.new(2009,1,1)
      Delorean.time_travel_to Date.new(2009,2,20)
      Delorean.time_travel_to past_date
      Date.today.should == past_date
    end

    it "should travel to string times" do
      two_minutes_from_now = Time.now + 120
      Delorean.time_travel_to "2 minutes from now"
      Time.now.should be_within(1).of(two_minutes_from_now)
    end

    it "should travel to string times with options" do
      two_days_ago = 2.days.ago
      yesterday = Chronic.parse '1 day ago'
      Delorean.time_travel_to "1 day ago", :now => yesterday
      Time.now.should be_within(1).of(two_days_ago)
    end

    it "should return the final value of the block given" do
      Delorean.time_travel_to(Date.new(1955,11,12)) do
        'You\'re safe and sound now'
        'Back in good old 1955.'
      end.should eql 'Back in good old 1955.'
    end
    
    it "should work with DateTime" do
      datetime = DateTime.strptime("2011-05-25 18:00", "%Y-%m-%d %H:%M")
      Delorean.time_travel_to(datetime) do
        Time.now.should be_within(1).of(datetime)
      end
    end

    it "should change the result of DateTime" do
      datetime = DateTime.strptime("2011-05-25 18:00", "%Y-%m-%d %H:%M")
      Delorean.time_travel_to(datetime) do
        DateTime.now.should be_within(1).of(datetime)
      end
    end
  end

  describe 'subclasses' do
    describe 'of Time' do
      let( :time_klass ){ Class.new(Time) }
      it 'should change the result of time_klass.now' do
        past_date = Date.new(1955,11,12)
        Delorean.time_travel_to( past_date ) do
          time_klass.now.should be_an_instance_of time_klass
          time_klass.now.strftime('%F').should == past_date.strftime('%F') 
        end
      end
    end

    describe 'of Date' do
      let( :date_klass ){ Class.new(Date) }
      it 'should change the result of date_klass.now' do
        past_date = Date.new(1955,11,12)
        Delorean.time_travel_to( past_date ) do
          date_klass.today.should be_an_instance_of date_klass
          date_klass.today.strftime('%F').should == past_date.strftime('%F') 
        end
      end
    end

    describe 'of DateTime' do
      let( :datetime_klass ){ Class.new(DateTime) }
      it 'should change the result of datetime_klass.now' do
        past_date = Date.new(1955,11,12)
        Delorean.time_travel_to( past_date ) do
          datetime_klass.now.should be_an_instance_of datetime_klass
          datetime_klass.now.strftime('%F').should == past_date.strftime('%F') 
        end
      end
    end
  end

  describe "back_to_the_present" do
    it "should stay in the present if in the present" do
      today = Date.today
      Delorean.back_to_the_present
      Date.today.should == today
    end

    it "should go back to the present if not in the present" do
      today = Date.today
      Delorean.time_travel_to Time.local(2009,2,2,1,1)
      Delorean.back_to_the_present
      Date.today.should == today
    end

    it "should go back to the original present if travelled through time several times" do
      today = Date.today
      2.times { Delorean.time_travel_to Time.local(2009,2,2,1,1) }
      Delorean.back_to_the_present
      Date.today.should == today
    end
  end

  describe "time_travel_to with block" do
    it "should travel through time" do
      past_date = Time.utc(2009,1,1,10,30)
      Delorean.time_travel_to(past_date) do
        Time.now.should be_within(1).of(past_date)
      end
    end

    it "should return to the future" do
      today = Date.today
      Delorean.time_travel_to(Time.utc(2009,2,2,10,30)) {}
      Date.today.should == today
    end

    it "should travel through time several times" do
      Delorean.time_travel_to(Time.utc(2009,2,2,10,40)) do
        Delorean.time_travel_to(Time.utc(2009,1,1,22,45)) do
          Date.today.should == Date.new(2009,1,1)
        end
      end
    end

    it "should still return to the future" do
      today = Date.today
      Delorean.time_travel_to(Time.utc(2009,2,2,10,40)) do
        Delorean.time_travel_to(Time.utc(2009,1,1,10,40)) {}
        Date.today.should == Date.new(2009,2,2)
      end
      Date.today.should == today
    end

    it "should travel to string times" do
      two_minutes_ago = Time.now - 120
      Delorean.time_travel_to("2 minutes ago") do
        Time.now.should be_within(1).of(two_minutes_ago)
      end
    end

    it "should travel to string times with options" do
      two_days_ago = 2.days.ago
      yesterday = Chronic.parse '1 day ago'
      Delorean.time_travel_to("1 day ago", :now => yesterday) do
        Time.now.should be_within(1).of(two_days_ago)
      end
    end
  end

  describe "jump" do
    it "should jump the given number of seconds to the future" do
      expected = Time.now + 60
      Delorean.jump 60
      Time.now.should be_within(1).of(expected)
    end

    it "should return the final value of the block given" do
      to_the_future = Date.new(2015,10,21).to_time - Time.now
      Delorean.jump(to_the_future) do
        'You\'re safe and sound now'
        'Marti, I need to your help to save your future children'
      end.should eql 'Marti, I need to your help to save your future children'
    end

    it "should jump to future using rails date helpers" do
      expected = Time.now + 60
      Delorean.jump 1.minute
      Time.now.should be_within(1).of(expected)
    end

    it "should jump to future using rails date helpers" do
      expected = Time.now + 3600
      Delorean.jump 1.hour
      Time.now.should be_within(1).of(expected)
    end
  end
end

