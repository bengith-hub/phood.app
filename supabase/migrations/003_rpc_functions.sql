-- RPC function: increment stock for an ingredient
CREATE OR REPLACE FUNCTION increment_stock(p_ingredient_id UUID, p_quantite NUMERIC)
RETURNS void AS $$
BEGIN
  INSERT INTO stocks (ingredient_id, quantite, derniere_maj, source_maj)
  VALUES (p_ingredient_id, p_quantite, now(), 'reception')
  ON CONFLICT (ingredient_id)
  DO UPDATE SET
    quantite = stocks.quantite + p_quantite,
    derniere_maj = now(),
    source_maj = 'reception';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- RPC function: decrement stock (for sales/vente)
CREATE OR REPLACE FUNCTION decrement_stock(p_ingredient_id UUID, p_quantite NUMERIC)
RETURNS void AS $$
BEGIN
  UPDATE stocks
  SET quantite = GREATEST(0, quantite - p_quantite),
      derniere_maj = now(),
      source_maj = 'vente'
  WHERE ingredient_id = p_ingredient_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- RPC function: recalibrate stock after inventory
CREATE OR REPLACE FUNCTION recalibrate_stock(p_ingredient_id UUID, p_quantite_reelle NUMERIC)
RETURNS void AS $$
BEGIN
  INSERT INTO stocks (ingredient_id, quantite, derniere_maj, source_maj)
  VALUES (p_ingredient_id, p_quantite_reelle, now(), 'inventaire')
  ON CONFLICT (ingredient_id)
  DO UPDATE SET
    quantite = p_quantite_reelle,
    derniere_maj = now(),
    source_maj = 'inventaire';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
