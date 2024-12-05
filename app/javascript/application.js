// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
import "./posts"

document.addEventListener('turbo:load', () => {
  const flashMessages = document.querySelectorAll('.notice, .alert');
  flashMessages.forEach(message => {
    setTimeout(() => {
      message.style.display = 'none';
    }, 3000);
  });
});