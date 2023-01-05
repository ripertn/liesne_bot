defmodule W do
  @moduledoc """
    module used to dev in iex and save time
  """

  require Logger

  def open_json(path), do: path |> File.read!() |> Jason.decode!()

  @doc """
      simple function to write to json
  """
  def write_json(path, content), do: File.write(path, Jason.encode!(content))



  def dev1(responsejson \\ "details/response_1668697983943.json") do
    res = File.read!(responsejson) |> Jason.decode!()
    j = hd(hd(res["Siri"]["ServiceDelivery"]["EstimatedTimetableDelivery"])["EstimatedJourneyVersionFrame"])["EstimatedVehicleJourney"]

  end

  def dev2(journeys) do

    Enum.map(journeys, fn j -> 
      {
        j["DestinationName"],
        j["EstimatedCalls"]["EstimatedCall"]
          |> Enum.map(fn c -> {
                                c["StopPointRef"],
                                elem(DateTime.from_iso8601(c["ExpectedDepartureTime"] || c["ExpectedArrivalTime"]),1)
                                }
                      end)
          |> Enum.sort_by(fn {_,t} -> t end, {:asc,DateTime}),
        } end)
  end
  

  def sample_journey() do
    %{
      "DatedVehicleJourneyRef" => %{
        "value" => "SNCF_ACCES_CLOUD:VehicleJourney::152964_20221117:LOC"
      },
      "DestinationName" => [%{"value" => "Gare de Lyon"}],
      "DestinationRef" => %{"value" => "STIF:StopPoint:Q:41396:"},
      "DirectionRef" => %{},
      "EstimatedCalls" => %{
        "EstimatedCall" => [
          %{
            "AimedArrivalTime" => "2022-11-17T17:55:00.000Z",
            "ArrivalPlatformName" => %{"value" => "2"},
            "ArrivalProximityText" => %{},
            "ArrivalStatus" => "onTime",
            "DepartureStatus" => "onTime",
            "DestinationDisplay" => [%{"value" => "Gare de Lyon"}],
            "ExpectedArrivalTime" => "2022-11-17T17:56:31.000Z",
            "ExpectedDepartureTime" => "2022-11-17T17:56:31.000Z",
            "StopPointRef" => %{"value" => "STIF:StopPoint:Q:41366:"}
          },
          %{
            "AimedArrivalTime" => "2022-11-17T17:38:10.000Z",
            "AimedDepartureTime" => "2022-11-17T17:39:10.000Z",
            "ArrivalPlatformName" => %{"value" => "2"},
            "ArrivalProximityText" => %{},
            "ArrivalStatus" => "onTime",
            "DepartureStatus" => "onTime",
            "DestinationDisplay" => [%{"value" => "Gare de Lyon"}],
            "ExpectedArrivalTime" => "2022-11-17T17:39:41.000Z",
            "ExpectedDepartureTime" => "2022-11-17T17:40:41.000Z",
            "StopPointRef" => %{"value" => "STIF:StopPoint:Q:41371:"}
          },
          %{
            "AimedArrivalTime" => "2022-11-17T18:13:00.000Z",
            "ArrivalPlatformName" => %{},
            "ArrivalProximityText" => %{},
            "ArrivalStatus" => "onTime",
            "DestinationDisplay" => [%{"value" => "Gare de Lyon"}],
            "ExpectedArrivalTime" => "2022-11-17T18:14:31.000Z",
            "StopPointRef" => %{"value" => "STIF:StopPoint:Q:41396:"}
          },
          %{
            "AimedArrivalTime" => "2022-11-17T17:57:00.000Z",
            "ArrivalPlatformName" => %{"value" => "2"},
            "ArrivalProximityText" => %{},
            "ArrivalStatus" => "onTime",
            "DepartureStatus" => "onTime",
            "DestinationDisplay" => [%{"value" => "Gare de Lyon"}],
            "ExpectedArrivalTime" => "2022-11-17T17:58:31.000Z",
            "ExpectedDepartureTime" => "2022-11-17T17:58:31.000Z",
            "StopPointRef" => %{"value" => "STIF:StopPoint:Q:41364:"}
          },
          %{
            "AimedArrivalTime" => "2022-11-17T17:44:00.000Z",
            "AimedDepartureTime" => "2022-11-17T17:45:00.000Z",
            "ArrivalPlatformName" => %{"value" => "2"},
            "ArrivalProximityText" => %{},
            "ArrivalStatus" => "onTime",
            "DepartureStatus" => "onTime",
            "DestinationDisplay" => [%{"value" => "Gare de Lyon"}],
            "ExpectedArrivalTime" => "2022-11-17T17:45:31.000Z",
            "ExpectedDepartureTime" => "2022-11-17T17:46:31.000Z",
            "StopPointRef" => %{"value" => "STIF:StopPoint:Q:41361:"}
          },
          %{
            "AimedArrivalTime" => "2022-11-17T17:31:20.000Z",
            "AimedDepartureTime" => "2022-11-17T17:32:20.000Z",
            "ArrivalPlatformName" => %{"value" => "2"},
            "ArrivalProximityText" => %{},
            "ArrivalStatus" => "onTime",
            "DepartureStatus" => "onTime",
            "DestinationDisplay" => [%{"value" => "Gare de Lyon"}],
            "ExpectedArrivalTime" => "2022-11-17T17:31:32.000Z",
            "ExpectedDepartureTime" => "2022-11-17T17:32:32.000Z",
            "StopPointRef" => %{"value" => "STIF:StopPoint:Q:41372:"}
          },
          %{
            "AimedArrivalTime" => "2022-11-17T17:49:30.000Z",
            "ArrivalPlatformName" => %{"value" => "2"},
            "ArrivalProximityText" => %{},
            "ArrivalStatus" => "onTime",
            "DepartureStatus" => "onTime",
            "DestinationDisplay" => [%{"value" => "Gare de Lyon"}],
            "ExpectedArrivalTime" => "2022-11-17T17:51:01.000Z",
            "ExpectedDepartureTime" => "2022-11-17T17:51:01.000Z",
            "StopPointRef" => %{"value" => "STIF:StopPoint:Q:41368:"}
          },
          %{
            "AimedArrivalTime" => "2022-11-17T17:24:30.000Z",
            "AimedDepartureTime" => "2022-11-17T17:25:30.000Z",
            "ArrivalPlatformName" => %{"value" => "2"},
            "ArrivalProximityText" => %{},
            "ArrivalStatus" => "onTime",
            "DepartureStatus" => "onTime",
            "DestinationDisplay" => [%{"value" => "Gare de Lyon"}],
            "ExpectedArrivalTime" => "2022-11-17T17:24:42.000Z",
            "ExpectedDepartureTime" => "2022-11-17T17:25:42.000Z",
            "StopPointRef" => %{"value" => "STIF:StopPoint:Q:41374:"}
          },
          %{
            "AimedArrivalTime" => "2022-11-17T18:05:50.000Z",
            "ArrivalPlatformName" => %{"value" => "2M"},
            "ArrivalProximityText" => %{},
            "ArrivalStatus" => "onTime",
            "DepartureStatus" => "onTime",
            "DestinationDisplay" => [%{"value" => "Gare de Lyon"}],
            "ExpectedArrivalTime" => "2022-11-17T18:07:21.000Z",
            "ExpectedDepartureTime" => "2022-11-17T18:07:21.000Z",
            "StopPointRef" => %{"value" => "STIF:StopPoint:Q:41337:"}
          },
          %{
            "AimedDepartureTime" => "2022-11-17T17:14:00.000Z",
            "ArrivalPlatformName" => %{},
            "ArrivalProximityText" => %{},
            "DepartureStatus" => "onTime",
            "DestinationDisplay" => [%{"value" => "Gare de Lyon"}],
            "ExpectedDepartureTime" => "2022-11-17T17:14:00.000Z",
            "StopPointRef" => %{"value" => "STIF:StopPoint:Q:41376:"}
          },
          %{
            "AimedArrivalTime" => "2022-11-17T18:01:10.000Z",
            "ArrivalPlatformName" => %{"value" => "2"},
            "ArrivalProximityText" => %{},
            "ArrivalStatus" => "onTime",
            "DepartureStatus" => "onTime",
            "DestinationDisplay" => [%{"value" => "Gare de Lyon"}],
            "ExpectedArrivalTime" => "2022-11-17T18:02:41.000Z",
            "ExpectedDepartureTime" => "2022-11-17T18:02:41.000Z",
            "StopPointRef" => %{"value" => "STIF:StopPoint:Q:41360:"}
          },
          %{
            "AimedArrivalTime" => "2022-11-17T17:21:30.000Z",
            "AimedDepartureTime" => "2022-11-17T17:22:10.000Z",
            "ArrivalPlatformName" => %{"value" => "2M"},
            "ArrivalProximityText" => %{},
            "ArrivalStatus" => "onTime",
            "DepartureStatus" => "onTime",
            "DestinationDisplay" => [%{"value" => "Gare de Lyon"}],
            "ExpectedArrivalTime" => "2022-11-17T17:21:42.000Z",
            "ExpectedDepartureTime" => "2022-11-17T17:22:22.000Z",
            "StopPointRef" => %{"value" => "STIF:StopPoint:Q:41375:"}
          },
          %{
            "AimedArrivalTime" => "2022-11-17T17:52:50.000Z",
            "ArrivalPlatformName" => %{"value" => "2"},
            "ArrivalProximityText" => %{},
            "ArrivalStatus" => "onTime",
            "DepartureStatus" => "onTime",
            "DestinationDisplay" => [%{"value" => "Gare de Lyon"}],
            "ExpectedArrivalTime" => "2022-11-17T17:54:21.000Z",
            "ExpectedDepartureTime" => "2022-11-17T17:54:21.000Z",
            "StopPointRef" => %{"value" => "STIF:StopPoint:Q:41367:"}
          },
          %{
            "AimedArrivalTime" => "2022-11-17T17:51:10.000Z",
            "ArrivalPlatformName" => %{"value" => "2"},
            "ArrivalProximityText" => %{},
            "ArrivalStatus" => "onTime",
            "DepartureStatus" => "onTime",
            "DestinationDisplay" => [%{"value" => "Gare de Lyon"}],
            "ExpectedArrivalTime" => "2022-11-17T17:52:41.000Z",
            "ExpectedDepartureTime" => "2022-11-17T17:52:41.000Z",
            "StopPointRef" => %{"value" => "STIF:StopPoint:Q:41370:"}
          },
          %{
            "AimedArrivalTime" => "2022-11-17T17:55:40.000Z",
            "ArrivalPlatformName" => %{"value" => "2"},
            "ArrivalProximityText" => %{},
            "ArrivalStatus" => "onTime",
            "DepartureStatus" => "onTime",
            "DestinationDisplay" => [%{"value" => "Gare de Lyon"}],
            "ExpectedArrivalTime" => "2022-11-17T17:57:11.000Z",
            "ExpectedDepartureTime" => "2022-11-17T17:57:11.000Z",
            "StopPointRef" => %{"value" => "STIF:StopPoint:Q:41365:"}
          },
          %{
            "AimedArrivalTime" => "2022-11-17T17:58:50.000Z",
            "ArrivalPlatformName" => %{"value" => "2"},
            "ArrivalProximityText" => %{},
            "ArrivalStatus" => "onTime",
            "DepartureStatus" => "onTime",
            "DestinationDisplay" => [%{"value" => "Gare de Lyon"}],
            "ExpectedArrivalTime" => "2022-11-17T18:00:21.000Z",
            "ExpectedDepartureTime" => "2022-11-17T18:00:21.000Z",
            "StopPointRef" => %{"value" => "STIF:StopPoint:Q:41362:"}
          },
          %{
            "AimedArrivalTime" => "2022-11-17T17:47:20.000Z",
            "ArrivalPlatformName" => %{"value" => "2"},
            "ArrivalProximityText" => %{},
            "ArrivalStatus" => "onTime",
            "DepartureStatus" => "onTime",
            "DestinationDisplay" => [%{"value" => "Gare de Lyon"}],
            "ExpectedArrivalTime" => "2022-11-17T17:48:51.000Z",
            "ExpectedDepartureTime" => "2022-11-17T17:48:51.000Z",
            "StopPointRef" => %{"value" => "STIF:StopPoint:Q:41369:"}
          },
          %{
            "AimedArrivalTime" => "2022-11-17T17:58:00.000Z",
            "ArrivalPlatformName" => %{"value" => "2"},
            "ArrivalProximityText" => %{},
            "ArrivalStatus" => "onTime",
            "DepartureStatus" => "onTime",
            "DestinationDisplay" => [%{"value" => "Gare de Lyon"}],
            "ExpectedArrivalTime" => "2022-11-17T17:59:31.000Z",
            "ExpectedDepartureTime" => "2022-11-17T17:59:31.000Z",
            "StopPointRef" => %{"value" => "STIF:StopPoint:Q:41363:"}
          },
          %{
            "AimedArrivalTime" => "2022-11-17T17:28:20.000Z",
            "ArrivalPlatformName" => %{"value" => "2"},
            "ArrivalProximityText" => %{},
            "ArrivalStatus" => "onTime",
            "DepartureStatus" => "onTime",
            "DestinationDisplay" => [%{"value" => "Gare de Lyon"}],
            "ExpectedArrivalTime" => "2022-11-17T17:28:32.000Z",
            "ExpectedDepartureTime" => "2022-11-17T17:28:32.000Z",
            "StopPointRef" => %{"value" => "STIF:StopPoint:Q:41373:"}
          },
          %{
            "AimedArrivalTime" => "2022-11-17T18:04:50.000Z",
            "ArrivalPlatformName" => %{"value" => "2M"},
            "ArrivalProximityText" => %{},
            "ArrivalStatus" => "onTime",
            "DepartureStatus" => "onTime",
            "DestinationDisplay" => [%{"value" => "Gare de Lyon"}],
            "ExpectedArrivalTime" => "2022-11-17T18:06:21.000Z",
            "ExpectedDepartureTime" => "2022-11-17T18:06:21.000Z",
            "StopPointRef" => %{"value" => "STIF:StopPoint:Q:41338:"}
          }
        ]
      },
      "FirstOrLastJourney" => "unspecified",
      "JourneyNote" => [%{"value" => "PUMA"}],
      "LineRef" => %{"value" => "STIF:Line::C01731:"},
      "OperatorRef" => %{"value" => "SNCF_ACCES_CLOUD:Operator::SNCF:"},
      "OriginRef" => %{},
      "ProductCategoryRef" => %{},
      "PublishedLineName" => [%{"value" => "R"}],
      "RecordedAtTime" => "2022-11-17T17:39:57.568Z",
      "RouteRef" => %{}
    }
  end

  def sample_rail_stop() do
    %{
      "datasetid" => "arrets",
      "fields" => %{
        "arraccessibility" => "partial",
        "arraudiblesignals" => "unknown",
        "arrchanged" => "2020-08-25T21:07:50+02:00",
        "arrcreated" => "2014-12-29T02:00:00+01:00",
        "arrgeopoint" => [48.83069026787006, 1.9600576282081914],
        "arrid" => "41246",
        "arrname" => "Gare de Plaisir les Clayes",
        "arrpostalregion" => "78490",
        "arrtown" => "Plaisir",
        "arrtype" => "rail",
        "arrversion" => "1096524-1119819",
        "arrvisualsigns" => "unknown",
        "arrxepsg2154" => 623659,
        "arryepsg2154" => 6859462
      },
      "geometry" => %{
        "coordinates" => [1.9600576282081914, 48.83069026787006],
        "type" => "Point"
      },
      "record_timestamp" => "2022-11-18T01:40:26.552+01:00",
      "recordid" => "f93a4503ffaf4a2e1b280a0dcdbb03e41317f055"
    }
  end

  def sample_line() do
    %{
      "datasetid" => "referentiel-des-lignes",
      "fields" => %{
        "accessibility" => "false",
        "audiblesigns_available" => "unknown",
        "colourprint_cmjn" => "23 11 100 0",
        "colourweb_hexa" => "cec73d",
        "externalcode_line" => "000535800:EXTS",
        "id_groupoflines" => "A02471",
        "id_line" => "C02479",
        "name_line" => "Extrême Soirée",
        "networkname" => "Mantois",
        "operatorname" => "RD Mantois",
        "operatorref" => "1011",
        "shortname_groupoflines" => "LIGNE EXTREME SOIREE CONFLANS - LES MUREAUX - MANTES-LA-JOLIE",
        "shortname_line" => "EXTS",
        "status" => "active",
        "textcolourprint_hexa" => "000000",
        "textcolourweb_hexa" => "000000",
        "transportmode" => "bus",
        "transportsubmode" => "localBus",
        "visualsigns_available" => "unknown"
      },
      "record_timestamp" => "2022-11-16T15:24:00.910+01:00",
      "recordid" => "8ecda70a861e88908bb41edfa0cda1d2d8e2933f"
    }    
  end

  def sample_station() do
    %{
      "datasetid" => "emplacement-des-gares-idf",
      "fields" => %{
        "nom_lda" => "Achères Ville",
        "nom" => "Achères-Ville",
        "fer" => 1.0,
        "navette" => 0.0,
        "id_ref_lda" => 73604.0,
        "ternavette" => "0",
        "terrer" => "0",
        "idrefligc" => "C01742",
        "termetro" => "0",
        "terfer" => "0",
        "terval" => "0",
        "train" => 0.0,
        "rer" => 1.0,
        "idf" => 1.0,
        "nom_zdl" => "Achères Ville",
        "val" => 0.0,
        "id_ref_zdl" => 46647.0,
        "geo_shape" => %{
          "coordinates" => [2.077731764565598, 48.97066504740207],
          "type" => "Point"
        },
        "nom_long" => "Achères-Ville",
        "mode" => "RER",
        "res_com" => "RER A",
        "tramway" => 0.0,
        "indice_lig" => "A",
        "num_mod" => 0.0,
        "idrefliga" => "A01856",
        "gares_id" => 6.0,
        "principal" => 0.0,
        "picto" => %{
          "filename" => "RER_A.svg",
          "format" => "svg",
          "height" => 300,
          "id" => "2922fd9716bdb3b0487b2960b932652a",
          "mimetype" => "image/svg+xml",
          "thumbnail" => true,
          "width" => 300
        },
        "exploitant" => "SNCF",
        "y" => 6874918.732500002,
        "geo_point_2d" => [48.97066504740207, 2.077731764565598],
        "tertram" => "0",
        "nom_iv" => "Achères-Ville",
        "tertrain" => "0",
        "ligne" => "RER A",
        "metro" => 0.0,
        "x" => 632479.4114999995
      },
      "geometry" => %{
        "coordinates" => [2.077731764565598, 48.97066504740207],
        "type" => "Point"
      },
      "record_timestamp" => "2022-07-25T09:47:37.397+02:00", 
      "recordid" => "1c8db5bc504a73d0305eb24e4fedc7565f42b4c8"
    }    
  end
  
end