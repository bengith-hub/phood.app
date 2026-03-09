/**
 * Direct REST client for Supabase PostgREST.
 *
 * Bypasses the Supabase JS client entirely to avoid its internal
 * auth token refresh mechanism which can hang indefinitely,
 * freezing ALL operations (reads and writes) and blocking navigation.
 *
 * All calls have a configurable AbortController timeout (default 10s).
 */

const SUPABASE_URL = import.meta.env.VITE_SUPABASE_URL as string
const SUPABASE_ANON_KEY = import.meta.env.VITE_SUPABASE_ANON_KEY as string

const PROJECT_REF = SUPABASE_URL?.replace('https://', '').split('.')[0] || ''

// ── Session helpers (localStorage only, no network calls) ────────

/** Read the user's JWT from Supabase's localStorage cache */
export function getAccessToken(): string {
  try {
    const stored = localStorage.getItem(`sb-${PROJECT_REF}-auth-token`)
    if (stored) {
      const parsed = JSON.parse(stored)
      return parsed.access_token || parsed.currentSession?.access_token || SUPABASE_ANON_KEY
    }
  } catch { /* ignore */ }
  return SUPABASE_ANON_KEY
}

/** Check if we have a valid (non-expired) JWT in localStorage */
export function hasValidSession(): { valid: boolean; userId?: string } {
  try {
    const stored = localStorage.getItem(`sb-${PROJECT_REF}-auth-token`)
    if (!stored) return { valid: false }
    const parsed = JSON.parse(stored)
    const token = parsed.access_token || parsed.currentSession?.access_token
    if (!token) return { valid: false }
    // Decode JWT payload
    const payload = JSON.parse(atob(token.split('.')[1]))
    if (payload.exp * 1000 < Date.now()) return { valid: false }
    return { valid: true, userId: payload.sub }
  } catch {
    return { valid: false }
  }
}

/**
 * Refresh the JWT directly via Supabase Auth API (bypasses Supabase JS client).
 * Called when hasValidSession() returns false but a refresh_token exists.
 * Returns true if the token was successfully refreshed.
 */
let _refreshPromise: Promise<boolean> | null = null

export async function refreshSession(): Promise<boolean> {
  // Deduplicate concurrent refresh calls
  if (_refreshPromise) return _refreshPromise
  _refreshPromise = _doRefresh()
  try { return await _refreshPromise } finally { _refreshPromise = null }
}

async function _doRefresh(): Promise<boolean> {
  try {
    const stored = localStorage.getItem(`sb-${PROJECT_REF}-auth-token`)
    if (!stored) return false
    const parsed = JSON.parse(stored)
    const refreshToken = parsed.refresh_token || parsed.currentSession?.refresh_token
    if (!refreshToken) return false

    const controller = new AbortController()
    const timer = setTimeout(() => controller.abort(), 5000)

    try {
      const resp = await fetch(`${SUPABASE_URL}/auth/v1/token?grant_type=refresh_token`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'apikey': SUPABASE_ANON_KEY,
        },
        body: JSON.stringify({ refresh_token: refreshToken }),
        signal: controller.signal,
      })

      if (!resp.ok) return false
      const data = await resp.json()

      if (data.access_token && data.refresh_token) {
        // Update localStorage with fresh tokens (same format Supabase client uses)
        const newSession = {
          ...parsed,
          access_token: data.access_token,
          refresh_token: data.refresh_token,
          expires_at: data.expires_at,
          expires_in: data.expires_in,
          token_type: data.token_type || 'bearer',
          user: data.user || parsed.user,
        }
        localStorage.setItem(`sb-${PROJECT_REF}-auth-token`, JSON.stringify(newSession))
        return true
      }
      return false
    } finally {
      clearTimeout(timer)
    }
  } catch {
    return false
  }
}

/** Cache the user role in localStorage (avoids network call in router guard) */
export function getCachedRole(): string | null {
  try { return localStorage.getItem('phood-user-role') } catch { return null }
}
export function setCachedRole(role: string | null): void {
  try {
    if (role) localStorage.setItem('phood-user-role', role)
    else localStorage.removeItem('phood-user-role')
  } catch { /* ignore */ }
}

// ── REST call ────────────────────────────────────────────────────

export interface RestCallOptions {
  single?: boolean       // Expect single row (Accept: application/vnd.pgrst.object+json)
  maybeSingle?: boolean  // Like single, but returns null instead of throwing on 0 rows
  prefer?: string        // Custom Prefer header (e.g. 'count=exact')
  timeout?: number       // Override default timeout (ms), default 10000
}

/** Direct REST call to Supabase PostgREST with timeout */
// ── Storage helpers ──────────────────────────────────────────────

/** Upload a file to Supabase Storage */
export async function storageUpload(
  bucket: string,
  path: string,
  file: Blob | File,
  options?: { contentType?: string; upsert?: boolean },
): Promise<{ path: string }> {
  const controller = new AbortController()
  const timer = setTimeout(() => controller.abort(), 30000)

  try {
    const headers: Record<string, string> = {
      'apikey': SUPABASE_ANON_KEY,
      'Authorization': `Bearer ${getAccessToken()}`,
    }
    if (options?.contentType) headers['Content-Type'] = options.contentType
    if (options?.upsert) headers['x-upsert'] = 'true'

    const resp = await fetch(`${SUPABASE_URL}/storage/v1/object/${bucket}/${path}`, {
      method: 'POST',
      headers,
      body: file,
      signal: controller.signal,
    })

    if (!resp.ok) {
      const text = await resp.text().catch(() => '')
      throw new Error(`Storage upload error ${resp.status}: ${text.slice(0, 300)}`)
    }

    return { path }
  } catch (e: unknown) {
    if ((e as Error).name === 'AbortError') {
      throw new Error('Timeout upload : le serveur ne répond pas.')
    }
    throw e
  } finally {
    clearTimeout(timer)
  }
}

/** Get public URL for a file in Supabase Storage */
export function storagePublicUrl(bucket: string, path: string): string {
  return `${SUPABASE_URL}/storage/v1/object/public/${bucket}/${path}`
}

// ── REST call ────────────────────────────────────────────────────

/** Direct REST call to Supabase PostgREST with timeout */
export async function restCall<T = unknown>(
  method: 'GET' | 'POST' | 'PATCH' | 'DELETE' | 'HEAD',
  path: string,
  body?: unknown,
  options?: RestCallOptions,
): Promise<T> {
  const controller = new AbortController()
  const ms = options?.timeout || 10000
  const timer = setTimeout(() => controller.abort(), ms)

  try {
    const headers: Record<string, string> = {
      'apikey': SUPABASE_ANON_KEY,
      'Authorization': `Bearer ${getAccessToken()}`,
    }

    // Build Prefer header
    const prefers: string[] = []
    if (body && !options?.prefer) prefers.push('return=representation')
    if (options?.prefer) prefers.push(options.prefer)
    if (prefers.length) headers['Prefer'] = prefers.join(', ')

    if (body) headers['Content-Type'] = 'application/json'

    if (options?.single || options?.maybeSingle) {
      headers['Accept'] = 'application/vnd.pgrst.object+json'
    }

    const resp = await fetch(`${SUPABASE_URL}/rest/v1/${path}`, {
      method,
      headers,
      body: body ? JSON.stringify(body) : undefined,
      signal: controller.signal,
    })

    // HEAD requests: extract count from content-range header
    if (method === 'HEAD') {
      const range = resp.headers.get('content-range') || ''
      const total = range.includes('/') ? parseInt(range.split('/').pop() || '0') : 0
      return total as T
    }

    if (!resp.ok) {
      // maybeSingle: 406 = 0 or 2+ rows → return null
      if (options?.maybeSingle && resp.status === 406) return null as T

      // 401 = JWT expired → try refresh and retry once
      if (resp.status === 401) {
        const refreshed = await refreshSession()
        if (refreshed) {
          clearTimeout(timer)
          // Retry with new token (recursive call, won't loop because fresh token won't 401)
          return restCall(method, path, body, options)
        }
      }

      const text = await resp.text().catch(() => '')
      throw new Error(`Erreur ${resp.status}: ${text.slice(0, 300)}`)
    }

    const ct = resp.headers.get('content-type') || ''
    if (ct.includes('json')) return await resp.json() as T
    return [] as unknown as T
  } catch (e: unknown) {
    if ((e as Error).name === 'AbortError') {
      throw new Error('Timeout : le serveur ne répond pas. Essayez de rafraîchir la page.')
    }
    throw e
  } finally {
    clearTimeout(timer)
  }
}
