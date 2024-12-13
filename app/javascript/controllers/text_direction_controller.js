import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "toggle"]

  connect() {
    console.log("Text Direction Controller connected")
    console.log("Content targets:", this.contentTargets.length)
    this.loadDirection()
  }

  loadDirection() {
    try {
      this.direction = localStorage.getItem('textDirection') || 'vertical'
      console.log("Loading direction:", this.direction)
      this.updateDirection()
    } catch (error) {
      console.error("Error loading direction:", error)
    }
  }

  toggle() {
    try {
      console.log("Toggle clicked. Current direction:", this.direction)
      this.direction = this.direction === 'vertical' ? 'horizontal' : 'vertical'
      localStorage.setItem('textDirection', this.direction)
      this.updateDirection()
    } catch (error) {
      console.error("Error toggling direction:", error)
    }
  }

  updateDirection() {
    try {
      console.log("Updating direction to:", this.direction)
      console.log("Content targets found:", this.contentTargets.length)
      
      this.contentTargets.forEach((element, index) => {
        console.log(`Updating target ${index}:`, element)
        element.classList.remove('vertical-text', 'horizontal-text')
        element.classList.add(`${this.direction}-text`)
      })

      if (this.hasToggleTarget) {
        this.toggleTarget.textContent = 
          this.direction === 'vertical' ? '横書きに切り替え' : '縦書きに切り替え'
      }
    } catch (error) {
      console.error("Error in updateDirection:", error)
    }
  }
}