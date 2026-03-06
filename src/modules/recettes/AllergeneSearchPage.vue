<script setup lang="ts">
import { ref } from 'vue'

const query = ref('')
const results = ref<string[]>([])
</script>

<template>
  <div class="allergene-search">
    <h1>Vérification allergènes</h1>
    <p class="subtitle">Recherchez un allergène ou ingrédient pour vérifier sa présence dans les recettes</p>

    <input
      v-model="query"
      type="search"
      placeholder="Ex: gluten, sésame, lait..."
      class="search-input"
      autofocus
    />

    <div v-if="query && results.length === 0" class="no-results">
      Aucun résultat pour "{{ query }}" — recherche en développement
    </div>
  </div>
</template>

<style scoped>
h1 { font-size: 28px; margin-bottom: 8px; }
.subtitle { color: var(--text-secondary); margin-bottom: 24px; font-size: 16px; }
.search-input {
  width: 100%;
  height: 56px;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  padding: 0 20px;
  font-size: 20px;
  background: var(--bg-surface);
}
.search-input:focus {
  outline: none;
  border-color: var(--color-primary);
}
.no-results {
  margin-top: 32px;
  text-align: center;
  color: var(--text-tertiary);
}
</style>
