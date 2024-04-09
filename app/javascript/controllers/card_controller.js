import { Controller } from "@hotwired/stimulus";
import { getPayjpInstance } from "../initialize-payjp.js";

export default class extends Controller {
  static targets = ["form", "number", "expiry", "cvc", "error", "token"];

  connect() {
    console.log("Controller connected");
    if (!this.hasInitialized) {
      this.initializePayjp();
      this.initializeElements();
      this.hasInitialized = true;
    }
    this.formTarget.addEventListener("turbo:before-fetch-request", this.handleTurboBeforeFetchRequest.bind(this));
  }

  initializePayjp() {
    this.payjp = getPayjpInstance();
    this.elements = this.payjp.elements();
  }

  initializeElements() {
    var elementStyle = {
      base: {
        fontFamily: "'Noto Sans Japanese', sans-serif",
        fontSize: "18px",
        "::placeholder": {
          color: "rgba(0, 0, 0, 0.54)",
        },
        caretColor: "#198FCC",
        lineHeight: "36px",
      },
      invalid: {
        color: "rgba(0, 0, 0, 0.87)",
      },
    };

    if (!this.numberElement) {
      const numberElement = this.elements.create("cardNumber", {
        style: elementStyle,
        placeholder: "4242 4242 4242 4242",
      });
      numberElement.mount(`#${this.numberTarget.id}`);
      this.numberElement = numberElement; // Store the element for later use
    }

    if (!this.expiryElement) {
      const expiryElement = this.elements.create("cardExpiry", {
        style: elementStyle,
      });
      expiryElement.mount(`#${this.expiryTarget.id}`);
      this.expiryElement = expiryElement; // Store the element for later use
    }

    if (!this.cvcElement) {
      const cvcElement = this.elements.create("cardCvc", {
        style: elementStyle,
      });
      cvcElement.mount(`#${this.cvcTarget.id}`);
      this.cvcElement = cvcElement; // Store the element for later use
    }
  }

  handleTurboBeforeFetchRequest(event) {
    if (event.target === this.formTarget && !this.isSubmitting) {
      console.log("Preparing form for submission");
      event.preventDefault();

      this.isSubmitting = true;
      this.createToken();
    }
  }

  createToken() {
    this.payjp.createToken(this.numberElement).then((response) => {
      if (response.error) {
        console.error("Error creating token:", response.error);
        this.showError(response.error.message);
      } else {
        this.addTokenToForm(response.id);
        this.formTarget.requestSubmit();
      }
      this.isSubmitting = false;
    });
  }

  addTokenToForm(token) {
    let tokenInput = this.formTarget.querySelector('input[name="token"]');
    if (!tokenInput) {
      tokenInput = document.createElement("input");
      tokenInput.setAttribute("type", "hidden");
      tokenInput.setAttribute("name", "token");
      this.formTarget.appendChild(tokenInput);
    }
    tokenInput.setAttribute("value", token);
  }

  clearFormFields() {
    this.numberElement.clear();
    this.expiryElement.clear();
    this.cvcElement.clear();
  }

  disconnect() {
    this.formTarget.removeEventListener("turbo:before-fetch-request", this.handleTurboBeforeFetchRequest.bind(this));
    this.numberElement.unmount();
    this.expiryElement.unmount();
    this.cvcElement.unmount();
  }
}
