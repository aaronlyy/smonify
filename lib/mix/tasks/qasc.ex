defmodule Mix.Tasks.Qasc do
  @moduledoc "Calls all security and quality tasks: mix help qasc"
  use Mix.Task

  @shortdoc "Calls bascically ever quality and security tool available."
  def run(_) do
    Mix.Task.run("dialyzer", [])
    Mix.Task.run("sobelow", [])
    Mix.Task.run("credo", ["--strict"])
    Mix.Task.run("deps.audit", [])
  end
end
