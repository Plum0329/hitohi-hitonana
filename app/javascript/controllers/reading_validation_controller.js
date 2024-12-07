import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener('input', this.validate.bind(this))
    this.element.addEventListener('paste', this.handlePaste.bind(this))
    this.element.addEventListener('compositionend', this.validate.bind(this))
  }

  validate(event) {
    if (event.type === 'input' && event.isComposing) return
    
    const input = event.target
    const value = input.value
    const validText = value.replace(/[^ぁ-んァ-ンー　 \n]/g, '')
    
    if (value !== validText) {
      const start = input.selectionStart
      const end = input.selectionEnd
      input.value = validText
      input.setSelectionRange(start, end)
      this.showError('ひらがな・カタカナ以外は入力できません')
    } else {
      this.clearError()
    }
  }

  handlePaste(event) {
    event.preventDefault()
    const pastedText = (event.clipboardData || window.clipboardData).getData('text')
    const validText = pastedText.replace(/[^ぁ-んァ-ンー　 \n]/g, '')
    
    const start = this.element.selectionStart
    this.element.value = this.element.value.slice(0, start) + validText + this.element.value.slice(this.element.selectionEnd)
    
    const newPosition = start + validText.length
    this.element.setSelectionRange(newPosition, newPosition)
    
    if (pastedText !== validText) {
      this.showError('ひらがな・カタカナ以外は入力できません')
    }
  }

  showError(message) {
    let errorDiv = this.element.parentElement.querySelector('.reading-error')
    if (!errorDiv) {
      errorDiv = document.createElement('div')
      errorDiv.className = 'reading-error alert alert-danger mt-2'
      this.element.parentElement.appendChild(errorDiv)
    }
    errorDiv.textContent = message
  }

  clearError() {
    const errorDiv = this.element.parentElement.querySelector('.reading-error')
    if (errorDiv) {
      errorDiv.remove()
    }
  }
}