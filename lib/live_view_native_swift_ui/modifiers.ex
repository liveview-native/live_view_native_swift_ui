defmodule LiveViewNativeSwiftUi.Modifiers do
  @moduledoc false
  defstruct [
    :frame,
    :list_row_insets,
    :list_row_separator,
    :navigation_title,
    :padding,
    :tint
  ]

  def encode_map(%{} = map) do
    map
    |> Enum.into(%{})
  end

  defimpl Phoenix.HTML.Safe do
    alias LiveViewNativeSwiftUi.Modifiers

    def to_iodata(data) do
      modifiers =
        data
        |> Map.from_struct()
        |> Enum.reduce([], fn {key, props}, acc ->
          case props do
            %{} = props ->
              modifier =
                props
                |> Modifiers.encode_map()
                |> Map.put(:type, key)

              acc ++ [modifier]

            _ ->
              acc
          end
        end)
        |> Enum.sort_by(fn %{type: type} -> type end)

      case modifiers do
        [] ->
          ""

        modifiers ->
          Jason.encode!(modifiers)
          |> Phoenix.HTML.Engine.html_escape()
      end
    end
  end
end
