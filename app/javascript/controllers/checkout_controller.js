import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["changeCardLink", "selectedCardDisplay", "cardListContainer"];
  static values = { setPaymentMethodUrl: String };

  connect() {
    this.updateSelectedCardDisplay();
    window.addEventListener("pageshow", this.handlePageShow.bind(this));
    window.addEventListener("pagehide", this.handlePageHide.bind(this));
  }

  disconnect() {
    this.clearSession();
  }

  handlePageShow(event) {
    if (event.persisted) {
      this.updateSelectedCardDisplay();
    }
  }

  handlePageHide(event) {
    if (event.persisted) {
      this.clearSession();
    }
  }

  updateSelectedCardDisplay() {
    fetch("/selected_card_display")
      .then((response) => response.text())
      .then((html) => {
        this.selectedCardDisplayTarget.innerHTML = html;

        if (sessionStorage.getItem("updated") !== "true") {
          sessionStorage.setItem("updated", "true"); // Set the flag in session storage
          window.location.reload();
        } else {
          sessionStorage.removeItem("updated"); // Remove the flag to allow future updates
        }
      })
      .catch((error) => console.error("Could not update selected card display:", error));
  }

  clearSession() {
    fetch("/clear_session", {
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

  openCardList(event) {
    event.preventDefault();
    this.selectedCardDisplayTarget.style.display = "none";
    this.changeCardLinkTarget.style.display = "none";
    this.cardListContainerTarget.style.display = "block";
  }

  closeCardList() {
    this.selectedCardDisplayTarget.style.display = "block";
    this.changeCardLinkTarget.style.display = "block";
    this.cardListContainerTarget.style.display = "none";
  }

  setPaymentMethod(event) {
    const cardId = event.target.value;

    fetch(this.setPaymentMethodUrlValue, {
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
