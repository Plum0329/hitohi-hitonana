document.addEventListener('turbo:load', function() {
  console.log("posts.js loaded");
  
  function initializeForm() {
    const readingForm = document.getElementById('reading-form');
    const contentForm = document.getElementById('content-form');
    const nextButton = document.getElementById('next-step');
    const backButton = document.getElementById('back-to-reading');
    const readingInput = document.querySelector('textarea[name="post[reading]"]');
    const contentInput = document.querySelector('textarea[name="post[display_content]"]');
    const warningDisplay = document.getElementById('content-warning');
    
    console.log('Elements found:', {
      readingForm: !!readingForm,
      contentForm: !!contentForm,
      nextButton: !!nextButton,
      backButton: !!backButton
    });

    if (nextButton) {
      nextButton.addEventListener('click', function(event) {
        console.log('Next button clicked');
        event.preventDefault();
        
        if (readingInput && readingInput.value.trim()) {
          readingForm.style.display = 'none';
          contentForm.style.display = 'block';
          console.log('Switched to content form');
        }
      });
    }

    if (backButton) {
      backButton.addEventListener('click', function(event) {
        console.log('Back button clicked');
        event.preventDefault();
        contentForm.style.display = 'none';
        readingForm.style.display = 'block';
        console.log('Switched to reading form');
      });
    }

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

  initializeForm();

  // Turboによるページ更新時にも初期化を実行
  document.addEventListener('turbo:render', function() {
    console.log('Turbo render occurred, reinitializing form');
    initializeForm();
  });
});