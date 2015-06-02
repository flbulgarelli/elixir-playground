EtsStore
========

This example is about a very simple ETS key/value store extension, the objective is to have a key/value database for process
and network support.

### First step

Create a small wrapper from ETS that will hold the values of the key/value store, and will only be used by one process

```elixir

    EtsStore.init
    EtsStore.insert(:one, 1)
    EtsStore.get(:one, 1) #{ok:, 1}
    EtsStore.update(:one, 2)
    EtsStore.get(:one) #{:ok, 2}
    EtsStore.delete(:one)
    EtsStore.get(:one) #{:error, :not_found}

```


## Things to add

* Make this store compatible with multiple process, make them concurrent.
* level synchronized writes (inserts, read/modify/write updates, deletes)
* callbacks
