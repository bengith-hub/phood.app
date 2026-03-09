<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuth } from '@/composables/useAuth'

const router = useRouter()
const { signIn, signInWithGoogle, resetPassword } = useAuth()

const email = ref('')
const password = ref('')
const error = ref('')
const loading = ref(false)
const showForgot = ref(false)
const resetEmail = ref('')
const resetLoading = ref(false)
const resetMsg = ref('')

async function handleSubmit() {
  error.value = ''
  loading.value = true
  try {
    await signIn(email.value, password.value)
    router.push('/')
  } catch (e: unknown) {
    error.value = e instanceof Error ? e.message : 'Erreur de connexion'
  } finally {
    loading.value = false
  }
}

async function handleGoogle() {
  error.value = ''
  try {
    await signInWithGoogle()
  } catch (e: unknown) {
    error.value = e instanceof Error ? e.message : 'Erreur Google'
  }
}

async function handleResetPassword() {
  if (!resetEmail.value) return
  resetLoading.value = true
  resetMsg.value = ''
  try {
    await resetPassword(resetEmail.value)
    resetMsg.value = 'Un email de réinitialisation a été envoyé.'
  } catch (e: unknown) {
    resetMsg.value = e instanceof Error ? e.message : 'Erreur lors de l\'envoi'
  } finally {
    resetLoading.value = false
  }
}
</script>

<template>
  <div class="login-page">
    <div class="login-card">
      <img src="/assets/logos/phood-logo.png" alt="Phood" class="login-logo" />
      <p class="login-subtitle">Gestion Restaurant</p>

      <form @submit.prevent="handleSubmit" action="/login" method="post" class="login-form">
        <div class="field">
          <label for="login-email">Email</label>
          <input
            id="login-email"
            name="email"
            v-model="email"
            type="email"
            autocomplete="email"
            inputmode="email"
            required
            placeholder="votre@email.fr"
          />
        </div>
        <div class="field">
          <label for="login-password">Mot de passe</label>
          <input
            id="login-password"
            name="password"
            v-model="password"
            type="password"
            autocomplete="current-password"
            required
            placeholder="••••••••"
          />
        </div>

        <p v-if="error" class="error">{{ error }}</p>

        <button type="submit" class="btn-primary" :disabled="loading">
          {{ loading ? 'Connexion...' : 'Se connecter' }}
        </button>

        <button type="button" class="btn-forgot" @click="showForgot = true">
          Mot de passe oublié ?
        </button>
      </form>

      <!-- Forgot password inline form -->
      <div v-if="showForgot" class="forgot-section">
        <p class="forgot-title">Réinitialiser le mot de passe</p>
        <div class="forgot-form">
          <input
            id="reset-email"
            name="email"
            v-model="resetEmail"
            type="email"
            autocomplete="email"
            placeholder="votre@email.fr"
            @keyup.enter="handleResetPassword"
          />
          <button
            class="btn-primary btn-reset"
            :disabled="resetLoading || !resetEmail"
            @click="handleResetPassword"
          >
            {{ resetLoading ? 'Envoi...' : 'Envoyer' }}
          </button>
        </div>
        <p v-if="resetMsg" class="reset-msg" :class="{ success: resetMsg.includes('envoyé') }">
          {{ resetMsg }}
        </p>
        <button class="btn-forgot" @click="showForgot = false">Retour à la connexion</button>
      </div>

      <div class="separator">
        <span>ou</span>
      </div>

      <button class="btn-google" @click="handleGoogle">
        Continuer avec Google
      </button>
    </div>
  </div>
</template>

<style scoped>
.login-page {
  min-height: 100dvh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--bg-main);
  padding: 20px;
}

.login-card {
  width: 100%;
  max-width: 420px;
  background: var(--bg-surface);
  border-radius: 16px;
  padding: 40px 32px;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.08);
}

.login-logo {
  display: block;
  margin: 0 auto;
  height: 48px;
  width: auto;
  object-fit: contain;
}

.login-subtitle {
  text-align: center;
  color: var(--text-secondary);
  font-size: 16px;
  margin: 8px 0 32px;
}

.login-form {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.field {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.field label {
  font-size: 15px;
  font-weight: 600;
  color: var(--text-primary);
}

.field input {
  height: 52px;
  border: 2px solid var(--border);
  border-radius: 12px;
  padding: 0 16px;
  font-size: 18px;
  background: var(--bg-main);
  color: var(--text-primary);
  transition: border-color 0.15s;
}

.field input:focus {
  outline: none;
  border-color: var(--color-primary);
}

.error {
  color: var(--color-danger);
  font-size: 14px;
  margin: 0;
}

.btn-primary {
  height: 56px;
  border: none;
  border-radius: 12px;
  background: var(--color-primary);
  color: white;
  font-size: 18px;
  font-weight: 700;
  cursor: pointer;
  transition: opacity 0.15s;
}

.btn-primary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.separator {
  display: flex;
  align-items: center;
  margin: 24px 0;
  gap: 12px;
}

.separator::before,
.separator::after {
  content: '';
  flex: 1;
  border-top: 1px solid var(--border);
}

.separator span {
  color: var(--text-tertiary);
  font-size: 14px;
}

.btn-forgot {
  background: none;
  border: none;
  color: var(--color-primary);
  font-size: 15px;
  cursor: pointer;
  padding: 12px 0;
  text-align: center;
  width: 100%;
  min-height: 48px;
}

.forgot-section {
  margin-top: 16px;
  padding: 16px;
  background: var(--bg-main);
  border-radius: 12px;
}

.forgot-title {
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 12px;
  color: var(--text-primary);
}

.forgot-form {
  display: flex;
  gap: 8px;
}

.forgot-form input {
  flex: 1;
  height: 48px;
  border: 2px solid var(--border);
  border-radius: 12px;
  padding: 0 14px;
  font-size: 16px;
  background: var(--bg-surface);
}

.forgot-form input:focus {
  outline: none;
  border-color: var(--color-primary);
}

.btn-reset {
  height: 48px;
  padding: 0 20px;
  font-size: 15px;
  white-space: nowrap;
}

.reset-msg {
  font-size: 14px;
  margin-top: 10px;
  color: var(--color-danger);
}

.reset-msg.success {
  color: var(--color-success);
}

.btn-google {
  width: 100%;
  height: 52px;
  border: 2px solid var(--border);
  border-radius: 12px;
  background: white;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  color: var(--text-primary);
}
</style>
