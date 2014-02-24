require 'sinatra'
require '/Users/weston/Downloads/ralipay/lib/ralipay.rb'
require 'rqrcode_png'
# set :bing, '192.168.0.106'
set :bind, '0.0.0.0'

set :port, 8080

get "/" do 

configs =    {
      :partner => '2088701977493485',  #商户id partner_id
      :seller_email => 'hr@rongyi.com',  #商户email
       :key => '1htrinnzcp1371s5hbbt9gr5p1wlgz2f',
      :rsa_private_key_path => '/Users/weston/Downloads/mykey.pem',  #私钥绝对路径
      :rsa_public_key_path  => '/Users/weston/Downloads/mykey.pub',  #公钥绝对路径
      :subject => '测试商品',  #商品名称
      :out_trade_no => rand(9999).to_s,  #外部交易号,不能重复
      :total_fee => '0.01',  #交易价格
      :notify_url => 'http://192.168.0.108',  #服务器异步回调通知接口地址
      :merchant_url => 'http://192.168.0.108',  #商品展示地址
      :call_back_url => 'http://192.168.0.108'  #支付成功同步回调跳转地址
    }
@url = Ralipay::WebPayment.new(configs).generate_pay_url
erb :"index", :layout => false
end

get "/pay" do 
configs =    {
      :partner => '2088701977493485',  #商户id partner_id
      :seller_email => 'hr@rongyi.com',  #商户email
       :key => '1htrinnzcp1371s5hbbt9gr5p1wlgz2f',
      :rsa_private_key_path => '/Users/weston/Downloads/mykey.pem',  #私钥绝对路径
      :rsa_public_key_path  => '/Users/weston/Downloads/mykey.pub',  #公钥绝对路径
      :subject => '测试商品',  #商品名称
      :out_trade_no => rand(9999).to_s,  #外部交易号,不能重复
      :total_fee => '0.01',  #交易价格
      :notify_url => 'http://www.rongyi.com',  #服务器异步回调通知接口地址
      :merchant_url => 'http://www.rongyi.com',  #商品展示地址
      :call_back_url => 'http://www.rongyi.com'  #支付成功同步回调跳转地址
    }
url = Ralipay::WapPayment.new(configs).generate_pay_url

  "<a href='" + url  + "'>支付</a>"
end
