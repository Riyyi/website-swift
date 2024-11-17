import Elementary
import ElementaryHTMX

// -----------------------------------------
// Elementary

public extension HTMLAttribute {
    static func empty() -> HTMLAttribute {
        return HTMLAttribute(name: "", value: "")
    }
}

// -----------------------------------------
// ElementaryHTMX

public extension HTMLAttribute.hx {
    static func swap(_ value: HTMLAttributeValue.HTMX.ModifiedSwapTarget, _ spec: String? = nil) -> HTMLAttribute {
        if let spec {
            .init(name: "hx-swap", value: "\(value.rawValue) \(spec)")
        } else {
            .init(name: "hx-swap", value: value.rawValue)
        }
    }
}
