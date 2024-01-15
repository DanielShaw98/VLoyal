import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="prompt"
export default class extends Controller {

  static targets = ["prompt", 'img', 'card'];

  connect() {
  }

  showPrompt(e) {
    e.preventDefault();
    let targetCard;
    this.cardTargets.forEach(card => {
      if (card.contains(e.target)) {
        targetCard = card;
      }
    });
    this.imgTarget.src = targetCard.dataset.src;
    this.promptTarget.classList.remove("d-none");
    setTimeout(() => {
      this.promptTarget.classList.add("show");
    }, 10);
  }

  hidePrompt(e) {
    e.preventDefault(e);
    this.promptTarget.classList.remove("show");
    setTimeout(() => {
      this.promptTarget.classList.add("d-none");
    }, 300);
  }
}
