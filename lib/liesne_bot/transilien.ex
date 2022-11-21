defmodule Transilien do
  use Tesla, only: [:get], docs: false

  @api (File.read!("./details/itwillbeourlittlesecret.json") |> Jason.decode!())["sncf"]

  plug Tesla.Middleware.BaseUrl, @api["base_url"]
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Headers, [{"Apikey",  @api["token"]}]

  @uic_melun 87682005
  @uic_paris_gare_de_lyon_1 87686006
  @uic_paris_gare_de_lyon_2 87758581

  def url(uic \\ @uic_melun) do
    "/gare/#{uic}/depart/"
  end

  
end