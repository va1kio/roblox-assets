# Retry.lua

## About Retry

Retry is an utility for running scripts that requires network connections (such as, HTTPs, API, etc), when using Retry
Retry itself will attempt to try running the function which is wrapped in a pcall, and if it failed, it will keep retrying
until it has reached the RetryLimit (Default is 3)

To avoid issue like too much requests, Retry will wait for an interval per retry.

## So, why Retry

DataStoreService has a property called AutomaticRetry, which will automatically retry when failed. However,
DataStores do not respect this property  because automatic retry has been disabled due to technical reasons.
Therefore, you must implement systems for retrying operations yourself.

I've created this module for beginners, since they might not know about this, for developers, you can implement
a system for retrying operation, rather than using this one, but it's all up to you.

## Reference

```function Retry:Try(function Callback)```

// Start trying a function, and will retry if failed.
