import { createApp } from 'vue'
import { createPinia } from 'pinia'
import router from './router'
import App from './App.vue'
import './assets/main.css'

const app = createApp(App)
app.use(createPinia())
app.use(router)

// Global error handler — prevents silent errors from freezing the app
app.config.errorHandler = (err, _instance, info) => {
  console.error(`[Vue Error] ${info}:`, err)
}

// Catch unhandled promise rejections globally
window.addEventListener('unhandledrejection', (event) => {
  console.error('[Unhandled Promise]', event.reason)
  event.preventDefault() // Prevent app freeze
})

app.mount('#app')
