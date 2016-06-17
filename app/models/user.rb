require 'data_mapper'
require 'dm-postgres-adapter'
require 'bcrypt'


class User

  include DataMapper::Resource

  attr_reader :password
  attr_accessor :password_confirmation

  validates_confirmation_of :password

  property :id , Serial
  property :email , String, :required => true, :format => :email_address, :unique => true,
  :messages => {
  	:presence => "Email must not be blank",
  	:is_unique => "E-mail address already registered.",
  	:format => "Email has an invalid format"
  }
  property :password_digest, String, length: 60

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.authenticate(email, password)
  	user = first(email: email)
    if user && BCrypt::Password.new(user.password_digest) == password
      user
    else
      nil
    end
  end

end
