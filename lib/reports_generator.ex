defmodule ReportsGenerator do
  @moduledoc """
  Documentation for `ReportsGenerator`.
  """

  alias ReportsGenerator.Parser

  @doc """
  Given the file path, function 'build' parses it to return the amount spent for each client (report_acc)
  """
  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn [id, _food_name, price], report ->
    Map.put(report, id, report[id] + price)
    end)
  end

  defp report_acc, do: Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})

end
