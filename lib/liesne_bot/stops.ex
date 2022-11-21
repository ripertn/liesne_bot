defmodule Stops do
  use GenServer
  require Logger

  @station_ids %{
    "melun" => %{name: "melun", id: "41361"},
    "fontainebleau" => %{id: "41372"},
    "bois" => %{id: "41371"},
    "bois le roi" => %{id: "41371"},
    "gare de lyon" => %{id: "41396"}, # and 474065 or 474062
    "paris" => %{id: "41396"},
    "montargis" => %{id: "411481"},
    "montereau" => %{id: "41376"},
    "laroche" => %{id: "411478"},
    "laroche migennes" => %{id: "411478"}
  }

  def start_link(opts), do: GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  def init(_opts) do
    Logger.info("Stops GenServer starting")
    stops = Connector.Prim.format_stops()

    # TODO automatic refresh of the data
    # case Time.to_seconds_after_midnight(Time.utc_now) do
    #   {x,_} when x < 28800-> Process.send_after(self(), :pull, x*1000)                    #before 8:00 am
    #   {x,_} -> Process.send_after(self(), :pull, (x+28800)*1000)                          #after 8:00 am
    # end

    Logger.info("Stops GenServer successfully started")
    {:ok, stops}
  end

  def get_state(), do: GenServer.call(__MODULE__, {:get_state})
  def handle_call({:get_state}, _from, state), do: {:reply, state, state}


  def get_stop(%{id: id}), do: GenServer.call(__MODULE__, {:stop_by_id, id})
  def get_stop(%{name: name}), do: GenServer.call(__MODULE__, {:stop_by_name, name})
  def get_stop(name), do: get_stop(%{name: name})


  def handle_call({:stop_by_id, id}, _from, state) do
    [stop] = Enum.filter(state,fn l -> l[:id]==id end) 
    {:reply, stop, state}
  end

  def handle_call({:stop_by_name, name}, _from, state) do
    {stop, _best_distance} = Enum.reduce(state, {%{},0}, fn stop, {s_acc, distance_acc} -> 
                                          distance = String.bag_distance(stop[:name],name) 
                                          distance >= distance_acc && {stop, distance} || {s_acc, distance_acc}
                                        end)
    {:reply, stop, state}
  end
end