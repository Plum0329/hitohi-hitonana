document.addEventListener('turbo:load', function() {
  const postForm = document.querySelector('form');
  if (!postForm) return;
  console.log("posts.js loaded");

  function showError(message, targetElement) {
    // 既存のエラーメッセージがあれば削除
    const existingError = targetElement.parentElement.querySelector('.error-message');
    if (existingError) {
      existingError.remove();
    }

    // 新しいエラーメッセージを作成
    const errorDiv = document.createElement('div');
    errorDiv.className = 'error-message';
    errorDiv.textContent = message;
    targetElement.parentElement.appendChild(errorDiv);
  }

  function clearError(targetElement) {
    const errorDiv = targetElement.parentElement.querySelector('.error-message');
    if (errorDiv) {
      errorDiv.remove();
    }
  }

  function showContentForm() {
    // 読み方の表示を最優先で行う
    const readingInput = document.querySelector('textarea[name="post[reading]"]');
    const readingDisplay = document.getElementById('reading-display');
    
    if (readingInput && readingDisplay) {
      const readingText = readingInput.value || '';
      readingDisplay.textContent = readingText;
      console.log('Setting reading display:', readingText); // デバッグ用
    }
  
    // その後で表示切り替え
    requestAnimationFrame(() => {
      document.getElementById('reading-rules').style.display = 'none';
      document.getElementById('content-rules').style.display = 'block';
      document.getElementById('reading-form').style.display = 'none';
      document.getElementById('content-form').style.display = 'block';
    });
  }

  function showReadingForm() {
    document.getElementById('content-rules').style.display = 'none';
    document.getElementById('reading-rules').style.display = 'block';
    document.getElementById('content-form').style.display = 'none';
    document.getElementById('reading-form').style.display = 'block';
  }

  function attachEventListeners() {
    console.log("Attaching event listeners");
    
    // フォーム要素の取得
    const readingInput = document.querySelector('textarea[name="post[reading]"]');
    const contentInput = document.querySelector('textarea[name="post[display_content]"]');
    const warningDisplay = document.getElementById('content-warning');

    if (readingInput) {
      readingInput.addEventListener('input', function(event) {
        // IMEの入力中は処理をスキップ
        if (event.isComposing) {
          return;
        }
    
        // 許可する文字パターンの確認
        // ひらがな、カタカナ、長音記号、句読点、全角スペースを許可
        const isValid = /^[ぁ-んァ-ンー　]*$/.test(this.value);
        
        if (!isValid) {
          // 不正な文字が含まれている場合のみ、許可された文字だけを残す
          const validText = this.value.replace(/[^ぁ-んァ-ンー　]/g, '');
          this.value = validText;
          showError('ひらがな・カタカナ以外は入力できません', readingInput);
        } else {
          clearError(readingInput);
        }
      });
    
      // IME確定時の処理
      readingInput.addEventListener('compositionend', function() {
        const isValid = /^[ぁ-んァ-ンー　]*$/.test(this.value);
        
        if (!isValid) {
          const validText = this.value.replace(/[^ぁ-んァ-ンー　]/g, '');
          this.value = validText;
          showError('ひらがな・カタカナ以外は入力できません', readingInput);
        } else {
          clearError(readingInput);
        }
      });
    
      // ペースト時の処理
      readingInput.addEventListener('paste', function(event) {
        event.preventDefault();
        const pastedText = (event.clipboardData || window.clipboardData).getData('text');
        const validText = pastedText.replace(/[^ぁ-んァ-ンー　]/g, '');
        
        // カーソル位置に有効なテキストを挿入
        const start = this.selectionStart;
        const end = this.selectionEnd;
        const text = this.value;
        this.value = text.substring(0, start) + validText + text.substring(end);
        
        if (pastedText !== validText) {
          showError('ひらがな・カタカナ以外は入力できません', readingInput);
        }
      });
    }

    // 次へボタンの処理
    const nextButton = document.getElementById('next-step');
    if (nextButton) {
      const newNextButton = nextButton.cloneNode(true);
      nextButton.parentNode.replaceChild(newNextButton, nextButton);
      
      newNextButton.addEventListener('click', function(event) {
        event.preventDefault();
        clearError(readingInput);
        
        if (!readingInput || !readingInput.value.trim()) {
          showError('読み方を入力してください', readingInput);
          return false;
        }

        const readingDisplay = document.getElementById('reading-display');
        if (readingDisplay) {
          readingDisplay.textContent = readingInput.value;
        }

        showContentForm();
      });
    }

    // 戻るボタンの処理
    const backButton = document.getElementById('back-to-reading');
    if (backButton) {
      const newBackButton = backButton.cloneNode(true);
      backButton.parentNode.replaceChild(newBackButton, backButton);
      
      newBackButton.addEventListener('click', function(event) {
        event.preventDefault();
        clearError(contentInput);
        showReadingForm();
      });
    }

    // 投稿ボタンの処理
    const submitButton = document.querySelector('input[type="submit"]');
    if (submitButton) {
      const newSubmitButton = submitButton.cloneNode(true);
      submitButton.parentNode.replaceChild(newSubmitButton, submitButton);
      
      newSubmitButton.addEventListener('click', function(event) {
        event.preventDefault();
        clearError(contentInput);
        
        const content = contentInput?.value.trim();
        const tagSelected = document.querySelector('input[name="post[tag_id]"]:checked');
        const errors = [];

        if (!content) {
          errors.push('本文が入力されていません');
        }
        
        if (!tagSelected) {
          errors.push('俳句か川柳を選択してください');
        }

        if (errors.length > 0) {
          errors.forEach(error => showError(error, contentInput));
          showContentForm(); // 本文入力画面を表示
          return false;
        }

        // エラーがなければフォームを送信
        this.form.submit();
      });
    }    

    // 本文と読みの長さチェック
    if (contentInput && readingInput && warningDisplay) {
      contentInput.addEventListener('input', function() {
        const reading = readingInput.value.replace(/[\s　]/g, '');
        const content = contentInput.value.replace(/[\s　]/g, '');

        if (content.length < (reading.length / 2)) {
          warningDisplay.textContent = "本文が読みより短いようです。意図した入力ですか？";
        } else if (content.length > (reading.length * 2)) {
          warningDisplay.textContent = "本文が読みより長いようです。意図した入力ですか？";
        } else {
          warningDisplay.textContent = "";
        }
      });
    }
  }

  // 初期表示時にエラーがある場合は本文フォームを表示
  function checkErrorState() {
    if (document.querySelector('.error-message') || document.querySelector('.alert-danger')) {
      const readingInput = document.querySelector('textarea[name="post[reading]"]');
      const readingDisplay = document.getElementById('reading-display');
      if (readingInput && readingDisplay) {
        readingDisplay.textContent = readingInput.value;
      }
      showContentForm();
    }
  }

  // 初期化処理の呼び出し
  attachEventListeners();
  checkErrorState();

  // turbo:renderイベントのリスナー
  document.addEventListener('turbo:render', function() {
    console.log('Turbo render occurred, reattaching event listeners');
    attachEventListeners();
    checkErrorState();
  });
});