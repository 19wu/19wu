require "spec_helper"

describe Hash do
  describe '#to_ng_init' do
    subject { {a: 1, c:true, d: 's'}.to_ng_init }
    it { should eql "a=1;c=true;d=\"s\"" }
    context 'with hash value' do
      subject { {a: {b: 1}}.to_ng_init }
      it { should eql "a={\"b\":1}" }
    end
    context 'with array value' do
      subject { {tickets: [{name: 'person'}, {name: 'company'}]}.to_ng_init }
      it { should eql "tickets=[{\"name\":\"person\"},{\"name\":\"company\"}]" }
    end
    context 'with nil value' do
      subject { {a: nil}.to_ng_init }
      it { should eql "a=null" }
    end
  end
end
