module UsersHelper
  def gravatar_for(user, size = 36)
    return '' if user.blank?

    md_hash = Digest::MD5::hexdigest(user.email || '')
    gravatar_url = "http://www.gravatar.com/avatar/#{md_hash}?s=#{size}&d=mm"
    image_tag(gravatar_url, alt: user.login, class: 'gravatar')
  end
end
