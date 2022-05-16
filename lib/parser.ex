defmodule ReportsGenerator.Parser do
  @moduledoc """
  Parser for data streamed by ReportsGenerator.
  """

  @doc """
  Captures data from csv and streams it line by line; parses it with parse_line()
  """
  def parse_file(filename) do
    "reports/#{filename}"
    |> File.stream!()
    |> Stream.map(fn line -> parse_line(line) end)
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> List.update_at(2, &String.to_integer/1)
  end

end
