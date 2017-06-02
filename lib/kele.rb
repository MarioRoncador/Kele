require 'httparty'
require 'json'
require './lib/roadmap.rb'
require './lib/message.rb'

class Kele
  include HTTParty
  include Roadmap
  include Message

  def initialize(email, password)
    response = self.class.post("https://www.bloc.io/api/v1/sessions", body: {"email": email, "password": password})

    raise "invalid email or password" if response.code != 200
    @auth_token = response['auth_token']

  end

  def get_me
    response = self.class.get("https://www.bloc.io/api/v1/users/me", user_auth)
    @user_data = JSON.parse(response.body)
  end

  def user_id
    @id = get_me["id"]
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get("https://www.bloc.io/api/v1/mentors/#{mentor_id}/student_availability", user_auth)
    @mentor_availability = JSON.parse(response.body)
  end

  def get_roadmap(roadmap_id)
    response = self.class.get("https://www.bloc.io/api/v1/roadmaps/#{roadmap_id}", user_auth)
    @roadmap = JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id)
    response = self.class.get("https://www.bloc.io/api/v1/checkpoints/#{checkpoint_id}", user_auth)
    @checkpoint = JSON.parse(response.body)
  end

  #method used in the above 'get_me' and 'get_mentor_availability' to keep them cleaner
  def user_auth
    { headers: { "authorization" => @auth_token }}
  end

end
