import Fluent
import Vapor

struct TodoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("todos")

        todos.get(use: index)
        todos.post(use: create)
        todos.group(":id") { todo in
            todo.get(use: show)
            todo.put(use: update)
            todo.delete(use: delete)
        }
        // todos.delete(":todoID", use: delete)
    }

    @Sendable
    func index(req: Request) async throws -> [TodoDTO] {
        try await Todo.query(on: req.db).all().map { $0.toDTO() }
    }

    @Sendable
    func show(req: Request) async throws -> TodoDTO {
        guard let uuid = hexToUUID(hex: req.parameters.get("id")!),
              let todo = try await Todo.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }

        return todo.toDTO()
    }

    @Sendable
    func create(req: Request) async throws -> TodoDTO {
        let todo = try req.content.decode(TodoDTO.self).toModel()

        try await todo.save(on: req.db)

        return todo.toDTO()
    }

    @Sendable
    func update(req: Request) async throws -> TodoDTO {
        guard let uuid = hexToUUID(hex: req.parameters.get("id")!),
              let todo = try await Todo.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }

        let updatedTodo = try req.content.decode(Todo.self)
        todo.title = updatedTodo.title
        try await todo.save(on: req.db)

        return todo.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let uuid = hexToUUID(hex: req.parameters.get("id")!),
              let todo = try await Todo.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }

        try await todo.delete(on: req.db)

        return .noContent
    }

    // -------------------------------------

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
