import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "toggle"]
  static values = {
    direction: String
  }

  connect() {
    this.loadDirection()
    // ページ読み込み時に現在の方向を設定
    this.updateAllPages()
  }

  loadDirection() {
    this.direction = localStorage.getItem('textDirection') || 'vertical'
    this.updateDirection()
  }

  toggle() {
    this.direction = this.direction === 'vertical' ? 'horizontal' : 'vertical'
    localStorage.setItem('textDirection', this.direction)
    // 切り替え時に全ページの要素を更新
    this.updateAllPages()
  }

  updateDirection() {
    // このコントローラーの配下の要素を更新
    this.contentTargets.forEach(element => {
      element.classList.remove('vertical-text', 'horizontal-text')
      element.classList.add(`${this.direction}-text`)
    })

    // ボタンのテキストを更新
    if (this.hasToggleTarget) {
      this.toggleTarget.textContent = 
        this.direction === 'vertical' ? '横書きに切り替え' : '縦書きに切り替え'
    }
  }

  updateAllPages() {
    // documentのすべてのpost-content要素を取得して更新
    document.querySelectorAll('.post-content').forEach(element => {
      element.classList.remove('vertical-text', 'horizontal-text')
      element.classList.add(`${this.direction}-text`)
    })

    // すべての切り替えボタンのテキストを更新
    document.querySelectorAll('[data-text-direction-target="toggle"]').forEach(button => {
      button.textContent = this.direction === 'vertical' ? '横書きに切り替え' : '縦書きに切り替え'
    })

    // カスタムイベントを発行して他のコントローラーに通知
    const event = new CustomEvent('textDirectionChange', { 
      detail: { direction: this.direction }
    })
    window.dispatchEvent(event)
  }
}