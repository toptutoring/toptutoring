module ReviewHelper
  def review_stars(number)
    tag.span "★" * number, class: "stars"
  end
end
