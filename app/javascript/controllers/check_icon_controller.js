import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="check-icon"
export default class extends Controller {
  static targets = ["icon"];
  static values = {
    url: String
  }

  connect() {
  }

  check(e) {
    this.element.classList.add("checked");
    this.iconTarget.outerHTML = '<i class="fa-solid fa-circle-check"></i>';
    if (this.element.href != this.originalHref) {
      return false;
    } else {
      let csrfToken = document.querySelector('meta[name="csrf-token"]').content;
      fetch(this.urlValue, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "X-CSRF-Token": csrfToken
        },
        body: JSON.stringify({})
      })
        .then((response) => console.log(response));
      this.element.href = "#";
    }
  }
}
