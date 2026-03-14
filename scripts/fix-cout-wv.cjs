#!/usr/bin/env node
const fs = require('fs');
const env = fs.readFileSync(__dirname + '/../.env', 'utf8');
const url = env.match(/VITE_SUPABASE_URL=(.+)/)[1].trim();
const skey = (env.match(/SUPABASE_SERVICE_ROLE_KEY=(.+)/) || [])[1]?.trim();

const fixes = [
  { nom: 'Coriandre', cout_unitaire: 0.00129 },
  { nom: 'Menthe', cout_unitaire: 0.00099 },
  { nom: 'Poudre soupe pho', cout_unitaire: 0.00708 },
  { nom: 'Sauce Sweet chili vrac', cout_unitaire: 0.000625 },
  { nom: 'Limonade', cout_unitaire: 0.000281 },
];

async function main() {
  for (const fix of fixes) {
    const r = await fetch(url + '/rest/v1/ingredients_restaurant?nom=eq.' + encodeURIComponent(fix.nom), {
      method: 'PATCH',
      headers: {
        apikey: skey,
        Authorization: 'Bearer ' + skey,
        'Content-Type': 'application/json',
        Prefer: 'return=representation'
      },
      body: JSON.stringify({
        cout_unitaire: fix.cout_unitaire,
        cout_source: 'mercuriale',
        cout_maj_date: new Date().toISOString().split('T')[0]
      })
    });
    const d = await r.json();
    if (d.length > 0) {
      console.log('OK: ' + fix.nom + ' → ' + fix.cout_unitaire + ' €/' + d[0].unite_stock);
    } else {
      console.log('ERREUR: ' + fix.nom + ' non trouvé');
    }
  }
}
main().catch(console.error);
