defmodule ReportsGenerator do
  @moduledoc """
  Builds the file captured in the Parser, runs it line by line and returns the amount spent for each index from 1..30
  """

  alias ReportsGenerator.Parser

  @doc """
  Given the file path, build() parses it to return the amount spent (sum_values()) for each client with report_acc()
  """
  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report -> sum_values(line, report) end)
  end

  defp sum_values([id, _food_name, price], report), do: Map.put(report, id, report[id] + price)

  defp report_acc, do: Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})

end
