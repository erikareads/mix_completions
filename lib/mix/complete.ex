defmodule Mix.Tasks.Complete do
  use Mix.Task

  @shortdoc "Cache tab completions for mix"
  def run(_) do
    text = elem(System.shell("mix help --names"), 0)
    cache_dir = case System.get_env("XDG_CACHE_HOME") do
      nil -> Path.join([System.get_env("HOME"), ".cache"])
      "" -> Path.join([System.get_env("HOME"), ".cache"])
      xdg_cache_home -> xdg_cache_home
    end

    if File.exists?("mix.exs") do
      File.write(".mix_complete.cache", text)
      IO.puts(:stderr, "cache updated in project directory")
    else
      File.write(Path.join([cache_dir, ".mix_complete.cache"]), text) 
      IO.puts(:stderr, "cache updated in #{cache_dir}")
    end
  end
end
