defmodule Mix.Tasks.Complete do
  use Mix.Task

  @shortdoc "Cache tab completions for mix"
  def run(_) do
    loadpaths!()

    modules = load_tasks()
    aliases = load_aliases()

    docs = build_doc_list(modules, aliases)
    text = docs |> Enum.sort() |> Enum.map(fn {task, shortdoc} -> "#{task}\t#{shortdoc}" end) |> Enum.join("\n")
    # text = elem(System.shell("mix help --names"), 0)
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

  defp loadpaths! do
    args = ["--no-elixir-version-check", "--no-deps-check", "--no-archives-check"]
    Mix.Task.run("loadpaths", args)
    Mix.Task.reenable("loadpaths")
    Mix.Task.reenable("deps.loadpaths")
  end

  defp load_tasks() do
    Enum.filter(Mix.Task.load_all(), &(Mix.Task.moduledoc(&1) != false))
  end

  defp load_aliases() do
    aliases = Mix.Project.config()[:aliases]

    Map.new(aliases, fn {alias_name, alias_tasks} -> {Atom.to_string(alias_name), alias_tasks} end)
  end

  defp build_doc_list(modules, aliases) do
    task_docs = build_task_doc_list(modules)
    alias_docs = build_alias_doc_list(aliases)
    task_docs ++ alias_docs
  end

  defp build_task_doc_list(modules) do
    Enum.reduce(modules, [], fn module, docs ->
      if doc = Mix.Task.shortdoc(module) do
        task = Mix.Task.task_name(module)
        [{task, doc} | docs]
      else
        docs
      end
    end)
  end

  defp build_alias_doc_list(aliases) do
    Enum.reduce(aliases, [], fn {alias_name, _task_name}, docs ->
      doc = "Alias defined in mix.exs"
      task = alias_name
      [{task, doc} | docs]
    end)
  end

  end

