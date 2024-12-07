import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "output"]

  connect() {
    console.log("Post Preview Controller connected")
    if (this.hasInputTarget && this.hasOutputTarget) {
      console.log("Preview targets found") // デバッグ用
      this.update()
    } else {
      console.log("Missing preview targets") // デバッグ用
    }
  }

  update() {
    try {
      if (!this.hasInputTarget || !this.hasOutputTarget) {
        console.log("Missing targets in update") // デバッグ用
        return
      }
      console.log("Updating preview with:", this.inputTarget.value) // デバッグ用
      this.outputTarget.textContent = this.inputTarget.value
    } catch (error) {
      console.error("Error in update:", error)
    }
  }
}