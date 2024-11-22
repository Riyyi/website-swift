import Elementary
import ElementaryHTMX
import Fluent

struct TodosTableComponent: HTML {

    var name: String
    var todos: [TodoDTO]
    var refresh: Bool = false

    // -------------------------------------

    var content: some HTML {
        div(.id("cdiv_" + name), refresh ? .hx.swapOOB(.outerHTML) : .empty()) {
            table(.class("table")) {
                thead {
                    tr {
                        th { "#" }
                        th { "ID" }
                        th {
                            "Title "
                            i(.class("bi bi-arrow-down-circle")) {}
                        }
                        th { "Modifier" }
                    }
                }
                tbody(
                    .hx.confirm("Are you sure?"), .hx.target("closest tr"),
                    .hx.swap(.outerHTML, "swap:0.5s")
                ) {
                    for (index, todo) in todos.enumerated() {
                        tr {
                            td { "\(index)" }
                            td { todo.id?.uuidString ?? "" }
                            td { todo.title ?? "" }
                            td {
                                if let id = todo.id {
                                    i(
                                        .class("bi bi-trash3 text-danger"),
                                        .data("bs-toggle", value: "tooltip"),
                                        .data("bs-title", value: "Delete"),
                                        .hx.delete("/\(name)/\(id.uuidString)")
                                    ) {}
                                }
                            }
                        }
                    }
                }
            }

            ScriptAfterLoad(initial: !refresh) { "web.tooltips();" };
        }
    }

}
