# encoding: utf-8
require 'spec_helper'

describe HomeHelper do

  describe 'active?' do
    context 'menu is events' do
      let(:menu) { :events }
      subject { helper.active?(current, menu) }
      context 'current is events' do
        let(:current) { :events }
        it { should == :active }
      end
      context 'current is not events' do
        let(:current) { :activities }
        it { should be_blank }
      end
    end
  end
end
