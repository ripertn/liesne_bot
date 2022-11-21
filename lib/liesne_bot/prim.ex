defmodule Prim do
  use Tesla, only: [:get], docs: false
  require Logger

  @api (File.read!("./details/itwillbeourlittlesecret.json") |> Jason.decode!())["prim"]
  
  def get_api_details(), do: @api

  def get_trains(text \\ "melun") do
    case get_journey(text) do
      %{station_from: station_from, station_to: station_to}->
        # TODO
        ""
      %{station_from: station_from}->
        case API.Prim.get_stop_monitoring(station_from) do
          {:ok,body}->
            body
              |> Connector.Prim.format_stop_monitoring()
              |> Enum.filter(& &1.expected_time && &1.id_line && &1.name_terminus)
              |> Enum.map(fn next_train ->
                            expected_time = to_readable_time(next_train.expected_time)
                            type_of_train = case Lines.get_line_details(next_train.id_line) do
                              %{"networkname"=> networkname, "name_line"=> name_line} -> " " <> networkname <> " " <> name_line <> " " <> next_train.info_line
                              _other-> " ligne inconnue"
                            end
                            expected_time <> " " <> next_train.name_terminus <> type_of_train
                          end)
              |> Enum.join("\n")
              |> IO.inspect()
          {:ko,error}-> {:ko,error}
        end
    end
  end

  def get_journey(text \\ "melun") do
    case text |> String.downcase() |> String.split() do
      [station_from] ->
        IO.inspect("station_from")
        %{station_from: Stops.get_stop(%{name: station_from})}
      [station_from, station_to] ->
        %{station_from: Stops.get_stop(%{name: station_from}), station_to: Stops.get_stop(%{name: station_to})}
      [station_from|t] ->
        station_to = Enum.join(t," ")
        %{station_from: Stops.get_stop(%{name: station_from}), station_to: Stops.get_stop(%{name: station_to})}
    end    
  end





  def get_next_train(text \\ "melun") do

    [station_from|station_to] = text |> String.downcase() |> String.split()
    station_to = station_to == [] && "paris" || List.first(station_to)

    # station_from = sanitize(station_from)
    # station_to = sanitize(station_to)
    # Calendar.put_time_zone_database(Tzdata.TimeZoneDatabase)

    # TO DO: check that station_from and station_to belongs to the same line

    path = URI.encode_www_form("stop-monitoring?MonitoringRef=STIF:StopPoint:Q:#{station_from[:id]}:")
    
    case get(path) do
      {:ok,%{status: 200, body: body}} ->
        case body["Siri"]["ServiceDelivery"]["StopMonitoringDelivery"] |> hd() do
          %{"MonitoredStopVisit"=> next, "Status"=> "true" } ->
            next
              |> Enum.filter(fn n -> n["MonitoredVehicleJourney"]["DestinationRef"]["value"] == "STIF:StopPoint:Q:#{station_to[:id]}:" end) |> IO.inspect()
              |> Enum.map(fn n -> 
                                  %{
                                    expected_time: n["MonitoredVehicleJourney"]["MonitoredCall"]["ExpectedDepartureTime"],
                                    line_ref: n["MonitoredVehicleJourney"]["LineRef"]["value"]
                                  }
                                end)
              |> Enum.filter(& &1[:expected_time])
              |> Enum.map(fn d -> 
                                expected_time = d.expected_time
                                  |> DateTime.from_iso8601()
                                  |> elem(1) 
                                  |> DateTime.shift_zone("Europe/Paris")
                                  |> elem(1)
                                  |> DateTime.to_time()
                                  |> Time.truncate(:second)
                                  |> to_string()
                                  |> String.split("+") 
                                  |> hd()
                                "STIF:Line::" <> line_ref = String.trim_trailing(d.line_ref,":")
                                line_ref = case Lines.get_line_details(line_ref) do
                                  %{"networkname"=> networkname, "name_line"=> name_line} -> " " <> networkname <> " " <> name_line
                                  _ -> " unknown"
                                end
                                expected_time <> line_ref
                          end)
              |> Enum.join("\n")
              |> IO.inspect()
          other_answer ->
            Logger.debug("bad answer when calling PRIM api: #{other_answer}")
            "Failed to get next train"
          end
      {:ok,%{status: http_code}} ->
        Logger.debug("bad http code #{http_code} when calling PRIM api")
        "Failed to get next train"
        other_answer ->
        Logger.debug("bad answer when calling PRIM api: #{IO.inspect(other_answer)}")
        "Failed to get next train"
    end

  # call to /estimated-timetable


    
    # Enum.at(hd(tes.body["Siri"]["ServiceDelivery"]["StopMonitoringDelivery"])["MonitoredStopVisit"],0)
    

    
  end

  @doc """
    from "2022-11-11T14:46:00.000Z" to "14h46:00"
  """
  def to_readable_time(time) do
    time
      |> DateTime.from_iso8601()
      |> elem(1) 
      |> DateTime.shift_zone("Europe/Paris")
      |> elem(1)
      |> DateTime.to_time()
      |> Time.truncate(:second)
      |> to_string()
      |> String.split("+") 
      |> hd()
  end
  
end