// Activate Bootstrap tooltips
const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
const tooltipList = [...tooltipTriggerList].map(element => new bootstrap.Tooltip(element))

// -----------------------------------------
// HTMX events

function runOnceAfterSettle(func) {
	// https://htmx.org/docs/#request-operations
	document.addEventListener("htmx:afterSettle", function handler(event) {
        func();
        document.removeEventListener("htmx:afterSwap", handler);
    });
}
