defmodule LiveViewNativeSwiftUiTest.ShapeStyleTest do
  use ExUnit.Case
  doctest LiveViewNativeSwiftUi.Types.ShapeStyle

  alias LiveViewNativeSwiftUi.Types.ShapeStyle

  test "shadow" do
    actual = ShapeStyle.tint |> ShapeStyle.shadow(:drop, 15)
      |> Phoenix.HTML.Safe.to_iodata()
      |> IO.iodata_to_binary()

    assert actual == "{&quot;shadow&quot;:{&quot;color&quot;:null,&quot;radius&quot;:15,&quot;root&quot;:{&quot;tint&quot;:{}},&quot;style&quot;:&quot;drop&quot;,&quot;x&quot;:null,&quot;y&quot;:null}}"
  end
end
