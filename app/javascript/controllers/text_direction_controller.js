import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "toggle"]

  connect() {
    this.loadDirection()
  }

  loadDirection() {
    const direction = localStorage.getItem('textDirection') || 'horizontal'
    this.updateDirection(direction)
  }

  toggle() {
    const currentDirection = localStorage.getItem('textDirection') || 'horizontal'
    const newDirection = currentDirection === 'horizontal' ? 'vertical' : 'horizontal'
    localStorage.setItem('textDirection', newDirection)
    this.updateDirection(newDirection)
  }

  updateDirection(direction) {
    document.querySelectorAll('.post-content').forEach(element => {
      element.classList.remove('vertical-text', 'horizontal-text')
      element.classList.add(`${direction}-text`)
    })

    if (this.hasToggleTarget) {
      this.toggleTarget.textContent = 
        direction === 'horizontal' ? '縦書きに切り替え' : '横書きに切り替え'
    }
  }
}