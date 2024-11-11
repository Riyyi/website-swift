import Elementary
import Fluent
import Vapor
import VaporElementary

func routes(_ app: Application) throws {
    app.routes.caseInsensitive = true

    app.get { req async throws in

        let todo = Todo(title: "Test Todo")
        try await todo.save(on: req.db)

        return "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    app.get("test") { _ in
        HTMLResponse {
            MainLayout(title: "Test123") {
                IndexPage()
            }
        }
    }

    try app.register(collection: TodoController())
}

/*

Closure Expression Syntax
  https://docs.swift.org/swift-book/documentation/the-swift-programming-language/closures#Closure-Expression-Syntax

{ (<#parameters#>) -> <#return type#> in
    <#statements#>
}

*/
