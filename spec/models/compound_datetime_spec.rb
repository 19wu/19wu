require File.expand_path('../../spec_helper', __FILE__)

describe CompoundDatetime do
  let(:date) {
    str = example.metadata[:full_description].scan(/\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/).last
    Time.zone.parse(str)
  }
  subject { CompoundDatetime.new(date) }

  describe 'attr_reader' do
    describe '2012-03-31 00:00:00' do
      its(:date) { should == Date.new(2012, 3, 31) }
      its(:hour) { should == 12 }
      its(:min) { should == 0 }
      its(:sec) { should == 0 }
      its(:meridian) { should == 'am' }
    end
    context '2012-03-31 00:01:02' do
      its(:date) { should == Date.new(2012, 3, 31) }
      its(:hour) { should == 12 }
      its(:min) { should == 1 }
      its(:sec) { should == 2 }
      its(:meridian) { should == 'am' }
    end
    context '2012-03-31 11:59:59' do
      its(:date) { should == Date.new(2012, 3, 31) }
      its(:hour) { should == 11 }
      its(:min) { should == 59 }
      its(:sec) { should == 59 }
      its(:meridian) { should == 'am' }
    end
    context '2012-03-31 12:00:00' do
      its(:date) { should == Date.new(2012, 3, 31) }
      its(:hour) { should == 12 }
      its(:min) { should == 0 }
      its(:sec) { should == 0 }
      its(:meridian) { should == 'pm' }
    end
    context '2012-03-31 12:01:02' do
      its(:date) { should == Date.new(2012, 3, 31) }
      its(:hour) { should == 12 }
      its(:min) { should == 1 }
      its(:sec) { should == 2 }
      its(:meridian) { should == 'pm' }
    end
  end

  describe 'attr_writer' do
    describe '2012-02-21 04:05:06' do
      context 'set meridian to pm' do
        before { subject.meridian = 'pm' }

        its(:meridian) { should == 'pm' }
        its(:hour) { should == 4 }
      end
      context 'set date to 2013-12-31' do
        before { subject.date = '2012-12-31' }
        its(:date) { should == Date.new(2012, 12, 31) }
      end

      describe 'assign_attributes' do
        let(:attributes) do
          {
            'date' => '2013-12-31',
            'hour' => '12',
            'meridian' => 'pm',
            'min' => '10',
            'sec' => '30'
          }
        end
        before { subject.assign_attributes(attributes) }

        its(:date) { should == Date.new(2013, 12, 31) }
        its(:hour) { should == 12 }
        its(:min) { should == 10 }
        its(:sec) { should == 30 }
        its(:meridian) { should == 'pm' }
      end
    end
  end
end
