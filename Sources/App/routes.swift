import Elementary
import Fluent
import Vapor
import VaporElementary

func routes(_ app: Application) throws {
    app.routes.caseInsensitive = true

    app.get { req async throws in
        HTMLResponse {
            MainLayout(title: "Homepage") {
                IndexPage()
            }
        }
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    app.get("toast", use: toast)

    try app.register(collection: TodoController())
    try app.register(collection: TestController())

    try app.group("api") { api in
        try api.register(collection: TodoAPIController())
    }
}

@Sendable
func toast(req: Request) throws -> HTMLResponse {
    let state = try getState(request: req)
    let toast = state.toast
    state.toast = ToastState() // Clear toast

    return HTMLResponse {
        ToastComponent(state: toast)
    }
}

/*

Closure Expression Syntax
  https://docs.swift.org/swift-book/documentation/the-swift-programming-language/closures#Closure-Expression-Syntax

{ (<#parameters#>) -> <#return type#> in
    <#statements#>
}

*/
