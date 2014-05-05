defmodule Prime do
  def primes_up_to(max, who) do
    spawn_link fn ->
      Enum.each 0..max, fn n ->
        spawn_link fn -> test_prime(n, who) end
      end
    end
  end
  
  defp test_prime(n, who) do
    if prime? n do
      send who, {:prime_found, n}
    end
  end

  def prime?(n) do
    (n  >= 0 and n <= 3) or not Enum.any? 2..div(n, 2), &(rem(n, &1) == 0)
  end
end 
