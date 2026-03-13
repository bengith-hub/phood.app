-- ============================================================
-- Module "Tâches Équipier" — Kiosk tablette salle + cuisine
-- Templates (config récurrente) + Instances (quotidiennes générées)
-- ============================================================

-- Tache templates: admin defines recurring tasks
CREATE TABLE tache_templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nom TEXT NOT NULL,
  description TEXT,
  station TEXT NOT NULL CHECK (station IN ('salle', 'cuisine')),
  jours_semaine INTEGER[] NOT NULL DEFAULT '{}',  -- 0=dim, 1=lun...6=sam
  photo_reference_url TEXT,
  priorite BOOLEAN NOT NULL DEFAULT false,
  expiration TIMESTAMPTZ,
  ordre INTEGER NOT NULL DEFAULT 0,
  actif BOOLEAN NOT NULL DEFAULT true,
  created_by UUID NOT NULL REFERENCES profiles(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Tache instances: daily generated from templates
CREATE TABLE tache_instances (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id UUID REFERENCES tache_templates(id) ON DELETE SET NULL,
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  nom TEXT NOT NULL,
  description TEXT,
  station TEXT NOT NULL CHECK (station IN ('salle', 'cuisine')),
  photo_reference_url TEXT,
  priorite BOOLEAN NOT NULL DEFAULT false,
  statut TEXT NOT NULL DEFAULT 'en_attente' CHECK (statut IN ('en_attente', 'fait', 'non_fait')),
  photo_preuve_url TEXT,
  raison_non_fait TEXT,
  valide_par UUID REFERENCES profiles(id),
  valide_at TIMESTAMPTZ,
  ordre INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (template_id, date)
);

-- Indexes
CREATE INDEX idx_tache_instances_date_station ON tache_instances(date, station);
CREATE INDEX idx_tache_instances_template ON tache_instances(template_id);
CREATE INDEX idx_tache_templates_station ON tache_templates(station, actif);

-- ============================================================
-- RLS
-- ============================================================
ALTER TABLE tache_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE tache_instances ENABLE ROW LEVEL SECURITY;

-- Templates: all read, admin writes
CREATE POLICY "All read tache_templates" ON tache_templates FOR SELECT USING (true);
CREATE POLICY "Admin creates tache_templates" ON tache_templates FOR INSERT WITH CHECK (get_my_role() = 'admin');
CREATE POLICY "Admin updates tache_templates" ON tache_templates FOR UPDATE USING (get_my_role() = 'admin');
CREATE POLICY "Admin deletes tache_templates" ON tache_templates FOR DELETE USING (get_my_role() = 'admin');

-- Instances: all read, all can validate (UPDATE), admin creates/deletes
CREATE POLICY "All read tache_instances" ON tache_instances FOR SELECT USING (true);
CREATE POLICY "Admin creates tache_instances" ON tache_instances FOR INSERT WITH CHECK (get_my_role() = 'admin');
CREATE POLICY "All validate tache_instances" ON tache_instances FOR UPDATE USING (true);
CREATE POLICY "Admin deletes tache_instances" ON tache_instances FOR DELETE USING (get_my_role() = 'admin');

-- ============================================================
-- Config: add email recipients for task recap
-- ============================================================
ALTER TABLE config ADD COLUMN IF NOT EXISTS destinataires_email_taches TEXT[] DEFAULT '{}';
ALTER TABLE config ADD COLUMN IF NOT EXISTS plan_salle_url TEXT;
ALTER TABLE config ADD COLUMN IF NOT EXISTS plan_terrasse_url TEXT;

-- ============================================================
-- Enable Realtime replication on tache_instances
-- (also needs to be enabled in Supabase Dashboard > Database > Replication)
-- ============================================================
ALTER PUBLICATION supabase_realtime ADD TABLE tache_instances;
