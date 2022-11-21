defmodule API.Prim do
  @moduledoc """
    Module wrapping the "Plateforme Régional d'Information pour la Mobilité" API:
    - real time info message on the trafic
    - real time for one line
    - real time from one stop
    - generic data
  """
  use Tesla, only: [:get], docs: false
  require Logger

  @api (File.read!("./details/itwillbeourlittlesecret.json") |> Jason.decode!())["prim"]

  plug Tesla.Middleware.BaseUrl, @api["base_url"] <> @api["base_path"]
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Headers, [
                                  {"accept", "application/json"},
                                  {"apikey", @api["token"]},
                                  {"Accept-encoding", "gzip, deflate"}
                                  ]
  plug Tesla.Middleware.Compression
  
  
  def get_api_details(), do: @api

  @doc """
    http get on /stop-monitoring
    real time next trains from one stop. For example:
    API.Prim.get_next_trains_at_a_stop(%{name: "melun", id: "41361"})
  """
  def get_stop_monitoring(stopdata) do
    path = URI.encode_www_form("stop-monitoring?MonitoringRef=STIF:StopPoint:Q:#{stopdata[:id]}:")    
    case get(path) do
      {:ok,%{status: 200, body: body}} ->
        Logger.info("Successful call to PRIM api /stop-monitoring at stop: #{stopdata[:name] <> " - " <> stopdata[:id]}")
        {:ok,body}
      {:ok,%{status: http_code}} ->
        Logger.debug("bad http code #{http_code} when calling PRIM api /stop-monitoring at stop: #{stopdata[:name] <> " - " <> stopdata[:id]}")
        {:ko,%{error: "Failed to get next train"}}
      other_answer ->
        Logger.debug("bad answer when calling PRIM api /stop-monitoring at stop: #{stopdata[:name] <> " - " <> stopdata[:id]}: #{IO.inspect(other_answer)}")
        {:ko,%{error: "Failed to get next train"}}
    end
  end

  @doc """
    http get on /estimated-timetable
    real time timetable of one line. For example:
    API.Prim.get_timetable_of_a_line("C01731")
  """
  def get_estimated_timetable(line \\ "C01731") do
    
    path = URI.encode_www_form("estimated-timetable?LineRef=STIF:Line::#{line}:")
    
    case get(path) do
      {:ok,%{status: 200, body: body}} ->
        Logger.info("Successful call to PRIM api /estimated-timetable for line: #{line}")
        {:ok,body}
      {:ok,%{status: http_code}} ->
        Logger.debug("bad http code #{http_code} when calling PRIM api /estimated-timetable for line: #{line}")
        {:ko,%{error: "Failed to get timetable"}}
      other_answer ->
        Logger.debug("bad answer when calling PRIM api /estimated-timetable for line #{line}: #{IO.inspect(other_answer)}")
        {:ko,%{error: "Failed to get timetable"}}
    end
  end

end
