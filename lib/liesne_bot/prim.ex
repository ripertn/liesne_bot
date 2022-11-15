defmodule Prim do
  use Tesla, only: [:get], docs: false
  require Logger

  @api (File.read!("./details/itwillbeourlittlesecret.json") |> Jason.decode!())["prim"]

  plug Tesla.Middleware.BaseUrl, @api["base_url"] <> @api["base_path"]
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Headers, [{"accept", "application/json"},{"apikey", @api["token"]}]

  @station_ids %{
    "melun" => %{id: "41361"},
    "fontainebleau" => %{id: "41372"},
    "bois" => %{id: "41371"},
    "gare de lyon" => %{id: "41396"}, # and 474065 or 474062
    "paris" => %{id: "41396"}
  }
  
  def get_api_details(), do: @api


  def get_next_train(text \\ "melun paris") do

    [station_from|station_to] = text |> String.downcase() |> String.split()
    station_to = station_to == [] && "paris" || List.first(station_to)

    station_from = sanitize(station_from)
    station_to = sanitize(station_to)
    # Calendar.put_time_zone_database(Tzdata.TimeZoneDatabase)

    path = URI.encode_www_form("stop-monitoring?MonitoringRef=STIF:StopPoint:Q:#{station_from[:id]}:")
    
    res = case get(path) do
      {:ok,%{status: 200, body: body}} ->
        case body["Siri"]["ServiceDelivery"]["StopMonitoringDelivery"] |> hd() do
          %{"MonitoredStopVisit"=> next, "Status"=> "true" } ->
            next
              |> Enum.filter(fn n -> n["MonitoredVehicleJourney"]["DestinationRef"]["value"] == "STIF:StopPoint:Q:#{station_to[:id]}:" end) |> IO.inspect()
              |> Enum.map(fn n -> 
                                  %{
                                    expected_time: n["MonitoredVehicleJourney"]["MonitoredCall"]["ExpectedArrivalTime"],
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
                              line_ref = case d.line_ref do
                                "STIF:Line::C01745:" -> " ligne R"
                                "STIF:Line::C01731:" -> " ligne R POMA or PUMA"
                                _ -> " RER"
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

    
    # Enum.at(hd(tes.body["Siri"]["ServiceDelivery"]["StopMonitoringDelivery"])["MonitoredStopVisit"],0)
    
    # res = %{
      #   "ItemIdentifier" => "SNCF_ACCES_CLOUD:Item::41361_891024:LOC",
      #   "MonitoredVehicleJourney" => %{
        #     "DestinationName" => [%{"value" => "Gare de Lyon"}],
        #     "DestinationRef" => %{"value" => "STIF:StopPoint:Q:41396:"},
        #     "FramedVehicleJourneyRef" => %{
          #       "DataFrameRef" => %{"value" => "any"},
          #       "DatedVehicleJourneyRef" => "SNCF_ACCES_CLOUD:VehicleJourney::891024_20221111:LOC"
          #     },
          #     "LineRef" => %{"value" => "STIF:Line::C01745:"},
    #     "MonitoredCall" => %{
      #       "AimedArrivalTime" => "2022-11-11T14:46:00.000Z",
      #       "AimedDepartureTime" => "2022-11-11T14:47:00.000Z",
      #       "ArrivalPlatformName" => %{"value" => "2"},
      #       "ArrivalStatus" => "onTime",
      #       "DepartureStatus" => "onTime",
      #       "DestinationDisplay" => [%{"value" => "Gare de Lyon"}],
      #       "ExpectedArrivalTime" => "2022-11-11T14:50:23.000Z",
      #       "ExpectedDepartureTime" => "2022-11-11T14:51:23.000Z",
      #       "Order" => 16,
      #       "StopPointName" => [%{"value" => "Gare de Melun"}],
      #       "VehicleAtStop" => true
      #     },
      #     "OperatorRef" => %{"value" => "SNCF_ACCES_CLOUD:Operator::SNCF:"},
      #     "TrainNumbers" => %{"TrainNumberRef" => [%{"value" => "891024"}]}
    #   },
    #   "MonitoringRef" => %{"value" => "STIF:StopPoint:Q:41361:"},
    #   "RecordedAtTime" => "2022-11-11T14:51:22.883Z"
    # }
    
  end
  
  def sanitize(station \\ "melun") do
    IO.inspect(station)
    station = String.downcase(station)
    if @station_ids[station] do
      @station_ids[station]
    else
      {best_station, _bag_distance} = @station_ids
                                                  |> Map.keys()
                                                  |> Enum.reduce({"",0.0}, fn s,{station_acc,distance_acc} -> 
                                                      distance_s = String.bag_distance(s, station)
                                                      distance_s > distance_acc && {s,distance_s} || {station_acc,distance_acc}  
                                                    end)
      @station_ids[best_station]
    end 
  end

  def human_readable(line) do
    
  end
  
end