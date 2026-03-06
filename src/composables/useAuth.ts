import { ref, computed, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'
import type { Profile, UserRole } from '@/types/database'
import type { User, Session } from '@supabase/supabase-js'

const user = ref<User | null>(null)
const profile = ref<Profile | null>(null)
const loading = ref(true)

export function useAuth() {
  const isAuthenticated = computed(() => !!user.value)
  const role = computed<UserRole | null>(() => profile.value?.role ?? null)
  const isAdmin = computed(() => role.value === 'admin')
  const isManagerOrAbove = computed(() => role.value === 'admin' || role.value === 'manager')

  async function fetchProfile(userId: string) {
    const { data } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', userId)
      .single()
    if (data) profile.value = data as Profile
  }

  async function signIn(email: string, password: string) {
    const { data, error } = await supabase.auth.signInWithPassword({ email, password })
    if (error) throw error
    user.value = data.user
    if (data.user) await fetchProfile(data.user.id)
    return data
  }

  async function signInWithGoogle() {
    const { data, error } = await supabase.auth.signInWithOAuth({
      provider: 'google',
      options: { redirectTo: window.location.origin }
    })
    if (error) throw error
    return data
  }

  async function signOut() {
    await supabase.auth.signOut()
    user.value = null
    profile.value = null
  }

  function initAuth() {
    onMounted(async () => {
      const { data: { session } } = await supabase.auth.getSession()
      if (session?.user) {
        user.value = session.user
        await fetchProfile(session.user.id)
      }
      loading.value = false

      supabase.auth.onAuthStateChange(async (_event: string, session: Session | null) => {
        user.value = session?.user ?? null
        if (session?.user) {
          await fetchProfile(session.user.id)
        } else {
          profile.value = null
        }
      })
    })
  }

  return {
    user,
    profile,
    loading,
    isAuthenticated,
    role,
    isAdmin,
    isManagerOrAbove,
    signIn,
    signInWithGoogle,
    signOut,
    initAuth,
  }
}
