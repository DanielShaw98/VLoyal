import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="wallet"
export default class extends Controller {
  static targets = ['card'];
  connect() {
    this.state = 'wallet';
  };

  flipCard(e) {
    if (e.currentTarget.classList.contains("focus") || e.currentTarget.classList.contains("flipped")) {
      e.currentTarget.classList.remove("flipped");
      e.currentTarget.classList.remove("focus");
    } else {
      e.currentTarget.classList.add("focus");
      e.currentTarget.classList.add("flipped");
    };
    this.cardTargets.forEach((card) => {
      if (card != e.currentTarget) {
        card.classList.remove('flipped');
        card.classList.remove('focus');
      };
    });
  };

  reset(e) {
    let target = e.target;
    while (target != this.element) {
      target = target.parentElement;
      if (this.cardTargets.indexOf(target) != -1 ) {
        return false;
      };
    };
    this.cardTargets.forEach((card) => {
      card.classList.remove('flipped');
      card.classList.remove('focus');
    });
  };
};
