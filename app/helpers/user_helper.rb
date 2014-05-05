module UserHelper

  ADMIN_TYPE = "admin"
  CLIENT_TYPE = "clientuser"
  USER_TYPE = "user"

  module User
    
    @@base64_alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    @@salt_length=8

    def is_password?(passwd)
      self.password == encrypt_password(passwd,password[1..@@salt_length+2])
    end

    module_function

    def encrypt_password(passwd,salt = nil)
      if salt.blank?
        s = ''
        prng = Random.new
        for n in 1..@@salt_length
          s << @@base64_alphabet[prng.rand(63)]
        end
        salt = "1$#{s}"
      end
      passwd.crypt("$#{salt}$")
    end

  end

end
