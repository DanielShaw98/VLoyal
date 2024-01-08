import { Controller } from "@hotwired/stimulus";
import { BrowserQRCodeReader } from '@zxing/library';

// Connects to data-controller="basic-qr-code-reader"
export default class extends Controller {
  static targets = ["resultContainer", "alert", "card", "stamp"];
  static values = {
    user: Number
  };

  connect() {
    this.locked = true;
    this.codeReader = new BrowserQRCodeReader();
    this.#refreshScanner();
  };

  #refreshScanner() {
    this.codeReader
    .decodeFromInputVideoDevice(undefined, 'video')
    .then(result => this.#processResult(result));
  };

  #processResult(result) {
    // process the result
    // Prepare a post request so it can be sent to the Rails controller
    // Create a new FormData object
    let formData = new FormData();

    // // Prepare the data params
    // Add the params to the FormData object, making sure to convert it to JSON
    formData.append("user_id", this.userValue);

    // Send the QR code data as JSON to the qr_codes#create action using fetch
    fetch(result.text, {
      method: 'PATCH',
      'content-type': 'application/json',
      body: formData
    })
    .then(response => response.json()).then( data => {
        this.resultContainerTarget.classList.remove('d-none');
        this.alertTarget.innerHTML = data.alert;
        this.cardTarget.outerHTML = data.card;
        setTimeout(() => {
          this.resultContainerTarget.classList.add('show');
        }, 10);
        setTimeout(() => {
          this.cardTarget.classList.add('flipped');
          setTimeout(() => {
            const stampTarget = document.querySelector('.stamp:not(.stamped)');
            stampTarget.style.animationPlayState = 'running';
            setTimeout(() => {
              stampTarget.classList.add('stamped');
              // check if it is last stamp
              let stampArray = Array.from(this.stampTargets).map(stamp => stamp.classList.toString());
              if (stampArray[stampArray.length - 1].includes("stamped")) {
                this.#rewardAnimation();
              };
              this.locked = false;
            }, 300);
          }, 850);
        }, 800);
    })
    .catch(error => {
        console.error('Error:', error);
    });
  };

  #rewardAnimation() {
    this.stampTargets.forEach((stamp, index) => {
      setTimeout(() => {
        stamp.classList.add('reward');
      }, index * 200);
    });
  };

    collapse() {
    if (!this.locked) {
      this.cardTarget.classList.remove('flipped');
      setTimeout(() => {
        this.resultContainerTarget.classList.remove('show');
        setTimeout(() => {
          this.resultContainerTarget.classList.add('d-none');
          this.locked = true;
          this.#refreshScanner();
        }, 300);
      }, 500);
    };
  };
};
