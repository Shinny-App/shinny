import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]

  submit(event) {
    this.buttonTargets.forEach(btn => btn.classList.add("opacity-50", "pointer-events-none"))
  }
}
