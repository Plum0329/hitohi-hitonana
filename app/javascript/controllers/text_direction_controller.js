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
      const icon = this.toggleTarget.querySelector('i')
      if (icon) {
        if (direction === 'horizontal') {
          icon.classList.add('rotated')
        } else {
          icon.classList.remove('rotated')
        }
      }
    }
  }
}