---
title: "Learning Golang from Scratch: Real-World Projects"
description: "Apply your Go knowledge by building CLI tools and HTTP APIs."
pubDate: "Jul 21 2026"
heroImage: "../../assets/blog-placeholder-4.jpg"
tags: ["golang", "tutorial", "projects"]
---

Welcome to the final installment of our Golang series! We've covered the basics, idiomatic patterns, testing, and concurrency. Now it's time to build something real.

As discussed in _Building Microservices with Go_ and _Go Web Programming_, Go excels in two major domains: **Command Line Interfaces (CLI)** and **Networked Services (APIs/Microservices)**.

## Building a CLI Tool

Go creates statically linked, self-contained binaries that are perfect for CLI tools. You don't need to ask users to install a runtime (like Python or Node.js) to run your tool.

Let's build a simple CLI that reads a file and counts the words. While the standard library has the `flag` package, most modern Go developers use a community library called [Cobra](https://github.com/spf13/cobra) for complex CLIs (it powers Kubernetes `kubectl` and the GitHub CLI).

For our simple example, we'll stick to the standard library's `flag` package:

```go
package main

import (
    "flag"
    "fmt"
    "os"
    "strings"
)

func main() {
    // Define a string flag
    filePath := flag.String("file", "", "Path to the file to read")
    flag.Parse()

    if *filePath == "" {
        fmt.Println("Please provide a file path using the -file flag.")
        os.Exit(1)
    }

    // Read the file
    data, err := os.ReadFile(*filePath)
    if err != nil {
        fmt.Printf("Error reading file: %v\n", err)
        os.Exit(1)
    }

    // Count words
    content := string(data)
    words := strings.Fields(content)

    fmt.Printf("The file contains %d words.\n", len(words))
}
```

To run it:

```bash
go run main.go -file ./mytext.txt
```

To compile it into an executable that you can share:

```bash
go build -o wordcounter main.go
./wordcounter -file ./mytext.txt
```

## Building an HTTP API

Go's `net/http` package is incredibly robust. Unlike other languages where you immediately reach for a framework (like Express, Django, or Spring), in Go, it is common to build production-grade APIs using just the standard library.

Let's build a simple JSON API.

```go
package main

import (
    "encoding/json"
    "fmt"
    "log"
    "net/http"
)

// Define a struct for our response payload
// The backticks define JSON struct tags to format the keys
type Message struct {
    Text   string `json:"text"`
    Status int    `json:"status"`
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
    // Only allow GET requests
    if r.Method != http.MethodGet {
        http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
        return
    }

    msg := Message{
        Text:   "Hello from Go!",
        Status: 200,
    }

    // Set content type
    w.Header().Set("Content-Type", "application/json")

    // Encode the struct to JSON and write it to the response
    json.NewEncoder(w).Encode(msg)
}

func main() {
    // Register the route
    http.HandleFunc("/api/hello", helloHandler)

    port := ":8080"
    fmt.Printf("Server starting on port %s...\n", port)

    // Start the server
    if err := http.ListenAndServe(port, nil); err != nil {
        log.Fatal(err)
    }
}
```

If you run this code (`go run main.go`), you will have a highly concurrent web server running on port 8080. Every incoming request is automatically handled in its own goroutine!

## Where to go from here?

You now have the foundational knowledge to build real systems in Go. Your next steps should include:

1. **Database Integration:** Learn how to use the `database/sql` package along with drivers like `pq` (for PostgreSQL).
2. **Frameworks:** Explore lightweight routing libraries like `chi` or `gorilla/mux`. If you prefer full frameworks, look into `Gin` or `Echo`.
3. **gRPC & Protobuf:** Go is the premier language for building gRPC microservices. Look into the book _gRPC Microservices in Go_ for deep dives.

Happy coding, and enjoy the speed and simplicity of Go!
