defmodule BidirAssoc do
  @moduledoc """
  Technique for bidirectional associations.
  """

  defmodule A do
    use TypedStruct
    typedstruct do
      field :hello, BidirAssoc.B.t
      field :value, :atom
    end
  end

  defmodule B do
    use TypedStruct
    typedstruct do
      field :world, BidirAssoc.A.t
      field :value, :atom
    end
  end


  defmacro ref(%BidirAssoc.A{} = a, %BidirAssoc.B{} = b) do
    quote do
      unquote(%BidirAssoc.A{a | hello: quote(do: ref(unquote(b), unquote(a)))})
    end
  end

  defmacro ref(%BidirAssoc.B{} = b, %BidirAssoc.A{} = a) do
    quote do
      unquote(%BidirAssoc.B{b | world: quote(do: ref(unquote(a), unquote(b)))})
    end
  end

  def get_ref(obj, field) do
    value = Map.get(obj, field)
    {:ref, _, _} = value
    value |> Macro.expand_once(__ENV__)
  end

end
