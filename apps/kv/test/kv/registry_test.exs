defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  @ip {10,0,0,111}

  setup context do
    {:ok, registry} = KV.Registry.start_link(context.test)
    {:ok, registry: registry}
  end

  test "spawns buckets", %{registry: registry} do
    assert KV.Registry.lookup(registry, @ip) == :error

    KV.Registry.create(registry, @ip)
    assert {:ok, bucket} = KV.Registry.lookup(registry, @ip)

    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1
  end

  test "removes buckets on exit", %{registry: registry} do
    KV.Registry.create(registry, @ip)
    {:ok, bucket} = KV.Registry.lookup(registry, @ip)
    Agent.stop(bucket)
    assert KV.Registry.lookup(registry, @ip) == :error
  end

  test "removes bucket on crash", %{registry: registry} do
    KV.Registry.create(registry, @ip)
    {:ok, bucket} = KV.Registry.lookup(registry, @ip)

    # Stop the bucket with non-normal reason
    Process.exit(bucket, :shutdown)

    # Wait until the bucket is dead
    ref = Process.monitor(bucket)
    assert_receive {:DOWN, ^ref, _, _, _}

    assert KV.Registry.lookup(registry, @ip) == :error
  end
end
