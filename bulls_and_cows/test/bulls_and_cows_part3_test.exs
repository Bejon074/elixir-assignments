defmodule BullsAndCowsPart3Test do
    use ExUnit.Case
    use Plug.Test
  
    @opts GameRouter.init([])
  
    test "Reports path / is not served by the application" do
      conn = conn(:get, "/")
      conn = GameRouter.call(conn, @opts)
      assert conn.status == 404
      assert conn.resp_body == "Oops"
    end

    test "Test Game Creation" do
        conn = conn(:post, "/games")
        conn = GameRouter.call(conn, @opts)
        assert conn.status == 201
        assert conn.resp_body == "Your game has been created"
        assert get_resp_header(conn, "Location") != nil
    end

    test "get game state using it's id" do
        conn = conn(:post, "/games")
        conn = GameRouter.call(conn, @opts)
        location = Enum.join(get_resp_header(conn, "Location"))
        conn = conn(:get, location)
        conn = GameRouter.call(conn, @opts)
        response = Poison.decode!(conn.resp_body)
        assert conn.resp_body != nil
        assert conn.status == 200
        refute Map.has_key?(response, :secret)
    end

    test "get game state using false id" do
        conn = conn(:post, "/games")
        conn = GameRouter.call(conn, @opts)
        conn = conn(:get, "/games/false-id")
        conn = GameRouter.call(conn, @opts)
        assert conn.resp_body != nil
        assert conn.status == 404
        assert conn.resp_body == "Game URL is unknown"
    end

    test "send guess to the server" do
        conn = conn(:post, "/games")
        conn = GameRouter.call(conn, @opts)
        location = Enum.join(get_resp_header(conn, "Location"))
        conn = conn(:post, location<>"/guesses", %{"guess" => "1234"})
        conn = GameRouter.call(conn, @opts)
        response = Poison.decode!(conn.resp_body)
        assert conn.resp_body != nil
        assert conn.status == 201
        refute Map.has_key?(response, :secret)       
    end

    test "send guess to the server. But in wrong url" do
        conn = conn(:post, "/games")
        conn = GameRouter.call(conn, @opts)
        location = Enum.join(get_resp_header(conn, "Location"))
        conn = conn(:post, "/games/false-id/guesses", %{"guess" => "1234"})
        conn = GameRouter.call(conn, @opts)
        assert conn.resp_body != nil
        assert conn.status == 404
        assert conn.resp_body ==  "Game URL is unknown"
    end

  end