defmodule LiveViewNativeSwiftUi.Types.UnitPoint do
  defstruct [:x, :y]

  use LiveViewNativePlatform.Modifier.Type
  def type, do: :map

  def cast(value) when is_map(value) or is_list(value), do: {:ok, struct(__MODULE__, value)}
end
