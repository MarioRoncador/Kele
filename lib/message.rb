module Message

  def get_messages(page=nil)
    response = self.class.get("https://www.bloc.io/api/v1/message_threads?page=#{page}", user_auth)
    @messages = JSON.parse(response.body)
  end

  #my user_id = 2352229
  #Ryan's recipient_id = 456756
  def create_message(receiver, subject, body)
    #pulls the user_id from the login and assigns it to sender
    options = {body: {"recipient_id" => receiver, "subject" => subject, "stripped-text" => body}.merge(user_auth)}
    response = self.class.post("https://www.bloc.io/api/v1/messages", options)
    if response.success?
      "Your message was sent successfully"
    else
      "Error"
    end
  end

  #method used in the above 'get_me' and 'get_mentor_availability' to keep them cleaner
  def user_auth
    { headers: { "authorization" => @auth_token }}
  end

end
