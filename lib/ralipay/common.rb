module Ralipay::Common

  require 'openssl'
  require 'base64'
  require 'digest/md5'

  #生成签名结果
  def self.build_sign data_array
    #把数组所有元素，按照“参数=参数值”的模式用“&”字符拼接成字符串
    for_sign_string = self.create_link_string(data_array)
    #签名
    if $global_configs[:secure_type] == 'RSA'
      return self.rsa_sign(for_sign_string)
    elsif $global_configs[:secure_type] == 'MD5'
      return self.md5_sign(for_sign_string)
    else
      fail('------Unknown sign_type------')
    end
  end

  #把数组所有元素，排序后按照“参数=参数值”的模式用“&”字符拼接成字符串
  def self.create_link_string hash, sort = true
    result_string = ''
    #是否排序
    if sort
      hash = hash.sort
    end

    hash.each{|key,value|
      result_string += (key.to_s + '=' + value.to_s + '&')
    }
    #去掉末尾的&
    result_string = result_string[0, result_string.length - 1]
    return result_string
  end

  #RSA签名
  def self.rsa_sign for_sign_string
    #读取私钥文件
    rsa_private_key_file = File.read($global_configs[:rsa_private_key_path])
    #转换为openssl密钥
    openssl_key = OpenSSL::PKey::RSA.new rsa_private_key_file
    #使用openssl方法进行sha1签名digest(不能用sha256)
    digest = OpenSSL::Digest::SHA1.new
    signature = openssl_key.sign digest, for_sign_string
    #base64编码
    signature = Base64.encode64(signature)
    return signature
  end

  #MD5签名
  def self.md5_sign(for_sign_string)
    Digest::MD5.hexdigest for_sign_string
  end

  #验签
  def self.verify? for_sign_string, signed_string
    #读取公钥文件
    rsa_public_key_file = File.read($global_configs[:rsa_public_key_path])
    #转换为RSA对象
    openssl_public = OpenSSL::PKey::RSA.new rsa_public_key_file
    #生成SHA1密钥串
    digest = OpenSSL::Digest::SHA1.new
    #openssl验证签名
    openssl_public.verify(digest, Base64.decode64(signed_string), for_sign_string)
  end

  #除去数组中的空值和签名参数
  def self.para_filter paras = {}
    new_paras = {}
    paras.each{|key,value|
      if key != :sign && key != :sign_type && key != 'sign' && key != 'sign_type' && value != '' && value != nil
        new_paras[key] = value
      end
    }
    return new_paras
  end

  #解密用商户私钥,解密前，需要用base64将内容还原成二进制,按128位拆开解密
  def self.decrypt crypt_string
    #读取私钥文件
    rsa_private_key_file = File.read($global_configs[:rsa_private_key_path])
    #转换为openssl密钥
    openssl_key = OpenSSL::PKey::RSA.new rsa_private_key_file
    #密文经过base64解码
    crypt_string = Base64.decode64(crypt_string)

    #声明明文字符串变量
    result = ''
    #循环按照128位解密
    i = 0
    while i < (crypt_string.length.to_f/128) do
      for_decrypt_string = crypt_string[i * 128,128]
      #p for_decrypt_string
      #拆分开长度为128的字符串片段通过私钥进行解密
      origin_data = openssl_key.private_decrypt for_decrypt_string
      result = result + origin_data
      i += 1
    end

    return result
  end

end
