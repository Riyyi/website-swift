import Elementary
import ElementaryHTMX
import Fluent

struct TodosTableComponent: HTML {

    var state: TodosTableState = TodosTableState()

    // -------------------------------------

    var content: some HTML {
        div(.id("cdiv_" + state.name), state.refresh ? .hx.swapOOB(.outerHTML) : .empty()) {
            table(.class("table")) {
                thead {
                    tr {
                        th { "#" }
                        th { "ID" }
                        th {
                            let order = state.sort["title"]?.description ?? "ascending"
                            span(.style("cursor: pointer;"),
                                 .hx.get("/\(state.name)/sort?title=\(order == "descending" ? "ascending" : "descending")"),
                                 .hx.target("closest div")) {
                                "Title "
                                i(.class("bi bi-arrow-\(order == "descending" ? "down" : "up")-circle")) {}
                            }
                        }
                        th { "Modifier" }
                    }
                }
                tbody(
                    .hx.confirm("Are you sure?"), .hx.target("closest tr"),
                    .hx.swap(.outerHTML, "swap:0.5s")
                ) {
                    for (index, todo) in state.todos.enumerated() {
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
                                        .hx.delete("/\(state.name)/\(id.uuidString)")
                                    ) {}
                                }
                            }
                        }
                    }
                }
            }

            ScriptAfterLoad(initial: !state.refresh) { "web.tooltips();" };
        }
    }

}

struct Modal: HTML {
    var content: some HTML {
        div(.class("modal fade"), .id("alertModal"), .tabindex(-1)) {
            div(.class("modal-dialog modal-dialog-centered")) {
                div(.class("modal-content")) {
                    div(.class("modal-header border-bottom-0")) {
                        button(
                            .class("btn-close"), .type(.button), .data("bs-dismiss", value: "modal")
                        ) {}
                    }
                    div(.class("modal-body")) {
                        div(.class("alert alert-danger")) {
                            "Toby123"
                        }
                    }
                }
            }
        }
        button(
            .class("btn btn-primary"), .type(.button), .data("bs-toggle", value: "modal"),
            .data("bs-target", value: "#alertModal")
        ) { "Show" }

    }
}
