defmodule Connector.Prim do
  @moduledoc """
    all necessary functions to format data received from Prim (API and static dataset)
  """

  require Logger

  def open_json(path), do: path |> File.read!() |> Jason.decode!()

  @doc """
    connector used to format data received from PRIM API /stop-monitoring
  """
  def format_stop_monitoring(raw_body) do
    case raw_body["Siri"]["ServiceDelivery"]["StopMonitoringDelivery"] do
      [%{"MonitoredStopVisit"=> nexts, "Status"=> "true" }|_t] ->
        nexts |> Enum.map(fn n->
                                IO.inspect(n)
                                id_terminus = n["MonitoredVehicleJourney"]["DestinationRef"]["value"] |> String.split(":") |> Enum.at(3)
                                id_line = n["MonitoredVehicleJourney"]["LineRef"]["value"] |> String.split(":") |> Enum.at(3)
                                %{
                                  name_terminus: List.first(n["MonitoredVehicleJourney"]["DestinationName"])["value"],
                                  id_terminus: id_terminus,
                                  info_line: n["MonitoredVehicleJourney"]["JourneyNote"] && hd(n["MonitoredVehicleJourney"]["JourneyNote"])["value"] || "",
                                  id_line: id_line,
                                  platform_name: n["MonitoredVehicleJourney"]["MonitoredCall"]["ArrivalPlatformName"]["value"],
                                  status: n["MonitoredVehicleJourney"]["MonitoredCall"]["DepartureStatus"],
                                  expected_time: n["MonitoredVehicleJourney"]["MonitoredCall"]["ExpectedArrivalTime"]
                                                  || n["MonitoredVehicleJourney"]["MonitoredCall"]["ExpectedDepartureTime"],
                                  ref_train: n["MonitoredVehicleJourney"]["TrainNumbers"]["TrainNumberRef"] |> Enum.map(& &1["value"]),
                                }
                          end)
      other -> Logger.debug("unexpected body from PRIM API /stop-monitoring: #{to_string(other)}")
    end
  end

  @doc """
    connector used to format data received from PRIM API /estimated_timetable
  """
  def connector_estimated_timetable(raw_json) do
    %{"Siri"=>
        %{"ServiceDelivery"=>
          %{"EstimatedTimetableDelivery"=>
             [%{"EstimatedJourneyVersionFrame"=>
                [%{"EstimatedVehicleJourney"=>
                journeys
    }]}]}}} = raw_json

    journeys
  end

  @doc """
    get all stops basic data from https://data.iledefrance-mobilites.fr/explore/dataset/arrets/table/
  """
  def format_stops(path \\ "data/stops.json") do
    stops = open_json(path)
    stops
      |> Enum.map(fn s ->
                    case s["fields"]["arrtype"] do
                      "rail" -> Map.take(s["fields"], ["arrid", "arrname", "arrtown"])
                      other when other in ["bus", "tram", "metro"] -> nil # we do not handle bus, tram and metro
                      other ->
                        Logger.warn("unexpected arrtype: #{to_string(other)}, in : #{to_string(other)}")
                        nil
                    end
                  end)
      |> Enum.filter(fn stop -> stop && String.starts_with?(stop["arrname"], "Gare de ") end)
      |> Enum.map(fn stop ->
                            name = stop["arrname"]
                              |> String.downcase()
                              |> String.trim_leading("gare de ")
                            %{
                              id: stop["arrid"],
                              name: name,
                              town: stop["arrtown"]
                            }
                  end)
  end

  @doc """
    get all rail stops relationnal data from https://data.iledefrance-mobilites.fr/explore/dataset/emplacement-des-gares-idf/table/
  """
  def format_rail_stops(path \\ "data/railway_stations.json") do
    station = open_json(path)
    station |> Enum.map(fn s ->
                        Map.take(s["fields"], ["ligne","nom","idrefligc","id_ref_zdl","id_ref_lda"])
                        end)
            |> Enum.filter(& &1)
            |> Enum.group_by(& &1["idrefligc"])
  end

  @doc """
    get all stops relations from https://data.iledefrance-mobilites.fr/explore/dataset/relations/export/
    we know that:
      ZdClD <-> id_ref_zdl
      ZdAld <-> id_ref_lda
      ArRId <-> arrid
    so we can get 
  """
  def format_stops_relations(path \\ "data/stops_relations.json") do
    relations = open_json(path)
    relations
      |> Enum.map(fn r -> Map.take(r["fields"], ["ZdClD", "ZdAld", "ArRId"]) end)
      |> Enum.filter(& &1)
  end

  @doc """
    get all lines from https://data.iledefrance-mobilites.fr/explore/dataset/referentiel-des-lignes/table/?disjunctive.transportmode&disjunctive.transportsubmode&disjunctive.operatorname&disjunctive.networkname
  """
  def format_lines(path \\ "data/lines.json") do
    path
      |> open_json()
      |> Enum.map(fn l ->
                    case l["fields"]["transportmode"] do
                      "rail" -> l["fields"]
                      other when other in ["bus", "tram", "metro", "funicular"] -> nil # we do not care about bus, tram and metro
                      other ->
                        Logger.warn("unexpected transportmode: #{to_string(other)}, in : #{to_string(other)}")
                        nil
                    end
                  end)
      |> Enum.filter(& &1) 
  end

end