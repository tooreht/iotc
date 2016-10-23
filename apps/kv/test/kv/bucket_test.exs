defmodule KV.BucketTest do
  use ExUnit.Case, async: true

  @token 782347823487

  setup do
    {:ok, bucket} = KV.Bucket.start_link
    {:ok, bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    # `bucket` is now the bucket from the setup block
    assert KV.Bucket.get(bucket, "token") == nil

    KV.Bucket.put(bucket, "token", @token)
    assert KV.Bucket.get(bucket, "token") == @token

    assert KV.Bucket.delete(bucket, "token") == @token
    assert KV.Bucket.get(bucket, "token") == nil
  end
end
