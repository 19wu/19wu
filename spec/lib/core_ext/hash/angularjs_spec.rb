require "spec_helper"

describe Hash do
  describe '#to_ng_init' do
    subject { {a: 1, c:true, d: 's'}.to_ng_init }
    it { should eql "a=1;c=true;d=\"s\"" }
    context 'with hash value' do
      subject { {a: {b: 1}}.to_ng_init }
      it { should eql "a={\"b\":1}" }
    end
  end
end
