# BidirAssoc
. . . Technique for bidirectional associations.

## Bidirectional construction

Say each of two objects links to the other one, you may want to have code as
the following,

```elixir
a0 = %A{hello: b0}
b0 = %B{world: a0}
```

You found that it does not work. Do not be frustrated. Do not give up using
functional programming.

And this project tends to give a better approach on functional programming.

Say those elements exist, including macro `ref/2` for object-reference
definition, function `get_ref/2` for object-reference retrieval, and both
object modules `BidirAssoc.A` and `BidirAssoc.B`.

```elixir
import BidirAssoc, only: [ref: 2, get_ref: 2]
alias  BidirAssoc.A
alias  BidirAssoc.B
```

First you have to construct basic sturcts, then combine them into a magic
binary construction.

```elixir
a0 = %A{value: :hello}
b0 = %B{value: :world}
a =
  quote(do: ref(unquote(a0), unquote(b0)))
  |> Macro.expand_once(__ENV__)
```

And it seems like that.

```elixir
%BidirAssoc.A{
  hello: {:ref, [],
   [
     %BidirAssoc.B{value: nil, world: nil},
     %BidirAssoc.A{hello: nil, value: nil}
   ]},
  value: :hello 
}
```

And you may want to start from `a`, the structure `%BidirAssoc.A{}`, and go
down to `a.hello` that's a structure `%BidirAssoc.B{}`, and `a.hello.world`,
`%BidirAssoc.A{}`, and `a.hello.world.hello`, `%BidirAssoc.B{}`, and so on.

```elixir
a                               # This is a `%BidirAssoc.A{}`.

a |> BidirAssoc.get_ref(:hello) # This is a `%BidirAssoc.B{}`.

a
|> BidirAssoc.get_ref(:hello)
|> BidirAssoc.get_ref(:world)   # This is a `%BidirAssoc.A{}`.

a
|> BidirAssoc.get_ref(:hello)
|> BidirAssoc.get_ref(:world)
|> BidirAssoc.get_ref(:hello)   # This is a `%BidirAssoc.B{}`.
```
