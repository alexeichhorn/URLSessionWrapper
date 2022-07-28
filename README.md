# URLSessionWrapper

Can be used in different packets to allow packet user to customize URL session handling. Especially useful in Linux.

Create wrapper like this:
```swift
URLSessionWrapper { request in
    let response = try await handle(request)
    return response
}
```
