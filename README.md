<!--
SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.

SPDX-License-Identifier: Apache-2.0
-->

![Last commit build](https://github.com/emartech/mimic/actions/workflows/on_commit.yml/badge.svg)

<img src="assets/mimic.png" alt="Mimic" width="100" height="100">

## What is mimic?

`Mimic` is a testing framework designed specifically for the `Swift` programming language. It offers two key features that simplify the testing process. 
- Firstly, it provides a convenient way to create fake objects, which can be used similarly as a mock object.
- Secondly, it could generate instances for codable classes.

Since `Swift's` reflection is limited and rather we call it to introspection, creating runtime mocking frameworks are hardly possible. Most of the solutions are working with build time mock generations where creating mocks are marked with protocols or comments. This solution was created because we felt these solutions a bit unconvinient or not clean enough from a software development point of view.
Of course perfect solution doesn't exist, and this is also just a [leaky abstraction ](https://www.joelonsoftware.com/2002/11/11/the-law-of-leaky-abstractions/), the trade of here is that we have to create fake classes manually but this package helps us to make this painful method as convinient as possible. Moreover to be able to replace the behaviour of a class it forces the developer to organize the code in a clean way.

## Faking

By using fake objects, you can simulate various scenarios and ensure that your code behaves as expected in different situations by isolating the behaviors of specific components during testing. `Mimic` provides a simple and intuitive API that allows you to specify the expected behavior and responses of the fake object. This way, you can precisely control the interactions between your tests and the fake object, making testing more reliable and reproducible.

### Creating fake objects

Lets say we have a protocol which defines a function.

```swift
protocol SomeProtocol {
    
    func someFunction(with parameter: String) -> Int
    
}
```

And we have a class which conforms to this protocol and adds some implementation for that.

```swift
class SomeClass: SomeProtocol {
    
    func someFunction(with parameter: String) -> Int {
        return 42
    }
    
}
```

So now comes the tricky part, to create a fake object that could be used from tests for `SomeClass` class, we should do this:

```swift
final class FakeSomeClass: SomeProtocol, Mimic {
    
    let fnSomeFunction = Fn<Int>()
    
    func someFunction(with parameter: String) -> Int {
        return try! fnSomeFunction.invoke(params: parameter)
    }
    
}
```
#### Key steps: 
- add `Mimic` protocol to the fake class
- create a `Fn` instance where the generic type is the result type of the function that behaviour we want to replace
- add the fn instance to the function and invoke, pass the parameters and return with it

That's it. So as it is visible from the example above, it needs some code typing, but not so terrible, no need to add internal logic, or enything else, just a pure declaration, and teachings and verifications will work.

### Using fake objects
  
#### Checking properties

If we have a fake class that has properties, we can easily check their values by creating an expected dictionary where the key is the name of the property and the values are what we expecting, than make Props object from both and check their equality.

```swift
    let expected = [
        "boolValue": true,
        "wholeValue": 42,
        "floatingValue": 3.1415926535897,
        "stringValue": "Oh, yeah. Oooh, ahhh, that's how it always starts. Then later there's running and um, screaming.",
        "array": [true, false, true],
        "dict": ["key": "value"],
        "optionalNil": nil
    ].toProps()
    
    let result = testStruct.props()
    
    XCTAssertEqual(result, expected)
```

### `when` used for teaching / stubbing

#### `replaceFunction`
Sometimes we need more control on the function.
```swift
    let expected = 496
    
    var parameter: String!
    var times = 0

    fakeSomeClass.when(\.fnSomeFunction).replaceFunction { invocationCount, params in
        times = invocationCount
        parameter = params[0]
        return expected
    }
    
    let result = testStruct.someFunction(with: "parameterValue")
    
    XCTAssertEqual(result, expected)
    XCTAssertEqual(parameter, "parameterValue")
    XCTAssertEqual(times, 1)
```
#### Key steps: 
- with calling `when` function on the faked class and passing the `Fn` functions `keyPath` we can use the `replaceFunction`
- setting the explicit type for a parameter before getting it with index from `params` is mandatory
- `invocationCount` can be used to check how many times were the function called

#### `thenReturn`
Sometimes we just want to stub it and return with a simple value.
```swift
    let expected = 496

    fakeSomeClass.when(\.fnSomeFunction).thenReturn(expected)
    
    let result = testStruct.someFunction(with: "parameterValue")
    
    XCTAssertEqual(result, expected)
```
#### Key steps: 
- with calling `when` function on the faked class and passing the `Fn` functions `keyPath` we can use the `thenReturn`
- as a parameter of `thenReturn` function we can pass the return value

#### `thenReturns`
Sometimes we just want to stub it and return with a simple value.
```swift
    let expected1 = 6
    let expected2 = 28
    let expected3 = 496
    let expected5 = 8128

    fakeSomeClass.when(\.fnSomeFunction).thenReturns(expected1, expected2 , expected3, nil, expected4)
    
    let result1 = testStruct.someFunction(with: "parameterValue")
    let result2 = testStruct.someFunction(with: "parameterValue")
    let result3 = testStruct.someFunction(with: "parameterValue")
    let result4 = testStruct.someFunction(with: "parameterValue")
    let result5 = testStruct.someFunction(with: "parameterValue")
    
    XCTAssertEqual(result1, expected1)
    XCTAssertEqual(result2, expected2)
    XCTAssertEqual(result3, expected3)
    XCTAssertNil(result4)
    XCTAssertEqual(result5, expected5)
```
#### Key steps: 
- with calling `when` function on the faked class and passing the `Fn` functions `keyPath` we can use the `thenReturns`
- as a parameter of `thenReturns` function we can pass the return values
- if we call the function more times then return values, a `MimicError.missingResult` error will be thrown

#### `matchers`
Just like in mocking frameworks, `mimic` has matchers as well, it could be use for teaching and verification.
- `Arg.any` it could be anything without restrictions.
- `Arg.eq(<value>)` it is an equality mathcer where the `<value>` means the expected value.
- `Arg.nil` it expects that the value will be `nil`.
- `Arg.notNil` it expects that the valu won't be `nil`.
- `Arg.invokeClosure(<closure>)` the given `closure` will be called when the function invocation happens.

```swift
    let expectedArgument = "testExpectedArgument"

    fakeSomeClass.when(\.fnSomeFunction).calledWith(Arg.eq(expectedArgument)).thenReturn(42)
    
    let result = testStruct.someFunction(with: expectedArgument)
    
    XCTAssertEqual(result, 42)
```
#### Key steps: 
- matchers can be used with `calledWith` method after `when` and `verify` as well
- after `calledWith` other functions could be called, like `thenReturn`
- in the example above, the `thenReturn` will be used only if the arguments passed to the funtion fits with the matchers

#### `thenThrow`
It is just simply throw the given Error when the function being called.
```swift
    fakeSomeClass.when(\.fnSomeFunction).thenThrow(error: TestError.magicWord)
    
    let result = testStruct.someFunction(with: "value")
```

### `verify` used for verification after the function usage

#### `onThread(<Thread>)` 
This could be used to check on which thread the function was called.
```swift
    try fakeSomeClass.verify(\.fnSomeFunction).on(thread: Thread.current)
```
#### `times(<times value>)` 
This could be used to check how many times the function was called.
```swift
    try fakeSomeClass.verify(\.fnSomeFunction).times(times: .atLeast(2))
```
Possible values:
-  `.zero` it means the function should not be called
- `.atLeast(<Int value>)` it means the function should be called `<Int value>` or more times
- `.atMax(<Int value>)` it means the function should be called maximum `<Int value>` times
- `.eq(<Int value>)` it means the function should be called exactly `<Int value>` times

## Instance Generation for Codable Data Classes

When working with data classes, it's often necessary to create instances of them for testing purposes. Mimic simplifies this process by automatically generating instances with random values. This feature becomes especially handy when dealing with complex data models or when you need to generate a large number of instances for testing different scenarios. With this feature you can save time and effort that you could spend instead for the actual testing.

### `@Generate`
To use this feature you just simply add `@Generate` attribute before your variable.
```swift
    @Generate
    var someStruct: SomeStruct
```
That's it, after this code you could simply use the someStruct variable.

Limitations:
- the class itself should be implement the `Decodable` protocol
- if the class contains enums or other complex properties, those have to implement the `Codable` protocol and an instance should be passed, to the `Generate` attribute.
```swift
    @Generate(SomeEnum.case1(42))
    var someStruct: SomeStruct
```

# The cause
This team is the maker of the [EmarsysSDK's](https://github.com/emartech/ios-emarsys-sdk) when we started to develop the swift based version of it, we shortly arrived that point when we needed a proper mocking solution. We tried out few, but non of them was fit perfectly to our needs mainly because of those points what are highlighted above. This package and it's features are actively used in our SDK. Our team strongly beliefs that the good things, findings, solutions, knowledge should be shared that's why we made this repo publicly available to anyone. 
We hope you will consider it useful and will help your work.

## No promises

> `Disclaimer`
>
> As we mentioned before, at first place this package was created for internal use only. The main goal was to cover all of our use cases and fulfill our requirements what doesn't mean that this is good for everyone. If you find lack of features or issues we do not say that those will be implemented or solved in the near future since this product is not actively developed. We do our best, but no promises.

## Logo

The logo was created by [Bing Image Creator](https://www.bing.com/create)
