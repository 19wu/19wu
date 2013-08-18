# -*- coding: utf-8 -*-
require 'spec_helper'

describe EventOrderShippingAddress do
  subject(:shipping_address) { build(:shipping_address) }
  describe '#info' do
    its(:info) { should eql '广东省深圳市南山区 科技园南区 saberma 13928452888'}
  end
end
