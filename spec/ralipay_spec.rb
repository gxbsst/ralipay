# encoding: utf-8
require "spec_helper"
require 'pry'
require 'rqrcode_png'
describe Ralipay do 
     # seller_email: "shannon.mao@sidways.com"
    # partner: "2088801240842311"
    # key: "yf46ds05nkrwdggnmftchrk83tpaza5j"
  let(:configs) do
    {
      :partner => '2088701977493485',  #商户id partner_id
      :seller_email => 'hr@rongyi.com',  #商户email
       :key => '1htrinnzcp1371s5hbbt9gr5p1wlgz2f',
      # :partner => "2088801240842311",
      # :seller_email => "shannon.mao@sidways.com",
      # :key =>  "yf46ds05nkrwdggnmftchrk83tpaza5j",
      :rsa_private_key_path => '/Users/weston/Downloads/mykey.pem',  #私钥绝对路径
      :rsa_public_key_path  => '/Users/weston/Downloads/mykey.pub',  #公钥绝对路径
      :subject => '测试商品',  #商品名称
      :out_trade_no => rand(9999).to_s,  #外部交易号,不能重复
      :total_fee => '0.01',  #交易价格
      :notify_url => 'http://www.rongyi.com',  #服务器异步回调通知接口地址
      :merchant_url => 'http://www.rongyi.com',  #商品展示地址
      :call_back_url => 'http://www.rongyi.com'  #支付成功同步回调跳转地址
    }
  end
  it "return true" do 
    # expect(Ralipay::ClientPayment.new(configs).notify_verify?({})).to eq("..")
     # expect(Ralipay::WapPayment.new(configs).generate_pay_url).to eq("...")
     url = Ralipay::WapPayment.new(configs).generate_pay_url
     puts url
      # qr = RQRCode::QRCode.new( url, :size => 25, :level => :h )
     # png = qr.to_img                                             # returns an instance of ChunkyPNG
     # png.resize(90, 90).save("really_cool_qr_image.png")
  end

  describe "create qr code"  do

    it "should create qr code" do
      r = Ralipay::WapPayment.new(configs)   
      expect(r.create_qrcode).to eq("...")
    end
    
  end
  
end
