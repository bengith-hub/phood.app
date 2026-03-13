<script setup lang="ts">
import { ref, nextTick } from 'vue'

const props = defineProps<{
  modelValue: string[]
  placeholder?: string
}>()

const emit = defineEmits<{
  'update:modelValue': [value: string[]]
}>()

const inputValue = ref('')
const inputRef = ref<HTMLInputElement | null>(null)
const shakeInput = ref(false)

const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

function addEmail() {
  const raw = inputValue.value.trim()
  if (!raw) return

  // Split by comma in case user pastes multiple
  const emails = raw.split(',').map(e => e.trim()).filter(Boolean)
  const valid: string[] = []

  for (const email of emails) {
    if (EMAIL_REGEX.test(email) && !props.modelValue.includes(email)) {
      valid.push(email)
    }
  }

  if (valid.length > 0) {
    emit('update:modelValue', [...props.modelValue, ...valid])
    inputValue.value = ''
  } else {
    // Flash red
    shakeInput.value = true
    setTimeout(() => shakeInput.value = false, 400)
  }
}

function removeEmail(index: number) {
  const updated = [...props.modelValue]
  updated.splice(index, 1)
  emit('update:modelValue', updated)
}

function onKeydown(e: KeyboardEvent) {
  if (e.key === 'Enter' || e.key === ',') {
    e.preventDefault()
    addEmail()
  } else if (e.key === 'Backspace' && !inputValue.value && props.modelValue.length > 0) {
    removeEmail(props.modelValue.length - 1)
  }
}

function onBlur() {
  if (inputValue.value.trim()) {
    addEmail()
  }
}

function focusInput() {
  nextTick(() => inputRef.value?.focus())
}
</script>

<template>
  <div class="email-tag-input" @click="focusInput">
    <div class="tags-wrap">
      <span
        v-for="(email, i) in modelValue"
        :key="email"
        class="tag"
      >
        {{ email }}
        <button type="button" class="tag-remove" @click.stop="removeEmail(i)" aria-label="Supprimer">
          &times;
        </button>
      </span>
      <input
        ref="inputRef"
        v-model="inputValue"
        type="email"
        inputmode="email"
        autocomplete="email"
        :placeholder="modelValue.length === 0 ? (placeholder || 'Ajouter un email…') : ''"
        class="tag-input"
        :class="{ shake: shakeInput }"
        @keydown="onKeydown"
        @blur="onBlur"
      />
    </div>
  </div>
</template>

<style scoped>
.email-tag-input {
  border: 1.5px solid var(--color-border, #D1D5DB);
  border-radius: 10px;
  padding: 8px 10px;
  cursor: text;
  background: #fff;
  min-height: 48px;
  display: flex;
  align-items: flex-start;
  transition: border-color 0.2s;
}
.email-tag-input:focus-within {
  border-color: var(--color-primary, #E85D2C);
  box-shadow: 0 0 0 3px rgba(232, 93, 44, 0.08);
}

.tags-wrap {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  width: 100%;
  align-items: center;
}

.tag {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  background: #F9FAFB;
  border: 1px solid #E5E7EB;
  border-radius: 6px;
  padding: 4px 6px 4px 10px;
  font-size: 13px;
  color: var(--color-text, #374151);
  line-height: 1.3;
  white-space: nowrap;
  transition: background 0.15s, border-color 0.15s;
}
.tag:hover {
  background: #F3F4F6;
  border-color: #D1D5DB;
}

.tag-remove {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 18px;
  height: 18px;
  min-width: 18px;
  border: none;
  background: transparent;
  border-radius: 4px;
  font-size: 14px;
  font-weight: 600;
  color: #9CA3AF;
  cursor: pointer;
  line-height: 1;
  padding: 0;
  transition: background 0.15s, color 0.15s;
}
.tag-remove:hover {
  background: #FEE2E2;
  color: #EF4444;
}

.tag-input {
  flex: 1;
  min-width: 140px;
  border: none;
  outline: none;
  font-size: 14px;
  padding: 4px 4px;
  background: transparent;
  color: var(--color-text, #1F2937);
}
.tag-input::placeholder {
  color: #9CA3AF;
}

.tag-input.shake {
  animation: shake-red 0.35s;
}

@keyframes shake-red {
  0%, 100% { box-shadow: none; }
  25% { box-shadow: 0 0 0 2px #EF4444; transform: translateX(-2px); }
  50% { box-shadow: 0 0 0 2px #EF4444; transform: translateX(2px); }
  75% { box-shadow: 0 0 0 2px #EF4444; transform: translateX(-1px); }
}
</style>
