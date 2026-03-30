import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog"]

  open() {
    this.dialogTarget.style.display = "flex"
  }

  close() {
    this.dialogTarget.style.display = "none"
  }

  closeOnBackdrop(event) {
    if (event.target === this.dialogTarget) {
      this.close()
    }
  }
}
