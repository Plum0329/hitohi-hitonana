import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [ "input" ];

  connect() {
    console.log('Content validation controller connected');
    console.log('Input target:', this.inputTarget);
    this.inputTarget.addEventListener('input', this.validate.bind(this));
    this.inputTarget.addEventListener('keydown', this.handleKeydown.bind(this));
    this.inputTarget.addEventListener('paste', this.handlePaste.bind(this));
    this.inputTarget.addEventListener('compositionend', this.validate.bind(this));
    this.element.addEventListener('submit', this.handleSubmit.bind(this));
  }

  handleSubmit(event) {
    this.validate({ target: this.inputTarget });
    if (this.inputTarget.parentElement.querySelector('.content-error')) {
      event.preventDefault();
      return false;
    }
  }

  handleKeydown(event) {
    if (event.key === 'Enter') {
      const newlineCount = (this.inputTarget.value.match(/\n/g) || []).length;
      if (newlineCount >= 2) {
        event.preventDefault();
        this.showError('3つ以上の改行は入力できません');
      }
    }
  }

  validate(event) {
    if (event.type === 'input' && event.isComposing) return;
    
    const input = event.target;
    const cursor = input.selectionStart;
    let value = input.value;
    
    // 改行の数をカウント
    const newlineCount = (value.match(/\n/g) || []).length;
  
    // 改行が0個の場合
    if (newlineCount === 0) {
      this.showError('句全体で1つまたは2つの改行を入れてください');
      return;
    }
  
    // 先頭・末尾の改行チェック
    if (value.startsWith('\n') || value.endsWith('\n')) {
      this.showError('句の最初と最後に改行を入れることはできません');
      return;
    }
  
    // 連続した改行のチェック
    const hasConsecutiveNewlines = /\n{2,}/.test(value);
    if (hasConsecutiveNewlines) {
      value = value.replace(/\n+/g, '\n');
      input.value = value;
      this.showError('連続した改行は入力できません');
      return;
    }
    
    // 改行が3個以上の場合
    if (newlineCount > 2) {
      // 最初の2つの改行を見つける
      const firstTwoNewlines = [];
      let pos = -1;
      for (let i = 0; i < 2; i++) {
        pos = value.indexOf('\n', pos + 1);
        if (pos !== -1) {
          firstTwoNewlines.push(pos);
        }
      }

      if (firstTwoNewlines.length === 2) {
        const beforeThirdNewline = value.substring(0, firstTwoNewlines[1] + 1);
        const afterThirdNewline = value.substring(firstTwoNewlines[1] + 1).replace(/\n/g, '');
        value = beforeThirdNewline + afterThirdNewline;
        input.value = value;
        
        // カーソル位置を適切に調整
        const newCursor = Math.min(cursor, value.length);
        input.setSelectionRange(newCursor, newCursor);
      }

      this.showError('3つ以上の改行は入力できません');
      return;
    }

    this.clearError();
  }

  handlePaste(event) {
    event.preventDefault();
    const pastedText = (event.clipboardData || window.clipboardData).getData('text');
    
    const start = this.inputTarget.selectionStart;
    this.inputTarget.value = this.inputTarget.value.slice(0, start) + pastedText + this.inputTarget.value.slice(this.inputTarget.selectionEnd);
    
    const newPosition = start + pastedText.length;
    this.inputTarget.setSelectionRange(newPosition, newPosition);
  
    this.validate({ target: this.inputTarget });
  }

  showError(message) {
    let errorDiv = this.inputTarget.parentElement.querySelector('.content-error');
    if (!errorDiv) {
      errorDiv = document.createElement('div');
      errorDiv.className = 'content-error alert alert-danger mt-2';
      this.inputTarget.parentElement.querySelector('.content-error-container').appendChild(errorDiv);
    }
    this.inputTarget.classList.add('is-invalid');
    errorDiv.textContent = message;
  }

  clearError() {
    const errorDiv = this.inputTarget.parentElement.querySelector('.content-error');
    if (errorDiv) {
      errorDiv.remove();
      this.inputTarget.classList.remove('is-invalid');
    }
  }
}