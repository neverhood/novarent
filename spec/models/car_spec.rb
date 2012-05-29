require 'spec_helper'

describe Car do

  describe 'Validations' do

    before :each do
      @car = FactoryGirl.build(:car)
      @car.should be_valid
    end

    it 'validates manufacturer' do
      [ nil, '' ].each do |value|
        @car.manufacturer = value
        @car.should be_invalid
      end

      [ 'Honda', 'Mercedes' ].each do |value|
        @car.manufacturer = value
        @car.should be_valid
      end
    end

    it 'validates name' do
      [ nil, '' ].each do |value|
        @car.name = value
        @car.should be_invalid
      end

      [ 'Accord', 'X6' ].each do |value|
        @car.name = value
        @car.should be_valid
      end
    end

    it 'validates transmission' do
      @car.transmission.should == 'auto'
      @car.transmission = 0
      @car.transmission.should == 'manual'
    end


  end

end
