# Btree

## Definition

A binary tree is a tree data structure in which each node has at most two children, which are referred to as the left child and the right child.
A recursive definition using just set theory notions is that a (non-empty) binary tree is a triple (L, S, R), where L and R are binary trees or the empty set and S is a singleton set.

This example shows how we can populate a transverse a binary tree in different times, through elixir processes.
Below is a quick example

```elixir
tree = spawn_link fn -> empty end

send tree, {:insert, 3, self}
send tree, {:insert, 4, self}
send tree, {:traverse, self}

```

This implementation allows also to have an empty tree.

```elixir
tree = spawn_link fn -> empty end
```

## What's mising

* Add balancing to this example