<script setup lang="ts">
import { useAuth } from '@/composables/useAuth'

const { initAuth } = useAuth()
initAuth()
</script>

<template>
  <router-view />
</template>
