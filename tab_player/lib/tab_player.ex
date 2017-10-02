defmodule TabPlayer do
  require Integer
    def parse(tab) do
      generateFinalList(tab)
      |> Enum.join(" ")
    end

    def generateColumnWiseList (stringlist) do
      [head | _ ] = stringlist
      length = String.length(head) - 1
      for index <- 2..length, do: findStringForPosition(stringlist, index)      
    end

    def findStringForPosition(stringList, position) do
      for x <- stringList do
        case (String.at(x, position) == "-") do
          true -> nil
          false -> case String.at(x, position) == "|" do
            true -> "|"
            false -> String.at(x, 0) <> String.at(x, position)
          end
        end
      end
    end

    def generateFinalList(str) do
      stringList = String.split( str, "\n")
      columnWiseList = generateColumnWiseList(Enum.filter(stringList, fn string -> string != "" end))
      finalList = Enum.filter( List.flatten(readMultipleListAndProcessResult(columnWiseList, 2)), & !is_nil(&1))
      finalList
    end

    def readMultipleListAndProcessResult([head | tail], listIndex) do
      case isItStart(head, true) do
        false -> case Integer.is_odd(listIndex) do
          true -> [readSingleListAndGenerateSingleResult(head, "", true) | readMultipleListAndProcessResult(tail, listIndex + 1)]
          false -> [readSingleListAndGenerateSingleResult(head, "", false) | readMultipleListAndProcessResult(tail, listIndex + 1)]
        end
        true -> readMultipleListAndProcessResult(tail, 0)
        end
    end

    def readMultipleListAndProcessResult([], _), do: []

    def isItStart([head | tail], acc) do
      case head == "|" do
        true -> isItStart(tail, (true && acc))
        false -> isItStart(tail, (false && acc))
      end
    end
    def isItStart([], acc), do: acc


    def readSingleListAndGenerateSingleResult([head | tail], acc, isDash) do
      case head == nil do
        true -> readSingleListAndGenerateSingleResult(tail, acc, isDash)
        _ -> case acc == "" do
            true -> readSingleListAndGenerateSingleResult(tail, acc <> head, isDash)
            _ -> readSingleListAndGenerateSingleResult(tail, acc <>"/"<> head, isDash)
        end
      end
    end

    def readSingleListAndGenerateSingleResult([], acc, isDash) do
      case acc == "" do
        true -> case isDash do
          true -> "_"
          false -> nil
        end
        _ -> acc
      end
    end

  end