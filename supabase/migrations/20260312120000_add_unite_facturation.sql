-- Add unite_facturation column to mercuriale
-- Stores the unit in which the supplier invoices (e.g. 'kg' for €/kg)
ALTER TABLE mercuriale ADD COLUMN IF NOT EXISTS unite_facturation TEXT;
