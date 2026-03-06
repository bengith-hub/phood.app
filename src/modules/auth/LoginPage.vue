<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuth } from '@/composables/useAuth'

const router = useRouter()
const { signIn, signInWithGoogle } = useAuth()

const email = ref('')
const password = ref('')
const error = ref('')
const loading = ref(false)

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
</script>

<template>
  <div class="login-page">
    <div class="login-card">
      <h1 class="login-brand">Phood</h1>
      <p class="login-subtitle">Gestion Restaurant</p>

      <form @submit.prevent="handleSubmit" class="login-form">
        <div class="field">
          <label for="email">Email</label>
          <input
            id="email"
            v-model="email"
            type="email"
            autocomplete="email"
            required
            placeholder="votre@email.fr"
          />
        </div>
        <div class="field">
          <label for="password">Mot de passe</label>
          <input
            id="password"
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
      </form>

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

.login-brand {
  text-align: center;
  font-size: 36px;
  font-weight: 800;
  color: var(--color-primary);
  margin: 0;
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
