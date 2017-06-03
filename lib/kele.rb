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

  #checkpoint_id = 1905
  #assignment_branch = https://github.com/MarioRoncador/Kele/tree/keleCP6
  #assignment_commit_link = https://github.com/MarioRoncador/Kele/commit/f8629d78cad1f890c6b5f7dbf6120e8916fe16ae
  #my enrollment_id = 2352229
  def create_submissions(checkpoint_id, assignment_branch, assignment_commit_link, comment)
    options = {body: {"checkpoint_id" => checkpoint_id, "assignment_branch" => assignment_branch, "assignment_commit_link" => assignment_commit_link, "comment" => comment}.merge(user_auth)}
    response = self.class.post("https://www.bloc.io/api/v1/checkpoint_submissions", options)
    if response.success?
      "Your checkpoint #{checkpoint_id} was submitted successfully"
      response
    else
      "Error"
      response
    end
  end

  #method used in the above 'get_me' and 'get_mentor_availability' to keep them cleaner
  def user_auth
    { headers: { "authorization" => @auth_token }}
  end

end
