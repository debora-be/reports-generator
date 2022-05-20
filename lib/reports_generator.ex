defmodule ReportsGenerator do
  @moduledoc """
  Builds the file captured in the Parser, runs it line by line and returns the amount spent for each index from 1..30
  """

  alias ReportsGenerator.Parser

  @available_foods [
    "açaí",
    "churrasco",
    "esfirra",
    "hambúrguer",
    "pastel",
    "pizza",
    "prato_feito",
    "sushi"
  ]

  @options ["foods", "users"]

  @doc """
  Given the file name, build() parses the data
  """
  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report -> sum_values(line, report) end)
  end

  @doc """
  Given many file names, build_from_many() streams, parses the data and sums the values. Exemple of a call:
  iex(4)> ReportsGenerator.build_from_many(["report_1.csv", "report_2.csv", "report_3.csv"])
  """
  def build_from_many(filenames) do
    filenames
    |> Task.async_stream(&build &1)
    |> Enum.reduce(report_acc(), fn {:ok, result}, report -> sum_reports(report, result) end)
  end

  @doc """
  Returns the highest values from a list. Exemple of a call:
  iex(2)> "report_complete.csv" |> ReportsGenerator.build() |> ReportsGenerator.fetch_higher_cost()
  {"13", 282953}
  """
  def fetch_higher_cost(report, option) when option in @options do
    {:ok, Enum.max_by(report[option], fn {_key, value} -> value end)}
  end

  def fetch_higher_cost(_report, _option), do: {:error, "invalid option"}

  defp sum_reports(%{"foods" => foods1, "users" => users1}, %{
    "foods" => foods2,
    "users" => users2
  }) do
    foods = merge_maps(foods1, foods2)
    users = merge_maps(users1, users2)

    %{"foods" => foods, "users" => users}
  end

  defp merge_maps(map1, map2) do
    Map.merge(map1, map2, fn _key, value1, value2 -> value1 + value2 end)
  end

  defp sum_values([id, food_name, price], %{"foods" => foods, "users" => users} = report) do
    users = Map.put(users, id, users[id] + price)
    foods = Map.put(foods, food_name, foods[food_name] + 1)

    %{report | "users" => users, "foods" => foods}
  end

  defp report_acc do
    users = Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})
    foods = Enum.into(@available_foods, %{}, &{&1, 0})

    %{"users" => users, "foods" => foods}
  end
end
