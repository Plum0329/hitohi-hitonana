import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    fallbackPath: String
  }

  back(event) {
    event.preventDefault()
    
    // アニメーション用のクラスを追加
    event.currentTarget.classList.add('loading')

    // 直前のページに戻る
    if (window.history && window.history.length > 1) {
      window.history.back()
    } else {
      // 履歴がない場合はフォールバックパスに遷移
      window.location.href = this.fallbackPathValue
    }
  }
}