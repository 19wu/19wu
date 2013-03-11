require File.expand_path('../../spec_helper', __FILE__)

describe CompoundDatetime do
  let(:date) {
    str = example.metadata[:full_description].scan(/\d{4}-\d{2}-\d{2} \d{2}:\d{2}/).last
    Time.zone.parse(str)
  }
  let(:attributes) do
    {
      'date' => '2013-12-31',
      'time' => '12:10 PM'
    }
  end
  subject { CompoundDatetime.new(date) }

  describe 'attr_reader' do
    describe '2012-03-31 00:00' do
      its(:date) { should == Date.new(2012, 3, 31) }
      its(:time) { should be_nil }
    end
    context '2012-03-31 00:01' do
      its(:date) { should == Date.new(2012, 3, 31) }
      its(:time) { should == '12:01 AM' }
    end
    context '2012-03-31 11:59' do
      its(:date) { should == Date.new(2012, 3, 31) }
      its(:time) { should == '11:59 AM' }
    end
    context '2012-03-31 12:00' do
      its(:date) { should == Date.new(2012, 3, 31) }
      its(:time) { should == '12:00 PM' }
    end
    context '2012-03-31 12:01' do
      its(:date) { should == Date.new(2012, 3, 31) }
      its(:time) { should == '12:01 PM' }
    end
  end

  describe 'attr_writer' do
    describe '2012-02-21 04:05' do
      context 'set date to 2013-12-31' do
        before { subject.date = '2012-12-31' }
        its(:date) { should == Date.new(2012, 12, 31) }
        its(:time) { should == '04:05 AM' }
      end

      context 'set date to blank' do
        before { subject.date = '' }
        its(:date) { should be_nil }
        its(:time) { should be_nil }
      end

      context 'set time to blank' do
        before { subject.time = '' }
        its(:date) { should == Date.new(2012, 2, 21) }
        its(:time) { should be_nil }
      end

      describe 'assign_attributes' do
        before { subject.assign_attributes(attributes) }

        its(:date) { should == Date.new(2013, 12, 31) }
        its(:time) { should == '12:10 PM' }
      end
    end
  end

  describe CompoundDatetime::HasCompoundDatetime do
    let(:klass) {
      Class.new do
        attr_accessor :time
        extend CompoundDatetime::HasCompoundDatetime
        has_compound_datetime :time
      end
    }

    describe '2012-03-31 00:01' do
      describe 'compound_time' do
        subject do
          object = klass.new
          object.time = Time.zone.parse('2012-03-31 00:01')
          object.compound_time
        end

        its(:date) { should == Date.new(2012, 3, 31) }
        its(:time) { should == '12:01 AM' }
      end

      describe 'compound_time_attributres=' do
        let(:object) { klass.new }
        subject { object.compound_time }
        before do
          object.time = Time.zone.now
          object.compound_time_attributes = attributes
        end
        its(:date) { should == Date.new(2013, 12, 31) }
        its(:time) { should == '12:10 PM' }
      end
    end
  end
end
