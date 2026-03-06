<script setup lang="ts">
import { ref } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const commandeId = ref(route.params.id as string | undefined)
const isNew = !commandeId.value
</script>

<template>
  <div class="commande-edit">
    <h1>{{ isNew ? 'Nouvelle commande' : `Commande ${commandeId}` }}</h1>
    <p class="placeholder">Module de création/édition de commande — en développement</p>
  </div>
</template>

<style scoped>
h1 { font-size: 28px; margin-bottom: 20px; }
.placeholder { color: var(--text-tertiary); }
</style>
