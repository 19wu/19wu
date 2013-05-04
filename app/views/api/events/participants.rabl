collection @users, object_root: false
attributes :id, :login, :created_at

child :profile do
  attributes :name, :website, :bio_html
end

node(:avatar_url) {|u| u.gravatar_url(size: 48) }
