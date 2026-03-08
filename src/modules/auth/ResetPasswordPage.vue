<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuth } from '@/composables/useAuth'

const router = useRouter()
const { updatePassword } = useAuth()

const password = ref('')
const confirmPassword = ref('')
const error = ref('')
const loading = ref(false)
const success = ref(false)

async function handleSubmit() {
  error.value = ''

  if (password.value.length < 6) {
    error.value = 'Le mot de passe doit contenir au moins 6 caractères'
    return
  }

  if (password.value !== confirmPassword.value) {
    error.value = 'Les mots de passe ne correspondent pas'
    return
  }

  loading.value = true
  try {
    await updatePassword(password.value)
    success.value = true
    setTimeout(() => router.push('/'), 2000)
  } catch (e: unknown) {
    error.value = e instanceof Error ? e.message : 'Erreur lors de la mise à jour'
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="reset-page">
    <div class="reset-card">
      <img src="/assets/logos/phood-logo.png" alt="Phood" class="reset-logo" />
      <h1>Nouveau mot de passe</h1>

      <div v-if="success" class="success-msg">
        Mot de passe mis à jour. Redirection...
      </div>

      <form v-else @submit.prevent="handleSubmit" class="reset-form">
        <div class="field">
          <label for="password">Nouveau mot de passe</label>
          <input
            id="password"
            v-model="password"
            type="password"
            autocomplete="new-password"
            required
            placeholder="Min. 6 caractères"
          />
        </div>
        <div class="field">
          <label for="confirm">Confirmer le mot de passe</label>
          <input
            id="confirm"
            v-model="confirmPassword"
            type="password"
            autocomplete="new-password"
            required
            placeholder="Retapez le mot de passe"
          />
        </div>

        <p v-if="error" class="error">{{ error }}</p>

        <button type="submit" class="btn-primary" :disabled="loading">
          {{ loading ? 'Mise à jour...' : 'Mettre à jour' }}
        </button>
      </form>

      <button class="btn-link" @click="router.push('/login')">
        Retour à la connexion
      </button>
    </div>
  </div>
</template>

<style scoped>
.reset-page {
  min-height: 100dvh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--bg-main);
  padding: 20px;
}

.reset-card {
  width: 100%;
  max-width: 420px;
  background: var(--bg-surface);
  border-radius: 16px;
  padding: 40px 32px;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.08);
}

.reset-logo {
  display: block;
  margin: 0 auto 16px;
  height: 48px;
  width: auto;
  object-fit: contain;
}

h1 {
  text-align: center;
  font-size: 22px;
  font-weight: 700;
  color: var(--text-primary);
  margin-bottom: 24px;
}

.reset-form {
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

.success-msg {
  text-align: center;
  color: var(--color-success);
  font-size: 16px;
  font-weight: 600;
  padding: 20px 0;
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

.btn-link {
  display: block;
  margin-top: 16px;
  width: 100%;
  background: none;
  border: none;
  color: var(--color-primary);
  font-size: 15px;
  cursor: pointer;
  text-align: center;
  min-height: 40px;
}
</style>
