import Elementary
import ElementaryHTMX
import ElementaryHTMXSSE
import ElementaryHTMXWS
import Fluent
import Vapor
import VaporElementary

struct TodoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("todos") { todos in
			todos.get(use: index)

            todos.post(use: create)

            todos.group(":id") { todo in
                todo.delete(use: delete)
            }
        }
    }

    @Sendable
    func index(req: Request) async throws -> HTMLResponse {
        let todos = try await todos(db: req.db)

        return HTMLResponse {
            MainLayout(title: "Todos") {
                TodosTableComponent(name: "todos", todos: todos)
                TodosFormComponent(name: "todos-form", target: "todos")

                button(.class("btn btn-primary"), .type(.button), .hx.get("/test/toast")) { "Toast" }
            }
        }
    }

    @Sendable
    func create(req: Request) async throws -> HTMLResponse {
        do {
            try TodoDTO.validate(content: req)
        }
        catch let error as ValidationsError {
            return HTMLResponse {
                TodosFormComponent(name: "todos-form", target: "todos", errors: ["title": error.description])
            }
        }

        let todo = try req.content.decode(TodoDTO.self).toModel()
        try await todo.save(on: req.db)

        let todos = try await todos(db: req.db)

        return HTMLResponse {
            // Return the empty form
            TodosFormComponent(name: "todos-form", target: "todos")

            // Also update the todos table
            TodosTableComponent(name: "todos", todos: todos, refresh: true) // TODO: Put component names inside variables
        }
    }

    @Sendable
    func delete(req: Request) async throws -> HTMLResponse {
        guard let uuid = hexToUUID(hex: req.parameters.get("id")!),
              let todo = try await Todo.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }

        try await todo.delete(on: req.db)

        return HTMLResponse {} // TODO: Return 204 No Content
    }

    // -------------------------------------

    @Sendable
    private func todos(db: any Database) async throws -> [TodoDTO] {
        try await Todo.query(on: db).all().map { $0.toDTO() }
    }

    private func hexToUUID(hex: String) -> UUID? {
        var uuid: String = hex.replacingOccurrences(of: "-", with: "")

        guard uuid.count == 32 else { return nil }

        uuid.insert("-", at: uuid.index(uuid.startIndex, offsetBy: 8))
        uuid.insert("-", at: uuid.index(uuid.startIndex, offsetBy: 12 + 1))
        uuid.insert("-", at: uuid.index(uuid.startIndex, offsetBy: 16 + 2))
        uuid.insert("-", at: uuid.index(uuid.startIndex, offsetBy: 20 + 3))

        return UUID(uuidString: uuid)
    }

}
