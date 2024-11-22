window.web = {};

// -----------------------------------------

// Activate Bootstrap tooltips
web.tooltips = function() {
	const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
	const tooltipList = [...tooltipTriggerList].map(element => new bootstrap.Tooltip(element))
}

// -----------------------------------------
// HTMX events

web.afterLoad = function(func) {
	// https://htmx.org/docs/#request-operations
	document.addEventListener("htmx:afterSettle", function handler(event) {
        func();
        document.removeEventListener("htmx:afterSwap", handler);
    });
}
