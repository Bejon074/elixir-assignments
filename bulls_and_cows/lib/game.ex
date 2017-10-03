defmodule Game do
    use GenServer
  
    @max_turns 9
    def max_turns, do: @max_turns
  
   # @derive [Poison.Encoder] # This will be used in part 3 to generate JSON
    defstruct [
      turns_left: @max_turns, 
      current_state: :playing, 
      secret: "", 
      last_guess: "", 
      feedback: ""
    ]
  
    def start_link() do
      GenServer.start_link(__MODULE__, [Secret.new()])
    end
  
    def init([secret]) do
      game = %Game{secret: secret}
      {:ok, game}
    end

    def game_state(pid) do
        GenServer.call(pid, {:getState})
    end

    def handle_call({:getState}, _from, state) do
        returnState = Map.delete(state, :secret)
        {:reply, returnState, state}
    end

    def submit_guess(pid, input) do
        GenServer.call(pid, {:submitGuess, input})
    end

    def handle_call({:submitGuess, input}, _from, state) do
        truns_left = case Map.get(state, :turns_left) == 0 do
            true -> Map.get(state, :turns_left)
            false -> Map.get(state, :turns_left) - 1 
        end
        current_state = case truns_left == 0 do
            true -> :lost
            false -> Map.get(state, :current_state)
        end
        last_guess = input
        feedback = BullsAndCows.score_guess(Map.get(state, :secret), input)
        totalBulls = findBulls(String.codepoints(Map.get(state, :secret)), String.codepoints(input), 0)
        current_state = case totalBulls == 4 do
            true -> :win
            false -> current_state
        end
        nawState = %Game{turns_left: truns_left, 
                        current_state: current_state,
                        last_guess: last_guess,
                        feedback: feedback,
                        secret: Map.get(state, :secret)}
        {:reply, state, nawState}
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
  end