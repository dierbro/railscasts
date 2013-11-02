  class User < ActiveRecord::Base
  #FIXME: user strong parameters
  #attr_accessible :name, :email, :site_url, :email_on_reply
  before_create { generate_token(:token) }
  has_many :api_keys
  has_many :comments
  has_paper_trail

  def self.create_from_omniauth(omniauth)
    User.new.tap do |user|
      user.github_uid = omniauth["uid"]
      user.github_username = omniauth["info"]["nickname"]
      user.email = omniauth["info"]["email"]
      user.name = omniauth["info"]["name"]
      user.site_url = omniauth["info"]["urls"]["Blog"] if omniauth["info"]["urls"]
      user.gravatar_token = omniauth["extra"]["user_hash"]["gravatar_id"] if omniauth["extra"] && omniauth["extra"]["user_hash"]
      user.email_on_reply = true
      user.save!
    end
  end

  def generated_unsubscribe_token
    if unsubscribe_token.blank?
      generate_token(:unsubscribe_token)
      save!
    end
    unsubscribe_token
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def session_api_key
    api_keys.active.session.first_or_create
  end

  def display_name
    name.present? ? name : github_username
  end

  def banned?
    banned_at
  end
end
