class JsonWebToken
  # application secret to encode and decode token
  HAMC_SECRET = Rails.application.secrets.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    # set expirty to 24 hours from creation time
    payload[:exp] = exp.to_i

    # sign token with application secret
    JWT.encode(payload, HAMC_SECRET)
  end

  def self.decode(token)
    # payload - decode and get the first index
    body = JWT.decode(toen, HAMC_SECRET)[0]

    HashWithIndifferentAccess.new body
  rescue JWT::DecodeError => e
    raise ExceptionHandler::InvalidToken, e.message
  end
end