module ReviewHelper
  def review_stars(number)
    tag.span "★" * number, class: "stars"
  end

  def review_external_link(user)
    account = user.client_account
    link_to client_review_source(account),
      client_review_link(account), target: :blank
  end

  def client_review_source(account)
    account.review_source || ENV.fetch("DEFAULT_REVIEW_SOURCE")
  end

  def client_review_link(account)
    account.review_link || ENV.fetch("DEFAULT_REVIEW_LINK")
  end
end
