import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { restCall } from '@/lib/rest-client'
import { db } from '@/lib/dexie'
import type { TacheTemplate, TacheInstance, Station, StatutTache } from '@/types/database'

function todayISO() {
  return new Date().toISOString().slice(0, 10)
}

export const useTachesStore = defineStore('taches', () => {
  const templates = ref<TacheTemplate[]>([])
  const instances = ref<TacheInstance[]>([])
  const loading = ref(false)

  // Computed: today's instances sorted (priority first, then by ordre)
  const todayInstances = computed(() =>
    instances.value
      .filter(i => i.date === todayISO())
      .sort((a, b) => {
        if (a.priorite !== b.priorite) return a.priorite ? -1 : 1
        return a.ordre - b.ordre
      })
  )

  function byStation(station: Station) {
    return computed(() => todayInstances.value.filter(i => i.station === station))
  }

  function stats(station: Station) {
    return computed(() => {
      const list = todayInstances.value.filter(i => i.station === station)
      const done = list.filter(i => i.statut === 'fait').length
      return { total: list.length, done }
    })
  }

  // ---- Fetch ----

  async function fetchTodayInstances() {
    loading.value = true
    try {
      if (navigator.onLine) {
        const data = await restCall<TacheInstance[]>(
          'GET',
          `tache_instances?date=eq.${todayISO()}&select=*&order=priorite.desc,ordre.asc`
        )
        instances.value = data
        await db.tacheInstances.clear()
        await db.tacheInstances.bulkPut(data)
      } else {
        instances.value = await db.tacheInstances.where('date').equals(todayISO()).toArray()
      }
    } catch {
      instances.value = await db.tacheInstances.where('date').equals(todayISO()).toArray()
    } finally {
      loading.value = false
    }
  }

  async function fetchTemplates() {
    loading.value = true
    try {
      if (navigator.onLine) {
        const data = await restCall<TacheTemplate[]>(
          'GET',
          'tache_templates?select=*&order=station.asc,ordre.asc'
        )
        templates.value = data
        await db.tacheTemplates.clear()
        await db.tacheTemplates.bulkPut(data)
      } else {
        templates.value = await db.tacheTemplates.toArray()
      }
    } catch {
      templates.value = await db.tacheTemplates.toArray()
    } finally {
      loading.value = false
    }
  }

  // ---- Validation (kiosk) ----

  async function validateTask(
    instanceId: string,
    statut: StatutTache,
    photoPreuveUrl?: string,
    raisonNonFait?: string,
    userId?: string
  ) {
    const now = new Date().toISOString()
    const body: Record<string, unknown> = {
      statut,
      valide_at: statut === 'en_attente' ? null : now,
      valide_par: statut === 'en_attente' ? null : userId,
      photo_preuve_url: photoPreuveUrl || null,
      raison_non_fait: raisonNonFait || null,
      updated_at: now,
    }

    await restCall('PATCH', `tache_instances?id=eq.${instanceId}`, body)

    // Optimistic update
    const instance = instances.value.find(i => i.id === instanceId)
    if (instance) {
      Object.assign(instance, body)
    }
  }

  // ---- Admin CRUD (templates) ----

  async function createTemplate(template: Partial<TacheTemplate>) {
    const data = await restCall<TacheTemplate[]>(
      'POST',
      'tache_templates',
      template,
      { prefer: 'return=representation' }
    )
    if (data?.[0]) {
      templates.value.push(data[0])
    }
    return data?.[0]
  }

  async function updateTemplate(id: string, changes: Partial<TacheTemplate>) {
    await restCall('PATCH', `tache_templates?id=eq.${id}`, {
      ...changes,
      updated_at: new Date().toISOString(),
    })
    const t = templates.value.find(t => t.id === id)
    if (t) Object.assign(t, changes)
  }

  async function deleteTemplate(id: string) {
    await restCall('DELETE', `tache_templates?id=eq.${id}`)
    templates.value = templates.value.filter(t => t.id !== id)
  }

  // ---- Push priority task (admin, creates template + today's instance) ----

  async function pushPriorityTask(
    nom: string,
    description: string | null,
    station: Station,
    photoReferenceUrl: string | null,
    userId: string,
    expiration?: string
  ) {
    // Create template
    const template = await createTemplate({
      nom,
      description,
      station,
      jours_semaine: [],
      photo_reference_url: photoReferenceUrl,
      priorite: true,
      expiration: expiration || null,
      ordre: 0,
      actif: true,
      created_by: userId,
    })

    if (!template) return null

    // Create today's instance
    const instanceData = await restCall<TacheInstance[]>(
      'POST',
      'tache_instances',
      {
        template_id: template.id,
        date: todayISO(),
        nom,
        description,
        station,
        photo_reference_url: photoReferenceUrl,
        priorite: true,
        statut: 'en_attente',
        ordre: 0,
      },
      { prefer: 'return=representation' }
    )

    if (instanceData?.[0]) {
      instances.value.push(instanceData[0])
    }

    return instanceData?.[0]
  }

  // ---- Realtime handler (called by useTaskRealtime composable) ----

  function handleRealtimeEvent(eventType: string, newRecord: TacheInstance | null, oldRecord: { id: string } | null) {
    if (eventType === 'INSERT' && newRecord) {
      // Avoid duplicates (optimistic update may already have it)
      if (!instances.value.find(i => i.id === newRecord.id)) {
        instances.value.push(newRecord)
      }
    } else if (eventType === 'UPDATE' && newRecord) {
      const idx = instances.value.findIndex(i => i.id === newRecord.id)
      if (idx !== -1) {
        instances.value[idx] = newRecord
      } else {
        instances.value.push(newRecord)
      }
    } else if (eventType === 'DELETE' && oldRecord) {
      instances.value = instances.value.filter(i => i.id !== oldRecord.id)
    }
  }

  return {
    templates,
    instances,
    loading,
    todayInstances,
    byStation,
    stats,
    fetchTodayInstances,
    fetchTemplates,
    validateTask,
    createTemplate,
    updateTemplate,
    deleteTemplate,
    pushPriorityTask,
    handleRealtimeEvent,
  }
})
