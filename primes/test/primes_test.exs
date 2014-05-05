import Prime

ExUnit.start

defmodule PrimeTest do
  use ExUnit.Case
  test "0 is prime" do
    assert prime? 0
  end

  test "2 is prime" do
    assert prime? 2
  end

  test "13 is prime" do
    assert prime? 13
  end

  test "100 is not prime" do
    refute prime? 100
  end

  test "generates primes" do
    primes_up_to(15, self())
    assert_receive {:prime_found, 0}
    assert_receive {:prime_found, 1}
    assert_receive {:prime_found, 2}
    assert_receive {:prime_found, 3}
    assert_receive {:prime_found, 5}
    assert_receive {:prime_found, 7}
    assert_receive {:prime_found, 13}

    refute_receive {:prime_found, 4}
    refute_receive {:prime_found, 6}
    refute_receive {:prime_found, 17}
  end
end
