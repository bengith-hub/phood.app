import { createRouter, createWebHistory } from 'vue-router'
import { hasValidSession, refreshSession, getCachedRole, restCall, setCachedRole } from '@/lib/rest-client'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/login',
      name: 'login',
      component: () => import('@/modules/auth/LoginPage.vue'),
      meta: { public: true },
    },
    {
      path: '/reset-password',
      name: 'reset-password',
      component: () => import('@/modules/auth/ResetPasswordPage.vue'),
      meta: { public: true },
    },
    {
      path: '/',
      component: () => import('@/layouts/AppLayout.vue'),
      children: [
        {
          path: '',
          name: 'dashboard',
          component: () => import('@/modules/dashboard/DashboardPage.vue'),
        },
        // Commandes
        {
          path: 'commandes',
          name: 'commandes',
          component: () => import('@/modules/commandes/CommandesPage.vue'),
        },
        {
          path: 'commandes/new/:fournisseurId?',
          name: 'commande-new',
          component: () => import('@/modules/commandes/CommandeEditPage.vue'),
        },
        {
          path: 'commandes/:id',
          name: 'commande-detail',
          component: () => import('@/modules/commandes/CommandeEditPage.vue'),
        },
        // Réception
        {
          path: 'reception',
          name: 'reception',
          component: () => import('@/modules/reception/ReceptionPage.vue'),
        },
        // Recettes & Ingrédients
        {
          path: 'recettes',
          name: 'recettes',
          component: () => import('@/modules/recettes/RecettesPage.vue'),
        },
        {
          path: 'recettes/allergenes',
          name: 'allergenes',
          component: () => import('@/modules/recettes/AllergeneSearchPage.vue'),
        },
        {
          path: 'recettes/new',
          name: 'recette-new',
          component: () => import('@/modules/recettes/RecetteDetailPage.vue'),
        },
        {
          path: 'recettes/creation-ia',
          name: 'recette-creation-ia',
          component: () => import('@/modules/recettes/RecetteCreationIAPage.vue'),
        },
        {
          path: 'recettes/rentabilite',
          name: 'rentabilite',
          component: () => import('@/modules/recettes/RentabilitePage.vue'),
          meta: { requiresAdmin: true },
        },
        {
          path: 'recettes/cout-matiere',
          name: 'cout-matiere',
          component: () => import('@/modules/recettes/CoutMatierePage.vue'),
          meta: { requiresAdmin: true },
        },
        {
          path: 'recettes/ingredient/:id',
          name: 'ingredient-detail',
          component: () => import('@/modules/recettes/IngredientDetailPage.vue'),
        },
        {
          path: 'recettes/:id',
          name: 'recette-detail',
          component: () => import('@/modules/recettes/RecetteDetailPage.vue'),
        },
        // Fournisseurs & Mercuriale
        {
          path: 'fournisseurs',
          name: 'fournisseurs',
          component: () => import('@/modules/commandes/FournisseursPage.vue'),
          meta: { requiresAdmin: true },
        },
        {
          path: 'mercuriale',
          name: 'mercuriale',
          component: () => import('@/modules/commandes/MercurialePage.vue'),
        },
        {
          path: 'mercuriale/:fournisseurId',
          name: 'mercuriale-fournisseur',
          component: () => import('@/modules/commandes/MercurialePage.vue'),
        },
        // Stocks
        {
          path: 'stocks',
          name: 'stocks',
          component: () => import('@/modules/dashboard/StocksPage.vue'),
        },
        // Inventaire
        {
          path: 'inventaire',
          name: 'inventaire',
          component: () => import('@/modules/inventaire/InventairePage.vue'),
          meta: { requiresAdmin: true },
        },
        // Prévisions
        {
          path: 'previsions',
          name: 'previsions',
          component: () => import('@/modules/previsions/PrevisionsPage.vue'),
          meta: { requiresAdmin: true },
        },
        // Factures
        {
          path: 'factures',
          name: 'factures',
          component: () => import('@/modules/factures/FacturesPage.vue'),
          meta: { requiresAdmin: true },
        },
        // Reporting
        {
          path: 'reporting',
          name: 'reporting',
          component: () => import('@/modules/reporting/ReportingPage.vue'),
          meta: { requiresAdmin: true },
        },
        // Paramètres
        {
          path: 'parametres',
          name: 'parametres',
          component: () => import('@/modules/parametres/ParametresPage.vue'),
          meta: { requiresAdmin: true },
        },
      ],
    },
  ],
})

/**
 * Auth guard — uses localStorage JWT check (instant, no network call).
 * NEVER calls supabase.auth.getSession() which can hang indefinitely.
 */
router.beforeEach(async (to) => {
  if (to.meta.public) return true

  let session = hasValidSession()

  // If JWT expired, try to refresh it directly (bypasses Supabase client)
  if (!session.valid) {
    const refreshed = await refreshSession()
    if (refreshed) {
      session = hasValidSession()
    }
  }

  if (!session.valid) return { name: 'login' }

  // Role-based guard (admin-only pages)
  if (to.meta.requiresAdmin && session.userId) {
    // Check cached role first (instant, no network)
    let role = getCachedRole()

    // If no cached role, fetch via REST with 5s timeout
    if (!role) {
      try {
        const profile = await restCall<{ role: string } | null>(
          'GET',
          `profiles?id=eq.${session.userId}&select=role`,
          undefined,
          { maybeSingle: true, timeout: 5000 },
        )
        role = profile?.role || null
        if (role) setCachedRole(role)
      } catch {
        // On error, allow navigation rather than blocking
        return true
      }
    }

    if (role !== 'admin') return { name: 'dashboard' }
  }

  return true
})

// Auto-reload on chunk load failure (happens after new deploy with different hashes)
router.onError((error, to) => {
  if (error.message?.includes('dynamically imported module') || error.message?.includes('Failed to fetch')) {
    console.warn('Chunk load failed, reloading...', error.message)
    window.location.assign(to.fullPath)
  }
})

export default router
