class User < ApplicationRecord
    validates :user_name, :password_digest, presence: true, uniqueness: true
    validates :password, length: { minimum: 6, allow_nil: true }
    validates :session_token, presence: true, uniqueness: true
    after_initialize :ensure_session_token

    attr_reader :password

    has_many :cats,
        primary_key: :id,
        foreign_key: :user_id,
        class_name: 'Cat'


    # FIG VAPER
    def self.find_by_credentials(username, password)
        user = User.find_by(user_name: username)
        return nil unless user && user.is_password?(password)
        user
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        bcrypt_pass = BCrypt::Password.new(self.password_digest)
        bcrypt_pass.is_password?(password)
    end

    def reset_session_token!
        self.update!(session_token: self.class.generate_session_token)
        self.session_token
    end

    private

    def self.generate_session_token
        SecureRandom::urlsafe_base64
    end

    def ensure_session_token
        self.session_token ||= self.class.generate_session_token
    end

end
