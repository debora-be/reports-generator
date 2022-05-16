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

  @doc """
  Given the file path, build() parses it to return the amount spent (sum_values()) for each client with report_acc()
  """
  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report -> sum_values(line, report) end)
  end

  @doc """
  Returns the highest values from a list. Exemple of a call:
  iex(2)> "report_complete.csv" |> ReportsGenerator.build() |> ReportsGenerator.fetch_higher_cost()
  {"13", 282953}
  """
  def fetch_higher_cost(report), do: Enum.max_by(report, fn {_key, value} -> value end)

  defp sum_values([id, food_name, price], %{"foods" => foods, "users" => users} = report) do
    users = Map.put(users, id, users[id] + price)
    foods = Map.put(foods, food_name, foods[food_name] + 1)

    %{report | "users" => users, "foods" => foods}
  end

  defp report_acc do
    users = Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})
    foods = Enum.into(@available_foods, %{}, &{(&1), 0})

    %{"users" => users, "foods" => foods}
  end

end
