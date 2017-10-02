defmodule BullsAndCows do
    require Integer
    def score_guess(secretCode, input) do
        totalCowsAndBulls = findCowsPlusBulls(secretCode, input)
        totalBulls = findBulls(String.codepoints(secretCode), String.codepoints(input), 0)
        totalCows = totalCowsAndBulls - totalBulls
        case totalBulls == String.length(secretCode) do
            true -> "You win"
            false -> Integer.to_string(totalBulls) <>" Bulls, " <> Integer.to_string(totalCows) <>" Cows"
        end
    end
    def findBulls([secretCodeHead|secretCodetail], [inputHead|inputTail], acc) do
        case secretCodeHead == inputHead do
            true -> findBulls(secretCodetail,inputTail, acc+1)
            false -> findBulls(secretCodetail,inputTail, acc)
        end
    end
    def findBulls([],[], acc) do
        acc
    end
    def findCowsPlusBulls(secretCode, input) do
        Enum.reduce(for index <- 0..(String.length(secretCode)-1) do
                case String.contains?(input,String.at(secretCode,index)) do
                    true -> true
                    false -> false
                end
            end, 0 , fn(x, acc) -> 
                case x do
                    true -> acc+1
                    false -> acc
                end
             end)
        end
end
