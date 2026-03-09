import jsPDF from 'jspdf'
import autoTable from 'jspdf-autotable'
import type { Commande, CommandeLigne, Fournisseur, Mercuriale, Conditionnement } from '@/types/database'

interface PdfData {
  commande: Commande
  lignes: CommandeLigne[]
  fournisseur: Fournisseur
  getMercuriale: (id: string) => Mercuriale | undefined
}

// Restaurant constants
const RESTAURANT = {
  nom: 'Phood Restaurant',
  adresse: 'Galerie CC Rives d\'Arcins, 33130 Bègles',
  ville: '33130 Bègles, FR',
  telephone: '0760494311',
  email: 'team.begles@phood-restaurant.fr',
}

const PHOOD_ORANGE: [number, number, number] = [232, 93, 44]
const PHOOD_DARK: [number, number, number] = [30, 30, 80]

// Load logo as base64 at module level (cached)
let logoBase64: string | null = null
let logoLoaded = false

async function loadLogo(): Promise<string | null> {
  if (logoLoaded) return logoBase64
  try {
    const response = await fetch('/assets/logos/phood-logo-compact.png')
    const blob = await response.blob()
    return new Promise((resolve) => {
      const reader = new FileReader()
      reader.onloadend = () => {
        logoBase64 = reader.result as string
        logoLoaded = true
        resolve(logoBase64)
      }
      reader.onerror = () => {
        logoLoaded = true
        resolve(null)
      }
      reader.readAsDataURL(blob)
    })
  } catch {
    logoLoaded = true
    return null
  }
}

export async function generateCommandePdf(data: PdfData): Promise<jsPDF> {
  const { commande, lignes, fournisseur, getMercuriale } = data
  const doc = new jsPDF()
  const pageWidth = doc.internal.pageSize.getWidth()
  const margin = 15
  const contentWidth = pageWidth - margin * 2

  // Load logo
  const logo = await loadLogo()

  let y = 15

  // ─── Header: Logo + Title ───
  if (logo) {
    doc.addImage(logo, 'PNG', margin, y, 28, 16)
  }

  // Title "Bon de commande" + order number (right-aligned)
  doc.setFontSize(16)
  doc.setFont('helvetica', 'bold')
  doc.setTextColor(...PHOOD_DARK)
  doc.text('Bon de commande', pageWidth - margin, y + 6, { align: 'right' })

  doc.setFontSize(12)
  doc.setFont('helvetica', 'normal')
  doc.text(commande.numero, pageWidth - margin, y + 13, { align: 'right' })

  y += 24

  // ─── Separator line ───
  doc.setDrawColor(...PHOOD_ORANGE)
  doc.setLineWidth(0.8)
  doc.line(margin, y, pageWidth - margin, y)
  y += 8

  // ─── Two-column info boxes ───
  const boxWidth = (contentWidth - 8) / 2
  const boxLeft = margin
  const boxRight = margin + boxWidth + 8
  const boxTop = y

  // Fournisseur box (left)
  doc.setFillColor(248, 248, 248)
  doc.roundedRect(boxLeft, boxTop, boxWidth, 38, 2, 2, 'F')
  doc.setDrawColor(220, 220, 220)
  doc.roundedRect(boxLeft, boxTop, boxWidth, 38, 2, 2, 'S')

  doc.setFontSize(9)
  doc.setFont('helvetica', 'bold')
  doc.setTextColor(100)
  doc.text('Fournisseur', boxLeft + 5, boxTop + 7)

  doc.setFontSize(11)
  doc.setFont('helvetica', 'bold')
  doc.setTextColor(0)
  doc.text(fournisseur.nom, boxLeft + 5, boxTop + 14)

  doc.setFontSize(8.5)
  doc.setFont('helvetica', 'normal')
  doc.setTextColor(60)
  let fy = boxTop + 20
  if (fournisseur.telephone) {
    doc.text(`Tél : ${fournisseur.telephone}`, boxLeft + 5, fy)
    fy += 5
  }
  if (fournisseur.email_commande) {
    doc.text(`Email : ${fournisseur.email_commande}`, boxLeft + 5, fy)
    fy += 5
  }
  if (fournisseur.contact_nom) {
    doc.text(`Contact : ${fournisseur.contact_nom}`, boxLeft + 5, fy)
  }

  // Établissement box (right)
  doc.setFillColor(248, 248, 248)
  doc.roundedRect(boxRight, boxTop, boxWidth, 38, 2, 2, 'F')
  doc.setDrawColor(220, 220, 220)
  doc.roundedRect(boxRight, boxTop, boxWidth, 38, 2, 2, 'S')

  doc.setFontSize(9)
  doc.setFont('helvetica', 'bold')
  doc.setTextColor(100)
  doc.text('Établissement', boxRight + 5, boxTop + 7)

  doc.setFontSize(11)
  doc.setFont('helvetica', 'bold')
  doc.setTextColor(0)
  doc.text(RESTAURANT.nom, boxRight + 5, boxTop + 14)

  doc.setFontSize(8.5)
  doc.setFont('helvetica', 'normal')
  doc.setTextColor(60)
  doc.text(RESTAURANT.adresse, boxRight + 5, boxTop + 20)
  doc.text(RESTAURANT.ville, boxRight + 5, boxTop + 25)
  doc.text(`Tél : ${RESTAURANT.telephone}`, boxRight + 5, boxTop + 30)

  y = boxTop + 44

  // ─── Dates row ───
  doc.setFillColor(255, 248, 245)
  doc.roundedRect(margin, y, contentWidth, 14, 2, 2, 'F')
  doc.setDrawColor(232, 93, 44)
  doc.setLineWidth(0.3)
  doc.roundedRect(margin, y, contentWidth, 14, 2, 2, 'S')

  doc.setFontSize(9)
  doc.setFont('helvetica', 'normal')
  doc.setTextColor(0)

  if (commande.date_commande) {
    doc.setFont('helvetica', 'bold')
    doc.text('Date de commande :', margin + 5, y + 9)
    doc.setFont('helvetica', 'normal')
    doc.text(formatDateShort(commande.date_commande), margin + 48, y + 9)
  }
  if (commande.date_livraison_prevue) {
    doc.setFont('helvetica', 'bold')
    doc.text('Livraison prévue :', pageWidth / 2 + 5, y + 9)
    doc.setFont('helvetica', 'normal')
    doc.text(formatDateShort(commande.date_livraison_prevue), pageWidth / 2 + 43, y + 9)
  }

  y += 20

  // ─── Notes / Commentaire ───
  if (commande.notes) {
    doc.setFontSize(9)
    doc.setFont('helvetica', 'bold')
    doc.setTextColor(0)
    doc.text('Commentaire :', margin, y)
    doc.setFont('helvetica', 'normal')
    doc.setTextColor(60)
    const noteLines = doc.splitTextToSize(commande.notes, contentWidth - 5)
    doc.text(noteLines, margin + 32, y)
    y += noteLines.length * 4 + 4
  }

  // ─── Products table ───
  const tableData = lignes.map(l => {
    const merc = getMercuriale(l.mercuriale_id)
    const condLabel = getCondLabel(merc, l.conditionnement_idx)
    return [
      merc?.designation || '—',
      merc?.ref_fournisseur || '',
      condLabel,
      String(l.quantite),
      formatPrice(l.prix_unitaire_ht),
      formatPrice(l.montant_ht),
    ]
  })

  autoTable(doc, {
    startY: y,
    head: [['Désignation', 'Réf.', 'Conditionnement', 'Qté', 'PU HT', 'Total HT']],
    body: tableData,
    styles: {
      fontSize: 9,
      cellPadding: 4,
      lineColor: [220, 220, 220],
      lineWidth: 0.3,
    },
    headStyles: {
      fillColor: PHOOD_ORANGE,
      textColor: 255,
      fontStyle: 'bold',
      fontSize: 9,
    },
    alternateRowStyles: {
      fillColor: [252, 252, 252],
    },
    columnStyles: {
      0: { cellWidth: 55 },
      1: { cellWidth: 25 },
      3: { halign: 'center', cellWidth: 18 },
      4: { halign: 'right', cellWidth: 25 },
      5: { halign: 'right', cellWidth: 25 },
    },
    margin: { left: margin, right: margin },
  })

  const finalY = (doc as unknown as { lastAutoTable: { finalY: number } }).lastAutoTable?.finalY || 200

  // ─── Summary row ───
  const totalLignes = lignes.length
  const totalQte = lignes.reduce((sum, l) => sum + l.quantite, 0)

  doc.setFillColor(245, 245, 245)
  doc.rect(margin, finalY, contentWidth, 8, 'F')
  doc.setDrawColor(220, 220, 220)
  doc.setLineWidth(0.3)
  doc.rect(margin, finalY, contentWidth, 8, 'S')

  doc.setFontSize(8)
  doc.setFont('helvetica', 'normal')
  doc.setTextColor(80)
  doc.text(`${totalLignes} article${totalLignes > 1 ? 's' : ''}  •  ${totalQte} colis`, margin + 5, finalY + 5.5)

  // ─── Totals box ───
  const totalsY = finalY + 14
  const totalsBoxWidth = 70
  const totalsBoxX = pageWidth - margin - totalsBoxWidth

  doc.setFillColor(255, 248, 245)
  doc.roundedRect(totalsBoxX, totalsY, totalsBoxWidth, 22, 2, 2, 'F')
  doc.setDrawColor(...PHOOD_ORANGE)
  doc.setLineWidth(0.5)
  doc.roundedRect(totalsBoxX, totalsY, totalsBoxWidth, 22, 2, 2, 'S')

  doc.setFontSize(10)
  doc.setFont('helvetica', 'normal')
  doc.setTextColor(0)
  doc.text('Total HT :', totalsBoxX + 5, totalsY + 9)
  doc.setFont('helvetica', 'bold')
  doc.text(formatPrice(commande.montant_total_ht), totalsBoxX + totalsBoxWidth - 5, totalsY + 9, { align: 'right' })

  doc.setFont('helvetica', 'normal')
  doc.setTextColor(80)
  doc.setFontSize(9)
  doc.text('Total TTC :', totalsBoxX + 5, totalsY + 17)
  doc.setFont('helvetica', 'bold')
  doc.setTextColor(0)
  doc.text(formatPrice(commande.montant_total_ttc), totalsBoxX + totalsBoxWidth - 5, totalsY + 17, { align: 'right' })

  // ─── Footer ───
  const pageHeight = doc.internal.pageSize.getHeight()
  doc.setDrawColor(220, 220, 220)
  doc.setLineWidth(0.3)
  doc.line(margin, pageHeight - 18, pageWidth - margin, pageHeight - 18)

  doc.setFontSize(7.5)
  doc.setFont('helvetica', 'normal')
  doc.setTextColor(150)
  doc.text('Généré par PhoodApp', margin, pageHeight - 12)
  doc.text(
    `${RESTAURANT.nom} — ${RESTAURANT.adresse}`,
    pageWidth / 2,
    pageHeight - 12,
    { align: 'center' }
  )
  doc.text(`Page 1`, pageWidth - margin, pageHeight - 12, { align: 'right' })

  return doc
}

function formatDate(date: string): string {
  return new Date(date).toLocaleDateString('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric',
  })
}

function formatDateShort(date: string): string {
  return new Date(date).toLocaleDateString('fr-FR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
  })
}

function formatPrice(value: number): string {
  return value.toFixed(2).replace('.', ',') + ' €'
}

function getCondLabel(merc: Mercuriale | undefined, idx: number): string {
  if (!merc) return ''
  const conds = merc.conditionnements as Conditionnement[]
  if (!conds || conds.length === 0) return merc.unite_stock
  const cond = conds[idx] ?? conds[0]
  return cond?.nom ?? merc.unite_stock
}
