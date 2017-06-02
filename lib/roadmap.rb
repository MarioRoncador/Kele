module Roadmap

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
