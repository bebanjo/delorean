if ENV['CI']
  require 'coveralls'
  Coveralls.wear!
else
  require 'simplecov'
  SimpleCov.start 'rails'
end

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

  it "preserves milliseconds" do
    datetime_with_milliseconds = DateTime.now.strftime('%L')
    expect( lambda {
      Timeout::timeout(1) do
        while DateTime.now.strftime('%L') == datetime_with_milliseconds do; ; end;
      end
    }).to_not raise_error Timeout::Error
  end

  describe "time_travel_to" do
    it "travels through time" do
      past_date = Time.utc(2009,1,1,10,30)
      Delorean.time_travel_to past_date
      expect(Time.now).to be_within(1).of(past_date)
    end

    it "travels through time several times" do
      past_date = Date.new(2009,1,1)
      Delorean.time_travel_to Date.new(2009,2,20)
      Delorean.time_travel_to past_date
      expect(Date.today).to eq past_date
    end

    it "travels to string times" do
      two_minutes_from_now = Time.now + 120
      Delorean.time_travel_to "2 minutes from now"
      expect(Time.now).to be_within(1).of(two_minutes_from_now)
    end

    it "travels to string times with options" do
      two_days_ago = 2.days.ago
      yesterday = Chronic.parse '1 day ago'
      Delorean.time_travel_to "1 day ago", :now => yesterday
      expect(Time.now).to be_within(1).of(two_days_ago)
    end

    it "returns the final value of the block given" do
      expect(Delorean.time_travel_to(Date.new(1955,11,12)) do
        'You\'re safe and sound now'
        'Back in good old 1955.'
      end).to eq 'Back in good old 1955.'
    end

    it "works with DateTime" do
      datetime = DateTime.strptime("2011-05-25 18:00", "%Y-%m-%d %H:%M")
      Delorean.time_travel_to(datetime) do
        expect(Time.now).to be_within(1).of(datetime)
      end
    end

    it "changes the result of DateTime" do
      datetime = DateTime.strptime("2011-05-25 18:00", "%Y-%m-%d %H:%M")
      Delorean.time_travel_to(datetime) do
        expect(DateTime.now).to be_within(1).of(datetime)
      end
    end
  end

  describe 'subclasses' do
    describe 'of Time' do
      let( :time_klass ){ Class.new(Time) }
      it 'changes the result of time_klass.now' do
        past_date = Date.new(1955,11,12)
        Delorean.time_travel_to( past_date ) do
          expect(time_klass.now).to be_an_instance_of time_klass
          expect(time_klass.now.strftime('%F')).to eq past_date.strftime('%F')
        end
      end
    end

    describe 'of Date' do
      let( :date_klass ){ Class.new(Date) }
      it 'changes the result of date_klass.now' do
        past_date = Date.new(1955,11,12)
        Delorean.time_travel_to(past_date) do
          expect(date_klass.today).to be_an_instance_of date_klass
          expect(date_klass.today.strftime('%F')).to eq past_date.strftime('%F')
        end
      end
    end

    describe 'of DateTime' do
      let( :datetime_klass ){ Class.new(DateTime) }
      it 'changes the result of datetime_klass.now' do
        past_date = Date.new(1955,11,12)
        Delorean.time_travel_to( past_date ) do
          expect(datetime_klass.now).to be_an_instance_of datetime_klass
          expect(datetime_klass.now.strftime('%F')).to eq past_date.strftime('%F')
        end
      end
    end
  end

  describe "back_to_the_present" do
    it "stays in the present if in the present" do
      today = Date.today
      Delorean.back_to_the_present
      expect(Date.today).to eq today
    end

    it "goes back to the present if not in the present" do
      today = Date.today
      Delorean.time_travel_to Time.local(2009,2,2,1,1)
      Delorean.back_to_the_present
      expect(Date.today).to eq today
    end

    it "goes back to the original present if travelled through time several times" do
      today = Date.today
      2.times { Delorean.time_travel_to Time.local(2009,2,2,1,1) }
      Delorean.back_to_the_present
      expect(Date.today).to eq today
    end
  end

  describe "time_travel_to with block" do
    it "travels through time" do
      past_date = Time.utc(2009,1,1,10,30)
      Delorean.time_travel_to(past_date) do
        expect(Time.now).to be_within(1).of(past_date)
      end
    end

    it "returns to the future" do
      today = Date.today
      Delorean.time_travel_to(Time.utc(2009,2,2,10,30)) {}
      expect(Date.today).to eq today
    end

    it "travels through time several times" do
      Delorean.time_travel_to(Time.utc(2009,2,2,10,40)) do
        Delorean.time_travel_to(Time.utc(2009,1,1,22,45)) do
          expect(Date.today).to eq Date.new(2009,1,1)
        end
      end
    end

    it "still returns to the future" do
      today = Date.today
      Delorean.time_travel_to(Time.utc(2009,2,2,10,40)) do
        Delorean.time_travel_to(Time.utc(2009,1,1,10,40)) {}
        expect(Date.today).to eq Date.new(2009,2,2)
      end
      expect(Date.today).to eq today
    end

    it "should travel to string times" do
      two_minutes_ago = Time.now - 120
      Delorean.time_travel_to("2 minutes ago") do
        expect(Time.now).to be_within(1).of(two_minutes_ago)
      end
    end

    it "travels to string times with options" do
      two_days_ago = 2.days.ago
      yesterday = Chronic.parse '1 day ago'
      Delorean.time_travel_to("1 day ago", :now => yesterday) do
        expect(Time.now).to be_within(1).of(two_days_ago)
      end
    end
  end

  describe "jump" do
    it "jumps the given number of seconds to the future" do
      expected = Time.now + 60
      Delorean.jump 60
      expect(Time.now).to be_within(1).of(expected)
    end

    it "returns the final value of the block given" do
      to_the_future = Date.new(2015,10,21).to_time - Time.now
      expect(Delorean.jump(to_the_future) do
        'You\'re safe and sound now'
        'Marti, I need to your help to save your future children'
      end).to eq 'Marti, I need to your help to save your future children'
    end

    it "jumps to future using rails date helpers" do
      expected = Time.now + 60
      Delorean.jump 1.minute
      expect(Time.now).to be_within(1).of(expected)
    end

    it "jumps to future using rails date helpers" do
      expected = Time.now + 3600
      Delorean.jump 1.hour
      expect(Time.now).to be_within(1).of(expected)
    end
  end
end
