defmodule Transilien do
  use Tesla, only: [:get], docs: false

  plug Tesla.Middleware.BaseUrl, "https://api.transilien.com"
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Headers, [{"Apikey", "eHTvdFmj7xM7Ny4u0wgXTvJKQ2kbqazh"}]


  @jeu1 %{id: "api-sncf", url: "https://www.digital.sncf.com/startup/api"}
  @jeu2 %{id: "sncf-transilien-gtfs", url: ""}

  @jeu3 %{url: "https://ressources.data.sncf.com/api/v2"}
  
  @base_url "https://api.transilien.com"
  @uic_melun 87682005
  @uic_paris_gare_de_lyon_1 87686006
  @uic_paris_gare_de_lyon_2 87758581

  @mail "ripertdev@gmail.com"
  @pwd "2lazy2breathE"
  @pwd_PRIM "2lazY2breath&"
  @id__ "liesne_bot406"
  @jeton_api_PRIM "eHTvdFmj7xM7Ny4u0wgXTvJKQ2kbqazh"

  @api_key "7669342f442854374500b606c2035145355abb6f0dce7eb4ec82377e"

  def url(uic \\ @uic_melun) do
    # @base_url <> 
    "/gare/#{uic}/depart/" 
  end

  def fetch(uic \\ @uic_melun) do 

  end

  
end