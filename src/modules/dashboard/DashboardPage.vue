<script setup lang="ts">
import { useAuth } from '@/composables/useAuth'

const { profile } = useAuth()
</script>

<template>
  <div class="dashboard">
    <h1>Bonjour {{ profile?.nom || '' }}</h1>

    <div class="cards">
      <div class="card">
        <h2>Commandes du jour</h2>
        <p class="placeholder">Aucune commande en cours</p>
      </div>

      <div class="card">
        <h2>Réceptions à faire</h2>
        <p class="placeholder">Aucune réception en attente</p>
      </div>

      <div class="card">
        <h2>Alertes</h2>
        <p class="placeholder">Aucune alerte</p>
      </div>

      <div class="card">
        <h2>Stocks bas</h2>
        <p class="placeholder">Tous les stocks sont OK</p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.dashboard h1 {
  font-size: 28px;
  margin-bottom: 24px;
}

.cards {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 16px;
}

.card {
  background: var(--bg-surface);
  border-radius: var(--radius-lg);
  padding: 20px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
}

.card h2 {
  font-size: 18px;
  margin-bottom: 12px;
  color: var(--text-primary);
}

.placeholder {
  color: var(--text-tertiary);
  font-size: 15px;
}
</style>
