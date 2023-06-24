defmodule Mix.Tasks.Complete do
  use Mix.Task

  @shortdoc "Cache tab completions for mix"
  def run(_) do
    text = elem(System.shell("mix help | tail -n +2 | grep ^mix | awk '{print $2}'"), 0)
    File.write(".mix_complete.cache", text)
    IO.puts(:stderr, "cache updated")
  end
end
