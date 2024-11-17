import Elementary

// https://www.srihash.org/

extension MainLayout: Sendable where Body: Sendable {}
struct MainLayout<Body: HTML>: HTMLDocument {
    var title: String
    @HTMLBuilder var pageContent: Body  // This var name can't be changed!

    var head: some HTML {
        meta(.charset(.utf8))
        meta(.name(.viewport), .content("width=device-width, initial-scale=1.0"))

        // ---------------------------------
        // CSS includes

        link(
            .rel(.stylesheet),
            .href("https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css"),
            .integrity("sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"),
            .crossorigin(.anonymous))
        link(.rel(.stylesheet), .href("/css/style.css"))

        // ---------------------------------
        // Style

        style {
"""
body {
    padding-top: 56px;
}
"""
        }
    }

    var body: some HTML {
        // ---------------------------------
        // Header

        header {
            NavMenu()
        }

        // ---------------------------------
        // Content

        main {
            div(.class("container mt-4")) {
                div(.class("content px-4 pb-4")) {
                    pageContent
                }
            }
        }

        // ---------------------------------
        // JS includes

        script(
            .src(
                "https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"),
            .integrity("sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"),
            .crossorigin(.anonymous)
        ) {}
        script(
            .src("https://cdnjs.cloudflare.com/ajax/libs/htmx/2.0.3/htmx.min.js"),
            .integrity("sha384-0895/pl2MU10Hqc6jd4RvrthNlDiE9U1tWmX7WRESftEDRosgxNsQG/Ze9YMRzHq"),
            .crossorigin(.anonymous)
        ) {}
        script(
            .src("https://cdn.jsdelivr.net/npm/htmx-ext-sse@2.2.2/sse.min.js"),
            .integrity("sha384-yhS+rWHB2hwrHEg86hWiQV7XL6u+PH9X+3BlmS2+CNBaGYU8Nd7RZ2rZ9DWXgTdr"),
            .crossorigin(.anonymous)
        ) {}
        script(
            .src("https://cdn.jsdelivr.net/npm/htmx-ext-ws@2.0.1/ws.min.js"),
            .integrity("sha384-yhWpPsq2os1hEnx1I8cH7Ius6rclwTm3G2fhXDLF6Pzv7UnSsXY7BAj4fB6PIgSz"),
            .crossorigin(.anonymous)
        ) {}
        script(.src("/js/site.js")) {}
    }

}
