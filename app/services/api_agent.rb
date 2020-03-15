class ApiAgent
  API_V1_PREFIX = "api/v1/".freeze

  def initialize(root_url)
    @root_url = root_url
  end

  def new_game
    response = make_post_request("games")
    response["id"]
  end

  def make_shot(game_id, pins)
    make_post_request("games/#{game_id}/shots", pins: pins)
  end

  private

  def uri_to(path)
    URI("#{@root_url}#{API_V1_PREFIX}#{path}")
  end

  def make_post_request(path, payload ={})
    response = Net::HTTP.post_form(uri_to(path), payload)
    JSON.parse(response.body).with_indifferent_access
  end
end
