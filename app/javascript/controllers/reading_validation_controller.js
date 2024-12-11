import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input" ]
  connect() {
    console.log('Reading validation controller connected')
    console.log('Input target:', this.inputTarget)
    this.inputTarget.addEventListener('input', this.validate.bind(this))
    this.inputTarget.addEventListener('paste', this.handlePaste.bind(this))
    this.inputTarget.addEventListener('compositionend', this.validate.bind(this))
    this.element.addEventListener('submit', this.handleSubmit.bind(this))
  }

  handleSubmit(event) {
    this.validate({ target: this.inputTarget })
    if (this.inputTarget.parentElement.querySelector('.reading-error')) {
      event.preventDefault()
      return false
    }
  }

  validate(event) {
    if (event.type === 'input' && event.isComposing) return
    
    const input = event.target
    let value = input.value
    const validText = value.replace(/[^ぁ-んァ-ンー　 \n]/g, '')
    
    if (value !== validText) {
      const start = input.selectionStart
      const end = input.selectionEnd
      input.value = validText
      input.setSelectionRange(start, end)
      this.showError('ひらがな・カタカナ以外は入力できません')
      return
    }

    const spaceCount = (value.match(/[\s　]/g) || []).length

    if (spaceCount === 0) {
      this.showError('句全体で1つまたは2つの空白を入れてください')
      return
    }

    if (value.startsWith(' ') || value.startsWith('　') || value.endsWith(' ') || value.endsWith('　')) {
      this.showError('句の最初と最後に空白を入れることはできません')
      return
    }

    const hasConsecutiveSpaces = /[\s　]{2,}/.test(value)
    if (hasConsecutiveSpaces) {
      value = value.replace(/[\s　]+/g, ' ')
      input.value = value
      this.showError('連続した空白は入力できません')
      return
    } 
    
    if (spaceCount > 2) {
      let newValue = value
      let matches = value.match(/[\s　]/g) || []
      for (let i = 2; i < matches.length; i++) {
        newValue = newValue.replace(/[\s　]/, '')
      }
      input.value = newValue
      this.showError('句全体で1つまたは2つの空白を入れてください')
      return
    }

    this.clearError()
  }

  handlePaste(event) {
    event.preventDefault()
    const pastedText = (event.clipboardData || window.clipboardData).getData('text')
    const validText = pastedText.replace(/[^ぁ-んァ-ンー　 \n]/g, '')
    
    const start = this.inputTarget.selectionStart
    this.inputTarget.value = this.inputTarget.value.slice(0, start) + validText + this.inputTarget.value.slice(this.inputTarget.selectionEnd)
    
    const newPosition = start + validText.length
    this.inputTarget.setSelectionRange(newPosition, newPosition)
  
    this.validate({ target: this.inputTarget })
  }

  showError(message) {
    let errorDiv = this.inputTarget.parentElement.querySelector('.reading-error')
    if (!errorDiv) {
      errorDiv = document.createElement('div')
      errorDiv.className = 'reading-error alert alert-danger mt-2'
      this.inputTarget.parentElement.querySelector('.reading-error-container').appendChild(errorDiv)
    }
    this.inputTarget.classList.add('is-invalid')
    errorDiv.textContent = message
  }

  clearError() {
    const errorDiv = this.inputTarget.parentElement.querySelector('.reading-error')
    if (errorDiv) {
      errorDiv.remove()
      this.inputTarget.classList.remove('is-invalid')
    }
  }
}