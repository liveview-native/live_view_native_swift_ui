defmodule LiveViewNativeSwiftUi.Types.ShapeStyle do
  defstruct style: :color,
            props: %{}
  @type t :: %__MODULE__{style: atom, props: map}
  defp to_map(style), do: Map.new([{style.style, style.props}])

  def color(hex: hex), do: %__MODULE__{style: :hexColor, props: %{:hex => hex}}
  def color(system: name), do: %__MODULE__{style: :systemColor, props: %{:name => name}}
  def color(named: name), do: %__MODULE__{style: :namedColor, props: %{:name => name}}
  def black, do: color(system: :black)
  def blue, do: color(system: :blue)
  def brown, do: color(system: :brown)
  def clear, do: color(system: :clear)
  def cyan, do: color(system: :cyan)
  def gray, do: color(system: :gray)
  def green, do: color(system: :green)
  def indigo, do: color(system: :indigo)
  def mint, do: color(system: :mint)
  def orange, do: color(system: :orange)
  def pink, do: color(system: :pink)
  def purple, do: color(system: :purple)
  def red, do: color(system: :red)
  def teal, do: color(system: :teal)
  def white, do: color(system: :white)
  def yellow, do: color(system: :yellow)

  def hierarchical(level), do: %LiveViewNativeSwiftUi.Types.ShapeStyle{ style: :hierarchical, props: %{:level => level}}
  def primary, do: hierarchical(:primary)
  def secondary, do: hierarchical(:secondary)
  def tertiary, do: hierarchical(:tertiary)
  def quaternary, do: hierarchical(:quaternary)

  @type gradient_stop :: {
    %LiveViewNativeSwiftUi.Types.ShapeStyle{
      props: map,
      style: :hexColor | :systemColor | :namedColor
    },
    number
  }

  @type unit_point :: {number, number}

  defp encode_gradient_stops(stops), do: stops |> Enum.map(fn stop -> %{:color => to_map(elem(stop, 0)), :location => elem(stop, 1)} end)
  defp encode_unit_point(point), do: %{:x => elem(point, 0), :y => elem(point, 1)}

  @spec angular_gradient(list(gradient_stop), number, number, unit_point) :: t()
  def angular_gradient(stops, start_angle, end_angle, center) do
    %__MODULE__{
      style: :angularGradient,
      props: %{
        :stops => encode_gradient_stops(stops),
        :startAngle => start_angle,
        :endAngle => end_angle,
        :center => encode_unit_point(center)
      }
    }
  end
  @spec conic_gradient(list(gradient_stop), number, unit_point) :: t()
  def conic_gradient(stops, angle, center) do
    %__MODULE__{
      style: :conicGradient,
      props: %{
        :stops => encode_gradient_stops(stops),
        :angle => angle,
        :center => %{:x => elem(center, 0), :y => elem(center, 1)}
      }
    }
  end
  @spec elliptical_gradient(list(gradient_stop), float, float, unit_point) :: t()
  def elliptical_gradient(stops, start_radius_fraction, end_radius_fraction, center) do
    %__MODULE__{
      style: :ellipticalGradient,
      props: %{
        :stops => encode_gradient_stops(stops),
        :startRadiusFraction => start_radius_fraction,
        :endRadiusFraction => end_radius_fraction,
        :center => encode_unit_point(center)
      }
    }
  end
  @spec linear_gradient(list(gradient_stop), unit_point, unit_point) :: t()
  def linear_gradient(stops, start_point, end_point) do
    %__MODULE__{
      style: :linearGradient,
      props: %{
        :stops => encode_gradient_stops(stops),
        :startPoint => encode_unit_point(start_point),
        :endPoint => encode_unit_point(end_point),
      }
    }
  end
  @spec radial_gradient(list(gradient_stop), float, float, unit_point) :: t()
  def radial_gradient(stops, start_radius, end_radius, center) do
    %__MODULE__{
      style: :radialGradient,
      props: %{
        :stops => encode_gradient_stops(stops),
        :startRadius => start_radius,
        :endRadius => end_radius,
        :center => encode_unit_point(center),
      }
    }
  end

  def material(thickness), do: %__MODULE__{style: :material, props: %{ :thickness => thickness }}
  def ultra_thin, do: material(:ultraThin)
  def thin, do: material(:thin)
  def regular, do: material(:regular)
  def thick, do: material(:thick)
  def ultra_thick, do: material(:ultraThick)
  def bar, do: material(:bar)

  def foreground, do: %__MODULE__{style: :foreground, props: %{}}
  def background, do: %__MODULE__{style: :background, props: %{}}
  def selection, do: %__MODULE__{style: :selection, props: %{}}
  def separator, do: %__MODULE__{style: :separator, props: %{}}
  def tint, do: %__MODULE__{style: :tint, props: %{}}

  # Modifiers
  def opacity(root, opacity), do: %__MODULE__{style: :opacity, props: %{ :root => to_map(root), :opacity => opacity }}
  @spec blend_mode(atom | %{:props => any, :style => any, optional(any) => any}, any) :: any
  def blend_mode(root, blend_mode), do: %__MODULE__{style: :blendMode, props: %{ :root => to_map(root), :blendMode => blend_mode }}
  def shadow(root, style, radius, options \\ []) do
    color = Keyword.get(options, :color)
    %__MODULE__{
      style: :shadow,
      props: %{
        :root => to_map(root),
        :style => style,
        :color =>  (if color != nil, do: to_map(color), else: color),
        :radius => radius,
        :x => Keyword.get(options, :x),
        :y => Keyword.get(options, :y)
      }
    }
  end

  defimpl Phoenix.HTML.Safe do
    def to_iodata(data) do
      Map.new([{data.style, data.props}])
        |> Jason.encode!
        |> Phoenix.HTML.Safe.to_iodata
    end
  end
end
