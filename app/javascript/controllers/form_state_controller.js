import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.dataset.unsaved = 'false'
    
    // フォーム要素の変更を監視
    this.element.addEventListener('change', this.markAsChanged.bind(this))
    this.element.addEventListener('input', this.markAsChanged.bind(this))
    
    // フォーム送信時に変更フラグをリセット
    this.element.addEventListener('submit', () => {
      this.element.dataset.unsaved = 'false'
    })

    // ページを離れる前の確認
    window.addEventListener('beforeunload', this.beforeUnload.bind(this))
  }

  disconnect() {
    window.removeEventListener('beforeunload', this.beforeUnload.bind(this))
  }

  markAsChanged() {
    this.element.dataset.unsaved = 'true'
  }

  beforeUnload(event) {
    if (this.element.dataset.unsaved === 'true') {
      event.preventDefault()
      return event.returnValue = '保存されていない変更があります。このページを離れますか？'
    }
  }
}