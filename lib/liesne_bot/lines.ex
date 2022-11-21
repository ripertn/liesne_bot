defmodule Lines do
  use GenServer
  require Logger

  def start_link(opts), do: GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  def init(_opts) do
    Logger.info("Lines GenServer starting")
    lines = Connector.Prim.format_lines()

    # TODO automatic refresh of the data
    # case Time.to_seconds_after_midnight(Time.utc_now) do
    #   {x,_} when x < 28800-> Process.send_after(self(), :pull, x*1000)                    #before 8:00 am
    #   {x,_} -> Process.send_after(self(), :pull, (x+28800)*1000)                          #after 8:00 am
    # end

    Logger.info("Lines GenServer successfully started")
    {:ok, lines}
  end

  def get_state(), do: GenServer.call(__MODULE__, {:get_state})
  def handle_call({:get_state}, _from, state), do: {:reply, state, state}


  def get_line_details(id_line), do: GenServer.call(__MODULE__, {:details, id_line})

  def handle_call({:details, id_line}, _from, state) do
    [details] = Enum.filter(state,fn l -> l["id_line"]==id_line end) 
    {:reply, details, state}
  end
end