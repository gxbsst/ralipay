require 'spec_helper'

describe Ralipay::Common do

 describe ".para_filter" do
  let(:params) do 
    {:a => 111, :sign_type => 'MD5', :b => 1111}
  end 

  let(:filter_result) do 
    {:a => 111 }
  end 

  it "shoud return a correct result" do
    expect(Ralipay::Common.para_filter(params)).to eq(filter_result)
  end
 end


 describe ".valify?" do

   before :each do
     @for_sign_string = "ab"
     @signed_string = "ab"
   end  

   it "should return true" do 
     expect(Ralipay::Common.verify?(@for_sign_string,@signed_string)).to be_true
   end

 end
end
