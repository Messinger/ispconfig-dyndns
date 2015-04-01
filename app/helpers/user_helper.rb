module UserHelper

  ADMIN_TYPE = "admin"
  CLIENT_TYPE = "clientuser"
  USER_TYPE = "user"

  module GeneralUser
    
    BASE64_ALPHABET='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    SALT_LENGTH=8

    def is_password?(passwd)
      self.password == encrypt_password(passwd,password[1..SALT_LENGTH+2])
    end

    module_function

    def encrypt_password(apasswd,salt = nil)
      if salt.blank?
        s = ''
        prng = Random.new
        for n in 1..SALT_LENGTH
          s << BASE64_ALPHABET[prng.rand(63)]
        end
        salt = "1$#{s}"
      end
      apasswd.crypt("$#{salt}$")
    end

  end

end
