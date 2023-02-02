defmodule Api do

  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://2ch.hk"
  plug Tesla.Middleware.Headers, []
  plug Tesla.Middleware.JSON

  defp get_thread(board, thread) do
    get("/#{board}/res/#{thread}.json")
  end

  def get_file(%{"name" => name, "path" => path}) do
    response = get(path)
    case response do
      {:ok, %{body: body, status: 200}} -> :ok # perform saving here
      {:ok, %{status: 404}} -> {:error, :not_found}
      _ -> {:error, :request_failed}
    end
  end

  def get_response(board, thread) do
    response = get_thread(board, thread)
    case response do
      {:ok, %{body: body, status: 200}} -> case body do
        %{"threads" => [%{"posts" => posts}]} -> posts
        _ -> {:error, :unexpected_error}
      end
      {:ok, %{status: 404}} -> {:error, :not_found}
      _ -> {:error, :request_failed}
    end  
  end  

end
