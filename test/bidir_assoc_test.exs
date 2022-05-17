defmodule BidirAssocTest do
  use ExUnit.Case

  test ". . . build bidirectional associations..." do
    import BidirAssoc, only: [ref: 2, get_ref: 2]
    alias  BidirAssoc.A
    alias  BidirAssoc.B
    a0 = %A{}
    b0 = %B{}
    a =
      quote(do: ref(unquote(a0), unquote(b0)))
      |> Macro.expand_once(__ENV__)
    # But if `a = ref(a0, b0)`, it will cause compilation error like
    # ** (FunctionClauseError) no function clause matching in BidirAssoc.ref/2
    #     (bidir_assoc 0.1.0) expanding macro: BidirAssoc.ref/2
    assert a
    assert %B{} = a |> get_ref(:hello)
    assert %A{} = a |> get_ref(:hello) |> get_ref(:world)
  end


  test ". . . about value expansion..." do
    import BidirAssoc, only: [ref: 2, get_ref: 2]
    alias  BidirAssoc.A
    alias  BidirAssoc.B
    a0 = %A{value: :hello}
    b0 = %B{value: :world}
    a =
      quote(do: ref(unquote(a0), unquote(b0)))
      |> Macro.expand_once(__ENV__)
    assert a
    assert a.value === :hello
    assert a |> get_ref(:hello) |> Map.get(:value) === :world
  end

end
