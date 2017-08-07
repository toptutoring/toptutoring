class AuthHashService

  def initialize(auth_hash)
    @auth_hash = auth_hash
  end

  def find_or_create_user_from_auth_hash
    find_by_auth_hash || find_by_email || create_from_auth_hash
  end

  def set_token(user)
    update_provider_and_tokens_info(user)
  end

  private

  attr_accessor :auth_hash

  def find_by_auth_hash
    user = User.find_by(auth_provider: auth_hash["provider"],
                        auth_uid: auth_hash["uid"])
    update_token_info(user)
    user
  end

  def find_by_email
    user = User.find_by(email: auth_hash["info"]["email"])
    update_provider_and_tokens_info(user)
    user
  end

  def create_from_auth_hash
    User.create(
      auth_provider: auth_hash["provider"],
      auth_uid: auth_hash["uid"],
      email: auth_hash["info"]["email"],
      name: auth_hash["info"]["name"],
      dwolla_access_token: auth_hash["credentials"]["token"],
      dwolla_refresh_token: auth_hash["credentials"]["refresh_token"],
      token_expires_at: auth_hash["credentials"]["expires_at"]
    )
  end

  def update_provider_and_tokens_info(user)
    return unless user
    user.update(auth_provider: auth_hash["provider"],
                auth_uid: auth_hash["uid"],
                dwolla_access_token: auth_hash["credentials"]["token"],
                dwolla_refresh_token: auth_hash["credentials"]["refresh_token"],
                token_expires_at: auth_hash["credentials"]["expires_at"])
  end

  def update_token_info(user)
    return unless user
    user.update(dwolla_access_token: auth_hash["credentials"]["token"],
                dwolla_refresh_token: auth_hash["credentials"]["refresh_token"],
                token_expires_at: auth_hash["credentials"]["expires_at"])
  end
end
