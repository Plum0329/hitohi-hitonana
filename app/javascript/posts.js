document.addEventListener('turbo:load', function() {
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
    document.getElementById('reading-rules').style.display = 'none';
    document.getElementById('content-rules').style.display = 'block';
    document.getElementById('reading-form').style.display = 'none';
    document.getElementById('content-form').style.display = 'block';
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
        const reading = readingInput.value.replace(/[\s　、。]/g, '');
        const content = contentInput.value.replace(/[\s　、。]/g, '');

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
      showContentForm();
    }
  }
  
  // 初期表示時
  checkErrorState();
  
  document.addEventListener('turbo:render', function() {
    console.log('Turbo render occurred, reattaching event listeners');
    attachEventListeners();
    checkErrorState(); // エラー状態の確認を追加
  });
});