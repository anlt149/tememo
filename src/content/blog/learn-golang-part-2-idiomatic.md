---
title: "Learning Golang from Scratch: Idiomatic Go & Testing"
description: "Learn how to write clean, idiomatic Go code, handle errors properly, and test your applications."
pubDate: "Jul 19 2026"
heroImage: "../../assets/blog-placeholder-2.jpg"
tags: ["golang", "tutorial", "testing"]
---

Welcome to Part 2 of our Golang series! In Part 1, we covered the basic syntax and structures of Go. Now, we'll dive into what makes Go truly special: its philosophy, error handling, interfaces, and built-in testing framework.

To write code that Go veterans respect, you must write **idiomatic Go**. As Jon Bodner details in _Learning Go_, writing idiomatic Go means embracing the language's design rather than fighting it or trying to write Java or Python in Go.

## Error Handling: Values, Not Exceptions

One of the biggest shocks for newcomers to Go is the lack of `try/catch` exceptions. Instead, Go treats errors as standard return values. This makes error handling explicit and encourages developers to think about failure states continuously.

```go
package main

import (
    "errors"
    "fmt"
)

func DoSomethingRisky(input int) (string, error) {
    if input < 0 {
        return "", errors.New("input cannot be negative")
    }
    return "Success!", nil
}

func main() {
    result, err := DoSomethingRisky(-1)
    if err != nil {
        fmt.Println("Error occurred:", err)
        return
    }
    fmt.Println(result)
}
```

This pattern—checking `if err != nil`—is ubiquitous in Go. Embrace it!

## Interfaces: Implicit and Powerful

In many languages, a class must explicitly declare that it implements an interface (e.g., `class Dog implements Animal`). Go does things differently: **interfaces are satisfied implicitly**. If a type has the methods described by an interface, it automatically implements that interface.

This allows for incredibly decoupled and flexible system designs.

```go
package main

import "fmt"

// Define the interface
type Speaker interface {
    Speak() string
}

// Define a type
type Dog struct {
    Name string
}

// Dog implicitly implements Speaker
func (d Dog) Speak() string {
    return "Woof!"
}

// Define another type
type Cat struct {
    Name string
}

// Cat implicitly implements Speaker
func (c Cat) Speak() string {
    return "Meow!"
}

func MakeSound(s Speaker) {
    fmt.Println(s.Speak())
}

func main() {
    dog := Dog{Name: "Buddy"}
    cat := Cat{Name: "Whiskers"}

    MakeSound(dog) // Output: Woof!
    MakeSound(cat) // Output: Meow!
}
```

## Testing in Go

Go includes a powerful testing framework right in the standard library via the `testing` package and the `go test` command. You don't need third-party libraries like Jest or JUnit to get started.

Test files in Go live alongside the code they test and end with `_test.go`.

### Example Test

If you have a file `math.go`:

```go
package mathutils

func Add(a, b int) int {
    return a + b
}
```

You would create a file `math_test.go` in the same directory:

```go
package mathutils

import "testing"

func TestAdd(t *testing.T) {
    result := Add(2, 3)
    expected := 5

    if result != expected {
        t.Errorf("Add(2, 3) returned %d; expected %d", result, expected)
    }
}
```

Run tests from your terminal with:

```bash
go test -v ./...
```

The `-v` flag gives verbose output, and `./...` tells Go to test all packages in the current directory and its subdirectories.

### Table-Driven Tests

A common pattern in Go is "table-driven tests," where you iterate over a slice of structs containing inputs and expected outputs:

```go
func TestAddTable(t *testing.T) {
    tests := []struct {
        name     string
        a, b     int
        expected int
    }{
        {"positive numbers", 2, 3, 5},
        {"negative numbers", -1, -2, -3},
        {"mixed numbers", -1, 5, 4},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := Add(tt.a, tt.b)
            if result != tt.expected {
                t.Errorf("got %d, want %d", result, tt.expected)
            }
        })
    }
}
```

Writing idiomatic code and comprehensive tests will make your Go applications robust and maintainable. In Part 3, we will tackle Go's most famous feature: **Concurrency**!
