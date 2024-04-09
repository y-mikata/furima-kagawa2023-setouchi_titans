import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["selectedCard"];
  static values = { setCardUrl: String, clearSessionUrl: String, refreshCardFrameUrl: String };

  connect() {
    this.refreshSelectedCardDisplay();
    window.addEventListener("pageshow", this.handlePageShow.bind(this));
    window.addEventListener("pagehide", this.handlePageHide.bind(this));
  }

  disconnect() {
    this.clearSession();
    window.removeEventListener("pageshow", this.handlePageShow.bind(this));
    window.removeEventListener("pagehide", this.handlePageHide.bind(this));
  }

  handlePageShow(event) {
    if (event.persisted) {
      this.refreshSelectedCardDisplay();
    }
  }

  handlePageHide(event) {
    if (event.persisted) {
      this.clearSession();
    }
  }

  refreshSelectedCardDisplay() {
    fetch(this.refreshCardFrameUrlValue)
      .then((response) => response.text())
      .then((html) => {
        const turboFrame = document.getElementById("card_frame");
        if (turboFrame) {
          turboFrame.innerHTML = html;
        }
      })
      .catch((error) => console.error("Could not update selected card display:", error));
  }

  clearSession() {
    fetch(this.clearSessionUrlValue, {
      method: "POST",
      headers: {
        "X-CSRF-Token": this.getCSRFToken(),
        "Content-Type": "application/json",
      },
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error("Failed to clear session");
        }
        console.log("Session cleared successfully");
      })
      .catch((error) => {
        console.error("Error clearing session:", error);
      });
  }

  setPaymentMethod(event) {
    const cardId = event.target.value;

    fetch(this.setCardUrlValue, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": this.getCSRFToken(),
      },
      body: JSON.stringify({ selected_card_id: cardId }),
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        return response.json();
      })
      .then((data) => {
        console.log("Payment method set:", data);
      })
      .catch((error) => {
        console.error("Failed to set payment method:", error);
      });
  }

  getCSRFToken() {
    return document.querySelector('meta[name="csrf-token"]').getAttribute("content");
  }
}
