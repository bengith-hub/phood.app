import jsPDF from 'jspdf'
import autoTable from 'jspdf-autotable'
import type { Commande, CommandeLigne, Fournisseur, Mercuriale, Conditionnement } from '@/types/database'

interface PdfData {
  commande: Commande
  lignes: CommandeLigne[]
  fournisseur: Fournisseur
  getMercuriale: (id: string) => Mercuriale | undefined
}

export function generateCommandePdf(data: PdfData): jsPDF {
  const { commande, lignes, fournisseur, getMercuriale } = data
  const doc = new jsPDF()

  // Header
  doc.setFontSize(24)
  doc.setTextColor(232, 93, 44) // Phood orange
  doc.text('Phood', 20, 25)

  doc.setFontSize(10)
  doc.setTextColor(100)
  doc.text('Phood Restaurant — Bègles Centre Commercial', 20, 32)

  // Order number box
  doc.setFontSize(14)
  doc.setTextColor(0)
  doc.text(`Bon de commande : ${commande.numero}`, 120, 25)

  doc.setFontSize(10)
  doc.setTextColor(100)
  if (commande.date_commande) {
    doc.text(`Date : ${formatDate(commande.date_commande)}`, 120, 32)
  }
  if (commande.date_livraison_prevue) {
    doc.text(`Livraison souhaitée : ${formatDate(commande.date_livraison_prevue)}`, 120, 38)
  }

  // Supplier info
  doc.setFontSize(12)
  doc.setTextColor(0)
  doc.text('Fournisseur :', 20, 50)
  doc.setFontSize(11)
  doc.text(fournisseur.nom, 20, 57)
  if (fournisseur.contact_nom) {
    doc.text(`À l'attention de : ${fournisseur.contact_nom}`, 20, 63)
  }

  // Table
  const tableData = lignes.map(l => {
    const merc = getMercuriale(l.mercuriale_id)
    const condLabel = getCondLabel(merc, l.conditionnement_idx)
    return [
      merc?.designation || '—',
      merc?.ref_fournisseur || '',
      condLabel,
      String(l.quantite),
      `${l.prix_unitaire_ht.toFixed(2)} €`,
      `${l.montant_ht.toFixed(2)} €`,
    ]
  })

  autoTable(doc, {
    startY: 72,
    head: [['Désignation', 'Réf.', 'Conditionnement', 'Qté', 'PU HT', 'Total HT']],
    body: tableData,
    styles: { fontSize: 9, cellPadding: 4 },
    headStyles: { fillColor: [232, 93, 44], textColor: 255 },
    columnStyles: {
      0: { cellWidth: 55 },
      3: { halign: 'center' },
      4: { halign: 'right' },
      5: { halign: 'right' },
    },
  })

  // Totals
  const finalY = (doc as unknown as { lastAutoTable: { finalY: number } }).lastAutoTable?.finalY || 200
  doc.setFontSize(11)
  doc.setTextColor(0)
  doc.text(`Total HT : ${commande.montant_total_ht.toFixed(2)} €`, 140, finalY + 10)
  doc.text(`Total TTC : ${commande.montant_total_ttc.toFixed(2)} €`, 140, finalY + 17)

  // Notes
  if (commande.notes) {
    doc.setFontSize(9)
    doc.setTextColor(100)
    doc.text(`Notes : ${commande.notes}`, 20, finalY + 10)
  }

  // Footer
  doc.setFontSize(8)
  doc.setTextColor(150)
  doc.text('Généré par PhoodApp', 20, 285)
  doc.text(`Page 1`, 180, 285)

  return doc
}

function formatDate(date: string): string {
  return new Date(date).toLocaleDateString('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric',
  })
}

function getCondLabel(merc: Mercuriale | undefined, idx: number): string {
  if (!merc) return ''
  const conds = merc.conditionnements as Conditionnement[]
  if (!conds || conds.length === 0) return merc.unite_stock
  const cond = conds[idx] ?? conds[0]
  return cond?.nom ?? merc.unite_stock
}
