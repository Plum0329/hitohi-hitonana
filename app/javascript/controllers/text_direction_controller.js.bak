import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "toggle"]

  connect() {
    console.log("Text Direction Controller connected")
    this.initialize()
  }

  initialize() {
    this.direction = localStorage.getItem('textDirection') || 'vertical'
    this.updateDirection()
    
    this.observer = new MutationObserver(() => {
      this.updateDirection()
    })
    
    this.observer.observe(document.body, {
      childList: true,
      subtree: true
    })
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  toggle() {
    this.direction = this.direction === 'vertical' ? 'horizontal' : 'vertical'
    localStorage.setItem('textDirection', this.direction)
    this.updateDirection()
  }

  updateDirection() {
    if (!this.hasContentTarget) {
      return;
    }
  
    this.contentTargets.forEach(element => {
      // アニメーションのための準備
      element.style.transition = 'all 0.3s ease-in-out';
      
      // クラスの切り替え
      element.classList.remove('vertical-text', 'horizontal-text');
      element.classList.add(`${this.direction}-text`);
    });
  
    if (this.hasToggleTarget) {
      this.toggleTarget.textContent = 
        this.direction === 'vertical' ? '横書きに切り替え' : '縦書きに切り替え';
    }
  }
}