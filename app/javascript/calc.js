function calc (){
  const itemPrice  = document.getElementById("item-price");
  itemPrice.addEventListener("keyup", () => {
    const addTaxVal = Math.floor(itemPrice.value * 0.1);
    const profitVal = Math.floor(itemPrice.value * 0.9);
    const addTaxPrice  = document.getElementById("add-tax-price");
    addTaxPrice.innerHTML = addTaxVal;
    const profit  = document.getElementById("profit");
    profit.innerHTML = profitVal;
  });
};

window.addEventListener('turbo:load', calc);
