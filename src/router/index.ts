import { createRouter, createWebHistory } from 'vue-router'
import { supabase } from '@/lib/supabase'

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
      ],
    },
  ],
})

// Auth guard
router.beforeEach(async (to) => {
  if (to.meta.public) return true

  const { data: { session } } = await supabase.auth.getSession()
  if (!session) return { name: 'login' }

  // Role-based guard (admin-only pages)
  if (to.meta.requiresAdmin) {
    const { data: profile } = await supabase
      .from('profiles')
      .select('role')
      .eq('id', session.user.id)
      .single()
    if (profile?.role !== 'admin') return { name: 'dashboard' }
  }

  return true
})

export default router
