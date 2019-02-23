class JwtService
  def self.encode(payload:)
    expiration = Time.now.to_i + 84000
    payload.merge!(exp: expiration)
    JWT.encode(payload, self.secret)
  end

  def self.decode(token:)
    JWT.decode(token, self.secret).first
  end

  def self.secret
    ENV['jwt_secret_key']
  end
end