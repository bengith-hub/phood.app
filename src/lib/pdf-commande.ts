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
  slogan: 'Manger Viet & Bien',
  adresse: 'Galerie CC Rives d\'Arcins',
  codePostal: '33130',
  ville: 'Bègles',
  telephone: '07 60 49 43 11',
  email: 'team.begles@phood-restaurant.fr',
}

const PHOOD_ORANGE: [number, number, number] = [232, 93, 44]
const PHOOD_DARK: [number, number, number] = [27, 32, 68]

// Embed logo as base64 data URL at build time — avoids async fetch issues
let logoBase64Cache: string | null = null

async function loadLogo(): Promise<string | null> {
  if (logoBase64Cache !== null) return logoBase64Cache
  try {
    const response = await fetch('/assets/logos/phood-logo.png')
    if (!response.ok) throw new Error('Logo fetch failed')
    const blob = await response.blob()
    return new Promise((resolve) => {
      const reader = new FileReader()
      reader.onloadend = () => {
        logoBase64Cache = reader.result as string
        resolve(logoBase64Cache)
      }
      reader.onerror = () => resolve(null)
      reader.readAsDataURL(blob)
    })
  } catch {
    return null
  }
}

// Preload logo on module import so it's ready when needed
loadLogo()

export async function generateCommandePdf(data: PdfData): Promise<jsPDF> {
  const { commande, lignes, fournisseur, getMercuriale } = data
  const doc = new jsPDF()
  const pageWidth = doc.internal.pageSize.getWidth()
  const pageHeight = doc.internal.pageSize.getHeight()
  const margin = 15
  const contentWidth = pageWidth - margin * 2

  // Ensure logo is loaded
  const logo = logoBase64Cache || await loadLogo()

  let y = 15

  // ═══════════════════════════════════════════════════════
  // HEADER: Logo (left) + "Bon de commande" title (right)
  // ═══════════════════════════════════════════════════════
  const logoH = 18
  const logoW = logo ? 32 : 0

  if (logo) {
    try {
      doc.addImage(logo, 'PNG', margin, y - 2, logoW, logoH)
    } catch {
      // Fallback: text logo
      doc.setFontSize(22)
      doc.setFont('helvetica', 'bold')
      doc.setTextColor(...PHOOD_ORANGE)
      doc.text('Phood', margin, y + 10)
    }
  } else {
    // Fallback: text logo
    doc.setFontSize(22)
    doc.setFont('helvetica', 'bold')
    doc.setTextColor(...PHOOD_ORANGE)
    doc.text('Phood', margin, y + 10)
  }

  // Right side: Title + Order number
  doc.setFontSize(16)
  doc.setFont('helvetica', 'bold')
  doc.setTextColor(...PHOOD_DARK)
  doc.text('Bon de commande', pageWidth - margin, y + 5, { align: 'right' })

  doc.setFontSize(11)
  doc.setFont('helvetica', 'normal')
  doc.setTextColor(80)
  doc.text(commande.numero, pageWidth - margin, y + 12, { align: 'right' })

  y += Math.max(logoH, 16) + 6

  // ═══════════════════════════════════════════════════════
  // INFO BOXES: Fournisseur (left) | Établissement (right)
  // ═══════════════════════════════════════════════════════
  const gap = 6
  const boxWidth = (contentWidth - gap) / 2
  const boxLeft = margin
  const boxRight = margin + boxWidth + gap
  const boxTop = y

  // Calculate dynamic height based on content
  const fournisseurLines: string[] = []
  if (fournisseur.telephone) fournisseurLines.push(`Téléphone : ${fournisseur.telephone}`)
  if (fournisseur.email_commande) fournisseurLines.push(`Email : ${fournisseur.email_commande}`)
  if (fournisseur.email_commande_bcc) fournisseurLines.push(`Email : ${fournisseur.email_commande_bcc}`)
  if (fournisseur.contact_nom) fournisseurLines.push(`Contact : ${fournisseur.contact_nom}`)

  const boxH = Math.max(32, 18 + fournisseurLines.length * 5)

  // Fournisseur box (left)
  doc.setFillColor(248, 248, 248)
  doc.roundedRect(boxLeft, boxTop, boxWidth, boxH, 2, 2, 'F')
  doc.setDrawColor(200, 200, 200)
  doc.setLineWidth(0.3)
  doc.roundedRect(boxLeft, boxTop, boxWidth, boxH, 2, 2, 'S')

  doc.setFontSize(8)
  doc.setFont('helvetica', 'bold')
  doc.setTextColor(...PHOOD_ORANGE)
  doc.text('FOURNISSEUR', boxLeft + 5, boxTop + 6)

  doc.setFontSize(11)
  doc.setFont('helvetica', 'bold')
  doc.setTextColor(...PHOOD_DARK)
  doc.text(fournisseur.nom, boxLeft + 5, boxTop + 13)

  doc.setFontSize(8)
  doc.setFont('helvetica', 'normal')
  doc.setTextColor(60)
  let lineY = boxTop + 19
  for (const line of fournisseurLines) {
    doc.text(line, boxLeft + 5, lineY)
    lineY += 5
  }

  // Établissement box (right)
  doc.setFillColor(248, 248, 248)
  doc.roundedRect(boxRight, boxTop, boxWidth, boxH, 2, 2, 'F')
  doc.setDrawColor(200, 200, 200)
  doc.setLineWidth(0.3)
  doc.roundedRect(boxRight, boxTop, boxWidth, boxH, 2, 2, 'S')

  doc.setFontSize(8)
  doc.setFont('helvetica', 'bold')
  doc.setTextColor(...PHOOD_ORANGE)
  doc.text('ÉTABLISSEMENT : BÈGLES', boxRight + 5, boxTop + 6)

  doc.setFontSize(11)
  doc.setFont('helvetica', 'bold')
  doc.setTextColor(...PHOOD_DARK)
  doc.text(RESTAURANT.nom, boxRight + 5, boxTop + 13)

  doc.setFontSize(8)
  doc.setFont('helvetica', 'normal')
  doc.setTextColor(60)
  doc.text(`${RESTAURANT.adresse}, ${RESTAURANT.codePostal} ${RESTAURANT.ville}`, boxRight + 5, boxTop + 19)
  doc.text(`${RESTAURANT.codePostal} ${RESTAURANT.ville}, FR`, boxRight + 5, boxTop + 24)
  doc.text(`Téléphone : ${RESTAURANT.telephone}`, boxRight + 5, boxTop + 29)

  // Dates inside the right box
  doc.setFontSize(8)
  doc.setFont('helvetica', 'bold')
  doc.setTextColor(...PHOOD_ORANGE)
  if (commande.date_commande) {
    doc.text(`Date de commande (jj/mm/aaaa) : ${formatDateDDMMYYYY(commande.date_commande)}`, boxRight + 5, boxTop + boxH - 7)
  }
  if (commande.date_livraison_prevue) {
    doc.text(`Date de livraison (jj/mm/aaaa) : ${formatDateDDMMYYYY(commande.date_livraison_prevue)}`, boxRight + 5, boxTop + boxH - 2)
  }

  y = boxTop + boxH + 8

  // ═══════════════════════════════════════════════════════
  // COMMENTAIRE (optional)
  // ═══════════════════════════════════════════════════════
  // Always show the section header (empty = ready for handwritten notes)
  doc.setFillColor(245, 245, 245)
  doc.roundedRect(margin, y, contentWidth, 7, 1, 1, 'F')
  doc.setFontSize(9)
  doc.setFont('helvetica', 'bold')
  doc.setTextColor(0)
  doc.text('Commentaire :', margin + 4, y + 5)
  y += 9

  if (commande.notes) {
    doc.setFontSize(8.5)
    doc.setFont('helvetica', 'normal')
    doc.setTextColor(60)
    const noteLines = doc.splitTextToSize(commande.notes, contentWidth - 10)
    doc.text(noteLines, margin + 4, y + 4)
    y += noteLines.length * 4 + 6
  } else {
    y += 8 // Empty space for handwritten notes
  }

  // ═══════════════════════════════════════════════════════
  // PRODUCTS TABLE
  // ═══════════════════════════════════════════════════════
  const tableData = lignes.map(l => {
    const merc = getMercuriale(l.mercuriale_id)
    const condLabel = getCondLabel(merc, l.conditionnement_idx)
    return [
      merc?.ref_fournisseur || '',
      merc?.designation || '—',
      condLabel,
      String(l.quantite),
      formatPrice(l.prix_unitaire_ht),
      formatPrice(l.montant_ht),
    ]
  })

  autoTable(doc, {
    startY: y,
    head: [['Réf.', 'Désignation', 'Conditionnement', 'Qté', 'PU HT', 'Total HT']],
    body: tableData,
    styles: {
      fontSize: 8.5,
      cellPadding: 3.5,
      lineColor: [220, 220, 220],
      lineWidth: 0.2,
      textColor: [30, 30, 30],
    },
    headStyles: {
      fillColor: PHOOD_ORANGE,
      textColor: 255,
      fontStyle: 'bold',
      fontSize: 8.5,
    },
    alternateRowStyles: {
      fillColor: [252, 250, 248],
    },
    columnStyles: {
      0: { cellWidth: 22 },                          // Réf.
      1: { cellWidth: 'auto' },                       // Désignation
      2: { cellWidth: 38 },                           // Conditionnement
      3: { halign: 'center', cellWidth: 16 },         // Qté
      4: { halign: 'right', cellWidth: 24 },          // PU HT
      5: { halign: 'right', cellWidth: 24 },          // Total HT
    },
    margin: { left: margin, right: margin },
  })

  const finalY = (doc as unknown as { lastAutoTable: { finalY: number } }).lastAutoTable?.finalY || 200

  // ═══════════════════════════════════════════════════════
  // SUMMARY ROW: articles count, colis
  // ═══════════════════════════════════════════════════════
  const totalLignes = lignes.length
  const totalQte = lignes.reduce((sum, l) => sum + l.quantite, 0)

  doc.setFillColor(240, 240, 240)
  doc.rect(margin, finalY, contentWidth, 8, 'F')
  doc.setDrawColor(200, 200, 200)
  doc.setLineWidth(0.2)
  doc.rect(margin, finalY, contentWidth, 8, 'S')

  doc.setFontSize(8)
  doc.setFont('helvetica', 'bold')
  doc.setTextColor(60)
  doc.text(`Lignes : ${totalLignes}    Colis : ${totalQte}`, margin + 4, finalY + 5.5)

  // Total on right side of summary row
  doc.setFont('helvetica', 'bold')
  doc.setTextColor(0)
  doc.text(formatPrice(commande.montant_total_ht), pageWidth - margin - 4, finalY + 5.5, { align: 'right' })

  // ═══════════════════════════════════════════════════════
  // TOTAL HT (bottom section, like Inpulse)
  // ═══════════════════════════════════════════════════════
  const totY = finalY + 14

  doc.setFillColor(245, 245, 245)
  doc.roundedRect(margin, totY, contentWidth, 10, 1, 1, 'F')
  doc.setDrawColor(200, 200, 200)
  doc.setLineWidth(0.2)
  doc.roundedRect(margin, totY, contentWidth, 10, 1, 1, 'S')

  doc.setFontSize(10)
  doc.setFont('helvetica', 'bold')
  doc.setTextColor(...PHOOD_DARK)
  doc.text('Total HT', margin + 4, totY + 7)

  doc.setFontSize(8)
  doc.setFont('helvetica', 'normal')
  doc.setTextColor(60)
  doc.text(`Lignes : ${totalLignes}    Colis : ${totalQte}`, margin + 40, totY + 7)

  doc.setFontSize(10)
  doc.setFont('helvetica', 'bold')
  doc.setTextColor(...PHOOD_DARK)
  doc.text(`${formatPrice(commande.montant_total_ht)}`, pageWidth - margin - 4, totY + 7, { align: 'right' })

  // ═══════════════════════════════════════════════════════
  // FOOTER
  // ═══════════════════════════════════════════════════════
  doc.setDrawColor(200, 200, 200)
  doc.setLineWidth(0.3)
  doc.line(margin, pageHeight - 16, pageWidth - margin, pageHeight - 16)

  doc.setFontSize(7)
  doc.setFont('helvetica', 'normal')
  doc.setTextColor(150)
  doc.text('Généré par PhoodApp', margin, pageHeight - 10)
  doc.text(
    `${RESTAURANT.nom} — ${RESTAURANT.adresse}, ${RESTAURANT.codePostal} ${RESTAURANT.ville}`,
    pageWidth / 2,
    pageHeight - 10,
    { align: 'center' }
  )

  // Page number: 1/N
  const totalPages = (doc as unknown as { internal: { getNumberOfPages: () => number } }).internal.getNumberOfPages()
  doc.text(`Page 1 / ${totalPages}`, pageWidth - margin, pageHeight - 10, { align: 'right' })

  return doc
}

function formatDateDDMMYYYY(date: string): string {
  const d = new Date(date)
  const dd = String(d.getDate()).padStart(2, '0')
  const mm = String(d.getMonth() + 1).padStart(2, '0')
  const yyyy = d.getFullYear()
  return `${dd}/${mm}/${yyyy}`
}

function formatPrice(value: number): string {
  return value.toFixed(2)
}

function getCondLabel(merc: Mercuriale | undefined, idx: number): string {
  if (!merc) return ''
  const conds = merc.conditionnements as Conditionnement[]
  if (!conds || conds.length === 0) return merc.unite_stock
  const cond = conds[idx] ?? conds[0]
  return cond?.nom ?? merc.unite_stock
}
