class AuthHashService
  def initialize(auth_hash)
    @auth_hash = auth_hash
  end

  def update_dwolla_attributes(user)
    return unless user
    update_tokens(user) if user.has_role?("admin")
    user.update(auth_provider: auth_hash["provider"],
                auth_uid: auth_hash["uid"])
  end

  private

  attr_reader :auth_hash

  def update_tokens(user)
    user.update(dwolla_access_token: auth_hash["credentials"]["token"],
                dwolla_refresh_token: auth_hash["credentials"]["refresh_token"])
  end
end
