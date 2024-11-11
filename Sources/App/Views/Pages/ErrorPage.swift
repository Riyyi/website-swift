import Elementary

struct ErrorPage: HTML {
    var status: String
    var reason: String

    // -------------------------------------

    var content: some HTML {
        div {
            p { "Error "; strong { status }; "." }
            p { reason }
        }
    }
}
