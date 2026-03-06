<script setup lang="ts">
import { useRouter } from 'vue-router'

const router = useRouter()
</script>

<template>
  <div>
    <div class="page-header">
      <h1>Recettes & Ingrédients</h1>
      <button class="btn-allergenes" @click="router.push('/recettes/allergenes')">
        Vérif allergènes
      </button>
    </div>
    <p class="placeholder">Module recettes — en développement</p>
  </div>
</template>

<style scoped>
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}
h1 { font-size: 28px; }
.btn-allergenes {
  background: var(--color-warning);
  color: white;
  border: none;
  border-radius: var(--radius-md);
  padding: 12px 20px;
  font-size: 16px;
  font-weight: 700;
  cursor: pointer;
}
.placeholder { color: var(--text-tertiary); }
</style>
