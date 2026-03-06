<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const filter = ref('')
</script>

<template>
  <div class="commandes-page">
    <div class="page-header">
      <h1>Commandes</h1>
      <button class="btn-primary" @click="router.push('/commandes/new')">
        + Nouvelle commande
      </button>
    </div>

    <div class="filters">
      <input v-model="filter" type="search" placeholder="Rechercher..." />
    </div>

    <p class="placeholder">Aucune commande pour le moment. Créez votre première commande.</p>
  </div>
</template>

<style scoped>
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.page-header h1 {
  font-size: 28px;
}

.btn-primary {
  background: var(--color-primary);
  color: white;
  border: none;
  border-radius: var(--radius-md);
  padding: 12px 24px;
  font-size: 16px;
  font-weight: 700;
  cursor: pointer;
}

.filters {
  margin-bottom: 20px;
}

.filters input {
  width: 100%;
  max-width: 400px;
  height: 52px;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  padding: 0 16px;
  font-size: 18px;
  background: var(--bg-surface);
}

.placeholder {
  color: var(--text-tertiary);
  text-align: center;
  padding: 60px 20px;
  font-size: 16px;
}
</style>
