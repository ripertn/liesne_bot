defmodule LiesneBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ExGram,
      {LiesneBot.Bot, [method: :polling, token: "5628609758:AAE8EU7kmPVv3x6DZ7-OpN-uSsYlidt2Kkc"]}    
      # Starts a worker by calling: LiesneBot.Worker.start_link(arg)
      # {LiesneBot.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiesneBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end