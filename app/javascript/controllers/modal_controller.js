import { Controller } from "@hotwired/stimulus";
import { enter, leave } from "el-transition";

export default class extends Controller {
  static targets = ["wrapper", "body"];

  connect() {
    enter(this.wrapperTarget);
    enter(this.bodyTarget);

    document.addEventListener("turbo:submit-end", this.handleSubmit);
  }

  disconnect() {
    document.removeEventListener("turbo:submit-end", this.handleSubmit);
  }

  close() {
    leave(this.wrapperTarget);
    leave(this.bodyTarget).then(() => {
      this.element.remove();
    });
    this.element.parentElement.removeAttribute("src");
  }

  handleKeyup(e) {
    if (e.code == "Escape") {
      this.close();
    }
  }

  handleSubmit = (e) => {
    if (e.detail.success) {
      this.close();
    }
  };
}
