const selector = () => {
  var changeCardLink = document.getElementById("change-card-link");
  var selectedCardDisplay = document.getElementById("selected-card-container");
  var cardListContainer = document.getElementById("card-list-container");
  var cardSelectionRadios = document.querySelectorAll(".card-selection-radio");

  // Function to open the card list
  function openCardList() {
    selectedCardDisplay.style.display = "none";
    changeCardLink.style.display = "none";
    cardListContainer.style.display = "block";
  }

  // Function to close the card list
  function closeCardList() {
    selectedCardDisplay.style.display = "block";
    changeCardLink.style.display = "block";
    cardListContainer.style.display = "none";
  }

  // Event listener for the 'Change' link
  changeCardLink.addEventListener("click", function (event) {
    event.preventDefault();
    openCardList();
  });

  fetch("/selected_card_display")
    .then((response) => response.text())
    .then((html) => {
      document.getElementById("selected-card-container").innerHTML = html;
    });

  cardSelectionRadios.forEach(function (radioButton) {
    radioButton.addEventListener("change", function (event) {
      var cardId = this.value;

      fetch("/set_payment_method", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
        },
        body: JSON.stringify({ selected_card_id: cardId }),
      })
        .then((response) => {
          if (response.ok) {
            return response.json();
          }
        })
        .then((data) => {
          console.log("Payment method set:", data);
        })
        .catch((error) => {
          console.error("Failed to set payment method:", error);
        });
    });
    document.getElementById("card-selection-form").addEventListener("submit", function (event) {
      event.preventDefault();
      fetch("/selected_card_display")
        .then((response) => response.text())
        .then((html) => {
          document.getElementById("selected-card-container").innerHTML = html;
        });
      closeCardList();
    });
  });
};

const unload = () => {
  fetch("/clear_session", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
    },
  });
};

const resetRadioButtons = () => {
  var defaultCardId = gon.default_card;

  document.querySelectorAll(".card-selection-radio").forEach((radioButton) => {
    if (radioButton.value === defaultCardId) {
      radioButton.checked = true;
    }
  });
  document.addEventListener("turbo:load", function () {
    location.reload();
  });
};

window.addEventListener("turbo:before-cache", unload);
window.addEventListener("turbo:render", resetRadioButtons);
window.addEventListener("turbo:load", selector);
window.addEventListener("turbo:render", selector);
