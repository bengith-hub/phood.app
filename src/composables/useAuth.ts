import { ref, computed, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'
import { restCall, hasValidSession, setCachedRole } from '@/lib/rest-client'
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

  /** Fetch profile via direct REST (bypasses Supabase client) */
  async function fetchProfile(userId: string) {
    const data = await restCall<Profile | null>(
      'GET',
      `profiles?id=eq.${userId}&select=*`,
      undefined,
      { maybeSingle: true, timeout: 5000 },
    )
    if (data) {
      profile.value = data
      setCachedRole(data.role)
    }
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

  async function resetPassword(email: string) {
    const { error } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: `${window.location.origin}/reset-password`,
    })
    if (error) throw error
  }

  async function updatePassword(newPassword: string) {
    const { error } = await supabase.auth.updateUser({ password: newPassword })
    if (error) throw error
  }

  async function signOut() {
    await supabase.auth.signOut()
    user.value = null
    profile.value = null
    setCachedRole(null)
  }

  /**
   * Initialize auth state from localStorage (instant, no hang risk).
   * Sets up onAuthStateChange listener for real-time session updates.
   * NEVER calls supabase.auth.getSession() which can hang indefinitely.
   */
  function initAuth() {
    onMounted(async () => {
      // Fast check from localStorage — no network call, no hang risk
      const session = hasValidSession()
      if (session.valid && session.userId) {
        user.value = { id: session.userId } as User
        try {
          await fetchProfile(session.userId)
        } catch { /* ignore — profile will load when network is available */ }
      }
      loading.value = false

      // Listen for auth state changes (event-driven, safe — doesn't trigger refresh)
      supabase.auth.onAuthStateChange(async (_event: string, sess: Session | null) => {
        user.value = sess?.user ?? null
        if (sess?.user) {
          try { await fetchProfile(sess.user.id) } catch { /* ignore */ }
        } else {
          profile.value = null
          setCachedRole(null)
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
    resetPassword,
    updatePassword,
    signOut,
    initAuth,
  }
}
