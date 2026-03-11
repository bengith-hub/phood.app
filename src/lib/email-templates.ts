import type { Config, EtablissementInfo } from '@/types/database'

/** Extract etablissement info from config with hardcoded fallback defaults */
export function getEtablissement(config: Config | null): EtablissementInfo {
  return {
    nom: config?.etablissement_nom || 'Phood Restaurant',
    slogan: config?.etablissement_slogan || 'Manger Viet & Bien',
    adresse: config?.etablissement_adresse || 'Galerie CC Rives d\'Arcins',
    code_postal: config?.etablissement_code_postal || '33130',
    ville: config?.etablissement_ville || 'Bègles',
    telephone: config?.etablissement_telephone || '07 60 49 43 11',
    email: config?.etablissement_email || 'team.begles@phood-restaurant.fr',
    contact: config?.etablissement_contact || null,
    creneaux_livraison: config?.etablissement_creneaux_livraison || null,
  }
}

/** Standard email footer used in all outgoing emails */
export function emailFooter(etab: EtablissementInfo): string {
  return `
    <hr style="border:none;border-top:1px solid #eee;margin:24px 0;">
    <p style="color:#888;font-size:13px;">
      ${etab.nom} — ${etab.adresse}, ${etab.code_postal} ${etab.ville}<br/>
      ${etab.email}
    </p>
  `
}

/** Build the email subject prefix: "11/03 | Label | RestaurantName | Ville" */
export function emailSubjectPrefix(etab: EtablissementInfo, label: string): string {
  const dateStr = new Date().toLocaleDateString('fr-FR', { day: '2-digit', month: '2-digit' })
  return `${dateStr} | ${label} | ${etab.nom} | ${etab.ville}`
}
