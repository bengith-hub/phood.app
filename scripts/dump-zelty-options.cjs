/**
 * Dump ALL Zelty option groups with their values and dish usage count
 */
const KEY = process.env.ZELTY_API_KEY || 'MTY3NDA6uitTmHZ1rDwg5DCBTAZZDms9UDs=';

async function main() {
  const optResp = await fetch('https://api.zelty.fr/2.10/catalog/options?limit=200', {
    headers: { 'Authorization': 'Bearer ' + KEY, 'Accept': 'application/json' }
  });
  const optData = await optResp.json();

  const dishResp = await fetch('https://api.zelty.fr/2.10/catalog/dishes?limit=500&show_all=true', {
    headers: { 'Authorization': 'Bearer ' + KEY, 'Accept': 'application/json' }
  });
  const dishData = await dishResp.json();

  // Count how many dishes use each option
  const optUsage = {};
  for (const d of dishData.dishes) {
    for (const optId of (d.options || [])) {
      if (!optUsage[optId]) optUsage[optId] = 0;
      optUsage[optId]++;
    }
  }

  console.log('ALL Zelty option groups:\n');
  for (const o of (optData.options || [])) {
    const usage = optUsage[o.id] || 0;
    console.log(`Option ${o.id} [${usage} plats] : "${o.name}"`);
    for (const v of (o.values || [])) {
      const priceCents = typeof v.price === 'object' ? (v.price.original_amount_inc_tax || 0) : (v.price || 0);
      console.log(`    ${v.id}: "${v.name}" price=${priceCents} (${priceCents / 100}€)`);
    }
  }
}

main().catch(console.error);
