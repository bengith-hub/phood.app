/**
 * Offline sync queue — stores pending REST mutations in IndexedDB.
 * When the app comes back online, flushes all queued mutations in order.
 *
 * Format: { id, method, path, body, created_at }
 */
import { db } from './dexie'
import { restCall } from './rest-client'

export interface PendingMutation {
  id?: number // auto-incremented
  method: 'POST' | 'PATCH' | 'DELETE'
  path: string
  body: unknown
  created_at: string
}

/**
 * Queue a mutation for later sync. Called when offline.
 */
export async function queueMutation(method: 'POST' | 'PATCH' | 'DELETE', path: string, body?: unknown) {
  await db.pendingMutations.add({
    method,
    path,
    body: body ?? null,
    created_at: new Date().toISOString(),
  })
}

/**
 * Flush all pending mutations (FIFO order).
 * Called when the app comes back online.
 * Returns the count of successfully synced mutations.
 */
export async function flushQueue(): Promise<{ synced: number; failed: number }> {
  const pending = await db.pendingMutations.orderBy('id').toArray()
  if (pending.length === 0) return { synced: 0, failed: 0 }

  let synced = 0
  let failed = 0

  for (const mutation of pending) {
    try {
      await restCall(mutation.method, mutation.path, mutation.body as Record<string, unknown> | undefined)
      // Remove from queue on success
      if (mutation.id) await db.pendingMutations.delete(mutation.id)
      synced++
    } catch (e) {
      console.error('Sync queue: mutation failed, keeping in queue:', mutation.path, e)
      failed++
      // Stop flushing on first failure to preserve order
      break
    }
  }

  return { synced, failed }
}

/**
 * Get the count of pending mutations (for UI badge).
 */
export async function getPendingCount(): Promise<number> {
  return db.pendingMutations.count()
}

/**
 * Initialize online/offline listener for auto-flush.
 * Call once at app startup (e.g. in main.ts or App.vue).
 */
export function initSyncQueue() {
  window.addEventListener('online', async () => {
    console.log('Back online — flushing sync queue...')
    const result = await flushQueue()
    if (result.synced > 0) {
      console.log(`Sync queue: ${result.synced} mutation(s) synced, ${result.failed} failed`)
    }
  })
}
