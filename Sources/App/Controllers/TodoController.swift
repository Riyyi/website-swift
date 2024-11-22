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

            todos.group("sort") { todo in
                todo.get(use: sort)
            }
        }
    }

    @Sendable
    func index(req: Request) async throws -> HTMLResponse {
        let state = try getState(request: req)
        state.todos.table.name = "todos"
        state.todos.table.sort["title"] = state.todos.table.sort["title"] ?? .ascending
        let todos = try await todos(db: req.db, title: state.todos.table.sort["title"]!)
        state.todos.table.todos = todos
        state.todos.table.refresh = false

        return HTMLResponse {
            MainLayout(title: "Todos") {
                TodosPage(table: state.todos.table)
            }
        }
    }

    @Sendable
    func create(req: Request) async throws -> HTMLResponse {
        do {
            try TodoDTO.validate(content: req)
        } catch let error as ValidationsError {
            return HTMLResponse {
                TodosFormComponent(
                    name: "todos-form", target: "todos", errors: ["title": error.description])
            }
        }

        let todo = try req.content.decode(TodoDTO.self).toModel()
        try await todo.save(on: req.db)

        let state = try getState(request: req)
        let todos = try await todos(db: req.db, title: state.todos.table.sort["title"] ?? .ascending)
        state.todos.table.todos = todos
        state.todos.table.refresh = true

        return HTMLResponse {
            // Return the empty form
            TodosFormComponent(name: "todos-form", target: "todos")

            // Also update the todos table
            TodosTableComponent(state: state.todos.table)  // TODO: Put component names inside variables
        }
    }

    @Sendable
    func delete(req: Request) async throws -> HTMLResponse {
        guard let uuid = hexToUUID(hex: req.parameters.get("id")!),
            let todo = try await Todo.find(uuid, on: req.db)
        else {
            throw Abort(.notFound)
        }

        try await todo.delete(on: req.db)

        return HTMLResponse {}  // TODO: Return 204 No Content
    }

    struct Sort: Content {
		let title: String
    }

    @Sendable
    func sort(req: Request) async throws -> HTMLResponse {
        let state = try getState(request: req)

        let sort = try req.query.decode(Sort.self)
        state.todos.table.sort["title"] = sort.title == "descending" ? .descending : .ascending

        let todos = try await todos(db: req.db, title: state.todos.table.sort["title"]!)
        state.todos.table.todos = todos
        state.todos.table.refresh = true

        return HTMLResponse {
            TodosTableComponent(state: state.todos.table)
        }
    }

    // -------------------------------------

    @Sendable
    private func todos(db: any Database, title: DatabaseQuery.Sort.Direction = .ascending) async throws -> [TodoDTO] {
        try await Todo.query(on: db).sort("title", title).all().map { $0.toDTO() }
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
