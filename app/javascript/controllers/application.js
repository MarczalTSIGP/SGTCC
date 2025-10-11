import { Application } from "@hotwired/stimulus";

const application = Application.start();

// Configure Stimulus development experience
application.debug = false;
window.Stimulus   = application;

export { application };

document.addEventListener("turbo:load", () => {
  const tooltipTriggerList = [].slice.call(
    document.querySelectorAll("[data-bs-toggle=\"tooltip\"]")
  );
  tooltipTriggerList.forEach((tooltipTriggerEl) => {
    new bootstrap.Tooltip(tooltipTriggerEl, {
      delay: { show: 0, hide: 0 },
    });
  });
});
