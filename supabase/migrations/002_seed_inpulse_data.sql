-- Auto-generated migration from inpulse_export_phood_actifs.json
-- Generated: 2026-03-06T12:56:19.067Z
BEGIN;

-- Categories
INSERT INTO categories (nom, type, ordre) VALUES ('Plats', 'recette', 0) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('Préparation', 'recette', 1) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('PLATS', 'recette', 2) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('Boissons', 'recette', 3) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('VG', 'recette', 4) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('Plat du moment', 'recette', 5) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('KUNG PHOOD', 'recette', 6) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('SUPPLEMENT', 'recette', 7) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('Desserts', 'recette', 8) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('BOISSONS', 'recette', 9) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('DESSERTS', 'recette', 10) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('Side', 'recette', 11) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('SPECIAL', 'recette', 12) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('Test', 'recette', 13) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('SANDWICH', 'recette', 14) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('Finger Phood', 'recette', 15) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('Supplément', 'recette', 16) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('Kit boitage', 'recette', 17) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('SAUCE', 'recette', 18) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('Hygiène', 'ingredient', 19) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('Epicerie', 'ingredient', 20) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('Dessert', 'ingredient', 21) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('Emballages', 'ingredient', 22) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('Surgelés', 'ingredient', 23) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('Frais', 'ingredient', 24) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('Uniformes', 'ingredient', 25) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('Ingredients Exclusifs', 'ingredient', 26) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('Vaisselle', 'ingredient', 27) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('Marketing', 'ingredient', 28) ON CONFLICT (nom) DO NOTHING;
INSERT INTO categories (nom, type, ordre) VALUES ('Sauces', 'ingredient', 29) ON CONFLICT (nom) DO NOTHING;

-- Fournisseurs
INSERT INTO fournisseurs (id, nom, contact_nom, email_commande, telephone, adresse, actif)
VALUES ('25131b20-fc38-11ec-a176-d902a1918d35', 'Transgourmet', NULL, NULL, NULL, NULL, false);
INSERT INTO fournisseurs (id, nom, contact_nom, email_commande, telephone, adresse, actif)
VALUES ('4642b3ec-5b43-11eb-a18e-0a5bf521835e', 'AVIGROS', NULL, NULL, NULL, '2 rue du Gers, 94150, Rungis', false);
INSERT INTO fournisseurs (id, nom, contact_nom, email_commande, telephone, adresse, actif)
VALUES ('47e36ba0-c267-11ed-af3b-01e40c7876d2', 'DELIDRINKS', NULL, NULL, NULL, NULL, true);
INSERT INTO fournisseurs (id, nom, contact_nom, email_commande, telephone, adresse, actif)
VALUES ('5c49af70-8ef5-11f0-975b-2726f4fe3aed', 'Khadispal', NULL, NULL, NULL, '11 Rue du Lugan, 33130, Bègles', true);
INSERT INTO fournisseurs (id, nom, contact_nom, email_commande, telephone, adresse, actif)
VALUES ('5ebc88e0-7976-11ee-a1ca-ed4795abb9e6', 'Comodis', NULL, NULL, NULL, NULL, true);
INSERT INTO fournisseurs (id, nom, contact_nom, email_commande, telephone, adresse, actif)
VALUES ('60bb1420-c0a6-11ec-959c-5b5037aeef23', 'Pak Emballages', NULL, NULL, NULL, '19 Rue Charles Tellier , 13014, Marseille', true);
INSERT INTO fournisseurs (id, nom, contact_nom, email_commande, telephone, adresse, actif)
VALUES ('74cd61d0-e276-11ef-90ac-1d5624ff84a8', 'Quatra', NULL, NULL, NULL, NULL, true);
INSERT INTO fournisseurs (id, nom, contact_nom, email_commande, telephone, adresse, actif)
VALUES ('7634b460-f526-11eb-9855-6d337dfcae57', 'Franchise Sirop', NULL, NULL, NULL, '10 rue du 11 novembre, 33130, Bègles', false);
INSERT INTO fournisseurs (id, nom, contact_nom, email_commande, telephone, adresse, actif)
VALUES ('80c6a4f0-6a21-11eb-9a21-0a5bf521835e', 'Mochiri', NULL, NULL, NULL, '43 Chemin vicinale de la millière , 13011, Marseille', true);
INSERT INTO fournisseurs (id, nom, contact_nom, email_commande, telephone, adresse, actif)
VALUES ('8f9ce920-47e9-11ec-939f-314f99801403', 'Franchise Marketing', NULL, NULL, NULL, 'Bordeaux', true);
INSERT INTO fournisseurs (id, nom, contact_nom, email_commande, telephone, adresse, actif)
VALUES ('9a3280e0-2152-11ee-888e-8daad14c2966', 'Sodiscol', NULL, NULL, NULL, NULL, true);
INSERT INTO fournisseurs (id, nom, contact_nom, email_commande, telephone, adresse, actif)
VALUES ('a8700630-2b86-11ee-b43d-fba4734c3f62', 'Transgourmet', NULL, NULL, NULL, NULL, true);
INSERT INTO fournisseurs (id, nom, contact_nom, email_commande, telephone, adresse, actif)
VALUES ('b9ac9040-c00c-11f0-90c5-f561d51de85d', 'Mungoo', NULL, NULL, NULL, '5 B RUE MARION DE JACOB, 33700, MERIGNAC', true);
INSERT INTO fournisseurs (id, nom, contact_nom, email_commande, telephone, adresse, actif)
VALUES ('c7091860-db2f-11eb-a327-712c3f551ffc', 'Franchise cafe', NULL, NULL, NULL, NULL, true);
INSERT INTO fournisseurs (id, nom, contact_nom, email_commande, telephone, adresse, actif)
VALUES ('d4617750-9add-11ec-ba94-f94c6b33e293', 'Franchise Phoodwear', NULL, NULL, NULL, NULL, true);
INSERT INTO fournisseurs (id, nom, contact_nom, email_commande, telephone, adresse, actif)
VALUES ('d69710e0-f469-11eb-8fb0-df4c06cfdb0d', 'Franchise chocolat', NULL, NULL, NULL, '10 rue du 11 novembre, 33130, Bègles', false);
INSERT INTO fournisseurs (id, nom, contact_nom, email_commande, telephone, adresse, actif)
VALUES ('d7a47e10-d8d5-11ef-93ff-85201132e2e3', 'Massi Distribution', NULL, NULL, NULL, '12 ALLEE DARIUS MILHAUD, 42000, SAINT ETIENNE', true);
INSERT INTO fournisseurs (id, nom, contact_nom, email_commande, telephone, adresse, actif)
VALUES ('e1451f2a-9f72-11ea-8f40-0a5bf521835e', 'Franchise Autres', 'FETU', 'commandes@phood.fr', '0760494311', '10 rue du 11 novembre, 33130, Bègles', true);
INSERT INTO fournisseurs (id, nom, contact_nom, email_commande, telephone, adresse, actif)
VALUES ('e14520c4-9f72-11ea-8f42-0a5bf521835e', 'Promocash Bordeaux', 'Mickael', 'stephane_courserand@carrefour.com', '0557358382', 'MIN Brienne, 33130, Bègles', true);
INSERT INTO fournisseurs (id, nom, contact_nom, email_commande, telephone, adresse, actif)
VALUES ('e145239e-9f72-11ea-8f47-0a5bf521835e', 'TT Foods', 'Hergalant', 'chergalant@ttfoods.fr', '0389601793', NULL, true);
INSERT INTO fournisseurs (id, nom, contact_nom, email_commande, telephone, adresse, actif)
VALUES ('ea564a80-8977-11ec-8ce1-c32a63dfe765', 'One Move', NULL, NULL, NULL, '4 rue du Mont Blanc, 69960, Corbas', false);
INSERT INTO fournisseurs (id, nom, contact_nom, email_commande, telephone, adresse, actif)
VALUES ('fc61d960-ecf0-11ec-92c5-b70a8da9dfee', 'Franchise Vaisselle', NULL, NULL, NULL, '10 rue du 11 novembre, 33130, Bègles', true);

-- Ingredients Restaurant
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('076132f0-e3ad-11eb-8237-736a902b6e66', 'Vin blanc', 'L', 'Boissons', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('03c6ec00-d386-11ed-8873-3d005b07a028', 'Savon refresh ', 'L', 'Hygiène', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('04f43df0-7d4e-11ed-9124-af8ed14a816a', 'Sacs poubelle petit', 'unite', 'Hygiène', '{}'::text[], 0.0872, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('001f3140-ef92-11eb-bbe5-ef0537d994fa', 'Perles Passion', 'kg', 'Boissons', '{}'::text[], 6.2609, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('0176d3d0-7d4a-11ed-bef2-3be33b07e51f', 'Carton de café décaféiné', 'unite', 'Epicerie', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('070c0f70-d387-11ed-b5ed-85ce7cabeb42', 'Désodorisant rosé', 'L', 'Hygiène', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('033209b0-09cd-11ed-8e50-07ad3601b8bc', 'Glace chocolat brownie', 'unite', 'Dessert', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('06656f60-b230-11ef-9c6e-779763fa7658', 'Poudre Sésame', 'kg', 'Boissons', ARRAY['gluten', 'sesame']::text[], 10.2392, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('07b0e2e0-ee1c-11eb-8cf4-3f10540222ef', 'Sauce BBQ', 'L', 'Epicerie', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('07c64f70-a8eb-11eb-a511-a582f5c4cbb1', 'Levure chimque', 'kg', 'Epicerie', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('08c02da0-da60-11eb-88cc-6f7cfe428a18', 'Mochi glacé vanille', 'unite', 'Dessert', ARRAY['lait', 'soja']::text[], 0.89, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('097085c0-1f09-11ee-bc5c-5d86ba5dc90c', 'Personnalisé Phood Normal', 'unite', 'Emballages', '{}'::text[], 0.1649, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('08727600-be21-11ec-bc2e-4d33dd81b98a', 'Haché végétal', 'unite', 'Surgelés', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('09c960e0-117e-11f1-ae64-1f8e3f56f901', 'Tenders', 'kg', 'Surgelés', '{}'::text[], 9.5604, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('0dab1460-4e2b-11ee-8d17-29eec0ef8ef1', 'Prep. Cheesecake', 'L', 'Frais', ARRAY['lait']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('0b64ad20-e54a-11eb-b993-552ff2e9d866', 'Poudre thé au lait thai ', 'kg', 'Boissons', ARRAY['lait']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('0b4a7e70-e53a-11ef-ae90-c77ba71d6e00', 'Chicken Wings', 'kg', 'Surgelés', '{}'::text[], 6.9853, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('0d161320-1baf-11ec-9cd0-53f06f053e40', 'Oignons Jaunes', 'kg', 'Frais', '{}'::text[], 0.9455, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('0b9ba290-e1ea-11ee-9824-b524be6ecff3', 'Fromage Blanc', 'kg', 'Dessert', ARRAY['lait']::text[], 3.13, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('0f24c2c0-7d4b-11ed-b263-b95e21b5e348', 'Couvercle pot dessert', 'unite', 'Emballages', '{}'::text[], 0.06, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('11608c10-bdf2-11ef-ba0c-d9e4e2a63cd3', 'Eau robinet', 'kg', NULL, '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('12506e40-e277-11ed-9686-4bbf18f0f5ed', 'Bol Grand + Couvercle perso', 'unite', 'Emballages', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('15854ed0-6bb6-11eb-80f6-73940ffe6b4a', 'Gobelet Thé', 'unite', 'Emballages', '{}'::text[], 0.045, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('1541beb0-21db-11f0-ac69-4ff8f2877233', 'Boulettes boeuf halal', 'unite', 'Surgelés', ARRAY['gluten', 'soja']::text[], 0.3957, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('10212950-5147-11ed-ae1b-9d995079b109', 'Baskets', 'unite', 'Uniformes', '{}'::text[], 45, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('1288ef60-f30a-11ed-ada6-f1c2893b2f15', 'Vinaigre Blanc Ménager', 'L', 'Hygiène', '{}'::text[], 1.0322, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('0e8b62f0-21d2-11f0-840c-7186b075b488', 'Sirop Thé Vert concentré', 'L', 'Boissons', '{}'::text[], 6.3741, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('0fb01600-7d4f-11ed-9124-af8ed14a816a', 'T-shirt', 'unite', 'Uniformes', '{}'::text[], 14.3333, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('17d942f0-c275-11ed-b116-d7b40111f808', 'Perles myrtille', 'kg', 'Epicerie', '{}'::text[], 6.2609, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('1c0a2560-a8eb-11eb-9cae-41439e88333c', 'Ail poudre', 'kg', 'Epicerie', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('19ae6ea0-7d49-11ed-9124-af8ed14a816a', 'Boîte Pho ', 'unite', 'Emballages', '{}'::text[], 0.12, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('18ab8420-a8b6-11eb-9770-c18e5ed172e8', 'Sucre en poudre', 'kg', 'Epicerie', '{}'::text[], 1.6775, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('1a99aa30-d386-11ed-991b-f3f2287d9251', 'Bac mousse bactericide', 'L', 'Hygiène', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('1edcd750-4d86-11ee-b55c-159c4c7fd68f', 'Sorbet Framboise Litchi ', 'unite', 'Dessert', ARRAY['arachides', 'celeri', 'fruits_a_coque', 'gluten', 'lait']::text[], 1.678, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('1ccd9ea0-a8fa-11eb-9cae-41439e88333c', 'Pilon de poulet', 'kg', 'Frais', '{}'::text[], 1.8, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('202590d0-be1b-11ec-9222-db267923b89e', 'Nem légumes', 'unite', 'Surgelés', ARRAY['gluten']::text[], 0.2364, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('21cb1ba0-d38a-11ed-a335-b118b249b5d3', 'Liquide rinçage ', 'L', 'Hygiène', '{}'::text[], 1.804, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('21dd4110-91c0-11ed-b4d4-2171468c5ab0', 'Crème chantilly', 'L', 'Frais', '{}'::text[], 7.442, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('218671b0-1f05-11ed-b87e-25470f2449dc', 'Mochi glacé x1', 'unite', 'Surgelés', ARRAY['soja']::text[], 0.89, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('26d4cc10-d865-11ed-9677-6bd4a1cc96ce', 'Smarties', 'kg', 'Epicerie', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('26662f50-e277-11ed-bd5b-0f903c199e04', 'Bol Normal  + Couvercle perso ', 'unite', 'Emballages', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('2aad0c00-e31e-11eb-8237-736a902b6e66', 'Vin rouge', 'L', 'Boissons', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('2af3efe0-bdfd-11ef-a034-73777b7f79b7', 'Concentré tamarin', 'kg', 'Epicerie', '{}'::text[], 3.31, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('2280bae0-20fa-11f0-ab9e-b3d91cd9f60a', 'Gin & Tonic OUSIA', 'unite', 'Boissons', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('29372760-da73-11f0-ad55-178a15fbfae9', 'Rouleau Jumbo', 'unite', 'Hygiène', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('28362d70-1f09-11ee-8289-e38a95489b1f', 'Personnalisé Phood Grand', 'unite', 'Emballages', '{}'::text[], 0.2557, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('2b68f4e0-5147-11ed-b50c-474f649a5bc5', 'Pulvérisateur', 'unite', 'Hygiène', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('2b877c00-46bf-11ec-939f-314f99801403', 'Carottes entières ', 'kg', 'Frais', '{}'::text[], 1.18, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('26c8acb0-a332-11eb-a60c-5545ff63e985', 'Set 3 Mini tablettes', 'unite', 'Epicerie', ARRAY['fruits_a_coque', 'gluten', 'lait']::text[], 3.8, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('2e3b3e20-4617-11ed-b8df-c363575b0859', 'Sauce Loc Lac', 'kg', 'Ingredients Exclusifs', ARRAY['gluten', 'mollusques', 'soja']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('2cf1bfa0-19f7-11ec-967c-692187d0a72f', 'Coca Zero  slim', 'unite', 'Boissons', '{}'::text[], 0.6053, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('2dbdce80-8805-11eb-b96f-7177973d12e2', 'Sirop de canne', 'L', 'Boissons', '{}'::text[], 5.4396, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('305de0c0-d395-11ed-89d3-cf05f605d483', 'Essui Main Pliage V', 'unite', 'Hygiène', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('32df9ea0-4e20-11ee-89fc-3b4978b6868d', 'Appareil Panna Cotta ', 'L', 'Frais', '{}'::text[], 5.34, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('2f232d10-ec86-11ec-9630-193a22d236be', 'Tomate cerise', 'kg', 'Frais', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('34fbcd00-a33a-11eb-84f4-0b99e046e5f3', 'Ginger Lime Ba Ria 69% Grande', 'unite', 'Epicerie', ARRAY['fruits_a_coque', 'gluten', 'lait']::text[], 3.3, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('32bb7eb0-2d65-11ef-a188-f3703d636499', 'Verrine Chocolat', 'unite', 'Dessert', ARRAY['gluten', 'lait']::text[], 1.2701, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('35deb170-d398-11ed-bf32-3110e1284941', 'Détergent Tous Sol', 'L', 'Hygiène', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('39983170-bba8-11ef-8612-e5fe96a59ed9', 'Galanga', 'kg', 'Ingredients Exclusifs', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('42afc510-7d4e-11ed-b263-b95e21b5e348', 'Sacs poubelle grand', 'unite', 'Hygiène', '{}'::text[], 2.094, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('3d046180-bdf1-11ef-b77b-b5f02a7171be', 'Sauce huïtre', 'kg', 'Epicerie', ARRAY['mollusques', 'sulfites']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('419abe30-4e29-11ee-99c3-efac9f73b6b5', 'Cookies ', 'kg', 'Dessert', '{}'::text[], 7.6629, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('384576e0-e3be-11eb-b4a4-c79ec670c12e', 'Kumquat Tien Giang 68% Grande', 'unite', 'Epicerie', ARRAY['fruits_a_coque', 'gluten', 'lait']::text[], 3.3, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('3ed4bfb0-7d4c-11ed-a047-fb061caa6559', 'Gel WC', 'L', 'Hygiène', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('3c1aade0-4d83-11ee-9848-af14af9a4362', 'Crème Glacée Chocolat de Tanzanie', 'unite', 'Dessert', ARRAY['fruits_a_coque', 'gluten', 'lait']::text[], 1.678, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('3a5a9a90-f5ee-11eb-8f32-750a66e837fd', 'Sirop yuzu / citron', 'L', 'Boissons', '{}'::text[], 8.9116, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('46b9cde0-7d49-11ed-bef2-3be33b07e51f', 'Bonbons', 'kg', 'Epicerie', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('3c859810-3a7b-11ed-9f9b-fb5c16910c99', 'Concentré de tomate', 'kg', 'Epicerie', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('457af520-d394-11ed-9c3f-53b8785e19c0', 'Liquide Lavage Vaisselle', 'L', 'Hygiène', '{}'::text[], 2.504, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('48203b90-a63a-11ee-941d-29757a71a6ae', 'Daïquiri fraise', 'L', 'Boissons', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('48734040-c1a5-11ec-853d-e7960d3897c4', 'Glace mango (orange, mangue)', 'unite', 'Dessert', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('43802dc0-4e2e-11ee-8d17-29eec0ef8ef1', 'Coulis ', 'unite', NULL, '{}'::text[], 7.1226, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('498ec2a0-e54c-11eb-be8e-9f30aafccd7a', 'Frites', 'kg', 'Frais', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('4c217cf0-cf15-11ee-9196-c5c68bf4c631', 'Boulettes de riz thai', 'unite', 'Surgelés', ARRAY['celeri', 'gluten', 'lait', 'moutarde', 'soja']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('4bd60d30-7d48-11ed-a047-fb061caa6559', 'Bol Inox Phood XL', 'unite', 'Vaisselle', '{}'::text[], 11.2, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('4b420b70-1f8e-11ed-b87e-25470f2449dc', 'Mochi glacé vanille & abricot', 'unite', 'Surgelés', ARRAY['lait', 'soja']::text[], 0.89, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('4cdc9920-9eff-11f0-b3c9-33035a5842ae', 'Sundae Vanille Fraise', 'unite', 'Dessert', ARRAY['fruits_a_coque', 'lait']::text[], 0.4814, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('5439a090-7d4d-11ed-9124-af8ed14a816a', 'Manche Alimentaire', 'unite', 'Hygiène', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('550da450-7d4b-11ed-b263-b95e21b5e348', 'Cristaux de soude', 'kg', 'Hygiène', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('4d17d8d0-2d65-11ef-b990-47930060fae2', 'Verrine Banoffee', 'unite', 'Dessert', ARRAY['gluten', 'lait']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('562ac320-f4f5-11eb-9855-6d337dfcae57', 'huile sésame', 'L', 'Epicerie', ARRAY['sesame']::text[], 8.6263, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('53090f20-19f4-11ec-b6d2-6571eca8bd6a', 'Orangina', 'unite', 'Boissons', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('570c0710-f5d4-11eb-8ccc-17901c63413d', 'Napolitains Ben Tre 78', 'unite', 'Epicerie', ARRAY['fruits_a_coque', 'gluten', 'lait']::text[], 4.5, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('59a0b220-7e80-11ec-bafd-fb0d701e3442', 'Donut caramel ', 'unite', 'Dessert', ARRAY['fruits_a_coque', 'gluten', 'lait']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('5409fdc0-be1e-11ec-92b5-d17e9a4e477d', 'Poulet végétal', 'kg', 'Surgelés', ARRAY['soja']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('4fd6e900-d38c-11ed-a335-b118b249b5d3', 'Bobine thermique Imprimante', 'unite', 'Hygiène', '{}'::text[], 1.5, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('57387cf0-b8d5-11f0-8023-f50462a02790', 'Crousty poulet base', 'kg', NULL, ARRAY['gluten']::text[], 9.4102, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('5ccdcfd0-a63a-11ee-90ac-0338ca361de0', 'Gin Basilic Smash', 'L', 'Boissons', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('5ec23a80-f842-11ec-87d3-cf5d212ef325', 'Jus de citron jaune', 'L', 'Boissons', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('60f608e0-d398-11ed-a90f-effe91255ffc', 'Raclette Sol', 'unite', 'Hygiène', '{}'::text[], 11, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('602f4f30-a8f1-11eb-a272-274b1324dbc5', 'Aile poulet', 'kg', 'Frais', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('60698600-a333-11eb-a82e-d37eb9df5ff1', 'Set 6 mini tablettes', 'unite', 'Epicerie', ARRAY['fruits_a_coque', 'gluten', 'lait']::text[], 7.5, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('5bd9afd0-4e2a-11ee-8d17-29eec0ef8ef1', 'Prep. Mousse Chocolat Noir', 'L', 'Dessert', ARRAY['lait', 'soja']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('61767070-7d49-11ed-a047-fb061caa6559', 'Carte boisson', 'unite', 'Marketing', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('5ff10d10-f4f5-11eb-9855-6d337dfcae57', 'sauce soja base', 'kg', 'Sauces', ARRAY['gluten', 'soja']::text[], 0.6605, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('5cf92180-dc2e-11ec-ae34-1dcb862714d3', 'Donut sucre', 'unite', 'Dessert', ARRAY['gluten', 'lait', 'soja']::text[], 0.2529, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('6121a440-7d4a-11ed-b263-b95e21b5e348', 'Cartouche de Gel hydroalcoolique ', 'L', 'Emballages', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('63466fb0-a8f0-11eb-a511-a582f5c4cbb1', 'Maizena', 'kg', 'Epicerie', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('6289ccb0-6bb6-11eb-aac1-2355e6ce6dd2', 'Couvercle Thé', 'unite', 'Emballages', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('61d22480-f840-11ec-a176-d902a1918d35', 'Gomme xanthane', 'kg', 'Epicerie', '{}'::text[], 21.73, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('65efe100-4d86-11ee-a7f1-87190e351617', 'Sorbet Mangue', 'unite', 'Dessert', ARRAY['fruits_a_coque', 'gluten', 'lait']::text[], 1.678, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('6957aad0-f4f5-11eb-a95c-45ac352893ba', 'sauce poisson base', 'L', 'Sauces', ARRAY['poissons']::text[], 2.6322, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('68f22880-e3ad-11eb-8237-736a902b6e66', 'Vin rosé', 'L', 'Boissons', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('67bc3410-72b0-11eb-a732-3588446adb69', 'Cookie framboise ', 'unite', 'Dessert', ARRAY['gluten', 'lait', 'soja']::text[], 0.772, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('67fffe90-7d4c-11ed-bef2-3be33b07e51f', 'Grand pot sauce inox', 'unite', 'Vaisselle', '{}'::text[], 3.8, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('6286a130-fb92-11ec-87d3-cf5d212ef325', 'Glace passion (ananas, fruit de la passion)', 'unite', 'Dessert', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('66ff9a30-00f8-11ed-82ff-e103d8d6432f', 'Sirop fleur de cerisier', 'L', 'Boissons', '{}'::text[], 8.4792, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('6b66cd30-23dc-11ed-8331-7f9fd88301ac', 'Nouille de blé udon', 'kg', 'Epicerie', ARRAY['gluten']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('6bb818c0-d045-11eb-9f02-bf5812513161', 'Mochi glacé framboise', 'unite', 'Dessert', ARRAY['fruits_a_coque', 'lait', 'soja']::text[], 0.89, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('6ea4c720-c1a5-11ec-853d-e7960d3897c4', 'Pot de glace noix de coco', 'unite', 'Dessert', ARRAY['arachides', 'fruits_a_coque', 'gluten', 'lait']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('6c028cc0-fb73-11ec-87d3-cf5d212ef325', 'Sirop grenade', 'L', 'Boissons', '{}'::text[], 8.2458, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('6eaefda0-a63a-11ee-941d-29757a71a6ae', 'Pornstar martini', 'L', 'Boissons', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('6befbf50-6168-11ec-b4f3-f589907dab6b', 'Perles kiwi', 'kg', 'Boissons', '{}'::text[], 6.2609, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('6e078db0-be2c-11ec-92b5-d17e9a4e477d', 'Champignons blancs', 'kg', 'Frais', '{}'::text[], 4.6111, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('6d016550-6fd4-11eb-a4bf-c58d44f967d3', 'Ciboulette', 'kg', 'Frais', '{}'::text[], 24.4682, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('6be24a70-da70-11f0-8612-8be369b626f7', 'Bobine DC', 'unite', 'Hygiène', '{}'::text[], 1.9983, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('6e48f33a-abce-11ea-ad20-0a5bf521835e', 'Canne à sucre', 'kg', 'Ingredients Exclusifs', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('75410240-7d4a-11ed-b263-b95e21b5e348', 'Cartouche de Gaz ', 'unite', 'Emballages', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('70a95120-fb76-11ec-82ff-e103d8d6432f', 'Sirop hibiscus', 'L', 'Boissons', '{}'::text[], 7.5767, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('6fdb4200-fb92-11ec-a176-d902a1918d35', 'Glace punch tropical (rhum, mangue, ananas) ', 'unite', 'Dessert', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('76bb1e20-c158-11ec-9265-d57037e66861', 'Lardons VG', 'kg', 'Frais', ARRAY['soja']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('6ee353a0-fb75-11ec-86ff-13fce83436c9', 'Sirop kumquat', 'L', 'Boissons', '{}'::text[], 6.5933, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('77aa7da0-7d49-11ed-9124-af8ed14a816a', 'Carte de visite', 'unite', 'Marketing', '{}'::text[], 0.0604, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('76aa31a0-2370-11f0-8b17-c9ef36ffc4e8', 'Thé rooibos vanille - KUSMI', 'unite', 'Boissons', '{}'::text[], 0.4268, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('72a76ef0-9eff-11f0-aced-2f0ff397d130', 'Sundae Vanille Caramel', 'unite', 'Dessert', ARRAY['fruits_a_coque', 'lait']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('74a7fbc0-5146-11ed-b50c-474f649a5bc5', 'Badges', 'unite', 'Marketing', '{}'::text[], 2.677, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('6f6abe40-4e2f-11ee-9a37-c1fb9a9e60bd', 'Crevettes décortiquées crues', 'unite', 'Surgelés', '{}'::text[], 7.897, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('7a3903c0-d398-11ed-9c3f-53b8785e19c0', 'Rouleau Vert', 'unite', 'Hygiène', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('7a9b0d70-c1c6-11ec-853d-e7960d3897c4', 'Feuilles de combava séchées', 'kg', 'Epicerie', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('791cdaa0-4d84-11ee-bde1-5fde63a70b93', 'Crème Glacée Miel et Noisettes Caramélisées', 'unite', 'Dessert', ARRAY['arachides', 'celeri', 'fruits_a_coque', 'gluten', 'lait']::text[], 1.678, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('79da2e70-bdef-11ef-be99-f72f1fb7b2f1', 'Curry jaune poudre', 'kg', 'Epicerie', ARRAY['moutarde']::text[], 4.39, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('7dc74cc0-5145-11ed-ae1b-9d995079b109', 'Enveloppes', 'unite', 'Marketing', '{}'::text[], 0.1301, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('7dac17b0-6757-11ee-a127-bd5aba4de5fc', 'Jus KOOKABARRA', 'unite', 'Boissons', '{}'::text[], 1.638, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('7b06f6a0-601f-11ed-ba86-0916fa7dd2eb', 'Coca Cola Canette ', 'unite', 'Boissons', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('7d3cb780-c9ca-11eb-b7f7-8b9a3a648073', 'Sticker Rectangle BBT', 'unite', 'Emballages', '{}'::text[], 0.0541, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('78f6cb20-e3ce-11eb-be8e-9f30aafccd7a', 'Tien Giang 70% grande', 'unite', 'Epicerie', ARRAY['fruits_a_coque', 'gluten', 'lait']::text[], 1.2, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('7f9bfdb0-87b2-11eb-b06e-f714206729cb', 'Coca 25cl', 'unite', 'Boissons', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8088c240-9c4d-11ea-925e-0a5bf521835e', 'Sac Sandwich', 'unite', 'Emballages', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('808921ea-9c4d-11ea-9262-0a5bf521835e', 'Couvercle saladier normal', 'unite', 'Emballages', '{}'::text[], 0.1239, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80891f2e-9c4d-11ea-925f-0a5bf521835e', 'Sachet cookie', 'unite', 'Emballages', '{}'::text[], 0.0128, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80892032-9c4d-11ea-9260-0a5bf521835e', 'Boite Finger Phood', 'unite', 'Emballages', '{}'::text[], 0.104, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089260e-9c4d-11ea-9267-0a5bf521835e', 'Couvercle pot à sauce', 'unite', 'Emballages', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('808922c6-9c4d-11ea-9263-0a5bf521835e', 'Saladier rond grand', 'unite', 'Emballages', '{}'::text[], 0.335, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089246a-9c4d-11ea-9265-0a5bf521835e', 'Barquette nems', 'unite', 'Emballages', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089212c-9c4d-11ea-9261-0a5bf521835e', 'Saladier rond normal', 'unite', 'Emballages', '{}'::text[], 0.2058, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80892532-9c4d-11ea-9266-0a5bf521835e', 'Pot à sauce', 'unite', 'Emballages', '{}'::text[], 0.063, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089238e-9c4d-11ea-9264-0a5bf521835e', 'Couvercle saladier grand', 'unite', 'Emballages', '{}'::text[], 0.1764, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('808928ac-9c4d-11ea-926a-0a5bf521835e', 'Pot à soupe grand', 'unite', 'Emballages', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('808927a8-9c4d-11ea-9269-0a5bf521835e', 'Pot à soupe normal', 'unite', 'Emballages', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089297e-9c4d-11ea-926b-0a5bf521835e', 'Boite perles coco', 'unite', 'Emballages', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('808926cc-9c4d-11ea-9268-0a5bf521835e', 'Pic bois', 'unite', 'Emballages', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80892e92-9c4d-11ea-9271-0a5bf521835e', 'Gants M', 'unite', 'Emballages', '{}'::text[], 5.9, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80892a5a-9c4d-11ea-926c-0a5bf521835e', 'Couvercle boite perles coco', 'unite', 'Emballages', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80892cda-9c4d-11ea-926f-0a5bf521835e', 'Fourchette', 'unite', 'Emballages', '{}'::text[], 0.024, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80892dc0-9c4d-11ea-9270-0a5bf521835e', 'Gants L', 'unite', 'Emballages', '{}'::text[], 5.9, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80892b22-9c4d-11ea-926d-0a5bf521835e', 'Gobelet café', 'unite', 'Emballages', '{}'::text[], 0.027, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80892c12-9c4d-11ea-926e-0a5bf521835e', 'Cuillère', 'unite', 'Emballages', '{}'::text[], 0.03, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('808931ee-9c4d-11ea-9275-0a5bf521835e', 'Serviettes', 'unite', 'Emballages', '{}'::text[], 0.0132, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80893112-9c4d-11ea-9274-0a5bf521835e', 'Baguettes chinoises', 'unite', 'Emballages', '{}'::text[], 0.032, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80893658-9c4d-11ea-927a-0a5bf521835e', 'Vermicelles de riz', 'kg', 'Epicerie', '{}'::text[], 2.64, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80893036-9c4d-11ea-9273-0a5bf521835e', 'Film prédécoupé', 'unite', 'Emballages', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80893496-9c4d-11ea-9278-0a5bf521835e', 'Couvercle cup cheesecake', 'unite', 'Emballages', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80893572-9c4d-11ea-9279-0a5bf521835e', 'Pâtes de riz', 'kg', 'Epicerie', '{}'::text[], 3.03, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80892f64-9c4d-11ea-9272-0a5bf521835e', 'Gants S', 'unite', 'Emballages', '{}'::text[], 5.9, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('808933c4-9c4d-11ea-9277-0a5bf521835e', 'Cup cheesecake', 'unite', 'Emballages', '{}'::text[], 0.05, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80893748-9c4d-11ea-927b-0a5bf521835e', 'Nouilles de blé', 'kg', 'Epicerie', ARRAY['gluten']::text[], 5.1, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('808932c0-9c4d-11ea-9276-0a5bf521835e', 'Sacs', 'unite', 'Emballages', '{}'::text[], 0.304, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('808939be-9c4d-11ea-927e-0a5bf521835e', 'Sauce poisson petite', 'L', 'Sauces', ARRAY['poissons']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('808938ec-9c4d-11ea-927d-0a5bf521835e', 'Sauce soja petite', 'L', 'Epicerie', ARRAY['gluten', 'soja']::text[], 4.2, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80893810-9c4d-11ea-927c-0a5bf521835e', 'Riz', 'kg', 'Epicerie', '{}'::text[], 1.5981, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80893f90-9c4d-11ea-9285-0a5bf521835e', 'Pâte muffin chocolat', 'kg', 'Dessert', ARRAY['gluten', 'lait', 'soja']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80893a90-9c4d-11ea-927f-0a5bf521835e', 'Sauce hoisin petite', 'L', 'Epicerie', ARRAY['arachides', 'gluten', 'poissons', 'sesame', 'soja']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80893ec8-9c4d-11ea-9284-0a5bf521835e', 'Beurre doux', 'kg', 'Frais', ARRAY['lait']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80893d1a-9c4d-11ea-9282-0a5bf521835e', 'Oignons frits', 'kg', 'Epicerie', ARRAY['gluten']::text[], 5.456, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80893b6c-9c4d-11ea-9280-0a5bf521835e', 'Sauce sriracha grande', 'L', 'Epicerie', ARRAY['arachides', 'gluten', 'poissons', 'sesame', 'soja']::text[], 4.1041, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80893c3e-9c4d-11ea-9281-0a5bf521835e', 'Cacahuètes grillées', 'kg', 'Epicerie', ARRAY['arachides']::text[], 4.72, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80893de2-9c4d-11ea-9283-0a5bf521835e', 'Frites patate douce', 'kg', 'Frais', '{}'::text[], 4.7308, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80894170-9c4d-11ea-9287-0a5bf521835e', 'Pépites chocolat noir', 'kg', 'Frais', ARRAY['lait', 'soja']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80896f06-9c4d-11ea-928c-0a5bf521835e', 'Cookie vanille', 'unite', 'Dessert', ARRAY['gluten', 'lait', 'soja']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80897000-9c4d-11ea-928d-0a5bf521835e', 'Préparation mousse chocolat', 'kg', 'Dessert', ARRAY['lait', 'soja']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('808971ae-9c4d-11ea-928f-0a5bf521835e', 'Préparation cheesecake', 'kg', 'Dessert', ARRAY['lait']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80894328-9c4d-11ea-9289-0a5bf521835e', 'Caissette tulip cup', 'unite', 'Emballages', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089408a-9c4d-11ea-9286-0a5bf521835e', 'Pâte muffin vanille', 'kg', 'Dessert', ARRAY['gluten', 'lait', 'soja']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('808944cc-9c4d-11ea-928b-0a5bf521835e', 'Cookie chocolat', 'unite', 'Dessert', ARRAY['gluten', 'lait', 'soja']::text[], 0.7729, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089424c-9c4d-11ea-9288-0a5bf521835e', 'plaque tulip cup', 'unite', 'Emballages', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('808970d2-9c4d-11ea-928e-0a5bf521835e', 'Préparation pannacotta', 'kg', 'Dessert', ARRAY['lait']::text[], 6.93, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('808943f0-9c4d-11ea-928a-0a5bf521835e', 'Coulis exotique', 'kg', 'Frais', '{}'::text[], 8.2605, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089737a-9c4d-11ea-9291-0a5bf521835e', 'Thé noir tchai sachet', 'unite', 'Epicerie', '{}'::text[], 0.1275, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80897442-9c4d-11ea-9292-0a5bf521835e', 'Rooibos sachet', 'unite', 'Epicerie', '{}'::text[], 0.1315, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80897280-9c4d-11ea-9290-0a5bf521835e', 'Thé vert menthe sachet', 'unite', 'Epicerie', '{}'::text[], 0.137, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80897884-9c4d-11ea-9294-0a5bf521835e', 'Café vietnamien grains', 'kg', 'Epicerie', '{}'::text[], 9.1, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80897a3c-9c4d-11ea-9296-0a5bf521835e', 'Paille BBT', 'unite', 'Emballages', '{}'::text[], 0.0005, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80897b0e-9c4d-11ea-9297-0a5bf521835e', 'Gobelet BBT', 'unite', 'Emballages', '{}'::text[], 0.0915, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80897bea-9c4d-11ea-9298-0a5bf521835e', 'Lait poudre', 'kg', 'Boissons', ARRAY['lait']::text[], 9.7575, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80897cbc-9c4d-11ea-9299-0a5bf521835e', 'Film opercule BBT', 'unite', 'Emballages', '{}'::text[], 36.8267, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089751e-9c4d-11ea-9293-0a5bf521835e', 'Café espresso grains', 'kg', 'Epicerie', '{}'::text[], 17, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80897960-9c4d-11ea-9295-0a5bf521835e', 'Flyer', 'unite', 'Marketing', '{}'::text[], 0.0323, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80897e56-9c4d-11ea-929b-0a5bf521835e', 'Poudre Vanille', 'kg', 'Boissons', ARRAY['lait']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80897d8e-9c4d-11ea-929a-0a5bf521835e', 'Poudre Taro', 'kg', 'Boissons', ARRAY['lait']::text[], 11.8754, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80898374-9c4d-11ea-92a0-0a5bf521835e', 'Sauce Goi Bo', 'kg', 'Sauces', ARRAY['poissons']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80899c4c-9c4d-11ea-92a3-0a5bf521835e', 'Marinade Porc Laqué', 'kg', 'Sauces', ARRAY['sesame', 'soja']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80899a4e-9c4d-11ea-92a1-0a5bf521835e', 'Eau Sucree', 'kg', 'Sauces', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80897f50-9c4d-11ea-929c-0a5bf521835e', 'Perles Tapioca', 'kg', 'Boissons', ARRAY['sulfites']::text[], 1.3383, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80899b48-9c4d-11ea-92a2-0a5bf521835e', 'Marinade PPC', 'kg', 'Sauces', ARRAY['gluten', 'sesame', 'soja']::text[], 5.832, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('808981d0-9c4d-11ea-929e-0a5bf521835e', 'Perles Mangue', 'kg', 'Boissons', '{}'::text[], 6.2609, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80898022-9c4d-11ea-929d-0a5bf521835e', 'Perles Litchi', 'kg', 'Boissons', '{}'::text[], 6.2609, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('808982ac-9c4d-11ea-929f-0a5bf521835e', 'Bouillon pho Concentré', 'kg', 'Sauces', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80899d1e-9c4d-11ea-92a4-0a5bf521835e', 'Sauce Boeuf Citronnelle', 'kg', 'Sauces', ARRAY['mollusques']::text[], 6.3448, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80899df0-9c4d-11ea-92a5-0a5bf521835e', 'Sauce Poulet Gingembre', 'kg', 'Sauces', ARRAY['gluten', 'mollusques']::text[], 6.5638, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80899ef4-9c4d-11ea-92a6-0a5bf521835e', 'Sauce Ga Kho', 'kg', 'Sauces', ARRAY['gluten', 'soja']::text[], 4.6966, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089a390-9c4d-11ea-92ab-0a5bf521835e', 'Dosette Soja', 'kg', 'Sauces', ARRAY['gluten', 'soja']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089a2b4-9c4d-11ea-92aa-0a5bf521835e', 'Mayonnaise Vegetale Bio', 'kg', 'Sauces', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089a534-9c4d-11ea-92ad-0a5bf521835e', 'Dosette Nuoc Mam', 'unite', 'Sauces', ARRAY['poissons', 'soja', 'sulfites']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('80899fda-9c4d-11ea-92a7-0a5bf521835e', 'Sauce Mixao', 'kg', 'Sauces', ARRAY['gluten', 'sesame', 'soja']::text[], 5.4897, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089a1ba-9c4d-11ea-92a9-0a5bf521835e', 'Sauce Pad thai', 'kg', NULL, ARRAY['poissons']::text[], 5.9172, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089a0c0-9c4d-11ea-92a8-0a5bf521835e', 'Sauce Nuoc Mam', 'kg', 'Sauces', ARRAY['poissons']::text[], 3.27, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089a462-9c4d-11ea-92ac-0a5bf521835e', 'Dosette Piment', 'unite', 'Sauces', '{}'::text[], 0.1011, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089a8cc-9c4d-11ea-92b1-0a5bf521835e', 'The Vert Menthe Bio', 'unite', 'Ingredients Exclusifs', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089a7fa-9c4d-11ea-92b0-0a5bf521835e', 'Dosette Thé noir Concentré', 'unite', 'Ingredients Exclusifs', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089ac28-9c4d-11ea-92b5-0a5bf521835e', 'The vert citronnelle Bio', 'unite', 'Ingredients Exclusifs', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089add6-9c4d-11ea-92b7-0a5bf521835e', 'Biere Artisanale Blonde', 'unite', 'Ingredients Exclusifs', ARRAY['arachides', 'gluten']::text[], 1.6867, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089aa7a-9c4d-11ea-92b3-0a5bf521835e', 'The Vert  Gingembre Bio', 'unite', 'Ingredients Exclusifs', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089a71e-9c4d-11ea-92af-0a5bf521835e', 'Dosette Thé vert Concentré', 'unite', 'Ingredients Exclusifs', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089a99e-9c4d-11ea-92b2-0a5bf521835e', 'Citronnade Bio', 'unite', 'Ingredients Exclusifs', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089a61a-9c4d-11ea-92ae-0a5bf521835e', 'Dosette Mayo Végétale Bio', 'unite', 'Sauces', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089ab4c-9c4d-11ea-92b4-0a5bf521835e', 'Infusion Hibiscus Menthe Bio', 'unite', 'Ingredients Exclusifs', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089acfa-9c4d-11ea-92b6-0a5bf521835e', 'Jus de Pomme bio', 'unite', 'Ingredients Exclusifs', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089af7a-9c4d-11ea-92b9-0a5bf521835e', 'Sauce Satay base', 'kg', 'Sauces', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089ae9e-9c4d-11ea-92b8-0a5bf521835e', 'Cidre Artisanal Vietnam', 'unite', 'Ingredients Exclusifs', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089b3ee-9c4d-11ea-92be-0a5bf521835e', 'Menthe', 'kg', 'Frais', '{}'::text[], 22.7521, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089b4ca-9c4d-11ea-92bf-0a5bf521835e', 'Citron vert', 'kg', 'Frais', '{}'::text[], 3.921, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 'Oignons rouges', 'kg', 'Frais', '{}'::text[], 1.8617, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089b696-9c4d-11ea-92c1-0a5bf521835e', 'Poivre noir moulu', 'kg', 'Epicerie', '{}'::text[], 17.813, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089b312-9c4d-11ea-92bd-0a5bf521835e', 'Coriandre', 'kg', 'Frais', '{}'::text[], 22.2886, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089b16e-9c4d-11ea-92bb-0a5bf521835e', 'Eau minérale', 'unite', 'Boissons', '{}'::text[], 0.4323, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089b236-9c4d-11ea-92bc-0a5bf521835e', 'Eau pétillante', 'unite', 'Boissons', '{}'::text[], 0.5869, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089b772-9c4d-11ea-92c2-0a5bf521835e', 'Paprika', 'kg', 'Epicerie', '{}'::text[], 8.61, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089b9f2-9c4d-11ea-92c5-0a5bf521835e', 'Noix de coco râpée', 'kg', 'Epicerie', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089b844-9c4d-11ea-92c3-0a5bf521835e', 'Dosettes sucre', 'unite', 'Epicerie', '{}'::text[], 0.0164, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089bace-9c4d-11ea-92c6-0a5bf521835e', 'Brisure Oreo', 'kg', 'Epicerie', ARRAY['gluten', 'soja']::text[], 10.6592, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089b920-9c4d-11ea-92c4-0a5bf521835e', 'Lait de coco', 'kg', 'Epicerie', ARRAY['crustaces', 'lait', 'poissons', 'sesame', 'soja', 'sulfites']::text[], 3.1476, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089bc9a-9c4d-11ea-92c8-0a5bf521835e', 'Sirop fraise', 'L', 'Boissons', '{}'::text[], 6.424, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089bf42-9c4d-11ea-92ca-0a5bf521835e', 'Vinaigre blanc', 'kg', 'Epicerie', '{}'::text[], 0.543, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089c0aa-9c4d-11ea-92cb-0a5bf521835e', 'Farine de blé', 'kg', 'Epicerie', ARRAY['gluten']::text[], 0.7553, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089bd76-9c4d-11ea-92c9-0a5bf521835e', 'Sirop passion', 'L', 'Boissons', '{}'::text[], 8.1922, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089c17c-9c4d-11ea-92cc-0a5bf521835e', 'Concombre', 'kg', 'Frais', '{}'::text[], 2.7189, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089bbbe-9c4d-11ea-92c7-0a5bf521835e', 'Lait concentré tube', 'kg', 'Epicerie', ARRAY['lait']::text[], 5.0044, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 'Pousses de Soja', 'kg', 'Frais', '{}'::text[], 1.932, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089c5be-9c4d-11ea-92d1-0a5bf521835e', 'Carottes râpées', 'kg', 'Frais', '{}'::text[], 1.9143, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089c32a-9c4d-11ea-92ce-0a5bf521835e', 'Salade', 'kg', 'Frais', '{}'::text[], 3.4738, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089c258-9c4d-11ea-92cd-0a5bf521835e', 'Cébette', 'kg', 'Frais', '{}'::text[], 6.2667, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089c690-9c4d-11ea-92d2-0a5bf521835e', 'Chips Crevette', 'kg', 'Epicerie', ARRAY['crustaces', 'sulfites']::text[], 3.69, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089c406-9c4d-11ea-92cf-0a5bf521835e', 'Poivron rouge', 'kg', 'Frais', '{}'::text[], 3.4025, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089c852-9c4d-11ea-92d4-0a5bf521835e', 'Champignons noir', 'kg', 'Frais', '{}'::text[], 12.65, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089ca00-9c4d-11ea-92d6-0a5bf521835e', 'Poudre 5 épices', 'kg', 'Epicerie', '{}'::text[], 9.5, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089c924-9c4d-11ea-92d5-0a5bf521835e', 'Piment entier', 'kg', 'Frais', '{}'::text[], 33.1275, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089c780-9c4d-11ea-92d3-0a5bf521835e', 'Samosa légumes', 'unite', 'Surgelés', ARRAY['gluten', 'soja']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089cd5c-9c4d-11ea-92da-0a5bf521835e', 'Nata coco aloe vera', 'kg', 'Frais', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089cac8-9c4d-11ea-92d7-0a5bf521835e', 'Bière Saigon', 'unite', 'Boissons', ARRAY['arachides', 'gluten']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089cf00-9c4d-11ea-92dc-0a5bf521835e', 'Nem poulet', 'unite', 'Surgelés', ARRAY['lait', 'soja']::text[], 0.3895, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089cbae-9c4d-11ea-92d8-0a5bf521835e', 'Perles coco cacahuètes', 'kg', 'Dessert', ARRAY['arachides', 'gluten', 'sesame']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089d1c6-9c4d-11ea-92df-0a5bf521835e', 'Oignons émincés surgelés', 'kg', 'Frais', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089ce24-9c4d-11ea-92db-0a5bf521835e', 'Beurre cacahuètes', 'kg', 'Epicerie', ARRAY['arachides']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089d298-9c4d-11ea-92e0-0a5bf521835e', 'Ail cubes', 'kg', 'Frais', '{}'::text[], 6.84, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089cfdc-9c4d-11ea-92dd-0a5bf521835e', 'Filet poulet', 'kg', 'Frais', '{}'::text[], 7.3544, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089cc80-9c4d-11ea-92d9-0a5bf521835e', 'Tofu nature', 'kg', 'Frais', ARRAY['soja']::text[], 5.2453, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089d90a-9c4d-11ea-92e6-0a5bf521835e', 'Boulettes traditionnelles', 'kg', 'Frais', ARRAY['gluten', 'lait', 'poissons']::text[], 12.3299, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089d522-9c4d-11ea-92e3-0a5bf521835e', 'Oeufs entiers liquide', 'kg', 'Frais', '{}'::text[], 4.6734, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089d446-9c4d-11ea-92e2-0a5bf521835e', 'Echine de porc', 'kg', 'Frais', '{}'::text[], 7.3837, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089d37e-9c4d-11ea-92e1-0a5bf521835e', 'Huile', 'kg', 'Epicerie', '{}'::text[], 3.4004, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089d838-9c4d-11ea-92e5-0a5bf521835e', 'Boeuf', 'kg', 'Frais', '{}'::text[], 17.5842, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('88c4aa00-a33b-11eb-a68c-ebc667a0f6a6', 'Napolitains Ba Ria 76%', 'unite', 'Epicerie', ARRAY['fruits_a_coque', 'gluten', 'lait']::text[], 4.5, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('844e6910-90f2-11ed-808a-65c448e0727c', 'Drink waters Plate', 'unite', 'Boissons', '{}'::text[], 1.24, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('84398c10-601f-11ed-85c3-e1b33cb1c0b7', 'Coca Cola Bouteille', 'unite', 'Boissons', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('83dd7550-be2c-11ec-9222-db267923b89e', 'Chou chinois', 'unite', 'Frais', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8089d0a4-9c4d-11ea-92de-0a5bf521835e', 'Crevettes décortiquées VN', 'kg', 'Surgelés', ARRAY['crustaces', 'sulfites']::text[], 12.4375, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('88c9e970-e482-11ef-aa41-01eb4d41c1d0', 'Granola', 'kg', 'Dessert', ARRAY['gluten']::text[], 10.37, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8cb796e0-a63a-11ee-b3cd-3d8b47d7dc66', 'Moscow mule', 'L', 'Boissons', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('905c80f0-9eb6-11eb-b217-2bde6a29a24e', 'Mochi glacé litchi (vegan)', 'unite', 'Dessert', ARRAY['soja']::text[], 0.89, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('89c0dd60-00ee-11f0-9d98-b7ea8c718efe', 'Mayonnaise vrac', 'kg', 'Sauces', ARRAY['moutarde']::text[], 3.1289, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8f221700-4d81-11ee-9848-af14af9a4362', 'Crème Glacée Beurre de Cacahuètes', 'unite', 'Dessert', ARRAY['arachides', 'fruits_a_coque', 'gluten', 'lait']::text[], 1.678, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('952356e0-8d98-11ed-b5d4-d30635a860b5', 'Dosette sweet chili TT', 'unite', 'Sauces', ARRAY['arachides', 'gluten', 'poissons', 'sesame', 'soja']::text[], 0.19, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('96d871b0-b37b-11ed-9ea0-d38c4a9947cb', 'Couvercle Pho', 'unite', 'Emballages', '{}'::text[], 0.112, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8faec180-7d4a-11ed-b263-b95e21b5e348', 'Casquettes', 'unite', 'Uniformes', '{}'::text[], 10.8333, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('94e89f80-d4be-11eb-8c4c-2fe8d4c30ca4', 'Coca Zero 25cl', 'unite', 'Boissons', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('8eda7860-7cd6-11eb-83c2-81353eec23fb', 'Perles Grenade', 'kg', 'Boissons', '{}'::text[], 6.2609, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('91d84850-9dfe-11f0-ad3e-2792898a72a1', 'Tiramisu Noisette Choco & Spéculoos', 'unite', 'Dessert', ARRAY['fruits_a_coque', 'gluten', 'lait', 'soja']::text[], 1.4733, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('9fe020a0-e31b-11eb-b993-552ff2e9d866', 'Biere pression', 'L', 'Boissons', ARRAY['arachides', 'gluten']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('9e0f3020-d385-11ed-b3c8-cd0e0e620070', 'Savon Bactéricide cuisine', 'L', 'Hygiène', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('98361850-77a3-11ed-9a28-4df3cd6470f6', 'Bol Grand + Couvercle', 'unite', 'Emballages', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('984d2290-a63a-11ee-b682-015a80327a47', 'Spritz', 'L', 'Boissons', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('96ef61c0-916f-11eb-9d41-2dd57a3d8f5e', 'Perles coco crème', 'unite', 'Dessert', ARRAY['gluten', 'lait', 'soja']::text[], 13.31, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('9724eb40-55c9-11ed-8260-85ea4d40d179', 'Féfé', 'unite', 'Boissons', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('9846ad50-5147-11ed-b50c-474f649a5bc5', 'Bière', 'unite', 'Boissons', '{}'::text[], 1.05, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('9898f160-7d4c-11ed-b263-b95e21b5e348', 'Lave Pont Frottoir', 'unite', 'Hygiène', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('9e7f4730-9eb6-11eb-846b-b95a8fb3fd70', 'Mochi glacé yuzu et citron (vegan)', 'unite', 'Dessert', ARRAY['soja']::text[], 0.89, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('a20c0f10-7d48-11ed-a047-fb061caa6559', 'Boule inox', 'unite', 'Hygiène', '{}'::text[], 0.589, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('aef2a440-20b9-11ee-8622-37df65c2b093', 'Glace Au Chocolat', 'L', 'Surgelés', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('a5980d40-7d4e-11ed-9124-af8ed14a816a', 'Sirop de Cassis ', 'L', 'Boissons', '{}'::text[], 4.9, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('a54f72d0-d864-11ed-a335-b118b249b5d3', 'Préparation BBL waffle', 'kg', 'Epicerie', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('a3e37730-ede1-11eb-b539-d109965a1b2f', 'Napolitains Dong Nai 72', 'unite', 'Epicerie', ARRAY['fruits_a_coque', 'gluten', 'lait']::text[], 4.5, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('b54c7000-7d4e-11ed-a047-fb061caa6559', 'Sirop de Coco', 'L', 'Boissons', '{}'::text[], 3.8, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('a54866e0-6ae6-11eb-80f6-73940ffe6b4a', 'Donut Nutella', 'unite', 'Dessert', ARRAY['fruits_a_coque', 'gluten', 'lait', 'soja']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('ad6b1c90-19f6-11ec-964d-47192e0197c6', 'Ice Tea', 'unite', 'Boissons', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('a84e6e30-da70-11f0-adac-a3171657b79f', 'bobine Thermique TPE', 'unite', 'Hygiène', '{}'::text[], 0.3802, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('b5996970-7d4c-11ed-bef2-3be33b07e51f', 'Lavette ', 'unite', 'Hygiène', '{}'::text[], 3.136, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('a39ec9b0-d38f-11ed-9677-6bd4a1cc96ce', 'Ensemble Pelle Balayette', 'unite', 'Hygiène', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('b59bf6e0-d864-11ed-9aa1-ef27351cff41', 'Mini kinder bueno ', 'unite', 'Epicerie', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('b6016290-bb2a-11f0-9bda-f77aaf7b1906', 'Jus Litchi', 'unite', 'Boissons', '{}'::text[], 1.2271, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('b5bcc650-6c3b-11eb-830a-2b05dd6006ef', 'Kefir Figue Citron Bio', 'unite', 'Ingredients Exclusifs', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('bb248820-c310-11ed-9c70-752f0462a215', 'Thé vert menthe concombre - KUSMI', 'unite', 'Epicerie', '{}'::text[], 0.4012, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('ba162090-7eb7-11ec-bafd-fb0d701e3442', 'Pot soupe pho (taille normale et grande)', 'unite', 'Emballages', '{}'::text[], 0.12, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('bc30cef0-2370-11f0-ac9f-fffdeb0f868f', 'Thé noir kashmir tchai - KUSMI', 'unite', 'Boissons', '{}'::text[], 0.3992, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('b7c1c370-d38a-11ed-9677-6bd4a1cc96ce', 'Sel adoucisseur', 'kg', 'Hygiène', '{}'::text[], 0.4942, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('ba102e80-d1f8-11ec-b363-f7982c6efb86', 'Sirop peche', 'L', 'Boissons', '{}'::text[], 4.4792, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('b632b350-5146-11ed-b50c-474f649a5bc5', 'Balai', 'unite', 'Hygiène', '{}'::text[], 13.475, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('ba0d5480-6686-11ed-a031-8b54f9890809', 'Bière sans alcool', 'unite', 'Boissons', ARRAY['gluten']::text[], 1.6915, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('c08fb080-da70-11f0-aed4-7d96cdc22e1f', 'Frange serpillère', 'unite', 'Hygiène', '{}'::text[], 1.2, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('bf29fff0-c1a8-11ec-b810-d1ffe210d8b1', 'Chia', 'kg', 'Epicerie', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('c2209b50-4d85-11ee-b1b9-d7aabbfa3a52', 'Crème Glacée Vanille Pecan', 'unite', 'Dessert', ARRAY['fruits_a_coque', 'gluten', 'lait']::text[], 1.678, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('c39076e0-6023-11ed-8dc7-092ea485f5d7', 'Film étirable alimentaire', 'unite', 'Emballages', '{}'::text[], 8.765, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('c5a46030-bb2a-11f0-9bda-f77aaf7b1906', 'Eau coco Maya', 'unite', 'Boissons', '{}'::text[], 1.2271, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('bfd9c020-d395-11ed-a335-b118b249b5d3', 'Papier Toilette', 'unite', 'Hygiène', '{}'::text[], 7.36, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('c384cf60-a8b5-11eb-9cae-41439e88333c', 'Chair à saucisse', 'kg', 'Frais', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('c523b650-7d49-11ed-b263-b95e21b5e348', 'Cartes plats', 'unite', 'Marketing', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('c62145d0-8c13-11ed-a977-852f0d1617fb', 'Coca Cola slim', 'unite', 'Boissons', '{}'::text[], 0.6653, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('cf2ba4a0-74c4-11ee-bc12-d54052347f51', 'Vin canetta', 'unite', 'Boissons', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('cfbb0da0-08fb-11ee-8674-bb09560c03c4', 'Sirop Pandan', 'L', 'Boissons', '{}'::text[], 8.6017, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('c88ce710-7d4b-11ed-b263-b95e21b5e348', 'Dégraissant', 'L', 'Hygiène', '{}'::text[], 4.4, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('c7c73660-2836-11ed-b785-09840579bd69', 'Mogu - Mogu ', 'unite', 'Boissons', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('cd5461e0-bf8f-11eb-ba7c-19483afb8580', 'Mochi glacé fleur de cerisier ', 'unite', 'Dessert', ARRAY['lait']::text[], 0.89, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('cc3d2e20-7cf7-11eb-83c2-81353eec23fb', 'Papier cuisson silicone', 'unite', 'Emballages', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('cf5aa960-2370-11f0-8b95-0ba6cd1a2e00', 'Thé vert de chine - KUSMI', 'unite', 'Boissons', '{}'::text[], 0.4268, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('cab47370-9316-11ec-bdf2-dbb798a33559', 'Coulis framboise', 'kg', 'Frais', ARRAY['fruits_a_coque']::text[], 6.8, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('d0f323c0-b740-11ef-95c4-57b2d144b46f', 'Drink waters pétillante', 'unite', 'Boissons', '{}'::text[], 1.24, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('c5655100-9eb6-11eb-846b-b95a8fb3fd70', 'Mochi glacé mangue / passion (vegan)', 'unite', 'Dessert', '{}'::text[], 0.89, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('d0ceb8f0-3583-11ed-9548-ed051dc9e4fe', 'Dosette Ong Xen', 'unite', 'Sauces', ARRAY['poissons']::text[], 0.15, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('d627b890-d864-11ed-89d3-cf05f605d483', 'Brisure daim', 'kg', 'Epicerie', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('d632baa0-ebcb-11ec-9630-193a22d236be', 'Tartare de bœuf', 'kg', 'Frais', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('d7dc0a50-77a3-11ed-9df8-0bd02a42dd7f', 'Bol Normal + Couvercle', 'unite', 'Emballages', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('d6825b50-bdf1-11ef-ba0c-d9e4e2a63cd3', 'Citronnelle moulue', 'kg', 'Frais', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('d3adbff0-fb8e-11ec-86ff-13fce83436c9', 'Pot de glace cacahuète', 'unite', 'Dessert', ARRAY['arachides', 'fruits_a_coque', 'gluten', 'lait', 'soja']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('d971c9b0-6685-11ed-8cf9-1de12f567f43', 'Jus la boissonnerie', 'unite', 'Boissons', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('dd840f20-bf8f-11eb-8fcb-8ba60eb97259', 'Mochi glacé caramel au beurre salé', 'unite', 'Dessert', ARRAY['lait']::text[], 0.89, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('dc85cbf0-5146-11ed-9fe9-c12459cc1b44', 'Bandeau de ménage', 'unite', 'Hygiène', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('da05ca10-ab96-11ed-9bd5-bfc79caa022b', 'Préparation pâte bubble waffle', 'kg', 'Epicerie', '{}'::text[], 5.809, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('d257ad90-9eb6-11eb-98d0-4d3123634f37', 'Mochi glacé chocolat eclats de noisette', 'unite', 'Dessert', ARRAY['arachides', 'fruits_a_coque', 'lait']::text[], 0.89, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('ddca0900-2370-11f0-bb68-a1d2c971872e', 'Thé vert jasmin - KUSMI', 'unite', 'Boissons', '{}'::text[], 0.4268, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('dee419c0-c1a8-11ec-853d-e7960d3897c4', 'Cubes de mangue', 'kg', 'Surgelés', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('e902d420-2d90-11ec-ac7d-edfd3dbf0302', 'Poudre soupe pho', 'kg', 'Epicerie', ARRAY['celeri', 'crustaces', 'gluten', 'lait', 'poissons', 'soja']::text[], 9.3158, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('e0db1a50-7d4e-11ed-bef2-3be33b07e51f', 'Sirop de mangue', 'L', 'Boissons', '{}'::text[], 7.619, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('e927cbf0-fb8e-11ec-82ff-e103d8d6432f', 'Pot de glace vanille cookie', 'unite', 'Dessert', ARRAY['arachides', 'fruits_a_coque', 'gluten', 'lait', 'soja']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('e747d290-f0c9-11ed-9ff6-59801b43f17c', 'Poudre de Coco', 'kg', 'Epicerie', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('e7240c10-7d48-11ed-a047-fb061caa6559', 'Bouteille vaporisateur', 'unite', 'Hygiène', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('e704fed0-a8ea-11eb-a272-274b1324dbc5', 'Sel fin vrac', 'kg', 'Epicerie', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('e61c84e0-4d82-11ee-b1b9-d7aabbfa3a52', 'Crème Glacée Caramel Brownie', 'unite', 'Dessert', ARRAY['fruits_a_coque', 'gluten', 'lait']::text[], 1.678, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('f37315a0-e542-11eb-8237-736a902b6e66', 'Mochi glacé fraise (vegan)', 'unite', 'Dessert', ARRAY['soja']::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('f2e91490-9eb6-11eb-b217-2bde6a29a24e', 'Mochi glacé pistache', 'unite', 'Dessert', ARRAY['fruits_a_coque', 'lait']::text[], 0.89, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('ebbcfde0-ef91-11eb-bbe5-ef0537d994fa', 'Perles Framboise', 'kg', 'Boissons', '{}'::text[], 6.2609, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('f0deb290-fe75-11ef-9f24-3dea27761cfa', 'Sauce sweet chili dosette', 'unite', 'Sauces', '{}'::text[], 0.1649, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('ec92a780-4d84-11ee-a7f1-87190e351617', 'Crème Glacée Noix de Coco Avec Copeaux De Chocolat', 'unite', 'Dessert', ARRAY['fruits_a_coque', 'gluten', 'lait', 'soja']::text[], 1.678, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('e9d88d10-b944-11eb-acec-29fb8569cb50', 'Petit Pois', 'kg', 'Frais', '{}'::text[], 3.124, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('f0198690-7d4a-11ed-b263-b95e21b5e348', 'Couvercle Bol Grand', 'unite', 'Emballages', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('eb643230-fe6c-11ef-a70a-c30a5e202927', 'Porte Gobelets', 'unite', 'Emballages', '{}'::text[], 0.064, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('ebee1fa0-9eb6-11eb-98d0-4d3123634f37', 'Mochi glacé thé vert matcha bio', 'unite', 'Dessert', ARRAY['lait']::text[], 0.89, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('f189f420-2853-11ed-8172-37c06f5b9a95', 'Ousia 0 %', 'unite', 'Boissons', '{}'::text[], 1.81, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('f7663c30-5933-11ed-988a-6df56d6d4bf0', 'Cuillère Pho', 'unite', 'Vaisselle', '{}'::text[], 0.7917, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('f456eba0-d38d-11ed-9c3f-53b8785e19c0', 'Dégraissant Désinfectant', 'kg', 'Hygiène', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('f6545520-fe77-11ef-abd3-1d5bab16a12f', 'Sauce Sweet chili vrac', 'kg', 'Sauces', '{}'::text[], 2.8981, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('f6ba4130-ef91-11eb-b539-d109965a1b2f', 'Perles Fraise', 'kg', 'Boissons', '{}'::text[], 6.2609, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('f7fccfe0-d392-11ed-993e-3b5e3ecd3f4f', 'Pistolet Pulvérisateur', 'unite', 'Hygiène', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('f8c2c2a0-d694-11ec-9aab-3f3b95fb7b18', 'Donut Chocolat', 'unite', 'Dessert', ARRAY['gluten', 'lait', 'soja']::text[], 0.3101, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('f8f32660-20b8-11ee-8622-37df65c2b093', 'Glace à la vanille', 'L', 'Surgelés', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('f9dbed40-236e-11f0-bb68-a1d2c971872e', 'Thé noir quatre fruits rouge - KUSMI', 'unite', 'Boissons', '{}'::text[], 0.4068, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('fc2bc190-f5d4-11eb-8ccc-17901c63413d', 'Pâte à tartiner marou', 'unite', 'Epicerie', ARRAY['arachides', 'fruits_a_coque', 'gluten', 'lait']::text[], 9, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('faac3510-8f66-11ee-89c1-731f17c336c3', 'Cookie Triple Chocolat', 'unite', 'Dessert', ARRAY['gluten', 'lait', 'soja']::text[], 0.7684, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('fd416aa0-d384-11ed-b4ea-03c09a21f282', 'cartouche mousse hydroalcoolique', 'L', 'Hygiène', '{}'::text[], 0, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('fc2f93f0-6428-11ee-8a36-29bc4666a7c6', 'Polo ', 'unite', 'Uniformes', '{}'::text[], 32, true);
INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES ('fcf1fa20-d1c2-11ec-88bd-5b29d81a78b4', 'Limonade', 'L', 'Boissons', '{}'::text[], 0.2813, true);

-- Mercuriale (supplier products)
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('a25490b0-fc5a-11ec-a176-d902a1918d35', '25131b20-fc38-11ec-a176-d902a1918d35', '04f43df0-7d4e-11ed-9124-af8ed14a816a', 'Sac Poubelle Petit 50L', '501699', 'Hygiène', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 500 pcs","quantite":500,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 43.6, 5.5, 'unite', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'a25490b0-fc5a-11ec-a176-d902a1918d35' WHERE id = '04f43df0-7d4e-11ed-9124-af8ed14a816a';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('5a559100-c276-11ed-8f98-af22ee5cd631', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '001f3140-ef92-11eb-bbe5-ef0537d994fa', 'Perles Passion - Pop Ball', '126034', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Colis  de 4 x 3,2kg","quantite":12.8,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 80.14, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '5a559100-c276-11ed-8f98-af22ee5cd631' WHERE id = '001f3140-ef92-11eb-bbe5-ef0537d994fa';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('34a46ef0-b0b7-11ef-8596-c937323b5e82', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '06656f60-b230-11ef-9c6e-779763fa7658', 'Poudre Sésame', '126561C12', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 12 x 1kg","quantite":12,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 122.87, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '34a46ef0-b0b7-11ef-8596-c937323b5e82' WHERE id = '06656f60-b230-11ef-9c6e-779763fa7658';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('67670630-074c-11f1-beab-9d63667c62f5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '09c960e0-117e-11f1-ae64-1f8e3f56f901', 'Tenders PLT crispy Vestey', '803032', 'Surgelés', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"sachet de 800g","quantite":0.8,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 9.216, 5.5, 'kg', 5, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '67670630-074c-11f1-beab-9d63667c62f5' WHERE id = '09c960e0-117e-11f1-ae64-1f8e3f56f901';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('67d53950-b8d4-11f0-b6fe-43cc2133c362', '5c49af70-8ef5-11f0-975b-2726f4fe3aed', '09c960e0-117e-11f1-ae64-1f8e3f56f901', 'Tenders Strips Oumaty', '6085', 'Surgelés', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"sachet de 800g","quantite":0.8,"unite":"kg","utilise_commande":true,"utilise_stock":true},{"nom":"CTN de 7 sachets de 800g","quantite":7,"unite":"kg","utilise_commande":false,"utilise_stock":false}]', 1, 8.99, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '67d53950-b8d4-11f0-b6fe-43cc2133c362' WHERE id = '09c960e0-117e-11f1-ae64-1f8e3f56f901';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('9c5fb590-b96c-11f0-a957-8de7f3544dea', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '09c960e0-117e-11f1-ae64-1f8e3f56f901', 'Crispy Tenders', '186288', 'Surgelés', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"sachet de 1kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true},{"nom":"carton de 5 sachets","quantite":5,"unite":"kg","utilise_commande":false,"utilise_stock":false}]', 1, 9.99, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '9c5fb590-b96c-11f0-a957-8de7f3544dea' WHERE id = '09c960e0-117e-11f1-ae64-1f8e3f56f901';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('d1d11e40-8ef5-11f0-83bf-f96a1806d919', '5c49af70-8ef5-11f0-975b-2726f4fe3aed', '0b4a7e70-e53a-11ef-ae90-c77ba71d6e00', 'Wings Tex Mex halal oumaty', '300763', 'Surgelés', '[{"nom":"sachet de 800g","quantite":0.8,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"carton de 7 x 800g","quantite":7,"unite":"kg","utilise_commande":true,"utilise_stock":false}]', 1, 5.35, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'd1d11e40-8ef5-11f0-83bf-f96a1806d919' WHERE id = '0b4a7e70-e53a-11ef-ae90-c77ba71d6e00';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('e108a550-8ef4-11f0-9f81-21aea717c1be', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '0b4a7e70-e53a-11ef-ae90-c77ba71d6e00', 'Wings Tex Mex halal oumaty', '300763', 'Surgelés', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"sachet de 800 g","quantite":0.8,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 7.4375, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'e108a550-8ef4-11f0-9f81-21aea717c1be' WHERE id = '0b4a7e70-e53a-11ef-ae90-c77ba71d6e00';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('f423e920-0fa5-11f0-b578-3bbca98dba90', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '0b4a7e70-e53a-11ef-ae90-c77ba71d6e00', 'Aile de poulet Tex Mex halal', '669671', 'Surgelés', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"colis de 5kg","quantite":5,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 6.831, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'f423e920-0fa5-11f0-b578-3bbca98dba90' WHERE id = '0b4a7e70-e53a-11ef-ae90-c77ba71d6e00';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('33e4b910-c011-11f0-aa3b-ef2b4b2ddd30', 'b9ac9040-c00c-11f0-90c5-f561d51de85d', '0d161320-1baf-11ec-9cd0-53f06f053e40', 'Oignon Jaune', '2040', 'Epicerie', '[{"nom":"Kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true},{"nom":"Filet de 10 kg","quantite":10,"unite":"kg","utilise_commande":false,"utilise_stock":false}]', 0, 0.99, 5.5, 'kg', 20, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '33e4b910-c011-11f0-aa3b-ef2b4b2ddd30' WHERE id = '0d161320-1baf-11ec-9cd0-53f06f053e40';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('58c1a8c0-19e3-11ec-967c-692187d0a72f', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '0d161320-1baf-11ec-9cd0-53f06f053e40', 'Oignons jaune gros', '402152', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"sac de 25 kg","quantite":25,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 1.29, 5.5, 'kg', 20, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '58c1a8c0-19e3-11ec-967c-692187d0a72f' WHERE id = '0d161320-1baf-11ec-9cd0-53f06f053e40';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('79d8c8e0-8d04-11ee-a5e3-8d90d3a1e616', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '0d161320-1baf-11ec-9cd0-53f06f053e40', 'Oignon Jaune 10 kg', '972546', 'Epicerie', '[{"nom":"Kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"Filet de 10 kg","quantite":10,"unite":"kg","utilise_commande":true,"utilise_stock":false}]', 1, 6.9, 5.5, 'kg', 20, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '79d8c8e0-8d04-11ee-a5e3-8d90d3a1e616' WHERE id = '0d161320-1baf-11ec-9cd0-53f06f053e40';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('cc883450-fc59-11ec-87d3-cf5d212ef325', '25131b20-fc38-11ec-a176-d902a1918d35', '0d161320-1baf-11ec-9cd0-53f06f053e40', 'Oignons jaunes gros (fr C1)', '969306', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Au kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 0.39, 5.5, 'kg', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'cc883450-fc59-11ec-87d3-cf5d212ef325' WHERE id = '0d161320-1baf-11ec-9cd0-53f06f053e40';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('ee6187a0-8979-11ec-8ce1-c32a63dfe765', 'ea564a80-8977-11ec-8ce1-c32a63dfe765', '0d161320-1baf-11ec-9cd0-53f06f053e40', 'Oignons blanc', NULL, 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Sachet de 5kg","quantite":5,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 2.5, 5.5, 'kg', 20, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'ee6187a0-8979-11ec-8ce1-c32a63dfe765' WHERE id = '0d161320-1baf-11ec-9cd0-53f06f053e40';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('024d2b10-8ec4-11ee-a601-bd4702810762', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '0b9ba290-e1ea-11ee-9824-b524be6ecff3', 'Fromage Blanc I Paysan Breton', '242026', 'Frais', '[{"nom":"pot","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true},{"nom":"Colis de 6 pots ","quantite":6,"unite":"kg","utilise_commande":false,"utilise_stock":false}]', 0, 3.068, 5.5, 'kg', 20, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '024d2b10-8ec4-11ee-a601-bd4702810762' WHERE id = '0b9ba290-e1ea-11ee-9824-b524be6ecff3';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('292617c0-da70-11f0-acf2-970a8697a1f0', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '0b9ba290-e1ea-11ee-9824-b524be6ecff3', 'Fromage Blanc SIMPL', '830839', 'Frais', '[{"nom":"pot","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 0, 1.94, 5.5, 'kg', 20, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '292617c0-da70-11f0-acf2-970a8697a1f0' WHERE id = '0b9ba290-e1ea-11ee-9824-b524be6ecff3';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('f38df7f0-469e-11f0-ac0f-7bf1a4337fac', '60bb1420-c0a6-11ec-959c-5b5037aeef23', '0f24c2c0-7d4b-11ed-b263-b95e21b5e348', 'Couvercle Pot Dessert carton', ' COUVBOLD9PAP', 'Emballages', '[{"nom":"Couvercle pot dessert","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Couvercle Pot Dessert","quantite":500,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 30, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'f38df7f0-469e-11f0-ac0f-7bf1a4337fac' WHERE id = '0f24c2c0-7d4b-11ed-b263-b95e21b5e348';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('a0433550-fea9-11ec-87d3-cf5d212ef325', '60bb1420-c0a6-11ec-959c-5b5037aeef23', '15854ed0-6bb6-11eb-80f6-73940ffe6b4a', 'Gobelet Thé', '200007', 'Emballages', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 1000pcs","quantite":1000,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 45, 5.5, 'unite', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'a0433550-fea9-11ec-87d3-cf5d212ef325' WHERE id = '15854ed0-6bb6-11eb-80f6-73940ffe6b4a';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('c11658b0-21c0-11f0-ac9f-fffdeb0f868f', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '1541beb0-21db-11f0-ac69-4ff8f2877233', 'Boulettes boeuf halal', '651497', 'Surgelés', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"sachet de 5kg","quantite":5,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 12.808000000000002, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'c11658b0-21c0-11f0-ac9f-fffdeb0f868f' WHERE id = '1541beb0-21db-11f0-ac69-4ff8f2877233';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('f58f1a80-24f1-11f0-9d79-f1534d75c7a1', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '1541beb0-21db-11f0-ac69-4ff8f2877233', 'Boulettes boeuf halal', '244882', 'Surgelés', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"sachet 50 pcs (30g)","quantite":1.5,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"CTN de 4 sachets","quantite":4,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 2, 13.442, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'f58f1a80-24f1-11f0-9d79-f1534d75c7a1' WHERE id = '1541beb0-21db-11f0-ac69-4ff8f2877233';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('15733700-7a62-11ee-a128-173f0dc27acd', 'd4617750-9add-11ec-ba94-f94c6b33e293', '10212950-5147-11ed-ae1b-9d995079b109', 'Surchaussure 41 - 44', 'SC01-BLK41', 'Uniformes', '[{"nom":"Surchaussure","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 0, 45, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '15733700-7a62-11ee-a128-173f0dc27acd' WHERE id = '10212950-5147-11ed-ae1b-9d995079b109';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('34c31d50-7a62-11ee-8d65-69677a6c946d', 'd4617750-9add-11ec-ba94-f94c6b33e293', '10212950-5147-11ed-ae1b-9d995079b109', 'Surchaussure 45 et + ', 'SC01-BLK45', 'Uniformes', '[{"nom":"Surchaussure","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 0, 45, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '34c31d50-7a62-11ee-8d65-69677a6c946d' WHERE id = '10212950-5147-11ed-ae1b-9d995079b109';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('afc2ce20-7a61-11ee-8098-81145f75bf63', 'd4617750-9add-11ec-ba94-f94c6b33e293', '10212950-5147-11ed-ae1b-9d995079b109', 'Surchaussure 34 - 36', 'SC01-BLK34', 'Uniformes', '[{"nom":"Surchaussure","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 0, 45, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'afc2ce20-7a61-11ee-8098-81145f75bf63' WHERE id = '10212950-5147-11ed-ae1b-9d995079b109';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('fff5cfa0-7a61-11ee-9235-7d6e956d0ff1', 'd4617750-9add-11ec-ba94-f94c6b33e293', '10212950-5147-11ed-ae1b-9d995079b109', 'Surchaussure 37 - 40', 'SC01-BLK37', 'Uniformes', '[{"nom":"Surchaussure","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 0, 45, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'fff5cfa0-7a61-11ee-9235-7d6e956d0ff1' WHERE id = '10212950-5147-11ed-ae1b-9d995079b109';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('75fa8560-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '1288ef60-f30a-11ed-ada6-f1c2893b2f15', 'Vinaigre d''alcool blanc 8°C', '448712', 'Epicerie', '[{"nom":"Bidon","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"Bidon de 10 L","quantite":10,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 10.322, 5.5, 'L', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '75fa8560-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '1288ef60-f30a-11ed-ada6-f1c2893b2f15';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('fe52ba50-0ec7-11ef-b4a3-5f60b060840e', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '0e8b62f0-21d2-11f0-840c-7186b075b488', 'Sirop thé vert concentré ', '115423', 'Boissons', '[{"nom":"L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 6 bouteilles de 1L","quantite":6,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 37.48, 5.5, 'L', 2, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'fe52ba50-0ec7-11ef-b4a3-5f60b060840e' WHERE id = '0e8b62f0-21d2-11f0-840c-7186b075b488';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('1fc7d9b0-6426-11ee-ad4f-1351a0481861', 'd4617750-9add-11ec-ba94-f94c6b33e293', '0fb01600-7d4f-11ed-9124-af8ed14a816a', ' T-Shirt Burgundy Taille L', 'T01-BUR-L', 'Uniformes', '[{"nom":"T-shirt ","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 0, 15, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '1fc7d9b0-6426-11ee-ad4f-1351a0481861' WHERE id = '0fb01600-7d4f-11ed-9124-af8ed14a816a';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('2505aac0-6425-11ee-8a36-29bc4666a7c6', 'd4617750-9add-11ec-ba94-f94c6b33e293', '0fb01600-7d4f-11ed-9124-af8ed14a816a', 'T-Shirt Burgundy Taille S', 'T01-BUR-S', 'Uniformes', '[{"nom":"T-shirt","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 0, 15, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '2505aac0-6425-11ee-8a36-29bc4666a7c6' WHERE id = '0fb01600-7d4f-11ed-9124-af8ed14a816a';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('440625d0-a0ae-11ec-b897-49361739ec66', 'd4617750-9add-11ec-ba94-f94c6b33e293', '0fb01600-7d4f-11ed-9124-af8ed14a816a', 'T-shirt navy M', 'T01-NVY-M', 'Uniformes', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Unité","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 13, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '440625d0-a0ae-11ec-b897-49361739ec66' WHERE id = '0fb01600-7d4f-11ed-9124-af8ed14a816a';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('53d6ea30-a0ae-11ec-9621-f9b12b907ef5', 'd4617750-9add-11ec-ba94-f94c6b33e293', '0fb01600-7d4f-11ed-9124-af8ed14a816a', 'T-shirt navy S', 'T01-NVY-S', 'Uniformes', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Unité","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 13, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '53d6ea30-a0ae-11ec-9621-f9b12b907ef5' WHERE id = '0fb01600-7d4f-11ed-9124-af8ed14a816a';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('a3250030-6426-11ee-b4a7-47b0eb7cb58a', 'd4617750-9add-11ec-ba94-f94c6b33e293', '0fb01600-7d4f-11ed-9124-af8ed14a816a', 'T-Shirt Burgundy Taille XL', 'T01-BUR-XL', 'Uniformes', '[{"nom":"T-shirt ","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 0, 15, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'a3250030-6426-11ee-b4a7-47b0eb7cb58a' WHERE id = '0fb01600-7d4f-11ed-9124-af8ed14a816a';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('dfc76ba0-6425-11ee-8d36-7ff8ac678c0f', 'd4617750-9add-11ec-ba94-f94c6b33e293', '0fb01600-7d4f-11ed-9124-af8ed14a816a', 'T-Shirt Burgundy Taille M', 'T01-BUR-M', 'Uniformes', '[{"nom":"T-shirt ","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 0, 15, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'dfc76ba0-6425-11ee-8d36-7ff8ac678c0f' WHERE id = '0fb01600-7d4f-11ed-9124-af8ed14a816a';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('d5a37e50-c274-11ed-8f4c-e7d4ca882d17', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '17d942f0-c275-11ed-b116-d7b40111f808', 'Perles Myrtilles - Pop Ball', '126029', 'Epicerie', '[{"nom":"Pot 3,2kg","quantite":3.2,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 4 x 3.2kg","quantite":4,"unite":"kg","utilise_commande":true,"utilise_stock":false}]', 1, 80.14, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'd5a37e50-c274-11ed-8f4c-e7d4ca882d17' WHERE id = '17d942f0-c275-11ed-b116-d7b40111f808';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('75db3d90-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '18ab8420-a8b6-11eb-9770-c18e5ed172e8', 'Sucre en Poudre', '330170', 'Epicerie', '[{"nom":"au kilogramme","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"6 sachets de 1 kg ","quantite":6,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 2.105, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '75db3d90-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '18ab8420-a8b6-11eb-9770-c18e5ed172e8';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('e6020750-d10f-11ec-b363-f7982c6efb86', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '18ab8420-a8b6-11eb-9770-c18e5ed172e8', 'Sucre en poudre 1er Prix', '737829', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 1kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 1.25, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'e6020750-d10f-11ec-b363-f7982c6efb86' WHERE id = '18ab8420-a8b6-11eb-9770-c18e5ed172e8';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('59e12770-4bf6-11ee-9e4e-e1162ef350f9', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '1edcd750-4d86-11ee-b55c-159c4c7fd68f', 'Sorbet Framboise Litchi - Atelier des écrins', '302213', 'Surgelés', '[{"nom":"Pot de glace 92g","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"CTN de 15 pots","quantite":15,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 1.6780000000000002, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '59e12770-4bf6-11ee-9e4e-e1162ef350f9' WHERE id = '1edcd750-4d86-11ee-b55c-159c4c7fd68f';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('1ab94986-5ffb-11eb-a225-0a5bf521835e', '4642b3ec-5b43-11eb-a18e-0a5bf521835e', '1ccd9ea0-a8fa-11eb-9cae-41439e88333c', 'Pilon poulet Halal', '5851', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"Paquet de 10 KG","quantite":10,"unite":"kg","utilise_commande":true,"utilise_stock":false}]', 1, 18, 5.5, 'kg', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '1ab94986-5ffb-11eb-a225-0a5bf521835e' WHERE id = '1ccd9ea0-a8fa-11eb-9cae-41439e88333c';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('a9cfce10-c634-11ec-b967-edc70ea1c95c', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '202590d0-be1b-11ec-9222-db267923b89e', 'Nems légumes', '999069', 'Surgelés', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Sachet de 1.440kg","quantite":48,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 10.9, 5.5, 'unite', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'a9cfce10-c634-11ec-b967-edc70ea1c95c' WHERE id = '202590d0-be1b-11ec-9222-db267923b89e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('e463a240-abb1-11ee-bf91-07c4b0b3a531', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '202590d0-be1b-11ec-9222-db267923b89e', 'Nems aux légumes SFPA', '623258', 'Surgelés', '[{"nom":"à l''unité","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"sachet de 48 pièces","quantite":48,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"CTN de 4 sachets x 48 pcs","quantite":192,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 2, 11.14, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'e463a240-abb1-11ee-bf91-07c4b0b3a531' WHERE id = '202590d0-be1b-11ec-9222-db267923b89e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('f373aa70-94c4-11f0-93c7-cf854843b3c9', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '202590d0-be1b-11ec-9222-db267923b89e', 'Nems aux légumes SFPA', '999069', 'Surgelés', '[{"nom":"sachet de 50 pcs","quantite":50,"unite":"unite","utilise_commande":true,"utilise_stock":true},{"nom":"CTN de 4 sachets ","quantite":4,"unite":"unite","utilise_commande":false,"utilise_stock":false}]', 0, 12.5, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'f373aa70-94c4-11f0-93c7-cf854843b3c9' WHERE id = '202590d0-be1b-11ec-9222-db267923b89e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('78669780-2607-11ee-a9c5-919e3d735654', '9a3280e0-2152-11ee-888e-8daad14c2966', '21cb1ba0-d38a-11ed-a335-b118b249b5d3', 'Liquide Rinçage Vaisselle ', '566533', 'Hygiène', '[{"nom":"1 L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"Bidon de 5 L","quantite":5,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 9.02, 20, 'L', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '78669780-2607-11ee-a9c5-919e3d735654' WHERE id = '21cb1ba0-d38a-11ed-a335-b118b249b5d3';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('fe356fb0-5309-11ee-bd02-0b8c1274b273', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '21dd4110-91c0-11ed-b4d4-2171468c5ab0', 'Crème Sucrée Sous Pression', '414409', 'Frais', '[{"nom":"Bombe de 700 ML","quantite":1,"unite":"L","utilise_commande":true,"utilise_stock":true},{"nom":"Colis de 6 Bombes","quantite":6,"unite":"L","utilise_commande":false,"utilise_stock":false}]', 0, 7.442, 5.5, 'L', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'fe356fb0-5309-11ee-bd02-0b8c1274b273' WHERE id = '21dd4110-91c0-11ed-b4d4-2171468c5ab0';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('110d1270-bf8f-11eb-8fcb-8ba60eb97259', '80c6a4f0-6a21-11eb-9a21-0a5bf521835e', '218671b0-1f05-11ed-b87e-25470f2449dc', 'Mochi Litchi (vegan)', NULL, 'Surgelés', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 25 pcs","quantite":25,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 22.25, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '110d1270-bf8f-11eb-8fcb-8ba60eb97259' WHERE id = '218671b0-1f05-11ed-b87e-25470f2449dc';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('137e57a0-d045-11eb-a570-6b7b458b3a1a', '80c6a4f0-6a21-11eb-9a21-0a5bf521835e', '218671b0-1f05-11ed-b87e-25470f2449dc', 'Mochi Framboise', 'Non défini', 'Surgelés', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 25 pcs","quantite":25,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 22.25, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '137e57a0-d045-11eb-a570-6b7b458b3a1a' WHERE id = '218671b0-1f05-11ed-b87e-25470f2449dc';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('167f07e0-cead-11eb-ad59-4b0ef542f836', '80c6a4f0-6a21-11eb-9a21-0a5bf521835e', '218671b0-1f05-11ed-b87e-25470f2449dc', 'Mochi vanille', NULL, 'Surgelés', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 25 pcs","quantite":25,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 22.25, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '167f07e0-cead-11eb-ad59-4b0ef542f836' WHERE id = '218671b0-1f05-11ed-b87e-25470f2449dc';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('288b04c0-bf8f-11eb-8fcb-8ba60eb97259', '80c6a4f0-6a21-11eb-9a21-0a5bf521835e', '218671b0-1f05-11ed-b87e-25470f2449dc', 'Mochi Mangue / Passion (vegan)', 'Non défini', 'Surgelés', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 25 pcs","quantite":25,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 22.25, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '288b04c0-bf8f-11eb-8fcb-8ba60eb97259' WHERE id = '218671b0-1f05-11ed-b87e-25470f2449dc';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('3091eb70-bf8f-11eb-8fcb-8ba60eb97259', '80c6a4f0-6a21-11eb-9a21-0a5bf521835e', '218671b0-1f05-11ed-b87e-25470f2449dc', 'Mochi Pistache', 'Non défini', 'Surgelés', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 25 pcs","quantite":25,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 22.25, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '3091eb70-bf8f-11eb-8fcb-8ba60eb97259' WHERE id = '218671b0-1f05-11ed-b87e-25470f2449dc';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('3b9919d0-bf8f-11eb-8fcb-8ba60eb97259', '80c6a4f0-6a21-11eb-9a21-0a5bf521835e', '218671b0-1f05-11ed-b87e-25470f2449dc', 'Mochi Thé vert matcha bio', 'Non défini', 'Surgelés', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 25 pcs","quantite":25,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 22.25, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '3b9919d0-bf8f-11eb-8fcb-8ba60eb97259' WHERE id = '218671b0-1f05-11ed-b87e-25470f2449dc';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('44737d20-bf8f-11eb-89e7-33cf61a157fb', '80c6a4f0-6a21-11eb-9a21-0a5bf521835e', '218671b0-1f05-11ed-b87e-25470f2449dc', 'Mochi Fleur de cerisier', 'Non défini', 'Surgelés', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 25 pcs","quantite":25,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 22.25, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '44737d20-bf8f-11eb-89e7-33cf61a157fb' WHERE id = '218671b0-1f05-11ed-b87e-25470f2449dc';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('5879add0-bf8f-11eb-8fcb-8ba60eb97259', '80c6a4f0-6a21-11eb-9a21-0a5bf521835e', '218671b0-1f05-11ed-b87e-25470f2449dc', 'Mochi Caramel beurre salé', 'Non défini', 'Surgelés', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 25 pcs","quantite":25,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 22.25, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '5879add0-bf8f-11eb-8fcb-8ba60eb97259' WHERE id = '218671b0-1f05-11ed-b87e-25470f2449dc';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('67313a00-bf8f-11eb-af08-75c0c4679929', '80c6a4f0-6a21-11eb-9a21-0a5bf521835e', '218671b0-1f05-11ed-b87e-25470f2449dc', 'Mochi Yuzu et citron (vegan)', 'Non défini', 'Surgelés', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 25 pcs","quantite":25,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 22.25, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '67313a00-bf8f-11eb-af08-75c0c4679929' WHERE id = '218671b0-1f05-11ed-b87e-25470f2449dc';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('d80db3d0-bf8e-11eb-8fcb-8ba60eb97259', '80c6a4f0-6a21-11eb-9a21-0a5bf521835e', '218671b0-1f05-11ed-b87e-25470f2449dc', 'Mochi Chocolat eclats de noisette', 'Non défini', 'Surgelés', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 25 pcs","quantite":25,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 22.25, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'd80db3d0-bf8e-11eb-8fcb-8ba60eb97259' WHERE id = '218671b0-1f05-11ed-b87e-25470f2449dc';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('0a679430-c012-11f0-82b5-b530456d9e5b', 'b9ac9040-c00c-11f0-90c5-f561d51de85d', '2b877c00-46bf-11ec-939f-314f99801403', 'Carottes entières', '2039', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":false},{"nom":"Sachet de 10kg","quantite":10,"unite":"kg","utilise_commande":false,"utilise_stock":true}]', 0, 0.99, 5.5, 'kg', 20, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '0a679430-c012-11f0-82b5-b530456d9e5b' WHERE id = '2b877c00-46bf-11ec-939f-314f99801403';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('2fd36230-fc48-11ec-87d3-cf5d212ef325', '25131b20-fc38-11ec-a176-d902a1918d35', '2b877c00-46bf-11ec-939f-314f99801403', 'Carottes entières C1', '969156', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Au kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 0.82, 5.5, 'kg', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '2fd36230-fc48-11ec-87d3-cf5d212ef325' WHERE id = '2b877c00-46bf-11ec-939f-314f99801403';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('752d2340-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '2b877c00-46bf-11ec-939f-314f99801403', 'Carottes entières', '966063', 'Frais', '[{"nom":"au kilogramme","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"Sachet de 5 kg","quantite":5,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 0.919, 5.5, 'kg', 5, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '752d2340-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '2b877c00-46bf-11ec-939f-314f99801403';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('b8630350-19e3-11ec-967c-692187d0a72f', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '2b877c00-46bf-11ec-939f-314f99801403', 'Carottes entières', '13705', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Sachet de 5kg","quantite":5,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 1.6, 5.5, 'kg', 20, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'b8630350-19e3-11ec-967c-692187d0a72f' WHERE id = '2b877c00-46bf-11ec-939f-314f99801403';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('cd685e20-8979-11ec-8ce1-c32a63dfe765', 'ea564a80-8977-11ec-8ce1-c32a63dfe765', '2b877c00-46bf-11ec-939f-314f99801403', 'Carottes entières', NULL, 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Sachet de 5kg","quantite":5,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 3.5, 5.5, 'kg', 20, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'cd685e20-8979-11ec-8ce1-c32a63dfe765' WHERE id = '2b877c00-46bf-11ec-939f-314f99801403';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('1c23c8ea-51a1-11eb-b01d-0a5bf521835e', 'd69710e0-f469-11eb-8fb0-df4c06cfdb0d', '26c8acb0-a332-11eb-a60c-5545ff63e985', 'Set 3 Mini tablettes', NULL, 'Epicerie', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"8 set de 3 tablettes de 24g","quantite":8,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 30.4, 5.5, 'unite', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '1c23c8ea-51a1-11eb-b01d-0a5bf521835e' WHERE id = '26c8acb0-a332-11eb-a60c-5545ff63e985';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('54639e50-8c15-11ed-a8b0-71c818120196', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '2cf1bfa0-19f7-11ec-967c-692187d0a72f', 'Coca Cola Zéro Slim - 33CL', '346102', 'Boissons', '[{"nom":"canette","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":" 24 canettes de  33cl","quantite":24,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 0.53, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '54639e50-8c15-11ed-a8b0-71c818120196' WHERE id = '2cf1bfa0-19f7-11ec-967c-692187d0a72f';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('759e82b0-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '2cf1bfa0-19f7-11ec-967c-692187d0a72f', 'Coca Cola Zero Slim', '211389', 'Boissons', '[{"nom":"La canette ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 24 canettes","quantite":24,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 0.766, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '759e82b0-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '2cf1bfa0-19f7-11ec-967c-692187d0a72f';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('f0bb2160-8ef6-11f0-a12b-690e93f68ae2', '5c49af70-8ef5-11f0-975b-2726f4fe3aed', '2cf1bfa0-19f7-11ec-967c-692187d0a72f', 'Coca Cola Zero Slim 33cl', '152', 'Boissons', '[{"nom":"La canette ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 24 canettes","quantite":24,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 0.52, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'f0bb2160-8ef6-11f0-a12b-690e93f68ae2' WHERE id = '2cf1bfa0-19f7-11ec-967c-692187d0a72f';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('8b9ccd90-c268-11ed-9637-2ff9d0f68a96', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '2dbdce80-8805-11eb-b96f-7177973d12e2', 'Sirop de canne Routin', '115151', 'Boissons', '[{"nom":"L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 6 bouteilles de 1L","quantite":6,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 31.27, 5.5, 'L', 2, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '8b9ccd90-c268-11ed-9637-2ff9d0f68a96' WHERE id = '2dbdce80-8805-11eb-b96f-7177973d12e2';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('c2270994-8664-11eb-864c-0a5bf521835e', '7634b460-f526-11eb-9855-6d337dfcae57', '2dbdce80-8805-11eb-b96f-7177973d12e2', 'Sirop de canne', '115151C6', 'Boissons', '[{"nom":"L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"carton de 6 btl de 1L","quantite":6,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 32.7, 5.5, 'L', 2, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'c2270994-8664-11eb-864c-0a5bf521835e' WHERE id = '2dbdce80-8805-11eb-b96f-7177973d12e2';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('757290b0-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '32df9ea0-4e20-11ee-89fc-3b4978b6868d', 'Appareil Panna Cotta ', '811523', 'Frais', '[{"nom":"Bouteille de 1 L ","quantite":1,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 0, 5.34, 5.5, 'L', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '757290b0-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '32df9ea0-4e20-11ee-89fc-3b4978b6868d';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('46e150b6-5110-11eb-b1da-0a5bf521835e', 'd69710e0-f469-11eb-8fb0-df4c06cfdb0d', '34fbcd00-a33a-11eb-84f4-0b99e046e5f3', 'Ginger & lime Ba Ria 69% grande', NULL, 'Epicerie', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"boîte de 10 tablettes","quantite":10,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 33, 5.5, 'unite', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '46e150b6-5110-11eb-b1da-0a5bf521835e' WHERE id = '34fbcd00-a33a-11eb-84f4-0b99e046e5f3';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('c67439e0-2d64-11ef-a73f-3deaa7027210', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '32bb7eb0-2d65-11ef-a188-f3703d636499', 'Verrine Chocolat ', '403951', 'Surgelés', '[{"nom":"Verrine Chocolat","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Carton de 12 verrines x 80g","quantite":12,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 15.241, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'c67439e0-2d64-11ef-a73f-3deaa7027210' WHERE id = '32bb7eb0-2d65-11ef-a188-f3703d636499';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('1257c2a0-7c85-11ee-8d65-69677a6c946d', '5ebc88e0-7976-11ee-a1ca-ed4795abb9e6', '42afc510-7d4e-11ed-b263-b95e21b5e348', 'Sacs à déchets 130L noir', '772266', 'Hygiène', '[{"nom":"1 rouleau de 10 sacs","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Carton de 10 rouleaux (10x10)","quantite":10,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 26.08, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '1257c2a0-7c85-11ee-8d65-69677a6c946d' WHERE id = '42afc510-7d4e-11ed-b263-b95e21b5e348';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('7e0fe5b0-fc5a-11ec-87d3-cf5d212ef325', '25131b20-fc38-11ec-a176-d902a1918d35', '42afc510-7d4e-11ed-b263-b95e21b5e348', 'Sac poubelle Grand 130L', '301083', 'Hygiène', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 10 pcs","quantite":10,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 15.8, 5.5, 'unite', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '7e0fe5b0-fc5a-11ec-87d3-cf5d212ef325' WHERE id = '42afc510-7d4e-11ed-b263-b95e21b5e348';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('46e15142-5110-11eb-b1dc-0a5bf521835e', 'd69710e0-f469-11eb-8fb0-df4c06cfdb0d', '384576e0-e3be-11eb-b4a4-c79ec670c12e', 'Kumquat Tien Giang 68% grande', NULL, 'Epicerie', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"boîte de 10 tablettes","quantite":10,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 33, 5.5, 'unite', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '46e15142-5110-11eb-b1dc-0a5bf521835e' WHERE id = '384576e0-e3be-11eb-b4a4-c79ec670c12e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('5dc43890-4bf7-11ee-aa89-f30425481ee6', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '3c1aade0-4d83-11ee-9848-af14af9a4362', 'Crème Glacée Chocolat de Tanzanie - Atelier des écrins', '301524', 'Surgelés', '[{"nom":"Pot de glace ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Pots de glace Chocolat","quantite":15,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 25.17, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '5dc43890-4bf7-11ee-aa89-f30425481ee6' WHERE id = '3c1aade0-4d83-11ee-9848-af14af9a4362';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('26b894b0-c270-11ed-8f98-af22ee5cd631', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '3a5a9a90-f5ee-11eb-8f32-750a66e837fd', 'Sirop Yuzu / Citron Routin', '115091', 'Boissons', '[{"nom":"L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 6 bouteilles de 1L","quantite":6,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 51.61, 5.5, 'L', 2, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '26b894b0-c270-11ed-8f98-af22ee5cd631' WHERE id = '3a5a9a90-f5ee-11eb-8f32-750a66e837fd';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('c33162a0-f5ed-11eb-8f32-750a66e837fd', '7634b460-f526-11eb-9855-6d337dfcae57', '3a5a9a90-f5ee-11eb-8f32-750a66e837fd', 'Sirop Yuzu / Citron', '115091C6', 'Boissons', '[{"nom":"L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"Carton de 6 btl de 1L","quantite":6,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 53.19, 5.5, 'L', 2, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'c33162a0-f5ed-11eb-8f32-750a66e837fd' WHERE id = '3a5a9a90-f5ee-11eb-8f32-750a66e837fd';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('77d2e300-2607-11ee-a9c5-919e3d735654', '9a3280e0-2152-11ee-888e-8daad14c2966', '457af520-d394-11ed-9c3f-53b8785e19c0', 'Liquide lavage Vaisselle ', '566542', 'Hygiène', '[{"nom":"1 L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"Bidon de 5 L","quantite":5,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 12.52, 20, 'L', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '77d2e300-2607-11ee-a9c5-919e3d735654' WHERE id = '457af520-d394-11ed-9c3f-53b8785e19c0';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('3542e1d0-5077-11ee-a38b-7d8eb0ef0f5b', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '43802dc0-4e2e-11ee-8d17-29eec0ef8ef1', 'Coulis Mangue/Passion - BOIRON ', '490060	', 'Frais', '[{"nom":"Flacon de 500g","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":true},{"nom":"Colis de 12 Flacons","quantite":12,"unite":"unite","utilise_commande":false,"utilise_stock":false}]', 0, 4.96, 5.5, 'unite', 5, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '3542e1d0-5077-11ee-a38b-7d8eb0ef0f5b' WHERE id = '43802dc0-4e2e-11ee-8d17-29eec0ef8ef1';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('a56b7f80-5077-11ee-a3ba-7791caca3b3f', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '43802dc0-4e2e-11ee-8d17-29eec0ef8ef1', 'Coulis Fruit Rouge - BOIRON ', '490086	', 'Frais', '[{"nom":"Flacon ","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":true},{"nom":"Colis de 12 Flacons","quantite":12,"unite":"unite","utilise_commande":false,"utilise_stock":false}]', 0, 8.573, 5.5, 'unite', 5, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'a56b7f80-5077-11ee-a3ba-7791caca3b3f' WHERE id = '43802dc0-4e2e-11ee-8d17-29eec0ef8ef1';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('86aaee20-3dd9-11ed-bc30-e32dbbc99e9f', 'fc61d960-ecf0-11ec-92c5-b70a8da9dfee', '4bd60d30-7d48-11ed-a047-fb061caa6559', 'Bol Inox PHOOD Grand', 'FVA-BOL02', 'Vaisselle', '[{"nom":"Colis de 10","quantite":10,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 0, 112, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '86aaee20-3dd9-11ed-bc30-e32dbbc99e9f' WHERE id = '4bd60d30-7d48-11ed-a047-fb061caa6559';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('e1890320-9efe-11f0-8968-273afd593a5f', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '4cdc9920-9eff-11f0-b3c9-33035a5842ae', 'Sundae Vanille Fraise', '234581', 'Surgelés', '[{"nom":"pot","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"CTN de 40 pots","quantite":40,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 19.256, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'e1890320-9efe-11f0-8968-273afd593a5f' WHERE id = '4cdc9920-9eff-11f0-b3c9-33035a5842ae';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('70cb6760-2d65-11ef-bd8b-ffd37e1ba7cb', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '4d17d8d0-2d65-11ef-b990-47930060fae2', 'Verrine Banoffee ', '403952', 'Surgelés', '[{"nom":"Verrine Banoffee","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Carton de 12 verrines x 80g","quantite":12,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 15.241, 5.5, 'unite', 0, true);
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('086665ac-51a0-11eb-9e6f-0a5bf521835e', 'd69710e0-f469-11eb-8fb0-df4c06cfdb0d', '570c0710-f5d4-11eb-8ccc-17901c63413d', 'Napolitains Ben Tre 78%', NULL, 'Epicerie', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"8 boites de 80h","quantite":8,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 36, 5.5, 'unite', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '086665ac-51a0-11eb-9e6f-0a5bf521835e' WHERE id = '570c0710-f5d4-11eb-8ccc-17901c63413d';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('bcf76ad0-7c85-11ee-ab72-3fd0ed0819d1', '5ebc88e0-7976-11ee-a1ca-ed4795abb9e6', '4fd6e900-d38c-11ed-a335-b118b249b5d3', 'Bobine Thermique Addition 80x80x12', '818370', 'Hygiène', '[{"nom":"Bobine Thermique 80x80x12","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 50 pièces","quantite":50,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 75, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'bcf76ad0-7c85-11ee-ab72-3fd0ed0819d1' WHERE id = '4fd6e900-d38c-11ed-a335-b118b249b5d3';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('41c61ca0-b8d6-11f0-8023-f50462a02790', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '57387cf0-b8d5-11f0-8023-f50462a02790', 'Tenders Cornflakes Oumaty', '300786', 'Surgelés', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"sachet de 800g","quantite":0.8,"unite":"kg","utilise_commande":true,"utilise_stock":true},{"nom":"CTN de 7 sachets de 800g","quantite":7,"unite":"kg","utilise_commande":false,"utilise_stock":false}]', 1, 8.54, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '41c61ca0-b8d6-11f0-8023-f50462a02790' WHERE id = '57387cf0-b8d5-11f0-8023-f50462a02790';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('bac40470-b89d-11f0-ac04-bb69b75f8f49', '5c49af70-8ef5-11f0-975b-2726f4fe3aed', '57387cf0-b8d5-11f0-8023-f50462a02790', 'Tenders Cornflakes Oumaty', '3599', 'Surgelés', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"sachet de 800g","quantite":0.8,"unite":"kg","utilise_commande":true,"utilise_stock":true},{"nom":"CTN de 7 sachets de 800g","quantite":7,"unite":"kg","utilise_commande":false,"utilise_stock":false}]', 1, 6.626, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'bac40470-b89d-11f0-ac04-bb69b75f8f49' WHERE id = '57387cf0-b8d5-11f0-8023-f50462a02790';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('c97b5960-f14f-11f0-9c7a-a7fd0376f6bd', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '57387cf0-b8d5-11f0-8023-f50462a02790', 'Pepper Tenders', '292354', 'Surgelés', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"sachet de 800g","quantite":0.8,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 10.41, 5.5, 'kg', 5, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'c97b5960-f14f-11f0-9c7a-a7fd0376f6bd' WHERE id = '57387cf0-b8d5-11f0-8023-f50462a02790';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('13262770-7c8b-11ee-a1ca-ed4795abb9e6', '5ebc88e0-7976-11ee-a1ca-ed4795abb9e6', '60f608e0-d398-11ed-a90f-effe91255ffc', 'Support Frange à Languette Type Speedy 40X13 BLEU LEGER', '109415', 'Hygiène', '[{"nom":"1 pièce","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 0, 16, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '13262770-7c8b-11ee-a1ca-ed4795abb9e6' WHERE id = '60f608e0-d398-11ed-a90f-effe91255ffc';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('56590960-7c8e-11ee-8d65-69677a6c946d', '5ebc88e0-7976-11ee-a1ca-ed4795abb9e6', '60f608e0-d398-11ed-a90f-effe91255ffc', 'Raclette Vitres inox 25 cm', '152695', 'Hygiène', '[{"nom":"1 pièce","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 0, 12, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '56590960-7c8e-11ee-8d65-69677a6c946d' WHERE id = '60f608e0-d398-11ed-a90f-effe91255ffc';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('d54a66c0-7c8d-11ee-8d65-69677a6c946d', '5ebc88e0-7976-11ee-a1ca-ed4795abb9e6', '60f608e0-d398-11ed-a90f-effe91255ffc', 'Support Mouilleur Alu 35cm', '100880', 'Hygiène', '[{"nom":"1 piece","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 0, 5, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'd54a66c0-7c8d-11ee-8d65-69677a6c946d' WHERE id = '60f608e0-d398-11ed-a90f-effe91255ffc';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('568d8962-51a1-11eb-873a-0a5bf521835e', 'd69710e0-f469-11eb-8fb0-df4c06cfdb0d', '60698600-a333-11eb-a82e-d37eb9df5ff1', 'Set 6 mini tablettes', NULL, 'Epicerie', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"4 sets de 6 tablettes de 24g","quantite":4,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 30, 5.5, 'unite', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '568d8962-51a1-11eb-873a-0a5bf521835e' WHERE id = '60698600-a333-11eb-a82e-d37eb9df5ff1';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('7f47e260-f45f-11eb-8fb0-df4c06cfdb0d', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '5ff10d10-f4f5-11eb-9855-6d337dfcae57', 'Sauce soja claire supérieur', '999039L', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"2 bidons de 10KG","quantite":20,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 13.21, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '7f47e260-f45f-11eb-8fb0-df4c06cfdb0d' WHERE id = '5ff10d10-f4f5-11eb-9855-6d337dfcae57';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('7d370340-d262-11ef-9eef-7569a7ba2d26', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '5cf92180-dc2e-11ec-ae34-1dcb862714d3', 'Donut Sucre ', '301479', 'Surgelés', '[{"nom":"Cookie 50g","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 48 donuts","quantite":48,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 12.138, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '7d370340-d262-11ef-9eef-7569a7ba2d26' WHERE id = '5cf92180-dc2e-11ec-ae34-1dcb862714d3';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('0c8438b0-f840-11ec-a176-d902a1918d35', 'e1451f2a-9f72-11ea-8f40-0a5bf521835e', '61d22480-f840-11ec-a176-d902a1918d35', 'Gomme Xanthane', NULL, 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 1kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 21.73, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '0c8438b0-f840-11ec-a176-d902a1918d35' WHERE id = '61d22480-f840-11ec-a176-d902a1918d35';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('f0ccdda0-4bf6-11ee-8d4b-d1bb2685e1f4', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '65efe100-4d86-11ee-a7f1-87190e351617', 'Sorbet Mangue - Atelier des écrins', '301510', 'Surgelés', '[{"nom":"Pot de glace ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Sorbet Mangue","quantite":15,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 25.17, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'f0ccdda0-4bf6-11ee-8d4b-d1bb2685e1f4' WHERE id = '65efe100-4d86-11ee-a7f1-87190e351617';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('45197480-4979-11ed-a88d-09c2555d4c03', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '6957aad0-f4f5-11eb-a95c-45ac352893ba', 'Sauce Poisson', '8169', 'Epicerie', '[{"nom":"4,5L","quantite":4.5,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 0, 10.79, 5.5, 'L', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '45197480-4979-11ed-a88d-09c2555d4c03' WHERE id = '6957aad0-f4f5-11eb-a95c-45ac352893ba';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('9e0bc910-24f6-11ec-9b47-cbe6dae27c4e', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '6957aad0-f4f5-11eb-a95c-45ac352893ba', 'Sauce poisson | S.Quid', '8241', 'Epicerie', '[{"nom":"L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"3 bidons de 4,5L","quantite":13.5,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 38.7, 5.5, 'L', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '9e0bc910-24f6-11ec-9b47-cbe6dae27c4e' WHERE id = '6957aad0-f4f5-11eb-a95c-45ac352893ba';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('74ebad70-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '67bc3410-72b0-11eb-a732-3588446adb69', 'Cookie Chocolat Framboise', '222161', 'Surgelés', '[{"nom":"Cookie","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 90 cookies","quantite":90,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 69.479, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '74ebad70-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '67bc3410-72b0-11eb-a732-3588446adb69';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('c971a820-3dd9-11ed-b286-3989b7510705', 'fc61d960-ecf0-11ec-92c5-b70a8da9dfee', '67fffe90-7d4c-11ed-bef2-3be33b07e51f', 'Grand Pot Sauce Inox PHOOD', 'FVA-POT03', 'Vaisselle', '[{"nom":"Colis de 10","quantite":10,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 0, 38, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'c971a820-3dd9-11ed-b286-3989b7510705' WHERE id = '67fffe90-7d4c-11ed-bef2-3be33b07e51f';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('384c3430-c26f-11ed-b116-d7b40111f808', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '66ff9a30-00f8-11ed-82ff-e103d8d6432f', 'Sirop Fleur de Cerisier Routin', '115125', 'Boissons', '[{"nom":"L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 6 bouteilles de 1L","quantite":6,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 49.71, 5.5, 'L', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '384c3430-c26f-11ed-b116-d7b40111f808' WHERE id = '66ff9a30-00f8-11ed-82ff-e103d8d6432f';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('5f400450-ec81-11ec-8b07-55ade4ba684a', '7634b460-f526-11eb-9855-6d337dfcae57', '66ff9a30-00f8-11ed-82ff-e103d8d6432f', 'Sirop Fleur de Cerisier', '115125C6', 'Boissons', '[{"nom":"L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"carton de 6 btl de 1L","quantite":6,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 52.04, 5.5, 'L', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '5f400450-ec81-11ec-8b07-55ade4ba684a' WHERE id = '66ff9a30-00f8-11ed-82ff-e103d8d6432f';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('4f556140-ec7f-11ec-a12f-77342cf624c3', '7634b460-f526-11eb-9855-6d337dfcae57', '6c028cc0-fb73-11ec-87d3-cf5d212ef325', 'Sirop Grenade', '115155C6', 'Boissons', '[{"nom":"L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"carton de 6 btl x 1L","quantite":6,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 49.63, 5.5, 'L', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '4f556140-ec7f-11ec-a12f-77342cf624c3' WHERE id = '6c028cc0-fb73-11ec-87d3-cf5d212ef325';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('fdd08b40-c26d-11ed-9637-2ff9d0f68a96', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '6c028cc0-fb73-11ec-87d3-cf5d212ef325', 'Sirop Grenade Routin', '115155', 'Boissons', '[{"nom":"L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 6 bouteilles de 1L","quantite":6,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 49.32, 5.5, 'L', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'fdd08b40-c26d-11ed-9637-2ff9d0f68a96' WHERE id = '6c028cc0-fb73-11ec-87d3-cf5d212ef325';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('1a74cad0-c274-11ed-9637-2ff9d0f68a96', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '6befbf50-6168-11ec-b4f3-f589907dab6b', 'Perles Kiwi - Pop Ball', '126036', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 4 x 3.2kg","quantite":12.8,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 80.14, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '1a74cad0-c274-11ed-9637-2ff9d0f68a96' WHERE id = '6befbf50-6168-11ec-b4f3-f589907dab6b';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('79420f20-fc48-11ec-a176-d902a1918d35', '25131b20-fc38-11ec-a176-d902a1918d35', '6e078db0-be2c-11ec-92b5-d17e9a4e477d', 'Champignons émincés', '228358', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 1kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 5.5, 5.5, 'kg', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '79420f20-fc48-11ec-a176-d902a1918d35' WHERE id = '6e078db0-be2c-11ec-92b5-d17e9a4e477d';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('8e2b9af0-fc48-11ec-86ff-13fce83436c9', '25131b20-fc38-11ec-a176-d902a1918d35', '6e078db0-be2c-11ec-92b5-d17e9a4e477d', 'Champignons émincés', '891112', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 250g","quantite":0.25,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 1.8, 5.5, 'kg', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '8e2b9af0-fc48-11ec-86ff-13fce83436c9' WHERE id = '6e078db0-be2c-11ec-92b5-d17e9a4e477d';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('a4550830-be2b-11ec-9222-db267923b89e', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '6e078db0-be2c-11ec-92b5-d17e9a4e477d', 'Champignons blancs', '100783', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"Colis 3kg","quantite":3,"unite":"kg","utilise_commande":true,"utilise_stock":false}]', 1, 3.4, 5.5, 'kg', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'a4550830-be2b-11ec-9222-db267923b89e' WHERE id = '6e078db0-be2c-11ec-92b5-d17e9a4e477d';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('6d4d00c0-c013-11f0-b813-c7fded1d88f0', 'b9ac9040-c00c-11f0-90c5-f561d51de85d', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 'Ciboulette thai', '4015', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":false},{"nom":"Botte de 100g","quantite":0.1,"unite":"kg","utilise_commande":false,"utilise_stock":true}]', 0, 22.999999999999996, 5.5, 'kg', 1, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '6d4d00c0-c013-11f0-b813-c7fded1d88f0' WHERE id = '6d016550-6fd4-11eb-a4bf-c58d44f967d3';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('80505e70-593a-11ee-b8cb-edf41630f056', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 'Ciboulette barquette', '877534', 'Frais', '[{"nom":"au kilogramme ","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Barquette de 200g","quantite":0.2,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 5.388, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '80505e70-593a-11ee-b8cb-edf41630f056' WHERE id = '6d016550-6fd4-11eb-a4bf-c58d44f967d3';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('c838bbd4-6fcb-11eb-9165-0a5bf521835e', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 'Ciboulette', '837666', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Botte de 100g","quantite":0.1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 2.3, 5.5, 'kg', 1, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'c838bbd4-6fcb-11eb-9165-0a5bf521835e' WHERE id = '6d016550-6fd4-11eb-a4bf-c58d44f967d3';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('6f3bbf10-e30a-11f0-8ad5-9f10da4daf34', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '6be24a70-da70-11f0-8612-8be369b626f7', 'Bobine Dévidage Central 450 F', '416931', 'Hygiène', '[{"nom":"bobine","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 6","quantite":6,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 13.05, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '6f3bbf10-e30a-11f0-8ad5-9f10da4daf34' WHERE id = '6be24a70-da70-11f0-8612-8be369b626f7';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('776ddfa0-2607-11ee-a9c5-919e3d735654', '9a3280e0-2152-11ee-888e-8daad14c2966', '6be24a70-da70-11f0-8612-8be369b626f7', 'Bobine Dévidage Central 450 F', '559244', 'Hygiène', '[{"nom":"bobine","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 6","quantite":6,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 10.93, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '776ddfa0-2607-11ee-a9c5-919e3d735654' WHERE id = '6be24a70-da70-11f0-8612-8be369b626f7';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('51857d10-ed42-11ec-92c5-b70a8da9dfee', '7634b460-f526-11eb-9855-6d337dfcae57', '70a95120-fb76-11ec-82ff-e103d8d6432f', 'Sirop Hibiscus', '115252C6', 'Boissons', '[{"nom":"L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"carton de 6 btl de 1L","quantite":6,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 41.21, 5.5, 'L', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '51857d10-ed42-11ec-92c5-b70a8da9dfee' WHERE id = '70a95120-fb76-11ec-82ff-e103d8d6432f';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('b7352d20-c26e-11ed-9c70-752f0462a215', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '70a95120-fb76-11ec-82ff-e103d8d6432f', 'Sirop Hibiscus Routin', '115252', 'Boissons', '[{"nom":"L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 6 bouteilles de 1L","quantite":6,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 49.71, 5.5, 'L', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'b7352d20-c26e-11ed-9c70-752f0462a215' WHERE id = '70a95120-fb76-11ec-82ff-e103d8d6432f';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('26fbd380-0dab-11ed-88b9-5dbed728ece1', '7634b460-f526-11eb-9855-6d337dfcae57', '6ee353a0-fb75-11ec-86ff-13fce83436c9', 'Sirop kumquat', 'Non défini', 'Boissons', '[{"nom":"L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 6 x 2,5kg","quantite":15,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 94, 5.5, 'L', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '26fbd380-0dab-11ed-88b9-5dbed728ece1' WHERE id = '6ee353a0-fb75-11ec-86ff-13fce83436c9';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('4f54b180-f852-11ec-82ff-e103d8d6432f', '7634b460-f526-11eb-9855-6d337dfcae57', '6ee353a0-fb75-11ec-86ff-13fce83436c9', 'Sirop kumquat', 'Non défini', 'Boissons', '[{"nom":"L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"Bidon de 2,5kg","quantite":2.5,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 17.3, 5.5, 'L', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '4f54b180-f852-11ec-82ff-e103d8d6432f' WHERE id = '6ee353a0-fb75-11ec-86ff-13fce83436c9';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('ffbf3440-b19f-11ec-bfd2-fd896e4df82b', '8f9ce920-47e9-11ec-939f-314f99801403', '77aa7da0-7d49-11ed-9124-af8ed14a816a', 'Carte de Visite Restaurant (5,7x8,7)| 500pcs', 'Non défini', 'Marketing', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Pack de 500 pcs","quantite":500,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 30.2, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'ffbf3440-b19f-11ec-bfd2-fd896e4df82b' WHERE id = '77aa7da0-7d49-11ed-9124-af8ed14a816a';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('7620d670-c310-11ed-9637-2ff9d0f68a96', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '76aa31a0-2370-11f0-8b17-c9ef36ffc4e8', 'Thé rooibos vanille - KUSMI', '117131', 'Epicerie', '[{"nom":"Sachet de 2 g ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Paquet de 25 sachets de thés","quantite":25,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 10.67, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '7620d670-c310-11ed-9637-2ff9d0f68a96' WHERE id = '76aa31a0-2370-11f0-8b17-c9ef36ffc4e8';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('cd430280-b19f-11ec-9e3a-439a76807f2c', '8f9ce920-47e9-11ec-939f-314f99801403', '74a7fbc0-5146-11ed-b50c-474f649a5bc5', 'Badge formation (6,6x6,6)| 10 pcs', 'Non défini', 'Marketing', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Pack de 10 pcs","quantite":10,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 26.77, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'cd430280-b19f-11ec-9e3a-439a76807f2c' WHERE id = '74a7fbc0-5146-11ed-b50c-474f649a5bc5';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('aeb03640-46c9-11f0-b470-7b9ac5f9ae96', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '6f6abe40-4e2f-11ee-9a37-c1fb9a9e60bd', 'Crevettes décortiquées crues 31/40', '227574', 'Surgelés', '[{"nom":"sachet","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 10 sachets (10x800g)","quantite":10,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 7.897, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'aeb03640-46c9-11f0-b470-7b9ac5f9ae96' WHERE id = '6f6abe40-4e2f-11ee-9a37-c1fb9a9e60bd';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('c2691a50-4bf6-11ee-bbcb-694f2f8eac78', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '791cdaa0-4d84-11ee-bde1-5fde63a70b93', 'Crème Glacée Miel et Noisettes Caramélisées - Atelier des écrins', '301703', 'Surgelés', '[{"nom":"Pot de glace ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Pots de glace miel et noisettes","quantite":15,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 25.17, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'c2691a50-4bf6-11ee-bbcb-694f2f8eac78' WHERE id = '791cdaa0-4d84-11ee-bde1-5fde63a70b93';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('59d1a680-bdef-11ef-b1d2-cb85c75371d6', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '79da2e70-bdef-11ef-be99-f72f1fb7b2f1', 'Curry Jaune madras', '16026', 'Epicerie', '[{"nom":"poche de 1kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 0, 4.39, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '59d1a680-bdef-11ef-b1d2-cb85c75371d6' WHERE id = '79da2e70-bdef-11ef-be99-f72f1fb7b2f1';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('aac19d40-b19d-11ec-bda3-cd386d3f96f0', '8f9ce920-47e9-11ec-939f-314f99801403', '7dc74cc0-5145-11ed-ae1b-9d995079b109', 'A - Enveloppe caisse (210x110)| 500pcs', 'Non défini', 'Marketing', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Pack de 500 pcs","quantite":500,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 65.06, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'aac19d40-b19d-11ec-bda3-cd386d3f96f0' WHERE id = '7dc74cc0-5145-11ed-ae1b-9d995079b109';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('10f22900-6759-11ee-bdbd-3b34d06af2a8', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '7dac17b0-6757-11ee-a127-bd5aba4de5fc', 'Jus Detox Pomme Mangue KOOKABARRA', '199411', 'Frais', '[{"nom":"Bouteille 25cl","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"CTN 24 btl","quantite":24,"unite":"unite","utilise_commande":true,"utilise_stock":false},{"nom":"Colis x30 bouteilles","quantite":30,"unite":"unite","utilise_commande":false,"utilise_stock":false}]', 1, 1.638, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '10f22900-6759-11ee-bdbd-3b34d06af2a8' WHERE id = '7dac17b0-6757-11ee-a127-bd5aba4de5fc';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('365d0480-6759-11ee-bdbd-3b34d06af2a8', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '7dac17b0-6757-11ee-a127-bd5aba4de5fc', 'Jus Detox Pomme Menthe Citron KOOKABARRA', '508288', 'Frais', '[{"nom":"Bouteille 25cl","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"CTN 24 btl","quantite":24,"unite":"unite","utilise_commande":true,"utilise_stock":false},{"nom":"Colis x30 bouteilles","quantite":30,"unite":"unite","utilise_commande":false,"utilise_stock":false}]', 1, 1.638, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '365d0480-6759-11ee-bdbd-3b34d06af2a8' WHERE id = '7dac17b0-6757-11ee-a127-bd5aba4de5fc';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('8062b6c0-6758-11ee-8c4e-9599e555ef72', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '7dac17b0-6757-11ee-a127-bd5aba4de5fc', 'Jus Detox Pomme Carotte KOOKABARRA', '508287', 'Frais', '[{"nom":"Bouteille 25cl","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"CTN 24 btl","quantite":24,"unite":"unite","utilise_commande":true,"utilise_stock":false},{"nom":"Colis x30 bouteilles","quantite":30,"unite":"unite","utilise_commande":false,"utilise_stock":false}]', 1, 1.638, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '8062b6c0-6758-11ee-8c4e-9599e555ef72' WHERE id = '7dac17b0-6757-11ee-a127-bd5aba4de5fc';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('f2e17970-6758-11ee-870e-654dc74c5195', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '7dac17b0-6757-11ee-a127-bd5aba4de5fc', 'Jus Detox Pomme Fruits Rouges KOOKABARRA', '199410', 'Frais', '[{"nom":"Bouteille 25cl","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"CTN 24 btl","quantite":24,"unite":"unite","utilise_commande":true,"utilise_stock":false},{"nom":"Colis x30 bouteilles","quantite":30,"unite":"unite","utilise_commande":false,"utilise_stock":false}]', 1, 1.638, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'f2e17970-6758-11ee-870e-654dc74c5195' WHERE id = '7dac17b0-6757-11ee-a127-bd5aba4de5fc';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('0a314c00-484c-11ec-919a-17e2ac44051f', '8f9ce920-47e9-11ec-939f-314f99801403', '7d3cb780-c9ca-11eb-b7f7-8b9a3a648073', 'A - Stickers bubble tea (7,5x7,5)| 5000pcs', NULL, 'Emballages', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Sachet de 5000 pcs","quantite":5000,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 297.99, 20, 'unite', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '0a314c00-484c-11ec-919a-17e2ac44051f' WHERE id = '7d3cb780-c9ca-11eb-b7f7-8b9a3a648073';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('1b23ea90-5092-11ee-a38b-7d8eb0ef0f5b', '8f9ce920-47e9-11ec-939f-314f99801403', '7d3cb780-c9ca-11eb-b7f7-8b9a3a648073', 'A - Stickers bubble tea (5,5x8,5)| 5000pcs', 'Non défini', 'Marketing', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Pack de 5000 pcs","quantite":5000,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 241.66, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '1b23ea90-5092-11ee-a38b-7d8eb0ef0f5b' WHERE id = '7d3cb780-c9ca-11eb-b7f7-8b9a3a648073';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('27c614d0-484c-11ec-919a-17e2ac44051f', '8f9ce920-47e9-11ec-939f-314f99801403', '7d3cb780-c9ca-11eb-b7f7-8b9a3a648073', 'A - Stickers bubble tea (7,5x7,5)| 10000pcs', NULL, 'Emballages', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Sachet de 10000 pcs","quantite":10000,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 538.25, 20, 'unite', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '27c614d0-484c-11ec-919a-17e2ac44051f' WHERE id = '7d3cb780-c9ca-11eb-b7f7-8b9a3a648073';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('56b00400-5091-11ee-a11c-879e50f89dbc', '8f9ce920-47e9-11ec-939f-314f99801403', '7d3cb780-c9ca-11eb-b7f7-8b9a3a648073', ' A - Stickers bubble tea (5,5X8,5)| 10000pcs', 'Non défini', 'Marketing', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Pack de 10000 pcs","quantite":10000,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 421.71, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '56b00400-5091-11ee-a11c-879e50f89dbc' WHERE id = '7d3cb780-c9ca-11eb-b7f7-8b9a3a648073';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('66470800-c9ca-11eb-a089-793741e15315', 'e1451f2a-9f72-11ea-8f40-0a5bf521835e', '7d3cb780-c9ca-11eb-b7f7-8b9a3a648073', 'Sticker rond gobelet BBT « fresh & tasty »', NULL, 'Emballages', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Carton 2500 pcs","quantite":2500,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 85, 5.5, 'unite', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '66470800-c9ca-11eb-a089-793741e15315' WHERE id = '7d3cb780-c9ca-11eb-b7f7-8b9a3a648073';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('e175fc70-5091-11ee-bb90-af5f6f525e4f', '8f9ce920-47e9-11ec-939f-314f99801403', '7d3cb780-c9ca-11eb-b7f7-8b9a3a648073', 'A - Stickers bubble tea (5,5x8,5)| 2000pcs', 'Non défini', 'Marketing', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Pack de 2000 pcs","quantite":2000,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 129.84, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'e175fc70-5091-11ee-bb90-af5f6f525e4f' WHERE id = '7d3cb780-c9ca-11eb-b7f7-8b9a3a648073';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('e56102d0-484b-11ec-a380-e70d5f8a58f8', '8f9ce920-47e9-11ec-939f-314f99801403', '7d3cb780-c9ca-11eb-b7f7-8b9a3a648073', 'A - Stickers bubble tea (7,5x7,5)| 2000pcs', NULL, 'Emballages', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Sachet de 2000 pcs","quantite":2000,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 151.79, 20, 'unite', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'e56102d0-484b-11ec-a380-e70d5f8a58f8' WHERE id = '7d3cb780-c9ca-11eb-b7f7-8b9a3a648073';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('46e14fee-5110-11eb-b1d7-0a5bf521835e', 'd69710e0-f469-11eb-8fb0-df4c06cfdb0d', '78f6cb20-e3ce-11eb-be8e-9f30aafccd7a', 'Tien Giang 70% grande', NULL, 'Epicerie', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"carton de 10 x 80g","quantite":25,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 30, 5.5, 'unite', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '46e14fee-5110-11eb-b1d7-0a5bf521835e' WHERE id = '78f6cb20-e3ce-11eb-be8e-9f30aafccd7a';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('be8db6c0-1f05-11ee-8289-e38a95489b1f', '60bb1420-c0a6-11ec-959c-5b5037aeef23', '808921ea-9c4d-11ea-9262-0a5bf521835e', 'Couvercle Bol Normal Phood', 'PHOODCOUV1000', 'Emballages', '[{"nom":"Couvercle Normal Phood (300)","quantite":300,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 0, 37.17, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'be8db6c0-1f05-11ee-8289-e38a95489b1f' WHERE id = '808921ea-9c4d-11ea-9262-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('90b0f5a0-f5fe-11f0-95c8-3320934f4151', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '80891f2e-9c4d-11ea-925f-0a5bf521835e', 'Sac Crois Kbr', '324336', 'Emballages', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 1000pcs","quantite":1000,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 9.55, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '90b0f5a0-f5fe-11f0-95c8-3320934f4151' WHERE id = '80891f2e-9c4d-11ea-925f-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('d96dc880-ad46-11ed-bbe2-95ec3a5d1c86', '60bb1420-c0a6-11ec-959c-5b5037aeef23', '80891f2e-9c4d-11ea-925f-0a5bf521835e', 'Sachet Kraft Dessert', '372110', 'Emballages', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 1000pcs","quantite":1000,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 16, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'd96dc880-ad46-11ed-bbe2-95ec3a5d1c86' WHERE id = '80891f2e-9c4d-11ea-925f-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('92892dc0-c0b5-11ec-89a7-89ef3d1d3970', '60bb1420-c0a6-11ec-959c-5b5037aeef23', '80892032-9c4d-11ea-9260-0a5bf521835e', 'Boîte Finger Phood', 'SNACKRICE24OZ', 'Emballages', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 500 pcs","quantite":500,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 52, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '92892dc0-c0b5-11ec-89a7-89ef3d1d3970' WHERE id = '80892032-9c4d-11ea-9260-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('5ebf3c40-1f06-11ee-87d1-1b4f4158f14c', '60bb1420-c0a6-11ec-959c-5b5037aeef23', '808922c6-9c4d-11ea-9263-0a5bf521835e', 'Bol Grand Phood', ' PHOODBOL1200', 'Emballages', '[{"nom":"Bol Grand Phood","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Bol Grand Phood (300)","quantite":300,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 100.49, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '5ebf3c40-1f06-11ee-87d1-1b4f4158f14c' WHERE id = '808922c6-9c4d-11ea-9263-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('bd94c570-e278-11ed-9c42-f5f439c8b680', '60bb1420-c0a6-11ec-959c-5b5037aeef23', '8089212c-9c4d-11ea-9261-0a5bf521835e', 'Bol Normal Phood', 'PHOODBOL1000', 'Emballages', '[{"nom":"Bol Grand ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 300 pcs","quantite":300,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 61.74, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'bd94c570-e278-11ed-9c42-f5f439c8b680' WHERE id = '8089212c-9c4d-11ea-9261-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('51b433e0-1302-11ed-862a-79c14d6f9b65', '60bb1420-c0a6-11ec-959c-5b5037aeef23', '80892532-9c4d-11ea-9266-0a5bf521835e', 'Pot Sauce + Couvercle', 'PETITPO60KR / CVPO60KR', 'Emballages', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 2000pcs","quantite":2000,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 126, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '51b433e0-1302-11ed-862a-79c14d6f9b65' WHERE id = '80892532-9c4d-11ea-9266-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('909a24f0-1f06-11ee-b12d-05cf5a35c135', '60bb1420-c0a6-11ec-959c-5b5037aeef23', '8089238e-9c4d-11ea-9264-0a5bf521835e', 'Couvercle Bol Grand Phood', 'PHOODCOUV1200', 'Emballages', '[{"nom":"Couvercle Bol Grand Phood","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Couvercle Bol Grand Phood (300)","quantite":300,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 52.92, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '909a24f0-1f06-11ee-b12d-05cf5a35c135' WHERE id = '8089238e-9c4d-11ea-9264-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('67920d20-7c8a-11ee-ab72-3fd0ed0819d1', '5ebc88e0-7976-11ee-a1ca-ed4795abb9e6', '80892e92-9c4d-11ea-9271-0a5bf521835e', 'Gant Nitrile Noir M non Poudre', '810299', 'Hygiène', '[{"nom":"Boite de 100 ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Carton de 2 boites (2x100)","quantite":2,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 11.8, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '67920d20-7c8a-11ee-ab72-3fd0ed0819d1' WHERE id = '80892e92-9c4d-11ea-9271-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('03cdc690-c32f-11ed-b116-d7b40111f808', '60bb1420-c0a6-11ec-959c-5b5037aeef23', '80892cda-9c4d-11ea-926f-0a5bf521835e', 'Fourchette Bois 16cm', 'SNACKFOURCHET16', 'Emballages', '[{"nom":"unité ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 1000 pcs","quantite":1000,"unite":"unite","utilise_commande":true,"utilise_stock":true},{"nom":"Colis de 2500 Fourchettes","quantite":2500,"unite":"unite","utilise_commande":false,"utilise_stock":false}]', 1, 24, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '03cdc690-c32f-11ed-b116-d7b40111f808' WHERE id = '80892cda-9c4d-11ea-926f-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('05eb40b0-fd62-11ee-b36f-7f4605808581', '5ebc88e0-7976-11ee-a1ca-ed4795abb9e6', '80892dc0-9c4d-11ea-9270-0a5bf521835e', 'Gant Nitrile Noir L non Poudre', '808902', 'Hygiène', '[{"nom":"Boite de 100 ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Carton de 2 boites (2x100)","quantite":2,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 11.8, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '05eb40b0-fd62-11ee-b36f-7f4605808581' WHERE id = '80892dc0-9c4d-11ea-9270-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('51da08d0-fd62-11ee-86e0-4f416d96d512', '5ebc88e0-7976-11ee-a1ca-ed4795abb9e6', '80892dc0-9c4d-11ea-9270-0a5bf521835e', 'Gant Nitrile Noir XL non Poudre', '812964', 'Hygiène', '[{"nom":"Boite de 100 ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Carton de 2 boites (2x100)","quantite":2,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 11.8, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '51da08d0-fd62-11ee-86e0-4f416d96d512' WHERE id = '80892dc0-9c4d-11ea-9270-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('0f473450-abad-11ed-8a74-879b3a7157e3', '60bb1420-c0a6-11ec-959c-5b5037aeef23', '80892b22-9c4d-11ea-926d-0a5bf521835e', 'Gobelet Café', 'SNACKCUP4OZ', 'Emballages', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 1000 pcs","quantite":1000,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 27, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '0f473450-abad-11ed-8a74-879b3a7157e3' WHERE id = '80892b22-9c4d-11ea-926d-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('ef540100-c0bb-11ec-89ba-0352521d40d9', '60bb1420-c0a6-11ec-959c-5b5037aeef23', '80892c12-9c4d-11ea-926e-0a5bf521835e', 'Cuillère Bois', 'SNACKDESSERT110', 'Emballages', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 2500 pcs","quantite":2500,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 75, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'ef540100-c0bb-11ec-89ba-0352521d40d9' WHERE id = '80892c12-9c4d-11ea-926e-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('2716cfd0-fea8-11ec-a176-d902a1918d35', '60bb1420-c0a6-11ec-959c-5b5037aeef23', '808931ee-9c4d-11ea-9275-0a5bf521835e', 'Serviette Papier 2 plis', 'ST3001-T', 'Emballages', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 4800pcs","quantite":4800,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 63.168, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '2716cfd0-fea8-11ec-a176-d902a1918d35' WHERE id = '808931ee-9c4d-11ea-9275-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('5b6c8bb0-c012-11f0-9568-d18c30eea17c', 'b9ac9040-c00c-11f0-90c5-f561d51de85d', '80893112-9c4d-11ea-9274-0a5bf521835e', 'Baguettes jetable 23cm dragon phénix	', NULL, 'Emballages', '[{"nom":"1","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 2000 baguettes","quantite":2000,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 41.9, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '5b6c8bb0-c012-11f0-9568-d18c30eea17c' WHERE id = '80893112-9c4d-11ea-9274-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('f612d400-4886-11ed-99e0-55f904bebfca', '60bb1420-c0a6-11ec-959c-5b5037aeef23', '80893112-9c4d-11ea-9274-0a5bf521835e', 'Baguettes Personnalisées', 'PHOODBAGUET3', 'Emballages', '[{"nom":"1","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 4000 baguettes","quantite":4000,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 172.2, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'f612d400-4886-11ed-99e0-55f904bebfca' WHERE id = '80893112-9c4d-11ea-9274-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('eef68b18-9f72-11ea-8f81-0a5bf521835e', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '80893658-9c4d-11ea-927a-0a5bf521835e', 'Vermicelles de riz | 5 étoiles', '410052L', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"carton de 30 x 375g","quantite":11.25,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 29.700000000000003, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'eef68b18-9f72-11ea-8f81-0a5bf521835e' WHERE id = '80893658-9c4d-11ea-927a-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('eef68212-9f72-11ea-8f80-0a5bf521835e', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '80893572-9c4d-11ea-9279-0a5bf521835e', 'Pâtes Riz 5mm | My wok', '400272L', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"carton de 10kg","quantite":10,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 30.3, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'eef68212-9f72-11ea-8f80-0a5bf521835e' WHERE id = '80893572-9c4d-11ea-9279-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('74000f00-fd61-11ee-91d7-4daa68ce981b', '5ebc88e0-7976-11ee-a1ca-ed4795abb9e6', '80892f64-9c4d-11ea-9272-0a5bf521835e', 'Gant Nitrile Noir S non Poudre', '811780', 'Hygiène', '[{"nom":"Boite de 100 ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Carton de 2 boites (2x100)","quantite":2,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 11.8, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '74000f00-fd61-11ee-91d7-4daa68ce981b' WHERE id = '80892f64-9c4d-11ea-9272-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('af45b680-06a7-11ed-9205-bb3542156cde', '60bb1420-c0a6-11ec-959c-5b5037aeef23', '808933c4-9c4d-11ea-9277-0a5bf521835e', 'Pot Dessert', 'BOL250ML', 'Emballages', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 500pcs","quantite":500,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 25, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'af45b680-06a7-11ed-9205-bb3542156cde' WHERE id = '808933c4-9c4d-11ea-9277-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('eef69432-9f72-11ea-8f82-0a5bf521835e', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '80893748-9c4d-11ea-927b-0a5bf521835e', 'Nouilles chinoises jaunes | Mont Asie', '400023L', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"carton de 30 x 400g","quantite":12,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 61.2, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'eef69432-9f72-11ea-8f82-0a5bf521835e' WHERE id = '80893748-9c4d-11ea-927b-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('6c6d3460-9af3-11ed-86ae-75b8e0c0e46c', '60bb1420-c0a6-11ec-959c-5b5037aeef23', '808932c0-9c4d-11ea-9276-0a5bf521835e', 'Sacs personnalisés SOS', 'PHOODSOS32', 'Emballages', '[{"nom":"Colis de 250 Sacs Phood personnalisés  ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 250 Sacs Phood personnalisés","quantite":250,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 76, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '6c6d3460-9af3-11ed-86ae-75b8e0c0e46c' WHERE id = '808932c0-9c4d-11ea-9276-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('eef6a5ee-9f72-11ea-8f84-0a5bf521835e', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '808938ec-9c4d-11ea-927d-0a5bf521835e', 'Sauce Soja Petite btl verre | Ong Xen', '200044L', 'Epicerie', '[{"nom":"L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"carton de 24 x 150ml","quantite":3.6,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 15.12, 5.5, 'L', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'eef6a5ee-9f72-11ea-8f84-0a5bf521835e' WHERE id = '808938ec-9c4d-11ea-927d-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('b052dc10-ab7f-11ed-8b0a-c9b99c89577c', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '80893810-9c4d-11ea-927c-0a5bf521835e', 'Riz Parfumé  | ANGKOR', '100032L-fév 23', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"sac de 20kg","quantite":20,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 29.48, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'b052dc10-ab7f-11ed-8b0a-c9b99c89577c' WHERE id = '80893810-9c4d-11ea-927c-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('b49b0d10-c012-11f0-aa3b-ef2b4b2ddd30', 'b9ac9040-c00c-11f0-90c5-f561d51de85d', '80893810-9c4d-11ea-927c-0a5bf521835e', 'Riz Parfumé  | CAMBODGE', NULL, 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"sac de 18kg","quantite":18,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 27.9, 5.5, 'kg', 10, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'b49b0d10-c012-11f0-aa3b-ef2b4b2ddd30' WHERE id = '80893810-9c4d-11ea-927c-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('eef6d294-9f72-11ea-8f89-0a5bf521835e', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '80893d1a-9c4d-11ea-9282-0a5bf521835e', 'Oignons Frits', '400276L', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"carton de 4 x 2,5kg","quantite":10,"unite":"kg","utilise_commande":true,"utilise_stock":false}]', 1, 54.56, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'eef6d294-9f72-11ea-8f89-0a5bf521835e' WHERE id = '80893d1a-9c4d-11ea-9282-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('eef6c0d8-9f72-11ea-8f87-0a5bf521835e', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '80893b6c-9c4d-11ea-9280-0a5bf521835e', 'Sauce Sriracha | 5 étoiles', '200023L', 'Epicerie', '[{"nom":"L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"carton de 12 x 455ml","quantite":5.46,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 21.96, 5.5, 'L', 2, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'eef6c0d8-9f72-11ea-8f87-0a5bf521835e' WHERE id = '80893b6c-9c4d-11ea-9280-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('eef6c9c0-9f72-11ea-8f88-0a5bf521835e', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 'Cacahuètes Grillées non salées', '400199L', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"carton de 20 x 1kg","quantite":20,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 94.4, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'eef6c9c0-9f72-11ea-8f88-0a5bf521835e' WHERE id = '80893c3e-9c4d-11ea-9281-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('b509a900-5bdb-11f0-a3fd-b73fb17c463d', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '80893de2-9c4d-11ea-9283-0a5bf521835e', 'Frites De Patates Douce ', '302147', 'Surgelés', '[{"nom":" kilogramme","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Sachets  de 2,5 kg","quantite":2.5,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"CTN de 4 sachets de 2,5kg","quantite":4,"unite":"kg","utilise_commande":true,"utilise_stock":false}]', 2, 11.827, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'b509a900-5bdb-11f0-a3fd-b73fb17c463d' WHERE id = '80893de2-9c4d-11ea-9283-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('74e2d3d0-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '808944cc-9c4d-11ea-928b-0a5bf521835e', 'Cookie Pépites de Chocolat', '213327', 'Surgelés', '[{"nom":"cookie","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 90 cookies","quantite":90,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 69.564, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '74e2d3d0-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '808944cc-9c4d-11ea-928b-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('9ed89d14-6fcf-11eb-8307-0a5bf521835e', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '808970d2-9c4d-11ea-928e-0a5bf521835e', 'Preparation Pannacotta | Debic', '054676', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Bouteille de 1L","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 6.93, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '9ed89d14-6fcf-11eb-8307-0a5bf521835e' WHERE id = '808970d2-9c4d-11ea-928e-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('a30cfd10-9538-11f0-93c7-cf854843b3c9', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '808943f0-9c4d-11ea-928a-0a5bf521835e', 'Coulis exotique', '898651', 'Surgelés', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"flacon de 500g","quantite":0.5,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 3.81, 5.5, 'kg', 5, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'a30cfd10-9538-11f0-93c7-cf854843b3c9' WHERE id = '808943f0-9c4d-11ea-928a-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('d6e52be0-fc4c-11ec-87d3-cf5d212ef325', '25131b20-fc38-11ec-a176-d902a1918d35', '808943f0-9c4d-11ea-928a-0a5bf521835e', 'Coulis fruits exotiques', '490060', 'Surgelés', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Bouteille de 500g","quantite":0.5,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 4.25, 5.5, 'kg', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'd6e52be0-fc4c-11ec-87d3-cf5d212ef325' WHERE id = '808943f0-9c4d-11ea-928a-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('eef7d482-9f72-11ea-8fa7-0a5bf521835e', 'e1451f2a-9f72-11ea-8f40-0a5bf521835e', '80897442-9c4d-11ea-9292-0a5bf521835e', 'Rooibos', NULL, 'Epicerie', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"boîte de 4 x 20 sachets","quantite":80,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 10.52, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'eef7d482-9f72-11ea-8fa7-0a5bf521835e' WHERE id = '80897442-9c4d-11ea-9292-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('eef7c280-9f72-11ea-8fa5-0a5bf521835e', 'e1451f2a-9f72-11ea-8f40-0a5bf521835e', '80897280-9c4d-11ea-9290-0a5bf521835e', 'Thé Vert Menthe Vietnam', NULL, 'Epicerie', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"boîte de 4 x 20 sachets","quantite":80,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 10.96, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'eef7c280-9f72-11ea-8fa5-0a5bf521835e' WHERE id = '80897280-9c4d-11ea-9290-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('523048b0-c27d-11ed-8f98-af22ee5cd631', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '80897a3c-9c4d-11ea-9296-0a5bf521835e', 'Pailles XXL papier blanc', '126305', 'Emballages', '[{"nom":"Pièces","quantite":100,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 15*100","quantite":1500,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 75.6, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '523048b0-c27d-11ed-8f98-af22ee5cd631' WHERE id = '80897a3c-9c4d-11ea-9296-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('2361c390-06aa-11ed-9205-bb3542156cde', '60bb1420-c0a6-11ec-959c-5b5037aeef23', '80897b0e-9c4d-11ea-9297-0a5bf521835e', 'Gobelet Bubble Tea', 'GOBRPET16OZ', 'Emballages', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 1000pcs","quantite":1000,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 104, 5.5, 'unite', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '2361c390-06aa-11ed-9205-bb3542156cde' WHERE id = '80897b0e-9c4d-11ea-9297-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('4c4ff7e0-6365-11ee-8afe-5f3f986536c7', '60bb1420-c0a6-11ec-959c-5b5037aeef23', '80897b0e-9c4d-11ea-9297-0a5bf521835e', 'Gobelet BBT kraft Brun', ' PHOOD16OZ', 'Emballages', '[{"nom":"Unité","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 1000 gobelets","quantite":1000,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 79, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '4c4ff7e0-6365-11ee-8afe-5f3f986536c7' WHERE id = '80897b0e-9c4d-11ea-9297-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('c0606730-c27c-11ed-8f4c-e7d4ca882d17', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '80897bea-9c4d-11ea-9298-0a5bf521835e', 'Creamer', '126020', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 12 x 1kg","quantite":12,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 117.09, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'c0606730-c27c-11ed-8f4c-e7d4ca882d17' WHERE id = '80897bea-9c4d-11ea-9298-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('469cb170-c280-11ed-92b2-dd1a9b9b6635', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '80897cbc-9c4d-11ea-9299-0a5bf521835e', 'Film scellage gobelets PP', '126361', 'Emballages', '[{"nom":"rouleau de 4000 pcs","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 6 rlx de 4000 pcs","quantite":6,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 220.96, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '469cb170-c280-11ed-92b2-dd1a9b9b6635' WHERE id = '80897cbc-9c4d-11ea-9299-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('0decd4b0-db30-11eb-8a56-531396142f44', 'c7091860-db2f-11eb-a327-712c3f551ffc', '8089751e-9c4d-11ea-9293-0a5bf521835e', 'Café Vietnamien en grains', 'Non défini', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"carton de 5kg","quantite":5,"unite":"kg","utilise_commande":true,"utilise_stock":true},{"nom":"Pack de 3 cartons de 5 kg","quantite":15,"unite":"kg","utilise_commande":false,"utilise_stock":false}]', 1, 85, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '0decd4b0-db30-11eb-8a56-531396142f44' WHERE id = '8089751e-9c4d-11ea-9293-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('a0026270-b19f-11ec-9e3a-439a76807f2c', '8f9ce920-47e9-11ec-939f-314f99801403', '80897960-9c4d-11ea-9295-0a5bf521835e', 'A - Flyers Valeurs Version Français (14.8x21) | 2500pcs', 'Non défini', 'Marketing', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Pack de 2500 pcs","quantite":2500,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 95.05, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'a0026270-b19f-11ec-9e3a-439a76807f2c' WHERE id = '80897960-9c4d-11ea-9295-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('a89a3e80-b19f-11ec-9e3a-439a76807f2c', '8f9ce920-47e9-11ec-939f-314f99801403', '80897960-9c4d-11ea-9295-0a5bf521835e', 'A - Flyers Valeurs Version Français (14.8x21) | 5000pcs', 'Non défini', 'Marketing', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Pack de 5000 pcs","quantite":5000,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 132.61, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'a89a3e80-b19f-11ec-9e3a-439a76807f2c' WHERE id = '80897960-9c4d-11ea-9295-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('ed1e7c70-b19e-11ec-abb4-9df96e01f8b1', '8f9ce920-47e9-11ec-939f-314f99801403', '80897960-9c4d-11ea-9295-0a5bf521835e', 'A - Flyers Valeurs Version Anglais (14.8x21) | 2500pcs', 'Non défini', 'Marketing', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Pack de 2500 pcs","quantite":2500,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 95.05, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'ed1e7c70-b19e-11ec-abb4-9df96e01f8b1' WHERE id = '80897960-9c4d-11ea-9295-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('f40a5630-b19e-11ec-bda3-cd386d3f96f0', '8f9ce920-47e9-11ec-939f-314f99801403', '80897960-9c4d-11ea-9295-0a5bf521835e', 'A - Flyers Valeurs Version Anglais (14.8x21) | 5000pcs', 'Non défini', 'Marketing', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Pack de 5000 pcs","quantite":5000,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 132.61, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'f40a5630-b19e-11ec-bda3-cd386d3f96f0' WHERE id = '80897960-9c4d-11ea-9295-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('59ed8e20-c27b-11ed-9637-2ff9d0f68a96', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '80897d8e-9c4d-11ea-929a-0a5bf521835e', 'Poudre Taro', '126091', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 12 x 1kg","quantite":12,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 162.14, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '59ed8e20-c27b-11ed-9637-2ff9d0f68a96' WHERE id = '80897d8e-9c4d-11ea-929a-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('fdc0e4c0-c276-11ed-8f98-af22ee5cd631', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '80897f50-9c4d-11ea-929c-0a5bf521835e', 'Perles Tapioca', '126021', 'Epicerie', '[{"nom":"kg","quantite":3,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 6 x 3kg","quantite":18,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 72.27, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'fdc0e4c0-c276-11ed-8f98-af22ee5cd631' WHERE id = '80897f50-9c4d-11ea-929c-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('2036ea60-6e9f-11ef-b27f-59f52e572a8e', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '80899b48-9c4d-11ea-92a2-0a5bf521835e', 'Marinade Poulet Pop Corn', 'PHD008', 'Ingredients Exclusifs', '[{"nom":"Bidon 5kg","quantite":5,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"carton de 4 bidons 5kg","quantite":4,"unite":"kg","utilise_commande":true,"utilise_stock":false}]', 1, 29.16, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '2036ea60-6e9f-11ef-b27f-59f52e572a8e' WHERE id = '80899b48-9c4d-11ea-92a2-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('84b8e540-c277-11ed-af3b-01e40c7876d2', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '808981d0-9c4d-11ea-929e-0a5bf521835e', 'Perles Mangue - Pop Ball', '126033', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 4 x 3.2kg","quantite":12.8,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 80.14, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '84b8e540-c277-11ed-af3b-01e40c7876d2' WHERE id = '808981d0-9c4d-11ea-929e-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('55183520-c277-11ed-af3b-01e40c7876d2', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '80898022-9c4d-11ea-929d-0a5bf521835e', 'Perles Litchi - Pop Ball', '126032', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Colis  de 4 x 3.2kg","quantite":12.8,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 80.14, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '55183520-c277-11ed-af3b-01e40c7876d2' WHERE id = '80898022-9c4d-11ea-929d-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('4ae63130-6e9f-11ef-aa8d-49d01137f0e0', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '80899d1e-9c4d-11ea-92a4-0a5bf521835e', 'Sauce Boeuf Citronnelle', 'PHD009', 'Ingredients Exclusifs', '[{"nom":"Bidon","quantite":5.8,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"carton de 2 bidons 5kg","quantite":2,"unite":"kg","utilise_commande":true,"utilise_stock":false}]', 1, 36.8, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '4ae63130-6e9f-11ef-aa8d-49d01137f0e0' WHERE id = '80899d1e-9c4d-11ea-92a4-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('7b8a6ea0-6e9f-11ef-8591-45603fef0bf6', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '80899df0-9c4d-11ea-92a5-0a5bf521835e', 'Sauce Poulet Gingembre', 'PHD013', 'Ingredients Exclusifs', '[{"nom":"Bidon","quantite":5.8,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"carton de 2 bidons 5kg","quantite":2,"unite":"kg","utilise_commande":true,"utilise_stock":false}]', 1, 38.07, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '7b8a6ea0-6e9f-11ef-8591-45603fef0bf6' WHERE id = '80899df0-9c4d-11ea-92a5-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('5a4ee4f0-6e9f-11ef-817f-c10ed87c4957', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '80899ef4-9c4d-11ea-92a6-0a5bf521835e', 'Sauce Ga Kho', 'PHD010', 'Ingredients Exclusifs', '[{"nom":"Bidon","quantite":5.8,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"carton de 2 bidons 5kg","quantite":2,"unite":"kg","utilise_commande":true,"utilise_stock":false}]', 1, 27.24, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '5a4ee4f0-6e9f-11ef-817f-c10ed87c4957' WHERE id = '80899ef4-9c4d-11ea-92a6-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('68568210-6e9f-11ef-a924-0769a51e15d2', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '80899fda-9c4d-11ea-92a7-0a5bf521835e', 'Sauce Mixao', 'PHD011', 'Ingredients Exclusifs', '[{"nom":"Bidon","quantite":5.8,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"carton de 2 bidons 5kg","quantite":2,"unite":"kg","utilise_commande":true,"utilise_stock":false}]', 1, 31.84, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '68568210-6e9f-11ef-a924-0769a51e15d2' WHERE id = '80899fda-9c4d-11ea-92a7-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('38304e40-6e9f-11ef-b4d6-f53cbeed09eb', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '8089a1ba-9c4d-11ea-92a9-0a5bf521835e', 'Sauce Pad Thai', 'PHD014', 'Ingredients Exclusifs', '[{"nom":"Bidon","quantite":5.8,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"carton de 2 bidons 5kg","quantite":2,"unite":"kg","utilise_commande":true,"utilise_stock":false}]', 1, 34.32, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '38304e40-6e9f-11ef-b4d6-f53cbeed09eb' WHERE id = '8089a1ba-9c4d-11ea-92a9-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('9fe50810-6e9e-11ef-9f86-dbdfe37d425a', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '8089a0c0-9c4d-11ea-92a8-0a5bf521835e', 'Sauce Nuoc Mam Vrac', 'PHD007', 'Ingredients Exclusifs', '[{"nom":"Bidon","quantite":5,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"carton de 4 bidons 5kg","quantite":4,"unite":"kg","utilise_commande":true,"utilise_stock":false}]', 1, 16.35, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '9fe50810-6e9e-11ef-9f86-dbdfe37d425a' WHERE id = '8089a0c0-9c4d-11ea-92a8-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('c5df2c90-16b2-11ec-b40e-9bd684c98d3f', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '8089a462-9c4d-11ea-92ac-0a5bf521835e', 'Dosette sauce piment | Flying Goose', '8212', 'Epicerie', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"carton de 6 x 200 pcs de 8ml","quantite":1200,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 121.38, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'c5df2c90-16b2-11ec-b40e-9bd684c98d3f' WHERE id = '8089a462-9c4d-11ea-92ac-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('03b3b2c0-fc59-11ec-a176-d902a1918d35', '25131b20-fc38-11ec-a176-d902a1918d35', '8089b3ee-9c4d-11ea-92be-0a5bf521835e', 'Menthe', '929186', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 30g","quantite":0.03,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 1.104, 5.5, 'kg', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '03b3b2c0-fc59-11ec-a176-d902a1918d35' WHERE id = '8089b3ee-9c4d-11ea-92be-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('141d3530-af6c-11ec-9124-93672fb74e7a', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089b3ee-9c4d-11ea-92be-0a5bf521835e', 'Menthe', '837679', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Sachet de 100g","quantite":0.1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 2.35, 5.5, 'kg', 10, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '141d3530-af6c-11ec-9124-93672fb74e7a' WHERE id = '8089b3ee-9c4d-11ea-92be-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('3818a4b0-8979-11ec-86f8-370a6b20aba2', 'ea564a80-8977-11ec-8ce1-c32a63dfe765', '8089b3ee-9c4d-11ea-92be-0a5bf521835e', 'Menthe', NULL, 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Sachet de 1kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 7.5, 5.5, 'kg', 30, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '3818a4b0-8979-11ec-86f8-370a6b20aba2' WHERE id = '8089b3ee-9c4d-11ea-92be-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('75536ff0-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '8089b3ee-9c4d-11ea-92be-0a5bf521835e', 'Menthe barquette', '877532', 'Frais', '[{"nom":"au kilogramme","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Barquette de 200 g ","quantite":0.2,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 5.827, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '75536ff0-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '8089b3ee-9c4d-11ea-92be-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('9d4cd2c0-c011-11f0-aa3b-ef2b4b2ddd30', 'b9ac9040-c00c-11f0-90c5-f561d51de85d', '8089b3ee-9c4d-11ea-92be-0a5bf521835e', 'Menthe', '4001', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":false},{"nom":"Sachet de 100g","quantite":0.1,"unite":"kg","utilise_commande":false,"utilise_stock":true}]', 0, 0.99, 5.5, 'kg', 10, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '9d4cd2c0-c011-11f0-aa3b-ef2b4b2ddd30' WHERE id = '8089b3ee-9c4d-11ea-92be-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('0baa69e0-c011-11f0-8e50-279a93fee7a7', 'b9ac9040-c00c-11f0-90c5-f561d51de85d', '8089b4ca-9c4d-11ea-92bf-0a5bf521835e', 'Citron Vert', '3020', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true},{"nom":"colis de 1kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false}]', 0, 2.59, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '0baa69e0-c011-11f0-8e50-279a93fee7a7' WHERE id = '8089b4ca-9c4d-11ea-92bf-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('75460270-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '8089b4ca-9c4d-11ea-92bf-0a5bf521835e', 'Citron vert ', '422721', 'Frais', '[{"nom":"Filet de 1 kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 0, 5.823, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '75460270-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '8089b4ca-9c4d-11ea-92bf-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('eef9b7d4-9f72-11ea-8fdb-0a5bf521835e', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089b4ca-9c4d-11ea-92bf-0a5bf521835e', 'Citron Vert', '106067', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"colis de 1kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 3.35, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'eef9b7d4-9f72-11ea-8fdb-0a5bf521835e' WHERE id = '8089b4ca-9c4d-11ea-92bf-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('755dd030-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 'Oignon Rouge ', '966186', 'Epicerie', '[{"nom":"au kilogramme","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 5 kg","quantite":5,"unite":"kg","utilise_commande":true,"utilise_stock":false}]', 1, 1.228, 5.5, 'kg', 20, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '755dd030-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '8089b5ba-9c4d-11ea-92c0-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('c867f500-c225-11f0-a3df-c90ddadfd362', 'b9ac9040-c00c-11f0-90c5-f561d51de85d', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 'Oignon Rouge ', '2110', 'Epicerie', '[{"nom":"au kilogramme","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 0, 1.29, 5.5, 'kg', 20, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'c867f500-c225-11f0-a3df-c90ddadfd362' WHERE id = '8089b5ba-9c4d-11ea-92c0-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('eef9c0c6-9f72-11ea-8fdc-0a5bf521835e', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 'Oignons Rouges', '079875', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"sac de 5kg","quantite":5,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 1.95, 5.5, 'kg', 20, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'eef9c0c6-9f72-11ea-8fdc-0a5bf521835e' WHERE id = '8089b5ba-9c4d-11ea-92c0-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('75e4b370-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '8089b696-9c4d-11ea-92c1-0a5bf521835e', 'Poivre Noir Moulu ', '300519', 'Epicerie', '[{"nom":"Sachet de 1 kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true},{"nom":"Colis de 10 sachets","quantite":10,"unite":"kg","utilise_commande":false,"utilise_stock":false}]', 0, 15.326, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '75e4b370-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '8089b696-9c4d-11ea-92c1-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('eef9c990-9f72-11ea-8fdd-0a5bf521835e', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089b696-9c4d-11ea-92c1-0a5bf521835e', 'Poivre Noir moulu', '355222', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"pot de 500g","quantite":0.5,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 20.3, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'eef9c990-9f72-11ea-8fdd-0a5bf521835e' WHERE id = '8089b696-9c4d-11ea-92c1-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('1699e700-d44c-11eb-a248-1596e76b7202', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089b312-9c4d-11ea-92bd-0a5bf521835e', 'Coriandre', '837712', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Sachet de 100g","quantite":0.1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 2.35, 5.5, 'kg', 3, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '1699e700-d44c-11eb-a248-1596e76b7202' WHERE id = '8089b312-9c4d-11ea-92bd-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('754f0320-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '8089b312-9c4d-11ea-92bd-0a5bf521835e', 'Coriandre barquette', '877533', 'Frais', '[{"nom":"au kilogramme","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Barquette de 200 g ","quantite":0.2,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 5.868, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '754f0320-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '8089b312-9c4d-11ea-92bd-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('f3abd5e0-c010-11f0-b813-c7fded1d88f0', 'b9ac9040-c00c-11f0-90c5-f561d51de85d', '8089b312-9c4d-11ea-92bd-0a5bf521835e', 'Coriandre', '4005', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":false},{"nom":"Sachet de 100g","quantite":0.1,"unite":"kg","utilise_commande":false,"utilise_stock":true}]', 0, 1.29, 5.5, 'kg', 3, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'f3abd5e0-c010-11f0-b813-c7fded1d88f0' WHERE id = '8089b312-9c4d-11ea-92bd-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('14879be0-baf9-11f0-aa84-c9d116a3a725', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '8089b16e-9c4d-11ea-92bb-0a5bf521835e', 'Eau neuve plate - 33cl', '000002P24', 'Boissons', '[{"nom":"canette","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"24 canettes de 33 cl","quantite":24,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 0.698, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '14879be0-baf9-11f0-aa84-c9d116a3a725' WHERE id = '8089b16e-9c4d-11ea-92bb-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('e67293c0-fc4e-11ec-86ff-13fce83436c9', '25131b20-fc38-11ec-a176-d902a1918d35', '8089b16e-9c4d-11ea-92bb-0a5bf521835e', 'Eau plate - Cristaline', '410605', 'Boissons', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 24 x 50cl","quantite":24,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 4, 5.5, 'unite', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'e67293c0-fc4e-11ec-86ff-13fce83436c9' WHERE id = '8089b16e-9c4d-11ea-92bb-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('c613fda0-baf8-11f0-9f94-ab7add288166', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089b236-9c4d-11ea-92bc-0a5bf521835e', 'Cristalline pétillante - 33CL', '215539', 'Boissons', '[{"nom":"canette","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"6 canettes de 33 cl","quantite":6,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 0.36166666666666664, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'c613fda0-baf8-11f0-9f94-ab7add288166' WHERE id = '8089b236-9c4d-11ea-92bc-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('d51085a0-cece-11f0-a7de-e7dbeaa70084', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '8089b236-9c4d-11ea-92bc-0a5bf521835e', 'Eau minérale pétillante - 33cl', '000242P24', 'Boissons', '[{"nom":"canette","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"24 canettes de 33 cl","quantite":24,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 0.8120833333333333, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'd51085a0-cece-11f0-a7de-e7dbeaa70084' WHERE id = '8089b236-9c4d-11ea-92bc-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('139c7680-fc5a-11ec-82ff-e103d8d6432f', '25131b20-fc38-11ec-a176-d902a1918d35', '8089b772-9c4d-11ea-92c2-0a5bf521835e', 'Paprika', '300511', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 1kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 5.4, 5.5, 'kg', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '139c7680-fc5a-11ec-82ff-e103d8d6432f' WHERE id = '8089b772-9c4d-11ea-92c2-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('75e109f0-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '8089b772-9c4d-11ea-92c2-0a5bf521835e', 'Paprika Moulu Doux', '300511', 'Epicerie', '[{"nom":"Sachet de 1 kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true},{"nom":"Colis de 10 Sachets","quantite":10,"unite":"kg","utilise_commande":false,"utilise_stock":true}]', 0, 7.41, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '75e109f0-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '8089b772-9c4d-11ea-92c2-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('eef9d264-9f72-11ea-8fde-0a5bf521835e', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089b772-9c4d-11ea-92c2-0a5bf521835e', 'Paprika doux', '328125', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"boite de 500g","quantite":0.5,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 13.02, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'eef9d264-9f72-11ea-8fde-0a5bf521835e' WHERE id = '8089b772-9c4d-11ea-92c2-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('75f184b0-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '8089b844-9c4d-11ea-92c3-0a5bf521835e', 'Sucre dose', '822835', 'Epicerie', '[{"nom":"au kilogramme","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 5 kg","quantite":5,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 3.275, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '75f184b0-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '8089b844-9c4d-11ea-92c3-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('24d2dd60-da2b-11eb-8867-4d2f8a397267', '7634b460-f526-11eb-9855-6d337dfcae57', '8089bace-9c4d-11ea-92c6-0a5bf521835e', 'Brisure Oreo x 24 sachets', '112641P', 'Epicerie', '[{"nom":" Brisure Oreo x 24 sachets","quantite":9.6,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 0, 100.56, 5.5, 'kg', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '24d2dd60-da2b-11eb-8867-4d2f8a397267' WHERE id = '8089bace-9c4d-11ea-92c6-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('75bfed60-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '8089bace-9c4d-11ea-92c6-0a5bf521835e', 'Oreo Brisure Biscuit', '940441', 'Epicerie', '[{"nom":"au kilogramme","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"Sachet de 400g ","quantite":0.4,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 4.311, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '75bfed60-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '8089bace-9c4d-11ea-92c6-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('eef9f640-9f72-11ea-8fe2-0a5bf521835e', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089bace-9c4d-11ea-92c6-0a5bf521835e', 'Brisure Oreo', '719621', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"sachet de 400g","quantite":0.4,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 4.29, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'eef9f640-9f72-11ea-8fe2-0a5bf521835e' WHERE id = '8089bace-9c4d-11ea-92c6-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('464b70a4-7c4a-11eb-9626-0a5bf521835e', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '8089b920-9c4d-11ea-92c4-0a5bf521835e', 'Lait de coco', '8074', 'Epicerie', '[{"nom":"1 Kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Brique de 1 L","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"Carton de 12*1L","quantite":12,"unite":"kg","utilise_commande":true,"utilise_stock":false}]', 2, 2.96, 5.5, 'kg', 10, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '464b70a4-7c4a-11eb-9626-0a5bf521835e' WHERE id = '8089b920-9c4d-11ea-92c4-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('75ed8d10-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '8089b920-9c4d-11ea-92c4-0a5bf521835e', 'Lait coco ', '302189', 'Epicerie', '[{"nom":"Brique de 1 L","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 0, 2.204, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '75ed8d10-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '8089b920-9c4d-11ea-92c4-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('ac707180-d439-11f0-a8bf-7d15d004187b', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089b920-9c4d-11ea-92c4-0a5bf521835e', 'Lait de coco Makli', '265799', 'Epicerie', '[{"nom":"1 Kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Brique de 1 L","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true},{"nom":"Carton de 12*1L","quantite":12,"unite":"kg","utilise_commande":false,"utilise_stock":false}]', 1, 3.95, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'ac707180-d439-11f0-a8bf-7d15d004187b' WHERE id = '8089b920-9c4d-11ea-92c4-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('00fc8510-6309-11f0-b471-9b25ac562ba3', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '8089bc9a-9c4d-11ea-92c8-0a5bf521835e', 'Sirop Chamallow Grillé', '115025', 'Boissons', '[{"nom":"L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 6 bouteilles de 1L","quantite":6,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 33.51, 5.5, 'L', 2, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '00fc8510-6309-11f0-b471-9b25ac562ba3' WHERE id = '8089bc9a-9c4d-11ea-92c8-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('1d06dd50-6309-11f0-82ca-6d0b9365770d', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '8089bc9a-9c4d-11ea-92c8-0a5bf521835e', 'Sirop Concombre', '115089', 'Boissons', '[{"nom":"L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 6 bouteilles de 1L","quantite":6,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 40.03, 5.5, 'L', 2, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '1d06dd50-6309-11f0-82ca-6d0b9365770d' WHERE id = '8089bc9a-9c4d-11ea-92c8-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('e4f34520-c26f-11ed-9637-2ff9d0f68a96', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '8089bc9a-9c4d-11ea-92c8-0a5bf521835e', 'Sirop Fraise Routin', '115140', 'Boissons', '[{"nom":"L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 6 bouteilles de 1L","quantite":6,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 39.78, 5.5, 'L', 2, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'e4f34520-c26f-11ed-9637-2ff9d0f68a96' WHERE id = '8089bc9a-9c4d-11ea-92c8-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('eefa1a6c-9f72-11ea-8fe6-0a5bf521835e', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089bf42-9c4d-11ea-92ca-0a5bf521835e', 'Vinaigre  Blanc ', '138363', 'Epicerie', '[{"nom":"Bidon de 10 L ","quantite":10,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 0, 5.43, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'eefa1a6c-9f72-11ea-8fe6-0a5bf521835e' WHERE id = '8089bf42-9c4d-11ea-92ca-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('75d59840-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '8089c0aa-9c4d-11ea-92cb-0a5bf521835e', 'Farine De Blé', '300032', 'Epicerie', '[{"nom":"au kilogramme","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"Sachet de 10 kg","quantite":10,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 0.984, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '75d59840-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '8089c0aa-9c4d-11ea-92cb-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('d80e3b30-fc4f-11ec-86ff-13fce83436c9', '25131b20-fc38-11ec-a176-d902a1918d35', '8089c0aa-9c4d-11ea-92cb-0a5bf521835e', 'Farine de blé T55', '300032', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 10kg","quantite":10,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 5.72, 5.5, 'kg', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'd80e3b30-fc4f-11ec-86ff-13fce83436c9' WHERE id = '8089c0aa-9c4d-11ea-92cb-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('eefa23c2-9f72-11ea-8fe7-0a5bf521835e', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089c0aa-9c4d-11ea-92cb-0a5bf521835e', 'Farine Ble T55', '183449', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"colis de 10 x 1kg","quantite":10,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 0.71, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'eefa23c2-9f72-11ea-8fe7-0a5bf521835e' WHERE id = '8089c0aa-9c4d-11ea-92cb-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('68abf204-7c36-11eb-a5e7-0a5bf521835e', '7634b460-f526-11eb-9855-6d337dfcae57', '8089bd76-9c4d-11ea-92c9-0a5bf521835e', 'Sirop Passion', '115143C6', 'Boissons', '[{"nom":"L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"carton de 6 btl de 1L","quantite":6,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 49.63, 5.5, 'L', 2, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '68abf204-7c36-11eb-a5e7-0a5bf521835e' WHERE id = '8089bd76-9c4d-11ea-92c9-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('8cf7ec90-c26f-11ed-9732-7f8f79f04939', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '8089bd76-9c4d-11ea-92c9-0a5bf521835e', 'Sirop fruit de la passion Routin', '115143', 'Boissons', '[{"nom":"L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"Colis  de 6 bouteilles de 1L","quantite":6,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 46.71, 5.5, 'L', 2, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '8cf7ec90-c26f-11ed-9732-7f8f79f04939' WHERE id = '8089bd76-9c4d-11ea-92c9-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('61de85d0-fc4c-11ec-82ff-e103d8d6432f', '25131b20-fc38-11ec-a176-d902a1918d35', '8089c17c-9c4d-11ea-92cc-0a5bf521835e', 'Concombre', '969023', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Pièce","quantite":0.45,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 0.919, 5.5, 'kg', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '61de85d0-fc4c-11ec-82ff-e103d8d6432f' WHERE id = '8089c17c-9c4d-11ea-92cc-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('7549d300-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '8089c17c-9c4d-11ea-92cc-0a5bf521835e', 'Concombre', '966776', 'Frais', '[{"nom":"Pièce de concombre","quantite":0.45,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 12 Concombres","quantite":12,"unite":"kg","utilise_commande":true,"utilise_stock":false}]', 1, 1.834, 5.5, 'kg', 3, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '7549d300-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '8089c17c-9c4d-11ea-92cc-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('d58d0010-c011-11f0-8e50-279a93fee7a7', 'b9ac9040-c00c-11f0-90c5-f561d51de85d', '8089c17c-9c4d-11ea-92cc-0a5bf521835e', 'Concombre Entier', '2028', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"pc","quantite":0.45,"unite":"kg","utilise_commande":true,"utilise_stock":true},{"nom":"caisse de 12 pcs","quantite":12,"unite":"kg","utilise_commande":false,"utilise_stock":false}]', 1, 0.99, 5.5, 'kg', 5, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'd58d0010-c011-11f0-8e50-279a93fee7a7' WHERE id = '8089c17c-9c4d-11ea-92cc-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('eefa45c8-9f72-11ea-8feb-0a5bf521835e', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089c17c-9c4d-11ea-92cc-0a5bf521835e', 'Concombre Entier', '121930', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"pc","quantite":0.45,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 0.99, 5.5, 'kg', 5, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'eefa45c8-9f72-11ea-8feb-0a5bf521835e' WHERE id = '8089c17c-9c4d-11ea-92cc-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('235ce7ac-801f-11eb-bd82-0a5bf521835e', 'e1451f2a-9f72-11ea-8f40-0a5bf521835e', '8089bbbe-9c4d-11ea-92c7-0a5bf521835e', 'Lait concentré', NULL, 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"carton de 6 tubes x 300g","quantite":1.8,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 1.21, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '235ce7ac-801f-11eb-bd82-0a5bf521835e' WHERE id = '8089bbbe-9c4d-11ea-92c7-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('75e8d220-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '8089bbbe-9c4d-11ea-92c7-0a5bf521835e', 'Lait Concentré tube', '970480', 'Epicerie', '[{"nom":"au kilogramme","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"Tube de 300 g ","quantite":0.3,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 2.801, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '75e8d220-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '8089bbbe-9c4d-11ea-92c7-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('756a2c40-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 'Pousses Haricot Mungo ', '928426', 'Frais', '[{"nom":"Sachet de 1 kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true},{"nom":"Colis de 5 Sachets","quantite":5,"unite":"kg","utilise_commande":false,"utilise_stock":false}]', 0, 2.456, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '756a2c40-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '8089c4d8-9c4d-11ea-92d0-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('8ae27200-c225-11f0-a3df-c90ddadfd362', 'b9ac9040-c00c-11f0-90c5-f561d51de85d', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 'Pousses haricot mungo', '0221', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"sachet de 2kg","quantite":2,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 1.69, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '8ae27200-c225-11f0-a3df-c90ddadfd362' WHERE id = '8089c4d8-9c4d-11ea-92d0-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('eefa695e-9f72-11ea-8fef-0a5bf521835e', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 'Pousses haricot mungo', '573383', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"sachet de 1kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 1.65, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'eefa695e-9f72-11ea-8fef-0a5bf521835e' WHERE id = '8089c4d8-9c4d-11ea-92d0-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('58dd3660-fc48-11ec-82ff-e103d8d6432f', '25131b20-fc38-11ec-a176-d902a1918d35', '8089c5be-9c4d-11ea-92d1-0a5bf521835e', 'Carottes râpées', '300556', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 2,1kg","quantite":2.1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 4.02, 5.5, 'kg', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '58dd3660-fc48-11ec-82ff-e103d8d6432f' WHERE id = '8089c5be-9c4d-11ea-92d1-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('756dd5c0-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '8089c32a-9c4d-11ea-92ce-0a5bf521835e', 'Salade Iceberg entière', '981350', 'Frais', '[{"nom":"au kilogramme","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Pièce de 300 g ","quantite":0.3,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 10 Salades","quantite":10,"unite":"kg","utilise_commande":true,"utilise_stock":false}]', 2, 1.586, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '756dd5c0-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '8089c32a-9c4d-11ea-92ce-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('a5713350-d8bd-11eb-96e9-a774afd7ede3', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089c32a-9c4d-11ea-92ce-0a5bf521835e', 'Boule iceberg', '762498', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Pièce","quantite":0.5,"unite":"kg","utilise_commande":true,"utilise_stock":true},{"nom":"colis de 10 boules","quantite":10,"unite":"kg","utilise_commande":false,"utilise_stock":false}]', 1, 0.99, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'a5713350-d8bd-11eb-96e9-a774afd7ede3' WHERE id = '8089c32a-9c4d-11ea-92ce-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('e5505f10-fc47-11ec-87d3-cf5d212ef325', '25131b20-fc38-11ec-a176-d902a1918d35', '8089c32a-9c4d-11ea-92ce-0a5bf521835e', 'Boule iceberg', '969373', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Pièce","quantite":0.33,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 1.6, 5.5, 'kg', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'e5505f10-fc47-11ec-87d3-cf5d212ef325' WHERE id = '8089c32a-9c4d-11ea-92ce-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('e8eb30f0-c011-11f0-a5c2-2d6a16f3887e', 'b9ac9040-c00c-11f0-90c5-f561d51de85d', '8089c32a-9c4d-11ea-92ce-0a5bf521835e', 'Boule iceberg', '2010', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Pièce","quantite":0.5,"unite":"kg","utilise_commande":true,"utilise_stock":true},{"nom":"colis de 10 boules","quantite":10,"unite":"kg","utilise_commande":false,"utilise_stock":false}]', 1, 0.89, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'e8eb30f0-c011-11f0-a5c2-2d6a16f3887e' WHERE id = '8089c32a-9c4d-11ea-92ce-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('1f0d7982-ef42-11ea-b9cf-0a5bf521835e', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089c258-9c4d-11ea-92cd-0a5bf521835e', 'Oignon nouveau', NULL, 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"botte de 300g","quantite":0.3,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 1.56, 5.5, 'kg', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '1f0d7982-ef42-11ea-b9cf-0a5bf521835e' WHERE id = '8089c258-9c4d-11ea-92cd-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('e037e2e2-11f1-11eb-bc3e-0a5bf521835e', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089c258-9c4d-11ea-92cd-0a5bf521835e', 'Oignon Cébette', '373579', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"botte","quantite":0.12,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 0.88, 5.5, 'kg', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'e037e2e2-11f1-11eb-bc3e-0a5bf521835e' WHERE id = '8089c258-9c4d-11ea-92cd-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('9cff8f00-7c4c-11eb-b8b2-0a5bf521835e', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '8089c690-9c4d-11ea-92d2-0a5bf521835e', 'Chips Crevettes | SaGiang', '5076', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"carton de 12 x 1 kg","quantite":12,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 44.28, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '9cff8f00-7c4c-11eb-b8b2-0a5bf521835e' WHERE id = '8089c690-9c4d-11ea-92d2-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('661c0010-fc5a-11ec-87d3-cf5d212ef325', '25131b20-fc38-11ec-a176-d902a1918d35', '8089c406-9c4d-11ea-92cf-0a5bf521835e', 'Poivron rouge (C1)', '969338', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Au kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 3, 5.5, 'kg', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '661c0010-fc5a-11ec-87d3-cf5d212ef325' WHERE id = '8089c406-9c4d-11ea-92cf-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('756682c0-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '8089c406-9c4d-11ea-92cf-0a5bf521835e', 'Poivron Rouge', '8940', 'Frais', '[{"nom":"filet de 1 kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 0, 3.17, 5.5, 'kg', 20, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '756682c0-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '8089c406-9c4d-11ea-92cf-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('79b44640-c011-11f0-a5c2-2d6a16f3887e', 'b9ac9040-c00c-11f0-90c5-f561d51de85d', '8089c406-9c4d-11ea-92cf-0a5bf521835e', 'Poivron Rouge', '2023', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true},{"nom":"caisse de 5kg","quantite":5,"unite":"kg","utilise_commande":false,"utilise_stock":false}]', 0, 1.99, 5.5, 'kg', 20, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '79b44640-c011-11f0-a5c2-2d6a16f3887e' WHERE id = '8089c406-9c4d-11ea-92cf-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('b5e059b0-8979-11ec-9deb-cfde4f8f9538', 'ea564a80-8977-11ec-8ce1-c32a63dfe765', '8089c406-9c4d-11ea-92cf-0a5bf521835e', 'Poivron rouge', NULL, 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 5kg","quantite":5,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 8.25, 5.5, 'kg', 20, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'b5e059b0-8979-11ec-9deb-cfde4f8f9538' WHERE id = '8089c406-9c4d-11ea-92cf-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('eefa6080-9f72-11ea-8fee-0a5bf521835e', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089c406-9c4d-11ea-92cf-0a5bf521835e', 'Poivron Rouge', '470531', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 0, 4.4, 5.5, 'kg', 20, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'eefa6080-9f72-11ea-8fee-0a5bf521835e' WHERE id = '8089c406-9c4d-11ea-92cf-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('9a7e959c-7c46-11eb-a0d5-0a5bf521835e', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '8089c852-9c4d-11ea-92d4-0a5bf521835e', 'Champignons noir', '700019L', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Carton de 10 x 1kg","quantite":10,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 126.5, 5.5, 'kg', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '9a7e959c-7c46-11eb-a0d5-0a5bf521835e' WHERE id = '8089c852-9c4d-11ea-92d4-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('b3a00080-4205-11ec-bcaa-0fe6a8bf552e', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '8089ca00-9c4d-11ea-92d6-0a5bf521835e', 'Mélange 5 épices | LOBO', '16991', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Carton de 12 x 400g","quantite":4.8,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 45.6, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'b3a00080-4205-11ec-bcaa-0fe6a8bf552e' WHERE id = '8089ca00-9c4d-11ea-92d6-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('67ceaba0-c011-11f0-90c5-f561d51de85d', 'b9ac9040-c00c-11f0-90c5-f561d51de85d', '8089c924-9c4d-11ea-92d5-0a5bf521835e', 'Piment Oiseau Rouge', NULL, 'Frais', '[{"nom":"au kilogramme","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true},{"nom":"Barquette de 100g","quantite":0.1,"unite":"kg","utilise_commande":false,"utilise_stock":false}]', 0, 2.39, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '67ceaba0-c011-11f0-90c5-f561d51de85d' WHERE id = '8089c924-9c4d-11ea-92d5-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('6fa4af50-94c4-11f0-93c7-cf854843b3c9', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089c924-9c4d-11ea-92d5-0a5bf521835e', 'Piment Oiseau Rouge', '382881', 'Frais', '[{"nom":"au kilogramme","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"Barquette de 100g","quantite":0.1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 3.35, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '6fa4af50-94c4-11f0-93c7-cf854843b3c9' WHERE id = '8089c924-9c4d-11ea-92d5-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('7561c7d0-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '8089c924-9c4d-11ea-92d5-0a5bf521835e', 'Piment Oiseau Rouge', '008913', 'Frais', '[{"nom":"au kilogramme","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"Barquette de 100g","quantite":0.1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 3.011, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '7561c7d0-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '8089c924-9c4d-11ea-92d5-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('a30a5230-8b06-11ec-9deb-cfde4f8f9538', 'ea564a80-8977-11ec-8ce1-c32a63dfe765', '8089c924-9c4d-11ea-92d5-0a5bf521835e', 'Piment oiseau', 'Non défini', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Sachet de 100g","quantite":0.1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 4.5, 5.5, 'kg', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'a30a5230-8b06-11ec-9deb-cfde4f8f9538' WHERE id = '8089c924-9c4d-11ea-92d5-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('ca3291be-2aa5-11eb-8576-0a5bf521835e', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089cf00-9c4d-11ea-92dc-0a5bf521835e', 'Nems Poulet | SFPA Halal', '999067', 'Surgelés', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"sac de 1,9kg","quantite":50,"unite":"unite","utilise_commande":true,"utilise_stock":true},{"nom":"carton de 4 sachets","quantite":4,"unite":"unite","utilise_commande":false,"utilise_stock":false}]', 1, 18.5, 5.5, 'unite', 5, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'ca3291be-2aa5-11eb-8576-0a5bf521835e' WHERE id = '8089cf00-9c4d-11ea-92dc-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('02583b60-b421-11ec-8ebe-e111184aab00', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 'Ail Coupé', '607330', 'Surgelés', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Sachet de 250g","quantite":0.25,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 3.34, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '02583b60-b421-11ec-8ebe-e111184aab00' WHERE id = '8089d298-9c4d-11ea-92e0-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('46bad120-94c2-11f0-86dd-67ae401d9613', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 'Pulpe Ail', '151717', 'Epicerie', '[{"nom":"seau de 1kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 0, 3.58, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '46bad120-94c2-11f0-86dd-67ae401d9613' WHERE id = '8089d298-9c4d-11ea-92e0-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('74d8e8c0-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 'Ail Coupé', '300760', 'Surgelés', '[{"nom":"Sachet de 1 kg ","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 0, 3.58, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '74d8e8c0-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '8089d298-9c4d-11ea-92e0-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('44e9e190-8ef7-11f0-a5ad-37d09fba6a0b', '5c49af70-8ef5-11f0-975b-2726f4fe3aed', '8089cfdc-9c4d-11ea-92dd-0a5bf521835e', 'Filet de Poulet Halal (Barquette de 2,5kg)', '3574', 'Frais', '[{"nom":"au kilogramme","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Barquette de 2,5 kg ","quantite":2.5,"unite":"kg","utilise_commande":true,"utilise_stock":true},{"nom":"Colis de 4 bqt de 2,5kg","quantite":10,"unite":"kg","utilise_commande":false,"utilise_stock":false}]', 1, 6.8, 5.5, 'kg', 3, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '44e9e190-8ef7-11f0-a5ad-37d09fba6a0b' WHERE id = '8089cfdc-9c4d-11ea-92dd-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('758a3760-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '8089cfdc-9c4d-11ea-92dd-0a5bf521835e', 'Filet de Poulet Halal (Barquette de 2,5kg)', '212173', 'Frais', '[{"nom":"au kilogramme","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Barquette de 2,5 kg ","quantite":2.5,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 4 bqt de 2,5kg","quantite":10,"unite":"kg","utilise_commande":true,"utilise_stock":false}]', 2, 9.145, 5.5, 'kg', 3, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '758a3760-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '8089cfdc-9c4d-11ea-92dd-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('963cc260-d8d6-11ef-93ff-85201132e2e3', 'd7a47e10-d8d5-11ef-93ff-85201132e2e3', '8089cfdc-9c4d-11ea-92dd-0a5bf521835e', 'Filet de Poulet Halal (Bqt de 2,5kg)', NULL, 'Frais', '[{"nom":"au kilogramme","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Barquette de 2,5 kg ","quantite":2.5,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 5.8, 5.5, 'kg', 3, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '963cc260-d8d6-11ef-93ff-85201132e2e3' WHERE id = '8089cfdc-9c4d-11ea-92dd-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('c629dfc0-4168-11ec-894a-c7f0b1ca45e9', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089cfdc-9c4d-11ea-92dd-0a5bf521835e', 'Filet poulet UE halal', '86226', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Barquette de 2,5kg","quantite":2.5,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 7, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'c629dfc0-4168-11ec-894a-c7f0b1ca45e9' WHERE id = '8089cfdc-9c4d-11ea-92dd-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('5c156a20-69d2-11ee-8bc5-f5e77dc043b1', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '8089cc80-9c4d-11ea-92d9-0a5bf521835e', 'Tofu Nature 400g TT Foods ', '7010', 'Frais', '[{"nom":"Paquet de 400g ","quantite":0.4,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"Carton de 12 paquets (12x400g)","quantite":12,"unite":"kg","utilise_commande":true,"utilise_stock":false}]', 1, 15.360000000000001, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '5c156a20-69d2-11ee-8bc5-f5e77dc043b1' WHERE id = '8089cc80-9c4d-11ea-92d9-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('faf5b600-b77c-11f0-929b-63f9740ac7d8', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '8089cc80-9c4d-11ea-92d9-0a5bf521835e', 'Tofu Nature bio 1kg', '301810', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"sachet de 1kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true},{"nom":"CTN de 6 sachets","quantite":6,"unite":"kg","utilise_commande":false,"utilise_stock":false}]', 1, 6.926, 5.5, 'kg', 5, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'faf5b600-b77c-11f0-929b-63f9740ac7d8' WHERE id = '8089cc80-9c4d-11ea-92d9-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('7519e960-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '8089d90a-9c4d-11ea-92e6-0a5bf521835e', 'Boulettes De Boeuf SFPA', '404838', 'Surgelés', '[{"nom":"au kilogramme","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"sachet de 500g","quantite":0.5,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 15 sachets de 500 g","quantite":7.5,"unite":"kg","utilise_commande":true,"utilise_stock":false}]', 2, 92.47422680412372, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '7519e960-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '8089d90a-9c4d-11ea-92e6-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('1ff0afa0-cd39-11ec-87de-7f10c385a49a', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089d522-9c4d-11ea-92e3-0a5bf521835e', 'Oeufs Entiers | pasteurises', '67576', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"bouteille de 1kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true},{"nom":"colis de 6 btl","quantite":6,"unite":"kg","utilise_commande":false,"utilise_stock":false}]', 1, 4.35, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '1ff0afa0-cd39-11ec-87de-7f10c385a49a' WHERE id = '8089d522-9c4d-11ea-92e3-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('7527f320-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '8089d522-9c4d-11ea-92e3-0a5bf521835e', 'Oeuf Entier Liquide ', '950228', 'Frais', '[{"nom":"Bouteille de 1L","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true},{"nom":"pack de 8 briques de 1L","quantite":8,"unite":"kg","utilise_commande":false,"utilise_stock":false}]', 0, 4.747, 5.5, 'kg', 5, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '7527f320-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '8089d522-9c4d-11ea-92e3-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('58d90b20-94c6-11f0-9aca-45d02bbec7a9', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089d446-9c4d-11ea-92e2-0a5bf521835e', 'Roti Echine de Porc', '920599', 'Frais', '[{"nom":"au kilogramme","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"pièce de 2kg","quantite":2,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 7.9, 5.5, 'kg', 5, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '58d90b20-94c6-11f0-9aca-45d02bbec7a9' WHERE id = '8089d446-9c4d-11ea-92e2-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('751f1980-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '8089d446-9c4d-11ea-92e2-0a5bf521835e', 'Roti Echine de Porc', '219785', 'Surgelés', '[{"nom":"au kilogramme","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"4 Pièces de 2,2 kg","quantite":8.8,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 6.129, 5.5, 'kg', 5, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '751f1980-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '8089d446-9c4d-11ea-92e2-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('6b0d7a50-94cc-11f0-99ae-49d8e489343b', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 'Huile De Friture Maurel', '718732', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Bidon de 10 L","quantite":9.355,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 19.25, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '6b0d7a50-94cc-11f0-99ae-49d8e489343b' WHERE id = '8089d37e-9c4d-11ea-92e1-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('75f666b0-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 'Huile De Friture TGT Economy', '301181', 'Epicerie', '[{"nom":"Bidon d''huile","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Bidon de 5 L","quantite":5,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 14.684, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '75f666b0-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = '8089d37e-9c4d-11ea-92e1-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('8a7fbae0-fc51-11ec-a176-d902a1918d35', '25131b20-fc38-11ec-a176-d902a1918d35', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 'Huile', '300862', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Bidon de 5L","quantite":4.5,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 27.95, 5.5, 'kg', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '8a7fbae0-fc51-11ec-a176-d902a1918d35' WHERE id = '8089d37e-9c4d-11ea-92e1-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('ebff2fd0-e277-11ef-aada-97a81cdb71c0', '74cd61d0-e276-11ef-90ac-1d5624ff84a8', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 'Huile Tournesol Premium', 'OP15', 'Epicerie', '[{"nom":"Carton d''huile","quantite":15,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 0, 32.26, 5.5, 'kg', 2, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'ebff2fd0-e277-11ef-aada-97a81cdb71c0' WHERE id = '8089d37e-9c4d-11ea-92e1-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('15d48430-d1cb-11ef-a2a6-7b065928faa2', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '8089d838-9c4d-11ea-92e5-0a5bf521835e', 'Boule macreuse UE HALAL Boeuf', '971577', 'Frais', '[{"nom":"au kilogramme","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 2 kg","quantite":2,"unite":"kg","utilise_commande":true,"utilise_stock":false},{"nom":"Colis 8 poches de 2kg","quantite":16,"unite":"kg","utilise_commande":false,"utilise_stock":false}]', 1, 18.243, 5.5, 'kg', 6, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '15d48430-d1cb-11ef-a2a6-7b065928faa2' WHERE id = '8089d838-9c4d-11ea-92e5-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('50b140a0-9e1c-11ed-ae4a-95a7acd19b67', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089d838-9c4d-11ea-92e5-0a5bf521835e', 'Boeuf - macreuse Halal', '923336', 'Frais', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 0, 14.5, 5.5, 'kg', 8, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '50b140a0-9e1c-11ed-ae4a-95a7acd19b67' WHERE id = '8089d838-9c4d-11ea-92e5-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('e37a1dce-519f-11eb-a923-0a5bf521835e', 'd69710e0-f469-11eb-8fb0-df4c06cfdb0d', '88c4aa00-a33b-11eb-a68c-ebc667a0f6a6', 'Napolitains Ba Ria 76%', NULL, 'Epicerie', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"8 boîtes de 80g","quantite":8,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 36, 5.5, 'unite', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'e37a1dce-519f-11eb-a923-0a5bf521835e' WHERE id = '88c4aa00-a33b-11eb-a68c-ebc667a0f6a6';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('3efeb660-e080-11ee-ab07-53e6b8d14f53', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '844e6910-90f2-11ed-808a-65c448e0727c', 'DRINK WATERS Eau Plate', 'PHD004', 'Boissons', '[{"nom":"Bouteille","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis x12 bouteilles","quantite":12,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 14.879999999999999, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '3efeb660-e080-11ee-ab07-53e6b8d14f53' WHERE id = '844e6910-90f2-11ed-808a-65c448e0727c';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('721e9e60-416e-11ec-894a-c7f0b1ca45e9', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '8089d0a4-9c4d-11ea-92de-0a5bf521835e', 'Crevettes décortiquées crues 31/40', '578728', 'Surgelés', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Sachet de 800g","quantite":0.8,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 9.95, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '721e9e60-416e-11ec-894a-c7f0b1ca45e9' WHERE id = '8089d0a4-9c4d-11ea-92de-0a5bf521835e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('ee7a39d0-95de-11ee-8b0f-59407e3c6c5e', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '88c9e970-e482-11ef-aa41-01eb4d41c1d0', 'Granola Nature', '401898', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"Sachet de 2 kg","quantite":2,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 3 sachets","quantite":6,"unite":"kg","utilise_commande":true,"utilise_stock":false}]', 2, 10.37, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'ee7a39d0-95de-11ee-8b0f-59407e3c6c5e' WHERE id = '88c9e970-e482-11ef-aa41-01eb4d41c1d0';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('824cd960-8161-11ef-9167-575c4b10e0cc', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '89c0dd60-00ee-11f0-9d98-b7ea8c718efe', 'Mayonnaise vrac TGT quality', '300307', 'Frais', '[{"nom":"seau de 5L","quantite":5,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 0, 15.539, 5.5, 'kg', 3, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '824cd960-8161-11ef-9167-575c4b10e0cc' WHERE id = '89c0dd60-00ee-11f0-9d98-b7ea8c718efe';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('a359ee90-94ca-11f0-a520-25e5329ee829', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '89c0dd60-00ee-11f0-9d98-b7ea8c718efe', 'Mayonnaise 5L', '392549', 'Frais', '[{"nom":"seau de 5L","quantite":5,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 0, 12.99, 5.5, 'kg', 3, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'a359ee90-94ca-11f0-a520-25e5329ee829' WHERE id = '89c0dd60-00ee-11f0-9d98-b7ea8c718efe';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('9974d480-4bf7-11ee-9e4e-e1162ef350f9', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '8f221700-4d81-11ee-9848-af14af9a4362', 'Crème Glacée Beurre De Cacahuètes - Atelier des écrins', '301704', 'Surgelés', '[{"nom":"Pot de glace ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Pots de glace Beurre de Cacahuètes","quantite":15,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 25.17, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '9974d480-4bf7-11ee-9e4e-e1162ef350f9' WHERE id = '8f221700-4d81-11ee-9848-af14af9a4362';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('5b5205c0-b18a-11ef-8928-232def3f9c3e', '60bb1420-c0a6-11ec-959c-5b5037aeef23', '96d871b0-b37b-11ed-9ea0-d38c4a9947cb', 'Couvercle Pho', ' CVSC1000CARK', 'Emballages', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 500pcs","quantite":500,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 56, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '5b5205c0-b18a-11ef-8928-232def3f9c3e' WHERE id = '96d871b0-b37b-11ed-9ea0-d38c4a9947cb';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('4eb20710-b1c0-11ec-8ebe-e111184aab00', 'd4617750-9add-11ec-ba94-f94c6b33e293', '8faec180-7d4a-11ed-b263-b95e21b5e348', 'Casquettes Noires', 'CAP01-BLK', 'Uniformes', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Unité","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 10.5, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '4eb20710-b1c0-11ec-8ebe-e111184aab00' WHERE id = '8faec180-7d4a-11ed-b263-b95e21b5e348';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('aadd5bd0-448b-11ed-a9e9-53226e2a07d2', 'd4617750-9add-11ec-ba94-f94c6b33e293', '8faec180-7d4a-11ed-b263-b95e21b5e348', 'Casquettes Bleu Marine', 'CAP01-NVY', 'Uniformes', '[{"nom":"Unité","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 0, 10.5, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'aadd5bd0-448b-11ed-a9e9-53226e2a07d2' WHERE id = '8faec180-7d4a-11ed-b263-b95e21b5e348';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('df2673e0-6429-11ee-9e11-efb4dc2dfa79', 'd4617750-9add-11ec-ba94-f94c6b33e293', '8faec180-7d4a-11ed-b263-b95e21b5e348', 'Casquette Burgundy', 'CAP01-BUR', 'Uniformes', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 0, 11.5, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'df2673e0-6429-11ee-9e11-efb4dc2dfa79' WHERE id = '8faec180-7d4a-11ed-b263-b95e21b5e348';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('09e598f0-630a-11f0-82ca-6d0b9365770d', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '8eda7860-7cd6-11eb-83c2-81353eec23fb', 'Perles Ananas - Pop Ball', '126023', 'Epicerie', '[{"nom":"Pot de 3,2kg","quantite":3.2,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 4 x 3.2kg","quantite":4,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 80.14, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '09e598f0-630a-11f0-82ca-6d0b9365770d' WHERE id = '8eda7860-7cd6-11eb-83c2-81353eec23fb';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('a9110db0-c276-11ed-8f4c-e7d4ca882d17', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '8eda7860-7cd6-11eb-83c2-81353eec23fb', 'Perles Grenade - Pop Ball', '126030', 'Epicerie', '[{"nom":"Pot de 3,2kg","quantite":3.2,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 4 x 3.2kg","quantite":4,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 80.14, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'a9110db0-c276-11ed-8f4c-e7d4ca882d17' WHERE id = '8eda7860-7cd6-11eb-83c2-81353eec23fb';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('c81d3c20-6309-11f0-9a0a-bd68f2af8e9d', '47e36ba0-c267-11ed-af3b-01e40c7876d2', '8eda7860-7cd6-11eb-83c2-81353eec23fb', 'Perles Fruits du dragon - Pop Ball', '126041', 'Epicerie', '[{"nom":"Pot de 3,2kg","quantite":3.2,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 4 x 3.2kg","quantite":4,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 80.14, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'c81d3c20-6309-11f0-9a0a-bd68f2af8e9d' WHERE id = '8eda7860-7cd6-11eb-83c2-81353eec23fb';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('0c316ad0-9dfc-11f0-ad3e-2792898a72a1', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', '91d84850-9dfe-11f0-ad3e-2792898a72a1', 'Tiramisu noisette/choco/speculos', '228316', 'Surgelés', '[{"nom":"pot de 100g","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"CTN de 12 pots","quantite":12,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 1.4733333333333334, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '0c316ad0-9dfc-11f0-ad3e-2792898a72a1' WHERE id = '91d84850-9dfe-11f0-ad3e-2792898a72a1';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('dc77aeb0-513d-11ee-ab17-f3af3fe31514', 'a8700630-2b86-11ee-b43d-fba4734c3f62', '96ef61c0-916f-11eb-9d41-2dd57a3d8f5e', 'PERLE COCO YIDA', '404790', 'Surgelés', '[{"nom":"Sachets de 3kg","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 6 sachets","quantite":6,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 13.31, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'dc77aeb0-513d-11ee-ab17-f3af3fe31514' WHERE id = '96ef61c0-916f-11eb-9d41-2dd57a3d8f5e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('9b1c3fe0-89e5-11ee-8b41-f738d1c0da88', 'e145239e-9f72-11ea-8f47-0a5bf521835e', '9846ad50-5147-11ed-b50c-474f649a5bc5', 'Bière Tsingtao', '999004L', 'Boissons', '[{"nom":"Bière 33cl","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Carton de 24 x 33cl","quantite":24,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 25.200000000000003, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '9b1c3fe0-89e5-11ee-8b41-f738d1c0da88' WHERE id = '9846ad50-5147-11ed-b50c-474f649a5bc5';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('2b279d70-7c92-11ee-8098-81145f75bf63', '5ebc88e0-7976-11ee-a1ca-ed4795abb9e6', 'a20c0f10-7d48-11ed-a047-fb061caa6559', 'Boule Inox Gris ', '100012', 'Hygiène', '[{"nom":"Boule inox","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Carton de 10 Boules Inox","quantite":10,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 5.89, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '2b279d70-7c92-11ee-8098-81145f75bf63' WHERE id = 'a20c0f10-7d48-11ed-a047-fb061caa6559';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('256c6c46-51a0-11eb-afd6-0a5bf521835e', 'd69710e0-f469-11eb-8fb0-df4c06cfdb0d', 'a3e37730-ede1-11eb-b539-d109965a1b2f', 'Napolitains Dong Nai 72%', NULL, 'Epicerie', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"8 boites de 80g","quantite":8,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 36, 5.5, 'unite', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '256c6c46-51a0-11eb-afd6-0a5bf521835e' WHERE id = 'a3e37730-ede1-11eb-b539-d109965a1b2f';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('7786bed0-2607-11ee-a9c5-919e3d735654', '9a3280e0-2152-11ee-888e-8daad14c2966', 'a84e6e30-da70-11f0-adac-a3171657b79f', 'bobines thermiques CB THERMIQUE 57X40X12 SANS BPA', '523004', 'Hygiène', '[{"nom":"1 unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 50 pièces","quantite":50,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 19.01, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '7786bed0-2607-11ee-a9c5-919e3d735654' WHERE id = 'a84e6e30-da70-11f0-adac-a3171657b79f';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('268fdf20-7c8d-11ee-a19d-e32c28269216', '5ebc88e0-7976-11ee-a1ca-ed4795abb9e6', 'b5996970-7d4c-11ed-bef2-3be33b07e51f', 'Peau de rechange mouilleur 35cm', '101291', 'Hygiène', '[{"nom":"1 pièce","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 0, 9, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '268fdf20-7c8d-11ee-a19d-e32c28269216' WHERE id = 'b5996970-7d4c-11ed-bef2-3be33b07e51f';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('a4dbf470-7c8f-11ee-ab72-3fd0ed0819d1', '5ebc88e0-7976-11ee-a1ca-ed4795abb9e6', 'b5996970-7d4c-11ed-bef2-3be33b07e51f', 'Lavette verte 35x50', '771073', 'Hygiène', '[{"nom":"1 pièce","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Sachets de 25 pèces","quantite":25,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 5.1, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'a4dbf470-7c8f-11ee-ab72-3fd0ed0819d1' WHERE id = 'b5996970-7d4c-11ed-bef2-3be33b07e51f';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('ed1a85d0-7c8f-11ee-ab72-3fd0ed0819d1', '5ebc88e0-7976-11ee-a1ca-ed4795abb9e6', 'b5996970-7d4c-11ed-bef2-3be33b07e51f', 'Lavette Bleu 35x50 ', '771071', 'Hygiène', '[{"nom":"1 pièce","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Sachet de 25 pièces","quantite":25,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 5.1, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'ed1a85d0-7c8f-11ee-ab72-3fd0ed0819d1' WHERE id = 'b5996970-7d4c-11ed-bef2-3be33b07e51f';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('b170f410-bb21-11f0-b20e-21327225c2f9', '47e36ba0-c267-11ed-af3b-01e40c7876d2', 'b6016290-bb2a-11f0-9bda-f77aaf7b1906', 'Jus litchi Maya - 33cl', '101060P24', 'Boissons', '[{"nom":"canette","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"24 canettes de 33 cl","quantite":24,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 1.2270833333333333, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'b170f410-bb21-11f0-b20e-21327225c2f9' WHERE id = 'b6016290-bb2a-11f0-9bda-f77aaf7b1906';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('213751c0-c310-11ed-b116-d7b40111f808', '47e36ba0-c267-11ed-af3b-01e40c7876d2', 'bb248820-c310-11ed-9c70-752f0462a215', 'Thé vert menthe concombre - KUSMI', '117128', 'Epicerie', '[{"nom":"Sachet de 2 g ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Paquet de 25 sachets de thés","quantite":25,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 10.03, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '213751c0-c310-11ed-b116-d7b40111f808' WHERE id = 'bb248820-c310-11ed-9c70-752f0462a215';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('4a7a9b90-a66d-11ef-872a-750412b95ed1', '60bb1420-c0a6-11ec-959c-5b5037aeef23', 'ba162090-7eb7-11ec-bafd-fb0d701e3442', 'Boîte Pho', 'SC1000CARK ', 'Emballages', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 500pcs","quantite":500,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 60, 20, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '4a7a9b90-a66d-11ef-872a-750412b95ed1' WHERE id = 'ba162090-7eb7-11ec-bafd-fb0d701e3442';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('62189f60-c30f-11ed-9637-2ff9d0f68a96', '47e36ba0-c267-11ed-af3b-01e40c7876d2', 'bc30cef0-2370-11f0-ac9f-fffdeb0f868f', 'Thé noir kashmir tchai - KUSMI', '117119', 'Epicerie', '[{"nom":"Sachet de 2 g ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Paquet de 25 sachets de thés","quantite":25,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 9.98, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '62189f60-c30f-11ed-9637-2ff9d0f68a96' WHERE id = 'bc30cef0-2370-11f0-ac9f-fffdeb0f868f';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('78a6d4d0-2607-11ee-a9c5-919e3d735654', '9a3280e0-2152-11ee-888e-8daad14c2966', 'b7c1c370-d38a-11ed-9677-6bd4a1cc96ce', 'Sel adoucisseur AXAL I 25kg', '43', 'Hygiène', '[{"nom":"1 kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 25 kg","quantite":25,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 9.96, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '78a6d4d0-2607-11ee-a9c5-919e3d735654' WHERE id = 'b7c1c370-d38a-11ed-9677-6bd4a1cc96ce';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('bdf1f748-b97d-11eb-aa48-0a5bf521835e', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', 'b7c1c370-d38a-11ed-9677-6bd4a1cc96ce', 'Sel adoucisseur AXAL I 10kg', '626645', 'Hygiène', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Sac de 10 kg","quantite":10,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 5.9, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'bdf1f748-b97d-11eb-aa48-0a5bf521835e' WHERE id = 'b7c1c370-d38a-11ed-9677-6bd4a1cc96ce';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('02a69da0-fc5b-11ec-87d3-cf5d212ef325', '25131b20-fc38-11ec-a176-d902a1918d35', 'ba102e80-d1f8-11ec-b363-f7982c6efb86', 'Sirop peche', '301039', 'Boissons', '[{"nom":"L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"Bouteille de 1L","quantite":1,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 2.9, 5.5, 'L', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '02a69da0-fc5b-11ec-87d3-cf5d212ef325' WHERE id = 'ba102e80-d1f8-11ec-b363-f7982c6efb86';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('e3ce9c20-c3ec-11ed-85cc-93bd64fae96a', '47e36ba0-c267-11ed-af3b-01e40c7876d2', 'ba102e80-d1f8-11ec-b363-f7982c6efb86', 'Sirop pêche Routin', '115112', 'Boissons', '[{"nom":"L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 6 bouteilles de 1L","quantite":6,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 36.35, 5.5, 'L', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'e3ce9c20-c3ec-11ed-85cc-93bd64fae96a' WHERE id = 'ba102e80-d1f8-11ec-b363-f7982c6efb86';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('19b38620-7c8e-11ee-a013-59d6e817b6c6', '5ebc88e0-7976-11ee-a1ca-ed4795abb9e6', 'b632b350-5146-11ed-b50c-474f649a5bc5', 'Manche Alu 140cm', '101270', 'Hygiène', '[{"nom":"1 pièce","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 0, 3.9, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '19b38620-7c8e-11ee-a013-59d6e817b6c6' WHERE id = 'b632b350-5146-11ed-b50c-474f649a5bc5';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('6ffa6d60-7c8d-11ee-8d65-69677a6c946d', '5ebc88e0-7976-11ee-a1ca-ed4795abb9e6', 'b632b350-5146-11ed-b50c-474f649a5bc5', 'Tête de Loup Unger Ovale ', '120034', 'Hygiène', '[{"nom":"1 pièce","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 0, 12, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '6ffa6d60-7c8d-11ee-8d65-69677a6c946d' WHERE id = 'b632b350-5146-11ed-b50c-474f649a5bc5';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('89383c50-7c86-11ee-a128-173f0dc27acd', '5ebc88e0-7976-11ee-a1ca-ed4795abb9e6', 'b632b350-5146-11ed-b50c-474f649a5bc5', 'Grattoir vitres et sol emmanche 120cm', '153157', 'Hygiène', '[{"nom":"1 pièce","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 0, 25, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '89383c50-7c86-11ee-a128-173f0dc27acd' WHERE id = 'b632b350-5146-11ed-b50c-474f649a5bc5';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('de65c020-7c8c-11ee-8d65-69677a6c946d', '5ebc88e0-7976-11ee-a1ca-ed4795abb9e6', 'b632b350-5146-11ed-b50c-474f649a5bc5', 'Perche Télescopique Optiloc 3x1,25M ', '803463', 'Hygiène', '[{"nom":"Perche Télescopique ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 3 perches","quantite":3,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 39, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'de65c020-7c8c-11ee-8d65-69677a6c946d' WHERE id = 'b632b350-5146-11ed-b50c-474f649a5bc5';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('75cc61c0-aae7-11ee-818d-1791453a1a92', 'a8700630-2b86-11ee-b43d-fba4734c3f62', 'ba0d5480-6686-11ed-a031-8b54f9890809', 'Bière Heineken sans alcool 0%', '255824', 'Boissons', '[{"nom":"1 canette","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Pack de 6 canettes","quantite":6,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"1 colis de 4 packs (4x6)","quantite":24,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 2, 61.67999999999999, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '75cc61c0-aae7-11ee-818d-1791453a1a92' WHERE id = 'ba0d5480-6686-11ed-a031-8b54f9890809';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('7867d9c0-94c7-11f0-9aca-45d02bbec7a9', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', 'ba0d5480-6686-11ed-a031-8b54f9890809', 'Bière Heineken sans alcool 0%', '843616', 'Boissons', '[{"nom":"1 canette","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Pack de 6 canettes","quantite":6,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 0.813, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '7867d9c0-94c7-11f0-9aca-45d02bbec7a9' WHERE id = 'ba0d5480-6686-11ed-a031-8b54f9890809';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('77ed96f0-2607-11ee-a9c5-919e3d735654', '9a3280e0-2152-11ee-888e-8daad14c2966', 'c08fb080-da70-11f0-aed4-7d96cdc22e1f', 'Frange Lavage B. Espagne 150 G', '5202', 'Hygiène', '[{"nom":"1 unit","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 0, 1.2, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '77ed96f0-2607-11ee-a9c5-919e3d735654' WHERE id = 'c08fb080-da70-11f0-aed4-7d96cdc22e1f';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('75c341c0-4bf7-11ee-a05a-456bdbe5db27', 'a8700630-2b86-11ee-b43d-fba4734c3f62', 'c2209b50-4d85-11ee-b1b9-d7aabbfa3a52', 'Crème Glacée Vanille Pecan - Atelier des écrins', '301512', 'Surgelés', '[{"nom":"Pot de glace ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Pots de glace Vanille Pecan","quantite":15,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 25.17, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '75c341c0-4bf7-11ee-a05a-456bdbe5db27' WHERE id = 'c2209b50-4d85-11ee-b1b9-d7aabbfa3a52';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('2e1a69a0-561c-11ee-a63e-799c53ed9ed3', '9a3280e0-2152-11ee-888e-8daad14c2966', 'c39076e0-6023-11ed-8dc7-092ea485f5d7', 'Film Alimentaire Etirable 45CM X 300M', '533630', 'Emballages', '[{"nom":"1 rouleau ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 4 unités ","quantite":4,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 35.06, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '2e1a69a0-561c-11ee-a63e-799c53ed9ed3' WHERE id = 'c39076e0-6023-11ed-8dc7-092ea485f5d7';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('6614cf00-bb21-11f0-b37f-f1ca5653ca83', '47e36ba0-c267-11ed-af3b-01e40c7876d2', 'c5a46030-bb2a-11f0-9bda-f77aaf7b1906', 'Eau coco Maya - 33cl', '101064P24', 'Boissons', '[{"nom":"canette","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"24 canettes de 33 cl","quantite":24,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 29.45, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '6614cf00-bb21-11f0-b37f-f1ca5653ca83' WHERE id = 'c5a46030-bb2a-11f0-9bda-f77aaf7b1906';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('1c2ef420-7c93-11ee-a128-173f0dc27acd', '5ebc88e0-7976-11ee-a1ca-ed4795abb9e6', 'bfd9c020-d395-11ed-a335-b118b249b5d3', 'Rouleau essuie mains blanc 160M', '771212', 'Hygiène', '[{"nom":"rouleau","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Carton de 6 rouleaux ","quantite":6,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 44.16, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '1c2ef420-7c93-11ee-a128-173f0dc27acd' WHERE id = 'bfd9c020-d395-11ed-a335-b118b249b5d3';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('4a585190-8c14-11ed-b672-63eb7a7cc23e', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', 'c62145d0-8c13-11ed-a977-852f0d1617fb', 'Coca Cola Slim - 33CL', '345912', 'Boissons', '[{"nom":"canette","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"24 canettes de 33 cl","quantite":24,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 0.66, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '4a585190-8c14-11ed-b672-63eb7a7cc23e' WHERE id = 'c62145d0-8c13-11ed-a977-852f0d1617fb';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('75929bd0-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', 'c62145d0-8c13-11ed-a977-852f0d1617fb', 'Coca Cola Slim', '211383', 'Boissons', '[{"nom":"La canette ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 24 canettes ","quantite":24,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 0.816, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '75929bd0-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = 'c62145d0-8c13-11ed-a977-852f0d1617fb';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('d67ae140-94c9-11f0-bf7a-e545811c9fd1', '5c49af70-8ef5-11f0-975b-2726f4fe3aed', 'c62145d0-8c13-11ed-a977-852f0d1617fb', 'Coca Cola Slim - 33CL', '150', 'Boissons', '[{"nom":"canette","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"24 canettes de 33 cl","quantite":24,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 0.52, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'd67ae140-94c9-11f0-bf7a-e545811c9fd1' WHERE id = 'c62145d0-8c13-11ed-a977-852f0d1617fb';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('b0db9c60-08fb-11ee-b0c8-a9a066235cb8', '47e36ba0-c267-11ed-af3b-01e40c7876d2', 'cfbb0da0-08fb-11ee-8674-bb09560c03c4', 'Sirop Pandan Routin', '115172', 'Boissons', '[{"nom":"L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 6 bouteilles de 1L","quantite":6,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 51.61, 5.5, 'L', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'b0db9c60-08fb-11ee-b0c8-a9a066235cb8' WHERE id = 'cfbb0da0-08fb-11ee-8674-bb09560c03c4';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('80a89210-7c90-11ee-a013-59d6e817b6c6', '5ebc88e0-7976-11ee-a1ca-ed4795abb9e6', 'c88ce710-7d4b-11ed-b263-b95e21b5e348', 'BACTALIM SUPER NETTOYANT DEGRAISSANT DESINFECT ALIM  5 L', '771003', 'Hygiène', '[{"nom":"Litre","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":true},{"nom":"Bidon de 5L","quantite":5,"unite":"L","utilise_commande":true,"utilise_stock":false}]', 1, 22, 5.5, 'L', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '80a89210-7c90-11ee-a013-59d6e817b6c6' WHERE id = 'c88ce710-7d4b-11ed-b263-b95e21b5e348';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('a095a1c0-c30f-11ed-b116-d7b40111f808', '47e36ba0-c267-11ed-af3b-01e40c7876d2', 'cf5aa960-2370-11f0-8b95-0ba6cd1a2e00', 'Thé vert de chine - KUSMI', '117121', 'Epicerie', '[{"nom":"Sachet de 2 g ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Paquet de 25 sachets de thés","quantite":25,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 10.67, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'a095a1c0-c30f-11ed-b116-d7b40111f808' WHERE id = 'cf5aa960-2370-11f0-8b95-0ba6cd1a2e00';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('055cf6f0-fc4e-11ec-86ff-13fce83436c9', '25131b20-fc38-11ec-a176-d902a1918d35', 'cab47370-9316-11ec-bdf2-dbb798a33559', 'Coulis fruits rouges', '300984', 'Surgelés', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Bouteille de 500g","quantite":0.5,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 3.4, 5.5, 'kg', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '055cf6f0-fc4e-11ec-86ff-13fce83436c9' WHERE id = 'cab47370-9316-11ec-bdf2-dbb798a33559';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('2f5b91b0-e080-11ee-a9d4-81b274bd18d5', 'e145239e-9f72-11ea-8f47-0a5bf521835e', 'd0f323c0-b740-11ef-95c4-57b2d144b46f', 'DRINK WATERS Eau Pétillante', 'PHD003', 'Boissons', '[{"nom":"Bouteille","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis x12 bouteilles","quantite":12,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 14.879999999999999, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '2f5b91b0-e080-11ee-a9d4-81b274bd18d5' WHERE id = 'd0f323c0-b740-11ef-95c4-57b2d144b46f';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('af38df10-1a4c-11ed-841a-81e33d06fe9a', 'e145239e-9f72-11ea-8f47-0a5bf521835e', 'd0ceb8f0-3583-11ed-9548-ed051dc9e4fe', 'Dosette sauce nems | PHOOD', '410071L', 'Epicerie', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 300 x 30ml","quantite":300,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 45, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'af38df10-1a4c-11ed-841a-81e33d06fe9a' WHERE id = 'd0ceb8f0-3583-11ed-9548-ed051dc9e4fe';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('bb901720-ab96-11ed-9f6b-6b5518085ce3', '7634b460-f526-11eb-9855-6d337dfcae57', 'da05ca10-ab96-11ed-9bd5-bfc79caa022b', 'Préparation pâte bubble waffle', NULL, 'Epicerie', '[{"nom":"Sac de 10 kg","quantite":10,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 0, 58.09, 5.5, 'kg', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'bb901720-ab96-11ed-9f6b-6b5518085ce3' WHERE id = 'da05ca10-ab96-11ed-9bd5-bfc79caa022b';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('da902940-c30f-11ed-9732-7f8f79f04939', '47e36ba0-c267-11ed-af3b-01e40c7876d2', 'ddca0900-2370-11f0-bb68-a1d2c971872e', 'Thé vert jasmin - KUSMI', '117122', 'Epicerie', '[{"nom":"Sachet de 2 g ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Paquet de 25 sachets de thés","quantite":25,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 10.67, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'da902940-c30f-11ed-9732-7f8f79f04939' WHERE id = 'ddca0900-2370-11f0-bb68-a1d2c971872e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('f3c86d90-f521-11f0-ba9a-75f708fff4d6', 'e145239e-9f72-11ea-8f47-0a5bf521835e', 'e902d420-2d90-11ec-ac7d-edfd3dbf0302', 'Poudre soupe pho', '400321L', 'Epicerie', '[{"nom":"seau","quantite":0.8,"unite":"kg","utilise_commande":false,"utilise_stock":true},{"nom":"10 seaux de 800g","quantite":10,"unite":"kg","utilise_commande":true,"utilise_stock":false}]', 1, 7.08, 5.5, 'kg', 5, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'f3c86d90-f521-11f0-ba9a-75f708fff4d6' WHERE id = 'e902d420-2d90-11ec-ac7d-edfd3dbf0302';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('5c0f25d0-d24f-11ee-8962-c5e51ad7a486', '47e36ba0-c267-11ed-af3b-01e40c7876d2', 'e0db1a50-7d4e-11ed-bef2-3be33b07e51f', 'Sirop mangue', '115032', 'Boissons', '[{"nom":"L","quantite":1,"unite":"L","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 6 bouteilles de 1L","quantite":6,"unite":"L","utilise_commande":true,"utilise_stock":true}]', 1, 44.8, 5.5, 'L', 2, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '5c0f25d0-d24f-11ee-8962-c5e51ad7a486' WHERE id = 'e0db1a50-7d4e-11ed-bef2-3be33b07e51f';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('bd66f2b0-4bf7-11ee-9e4e-e1162ef350f9', 'a8700630-2b86-11ee-b43d-fba4734c3f62', 'e61c84e0-4d82-11ee-b1b9-d7aabbfa3a52', 'Crème Glacée Caramel Brownie - Atelier des écrins', '301513', 'Surgelés', '[{"nom":"Pot de glace ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Pots de glace Caramel Brownie","quantite":15,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 25.17, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'bd66f2b0-4bf7-11ee-9e4e-e1162ef350f9' WHERE id = 'e61c84e0-4d82-11ee-b1b9-d7aabbfa3a52';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('9bfb4010-c275-11ed-af3b-01e40c7876d2', '47e36ba0-c267-11ed-af3b-01e40c7876d2', 'ebbcfde0-ef91-11eb-bbe5-ef0537d994fa', 'Perles Framboise - Pop Ball', '126026', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 4 x 3.2kg","quantite":12.8,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 80.14, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '9bfb4010-c275-11ed-af3b-01e40c7876d2' WHERE id = 'ebbcfde0-ef91-11eb-bbe5-ef0537d994fa';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('1adc11e0-2a38-11ef-b7f1-79abb5ebf66a', 'a8700630-2b86-11ee-b43d-fba4734c3f62', 'f0deb290-fe75-11ef-9f24-3dea27761cfa', 'Coupelle sauce Sweet Chili', '223887', 'Epicerie', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 216 x 20g","quantite":216,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 35.611, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '1adc11e0-2a38-11ef-b7f1-79abb5ebf66a' WHERE id = 'f0deb290-fe75-11ef-9f24-3dea27761cfa';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('239c1160-4bf7-11ee-a133-513b0bc2e397', 'a8700630-2b86-11ee-b43d-fba4734c3f62', 'ec92a780-4d84-11ee-a7f1-87190e351617', 'Crème Glacée Noix de Coco Avec Copeaux De Chocolat - Atelier des écrins', '301673', 'Surgelés', '[{"nom":"Pot de glace ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Pots de glace  Noix de coco choco","quantite":15,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 25.17, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '239c1160-4bf7-11ee-a133-513b0bc2e397' WHERE id = 'ec92a780-4d84-11ee-a7f1-87190e351617';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('33f875a0-fc5a-11ec-86ff-13fce83436c9', '25131b20-fc38-11ec-a176-d902a1918d35', 'e9d88d10-b944-11eb-acec-29fb8569cb50', 'Petit pois', '301692', 'Surgelés', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 2,5kg","quantite":2.5,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 4.99, 5.5, 'kg', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '33f875a0-fc5a-11ec-86ff-13fce83436c9' WHERE id = 'e9d88d10-b944-11eb-acec-29fb8569cb50';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('751184f0-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', 'e9d88d10-b944-11eb-acec-29fb8569cb50', 'Petit pois doux très fin ', '443465', 'Surgelés', '[{"nom":"au kilogramme","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Sachets de 2,5 kg","quantite":2.5,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 4.932, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '751184f0-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = 'e9d88d10-b944-11eb-acec-29fb8569cb50';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('c1b3e924-b944-11eb-9f63-0a5bf521835e', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', 'e9d88d10-b944-11eb-acec-29fb8569cb50', 'Petit pois | très fins et précuits', '605213', 'Surgelés', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Sachet de 2,5kg","quantite":2.5,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 6.11, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = 'c1b3e924-b944-11eb-9f63-0a5bf521835e' WHERE id = 'e9d88d10-b944-11eb-acec-29fb8569cb50';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('6f37aef0-fc56-11ec-a176-d902a1918d35', '60bb1420-c0a6-11ec-959c-5b5037aeef23', 'eb643230-fe6c-11ef-a70a-c30a5e202927', 'Porte Gobelet', 'SNSCUPHOLDER', 'Emballages', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 600 pcs","quantite":600,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 1, 38.4, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '6f37aef0-fc56-11ec-a176-d902a1918d35' WHERE id = 'eb643230-fe6c-11ef-a70a-c30a5e202927';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('5920c6a0-e080-11ee-b84c-bfcfdaf0e652', 'e145239e-9f72-11ea-8f47-0a5bf521835e', 'f189f420-2853-11ed-8172-37c06f5b9a95', 'OUSIA Mojito 0%', 'PHD005', 'Boissons', '[{"nom":"Bouteille 27,5cl","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Colis x12 bouteilles","quantite":12,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 21.72, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '5920c6a0-e080-11ee-b84c-bfcfdaf0e652' WHERE id = 'f189f420-2853-11ed-8172-37c06f5b9a95';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('744838f0-e080-11ee-b84c-bfcfdaf0e652', 'e145239e-9f72-11ea-8f47-0a5bf521835e', 'f189f420-2853-11ed-8172-37c06f5b9a95', 'OUSIA Spritz 0%', 'PHD006', 'Boissons', '[{"nom":"Bouteille 27,5cl","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Colis x12 bouteilles","quantite":12,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 21.72, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '744838f0-e080-11ee-b84c-bfcfdaf0e652' WHERE id = 'f189f420-2853-11ed-8172-37c06f5b9a95';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('115d92f0-5934-11ed-8ba9-af293f7390a4', 'fc61d960-ecf0-11ec-92c5-b70a8da9dfee', 'f7663c30-5933-11ed-988a-6df56d6d4bf0', 'Cuillère Pho 13cm', 'FVA-CUI-CER', 'Vaisselle', '[{"nom":"Carton de 24 cuillères","quantite":24,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 0, 19, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '115d92f0-5934-11ed-8ba9-af293f7390a4' WHERE id = 'f7663c30-5933-11ed-988a-6df56d6d4bf0';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('22bc3db0-a8df-11ef-8823-a5dd9aeddc06', 'e145239e-9f72-11ea-8f47-0a5bf521835e', 'f6545520-fe77-11ef-abd3-1d5bab16a12f', 'Sauce Sweet Chili bidon', '000028L', 'Epicerie', '[{"nom":"unité","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 3 bidons x 4,5L","quantite":3,"unite":"kg","utilise_commande":true,"utilise_stock":false}]', 1, 37.95, 5.5, 'kg', 3, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '22bc3db0-a8df-11ef-8823-a5dd9aeddc06' WHERE id = 'f6545520-fe77-11ef-abd3-1d5bab16a12f';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('7ac04810-c274-11ed-b116-d7b40111f808', '47e36ba0-c267-11ed-af3b-01e40c7876d2', 'f6ba4130-ef91-11eb-b539-d109965a1b2f', 'Perles Fraise - Pop Ball', '126031', 'Epicerie', '[{"nom":"kg","quantite":1,"unite":"kg","utilise_commande":false,"utilise_stock":false},{"nom":"Colis de 4 x 3.2kg","quantite":12.8,"unite":"kg","utilise_commande":true,"utilise_stock":true}]', 1, 80.14, 5.5, 'kg', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '7ac04810-c274-11ed-b116-d7b40111f808' WHERE id = 'f6ba4130-ef91-11eb-b539-d109965a1b2f';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('45236430-d262-11ef-8f65-6b72446f7aab', 'a8700630-2b86-11ee-b43d-fba4734c3f62', 'f8c2c2a0-d694-11ec-9aab-3f3b95fb7b18', 'Donut Nappé Chocolat', '301480', 'Surgelés', '[{"nom":"Donut 55g","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 48 donuts","quantite":48,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 14.887, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '45236430-d262-11ef-8f65-6b72446f7aab' WHERE id = 'f8c2c2a0-d694-11ec-9aab-3f3b95fb7b18';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('26e37500-c30f-11ed-9c70-752f0462a215', '47e36ba0-c267-11ed-af3b-01e40c7876d2', 'f9dbed40-236e-11f0-bb68-a1d2c971872e', 'Thé noir quatre fruits rouge - KUSMI', '117115', 'Epicerie', '[{"nom":"Sachet de 2 g ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Paquet de 25 sachets de thés","quantite":25,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 10.17, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '26e37500-c30f-11ed-9c70-752f0462a215' WHERE id = 'f9dbed40-236e-11f0-bb68-a1d2c971872e';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('59cc43d0-51a0-11eb-9f54-0a5bf521835e', 'd69710e0-f469-11eb-8fb0-df4c06cfdb0d', 'fc2bc190-f5d4-11eb-8ccc-17901c63413d', 'Pâte à tartiner Marou', NULL, 'Epicerie', '[{"nom":"unit","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"10 pots de 250g","quantite":10,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 90, 5.5, 'unite', 0, false);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '59cc43d0-51a0-11eb-9f54-0a5bf521835e' WHERE id = 'fc2bc190-f5d4-11eb-8ccc-17901c63413d';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('74e767b0-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', 'faac3510-8f66-11ee-89c1-731f17c336c3', 'Cookie Triple Chocolat ', '213326', 'Surgelés', '[{"nom":"Cookie","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 90 cookies","quantite":90,"unite":"unite","utilise_commande":true,"utilise_stock":false}]', 1, 69.16, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '74e767b0-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = 'faac3510-8f66-11ee-89c1-731f17c336c3';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('402e0aa0-6429-11ee-8970-bb53b4e54c59', 'd4617750-9add-11ec-ba94-f94c6b33e293', 'fc2f93f0-6428-11ee-8a36-29bc4666a7c6', 'Polo Burgundy Taille M', 'P01-BUR-M', 'Uniformes', '[{"nom":"Polo","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 0, 32, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '402e0aa0-6429-11ee-8970-bb53b4e54c59' WHERE id = 'fc2f93f0-6428-11ee-8a36-29bc4666a7c6';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('79185aa0-6429-11ee-ad4f-1351a0481861', 'd4617750-9add-11ec-ba94-f94c6b33e293', 'fc2f93f0-6428-11ee-8a36-29bc4666a7c6', 'Polo Burgundy Taille L', 'P01-BUR-L', 'Uniformes', '[{"nom":"Polo","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 0, 32, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '79185aa0-6429-11ee-ad4f-1351a0481861' WHERE id = 'fc2f93f0-6428-11ee-8a36-29bc4666a7c6';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('883e8720-6429-11ee-8a36-29bc4666a7c6', 'd4617750-9add-11ec-ba94-f94c6b33e293', 'fc2f93f0-6428-11ee-8a36-29bc4666a7c6', 'Polo Burgundy Taille XL', 'P01-BUR-XL', 'Uniformes', '[{"nom":"Polo","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":true}]', 0, 32, 5.5, 'unite', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '883e8720-6429-11ee-8a36-29bc4666a7c6' WHERE id = 'fc2f93f0-6428-11ee-8a36-29bc4666a7c6';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('32094ba0-94ca-11f0-99ae-49d8e489343b', 'e14520c4-9f72-11ea-8f42-0a5bf521835e', 'fcf1fa20-d1c2-11ec-88bd-5b29d81a78b4', 'Limonade Steff 1,5L', '230177', 'Boissons', '[{"nom":"Bouteille de 1,5 L ","quantite":1,"unite":"unite","utilise_commande":true,"utilise_stock":true},{"nom":"Colis de 6 Bouteilles","quantite":6,"unite":"L","utilise_commande":false,"utilise_stock":false}]', 0, 0.422, 5.5, 'L', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '32094ba0-94ca-11f0-99ae-49d8e489343b' WHERE id = 'fcf1fa20-d1c2-11ec-88bd-5b29d81a78b4';
INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES ('75ae1310-4e1b-11ee-99c3-efac9f73b6b5', 'a8700630-2b86-11ee-b43d-fba4734c3f62', 'fcf1fa20-d1c2-11ec-88bd-5b29d81a78b4', 'Limonade Steff 1,5L', '488270', 'Boissons', '[{"nom":"Bouteille de 1,5 L ","quantite":1,"unite":"unite","utilise_commande":false,"utilise_stock":true},{"nom":"Colis de 6 Bouteilles","quantite":6,"unite":"L","utilise_commande":true,"utilise_stock":false}]', 1, 0.422, 5.5, 'L', 0, true);
UPDATE ingredients_restaurant SET fournisseur_prefere_id = '75ae1310-4e1b-11ee-99c3-efac9f73b6b5' WHERE id = 'fcf1fa20-d1c2-11ec-88bd-5b29d81a78b4';

-- Recettes & Sous-recettes
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('0020e110-3091-11ee-af48-fb839ee61b42', 'PAD THAI TOFU NORMAL', 'recette', 'Plats', 0, '{"sur_place":{"ttc":11.5,"tva":10},"emporter":{"ttc":11.5,"tva":10},"livraison":{"ttc":11.5,"tva":10}}'::jsonb, '09f944', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('00398690-e54b-11eb-b993-552ff2e9d866', 'BBT Milky Lait Thai', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('009727f0-bee0-11eb-95fb-335b2b14a84d', 'Bo Bun Sam Normal Base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('01108240-55c9-11ed-b91e-49abdebf3d26', 'Ga Kho Crevettes', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.9,"tva":10},"emporter":{"ttc":12.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('015f1fb0-308c-11ee-af48-fb839ee61b42', 'VEGGIE CHOW MEIN GRAND', 'recette', 'Plats', 0, '{"sur_place":{"ttc":13.9,"tva":10},"emporter":{"ttc":13.9,"tva":10},"livraison":{"ttc":13.9,"tva":10}}'::jsonb, '6f26a3|be664a', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('01b02f80-c19e-11ec-b810-d1ffe210d8b1', 'FRITES PATATE DOUCE VG SP', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('0268e650-d1f3-11ec-94f4-0b63ddc79043', 'BBT Limo Fraise ', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('02a8cad0-b739-11ef-9837-1733243488a6', 'Diabolo Fraise', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('02b03e40-35b9-11ed-b203-11e5174470d0', 'Boeuf Loc Lac SP', 'recette', 'Plat du moment', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('044d1cf0-c15b-11ec-853d-e7960d3897c4', 'Ga Kho VG Tofu SP', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('05781630-d695-11ec-9aab-3f3b95fb7b18', 'Donut Chocolat SP', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('05b22a80-4c37-11f0-96ac-4dfcc125480a', 'Boulettes boeuf caramel', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('0658e230-53d2-11ee-ad93-4d410949057c', 'Phried Rice Tofu SP', 'recette', 'Plat du moment', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('06fce4b0-3083-11ee-af48-fb839ee61b42', 'BROCHETTES DE BOULETTES VG', 'recette', 'Plats', 0, '{"sur_place":{"ttc":7.5,"tva":10},"emporter":{"ttc":7.5,"tva":10},"livraison":{"ttc":7.5,"tva":10}}'::jsonb, '230d70', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('07993880-e321-11eb-b4a4-c79ec670c12e', 'Bo Bun Sam + Crev Normal EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('0839ead0-307e-11ee-af48-fb839ee61b42', 'PINTE', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":6,"tva":10},"emporter":{"ttc":6,"tva":10}}'::jsonb, '4D61B1', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('08fa8280-783f-11eb-ad37-09556bb1f395', 'Donut Nutella SP', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('0998d630-308c-11ee-af48-fb839ee61b42', 'GAKHO TOFU VG', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.5,"tva":10},"emporter":{"ttc":12.5,"tva":10},"livraison":{"ttc":12.5,"tva":10}}'::jsonb, '63b19a', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('0a864520-38d3-11ed-a934-65f0780a90b4', 'MA PO TOFU', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('0ac98ea0-bbb9-11ef-bb4e-b5c75a97c9e7', 'Tofu Curry Rouge', 'recette', 'Plat du moment', 0, '{"sur_place":{"ttc":14.9,"tva":10},"emporter":{"ttc":14.9,"tva":10},"livraison":{"ttc":17.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('0b166490-3083-11ee-af48-fb839ee61b42', 'MIXAO CHAY VG', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.5,"tva":10},"emporter":{"ttc":12.5,"tva":10},"livraison":{"ttc":12.5,"tva":10}}'::jsonb, 'd67805', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('0be66fb0-308c-11ee-af48-fb839ee61b42', 'COM CHIEN LARDONS VG', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.5,"tva":10},"emporter":{"ttc":12.5,"tva":10},"livraison":{"ttc":12.5,"tva":10}}'::jsonb, 'e53327', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('0c00cf20-3084-11ee-af48-fb839ee61b42', 'CHICKEN WINGS x5', 'recette', 'KUNG PHOOD', 0, '{"sur_place":{"ttc":6.9,"tva":10},"emporter":{"ttc":6.9,"tva":10},"livraison":{"ttc":6.9,"tva":10}}'::jsonb, 'C16A5C', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('0cb021c0-c97c-11ec-860d-478ebb9d77b5', 'Pho VG boulette normal EMP/LIV', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('0d0fb000-811d-11ed-9124-af8ed14a816a', 'Coca Cola Bouteille', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('0d341f00-3084-11ee-af48-fb839ee61b42', 'JUS DE POMME BIO', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":3.5,"tva":10},"emporter":{"ttc":3.5,"tva":10},"livraison":{"ttc":3.5,"tva":10}}'::jsonb, 'a7932d', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('0e0a0240-ebf3-11ec-a12f-77342cf624c3', 'Hanoï Salad SP', 'recette', 'Plat du moment', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('0e9eb340-1d9c-11ef-994d-0be528309243', 'Crousty tofu Pad Thai Normal Base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('0eee652c-abcf-11ea-9ac1-0a5bf521835e', 'Jus de canne BASE', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('0f07b540-307e-11ee-af48-fb839ee61b42', 'BBT MILKY ', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":5,"tva":10},"emporter":{"ttc":5,"tva":10},"livraison":{"ttc":5,"tva":10}}'::jsonb, 'DA007D', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('0fc4a730-307f-11ee-af48-fb839ee61b42', 'CHAMPIGNONS NOIR', 'recette', 'SPECIAL', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":0,"tva":10}}'::jsonb, '66362a', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('0fde96d0-308a-11ee-af48-fb839ee61b42', 'BBT Taro / Tapioca', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":1.5,"tva":10},"emporter":{"ttc":1.5,"tva":10},"livraison":{"ttc":5,"tva":10}}'::jsonb, '8b1f52', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('12148dd0-3083-11ee-af48-fb839ee61b42', 'MENTHE BIO', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":0,"tva":10}}'::jsonb, '491130', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('1215b130-3081-11ee-af48-fb839ee61b42', 'MOCHI LITCHI', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":0,"tva":10}}'::jsonb, '2A97A6', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('12a47ea0-757f-11ed-9601-4d9353852faa', 'Cookie Vanille EMP/LIV', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('12aca650-fe78-11ef-abd3-1d5bab16a12f', 'Sauce Sweet chili', 'recette', 'SAUCE', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('131b5770-6cdb-11ed-9eee-db05cb0c0e69', 'Assortiment Finger Phood', 'recette', 'Finger Phood', 0, '{"sur_place":{"ttc":15.9,"tva":10},"emporter":{"ttc":15.9,"tva":10},"livraison":{"ttc":17.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('15289b50-bba7-11ef-a2da-67539c782629', 'Sauce curry rouge', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('157c1100-237a-11f0-9aaa-bb233268bb26', 'Sauce mayonnaise', 'recette', 'Finger Phood', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('16025d90-e545-11eb-b993-552ff2e9d866', 'Double Expresso SP', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('167ee140-308d-11ee-af48-fb839ee61b42', 'BBT FRUITY HIBISCUS', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":4.6,"tva":10},"emporter":{"ttc":4.6,"tva":10},"livraison":{"ttc":4.6,"tva":10}}'::jsonb, 'c17525', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('1778d460-a63b-11ee-bbc7-c15280019a78', 'Gin basilic smash', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":8,"tva":10},"emporter":{"ttc":8,"tva":10},"livraison":{"ttc":8,"tva":10}}'::jsonb, 'BIBGB03032023', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('177c1f40-3088-11ee-af48-fb839ee61b42', 'MIXAO TOFU', 'recette', 'Plats', 0, '{"sur_place":{"ttc":11.5,"tva":10},"emporter":{"ttc":11.5,"tva":10},"livraison":{"ttc":11.5,"tva":10}}'::jsonb, '40a875', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('179d3d80-e303-11eb-9b9e-0f6f0f6fa679', 'Nouilles sautées', 'recette', 'Finger Phood', 0, '{"sur_place":{"ttc":4.5,"tva":10},"emporter":{"ttc":4.5,"tva":10},"livraison":{"ttc":5,"tva":10}}'::jsonb, 'E1130D', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('17a8ac50-d5c0-11ec-a670-e7c04af67adb', 'MIXAO VG Poulet EMP/LIV', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('18f57270-3080-11ee-af48-fb839ee61b42', 'BOBUN TOFU', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('1a293680-308b-11ee-af48-fb839ee61b42', 'BOBUN PC LAQUE GRAND', 'recette', 'Plats', 0, '{"sur_place":{"ttc":15,"tva":10},"emporter":{"ttc":15,"tva":10},"livraison":{"ttc":15,"tva":10}}'::jsonb, '4b83df|7ea495', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('1a558720-d712-11ee-ac52-0b6841810148', 'Tofu frit base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('1b1cf780-a8f1-11eb-9770-c18e5ed172e8', 'Panure ', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('1c361170-a974-11ee-8113-71b52dd3cd48', 'Jus Kookabarra', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":0,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('1c812ce0-fb05-11ee-a4a8-777d36a25868', 'SUPP Topping Chantilly ', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":0.9,"tva":10},"emporter":{"ttc":0.9,"tva":10},"livraison":{"ttc":0.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('1dedf140-e31a-11eb-8237-736a902b6e66', 'Riz sauté de tata poulet', 'recette', 'Plat du moment', 0, '{"sur_place":{"ttc":11.5,"tva":10},"emporter":{"ttc":11.5,"tva":10},"livraison":{"ttc":11.5,"tva":10}}'::jsonb, '178399', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('1e5ef750-d5e5-11ec-b2e2-5dd84dabb8a8', 'BROCHETTE VG Boulettes LIV', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('1ec5a060-d6ef-11ee-a52e-515320277cef', 'Crousty Tofu EMP/LIV ', 'recette', 'Plat du moment', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('1eceff90-3085-11ee-af48-fb839ee61b42', 'MIXAO PLT NORMAL', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.9,"tva":10},"emporter":{"ttc":12.9,"tva":10},"livraison":{"ttc":11.9,"tva":10}}'::jsonb, '2a424c|caa203', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('1ed9a360-3084-11ee-af48-fb839ee61b42', 'GOI BO TOFU NORMAL', 'recette', 'Plats', 0, '{"sur_place":{"ttc":11.9,"tva":10},"emporter":{"ttc":11.9,"tva":10},"livraison":{"ttc":11.9,"tva":10}}'::jsonb, '83373A|CAA203', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('1f4af000-757d-11ed-9ceb-4384b0d4acc1', 'Cookie Chocolat EMP/LIV', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('208b5f30-96b0-11ef-82ea-15fba2c86089', 'Crazy Nems Légumes', 'recette', 'Finger Phood', 0, '{"sur_place":{"ttc":8.9,"tva":10},"emporter":{"ttc":8.9,"tva":10},"livraison":{"ttc":8.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('214df760-3087-11ee-af48-fb839ee61b42', 'BBT FRUITY FLEUR DE CERISIER', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":2,"tva":10},"emporter":{"ttc":2,"tva":10},"livraison":{"ttc":2,"tva":10}}'::jsonb, '16c93c', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('21a25d40-2375-11f0-9aaa-bb233268bb26', 'Sirop à l''eau Mangue', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('21b6fff0-7734-11ee-a1ca-ed4795abb9e6', 'Goi Bo Crevettes Grand SP ', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('21bb8020-bee0-11eb-95fb-335b2b14a84d', 'Bo Bun Sam +Tofu Normal SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('225daaf0-308d-11ee-af48-fb839ee61b42', 'MIXAO CREV NORMAL', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.9,"tva":10},"emporter":{"ttc":12.9,"tva":10},"livraison":{"ttc":10,"tva":10}}'::jsonb, '22cbae', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('225dfab0-a827-11ef-b50d-0d342dc0c076', 'Pop Corn Ga kho SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('227ad740-308a-11ee-af48-fb839ee61b42', 'Donut Chocolat', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":2.3,"tva":10},"emporter":{"ttc":2.3,"tva":10},"livraison":{"ttc":3.1,"tva":10}}'::jsonb, 'eb9701', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('2376dff0-3089-11ee-af48-fb839ee61b42', 'PAD THAI CREV', 'recette', 'Plats', 0, '{"sur_place":{"ttc":14.9,"tva":10},"emporter":{"ttc":14.9,"tva":10},"livraison":{"ttc":14.9,"tva":10}}'::jsonb, 'e66923', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('2393f620-308f-11ee-af48-fb839ee61b42', 'TENDERS x6 ', 'recette', 'KUNG PHOOD', 0, '{"sur_place":{"ttc":7.5,"tva":10},"emporter":{"ttc":7.5,"tva":10},"livraison":{"ttc":7.5,"tva":10}}'::jsonb, '38B13A', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('24496840-e3d2-11eb-b993-552ff2e9d866', 'Chicken Wings BASE', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('255190d0-8f67-11ee-89c1-731f17c336c3', 'Cookie Triple Chocolat EMP/LIV ', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('25c73560-3085-11ee-af48-fb839ee61b42', 'PLAT DU MOMENT', 'recette', 'Plats', 0, '{"sur_place":{"ttc":10.9,"tva":10},"emporter":{"ttc":10.9,"tva":10},"livraison":{"ttc":10.9,"tva":10}}'::jsonb, 'd84941', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('269c8d20-308d-11ee-af48-fb839ee61b42', 'MOCHI CHOCOLAT/NOISETTE', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":0,"tva":10}}'::jsonb, '7326D9', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('27dcd880-610c-11ed-8963-4516daed1f7c', 'FRITES PATATE DOUCE VG EMP/LIV', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('29b41a70-b73a-11ef-93a1-c158d35cfb9e', 'Bubble Limo Fraise', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":0,"tva":10}}'::jsonb, '7b738a', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('2bba8770-a63b-11ee-b3cd-3d8b47d7dc66', 'Pornstar martini', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":8,"tva":10},"emporter":{"ttc":8,"tva":10},"livraison":{"ttc":8,"tva":10}}'::jsonb, 'BIBPM03032023', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('2ce78f84-1a03-11eb-9cb1-0a5bf521835e', 'Bière Saigon', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('2d25e250-d520-11ec-983e-772482502ae8', 'Bo Bun VG  Boulettes EMP/LIV', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('2d933d50-3082-11ee-af48-fb839ee61b42', 'Bò bún au poulet', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.9,"tva":10},"emporter":{"ttc":12.9,"tva":10},"livraison":{"ttc":11.5,"tva":10}}'::jsonb, '616c7a', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('2e2a9d80-3091-11ee-af48-fb839ee61b42', 'Mousse au chocolat coco', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":4,"tva":10},"emporter":{"ttc":4,"tva":10},"livraison":{"ttc":4,"tva":10}}'::jsonb, '#8E17EE', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('2e2e8200-cf2a-11ee-b6de-95c295bfc3e2', 'Bo Bun Thai Balls SP', 'recette', 'Plat du moment', 0, '{"sur_place":{"ttc":13.9,"tva":10},"emporter":{"ttc":13.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('2e5a7d12-1a09-11eb-8a54-0a5bf521835e', 'Sauce Nuoc Mam', 'recette', 'Supplément', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('31ea0b50-811d-11ed-b263-b95e21b5e348', 'Coca Cola Canette', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('320146d0-c994-11ec-a38a-8d13737e0b72', 'CHIA PUDDING VG Mangue SP', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('3224d030-307e-11ee-af48-fb839ee61b42', 'VEGGIE CHOW MEIN', 'recette', 'Plats', 0, '{"sur_place":{"ttc":10,"tva":10},"emporter":{"ttc":10,"tva":10},"livraison":{"ttc":10,"tva":10}}'::jsonb, '67d762', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('33e25cb0-de44-11ef-9861-a9c1b860eb22', 'Nouilles Curry Rouge boeuf', 'recette', 'Plat du moment', 0, '{"sur_place":{"ttc":14.9,"tva":10},"emporter":{"ttc":14.9,"tva":10},"livraison":{"ttc":14.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('33e88050-e88e-11ef-b713-6d60198332da', 'Nouilles Curry Jaune boeuf', 'recette', 'Plat du moment', 0, '{"sur_place":{"ttc":14.9,"tva":10},"emporter":{"ttc":14.9,"tva":10},"livraison":{"ttc":14.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('3468b980-e31c-11eb-8237-736a902b6e66', 'Biere Demi (25cl)', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('356dccf0-952d-11ef-9c52-43a2af8862e9', 'Ga Kho Boeuf Grand', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('364329b0-308c-11ee-af48-fb839ee61b42', 'SUPP TOFU', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":3,"tva":10},"emporter":{"ttc":3,"tva":10},"livraison":{"ttc":3,"tva":10}}'::jsonb, '44b80f', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('36dada00-3085-11ee-af48-fb839ee61b42', 'COOKIE VANILLE', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":2.5,"tva":10},"emporter":{"ttc":2.5,"tva":10},"livraison":{"ttc":2.5,"tva":10}}'::jsonb, '081c4c', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('3724da00-e321-11eb-b993-552ff2e9d866', 'Bo Bun Sam + Crev Grand SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('372ab570-308a-11ee-af48-fb839ee61b42', 'BROCHETTES DE TOFU VG', 'recette', 'Plats', 0, '{"sur_place":{"ttc":7.5,"tva":10},"emporter":{"ttc":7.5,"tva":10},"livraison":{"ttc":7.5,"tva":10}}'::jsonb, 'a299f3', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('374bc7e0-f306-11ed-b0fa-47c95be3e3ca', 'Salade Découpée', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('378429f0-46eb-11ec-939f-314f99801403', 'Carottes Râpées', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('386bb960-fb0b-11ee-8459-f9898c99c906', 'SUPP Thaï Balls', 'recette', 'Finger Phood', 0, '{"sur_place":{"ttc":3.9,"tva":10},"emporter":{"ttc":3.9,"tva":10},"livraison":{"ttc":3,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('38ea1030-a8b6-11eb-a511-a582f5c4cbb1', 'Boulette Bun Cha BASE', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('392abe10-8f67-11ee-a601-bd4702810762', 'Cookie Triple Chocolat SP ', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('39e02650-0969-11ec-aefc-8520bddbc69b', 'Riz sauté de tata boeuf', 'recette', 'Plat du moment', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":0,"tva":10}}'::jsonb, '0B7130', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('3cc5d830-1d9b-11ef-8c72-f55f24b8a876', 'Poulet crousty Pad Thai Normal Base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('3cd420f0-3086-11ee-af48-fb839ee61b42', 'MOCHI FRAMBOISE', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":0,"tva":10}}'::jsonb, '2B6F62', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('3ceee070-307c-11ee-af48-fb839ee61b42', ' Bubble tea fruity Passion/Grenade ', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":2.5,"tva":10},"emporter":{"ttc":2.5,"tva":10},"livraison":{"ttc":2.5,"tva":10}}'::jsonb, '4ff5b9', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('3e3b0dc0-a8fa-11eb-9770-c18e5ed172e8', 'Tenders', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('3e818e60-307c-11ee-af48-fb839ee61b42', 'BBT FRUITY GRENADE', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":4.6,"tva":10},"emporter":{"ttc":4.6,"tva":10},"livraison":{"ttc":4.6,"tva":10}}'::jsonb, '3cf3ba', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('3f700a20-c1a3-11ec-853d-e7960d3897c4', 'CHIA PUDDING VG Base', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('3f9f6b60-3085-11ee-af48-fb839ee61b42', 'Bière pression (pinte) KGB', 'recette', NULL, 0, '{"sur_place":{"ttc":7.5,"tva":10},"emporter":{"ttc":7.5,"tva":10},"livraison":{"ttc":7.5,"tva":10}}'::jsonb, 'e6d9a6', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('3fbc5850-307c-11ee-af48-fb839ee61b42', 'PLT POPCORN', 'recette', 'SPECIAL', 0, '{"sur_place":{"ttc":7.9,"tva":10},"emporter":{"ttc":7.9,"tva":10},"livraison":{"ttc":8.9,"tva":10}}'::jsonb, 'a81c67', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('4018f880-c19c-11ec-b810-d1ffe210d8b1', 'Boitage Nems VG SP', 'recette', 'Kit boitage', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('40287730-da74-11ef-a19c-19f230724a0f', 'Panna cotta oreo & thé noir', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":4,"tva":10},"emporter":{"ttc":4,"tva":10},"livraison":{"ttc":5.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('40a50750-c159-11ec-853d-e7960d3897c4', 'COMCHIEN VG Lardons SP', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('413878b0-d1f7-11ec-94f4-0b63ddc79043', 'BBT Limo Menthe', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('414ed610-8e22-11eb-a941-234f53fd3ac7', 'Riz blanc EMP/LIV', 'recette', 'Side', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('432c65e0-3089-11ee-af48-fb839ee61b42', 'PERLES GRENADE', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":0.9,"tva":10},"emporter":{"ttc":0.9,"tva":10},"livraison":{"ttc":0.9,"tva":10}}'::jsonb, 'e1055f', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('43bc1080-e31c-11eb-b4a4-c79ec670c12e', 'Biere Pinte (50cl)', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('43d54440-77a6-11ed-ba0d-73a48f825398', 'Fefe Concombre SP', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('43fa2710-edf5-11eb-8cf4-3f10540222ef', 'BBT Milky Lait De Coco', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('45144440-307f-11ee-af48-fb839ee61b42', 'MIXAO BF GRAND', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('4523fdf0-ab9b-11ec-a872-7595cd01f649', 'SALADE VG Side SP', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('4575d540-757f-11ed-9c6e-83547301d186', 'Mochis Glacés x2 EMP/LIV', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('457c5190-c15c-11ec-a2ba-7bb1dc10361f', 'BROCHETTE VG Boulettes SP', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('46c3e250-307a-11ee-af48-fb839ee61b42', 'BOBUN PLT GRAND', 'recette', 'Plats', 0, '{"sur_place":{"ttc":13.5,"tva":10},"emporter":{"ttc":13.5,"tva":10},"livraison":{"ttc":13.5,"tva":10}}'::jsonb, ' 616C7A|7EA495', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('47398600-f6d2-11ec-82ff-e103d8d6432f', 'Sauce Pad Thai VG', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('47d428a0-9317-11ec-bdf2-dbb798a33559', 'Pannacotta fruits rouges', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":5,"tva":10}}'::jsonb, 'c14efc', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('48cadac0-f6da-11ec-87d3-cf5d212ef325', 'PLAT DU MOMENT VG (tofu) #2 SP', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('48ebf5a0-307e-11ee-af48-fb839ee61b42', 'BOBUN CREV+SAM GRAND', 'recette', 'Plats', 0, '{"sur_place":{"ttc":13.9,"tva":10},"emporter":{"ttc":13.9,"tva":10},"livraison":{"ttc":13.9,"tva":10}}'::jsonb, '92181F|BE664A', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('4a536290-8f6d-11ee-a916-51fa99cb2a20', 'Crème Glacée Beurre de Cacahuètes', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('4ab6ad90-3d99-11ed-bc30-e32dbbc99e9f', 'Boulette Marinade  Laque VG ', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('4b5d6040-307d-11ee-af48-fb839ee61b42', 'EXTRA SAUCE SOJA', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":0.5,"tva":10}}'::jsonb, 'C0A2D0', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('4b91fd70-3080-11ee-af48-fb839ee61b42', 'CHIPS CREVETTES', 'recette', 'SPECIAL', 0, '{"sur_place":{"ttc":3.5,"tva":10},"emporter":{"ttc":3.5,"tva":10},"livraison":{"ttc":3.5,"tva":10}}'::jsonb, '516034', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('4c525450-308d-11ee-af48-fb839ee61b42', 'BOBUN CREV+NEMS', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.9,"tva":10},"emporter":{"ttc":12.9,"tva":10},"livraison":{"ttc":13,"tva":10}}'::jsonb, '0cb5fb', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('4c620230-3081-11ee-af48-fb839ee61b42', 'SUPP NEMS LÉGUMES', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":3.5,"tva":10},"emporter":{"ttc":3.5,"tva":10},"livraison":{"ttc":3,"tva":10}}'::jsonb, '407b28', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('4d132c80-4bda-11ee-b9c8-7dced45403b1', 'Gauffre Base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('4e4227a0-53d2-11ee-ad93-4d410949057c', 'Phried Rice Crevettes SP', 'recette', 'Plat du moment', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('4f22aab0-e321-11eb-8237-736a902b6e66', 'Bo Bun Sam + Crev Grand EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('4f8c2390-3082-11ee-af48-fb839ee61b42', 'SAUCE BBQ', 'recette', 'SAUCE', 0, '{"sur_place":{"ttc":0.5,"tva":10},"emporter":{"ttc":0.5,"tva":10},"livraison":{"ttc":0.5,"tva":10}}'::jsonb, '0F54E9', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('50e1d640-3087-11ee-af48-fb839ee61b42', 'SUPP CREVETTES', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":3,"tva":10},"emporter":{"ttc":3,"tva":10},"livraison":{"ttc":3,"tva":10}}'::jsonb, 'bfb86e', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('533d6ef0-3086-11ee-af48-fb839ee61b42', 'BBT LIMO PECHE', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":0,"tva":10}}'::jsonb, '1f68ee', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('54953940-53d1-11ee-98c2-6770c73d7d3c', 'Phried Rice Base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('54bf74b0-307e-11ee-af48-fb839ee61b42', 'BBT LIMO MENTHE (2)', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":4.6,"tva":10},"emporter":{"ttc":4.6,"tva":10},"livraison":{"ttc":4.6,"tva":10}}'::jsonb, '39aacc', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('54e9ef60-811f-11ed-8419-9d8d34a930fb', 'Ousia 0%', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('55239840-307f-11ee-af48-fb839ee61b42', 'BOBUN PC LAQUE NORMAL', 'recette', 'Plats', 0, '{"sur_place":{"ttc":13.5,"tva":10},"emporter":{"ttc":13.5,"tva":10},"livraison":{"ttc":15.5,"tva":10}}'::jsonb, 'CB9B14', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('553380e0-3583-11ed-9926-7f25ebd78fb7', 'Bo Bun Normal Base - dosette TT', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('554fd590-f845-11ec-86ff-13fce83436c9', 'PLAT DU MOMENT VG (tofu) #2 LIV', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('55a7ad00-87b3-11eb-ba42-2d944e66f12b', 'Supplément porc laque', 'recette', 'Supplément', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('574c6de0-308e-11ee-af48-fb839ee61b42', 'Ga kho Grande', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('578a7760-3085-11ee-af48-fb839ee61b42', 'PERLES FRAMBOISE', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":0.9,"tva":10},"emporter":{"ttc":0.9,"tva":10},"livraison":{"ttc":0.9,"tva":10}}'::jsonb, 'E564E4', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('58400cc0-307a-11ee-af48-fb839ee61b42', 'BBT MILKY TARO', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":3.22,"tva":10},"emporter":{"ttc":3.22,"tva":10},"livraison":{"ttc":4.6,"tva":10}}'::jsonb, '219221', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('585a97a0-3090-11ee-af48-fb839ee61b42', 'NEMS LÉGUMES VG', 'recette', 'Plats', 0, '{"sur_place":{"ttc":7.5,"tva":10},"emporter":{"ttc":7.5,"tva":10},"livraison":{"ttc":7.5,"tva":10}}'::jsonb, 'bd2bbb', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('588bad00-3080-11ee-af48-fb839ee61b42', 'Pad thaï aux crevettes Grande', 'recette', 'Plats', 0, '{"sur_place":{"ttc":15,"tva":10},"emporter":{"ttc":15,"tva":10},"livraison":{"ttc":15,"tva":10}}'::jsonb, 'e66923|7ea495', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('58b82420-de44-11ef-9861-a9c1b860eb22', 'Nouilles Curry Rouge poulet', 'recette', 'Plat du moment', 0, '{"sur_place":{"ttc":14.9,"tva":10},"emporter":{"ttc":14.9,"tva":10},"livraison":{"ttc":14.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('59589190-308e-11ee-af48-fb839ee61b42', 'DONUT NUTELLA', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":2.5,"tva":10},"emporter":{"ttc":2.5,"tva":10},"livraison":{"ttc":2.5,"tva":10}}'::jsonb, '69e83b', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('59e342c0-87d2-11eb-b96f-7177973d12e2', 'Riz blanc SP', 'recette', 'Side', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('5a322000-c158-11ec-9265-d57037e66861', 'COMCHIEN VG Légumes SP', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('5a578d00-cf29-11ee-b6de-95c295bfc3e2', 'Phried Thai Balls EMP/LIV', 'recette', 'Plat du moment', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('5b05ba10-cf50-11ef-9028-f1198bb1e3d6', 'Sauce curry jaune', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('5b1b38e0-307d-11ee-af48-fb839ee61b42', 'RIZ BLANC', 'recette', 'SPECIAL', 0, '{"sur_place":{"ttc":4,"tva":10},"emporter":{"ttc":4,"tva":10},"livraison":{"ttc":4,"tva":10}}'::jsonb, '17dcb0', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('5bf82a60-3088-11ee-af48-fb839ee61b42', 'CREVETTES CARAMEL', 'recette', 'Plats', 0, '{"sur_place":{"ttc":11,"tva":10},"emporter":{"ttc":11,"tva":10},"livraison":{"ttc":11,"tva":10}}'::jsonb, 'AECBB8|CAA203', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('5cbda90e-1a04-11eb-b255-0a5bf521835e', 'Sauce Piment', 'recette', 'Supplément', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('5d92e410-3087-11ee-af48-fb839ee61b42', 'Oignons frits', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":0.5,"tva":10},"emporter":{"ttc":0.5,"tva":10},"livraison":{"ttc":0.5,"tva":10}}'::jsonb, '8c949a', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('5ec7fee0-e88e-11ef-9ae0-e94d7470c07a', 'Nouilles Curry Jaune Crevettes', 'recette', 'Plat du moment', 0, '{"sur_place":{"ttc":14.9,"tva":10},"emporter":{"ttc":14.9,"tva":10},"livraison":{"ttc":14.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('5fca0900-307f-11ee-af48-fb839ee61b42', 'BUN CHA', 'recette', 'Plats', 0, '{"sur_place":{"ttc":11.9,"tva":10},"emporter":{"ttc":11.9,"tva":10},"livraison":{"ttc":11.9,"tva":10}}'::jsonb, 'EC958D', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('5fd18ab0-bedd-11eb-b72d-730bbd0b1638', 'Bo Bun Sam Grand Base ', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('5fdd5510-bede-11eb-95fb-335b2b14a84d', 'Bo Bun Sam +Tofu Grand EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('6029fbf0-3082-11ee-af48-fb839ee61b42', 'Verre vin blanc', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":5.5,"tva":10},"emporter":{"ttc":5.5,"tva":10}}'::jsonb, '9D24E0', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('60738c90-d1f9-11ec-b363-f7982c6efb86', 'BBT Fruity Peche', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('61942680-d1f3-11ec-b363-f7982c6efb86', 'BBT Limo Passion', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('61a0f340-307c-11ee-af48-fb839ee61b42', 'Lait thai ', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":0,"tva":10}}'::jsonb, '09745F|CAA203', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('61b0d79e-1a02-11eb-8e96-0a5bf521835e', 'Perles de Coco', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":4.9,"tva":10},"emporter":{"ttc":4.9,"tva":10},"livraison":{"ttc":5,"tva":10}}'::jsonb, '3eac52', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('62079490-308d-11ee-af48-fb839ee61b42', 'PHO SATAY GRAND', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.9,"tva":10},"emporter":{"ttc":12.9,"tva":10},"livraison":{"ttc":12.9,"tva":10}}'::jsonb, '4497f1|7ea495', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('62236300-38d1-11ed-88aa-d327dbab6e49', 'Sauce Riz Rouge', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('62352cb0-c44d-11eb-933b-0fde1972ba99', 'BBT Milky Base Sans Lait', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('63596fd0-f6d7-11ec-82ff-e103d8d6432f', 'PLAT DU MOMENT VG (poulet) #2 LIV', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('64644a40-3082-11ee-af48-fb839ee61b42', 'BOBUN TOFU GRAND', 'recette', 'Plats', 0, '{"sur_place":{"ttc":14.5,"tva":10},"emporter":{"ttc":14.5,"tva":10},"livraison":{"ttc":14.5,"tva":10}}'::jsonb, 'fe1ae6|be664a', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('6793b510-307e-11ee-af48-fb839ee61b42', 'BBT MILKY LAIT DE COCO (2)', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":0,"tva":10}}'::jsonb, 'B81386', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('67eb2c90-7581-11ed-9ceb-4384b0d4acc1', 'Donut Chocolat EMP/LIV', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('67ed40f0-811d-11ed-b263-b95e21b5e348', 'Gallia', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('6a121b90-1d9c-11ef-8e49-3f4681dd1e3c', 'Pad thai Crousty tofu', 'recette', 'Plats', 0, '{"sur_place":{"ttc":15.9,"tva":10},"emporter":{"ttc":15.9,"tva":10},"livraison":{"ttc":17.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('6b2ebd80-307b-11ee-af48-fb839ee61b42', 'FRITES PATATE DOUCE', 'recette', 'SPECIAL', 0, '{"sur_place":{"ttc":4.5,"tva":10},"emporter":{"ttc":4.5,"tva":10},"livraison":{"ttc":4.5,"tva":10}}'::jsonb, 'bc2331', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('6b794010-46eb-11ec-bc07-efd394bb365a', 'Poivron rouge', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('6bb018f0-d5c1-11ec-8b7a-0f22ec019de6', 'PLAT DU MOMENT VG #1 LIV', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('6bd981d0-308e-11ee-af48-fb839ee61b42', 'PAD THAI POULET GRAND', 'recette', 'Plats', 0, '{"sur_place":{"ttc":13.9,"tva":10},"emporter":{"ttc":13.9,"tva":10},"livraison":{"ttc":14.9,"tva":10}}'::jsonb, '492B25', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('6c33fb20-4821-11ed-a241-9d0cf2de716e', 'Boeuf Loc Lac EMP/LIV', 'recette', 'Plat du moment', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('6cfb1a70-952c-11ef-afc3-13d48984d813', 'Boeuf caramel wok normal', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('6d32b370-e320-11eb-b993-552ff2e9d866', 'Bo Bun Sam + Crev Normal SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('6def0ea0-307e-11ee-af48-fb839ee61b42', 'PERLES MANGUE', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":0.9,"tva":10},"emporter":{"ttc":0.9,"tva":10},"livraison":{"ttc":0.9,"tva":10}}'::jsonb, 'E7302A', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('6e6aab10-a827-11ef-b50d-0d342dc0c076', 'Pop Corn Ga kho EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('6ed90490-b1fa-11ed-8398-4d566f64bec9', 'Sauce Crousty Gà', 'recette', 'Préparation', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('6f6f40d0-3090-11ee-af48-fb839ee61b42', 'BBT FRUITY', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":2.5,"tva":10},"emporter":{"ttc":2.5,"tva":10},"livraison":{"ttc":4.6,"tva":10}}'::jsonb, '9C9654', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('6fd5a7f0-3089-11ee-af48-fb839ee61b42', 'MOCHI FRAISE', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":0,"tva":10}}'::jsonb, 'BCEBCB', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('70606980-308e-11ee-af48-fb839ee61b42', 'Cookie Chocolat blc Framboise', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":2,"tva":10},"emporter":{"ttc":2,"tva":10},"livraison":{"ttc":3.1,"tva":10}}'::jsonb, '60d802', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('72d41420-e53a-11ef-ad07-115a9609c7c9', 'Chicken Wings', 'recette', 'Finger Phood', 0, '{"sur_place":{"ttc":8.9,"tva":10},"emporter":{"ttc":8.9,"tva":10},"livraison":{"ttc":8.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('73cbbc20-de4b-11ef-b1c9-b184c04c9ff1', 'Sirop à l''eau', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('74bb7ee0-d5e3-11ec-a670-e7c04af67adb', 'Nems VG EMP/LIV', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('74d26aa0-3083-11ee-af48-fb839ee61b42', 'GOI BO TOFU GRAND', 'recette', 'Plats', 0, '{"sur_place":{"ttc":13.9,"tva":10},"emporter":{"ttc":13.9,"tva":10},"livraison":{"ttc":13.9,"tva":10}}'::jsonb, '83373A|BE664A', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('758be7e0-3089-11ee-af48-fb839ee61b42', 'PERLES PASSION', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":0.9,"tva":10},"emporter":{"ttc":0.9,"tva":10},"livraison":{"ttc":0.9,"tva":10}}'::jsonb, '2BCBD3', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('764b4370-308d-11ee-af48-fb839ee61b42', 'Ga kho', 'recette', 'Plats', 0, '{"sur_place":{"ttc":14.9,"tva":10},"emporter":{"ttc":14.9,"tva":10},"livraison":{"ttc":14.9,"tva":10}}'::jsonb, '739679', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('76f94670-307c-11ee-af48-fb839ee61b42', 'BIERE SAIGON', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":4.9,"tva":10},"emporter":{"ttc":4.9,"tva":10},"livraison":{"ttc":4.9,"tva":10}}'::jsonb, 'D30FB1', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('779c3800-308e-11ee-af48-fb839ee61b42', 'GAKHO VG', 'recette', 'Plats', 0, '{"sur_place":{"ttc":11.9,"tva":10},"emporter":{"ttc":11.9,"tva":10},"livraison":{"ttc":11.9,"tva":10}}'::jsonb, '38a98d', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('77bbb370-d5cb-11ec-a670-e7c04af67adb', 'Boitage Nems VG LIV ', 'recette', 'Kit boitage', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('77d9cbe0-4bda-11ee-a133-513b0bc2e397', 'Gaufre Nature', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('784d06a0-8487-11ef-8ef8-37c5596a9593', 'Tofu frit mariné base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('788dbe50-e88e-11ef-9187-5bc2ac66eb1e', 'Nouilles Curry Jaune poulet', 'recette', 'Plat du moment', 0, '{"sur_place":{"ttc":14.9,"tva":10},"emporter":{"ttc":14.9,"tva":10},"livraison":{"ttc":14.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('7925f31a-19d9-11eb-bd61-0a5bf521835e', 'Menthe fraîche ciselée', 'recette', 'Supplément', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('79ecf810-3089-11ee-af48-fb839ee61b42', 'DOUBLE EXPRESSO', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":1.9,"tva":10},"emporter":{"ttc":1.9,"tva":10},"livraison":{"ttc":1.9,"tva":10}}'::jsonb, '1369b5', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('7a30c080-d1f9-11ec-b363-f7982c6efb86', 'BBT Limo Peche (2)', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('7a3c2320-3081-11ee-af48-fb839ee61b42', 'BBT MILKY LAIT THAi (2)', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":0,"tva":10}}'::jsonb, '09745F', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('7b268db0-3082-11ee-af48-fb839ee61b42', 'BBT passion / mangue', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":1.5,"tva":10},"emporter":{"ttc":1.5,"tva":10},"livraison":{"ttc":1.5,"tva":10}}'::jsonb, '9257a0', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('7c32a4d0-e545-11eb-b993-552ff2e9d866', 'Double Expresso EMP/LIV', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('7d1f5370-fb04-11ee-a4a8-777d36a25868', 'SUPP Topping Daim', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":1.1,"tva":10},"emporter":{"ttc":1.1,"tva":10},"livraison":{"ttc":1.2,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('7de3eb70-b1fb-11ed-a45c-5f2ed7b3184f', 'Crousty Gà', 'recette', 'Plats', 0, '{"sur_place":{"ttc":13.5,"tva":10},"emporter":{"ttc":13.5,"tva":10},"livraison":{"ttc":15.5,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('7dfe9fa0-e553-11ef-8b3c-2dedf456f4e7', 'Extra Chicken Wings', 'recette', 'Finger Phood', 0, '{"sur_place":{"ttc":4,"tva":10},"emporter":{"ttc":4,"tva":10},"livraison":{"ttc":5,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('7f1f7f60-9784-11eb-819d-97a3d64b2bfa', 'Boeuf Oignons Grand', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('806437b0-3081-11ee-af48-fb839ee61b42', 'GOI BO GRAND', 'recette', 'Plats', 0, '{"sur_place":{"ttc":14.5,"tva":10},"emporter":{"ttc":14.5,"tva":10},"livraison":{"ttc":14.5,"tva":10}}'::jsonb, 'fbf0ce|be664a', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('80693d70-9784-11eb-819d-97a3d64b2bfa', 'Boeuf Oignons Normal', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('80ac2f70-307c-11ee-af48-fb839ee61b42', 'BOBUN BOULETTES VG', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.5,"tva":10},"emporter":{"ttc":12.5,"tva":10},"livraison":{"ttc":12.5,"tva":10}}'::jsonb, 'e167cd', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('813c8560-9868-11eb-9abf-858942205919', 'Jus de canne SP', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('81befd10-d520-11ec-9a5d-f575e98074a0', 'Bo Bun VG   Légumes EMP/LIV', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('821c66a0-308f-11ee-af48-fb839ee61b42', 'BBT FRUITY YUZU/CITRON', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":5,"tva":10},"emporter":{"ttc":5,"tva":10},"livraison":{"ttc":5,"tva":10}}'::jsonb, 'C4E25C', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('825d9aa0-e88d-11ef-b713-6d60198332da', 'Nouilles Curry Jaune tofu', 'recette', 'Plat du moment', 0, '{"sur_place":{"ttc":14.9,"tva":10},"emporter":{"ttc":14.9,"tva":10},"livraison":{"ttc":14.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('82d3e2ee-1a03-11eb-accb-0a5bf521835e', 'Citronnade Bio', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('837cd110-307b-11ee-af48-fb839ee61b42', 'EXTRA MENTHE', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":0.5,"tva":10},"emporter":{"ttc":0.5,"tva":10},"livraison":{"ttc":0.5,"tva":10}}'::jsonb, '49a79d', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('83dc0710-3086-11ee-af48-fb839ee61b42', 'Bouteille vin rouge', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":22,"tva":10},"emporter":{"ttc":22,"tva":10},"livraison":{"ttc":22,"tva":10}}'::jsonb, 'EFD603', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('849e0ed0-a99e-11eb-a232-bb1b67e0525e', 'Bun Cha Base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('84f02310-d5c0-11ec-9916-a1c1f658f229', 'COMCHIEN VG Lardons LIV', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('84f86af0-be1b-11ec-92b5-d17e9a4e477d', 'SAUCE NUOC MAM VG', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('8567d730-3086-11ee-af48-fb839ee61b42', 'CHEESCAKE MANGUE OREO', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":6,"tva":10},"emporter":{"ttc":6,"tva":10},"livraison":{"ttc":6,"tva":10}}'::jsonb, '0B5FF8', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('85862ad0-9deb-11eb-9fc3-c54eb2b1a2bd', 'Goi Bo Tofu', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('85e0a480-811d-11ed-b263-b95e21b5e348', 'Jus la Boissonnerie', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('85e7df00-952c-11ef-b1c9-a52e879704e5', 'Boeuf caramel wok grand', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('864d3be0-308b-11ee-af48-fb839ee61b42', 'BBT FRUITY KUMQUAT ', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":0,"tva":10}}'::jsonb, 'cb8d7f', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('8800beb0-cc0f-11ee-8044-7df45c52b284', 'Pho poulet grand', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('88082af0-308e-11ee-af48-fb839ee61b42', 'TENDERS x9', 'recette', 'KUNG PHOOD', 0, '{"sur_place":{"ttc":10.9,"tva":10},"emporter":{"ttc":10.9,"tva":10},"livraison":{"ttc":10.9,"tva":10}}'::jsonb, '4B23A6', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('88af7960-308c-11ee-af48-fb839ee61b42', 'Bœuf Loc Lac', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.5,"tva":10},"emporter":{"ttc":12.5,"tva":10},"livraison":{"ttc":12.5,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('89c8f070-72b0-11eb-a732-3588446adb69', 'Cookie Framboise SP', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('8a42c490-3081-11ee-af48-fb839ee61b42', 'Pho tofu normal', 'recette', 'Plats', 0, '{"sur_place":{"ttc":11.9,"tva":10},"emporter":{"ttc":11.9,"tva":10},"livraison":{"ttc":11.9,"tva":10}}'::jsonb, 'CB171C|CAA203', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('8ac32a30-2374-11f0-953f-0dfe025424db', 'Sirop à l''eau Grenade', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('8af64270-cf51-11ef-ab41-33862f723ed5', 'Boeuf Curry Jaune', 'recette', 'Plat du moment', 0, '{"sur_place":{"ttc":14.9,"tva":10},"emporter":{"ttc":14.9,"tva":10},"livraison":{"ttc":16.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('8b0d3f80-308c-11ee-af48-fb839ee61b42', 'PERLES KIWI', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":0.9,"tva":10},"emporter":{"ttc":0.9,"tva":10},"livraison":{"ttc":0.9,"tva":10}}'::jsonb, '48ef46', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('8b8f1d2a-1a05-11eb-912d-0a5bf521835e', 'HIBISCUS MENTHE BIO', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":3.9,"tva":10},"emporter":{"ttc":3.9,"tva":10},"livraison":{"ttc":3.9,"tva":10}}'::jsonb, '857c2b', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('8c249fc0-3088-11ee-af48-fb839ee61b42', 'COM CHIEN CHAY VG', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.5,"tva":10},"emporter":{"ttc":12.5,"tva":10},"livraison":{"ttc":12.5,"tva":10}}'::jsonb, '7aefa8', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('8c3685a0-307e-11ee-af48-fb839ee61b42', 'MIXAO PORC LAQUE GRAND', 'recette', 'Plats', 0, '{"sur_place":{"ttc":15,"tva":10},"emporter":{"ttc":15,"tva":10},"livraison":{"ttc":15,"tva":10}}'::jsonb, 'e3df77|7ea495', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('8ce05420-fb75-11ec-82ff-e103d8d6432f', 'BBT Fruity Kumquat (2)', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('8d0c5fa0-53d2-11ee-b332-e9fcffa35d2c', 'Phried Rice Poulet EMP/LIV', 'recette', 'Plat du moment', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('8d539180-6168-11ec-b4f3-f589907dab6b', 'Perles kiwi pour bbt', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('8e0501b0-ea2f-11ef-b574-a13e4e584bf5', 'Pho crevettes normal', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.9,"tva":10},"emporter":{"ttc":12.9,"tva":10},"livraison":{"ttc":14.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('8e3059d0-307e-11ee-af48-fb839ee61b42', 'CHIA PUDDING EXOTIQUE VG', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":6,"tva":10},"emporter":{"ttc":6,"tva":10},"livraison":{"ttc":6,"tva":10}}'::jsonb, '383944', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('8e57e2d0-a827-11ef-8e56-e34985f0ea4e', 'Pop Corn Tofu Caramel SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('8e7c7c00-de44-11ef-b2c8-4d73a1025b97', 'Nouilles Curry Rouge tofu', 'recette', 'Plat du moment', 0, '{"sur_place":{"ttc":12.9,"tva":10},"emporter":{"ttc":12.9,"tva":10},"livraison":{"ttc":14.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('8e828490-d5e8-11ec-b2e2-5dd84dabb8a8', 'SALADE VG Side EMP/LIV', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('8f1cd300-c153-11ec-a2ba-7bb1dc10361f', 'Légumes VG Sautés ', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('8f7936fc-1a08-11eb-8432-0a5bf521835e', 'Sauce Soja', 'recette', 'Supplément', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('902e5410-307b-11ee-af48-fb839ee61b42', 'MOCHI GLACE', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":5,"tva":10},"emporter":{"ttc":5,"tva":10},"livraison":{"ttc":5,"tva":10}}'::jsonb, '94a02b', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('91852d50-3082-11ee-af48-fb839ee61b42', 'SUPP BOULETTES LEG', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":3,"tva":10},"emporter":{"ttc":3,"tva":10},"livraison":{"ttc":3,"tva":10}}'::jsonb, '04c681', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('92834de0-3583-11ed-9926-7f25ebd78fb7', 'Boitage Bobun Normal - dosette TT', 'recette', 'Kit boitage', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('931ca900-c156-11ec-853d-e7960d3897c4', 'MIXAO VG Légumes SP', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('93798aa0-307f-11ee-af48-fb839ee61b42', 'PERLES FRAISE', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":0.9,"tva":10},"emporter":{"ttc":0.9,"tva":10},"livraison":{"ttc":0.9,"tva":10}}'::jsonb, '10B528', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('93887a90-3086-11ee-af48-fb839ee61b42', 'PAD THAI TOFU GRAND', 'recette', 'Plats', 0, '{"sur_place":{"ttc":13.5,"tva":10},"emporter":{"ttc":13.5,"tva":10},"livraison":{"ttc":13.5,"tva":10}}'::jsonb, '09f944|7ea495', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('93cf2c10-307c-11ee-af48-fb839ee61b42', 'MOCHI VANILLE', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":0,"tva":10}}'::jsonb, 'EE9E23', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('941a4310-e1ea-11ee-b192-db3c6a6f33c1', 'Fromage Blanc ', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":2.2,"tva":10},"emporter":{"ttc":2.2,"tva":10},"livraison":{"ttc":2.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('9461e7ac-19ec-11eb-b914-0a5bf521835e', 'Extra Citron Vert', 'recette', 'Supplément', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('959ac860-c156-11ec-a2ba-7bb1dc10361f', 'MIXAO VG Poulet SP', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('95a03060-9def-11eb-b727-2bf863f3754b', 'Pho tofu grand SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('96448920-308d-11ee-af48-fb839ee61b42', 'BOBUN CHAY VG', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.5,"tva":10},"emporter":{"ttc":12.5,"tva":10},"livraison":{"ttc":12.5,"tva":10}}'::jsonb, '6bdbc7', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('970c45f0-308d-11ee-af48-fb839ee61b42', 'PAD THAI PC LAQUE GRAND', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.9,"tva":10},"emporter":{"ttc":12.9,"tva":10},"livraison":{"ttc":12.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('9737dd10-307d-11ee-af48-fb839ee61b42', 'BBT MILKY ORIGINAL', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":4.6,"tva":10},"emporter":{"ttc":4.6,"tva":10},"livraison":{"ttc":4.6,"tva":10}}'::jsonb, 'F6B9D0', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('9744f510-3080-11ee-af48-fb839ee61b42', 'Pho tofu grand', 'recette', 'Plats', 0, '{"sur_place":{"ttc":13.9,"tva":10},"emporter":{"ttc":13.9,"tva":10},"livraison":{"ttc":13.9,"tva":10}}'::jsonb, 'CB171C|BE664A', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('97d07f20-1f03-11ed-b321-cb89e2c9960f', 'Mochis Glacés x2 SP', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('99ec6800-9868-11eb-9e4f-6d7301ceddce', 'Jus de canne EMP/LIV', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('9ba576c0-3085-11ee-af48-fb839ee61b42', 'SUPP BOEUF', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":3,"tva":10},"emporter":{"ttc":3,"tva":10},"livraison":{"ttc":3,"tva":10}}'::jsonb, '911aa8', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('9bc86d00-00f0-11f0-875d-858d9ed2850d', 'Bo Bun Tofu Base Normal', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('9bfa76e0-7580-11ed-a0a7-1b2de41c84da', 'Pot de glace noix de coco SP ', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('9c013d40-3083-11ee-af48-fb839ee61b42', 'MOCHI PISTACHE', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":0,"tva":10}}'::jsonb, 'E73D23', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('9c85c030-0969-11ec-80fe-8d0b2ae362cc', 'Riz sauté de tata tofu', 'recette', 'Plat du moment', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":0,"tva":10}}'::jsonb, 'F340A5', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('9ccd89c0-308a-11ee-af48-fb839ee61b42', 'PHO BOULETTES GRAND', 'recette', 'Plats', 0, '{"sur_place":{"ttc":13.9,"tva":10},"emporter":{"ttc":13.9,"tva":10},"livraison":{"ttc":13.9,"tva":10}}'::jsonb, '64d53f|be664a', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('9d4d4230-2374-11f0-8e38-472558b3b72f', 'Sirop à l''eau Yuzu/citron', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('9d5d7080-f0ca-11ed-9ff6-59801b43f17c', 'Poulet au coco', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('9da7d670-3085-11ee-af48-fb839ee61b42', 'Mi xao au poulet Grande', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12,"tva":10},"emporter":{"ttc":12,"tva":10},"livraison":{"ttc":12,"tva":10}}'::jsonb, 'd85aff|7ea495', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('9dd760c0-f5d1-11eb-a95c-45ac352893ba', 'BBT Fruity Yuzu/Citron (2)', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('9de32ba0-bede-11eb-b72d-730bbd0b1638', 'Bo Bun Sam +Tofu Grand  SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('9e2d9cb0-de3f-11ef-a5b2-37188811106e', 'Nouilles Curry Rouge Crevettes', 'recette', 'Plat du moment', 0, '{"sur_place":{"ttc":14.9,"tva":10},"emporter":{"ttc":14.9,"tva":10},"livraison":{"ttc":13.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('9e3d1030-cf50-11ef-8b1f-795efc194fa4', 'Crevettes Curry Jaune', 'recette', 'Plat du moment', 0, '{"sur_place":{"ttc":14.9,"tva":10},"emporter":{"ttc":14.9,"tva":10},"livraison":{"ttc":14.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('9effd310-308a-11ee-af48-fb839ee61b42', 'BOBUN "POULET" VG', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.5,"tva":10},"emporter":{"ttc":12.5,"tva":10},"livraison":{"ttc":12.5,"tva":10}}'::jsonb, 'eda146', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('9f1d65d0-308d-11ee-af48-fb839ee61b42', 'SUPP POULET', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":3,"tva":10},"emporter":{"ttc":3,"tva":10},"livraison":{"ttc":3,"tva":10}}'::jsonb, 'B3D6DD', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a0183b30-307a-11ee-af48-fb839ee61b42', 'SUPP OEUFS', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":2.4,"tva":10},"emporter":{"ttc":2.4,"tva":10},"livraison":{"ttc":2.7,"tva":10}}'::jsonb, 'C17463', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a0917090-307f-11ee-af48-fb839ee61b42', 'PERLES TAPIOCA', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":0.9,"tva":10},"emporter":{"ttc":0.9,"tva":10},"livraison":{"ttc":0.9,"tva":10}}'::jsonb, 'A1B76D', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a0ccfde0-1d9b-11ef-93d6-1dc8be8e1247', 'Pad thai Poulet crousty', 'recette', 'Plats', 0, '{"sur_place":{"ttc":15.9,"tva":10},"emporter":{"ttc":15.9,"tva":10},"livraison":{"ttc":17.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a0cf7f70-3089-11ee-af48-fb839ee61b42', 'PIMENT FRAIS', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":0.5,"tva":10},"emporter":{"ttc":0.5,"tva":10}}'::jsonb, '561F4C', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a1809940-3084-11ee-af48-fb839ee61b42', 'Verre vin rouge', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":5,"tva":10},"emporter":{"ttc":5,"tva":10}}'::jsonb, '4E6025', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a26c8-9c4d-11ea-93a9-0a5bf521835e', 'Riz cuit', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a29b6-9c4d-11ea-93aa-0a5bf521835e', 'Porc laqué vrac', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a2a9c-9c4d-11ea-93ab-0a5bf521835e', 'Porc laqué', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a2b50-9c4d-11ea-93ac-0a5bf521835e', 'Tofu frit', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a2bfa-9c4d-11ea-93ad-0a5bf521835e', 'Poulet blanchi', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a2cae-9c4d-11ea-93ae-0a5bf521835e', 'Crevettes Cuites', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a2d62-9c4d-11ea-93af-0a5bf521835e', 'Vermicelles de riz cuits BASE', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a2e0c-9c4d-11ea-93b0-0a5bf521835e', 'Champignons Noir Hydratés', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a2eb6-9c4d-11ea-93b1-0a5bf521835e', 'Nouilles de blé cuites', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a2f6a-9c4d-11ea-93b2-0a5bf521835e', 'Pâtes de riz hydratées', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a3014-9c4d-11ea-93b3-0a5bf521835e', 'Boeuf Citronnelle Wok Base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a30be-9c4d-11ea-93b4-0a5bf521835e', 'Poulet gingembre wok', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a3168-9c4d-11ea-93b5-0a5bf521835e', 'Tofu frit wok', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a3212-9c4d-11ea-93b6-0a5bf521835e', 'Crevettes Wok Normal', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a32bc-9c4d-11ea-93b7-0a5bf521835e', 'Crevettes Wok Grand', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a3366-9c4d-11ea-93b8-0a5bf521835e', 'Tofu veggie chow mein', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a341a-9c4d-11ea-93b9-0a5bf521835e', 'Poulet caramel wok normal', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a34c4-9c4d-11ea-93ba-0a5bf521835e', 'Poulet caramel wok grand', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a3578-9c4d-11ea-93bb-0a5bf521835e', 'Tofu caramel wok normal', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a3622-9c4d-11ea-93bc-0a5bf521835e', 'Tofu caramel wok grand', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a36d6-9c4d-11ea-93bd-0a5bf521835e', 'Crevettes Pad Thai Normal', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a3780-9c4d-11ea-93be-0a5bf521835e', 'Crevettes Pad Thai Grand', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a382a-9c4d-11ea-93bf-0a5bf521835e', 'Poulet pad thai normal', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a38d4-9c4d-11ea-93c0-0a5bf521835e', 'Poulet pad thai grand', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a3988-9c4d-11ea-93c1-0a5bf521835e', 'Boeuf Pad Thai Normal Base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a3a32-9c4d-11ea-93c2-0a5bf521835e', 'Boeuf Pad Thai Grand Base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a3ae6-9c4d-11ea-93c3-0a5bf521835e', 'Tofu pad thai normal', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a3b90-9c4d-11ea-93c4-0a5bf521835e', 'Tofu pad thai grand', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a3d98-9c4d-11ea-93c7-0a5bf521835e', 'Perles tapioca cuites', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 'Boitage Saladier Normal', 'recette', 'Kit boitage', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 'Boitage Saladier Grand', 'recette', 'Kit boitage', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a404a-9c4d-11ea-93cb-0a5bf521835e', 'Sauce Nuoc Mam (2)', 'recette', 'Finger Phood', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a40f4-9c4d-11ea-93cc-0a5bf521835e', 'Boitage PPC EMP/LIV', 'recette', 'Kit boitage', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a42fc-9c4d-11ea-93cf-0a5bf521835e', 'Boitage Chips EMP/LIV', 'recette', 'Kit boitage', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a43b0-9c4d-11ea-93d0-0a5bf521835e', 'Boitage Bobun Normal', 'recette', 'Kit boitage', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a4464-9c4d-11ea-93d1-0a5bf521835e', 'Boitage Bobun Grand', 'recette', 'Kit boitage', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a466c-9c4d-11ea-93d4-0a5bf521835e', 'Boitage Pho Normal', 'recette', 'Kit boitage', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a4716-9c4d-11ea-93d5-0a5bf521835e', 'Boitage Pho Grand', 'recette', 'Kit boitage', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a47ca-9c4d-11ea-93d6-0a5bf521835e', 'Boitage BBT', 'recette', 'Kit boitage', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a4874-9c4d-11ea-93d7-0a5bf521835e', 'Boitage Cup Dessert SP', 'recette', 'Kit boitage', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a491e-9c4d-11ea-93d8-0a5bf521835e', 'Boitage Cup Dessert EMP/LIV', 'recette', 'Kit boitage', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a49d2-9c4d-11ea-93d9-0a5bf521835e', 'Supplément nems', 'recette', 'Supplément', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a4b30-9c4d-11ea-93db-0a5bf521835e', 'Supplément boulettes', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":3,"tva":10},"emporter":{"ttc":3,"tva":10},"livraison":{"ttc":3,"tva":10}}'::jsonb, '318277', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a4bda-9c4d-11ea-93dc-0a5bf521835e', 'Supplément tofu', 'recette', 'Supplément', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a4c8e-9c4d-11ea-93dd-0a5bf521835e', 'Supplément poulet', 'recette', 'Supplément', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a4d38-9c4d-11ea-93de-0a5bf521835e', 'Supplément boeuf', 'recette', 'Supplément', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a4de2-9c4d-11ea-93df-0a5bf521835e', 'Bo Bun Base Normal 	', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a4e8c-9c4d-11ea-93e0-0a5bf521835e', 'Bo Bun Base Grand 	', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a4fea-9c4d-11ea-93e2-0a5bf521835e', 'Bo Bun Bœuf', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.9,"tva":10},"emporter":{"ttc":12.9,"tva":10},"livraison":{"ttc":12.5,"tva":10}}'::jsonb, '6AD776', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a5094-9c4d-11ea-93e3-0a5bf521835e', 'Bo Bun Poulet Normal SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a5148-9c4d-11ea-93e4-0a5bf521835e', 'Bo Bun Poulet Normal EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a51f2-9c4d-11ea-93e5-0a5bf521835e', 'Bo Bun Crevette Normal SP	', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a52a6-9c4d-11ea-93e6-0a5bf521835e', 'Bo Bun Crevette Normal EMP/LIV	', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a5350-9c4d-11ea-93e7-0a5bf521835e', 'Bo Bun Tofu Normal  SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a53fa-9c4d-11ea-93e8-0a5bf521835e', 'Bo Bun Tofu Normal', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.9,"tva":10},"emporter":{"ttc":12.9,"tva":10},"livraison":{"ttc":14.9,"tva":10}}'::jsonb, '59dc77', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a54ae-9c4d-11ea-93e9-0a5bf521835e', 'Bo Bun Porc Laqué Normal SP	', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a554e-9c4d-11ea-93ea-0a5bf521835e', 'Bo Bun porc Laqué Normal EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a5a9e-9c4d-11ea-93ec-0a5bf521835e', 'Bo Bun Boeuf Grand EMP/LIV	', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a5b70-9c4d-11ea-93ed-0a5bf521835e', 'Bo Bun Poulet Grand SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a5c1a-9c4d-11ea-93ee-0a5bf521835e', 'Bo Bun Poulet Grand EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a5cce-9c4d-11ea-93ef-0a5bf521835e', 'Bo Bun Crevette Grand SP	', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a5d78-9c4d-11ea-93f0-0a5bf521835e', 'Bo Bun Crevette Grand EMP/LIV	', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a5e2c-9c4d-11ea-93f1-0a5bf521835e', 'Bo Bun Tofu Grand SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a5ed6-9c4d-11ea-93f2-0a5bf521835e', 'Bo Bun Tofu Grand EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a5f8a-9c4d-11ea-93f3-0a5bf521835e', 'Bo Bun Porc Laqué Grand SP	', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a6034-9c4d-11ea-93f4-0a5bf521835e', 'Bo Bun Porc Laqué Grand EMP/LIV	', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a60e8-9c4d-11ea-93f5-0a5bf521835e', 'Mixao Normal Base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a619c-9c4d-11ea-93f6-0a5bf521835e', 'Mixao Grand Base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a6246-9c4d-11ea-93f7-0a5bf521835e', 'Mixao Poulet Normal SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a62f0-9c4d-11ea-93f8-0a5bf521835e', 'Mixao Poulet Normal EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a639a-9c4d-11ea-93f9-0a5bf521835e', 'Mixao Boeuf Normal SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a644e-9c4d-11ea-93fa-0a5bf521835e', 'Mixao Boeuf Normal EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a6502-9c4d-11ea-93fb-0a5bf521835e', 'Mixao Crevettes Normal SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a65ac-9c4d-11ea-93fc-0a5bf521835e', 'Mixao Crevettes Normal EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a6660-9c4d-11ea-93fd-0a5bf521835e', 'Mixao tofu normal SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a6890-9c4d-11ea-93fe-0a5bf521835e', 'Mixao tofu normal EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a694e-9c4d-11ea-93ff-0a5bf521835e', 'Mixao Porc Laqué Normal SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a69f8-9c4d-11ea-9400-0a5bf521835e', 'Mixao Porc Laqué Normal EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a6aac-9c4d-11ea-9401-0a5bf521835e', 'Mixao poulet grand SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a6b56-9c4d-11ea-9402-0a5bf521835e', 'Mixao Poulet Grand EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a6c0a-9c4d-11ea-9403-0a5bf521835e', 'Mixao Boeuf Grand SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a6cb4-9c4d-11ea-9404-0a5bf521835e', 'Mixao Boeuf Grand EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a7678-9c4d-11ea-9405-0a5bf521835e', 'Mixao Crevettes Grand SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a777c-9c4d-11ea-9406-0a5bf521835e', 'Mixao Crevettes Grand EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a7830-9c4d-11ea-9407-0a5bf521835e', 'Mixao tofu grand SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a78da-9c4d-11ea-9408-0a5bf521835e', 'Mixao tofu grand EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a798e-9c4d-11ea-9409-0a5bf521835e', 'Mixao Porc Laqué Grand SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a7a38-9c4d-11ea-940a-0a5bf521835e', 'Mixao Porc Laqué Grand EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a7ae2-9c4d-11ea-940b-0a5bf521835e', 'Veggie chow mein normal base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a7b8c-9c4d-11ea-940c-0a5bf521835e', 'Veggie chow mein grand base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a7c40-9c4d-11ea-940d-0a5bf521835e', 'Veggie chow mein normal SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a7ce0-9c4d-11ea-940e-0a5bf521835e', 'Veggie chow mein normal emp/liv', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a7da8-9c4d-11ea-940f-0a5bf521835e', 'Veggie chow mein grand SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a7e5c-9c4d-11ea-9410-0a5bf521835e', 'Veggie chow mein grand emp/liv', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a7f06-9c4d-11ea-9411-0a5bf521835e', 'Ga Kho Normal Base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a7fb0-9c4d-11ea-9412-0a5bf521835e', 'Ga Kho Grand Base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a805a-9c4d-11ea-9413-0a5bf521835e', 'Ga Kho Poulet Normal SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a8104-9c4d-11ea-9414-0a5bf521835e', 'Ga Kho Poulet Normal EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a81ae-9c4d-11ea-9415-0a5bf521835e', 'Ga Kho Poulet Grand SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a8258-9c4d-11ea-9416-0a5bf521835e', 'Ga Kho Poulet Grand EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a83ac-9c4d-11ea-9418-0a5bf521835e', 'Ga Kho Tofu', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.9,"tva":10},"emporter":{"ttc":12.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a850a-9c4d-11ea-941a-0a5bf521835e', 'Ga Kho Tofu Grand', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a85b4-9c4d-11ea-941b-0a5bf521835e', 'Goi Bo Normal Base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a865e-9c4d-11ea-941c-0a5bf521835e', 'Goi bo Grand Base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a8712-9c4d-11ea-941d-0a5bf521835e', 'Goi Bo Boeuf Normal SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a87bc-9c4d-11ea-941e-0a5bf521835e', 'Goi Bo Boeuf', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.9,"tva":10},"emporter":{"ttc":12.9,"tva":10},"livraison":{"ttc":11.5,"tva":10}}'::jsonb, '786664', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a8866-9c4d-11ea-941f-0a5bf521835e', 'Goi Bo Boeuf Grand SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a8910-9c4d-11ea-9420-0a5bf521835e', 'Goi Bo Boeuf Grand EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a89c4-9c4d-11ea-9421-0a5bf521835e', 'Pad thai normal base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a8a6e-9c4d-11ea-9422-0a5bf521835e', 'Pad thai grand base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a8b40-9c4d-11ea-9423-0a5bf521835e', 'Pad thai crevettes normal SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a8c08-9c4d-11ea-9424-0a5bf521835e', 'Pad thai crevettes normal EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a8cbc-9c4d-11ea-9425-0a5bf521835e', 'Pad thai crevettes grand SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a8d66-9c4d-11ea-9426-0a5bf521835e', 'Pad thai crevettes grand EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a8e1a-9c4d-11ea-9427-0a5bf521835e', 'Pad thai poulet normal SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a8ece-9c4d-11ea-9428-0a5bf521835e', 'Pad thai poulet', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.9,"tva":10},"emporter":{"ttc":12.9,"tva":10},"livraison":{"ttc":13,"tva":10}}'::jsonb, '492b25|caa203', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a8fa0-9c4d-11ea-9429-0a5bf521835e', 'Pad thai poulet grand SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a904a-9c4d-11ea-942a-0a5bf521835e', 'Pad thai poulet grand EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a90f4-9c4d-11ea-942b-0a5bf521835e', 'Pad thai boeuf normal SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a919e-9c4d-11ea-942c-0a5bf521835e', 'Pad thai boeuf normal EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a9252-9c4d-11ea-942d-0a5bf521835e', 'Pad thai boeuf grand SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a9306-9c4d-11ea-942e-0a5bf521835e', 'Pad thai boeuf grand EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a96d0-9c4d-11ea-942f-0a5bf521835e', 'Pad thai tofu normal SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a97b6-9c4d-11ea-9430-0a5bf521835e', 'Pad thai tofu normal EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a9874-9c4d-11ea-9431-0a5bf521835e', 'Pad thai tofu grand SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a991e-9c4d-11ea-9432-0a5bf521835e', 'Pad thai tofu grand EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a99c8-9c4d-11ea-9433-0a5bf521835e', 'Pho normal base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a9a72-9c4d-11ea-9434-0a5bf521835e', 'Pho grand base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a9b26-9c4d-11ea-9435-0a5bf521835e', 'Pho boeuf normal SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a9bda-9c4d-11ea-9436-0a5bf521835e', 'Pho boeuf normal', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.9,"tva":10},"emporter":{"ttc":12.9,"tva":10},"livraison":{"ttc":10,"tva":10}}'::jsonb, 'bce73e', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a9d2e-9c4d-11ea-9438-0a5bf521835e', 'Pho boeuf grand ', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.9,"tva":10},"emporter":{"ttc":12.9,"tva":10},"livraison":{"ttc":14.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a9ea0-9c4d-11ea-943a-0a5bf521835e', 'Pho Boulettes', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.9,"tva":10},"emporter":{"ttc":12.9,"tva":10},"livraison":{"ttc":10,"tva":10}}'::jsonb, 'BC980E', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a9f54-9c4d-11ea-943b-0a5bf521835e', 'Pho boulettes grand SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18a9ffe-9c4d-11ea-943c-0a5bf521835e', 'Pho boulettes grand EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18aa0b2-9c4d-11ea-943d-0a5bf521835e', 'Sauce satay préparée', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18aa8fa-9c4d-11ea-9449-0a5bf521835e', 'Poulet pop corn base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18aa9ae-9c4d-11ea-944a-0a5bf521835e', 'Poulet pop corn SP', 'recette', 'Side', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18aaa58-9c4d-11ea-944b-0a5bf521835e', 'Poulet pop corn EMP/LIV', 'recette', 'Side', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18aabc0-9c4d-11ea-944d-0a5bf521835e', 'Crazy Nems Poulet', 'recette', 'Finger Phood', 0, '{"sur_place":{"ttc":7.9,"tva":10},"emporter":{"ttc":7.9,"tva":10},"livraison":{"ttc":7.9,"tva":10}}'::jsonb, '748de7', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18aade6-9c4d-11ea-9450-0a5bf521835e', 'Frites De Patate Douce SP', 'recette', 'Finger Phood', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18aae9a-9c4d-11ea-9451-0a5bf521835e', 'Frites De Patate Douce EMP/LIV', 'recette', 'Finger Phood', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18aaf4e-9c4d-11ea-9452-0a5bf521835e', 'Chips Crevettes SP', 'recette', 'Side', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18ab142-9c4d-11ea-9453-0a5bf521835e', 'Chips Crevettes EMP/LIV', 'recette', 'Side', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18ab372-9c4d-11ea-9456-0a5bf521835e', 'Pannacotta exotique v1', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18ab426-9c4d-11ea-9457-0a5bf521835e', 'Mousse choco coco base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18abe3a-9c4d-11ea-9458-0a5bf521835e', 'Mousse choco coco SP', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18abeee-9c4d-11ea-9459-0a5bf521835e', 'Mousse choco coco EMP/LIV', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18abfa2-9c4d-11ea-945a-0a5bf521835e', 'Cookie Chocolat SP', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18ac056-9c4d-11ea-945b-0a5bf521835e', 'Cookie Vanille SP', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18ac10a-9c4d-11ea-945c-0a5bf521835e', 'Muffin vanille base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18ac1be-9c4d-11ea-945d-0a5bf521835e', 'Muffin vanille SP', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18ac272-9c4d-11ea-945e-0a5bf521835e', 'Muffin vanille EMP/LIV', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18ac326-9c4d-11ea-945f-0a5bf521835e', 'Muffin chocolat base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18ac3da-9c4d-11ea-9460-0a5bf521835e', 'Muffin chocolat SP', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18ac484-9c4d-11ea-9461-0a5bf521835e', 'Muffin chocolat EMP/LIV', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18ac538-9c4d-11ea-9462-0a5bf521835e', 'Cheesecake Oreo base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18ac628-9c4d-11ea-9463-0a5bf521835e', 'Cheesecake Taro Oreo SP', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18ac6e6-9c4d-11ea-9464-0a5bf521835e', 'Cheesecake Taro Oreo EMP/LIV', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18ac79a-9c4d-11ea-9465-0a5bf521835e', 'Cheesecake Mangue Oreo SP', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18ac84e-9c4d-11ea-9466-0a5bf521835e', 'Cheesecake Mangue Oreo EMP/LIV', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18ac902-9c4d-11ea-9467-0a5bf521835e', 'Lait de coco base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18acbc8-9c4d-11ea-946b-0a5bf521835e', 'BBT Milky Base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18acc7c-9c4d-11ea-946c-0a5bf521835e', 'BBT Fruity Base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18acd30-9c4d-11ea-946d-0a5bf521835e', 'BBT Milky Original (2)', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18acdee-9c4d-11ea-946e-0a5bf521835e', 'BBT Milky Taro (2)', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18ace98-9c4d-11ea-946f-0a5bf521835e', 'BBT Milky Vanille', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18acf56-9c4d-11ea-9470-0a5bf521835e', 'BBT  Fruity Passion', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18ad00a-9c4d-11ea-9471-0a5bf521835e', 'BBT Fruity Fraise', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18ad0be-9c4d-11ea-9472-0a5bf521835e', 'Café Espresso', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":1.8,"tva":10},"emporter":{"ttc":1.8,"tva":10}}'::jsonb, 'BBE241', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18ad582-9c4d-11ea-9476-0a5bf521835e', 'Perles tapioca pour bbt', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18ad640-9c4d-11ea-9477-0a5bf521835e', 'Perles lychee pour bbt', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a18ad6f4-9c4d-11ea-9478-0a5bf521835e', 'Perles mangue pour bbt', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a192cab0-2393-11ed-a94a-933a73b178be', 'Boulette VG Sauce Xa Xiu', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a32565b0-117c-11f1-a108-496d87d5c077', 'Crazy Tenders new', 'recette', 'Finger Phood', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a48c7a10-c885-11ef-8a4d-17c77f3f8f34', 'Supp crousty poulet', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":5.5,"tva":10},"emporter":{"ttc":5.5,"tva":10},"livraison":{"ttc":5.5,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a5b09760-55c7-11ed-b50c-474f649a5bc5', 'Crevettes Sauce Ga Kho Grand', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a6d20cd0-b738-11ef-9837-1733243488a6', 'Sirop à l''eau Fraise', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a6d8bf20-be26-11ec-bc2e-4d33dd81b98a', 'Mélange légumes', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a72946a0-d5c0-11ec-b2e2-5dd84dabb8a8', 'COMCHIEN VG Légumes LIV', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a7bbc4d0-307d-11ee-af48-fb839ee61b42', '🍜 Mixao au porc laqué 🐖 Normal', 'recette', 'Plats', 0, '{"sur_place":{"ttc":13,"tva":10},"emporter":{"ttc":13,"tva":10},"livraison":{"ttc":13,"tva":10}}'::jsonb, 'e3df77|bf941e', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a802ad20-fb05-11ee-b163-25d7673ac736', 'SUPP Topping coulis fraise', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":0.8,"tva":10},"emporter":{"ttc":0.8,"tva":10},"livraison":{"ttc":0.8,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a86d9330-307e-11ee-af48-fb839ee61b42', 'CITRONNADE BIO (2)', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":3.9,"tva":10},"emporter":{"ttc":3.9,"tva":10},"livraison":{"ttc":3.9,"tva":10}}'::jsonb, '078cf6', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a89f66b0-3080-11ee-af48-fb839ee61b42', 'LAIT DE COCO', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":4,"tva":10},"emporter":{"ttc":4,"tva":10},"livraison":{"ttc":4,"tva":10}}'::jsonb, 'ab1f84', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a9076130-3089-11ee-af48-fb839ee61b42', 'MIXAO "POULET" VG', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.5,"tva":10},"emporter":{"ttc":12.5,"tva":10},"livraison":{"ttc":12.5,"tva":10}}'::jsonb, '9e8e26', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a96f1c50-308c-11ee-af48-fb839ee61b42', 'PAD THAI BF GRAND', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a98a14d0-3080-11ee-af48-fb839ee61b42', 'BBT FRUITY MENTHE', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":4.6,"tva":10},"emporter":{"ttc":4.6,"tva":10},"livraison":{"ttc":4.6,"tva":10}}'::jsonb, 'A7C319', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('a9fa7cb0-d6ee-11ee-8099-878d940648e3', 'Crousty Tofu SP', 'recette', 'Plat du moment', 0, '{"sur_place":{"ttc":12.55,"tva":10},"emporter":{"ttc":12.55,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('aa30a470-fb76-11ec-a176-d902a1918d35', 'BBT Fruity Hibiscus (2)', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('aaae78d0-c153-11ec-b810-d1ffe210d8b1', 'Bo Bun VG Boulettes SP ', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('abb108f0-307f-11ee-af48-fb839ee61b42', 'Bière pression (demi) KGB', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":4.5,"tva":10},"emporter":{"ttc":4.5,"tva":10},"livraison":{"ttc":4.5,"tva":10}}'::jsonb, '9ecd65', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('ac133c30-6d38-11eb-a732-3588446adb69', 'Thé vert menthe emp/liv', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('acac8220-308e-11ee-af48-fb839ee61b42', 'PAPIKRA', 'recette', 'SPECIAL', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":0,"tva":10}}'::jsonb, 'E5605A', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('ad204cf0-9dec-11eb-8c37-bb20979b8c2f', 'Goi Bo Tofu Grand EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('adef93d0-23dc-11ed-925e-393317a6b4b7', 'Mixao Normal Base Udon', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('ae8f5fb0-c157-11ec-b810-d1ffe210d8b1', 'COMCHIEN VG Base', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('aeff8c4e-19d9-11eb-a885-0a5bf521835e', 'Lait de Coco (2)', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('af274560-bded-11ef-b77b-b5f02a7171be', 'Sauce curry citronnelle', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('b04edf90-c992-11ec-8b95-edfe4c030b67', 'RIZ BLANC VG SP', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('b0ea9f10-bee0-11eb-b72d-730bbd0b1638', 'Bo Bun Sam +Tofu Normal EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('b1346b10-9deb-11eb-8c37-bb20979b8c2f', 'Goi Bo Tofu Grand SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('b1a98b90-308b-11ee-af48-fb839ee61b42', '5 ÉPICES', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":0,"tva":10}}'::jsonb, '7695F5', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('b24ad9b0-c15a-11ec-b810-d1ffe210d8b1', 'Ga Kho VG Poulet SP', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('b3d91460-e3eb-11eb-8237-736a902b6e66', 'Café Viet', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":4,"tva":10},"emporter":{"ttc":4,"tva":10},"livraison":{"ttc":4,"tva":10}}'::jsonb, 'DD5A1E', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('b3dd1b20-3090-11ee-af48-fb839ee61b42', 'Bò bún aux crevettes Grande', 'recette', 'Plats', 0, '{"sur_place":{"ttc":15,"tva":10},"emporter":{"ttc":15,"tva":10},"livraison":{"ttc":15,"tva":10}}'::jsonb, '0cb5fb|7ea495', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('b41c3fc0-757f-11ed-a0a7-1b2de41c84da', 'Pot de glace cacahuète SP', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('b53f6e70-3089-11ee-af48-fb839ee61b42', 'PAD THAI PC LAQUE NORMAL', 'recette', 'Plats', 0, '{"sur_place":{"ttc":11.9,"tva":10},"emporter":{"ttc":11.9,"tva":10},"livraison":{"ttc":11.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('b59ccca0-349c-11f0-9650-152532a65f04', 'Pannacotta exotique mélangé', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('b6ad21f0-bdfd-11ef-914f-cb5d4afd0259', 'Sauce Pad thai', 'recette', 'SAUCE', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('b888f420-3089-11ee-af48-fb839ee61b42', 'SUPP POUSSES SOJA', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":0,"tva":10}}'::jsonb, '8c9a66', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('b8f79e50-53d1-11ee-ad93-4d410949057c', 'Phried Rice poulet SP', 'recette', 'Plat du moment', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('b9678590-308f-11ee-af48-fb839ee61b42', 'PETITE SALADE', 'recette', 'Plats', 0, '{"sur_place":{"ttc":5,"tva":10},"emporter":{"ttc":5,"tva":10},"livraison":{"ttc":5,"tva":10}}'::jsonb, '6c3919', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('b9d1dc40-53d2-11ee-ad93-4d410949057c', 'Phried Rice Tofu EMP/LIV ', 'recette', 'Plat du moment', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('baa28230-7cd6-11eb-9648-651da3a4a532', 'Perles grenade pour bbt', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('bb5d2160-ea2f-11ef-99fd-f75a4ffbaeb0', 'Pho crevettes grand', 'recette', 'Plats', 0, '{"sur_place":{"ttc":14.9,"tva":10},"emporter":{"ttc":14.9,"tva":10},"livraison":{"ttc":16.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('bb979880-a827-11ef-8e56-e34985f0ea4e', 'Tofu pop corn SP', 'recette', 'Side', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('c03b0d50-c151-11ec-b810-d1ffe210d8b1', 'Pho VG boulette normal SP ', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('c0773370-d5bf-11ec-9916-a1c1f658f229', 'Bo Bun VG  Poulet EMP/LIV', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('c0b383b0-d5c0-11ec-8b7a-0f22ec019de6', 'Ga Kho VG Poulet LIV', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('c0c9eee0-308f-11ee-af48-fb839ee61b42', 'EXTRA CACAHUETES', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":0.5,"tva":10},"emporter":{"ttc":0.5,"tva":10}}'::jsonb, '906C42', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('c119ab70-fb04-11ee-9be0-1f5f4004d531', 'SUPP Topping Smarties', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":0.9,"tva":10},"emporter":{"ttc":0.9,"tva":10},"livraison":{"ttc":0.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('c15517e0-308f-11ee-af48-fb839ee61b42', 'PAD THAI BF', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.9,"tva":10},"emporter":{"ttc":12.9,"tva":10},"livraison":{"ttc":14.5,"tva":10}}'::jsonb, 'd0a1cb|7ea495', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('c16cd080-308d-11ee-af48-fb839ee61b42', 'Bouteille rosé', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":22,"tva":10},"emporter":{"ttc":22,"tva":10},"livraison":{"ttc":22,"tva":10}}'::jsonb, 'D063C5', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('c27c908c-19f2-11eb-a7a0-0a5bf521835e', 'Crevettes Curry Rouge', 'recette', 'Plat du moment', 0, '{"sur_place":{"ttc":14.9,"tva":10},"emporter":{"ttc":14.9,"tva":10},"livraison":{"ttc":12.5,"tva":10}}'::jsonb, 'd3ff0a', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('c2f64190-308b-11ee-af48-fb839ee61b42', 'SUPP PORC LAQUE', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":3,"tva":10},"emporter":{"ttc":3,"tva":10},"livraison":{"ttc":3,"tva":10}}'::jsonb, 'A15A2D|BF941E', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('c30371a0-be1b-11ec-a7fa-3529186828e2', 'Bo Bun VG   Normal Base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('c3179820-307e-11ee-af48-fb839ee61b42', 'MOCHI FLEUR DE CERISIER', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":0,"tva":10}}'::jsonb, 'CBD1BE', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('c360a6b0-308c-11ee-af48-fb839ee61b42', 'PHO BOULETTES VG', 'recette', 'Plats', 0, '{"sur_place":{"ttc":11.9,"tva":10},"emporter":{"ttc":11.9,"tva":10},"livraison":{"ttc":11.9,"tva":10}}'::jsonb, 'b513e4', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('c3a0ec60-307e-11ee-af48-fb839ee61b42', 'BOBUN CREV+SAM NORMAL', 'recette', 'Plats', 0, '{"sur_place":{"ttc":11.9,"tva":10},"emporter":{"ttc":11.9,"tva":10},"livraison":{"ttc":11.9,"tva":10}}'::jsonb, '92181F|CAA203', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('c4302450-308f-11ee-af48-fb839ee61b42', 'MUFFIN VANILLE PEPITE', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":4.5,"tva":10},"emporter":{"ttc":4.5,"tva":10},"livraison":{"ttc":4.5,"tva":10}}'::jsonb, 'd8130d', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('c4eddf70-e304-11eb-9b9e-0f6f0f6fa679', 'Riz sauté base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('c64cd9e0-307b-11ee-af48-fb839ee61b42', 'BBT MILKY VANILLE (2)', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":4.6,"tva":10},"emporter":{"ttc":4.6,"tva":10},"livraison":{"ttc":4.6,"tva":10}}'::jsonb, '5B0DED', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('c71bebe0-308a-11ee-af48-fb839ee61b42', 'BBT FRUITY PECHE (2)', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":4.6,"tva":10},"emporter":{"ttc":4.6,"tva":10},"livraison":{"ttc":4.6,"tva":10}}'::jsonb, '435cac', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('c7d7e5b0-3086-11ee-af48-fb839ee61b42', 'SUPP CORIANDRE', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":0.5,"tva":10},"emporter":{"ttc":0.5,"tva":10},"livraison":{"ttc":0.5,"tva":10}}'::jsonb, '227787', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('c8414da0-7580-11ed-9c6e-83547301d186', 'Pot de glace noix de coco EMP/LIV', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('c8a6e570-c153-11ec-9265-d57037e66861', 'Bo Bun VG Légumes SP ', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('ca2f38a0-3085-11ee-af48-fb839ee61b42', 'SUPP NEMS', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":3.5,"tva":10},"emporter":{"ttc":3.5,"tva":10},"livraison":{"ttc":3.5,"tva":10}}'::jsonb, '479e73', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('cc0f9000-cf50-11ef-90af-61ebec49d20b', 'Poulet Curry Jaune', 'recette', 'Plat du moment', 0, '{"sur_place":{"ttc":14.9,"tva":10},"emporter":{"ttc":14.9,"tva":10},"livraison":{"ttc":16.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('cc4e3520-d5e4-11ec-9916-a1c1f658f229', 'BROCHETTES VG Tofu LIV', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('cd65a10a-1a06-11eb-90f1-0a5bf521835e', 'Thé vert menthe SP', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('cf812cf0-308f-11ee-af48-fb839ee61b42', 'DONUT SUCRE', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":2.5,"tva":10},"emporter":{"ttc":2.5,"tva":10},"livraison":{"ttc":3.1,"tva":10}}'::jsonb, '527198', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('cfb73310-9387-11eb-b551-3d9be8d1c5c7', 'Boulettes trad BASE', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('cfeb4e10-a63b-11ee-b682-015a80327a47', 'Moscow mule', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":8,"tva":10},"emporter":{"ttc":8,"tva":10},"livraison":{"ttc":8,"tva":10}}'::jsonb, 'BIBMMC0702023', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('d0522bf0-2374-11f0-953f-0dfe025424db', 'Sirop à l''eau Pêche blanche', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('d0947110-811c-11ed-b263-b95e21b5e348', 'Bière 33 cl', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('d15b52e0-3089-11ee-af48-fb839ee61b42', 'SUPP LARDONS', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":3,"tva":10},"emporter":{"ttc":3,"tva":10},"livraison":{"ttc":3,"tva":10}}'::jsonb, '8eba3d', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('d2326660-53d2-11ee-a233-1bda7c5c59b1', 'Phried Rice Crevettes EMP/LIV  ', 'recette', 'Plat du moment', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('d26a8f10-3080-11ee-af48-fb839ee61b42', 'Hanoi Salad', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.5,"tva":10},"emporter":{"ttc":12.5,"tva":10},"livraison":{"ttc":12.5,"tva":10}}'::jsonb, '0d03f3', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('d31279c0-307e-11ee-af48-fb839ee61b42', 'HIBISCUS MENTHE BIO NORMAL', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('d3c50930-be1c-11ec-92b5-d17e9a4e477d', 'POULET VG PREPA', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('d3cd0a70-d5c0-11ec-b2e2-5dd84dabb8a8', 'Ga Kho VG Tofu LIV', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('d480e330-f0ca-11ed-ada6-f1c2893b2f15', 'Sauce Exotique', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('d499d5b0-3081-11ee-af48-fb839ee61b42', 'SAUCE PIMENT (2)', 'recette', 'SAUCE', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":0.5,"tva":10}}'::jsonb, '6f19a1', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('d58148e0-9dea-11eb-9fc3-c54eb2b1a2bd', 'Goi Bo Tofu Normal SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('d5cf9690-3081-11ee-af48-fb839ee61b42', 'JUS DE CANNE FRAIS', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":5,"tva":10},"emporter":{"ttc":5,"tva":10},"livraison":{"ttc":5,"tva":10}}'::jsonb, 'CA54CD', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('d5f8e2c0-307c-11ee-af48-fb839ee61b42', 'BBT LIMO FRAISE (2)', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('d6050200-c886-11ef-8cdd-494b0e1336ff', 'Supplément crousty tofu', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":5.5,"tva":10},"emporter":{"ttc":5.5,"tva":10},"livraison":{"ttc":5.5,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('d623e450-fb73-11ec-a176-d902a1918d35', 'BBT Fruity Grenade (2)', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('d63f3700-a828-11ef-8823-a5dd9aeddc06', 'Pop Corn Tofu Caramel EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('d6d629c0-3084-11ee-af48-fb839ee61b42', 'BBT FRUITY PASSION', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":4.6,"tva":10},"emporter":{"ttc":4.6,"tva":10},"livraison":{"ttc":4.6,"tva":10}}'::jsonb, '1CDA64', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('d742a500-cf26-11ee-9180-5f1b01ee3b04', 'Phried Thai Balls SP', 'recette', 'Plat du moment', 0, '{"sur_place":{"ttc":13.9,"tva":10},"emporter":{"ttc":13.9,"tva":10},"livraison":{"ttc":13.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('d75a78e0-9dee-11eb-b217-2bde6a29a24e', 'Pho tofu normal EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('d76a0980-307d-11ee-af48-fb839ee61b42', 'MOCHI CARAMEL BEURRE SALE', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":5,"tva":10},"emporter":{"ttc":5,"tva":10},"livraison":{"ttc":5,"tva":10}}'::jsonb, '6FF154', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('d8713460-19d9-11eb-b532-0a5bf521835e', 'Coriandre Fraîche Ciselée', 'recette', 'Supplément', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('dbeb1610-3083-11ee-af48-fb839ee61b42', 'Sauce nuoc-mam maison', 'recette', 'SAUCE', 0, '{"sur_place":{"ttc":0.5,"tva":10},"emporter":{"ttc":0.5,"tva":10},"livraison":{"ttc":0.5,"tva":10}}'::jsonb, '3c2fc4', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('dd5d83b4-1a08-11eb-99eb-0a5bf521835e', 'Jus de pomme bio (2)', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('de64e6e0-a63b-11ee-8113-71b52dd3cd48', 'Spritz', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":8,"tva":10},"emporter":{"ttc":8,"tva":10},"livraison":{"ttc":8,"tva":10}}'::jsonb, 'BIBSRZC072023', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('deb3cd90-be1c-11ec-92b5-d17e9a4e477d', 'Bo Bun VG   Poulet SP', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('df837110-9def-11eb-b217-2bde6a29a24e', 'Pho Tofu Grand EMP/LIV', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('dfc097de-1a05-11eb-b954-0a5bf521835e', 'Drinks  pétillante', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('e01f5ed0-fb03-11ee-8b75-2926d2419fed', 'SUPP Topping Oréo', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":0.9,"tva":10},"emporter":{"ttc":0.9,"tva":10},"livraison":{"ttc":0.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('e089f680-9ded-11eb-8c37-bb20979b8c2f', 'Pho tofu normal SP', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('e10bb450-9784-11eb-818f-6d98184fe9ec', 'Boeuf Oignons Base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('e113c530-f0cb-11ed-b842-fb729038efc8', 'Pickles Oignon Rouge', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('e13c3290-bbb8-11ef-b71c-3fa77561451e', 'Boeuf Curry Rouge', 'recette', 'Plat du moment', 0, '{"sur_place":{"ttc":14.9,"tva":10},"emporter":{"ttc":14.9,"tva":10},"livraison":{"ttc":16.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('e26a4e80-3087-11ee-af48-fb839ee61b42', 'PERLES LYCHEE', 'recette', 'SPECIAL', 0, '{"sur_place":{"ttc":0.9,"tva":10},"emporter":{"ttc":0.9,"tva":10},"livraison":{"ttc":0.9,"tva":10}}'::jsonb, 'F5E575', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('e2a255e0-7cd5-11eb-9648-651da3a4a532', 'Riz sauté de tata crevettes', 'recette', 'Plat du moment', 0, '{"sur_place":{"ttc":11.61,"tva":10},"emporter":{"ttc":11.61,"tva":10},"livraison":{"ttc":12.9,"tva":10}}'::jsonb, '662E6F', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('e2f871f0-7580-11ed-9ceb-4384b0d4acc1', 'Pot de glace vanille cookie SP ', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('e3c9e278-1a09-11eb-8de0-0a5bf521835e', 'Cidre Saigon', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('e42a35b0-3081-11ee-af48-fb839ee61b42', 'MOCHI MANGUE/PASSION', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":0,"tva":10}}'::jsonb, 'E91234', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('e437c240-9f68-11f0-99be-ff2defcc9a29', 'Pannacotta exotique v2', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":4,"tva":10},"emporter":{"ttc":4,"tva":10},"livraison":{"ttc":5,"tva":10}}'::jsonb, '9f8cc3', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('e4be28a0-cc0e-11ee-a6b6-e7ad7f0affd8', 'Pho poulet normal', 'recette', 'Plats', 0, '{"sur_place":{"ttc":13.9,"tva":10},"emporter":{"ttc":13.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('e54b9770-55c8-11ed-b50c-474f649a5bc5', 'Ga Kho Crevettes Grand', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('e5d6c8b0-308b-11ee-af48-fb839ee61b42', 'Cookie tout chocolat', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":2.5,"tva":10},"emporter":{"ttc":2.5,"tva":10},"livraison":{"ttc":2.5,"tva":10}}'::jsonb, '99dca1', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('e5e1fbe0-c15b-11ec-a2ba-7bb1dc10361f', 'BROCHETTES VG Tofu SP', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('e6468a30-307a-11ee-af48-fb839ee61b42', 'MIXAO TOFU GRAND', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12,"tva":10},"emporter":{"ttc":12,"tva":10},"livraison":{"ttc":12,"tva":10}}'::jsonb, '97FE7E|7EA495', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('e6f3d5d0-4c36-11f0-8e4e-bf609a422157', 'Curry Jaune boulettes thai', 'recette', 'Plat du moment', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('e760b460-4790-11ec-939f-314f99801403', 'Oignons blancs émincés', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('e7727520-307c-11ee-af48-fb839ee61b42', 'GOI BO', 'recette', 'Plats', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('e788cc3e-19ec-11eb-a474-0a5bf521835e', 'Supplément crevettes', 'recette', 'Supplément', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('e7d9a920-3081-11ee-af48-fb839ee61b42', 'Verre vin rosé', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":5,"tva":10},"emporter":{"ttc":5,"tva":10}}'::jsonb, '0366DD', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('e7ec58b0-307f-11ee-af48-fb839ee61b42', 'MIXAO CREV GRAND', 'recette', 'Plats', 0, '{"sur_place":{"ttc":13.9,"tva":10},"emporter":{"ttc":13.9,"tva":10},"livraison":{"ttc":13.9,"tva":10}}'::jsonb, 'd1a6a2|be664a', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('e877b220-7733-11ee-8098-81145f75bf63', 'Goi Bo Crevettes', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.9,"tva":10},"emporter":{"ttc":12.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('e9464450-be20-11ec-a7fa-3529186828e2', 'Boulette VG ', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('ea05dcb0-dfff-11ec-807b-81b583ff1692', 'CHIA PUDDING VG FRUITS ROUGES SP', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('ec236e80-3086-11ee-af48-fb839ee61b42', 'DEMI', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":3.45,"tva":10},"emporter":{"ttc":3.45,"tva":10}}'::jsonb, '58c6ad', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('ecb308a0-2374-11f0-953f-0dfe025424db', 'Sirop à l''eau Passion', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('ed09c990-2161-11ee-8578-978bb1f27913', 'Caesar Salad Viet EMP/LIV', 'recette', 'Plat du moment', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('ee38efd0-d50e-11ec-b5cd-3fba70e914e7', 'BBT Limo Citron / Yuzu', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('ee9e96c0-307d-11ee-af48-fb839ee61b42', 'Poulet pop corn XL ', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.5,"tva":10},"emporter":{"ttc":12.5,"tva":10},"livraison":{"ttc":12.5,"tva":10}}'::jsonb, 'F712DC', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('ef9b02b0-307e-11ee-af48-fb839ee61b42', 'CHIA PUDDING FRUITS ROUGES VG', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":6,"tva":10},"emporter":{"ttc":6,"tva":10},"livraison":{"ttc":6,"tva":10}}'::jsonb, '74aef0', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('f090fda0-308d-11ee-af48-fb839ee61b42', 'PHO SATAY NORMAL (2)', 'recette', 'Plats', 0, '{"sur_place":{"ttc":12.5,"tva":10},"emporter":{"ttc":12.5,"tva":10},"livraison":{"ttc":12.5,"tva":10}}'::jsonb, '4497f1|bf941e', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('f09677d0-7580-11ed-a0a7-1b2de41c84da', 'Pot de glace vanille cookie EMP/LIV', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('f0f73b30-b8d3-11f0-8023-f50462a02790', 'crousty base', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('f17b6830-308e-11ee-af48-fb839ee61b42', 'MIXAO BF', 'recette', 'Plats', 0, '{"sur_place":{"ttc":14.9,"tva":10},"emporter":{"ttc":14.9,"tva":10},"livraison":{"ttc":14.5,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('f1cd5360-307b-11ee-af48-fb839ee61b42', 'EXTRA CEBETTE', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":1.8,"tva":10},"emporter":{"ttc":1.8,"tva":10},"livraison":{"ttc":1.8,"tva":10}}'::jsonb, '47dd95', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('f1ee92d0-3082-11ee-af48-fb839ee61b42', 'SUPP "POULET"', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":3,"tva":10},"emporter":{"ttc":3,"tva":10},"livraison":{"ttc":3,"tva":10}}'::jsonb, '607078', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('f2e68828-1a05-11eb-b54a-0a5bf521835e', 'Drinks', 'recette', 'Boissons', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('f453f830-55c7-11ed-8260-85ea4d40d179', 'Crevettes Sauce Ga Kho Normal', 'recette', 'Préparation', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('f4bdfdc0-cf50-11ef-90af-61ebec49d20b', 'Tofu Curry Jaune', 'recette', 'Plat du moment', 0, '{"sur_place":{"ttc":14.9,"tva":10},"emporter":{"ttc":14.9,"tva":10},"livraison":{"ttc":16.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('f6becfa0-c98b-11ec-885b-c998f5137173', 'PLAT DU MOMENT VG #1 SP', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('f73f86d0-952c-11ef-9dfb-cd4665e53e06', 'Ga Kho Boeuf', 'recette', 'Plats', 0, '{"sur_place":{"ttc":13.9,"tva":10},"emporter":{"ttc":13.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('f8434030-3083-11ee-af48-fb839ee61b42', 'POIVRE', 'recette', 'SPECIAL', 0, '{"sur_place":{"ttc":0,"tva":10},"emporter":{"ttc":0,"tva":10},"livraison":{"ttc":0,"tva":10}}'::jsonb, '410B39', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('f890e6d0-308a-11ee-af48-fb839ee61b42', 'Bouteille vin blanc', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":22,"tva":10},"emporter":{"ttc":22,"tva":10},"livraison":{"ttc":22,"tva":10}}'::jsonb, '60EAA5', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('f90c38b0-3087-11ee-af48-fb839ee61b42', 'CHEESECAKE TARO OREO', 'recette', 'Desserts', 0, '{"sur_place":{"ttc":1.5,"tva":10},"emporter":{"ttc":1.5,"tva":10},"livraison":{"ttc":6,"tva":10}}'::jsonb, '33C037', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('f98cd930-d5bf-11ec-9916-a1c1f658f229', 'MIXAO VG Légumes EMP/LIV', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('f9d5e230-f0c9-11ed-ada6-f1c2893b2f15', 'Caesar Salad Viet SP', 'recette', 'Plat du moment', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('fa3e6200-3085-11ee-af48-fb839ee61b42', 'SUPP LEGUMES', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":3,"tva":10},"emporter":{"ttc":3,"tva":10},"livraison":{"ttc":3,"tva":10}}'::jsonb, 'e9f460', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('faad0350-307a-11ee-af48-fb839ee61b42', 'EXTRA CITRON VERT (2)', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":0.5,"tva":10},"emporter":{"ttc":0.5,"tva":10},"livraison":{"ttc":0.5,"tva":10}}'::jsonb, 'b90de0', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('faf38230-cf2b-11ee-9180-5f1b01ee3b04', 'Bo Bun Thai Balls', 'recette', 'Plat du moment', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('fbab2780-307c-11ee-af48-fb839ee61b42', 'EXTRA CIBOULETTE', 'recette', 'Supplément', 0, '{"sur_place":{"ttc":1.5,"tva":10},"emporter":{"ttc":1.5,"tva":10},"livraison":{"ttc":1.5,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('fc0ae680-c150-11ec-a2ba-7bb1dc10361f', 'PHO VG NORMAL BASE', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('fcaa98f0-bbb8-11ef-bb4e-b5c75a97c9e7', 'Poulet Curry Rouge', 'recette', 'Plat du moment', 0, '{"sur_place":{"ttc":14.9,"tva":10},"emporter":{"ttc":14.9,"tva":10},"livraison":{"ttc":17.9,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('fd4c24c0-041a-11ed-ba73-47672f6aff75', 'Hanoï Salad EMP/LIV', 'recette', 'Plat du moment', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('fda50190-f6d1-11ec-87d3-cf5d212ef325', 'PLAT DU MOMENT VG (poulet) #2 SP', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('fdfc93c0-308b-11ee-af48-fb839ee61b42', 'BBT LIMO BASE', 'recette', 'Boissons', 0, '{"sur_place":{"ttc":1,"tva":10},"emporter":{"ttc":1,"tva":10}}'::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('ff41d980-c19b-11ec-b810-d1ffe210d8b1', 'Nems VG  SP ', 'recette', 'VG', 0, NULL::jsonb, NULL, true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('ff814e10-3082-11ee-af48-fb839ee61b42', 'CHICKEN WINGS x10', 'recette', 'KUNG PHOOD', 0, '{"sur_place":{"ttc":12.9,"tva":10},"emporter":{"ttc":12.9,"tva":10},"livraison":{"ttc":12.9,"tva":10}}'::jsonb, '8AFE66', true);
INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES ('ff829370-757e-11ed-9ceb-4384b0d4acc1', 'Cookie Framboise EMP/LIV', 'recette', 'Desserts', 0, NULL::jsonb, NULL, true);

-- Recette Ingredients (mappings)
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('005648f0-3091-11ee-af48-fb839ee61b42', '0020e110-3091-11ee-af48-fb839ee61b42', 'a18a96d0-9c4d-11ea-942f-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('005648f1-3091-11ee-af48-fb839ee61b42', '0020e110-3091-11ee-af48-fb839ee61b42', 'a18a97b6-9c4d-11ea-9430-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('003a49e0-e54b-11eb-b993-552ff2e9d866', '00398690-e54b-11eb-b993-552ff2e9d866', 'a18acbc8-9c4d-11ea-946b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('003a49e1-e54b-11eb-b993-552ff2e9d866', '00398690-e54b-11eb-b993-552ff2e9d866', '0b64ad20-e54a-11eb-b993-552ff2e9d866', 32, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('00979d20-bee0-11eb-95fb-335b2b14a84d', '009727f0-bee0-11eb-95fb-335b2b14a84d', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('0097c431-bee0-11eb-95fb-335b2b14a84d', '009727f0-bee0-11eb-95fb-335b2b14a84d', '8089c17c-9c4d-11ea-92cc-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('0097c432-bee0-11eb-95fb-335b2b14a84d', '009727f0-bee0-11eb-95fb-335b2b14a84d', '8089b3ee-9c4d-11ea-92be-0a5bf521835e', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('0097c433-bee0-11eb-95fb-335b2b14a84d', '009727f0-bee0-11eb-95fb-335b2b14a84d', '8089c780-9c4d-11ea-92d3-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('0097c434-bee0-11eb-95fb-335b2b14a84d', '009727f0-bee0-11eb-95fb-335b2b14a84d', '8089c32a-9c4d-11ea-92ce-0a5bf521835e', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('0097eb40-bee0-11eb-95fb-335b2b14a84d', '009727f0-bee0-11eb-95fb-335b2b14a84d', '8089a0c0-9c4d-11ea-92a8-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('0097eb41-bee0-11eb-95fb-335b2b14a84d', '009727f0-bee0-11eb-95fb-335b2b14a84d', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('0097eb42-bee0-11eb-95fb-335b2b14a84d', '009727f0-bee0-11eb-95fb-335b2b14a84d', 'a18a2d62-9c4d-11ea-93af-0a5bf521835e', 170, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8c765520-5468-11ec-a8c2-03e92580e6a1', '009727f0-bee0-11eb-95fb-335b2b14a84d', '378429f0-46eb-11ec-939f-314f99801403', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('80617680-20f6-11f0-a357-57306f3734b9', '01108240-55c9-11ed-b91e-49abdebf3d26', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('80617681-20f6-11f0-a357-57306f3734b9', '01108240-55c9-11ed-b91e-49abdebf3d26', 'f453f830-55c7-11ed-8260-85ea4d40d179', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('806239d0-20f6-11f0-a357-57306f3734b9', '01108240-55c9-11ed-b91e-49abdebf3d26', 'a18a7f06-9c4d-11ea-9411-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('0194fcc0-308c-11ee-af48-fb839ee61b42', '015f1fb0-308c-11ee-af48-fb839ee61b42', 'a18a7da8-9c4d-11ea-940f-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('019523d0-308c-11ee-af48-fb839ee61b42', '015f1fb0-308c-11ee-af48-fb839ee61b42', 'a18a7e5c-9c4d-11ea-9410-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('01b0a4b0-c19e-11ec-b810-d1ffe210d8b1', '01b02f80-c19e-11ec-b810-d1ffe210d8b1', '80893de2-9c4d-11ea-9283-0a5bf521835e', 200, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('01b0a4b1-c19e-11ec-b810-d1ffe210d8b1', '01b02f80-c19e-11ec-b810-d1ffe210d8b1', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 20, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('01b0a4b2-c19e-11ec-b810-d1ffe210d8b1', '01b02f80-c19e-11ec-b810-d1ffe210d8b1', '8089a2b4-9c4d-11ea-92aa-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('02698290-d1f3-11ec-94f4-0b63ddc79043', '0268e650-d1f3-11ec-94f4-0b63ddc79043', 'fcf1fa20-d1c2-11ec-88bd-5b29d81a78b4', 400, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('02698291-d1f3-11ec-94f4-0b63ddc79043', '0268e650-d1f3-11ec-94f4-0b63ddc79043', '8089bc9a-9c4d-11ea-92c8-0a5bf521835e', 30, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('02698292-d1f3-11ec-94f4-0b63ddc79043', '0268e650-d1f3-11ec-94f4-0b63ddc79043', 'a18a47ca-9c4d-11ea-93d6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('03381d10-b73a-11ef-9837-1733243488a6', '02a8cad0-b739-11ef-9837-1733243488a6', 'fcf1fa20-d1c2-11ec-88bd-5b29d81a78b4', 300, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('03384420-b73a-11ef-9837-1733243488a6', '02a8cad0-b739-11ef-9837-1733243488a6', '8089bc9a-9c4d-11ea-92c8-0a5bf521835e', 24, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c9e73db0-5796-11ee-ae33-4faf93189a95', '02b03e40-35b9-11ed-b203-11e5174470d0', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 8, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c9e73db1-5796-11ee-ae33-4faf93189a95', '02b03e40-35b9-11ed-b203-11e5174470d0', '8089d838-9c4d-11ea-92e5-0a5bf521835e', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c9e764c0-5796-11ee-ae33-4faf93189a95', '02b03e40-35b9-11ed-b203-11e5174470d0', '8089b4ca-9c4d-11ea-92bf-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c9e764c1-5796-11ee-ae33-4faf93189a95', '02b03e40-35b9-11ed-b203-11e5174470d0', '8089c17c-9c4d-11ea-92cc-0a5bf521835e', 17, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c9e82810-5796-11ee-ae33-4faf93189a95', '02b03e40-35b9-11ed-b203-11e5174470d0', '8089b312-9c4d-11ea-92bd-0a5bf521835e', 3, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c9e82811-5796-11ee-ae33-4faf93189a95', '02b03e40-35b9-11ed-b203-11e5174470d0', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c9e82812-5796-11ee-ae33-4faf93189a95', '02b03e40-35b9-11ed-b203-11e5174470d0', '0d161320-1baf-11ec-9cd0-53f06f053e40', 18, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c9e82813-5796-11ee-ae33-4faf93189a95', '02b03e40-35b9-11ed-b203-11e5174470d0', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 18, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c9e84f20-5796-11ee-ae33-4faf93189a95', '02b03e40-35b9-11ed-b203-11e5174470d0', '8089b696-9c4d-11ea-92c1-0a5bf521835e', 1, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c9e84f21-5796-11ee-ae33-4faf93189a95', '02b03e40-35b9-11ed-b203-11e5174470d0', '8089c406-9c4d-11ea-92cf-0a5bf521835e', 24, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c9e84f22-5796-11ee-ae33-4faf93189a95', '02b03e40-35b9-11ed-b203-11e5174470d0', 'a18a26c8-9c4d-11ea-93a9-0a5bf521835e', 300, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c9e84f23-5796-11ee-ae33-4faf93189a95', '02b03e40-35b9-11ed-b203-11e5174470d0', '2e3b3e20-4617-11ed-b8df-c363575b0859', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c9e84f24-5796-11ee-ae33-4faf93189a95', '02b03e40-35b9-11ed-b203-11e5174470d0', '62236300-38d1-11ed-88aa-d327dbab6e49', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('044ecaa0-c15b-11ec-853d-e7960d3897c4', '044d1cf0-c15b-11ec-853d-e7960d3897c4', 'a18a7f06-9c4d-11ea-9411-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e55c55e0-c1c3-11ec-853d-e7960d3897c4', '044d1cf0-c15b-11ec-853d-e7960d3897c4', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e55c55e1-c1c3-11ec-853d-e7960d3897c4', '044d1cf0-c15b-11ec-853d-e7960d3897c4', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('e55c55e2-c1c3-11ec-853d-e7960d3897c4', '044d1cf0-c15b-11ec-853d-e7960d3897c4', 'e760b460-4790-11ec-939f-314f99801403', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e55c7cf0-c1c3-11ec-853d-e7960d3897c4', '044d1cf0-c15b-11ec-853d-e7960d3897c4', '80899ef4-9c4d-11ea-92a6-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e55c7cf1-c1c3-11ec-853d-e7960d3897c4', '044d1cf0-c15b-11ec-853d-e7960d3897c4', '8089cc80-9c4d-11ea-92d9-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('0578b270-d695-11ec-9aab-3f3b95fb7b18', '05781630-d695-11ec-9aab-3f3b95fb7b18', 'f8c2c2a0-d694-11ec-9aab-3f3b95fb7b18', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('061cf510-4c49-11f0-96ac-4dfcc125480a', '05b22a80-4c37-11f0-96ac-4dfcc125480a', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('061cf511-4c49-11f0-96ac-4dfcc125480a', '05b22a80-4c37-11f0-96ac-4dfcc125480a', '1541beb0-21db-11f0-ac69-4ff8f2877233', 4, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('061cf513-4c49-11f0-96ac-4dfcc125480a', '05b22a80-4c37-11f0-96ac-4dfcc125480a', 'a18a7f06-9c4d-11ea-9411-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('061cf515-4c49-11f0-96ac-4dfcc125480a', '05b22a80-4c37-11f0-96ac-4dfcc125480a', '80899ef4-9c4d-11ea-92a6-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('3591c650-68fb-11ee-bf56-ffd73309e818', '0658e230-53d2-11ee-ad93-4d410949057c', '54953940-53d1-11ee-98c2-6770c73d7d3c', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('3591c651-68fb-11ee-bf56-ffd73309e818', '0658e230-53d2-11ee-ad93-4d410949057c', '8089cc80-9c4d-11ea-92d9-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('073dbe40-3083-11ee-af48-fb839ee61b42', '06fce4b0-3083-11ee-af48-fb839ee61b42', '457c5190-c15c-11ec-a2ba-7bb1dc10361f', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('073de550-3083-11ee-af48-fb839ee61b42', '06fce4b0-3083-11ee-af48-fb839ee61b42', '1e5ef750-d5e5-11ec-b2e2-5dd84dabb8a8', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('07ba2e00-e321-11eb-b4a4-c79ec670c12e', '07993880-e321-11eb-b4a4-c79ec670c12e', '009727f0-bee0-11eb-95fb-335b2b14a84d', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('07ba5510-e321-11eb-b4a4-c79ec670c12e', '07993880-e321-11eb-b4a4-c79ec670c12e', 'a18a3212-9c4d-11ea-93b6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('07ba5511-e321-11eb-b4a4-c79ec670c12e', '07993880-e321-11eb-b4a4-c79ec670c12e', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('086392e0-307e-11ee-af48-fb839ee61b42', '0839ead0-307e-11ee-af48-fb839ee61b42', '43bc1080-e31c-11eb-b4a4-c79ec670c12e', 1, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('08fb6ce0-783f-11eb-ad37-09556bb1f395', '08fa8280-783f-11eb-ad37-09556bb1f395', 'a54866e0-6ae6-11eb-80f6-73940ffe6b4a', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('09ceb340-308c-11ee-af48-fb839ee61b42', '0998d630-308c-11ee-af48-fb839ee61b42', '044d1cf0-c15b-11ec-853d-e7960d3897c4', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('09ceda50-308c-11ee-af48-fb839ee61b42', '0998d630-308c-11ee-af48-fb839ee61b42', 'd3cd0a70-d5c0-11ec-b2e2-5dd84dabb8a8', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('0a875690-38d3-11ed-a934-65f0780a90b4', '0a864520-38d3-11ed-a934-65f0780a90b4', '8089cc80-9c4d-11ea-92d9-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('947890d0-de3f-11ef-82b7-573083c1dbad', '0ac98ea0-bbb9-11ef-bb4e-b5c75a97c9e7', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('947890d2-de3f-11ef-82b7-573083c1dbad', '0ac98ea0-bbb9-11ef-bb4e-b5c75a97c9e7', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9478b7e0-de3f-11ef-82b7-573083c1dbad', '0ac98ea0-bbb9-11ef-bb4e-b5c75a97c9e7', '8089c258-9c4d-11ea-92cd-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9478b7e2-de3f-11ef-82b7-573083c1dbad', '0ac98ea0-bbb9-11ef-bb4e-b5c75a97c9e7', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9478b7e4-de3f-11ef-82b7-573083c1dbad', '0ac98ea0-bbb9-11ef-bb4e-b5c75a97c9e7', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9478b7e6-de3f-11ef-82b7-573083c1dbad', '0ac98ea0-bbb9-11ef-bb4e-b5c75a97c9e7', '8089c406-9c4d-11ea-92cf-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9478b7e8-de3f-11ef-82b7-573083c1dbad', '0ac98ea0-bbb9-11ef-bb4e-b5c75a97c9e7', 'a18a26c8-9c4d-11ea-93a9-0a5bf521835e', 300, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9478b7ea-de3f-11ef-82b7-573083c1dbad', '0ac98ea0-bbb9-11ef-bb4e-b5c75a97c9e7', '15289b50-bba7-11ef-a2da-67539c782629', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9478b7ec-de3f-11ef-82b7-573083c1dbad', '0ac98ea0-bbb9-11ef-bb4e-b5c75a97c9e7', 'a18a2b50-9c4d-11ea-93ac-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('0bc939d0-3083-11ee-af48-fb839ee61b42', '0b166490-3083-11ee-af48-fb839ee61b42', '931ca900-c156-11ec-853d-e7960d3897c4', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('0bc939d1-3083-11ee-af48-fb839ee61b42', '0b166490-3083-11ee-af48-fb839ee61b42', 'f98cd930-d5bf-11ec-9916-a1c1f658f229', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('0c1c73d0-308c-11ee-af48-fb839ee61b42', '0be66fb0-308c-11ee-af48-fb839ee61b42', '40a50750-c159-11ec-853d-e7960d3897c4', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('0c1c9ae0-308c-11ee-af48-fb839ee61b42', '0be66fb0-308c-11ee-af48-fb839ee61b42', '84f02310-d5c0-11ec-9916-a1c1f658f229', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('0cb10c20-c97c-11ec-860d-478ebb9d77b5', '0cb021c0-c97c-11ec-860d-478ebb9d77b5', 'e9464450-be20-11ec-a7fa-3529186828e2', 3, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('0cb10c21-c97c-11ec-860d-478ebb9d77b5', '0cb021c0-c97c-11ec-860d-478ebb9d77b5', '6e078db0-be2c-11ec-92b5-d17e9a4e477d', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('0cb10c22-c97c-11ec-860d-478ebb9d77b5', '0cb021c0-c97c-11ec-860d-478ebb9d77b5', '83dd7550-be2c-11ec-9222-db267923b89e', 40, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('0cb13330-c97c-11ec-860d-478ebb9d77b5', '0cb021c0-c97c-11ec-860d-478ebb9d77b5', 'fc0ae680-c150-11ec-a2ba-7bb1dc10361f', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('134c4520-d5c2-11ec-9916-a1c1f658f229', '0cb021c0-c97c-11ec-860d-478ebb9d77b5', 'a18a466c-9c4d-11ea-93d4-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('0d107350-811d-11ed-9124-af8ed14a816a', '0d0fb000-811d-11ed-9124-af8ed14a816a', '84398c10-601f-11ed-85c3-e1b33cb1c0b7', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('0d58e510-3084-11ee-af48-fb839ee61b42', '0d341f00-3084-11ee-af48-fb839ee61b42', 'dd5d83b4-1a08-11eb-99eb-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('0cf7a3f0-f307-11ed-b3e5-85bdede5075f', '0e0a0240-ebf3-11ec-a12f-77342cf624c3', '374bc7e0-f306-11ed-b0fa-47c95be3e3ca', 35, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('0e0b13b0-ebf3-11ec-a12f-77342cf624c3', '0e0a0240-ebf3-11ec-a12f-77342cf624c3', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 18, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('0e0b13b2-ebf3-11ec-a12f-77342cf624c3', '0e0a0240-ebf3-11ec-a12f-77342cf624c3', '8089c17c-9c4d-11ea-92cc-0a5bf521835e', 64, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('0e0b3ac1-ebf3-11ec-a12f-77342cf624c3', '0e0a0240-ebf3-11ec-a12f-77342cf624c3', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('0e0b3ac2-ebf3-11ec-a12f-77342cf624c3', '0e0a0240-ebf3-11ec-a12f-77342cf624c3', 'a18a2d62-9c4d-11ea-93af-0a5bf521835e', 180, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('0e0b3ac3-ebf3-11ec-a12f-77342cf624c3', '0e0a0240-ebf3-11ec-a12f-77342cf624c3', '80898374-9c4d-11ea-92a0-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('0e0b3ac7-ebf3-11ec-a12f-77342cf624c3', '0e0a0240-ebf3-11ec-a12f-77342cf624c3', '8089d0a4-9c4d-11ea-92de-0a5bf521835e', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('0e0b61d0-ebf3-11ec-a12f-77342cf624c3', '0e0a0240-ebf3-11ec-a12f-77342cf624c3', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 4, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('3467f050-ebf3-11ec-9630-193a22d236be', '0e0a0240-ebf3-11ec-a12f-77342cf624c3', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('4408d660-ec88-11ec-99ce-05cdb8890088', '0e0a0240-ebf3-11ec-a12f-77342cf624c3', '2f232d10-ec86-11ec-9630-193a22d236be', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5ce856f0-ebf8-11ec-8213-438a9eb4823a', '0e0a0240-ebf3-11ec-a12f-77342cf624c3', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a3589b20-0419-11ed-96d3-c75196a787dc', '0e0a0240-ebf3-11ec-a12f-77342cf624c3', '8089a0c0-9c4d-11ea-92a8-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b4d23f10-f798-11ec-87d3-cf5d212ef325', '0e0a0240-ebf3-11ec-a12f-77342cf624c3', '8089b4ca-9c4d-11ea-92bf-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e22a47f0-ec85-11ec-8b07-55ade4ba684a', '0e0a0240-ebf3-11ec-a12f-77342cf624c3', '8089b312-9c4d-11ea-92bd-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('cd40d370-84a6-11ef-a61c-dd317c3e8bb8', '0e9eb340-1d9c-11ef-994d-0be528309243', '784d06a0-8487-11ef-8ef8-37c5596a9593', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('cd40d371-84a6-11ef-a61c-dd317c3e8bb8', '0e9eb340-1d9c-11ef-994d-0be528309243', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('cd40fa80-84a6-11ef-a61c-dd317c3e8bb8', '0e9eb340-1d9c-11ef-994d-0be528309243', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('cd40fa81-84a6-11ef-a61c-dd317c3e8bb8', '0e9eb340-1d9c-11ef-994d-0be528309243', '8089a1ba-9c4d-11ea-92a9-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('0eeef2da-abcf-11ea-9ac2-0a5bf521835e', '0eee652c-abcf-11ea-9ac1-0a5bf521835e', '6e48f33a-abce-11ea-ad20-0a5bf521835e', 425, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('0f31d280-307e-11ee-af48-fb839ee61b42', '0f07b540-307e-11ee-af48-fb839ee61b42', 'a18acbc8-9c4d-11ea-946b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('0fea57a0-307f-11ee-af48-fb839ee61b42', '0fc4a730-307f-11ee-af48-fb839ee61b42', 'a18a2e0c-9c4d-11ea-93b0-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('10049560-308a-11ee-af48-fb839ee61b42', '0fde96d0-308a-11ee-af48-fb839ee61b42', 'a18acdee-9c4d-11ea-946e-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('1004bc71-308a-11ee-af48-fb839ee61b42', '0fde96d0-308a-11ee-af48-fb839ee61b42', '80897f50-9c4d-11ea-929c-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('123a3e40-3083-11ee-af48-fb839ee61b42', '12148dd0-3083-11ee-af48-fb839ee61b42', 'cd65a10a-1a06-11eb-90f1-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('123a6550-3083-11ee-af48-fb839ee61b42', '12148dd0-3083-11ee-af48-fb839ee61b42', 'ac133c30-6d38-11eb-a732-3588446adb69', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('123a5030-3081-11ee-af48-fb839ee61b42', '1215b130-3081-11ee-af48-fb839ee61b42', '905c80f0-9eb6-11eb-b217-2bde6a29a24e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('123a7741-3081-11ee-af48-fb839ee61b42', '1215b130-3081-11ee-af48-fb839ee61b42', '8089297e-9c4d-11ea-926b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('123a7742-3081-11ee-af48-fb839ee61b42', '1215b130-3081-11ee-af48-fb839ee61b42', '80892a5a-9c4d-11ea-926c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('12a541f0-757f-11ed-9601-4d9353852faa', '12a47ea0-757f-11ed-9601-4d9353852faa', '80896f06-9c4d-11ea-928c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('12a541f1-757f-11ed-9601-4d9353852faa', '12a47ea0-757f-11ed-9601-4d9353852faa', '80891f2e-9c4d-11ea-925f-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('12added0-fe78-11ef-abd3-1d5bab16a12f', '12aca650-fe78-11ef-abd3-1d5bab16a12f', 'f6545520-fe77-11ef-abd3-1d5bab16a12f', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('094b6ba0-21aa-11f0-8b95-0ba6cd1a2e00', '131b5770-6cdb-11ed-9eee-db05cb0c0e69', 'a18a4464-9c4d-11ea-93d1-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('094b6ba1-21aa-11f0-8b95-0ba6cd1a2e00', '131b5770-6cdb-11ed-9eee-db05cb0c0e69', '80892032-9c4d-11ea-9260-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('094b6ba2-21aa-11f0-8b95-0ba6cd1a2e00', '131b5770-6cdb-11ed-9eee-db05cb0c0e69', '72d41420-e53a-11ef-ad07-115a9609c7c9', 0.5, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('094b6ba4-21aa-11f0-8b95-0ba6cd1a2e00', '131b5770-6cdb-11ed-9eee-db05cb0c0e69', '8089c690-9c4d-11ea-92d2-0a5bf521835e', 19, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('094b92b1-21aa-11f0-8b95-0ba6cd1a2e00', '131b5770-6cdb-11ed-9eee-db05cb0c0e69', 'd0ceb8f0-3583-11ed-9548-ed051dc9e4fe', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('094b92b2-21aa-11f0-8b95-0ba6cd1a2e00', '131b5770-6cdb-11ed-9eee-db05cb0c0e69', '952356e0-8d98-11ed-b5d4-d30635a860b5', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('094b92b3-21aa-11f0-8b95-0ba6cd1a2e00', '131b5770-6cdb-11ed-9eee-db05cb0c0e69', '80893de2-9c4d-11ea-9283-0a5bf521835e', 125, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('094b92b5-21aa-11f0-8b95-0ba6cd1a2e00', '131b5770-6cdb-11ed-9eee-db05cb0c0e69', '89c0dd60-00ee-11f0-9d98-b7ea8c718efe', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('094b92b7-21aa-11f0-8b95-0ba6cd1a2e00', '131b5770-6cdb-11ed-9eee-db05cb0c0e69', '202590d0-be1b-11ec-9222-db267923b89e', 3, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('094b92b9-21aa-11f0-8b95-0ba6cd1a2e00', '131b5770-6cdb-11ed-9eee-db05cb0c0e69', '8089cf00-9c4d-11ea-92dc-0a5bf521835e', 3, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('094b92bb-21aa-11f0-8b95-0ba6cd1a2e00', '131b5770-6cdb-11ed-9eee-db05cb0c0e69', '808926cc-9c4d-11ea-9268-0a5bf521835e', 2, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('094b92bd-21aa-11f0-8b95-0ba6cd1a2e00', '131b5770-6cdb-11ed-9eee-db05cb0c0e69', '80892532-9c4d-11ea-9266-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('70596f30-de3f-11ef-b6d3-554965be2b1a', '15289b50-bba7-11ef-a2da-67539c782629', '8089b920-9c4d-11ea-92c4-0a5bf521835e', 200, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('70596f32-de3f-11ef-b6d3-554965be2b1a', '15289b50-bba7-11ef-a2da-67539c782629', '39983170-bba8-11ef-8612-e5fe96a59ed9', 20, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('70599641-de3f-11ef-b6d3-554965be2b1a', '15289b50-bba7-11ef-a2da-67539c782629', '8089b772-9c4d-11ea-92c2-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('70599643-de3f-11ef-b6d3-554965be2b1a', '15289b50-bba7-11ef-a2da-67539c782629', '80899d1e-9c4d-11ea-92a4-0a5bf521835e', 930, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('157d4980-237a-11f0-9aaa-bb233268bb26', '157c1100-237a-11f0-9aaa-bb233268bb26', '89c0dd60-00ee-11f0-9d98-b7ea8c718efe', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('160320e0-e545-11eb-b993-552ff2e9d866', '16025d90-e545-11eb-b993-552ff2e9d866', '8089751e-9c4d-11ea-9293-0a5bf521835e', 14, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8a0d1770-e545-11eb-be8e-9f30aafccd7a', '16025d90-e545-11eb-b993-552ff2e9d866', '8089b844-9c4d-11ea-92c3-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('16a33220-308d-11ee-af48-fb839ee61b42', '167ee140-308d-11ee-af48-fb839ee61b42', 'aa30a470-fb76-11ec-a176-d902a1918d35', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('177a8210-a63b-11ee-bbc7-c15280019a78', '1778d460-a63b-11ee-bbc7-c15280019a78', '5ccdcfd0-a63a-11ee-90ac-0338ca361de0', 10, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('17ae52d0-3088-11ee-af48-fb839ee61b42', '177c1f40-3088-11ee-af48-fb839ee61b42', 'a18a7830-9c4d-11ea-9407-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('17ae52d1-3088-11ee-af48-fb839ee61b42', '177c1f40-3088-11ee-af48-fb839ee61b42', 'a18a78da-9c4d-11ea-9408-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('af276790-e88e-11ef-9ae0-e94d7470c07a', '179d3d80-e303-11eb-9b9e-0f6f0f6fa679', 'a18a40f4-9c4d-11ea-93cc-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('af282ae0-e88e-11ef-9ae0-e94d7470c07a', '179d3d80-e303-11eb-9b9e-0f6f0f6fa679', '80899fda-9c4d-11ea-92a7-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('af2851f1-e88e-11ef-9ae0-e94d7470c07a', '179d3d80-e303-11eb-9b9e-0f6f0f6fa679', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('af2851f3-e88e-11ef-9ae0-e94d7470c07a', '179d3d80-e303-11eb-9b9e-0f6f0f6fa679', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('af2851f5-e88e-11ef-9ae0-e94d7470c07a', '179d3d80-e303-11eb-9b9e-0f6f0f6fa679', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('af287900-e88e-11ef-9ae0-e94d7470c07a', '179d3d80-e303-11eb-9b9e-0f6f0f6fa679', 'a18a2eb6-9c4d-11ea-93b1-0a5bf521835e', 170, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('af287902-e88e-11ef-9ae0-e94d7470c07a', '179d3d80-e303-11eb-9b9e-0f6f0f6fa679', '80893d1a-9c4d-11ea-9282-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('17a94890-d5c0-11ec-a670-e7c04af67adb', '17a8ac50-d5c0-11ec-a670-e7c04af67adb', '959ac860-c156-11ec-a2ba-7bb1dc10361f', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('17a94891-d5c0-11ec-a670-e7c04af67adb', '17a8ac50-d5c0-11ec-a670-e7c04af67adb', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('cdcbf2b0-00f8-11f0-908f-078ee4f654a2', '18f57270-3080-11ee-af48-fb839ee61b42', 'a18a53fa-9c4d-11ea-93e8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('1a65a340-308b-11ee-af48-fb839ee61b42', '1a293680-308b-11ee-af48-fb839ee61b42', 'a18a5f8a-9c4d-11ea-93f3-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('1a65a341-308b-11ee-af48-fb839ee61b42', '1a293680-308b-11ee-af48-fb839ee61b42', 'a18a6034-9c4d-11ea-93f4-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9d911be0-d712-11ee-86de-6fcf4ce0f5fb', '1a558720-d712-11ee-ac52-0b6841810148', '8089c0aa-9c4d-11ea-92cb-0a5bf521835e', 1700, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9d911be1-d712-11ee-86de-6fcf4ce0f5fb', '1a558720-d712-11ee-ac52-0b6841810148', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9d911be2-d712-11ee-86de-6fcf4ce0f5fb', '1a558720-d712-11ee-ac52-0b6841810148', '8089d522-9c4d-11ea-92e3-0a5bf521835e', 340, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9d911be3-d712-11ee-86de-6fcf4ce0f5fb', '1a558720-d712-11ee-ac52-0b6841810148', '8089b772-9c4d-11ea-92c2-0a5bf521835e', 51, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9d911be4-d712-11ee-86de-6fcf4ce0f5fb', '1a558720-d712-11ee-ac52-0b6841810148', '8089cc80-9c4d-11ea-92d9-0a5bf521835e', 1000, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('1b1d93c0-a8f1-11eb-9770-c18e5ed172e8', '1b1cf780-a8f1-11eb-9770-c18e5ed172e8', '8089c0aa-9c4d-11ea-92cb-0a5bf521835e', 700, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('1b1d93c1-a8f1-11eb-9770-c18e5ed172e8', '1b1cf780-a8f1-11eb-9770-c18e5ed172e8', '63466fb0-a8f0-11eb-a511-a582f5c4cbb1', 250, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('1b1d93c2-a8f1-11eb-9770-c18e5ed172e8', '1b1cf780-a8f1-11eb-9770-c18e5ed172e8', '8089b772-9c4d-11ea-92c2-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('1b1dbad0-a8f1-11eb-9770-c18e5ed172e8', '1b1cf780-a8f1-11eb-9770-c18e5ed172e8', 'e704fed0-a8ea-11eb-a272-274b1324dbc5', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('1b1dbad1-a8f1-11eb-9770-c18e5ed172e8', '1b1cf780-a8f1-11eb-9770-c18e5ed172e8', '8089b696-9c4d-11ea-92c1-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('1b1dbad2-a8f1-11eb-9770-c18e5ed172e8', '1b1cf780-a8f1-11eb-9770-c18e5ed172e8', '07c64f70-a8eb-11eb-a511-a582f5c4cbb1', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('1b1de1e0-a8f1-11eb-9770-c18e5ed172e8', '1b1cf780-a8f1-11eb-9770-c18e5ed172e8', '1c0a2560-a8eb-11eb-9cae-41439e88333c', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('1c3722e0-a974-11ee-8113-71b52dd3cd48', '1c361170-a974-11ee-8113-71b52dd3cd48', '7dac17b0-6757-11ee-a127-bd5aba4de5fc', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('1c826560-fb05-11ee-a4a8-777d36a25868', '1c812ce0-fb05-11ee-a4a8-777d36a25868', '21dd4110-91c0-11ed-b4d4-2171468c5ab0', 30, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('155a97d0-d4c1-11ef-bf1a-83329262ea79', '1dedf140-e31a-11eb-8237-736a902b6e66', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('155a97d1-d4c1-11ef-bf1a-83329262ea79', '1dedf140-e31a-11eb-8237-736a902b6e66', '8089cfdc-9c4d-11ea-92dd-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('155abee1-d4c1-11ef-bf1a-83329262ea79', '1dedf140-e31a-11eb-8237-736a902b6e66', 'c4eddf70-e304-11eb-9b9e-0f6f0f6fa679', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('1e5f9390-d5e5-11ec-b2e2-5dd84dabb8a8', '1e5ef750-d5e5-11ec-b2e2-5dd84dabb8a8', '80892032-9c4d-11ea-9260-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('1e5f9391-d5e5-11ec-b2e2-5dd84dabb8a8', '1e5ef750-d5e5-11ec-b2e2-5dd84dabb8a8', '808926cc-9c4d-11ea-9268-0a5bf521835e', 3, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('1e5f9392-d5e5-11ec-b2e2-5dd84dabb8a8', '1e5ef750-d5e5-11ec-b2e2-5dd84dabb8a8', 'e9464450-be20-11ec-a7fa-3529186828e2', 6, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('1e5f9393-d5e5-11ec-b2e2-5dd84dabb8a8', '1e5ef750-d5e5-11ec-b2e2-5dd84dabb8a8', '8089a61a-9c4d-11ea-92ae-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('1e5f9394-d5e5-11ec-b2e2-5dd84dabb8a8', '1e5ef750-d5e5-11ec-b2e2-5dd84dabb8a8', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 20, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('e1211b20-c88a-11ef-bf5c-b9dc341c8c34', '1ec5a060-d6ef-11ee-a52e-515320277cef', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('e1211b21-c88a-11ef-bf5c-b9dc341c8c34', '1ec5a060-d6ef-11ee-a52e-515320277cef', 'a9fa7cb0-d6ee-11ee-8099-878d940648e3', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('1f0c0890-3085-11ee-af48-fb839ee61b42', '1eceff90-3085-11ee-af48-fb839ee61b42', 'a18a6246-9c4d-11ea-93f7-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('1f0c2fa0-3085-11ee-af48-fb839ee61b42', '1eceff90-3085-11ee-af48-fb839ee61b42', 'a18a62f0-9c4d-11ea-93f8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('1f0ce860-3084-11ee-af48-fb839ee61b42', '1ed9a360-3084-11ee-af48-fb839ee61b42', 'd58148e0-9dea-11eb-9fc3-c54eb2b1a2bd', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('1f0ce861-3084-11ee-af48-fb839ee61b42', '1ed9a360-3084-11ee-af48-fb839ee61b42', '85862ad0-9deb-11eb-9fc3-c54eb2b1a2bd', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('1f4c0170-757d-11ed-9ceb-4384b0d4acc1', '1f4af000-757d-11ed-9ceb-4384b0d4acc1', '808944cc-9c4d-11ea-928b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('1f4c0171-757d-11ed-9ceb-4384b0d4acc1', '1f4af000-757d-11ed-9ceb-4384b0d4acc1', '80891f2e-9c4d-11ea-925f-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('ee5eaa60-e53a-11ef-a2f4-2d43b0a29778', '208b5f30-96b0-11ef-82ea-15fba2c86089', 'a18a404a-9c4d-11ea-93cb-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ee5eaa62-e53a-11ef-a2f4-2d43b0a29778', '208b5f30-96b0-11ef-82ea-15fba2c86089', '80892032-9c4d-11ea-9260-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ee5eaa63-e53a-11ef-a2f4-2d43b0a29778', '208b5f30-96b0-11ef-82ea-15fba2c86089', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ee5eaa65-e53a-11ef-a2f4-2d43b0a29778', '208b5f30-96b0-11ef-82ea-15fba2c86089', '202590d0-be1b-11ec-9222-db267923b89e', 5, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('217b9710-3087-11ee-af48-fb839ee61b42', '214df760-3087-11ee-af48-fb839ee61b42', 'a18acc7c-9c4d-11ea-946c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('217bbe21-3087-11ee-af48-fb839ee61b42', '214df760-3087-11ee-af48-fb839ee61b42', '66ff9a30-00f8-11ed-82ff-e103d8d6432f', 30, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('48d638f0-2375-11f0-bb68-a1d2c971872e', '21a25d40-2375-11f0-9aaa-bb233268bb26', 'e0db1a50-7d4e-11ed-bef2-3be33b07e51f', 25, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('21b88690-7734-11ee-a1ca-ed4795abb9e6', '21b6fff0-7734-11ee-a1ca-ed4795abb9e6', '8089d0a4-9c4d-11ea-92de-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('21b88691-7734-11ee-a1ca-ed4795abb9e6', '21b6fff0-7734-11ee-a1ca-ed4795abb9e6', 'a18a865e-9c4d-11ea-941c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('21bc1c60-bee0-11eb-95fb-335b2b14a84d', '21bb8020-bee0-11eb-95fb-335b2b14a84d', '009727f0-bee0-11eb-95fb-335b2b14a84d', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('21bc1c61-bee0-11eb-95fb-335b2b14a84d', '21bb8020-bee0-11eb-95fb-335b2b14a84d', 'a18a3168-9c4d-11ea-93b5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('22929da0-308d-11ee-af48-fb839ee61b42', '225daaf0-308d-11ee-af48-fb839ee61b42', 'a18a6502-9c4d-11ea-93fb-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('22929da1-308d-11ee-af48-fb839ee61b42', '225daaf0-308d-11ee-af48-fb839ee61b42', 'a18a65ac-9c4d-11ea-93fc-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('225f0c20-a827-11ef-b50d-0d342dc0c076', '225dfab0-a827-11ef-b50d-0d342dc0c076', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('225f3331-a827-11ef-b50d-0d342dc0c076', '225dfab0-a827-11ef-b50d-0d342dc0c076', '80899ef4-9c4d-11ea-92a6-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('225f3333-a827-11ef-b50d-0d342dc0c076', '225dfab0-a827-11ef-b50d-0d342dc0c076', 'a18aa8fa-9c4d-11ea-9449-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('225f5a41-a827-11ef-b50d-0d342dc0c076', '225dfab0-a827-11ef-b50d-0d342dc0c076', 'a18a7f06-9c4d-11ea-9411-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('22a31fc0-308a-11ee-af48-fb839ee61b42', '227ad740-308a-11ee-af48-fb839ee61b42', 'f8c2c2a0-d694-11ec-9aab-3f3b95fb7b18', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('22a346d1-308a-11ee-af48-fb839ee61b42', '227ad740-308a-11ee-af48-fb839ee61b42', '80891f2e-9c4d-11ea-925f-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('23abf9b0-3089-11ee-af48-fb839ee61b42', '2376dff0-3089-11ee-af48-fb839ee61b42', 'a18a8b40-9c4d-11ea-9423-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('23ac20c0-3089-11ee-af48-fb839ee61b42', '2376dff0-3089-11ee-af48-fb839ee61b42', 'a18a8c08-9c4d-11ea-9424-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('2449dd70-e3d2-11eb-b993-552ff2e9d866', '24496840-e3d2-11eb-b993-552ff2e9d866', '602f4f30-a8f1-11eb-a272-274b1324dbc5', 62.5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('244a0480-e3d2-11eb-b993-552ff2e9d866', '24496840-e3d2-11eb-b993-552ff2e9d866', '80899b48-9c4d-11ea-92a2-0a5bf521835e', 62.5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('244a0481-e3d2-11eb-b993-552ff2e9d866', '24496840-e3d2-11eb-b993-552ff2e9d866', '8089d522-9c4d-11ea-92e3-0a5bf521835e', 12.5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('244a0482-e3d2-11eb-b993-552ff2e9d866', '24496840-e3d2-11eb-b993-552ff2e9d866', '1b1cf780-a8f1-11eb-9770-c18e5ed172e8', 62.5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('2559a720-8f67-11ee-89c1-731f17c336c3', '255190d0-8f67-11ee-89c1-731f17c336c3', 'faac3510-8f66-11ee-89c1-731f17c336c3', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('2559ce30-8f67-11ee-89c1-731f17c336c3', '255190d0-8f67-11ee-89c1-731f17c336c3', '80891f2e-9c4d-11ea-925f-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('267bdf60-3085-11ee-af48-fb839ee61b42', '25c73560-3085-11ee-af48-fb839ee61b42', 'f6becfa0-c98b-11ec-885b-c998f5137173', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('267c0670-3085-11ee-af48-fb839ee61b42', '25c73560-3085-11ee-af48-fb839ee61b42', '6bb018f0-d5c1-11ec-8b7a-0f22ec019de6', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('26c37610-308d-11ee-af48-fb839ee61b42', '269c8d20-308d-11ee-af48-fb839ee61b42', 'd257ad90-9eb6-11eb-98d0-4d3123634f37', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('26c39d20-308d-11ee-af48-fb839ee61b42', '269c8d20-308d-11ee-af48-fb839ee61b42', '8089297e-9c4d-11ea-926b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('26c39d21-308d-11ee-af48-fb839ee61b42', '269c8d20-308d-11ee-af48-fb839ee61b42', '80892a5a-9c4d-11ea-926c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('27dd9bd0-610c-11ed-8963-4516daed1f7c', '27dcd880-610c-11ed-8963-4516daed1f7c', '80893de2-9c4d-11ea-9283-0a5bf521835e', 200, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('27ddc2e0-610c-11ed-8963-4516daed1f7c', '27dcd880-610c-11ed-8963-4516daed1f7c', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 20, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('27ddc2e1-610c-11ed-8963-4516daed1f7c', '27dcd880-610c-11ed-8963-4516daed1f7c', '8089a2b4-9c4d-11ea-92aa-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('27ddc2e2-610c-11ed-8963-4516daed1f7c', '27dcd880-610c-11ed-8963-4516daed1f7c', 'a18a40f4-9c4d-11ea-93cc-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('29b552f0-b73a-11ef-93a1-c158d35cfb9e', '29b41a70-b73a-11ef-93a1-c158d35cfb9e', 'fcf1fa20-d1c2-11ec-88bd-5b29d81a78b4', 300, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('29b6b281-b73a-11ef-93a1-c158d35cfb9e', '29b41a70-b73a-11ef-93a1-c158d35cfb9e', '8089bc9a-9c4d-11ea-92c8-0a5bf521835e', 24, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('2bbbbff0-a63b-11ee-b3cd-3d8b47d7dc66', '2bba8770-a63b-11ee-b3cd-3d8b47d7dc66', '6eaefda0-a63a-11ee-941d-29757a71a6ae', 10, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('2ce8379a-1a03-11eb-9cb2-0a5bf521835e', '2ce78f84-1a03-11eb-9cb1-0a5bf521835e', '8089cac8-9c4d-11ea-92d7-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('2d26f3c0-d520-11ec-983e-772482502ae8', '2d25e250-d520-11ec-983e-772482502ae8', 'aaae78d0-c153-11ec-b810-d1ffe210d8b1', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('2d26f3c1-d520-11ec-983e-772482502ae8', '2d25e250-d520-11ec-983e-772482502ae8', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('2dd06d60-3082-11ee-af48-fb839ee61b42', '2d933d50-3082-11ee-af48-fb839ee61b42', 'a18a5094-9c4d-11ea-93e3-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('2dd09470-3082-11ee-af48-fb839ee61b42', '2d933d50-3082-11ee-af48-fb839ee61b42', 'a18a5148-9c4d-11ea-93e4-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('2e507500-3091-11ee-af48-fb839ee61b42', '2e2a9d80-3091-11ee-af48-fb839ee61b42', 'a18abe3a-9c4d-11ea-9458-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('2e509c10-3091-11ee-af48-fb839ee61b42', '2e2a9d80-3091-11ee-af48-fb839ee61b42', 'a18abeee-9c4d-11ea-9459-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('165f9fb0-e1e5-11ee-9dbd-77ae95427ab6', '2e2e8200-cf2a-11ee-b6de-95c295bfc3e2', 'a18a4de2-9c4d-11ea-93df-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('165f9fb1-e1e5-11ee-9dbd-77ae95427ab6', '2e2e8200-cf2a-11ee-b6de-95c295bfc3e2', '4c217cf0-cf15-11ee-9196-c5c68bf4c631', 5, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('2e5b0e1c-1a09-11eb-8a55-0a5bf521835e', '2e5a7d12-1a09-11eb-8a54-0a5bf521835e', '8089a0c0-9c4d-11ea-92a8-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('27e0d820-8f70-11ee-abb8-7d7b4983bd49', '31ea0b50-811d-11ed-b263-b95e21b5e348', 'c62145d0-8c13-11ed-a977-852f0d1617fb', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('32020a20-c994-11ec-a38a-8d13737e0b72', '320146d0-c994-11ec-a38a-8d13737e0b72', '3f700a20-c1a3-11ec-853d-e7960d3897c4', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('32020a21-c994-11ec-a38a-8d13737e0b72', '320146d0-c994-11ec-a38a-8d13737e0b72', '808943f0-9c4d-11ea-928a-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('32020a22-c994-11ec-a38a-8d13737e0b72', '320146d0-c994-11ec-a38a-8d13737e0b72', '8089b9f2-9c4d-11ea-92c5-0a5bf521835e', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('3258ff90-307e-11ee-af48-fb839ee61b42', '3224d030-307e-11ee-af48-fb839ee61b42', 'a18a7c40-9c4d-11ea-940d-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('3258ff91-307e-11ee-af48-fb839ee61b42', '3224d030-307e-11ee-af48-fb839ee61b42', 'a18a7ce0-9c4d-11ea-940e-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('33e45880-de44-11ef-9861-a9c1b860eb22', '33e25cb0-de44-11ef-9861-a9c1b860eb22', '8089d838-9c4d-11ea-92e5-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('33e47f90-de44-11ef-9861-a9c1b860eb22', '33e25cb0-de44-11ef-9861-a9c1b860eb22', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('33e47f92-de44-11ef-9861-a9c1b860eb22', '33e25cb0-de44-11ef-9861-a9c1b860eb22', 'a18a43b0-9c4d-11ea-93d0-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('33e47f93-de44-11ef-9861-a9c1b860eb22', '33e25cb0-de44-11ef-9861-a9c1b860eb22', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('33e4a6a0-de44-11ef-9861-a9c1b860eb22', '33e25cb0-de44-11ef-9861-a9c1b860eb22', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('33e4a6a2-de44-11ef-9861-a9c1b860eb22', '33e25cb0-de44-11ef-9861-a9c1b860eb22', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('33e4a6a4-de44-11ef-9861-a9c1b860eb22', '33e25cb0-de44-11ef-9861-a9c1b860eb22', 'a18a2f6a-9c4d-11ea-93b2-0a5bf521835e', 170, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('33e4cdb1-de44-11ef-9861-a9c1b860eb22', '33e25cb0-de44-11ef-9861-a9c1b860eb22', 'e9d88d10-b944-11eb-acec-29fb8569cb50', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('33e4cdb3-de44-11ef-9861-a9c1b860eb22', '33e25cb0-de44-11ef-9861-a9c1b860eb22', '6b794010-46eb-11ec-bc07-efd394bb365a', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('33e4f4c0-de44-11ef-9861-a9c1b860eb22', '33e25cb0-de44-11ef-9861-a9c1b860eb22', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('33e4f4c2-de44-11ef-9861-a9c1b860eb22', '33e25cb0-de44-11ef-9861-a9c1b860eb22', '15289b50-bba7-11ef-a2da-67539c782629', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('33e96ab0-e88e-11ef-b713-6d60198332da', '33e88050-e88e-11ef-b713-6d60198332da', '5b05ba10-cf50-11ef-9028-f1198bb1e3d6', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('33e96ab2-e88e-11ef-b713-6d60198332da', '33e88050-e88e-11ef-b713-6d60198332da', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('33e991c0-e88e-11ef-b713-6d60198332da', '33e88050-e88e-11ef-b713-6d60198332da', '8089d838-9c4d-11ea-92e5-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('33e991c2-e88e-11ef-b713-6d60198332da', '33e88050-e88e-11ef-b713-6d60198332da', 'a18a43b0-9c4d-11ea-93d0-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('33e991c3-e88e-11ef-b713-6d60198332da', '33e88050-e88e-11ef-b713-6d60198332da', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('33e991c5-e88e-11ef-b713-6d60198332da', '33e88050-e88e-11ef-b713-6d60198332da', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('33e991c7-e88e-11ef-b713-6d60198332da', '33e88050-e88e-11ef-b713-6d60198332da', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('33e9b8d0-e88e-11ef-b713-6d60198332da', '33e88050-e88e-11ef-b713-6d60198332da', 'a18a2f6a-9c4d-11ea-93b2-0a5bf521835e', 170, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('33e9b8d2-e88e-11ef-b713-6d60198332da', '33e88050-e88e-11ef-b713-6d60198332da', 'e9d88d10-b944-11eb-acec-29fb8569cb50', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('33e9b8d4-e88e-11ef-b713-6d60198332da', '33e88050-e88e-11ef-b713-6d60198332da', '6b794010-46eb-11ec-bc07-efd394bb365a', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('33ea2e00-e88e-11ef-b713-6d60198332da', '33e88050-e88e-11ef-b713-6d60198332da', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('346955c0-e31c-11eb-8237-736a902b6e66', '3468b980-e31c-11eb-8237-736a902b6e66', '9fe020a0-e31b-11eb-b993-552ff2e9d866', 250, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('59774e00-20f6-11f0-acf1-2d87a7025b77', '356dccf0-952d-11ef-9c52-43a2af8862e9', '85e7df00-952c-11ef-b1c9-a52e879704e5', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('59774e02-20f6-11f0-acf1-2d87a7025b77', '356dccf0-952d-11ef-9c52-43a2af8862e9', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('59774e03-20f6-11f0-acf1-2d87a7025b77', '356dccf0-952d-11ef-9c52-43a2af8862e9', 'a18a7fb0-9c4d-11ea-9412-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('36672c70-308c-11ee-af48-fb839ee61b42', '364329b0-308c-11ee-af48-fb839ee61b42', 'a18a4bda-9c4d-11ea-93dc-0a5bf521835e', 2, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('3702d460-3085-11ee-af48-fb839ee61b42', '36dada00-3085-11ee-af48-fb839ee61b42', 'a18ac056-9c4d-11ea-945b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('3725c460-e321-11eb-b993-552ff2e9d866', '3724da00-e321-11eb-b993-552ff2e9d866', '5fd18ab0-bedd-11eb-b72d-730bbd0b1638', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('3725eb70-e321-11eb-b993-552ff2e9d866', '3724da00-e321-11eb-b993-552ff2e9d866', 'a18a32bc-9c4d-11ea-93b7-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('3759dbc0-308a-11ee-af48-fb839ee61b42', '372ab570-308a-11ee-af48-fb839ee61b42', 'e5e1fbe0-c15b-11ec-a2ba-7bb1dc10361f', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('3759dbc1-308a-11ee-af48-fb839ee61b42', '372ab570-308a-11ee-af48-fb839ee61b42', 'cc4e3520-d5e4-11ec-9916-a1c1f658f229', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('374c8b30-f306-11ed-b0fa-47c95be3e3ca', '374bc7e0-f306-11ed-b0fa-47c95be3e3ca', '8089c32a-9c4d-11ea-92ce-0a5bf521835e', 800, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('3786e910-46eb-11ec-939f-314f99801403', '378429f0-46eb-11ec-939f-314f99801403', '2b877c00-46bf-11ec-939f-314f99801403', 1070, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('386e0350-fb0b-11ee-8459-f9898c99c906', '386bb960-fb0b-11ee-8459-f9898c99c906', '4c217cf0-cf15-11ee-9196-c5c68bf4c631', 2, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('38eafa90-a8b6-11eb-a511-a582f5c4cbb1', '38ea1030-a8b6-11eb-a511-a582f5c4cbb1', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 200, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('38eafa91-a8b6-11eb-a511-a582f5c4cbb1', '38ea1030-a8b6-11eb-a511-a582f5c4cbb1', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('38eafa92-a8b6-11eb-a511-a582f5c4cbb1', '38ea1030-a8b6-11eb-a511-a582f5c4cbb1', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 160, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('38eafa93-a8b6-11eb-a511-a582f5c4cbb1', '38ea1030-a8b6-11eb-a511-a582f5c4cbb1', '8089d522-9c4d-11ea-92e3-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('38eb21a0-a8b6-11eb-a511-a582f5c4cbb1', '38ea1030-a8b6-11eb-a511-a582f5c4cbb1', '8089b696-9c4d-11ea-92c1-0a5bf521835e', 8, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6ba0df40-a98d-11eb-a252-9103ac2596ee', '38ea1030-a8b6-11eb-a511-a582f5c4cbb1', '808938ec-9c4d-11ea-927d-0a5bf521835e', 30, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6ba10650-a98d-11eb-a252-9103ac2596ee', '38ea1030-a8b6-11eb-a511-a582f5c4cbb1', '808939be-9c4d-11ea-927e-0a5bf521835e', 30, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6ba10651-a98d-11eb-a252-9103ac2596ee', '38ea1030-a8b6-11eb-a511-a582f5c4cbb1', '18ab8420-a8b6-11eb-9770-c18e5ed172e8', 120, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6ba12d60-a98d-11eb-a252-9103ac2596ee', '38ea1030-a8b6-11eb-a511-a582f5c4cbb1', 'c384cf60-a8b5-11eb-9cae-41439e88333c', 1000, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('392bcf80-8f67-11ee-a601-bd4702810762', '392abe10-8f67-11ee-a601-bd4702810762', 'faac3510-8f66-11ee-89c1-731f17c336c3', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('392bcf81-8f67-11ee-a601-bd4702810762', '392abe10-8f67-11ee-a601-bd4702810762', '80891f2e-9c4d-11ea-925f-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('fc0c2b40-d4c0-11ef-81b1-519beedbf8f8', '39e02650-0969-11ec-aefc-8520bddbc69b', '8089d838-9c4d-11ea-92e5-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('fc0c2b42-d4c0-11ef-81b1-519beedbf8f8', '39e02650-0969-11ec-aefc-8520bddbc69b', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('fc0c5250-d4c0-11ef-81b1-519beedbf8f8', '39e02650-0969-11ec-aefc-8520bddbc69b', 'c4eddf70-e304-11eb-9b9e-0f6f0f6fa679', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('5f826400-b96d-11f0-8031-052614611c52', '3cc5d830-1d9b-11ef-8c72-f55f24b8a876', 'f0f73b30-b8d3-11f0-8023-f50462a02790', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5f826401-b96d-11f0-8031-052614611c52', '3cc5d830-1d9b-11ef-8c72-f55f24b8a876', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5f826402-b96d-11f0-8031-052614611c52', '3cc5d830-1d9b-11ef-8c72-f55f24b8a876', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5f826403-b96d-11f0-8031-052614611c52', '3cc5d830-1d9b-11ef-8c72-f55f24b8a876', '8089a1ba-9c4d-11ea-92a9-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('3cf9f870-3086-11ee-af48-fb839ee61b42', '3cd420f0-3086-11ee-af48-fb839ee61b42', '6bb818c0-d045-11eb-9f02-bf5812513161', 2, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('3cfa1f80-3086-11ee-af48-fb839ee61b42', '3cd420f0-3086-11ee-af48-fb839ee61b42', '8089297e-9c4d-11ea-926b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('3cfa1f81-3086-11ee-af48-fb839ee61b42', '3cd420f0-3086-11ee-af48-fb839ee61b42', '80892a5a-9c4d-11ea-926c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('3d141bb0-307c-11ee-af48-fb839ee61b42', '3ceee070-307c-11ee-af48-fb839ee61b42', 'a18acf56-9c4d-11ea-9470-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('3d1442c1-307c-11ee-af48-fb839ee61b42', '3ceee070-307c-11ee-af48-fb839ee61b42', '8eda7860-7cd6-11eb-83c2-81353eec23fb', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('236d6020-e3d2-11eb-b4a4-c79ec670c12e', '3e3b0dc0-a8fa-11eb-9770-c18e5ed172e8', '1b1cf780-a8f1-11eb-9770-c18e5ed172e8', 66.67, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('3e3baa00-a8fa-11eb-9770-c18e5ed172e8', '3e3b0dc0-a8fa-11eb-9770-c18e5ed172e8', '1ccd9ea0-a8fa-11eb-9cae-41439e88333c', 66.67, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('3e3baa01-a8fa-11eb-9770-c18e5ed172e8', '3e3b0dc0-a8fa-11eb-9770-c18e5ed172e8', '80899b48-9c4d-11ea-92a2-0a5bf521835e', 66.67, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('3e3bd110-a8fa-11eb-9770-c18e5ed172e8', '3e3b0dc0-a8fa-11eb-9770-c18e5ed172e8', '8089d522-9c4d-11ea-92e3-0a5bf521835e', 13.33, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('3ea82930-307c-11ee-af48-fb839ee61b42', '3e818e60-307c-11ee-af48-fb839ee61b42', 'd623e450-fb73-11ec-a176-d902a1918d35', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('3bff8cc1-c1a9-11ec-b810-d1ffe210d8b1', '3f700a20-c1a3-11ec-853d-e7960d3897c4', 'bf29fff0-c1a8-11ec-b810-d1ffe210d8b1', 80, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('3f707f50-c1a3-11ec-853d-e7960d3897c4', '3f700a20-c1a3-11ec-853d-e7960d3897c4', '8089b920-9c4d-11ea-92c4-0a5bf521835e', 500, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5d9125b0-c1a9-11ec-9265-d57037e66861', '3f700a20-c1a3-11ec-853d-e7960d3897c4', '18ab8420-a8b6-11eb-9770-c18e5ed172e8', 20, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('3fca7300-3085-11ee-af48-fb839ee61b42', '3f9f6b60-3085-11ee-af48-fb839ee61b42', '9fe020a0-e31b-11eb-b993-552ff2e9d866', 500, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('3fca9a10-3085-11ee-af48-fb839ee61b42', '3f9f6b60-3085-11ee-af48-fb839ee61b42', '80897b0e-9c4d-11ea-9297-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('3fca9a11-3085-11ee-af48-fb839ee61b42', '3f9f6b60-3085-11ee-af48-fb839ee61b42', '80897cbc-9c4d-11ea-9299-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('3ff45840-307c-11ee-af48-fb839ee61b42', '3fbc5850-307c-11ee-af48-fb839ee61b42', 'a18aa9ae-9c4d-11ea-944a-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('3ff45841-307c-11ee-af48-fb839ee61b42', '3fbc5850-307c-11ee-af48-fb839ee61b42', 'a18aaa58-9c4d-11ea-944b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('401994c0-c19c-11ec-b810-d1ffe210d8b1', '4018f880-c19c-11ec-b810-d1ffe210d8b1', '378429f0-46eb-11ec-939f-314f99801403', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('401994c1-c19c-11ec-b810-d1ffe210d8b1', '4018f880-c19c-11ec-b810-d1ffe210d8b1', '8089b3ee-9c4d-11ea-92be-0a5bf521835e', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('401994c2-c19c-11ec-b810-d1ffe210d8b1', '4018f880-c19c-11ec-b810-d1ffe210d8b1', '84f86af0-be1b-11ec-92b5-d17e9a4e477d', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('4029afb0-da74-11ef-a19c-19f230724a0f', '40287730-da74-11ef-a19c-19f230724a0f', '8089bace-9c4d-11ea-92c6-0a5bf521835e', 13, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('4029d6c0-da74-11ef-a19c-19f230724a0f', '40287730-da74-11ef-a19c-19f230724a0f', '8089a7fa-9c4d-11ea-92b0-0a5bf521835e', 0.3, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('4029d6c2-da74-11ef-a19c-19f230724a0f', '40287730-da74-11ef-a19c-19f230724a0f', '808970d2-9c4d-11ea-928e-0a5bf521835e', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('4029d6c4-da74-11ef-a19c-19f230724a0f', '40287730-da74-11ef-a19c-19f230724a0f', 'a18a491e-9c4d-11ea-93d8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('4029d6c5-da74-11ef-a19c-19f230724a0f', '40287730-da74-11ef-a19c-19f230724a0f', 'a18a4874-9c4d-11ea-93d7-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('40a5a390-c159-11ec-853d-e7960d3897c4', '40a50750-c159-11ec-853d-e7960d3897c4', 'ae8f5fb0-c157-11ec-b810-d1ffe210d8b1', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('40a5a391-c159-11ec-853d-e7960d3897c4', '40a50750-c159-11ec-853d-e7960d3897c4', '76bb1e20-c158-11ec-9265-d57037e66861', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('40a5a392-c159-11ec-853d-e7960d3897c4', '40a50750-c159-11ec-853d-e7960d3897c4', 'e9d88d10-b944-11eb-acec-29fb8569cb50', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('84ae22f0-c989-11ec-a38a-8d13737e0b72', '40a50750-c159-11ec-853d-e7960d3897c4', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('84ae22f1-c989-11ec-a38a-8d13737e0b72', '40a50750-c159-11ec-853d-e7960d3897c4', '378429f0-46eb-11ec-939f-314f99801403', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('41393c00-d1f7-11ec-94f4-0b63ddc79043', '413878b0-d1f7-11ec-94f4-0b63ddc79043', 'a18acc7c-9c4d-11ea-946c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('41393c01-d1f7-11ec-94f4-0b63ddc79043', '413878b0-d1f7-11ec-94f4-0b63ddc79043', 'fcf1fa20-d1c2-11ec-88bd-5b29d81a78b4', 400, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('414f7250-8e22-11eb-a941-234f53fd3ac7', '414ed610-8e22-11eb-a941-234f53fd3ac7', '80893810-9c4d-11ea-927c-0a5bf521835e', 300, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('414f9960-8e22-11eb-a941-234f53fd3ac7', '414ed610-8e22-11eb-a941-234f53fd3ac7', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('414f9961-8e22-11eb-a941-234f53fd3ac7', '414ed610-8e22-11eb-a941-234f53fd3ac7', '80893d1a-9c4d-11ea-9282-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('414f9962-8e22-11eb-a941-234f53fd3ac7', '414ed610-8e22-11eb-a941-234f53fd3ac7', 'a18a40f4-9c4d-11ea-93cc-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('43515300-3089-11ee-af48-fb839ee61b42', '432c65e0-3089-11ee-af48-fb839ee61b42', 'baa28230-7cd6-11eb-9648-651da3a4a532', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('43bcd3d0-e31c-11eb-b4a4-c79ec670c12e', '43bc1080-e31c-11eb-b4a4-c79ec670c12e', '9fe020a0-e31b-11eb-b993-552ff2e9d866', 500, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('43d62ea0-77a6-11ed-ba0d-73a48f825398', '43d54440-77a6-11ed-ba0d-73a48f825398', '9724eb40-55c9-11ed-8260-85ea4d40d179', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('43d62ea1-77a6-11ed-ba0d-73a48f825398', '43d54440-77a6-11ed-ba0d-73a48f825398', '8089c17c-9c4d-11ea-92cc-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c0151020-21d2-11f0-8e38-472558b3b72f', '43fa2710-edf5-11eb-8cf4-3f10540222ef', '62352cb0-c44d-11eb-933b-0fde1972ba99', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c0151021-21d2-11f0-8e38-472558b3b72f', '43fa2710-edf5-11eb-8cf4-3f10540222ef', '8089b920-9c4d-11ea-92c4-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('454a4860-307f-11ee-af48-fb839ee61b42', '45144440-307f-11ee-af48-fb839ee61b42', 'a18a6c0a-9c4d-11ea-9403-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('454a6f70-307f-11ee-af48-fb839ee61b42', '45144440-307f-11ee-af48-fb839ee61b42', 'a18a6cb4-9c4d-11ea-9404-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('2aab82c0-c1b4-11ec-b810-d1ffe210d8b1', '4523fdf0-ab9b-11ec-a872-7595cd01f649', '8089c5be-9c4d-11ea-92d1-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('45247321-ab9b-11ec-a872-7595cd01f649', '4523fdf0-ab9b-11ec-a872-7595cd01f649', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('45249a30-ab9b-11ec-a872-7595cd01f649', '4523fdf0-ab9b-11ec-a872-7595cd01f649', '8089b3ee-9c4d-11ea-92be-0a5bf521835e', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('45249a31-ab9b-11ec-a872-7595cd01f649', '4523fdf0-ab9b-11ec-a872-7595cd01f649', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 8, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('45249a32-ab9b-11ec-a872-7595cd01f649', '4523fdf0-ab9b-11ec-a872-7595cd01f649', '8089a2b4-9c4d-11ea-92aa-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('45249a33-ab9b-11ec-a872-7595cd01f649', '4523fdf0-ab9b-11ec-a872-7595cd01f649', '8089c32a-9c4d-11ea-92ce-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('902a6b30-c992-11ec-885b-c998f5137173', '4523fdf0-ab9b-11ec-a872-7595cd01f649', '84f86af0-be1b-11ec-92b5-d17e9a4e477d', 8, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('47fb65a0-8f69-11ee-ad20-8fcdb1b55b6b', '4575d540-757f-11ed-9c6e-83547301d186', 'a18a4874-9c4d-11ea-93d7-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('47fb65a1-8f69-11ee-ad20-8fcdb1b55b6b', '4575d540-757f-11ed-9c6e-83547301d186', '0f24c2c0-7d4b-11ed-b263-b95e21b5e348', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('47fb65a2-8f69-11ee-ad20-8fcdb1b55b6b', '4575d540-757f-11ed-9c6e-83547301d186', '218671b0-1f05-11ed-b87e-25470f2449dc', 2, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('457c9fb0-c15c-11ec-a2ba-7bb1dc10361f', '457c5190-c15c-11ec-a2ba-7bb1dc10361f', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 20, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('457cc6c0-c15c-11ec-a2ba-7bb1dc10361f', '457c5190-c15c-11ec-a2ba-7bb1dc10361f', '808926cc-9c4d-11ea-9268-0a5bf521835e', 2, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('457cc6c1-c15c-11ec-a2ba-7bb1dc10361f', '457c5190-c15c-11ec-a2ba-7bb1dc10361f', 'e9464450-be20-11ec-a7fa-3529186828e2', 6, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('457cc6c2-c15c-11ec-a2ba-7bb1dc10361f', '457c5190-c15c-11ec-a2ba-7bb1dc10361f', '8089a2b4-9c4d-11ea-92aa-0a5bf521835e', 20, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('47024ae0-307a-11ee-af48-fb839ee61b42', '46c3e250-307a-11ee-af48-fb839ee61b42', 'a18a5b70-9c4d-11ea-93ed-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('470271f0-307a-11ee-af48-fb839ee61b42', '46c3e250-307a-11ee-af48-fb839ee61b42', 'a18a5c1a-9c4d-11ea-93ee-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('473a2240-f6d2-11ec-82ff-e103d8d6432f', '47398600-f6d2-11ec-82ff-e103d8d6432f', '18ab8420-a8b6-11eb-9770-c18e5ed172e8', 1552, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('473a7060-f6d2-11ec-82ff-e103d8d6432f', '47398600-f6d2-11ec-82ff-e103d8d6432f', '84f86af0-be1b-11ec-92b5-d17e9a4e477d', 243, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('473a7061-f6d2-11ec-82ff-e103d8d6432f', '47398600-f6d2-11ec-82ff-e103d8d6432f', '808938ec-9c4d-11ea-927d-0a5bf521835e', 11.88, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('473a7062-f6d2-11ec-82ff-e103d8d6432f', '47398600-f6d2-11ec-82ff-e103d8d6432f', 'e704fed0-a8ea-11eb-a272-274b1324dbc5', 82, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e7329840-f844-11ec-87d3-cf5d212ef325', '47398600-f6d2-11ec-82ff-e103d8d6432f', '61d22480-f840-11ec-a176-d902a1918d35', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e7329841-f844-11ec-87d3-cf5d212ef325', '47398600-f6d2-11ec-82ff-e103d8d6432f', '8089bf42-9c4d-11ea-92ca-0a5bf521835e', 18, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9f3a5870-da73-11ef-8386-672917eaa162', '47d428a0-9317-11ec-bdf2-dbb798a33559', 'cab47370-9316-11ec-bdf2-dbb798a33559', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9f3a7f81-da73-11ef-8386-672917eaa162', '47d428a0-9317-11ec-bdf2-dbb798a33559', '80893496-9c4d-11ea-9278-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9f3a7f82-da73-11ef-8386-672917eaa162', '47d428a0-9317-11ec-bdf2-dbb798a33559', '80892c12-9c4d-11ea-926e-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9f3a7f83-da73-11ef-8386-672917eaa162', '47d428a0-9317-11ec-bdf2-dbb798a33559', '808933c4-9c4d-11ea-9277-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9f3a7f85-da73-11ef-8386-672917eaa162', '47d428a0-9317-11ec-bdf2-dbb798a33559', '808970d2-9c4d-11ea-928e-0a5bf521835e', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('48cb7700-f6da-11ec-87d3-cf5d212ef325', '48cadac0-f6da-11ec-87d3-cf5d212ef325', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('48cb7701-f6da-11ec-87d3-cf5d212ef325', '48cadac0-f6da-11ec-87d3-cf5d212ef325', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('48cb9e10-f6da-11ec-87d3-cf5d212ef325', '48cadac0-f6da-11ec-87d3-cf5d212ef325', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('48cb9e11-f6da-11ec-87d3-cf5d212ef325', '48cadac0-f6da-11ec-87d3-cf5d212ef325', '8089b4ca-9c4d-11ea-92bf-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('48cb9e12-f6da-11ec-87d3-cf5d212ef325', '48cadac0-f6da-11ec-87d3-cf5d212ef325', '8089b312-9c4d-11ea-92bd-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('48cb9e13-f6da-11ec-87d3-cf5d212ef325', '48cadac0-f6da-11ec-87d3-cf5d212ef325', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('48cb9e14-f6da-11ec-87d3-cf5d212ef325', '48cadac0-f6da-11ec-87d3-cf5d212ef325', 'a18a2f6a-9c4d-11ea-93b2-0a5bf521835e', 170, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('48cb9e15-f6da-11ec-87d3-cf5d212ef325', '48cadac0-f6da-11ec-87d3-cf5d212ef325', '8089c406-9c4d-11ea-92cf-0a5bf521835e', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('48cb9e16-f6da-11ec-87d3-cf5d212ef325', '48cadac0-f6da-11ec-87d3-cf5d212ef325', '8089cc80-9c4d-11ea-92d9-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('48cb9e17-f6da-11ec-87d3-cf5d212ef325', '48cadac0-f6da-11ec-87d3-cf5d212ef325', '47398600-f6d2-11ec-82ff-e103d8d6432f', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('48cbc520-f6da-11ec-87d3-cf5d212ef325', '48cadac0-f6da-11ec-87d3-cf5d212ef325', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 90, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('492729e0-307e-11ee-af48-fb839ee61b42', '48ebf5a0-307e-11ee-af48-fb839ee61b42', '3724da00-e321-11eb-b993-552ff2e9d866', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('492729e1-307e-11ee-af48-fb839ee61b42', '48ebf5a0-307e-11ee-af48-fb839ee61b42', '4f22aab0-e321-11eb-8237-736a902b6e66', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('4a5425e0-8f6d-11ee-a916-51fa99cb2a20', '4a536290-8f6d-11ee-a916-51fa99cb2a20', '8f221700-4d81-11ee-9848-af14af9a4362', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('4ab7bf00-3d99-11ed-bc30-e32dbbc99e9f', '4ab6ad90-3d99-11ed-bc30-e32dbbc99e9f', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 4, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('4ab7bf01-3d99-11ed-bc30-e32dbbc99e9f', '4ab6ad90-3d99-11ed-bc30-e32dbbc99e9f', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('4ab7e610-3d99-11ed-bc30-e32dbbc99e9f', '4ab6ad90-3d99-11ed-bc30-e32dbbc99e9f', '08727600-be21-11ec-bc2e-4d33dd81b98a', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('4ab7e611-3d99-11ed-bc30-e32dbbc99e9f', '4ab6ad90-3d99-11ed-bc30-e32dbbc99e9f', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 17.5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('4ab7e612-3d99-11ed-bc30-e32dbbc99e9f', '4ab6ad90-3d99-11ed-bc30-e32dbbc99e9f', '80899c4c-9c4d-11ea-92a3-0a5bf521835e', 3.5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('4b7f6730-307d-11ee-af48-fb839ee61b42', '4b5d6040-307d-11ee-af48-fb839ee61b42', '8089a390-9c4d-11ea-92ab-0a5bf521835e', 1, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('4bb786d0-3080-11ee-af48-fb839ee61b42', '4b91fd70-3080-11ee-af48-fb839ee61b42', 'a18aaf4e-9c4d-11ea-9452-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('4bb786d1-3080-11ee-af48-fb839ee61b42', '4b91fd70-3080-11ee-af48-fb839ee61b42', 'a18ab142-9c4d-11ea-9453-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('4c8d3a70-308d-11ee-af48-fb839ee61b42', '4c525450-308d-11ee-af48-fb839ee61b42', 'a18a51f2-9c4d-11ea-93e5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('4c8d3a71-308d-11ee-af48-fb839ee61b42', '4c525450-308d-11ee-af48-fb839ee61b42', 'a18a52a6-9c4d-11ea-93e6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('4c8a4ab0-3081-11ee-af48-fb839ee61b42', '4c620230-3081-11ee-af48-fb839ee61b42', '202590d0-be1b-11ec-9222-db267923b89e', 2, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('81138d40-4bda-11ee-aa89-f30425481ee6', '4d132c80-4bda-11ee-b9c8-7dced45403b1', 'da05ca10-ab96-11ed-9bd5-bfc79caa022b', 1000, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ea296c40-68fa-11ee-bf56-ffd73309e818', '4e4227a0-53d2-11ee-ad93-4d410949057c', '8089d0a4-9c4d-11ea-92de-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('ea29ba60-68fa-11ee-bf56-ffd73309e818', '4e4227a0-53d2-11ee-ad93-4d410949057c', '54953940-53d1-11ee-98c2-6770c73d7d3c', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('4f231fe0-e321-11eb-8237-736a902b6e66', '4f22aab0-e321-11eb-8237-736a902b6e66', '5fd18ab0-bedd-11eb-b72d-730bbd0b1638', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('4f231fe1-e321-11eb-8237-736a902b6e66', '4f22aab0-e321-11eb-8237-736a902b6e66', 'a18a32bc-9c4d-11ea-93b7-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('4f2346f0-e321-11eb-8237-736a902b6e66', '4f22aab0-e321-11eb-8237-736a902b6e66', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('4fb5a490-3082-11ee-af48-fb839ee61b42', '4f8c2390-3082-11ee-af48-fb839ee61b42', '07b0e2e0-ee1c-11eb-8cf4-3f10540222ef', 10, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('51084a00-3087-11ee-af48-fb839ee61b42', '50e1d640-3087-11ee-af48-fb839ee61b42', 'e788cc3e-19ec-11eb-a474-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('5364a600-3086-11ee-af48-fb839ee61b42', '533d6ef0-3086-11ee-af48-fb839ee61b42', '7a30c080-d1f9-11ec-b363-f7982c6efb86', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d45ffce0-5945-11ee-ac37-7ba082cf6722', '54953940-53d1-11ee-98c2-6770c73d7d3c', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d45ffce1-5945-11ee-ac37-7ba082cf6722', '54953940-53d1-11ee-98c2-6770c73d7d3c', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d46023f0-5945-11ee-ac37-7ba082cf6722', '54953940-53d1-11ee-98c2-6770c73d7d3c', '80893d1a-9c4d-11ea-9282-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d46023f1-5945-11ee-ac37-7ba082cf6722', '54953940-53d1-11ee-98c2-6770c73d7d3c', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 20, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d46023f2-5945-11ee-ac37-7ba082cf6722', '54953940-53d1-11ee-98c2-6770c73d7d3c', 'e902d420-2d90-11ec-ac7d-edfd3dbf0302', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d46023f3-5945-11ee-ac37-7ba082cf6722', '54953940-53d1-11ee-98c2-6770c73d7d3c', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d46023f4-5945-11ee-ac37-7ba082cf6722', '54953940-53d1-11ee-98c2-6770c73d7d3c', '80893810-9c4d-11ea-927c-0a5bf521835e', 200, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('54ebdbe0-307e-11ee-af48-fb839ee61b42', '54bf74b0-307e-11ee-af48-fb839ee61b42', '413878b0-d1f7-11ec-94f4-0b63ddc79043', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('54eab2b0-811f-11ed-8419-9d8d34a930fb', '54e9ef60-811f-11ed-8419-9d8d34a930fb', 'f189f420-2853-11ed-8172-37c06f5b9a95', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('5560ef60-307f-11ee-af48-fb839ee61b42', '55239840-307f-11ee-af48-fb839ee61b42', 'a18a54ae-9c4d-11ea-93e9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('55611670-307f-11ee-af48-fb839ee61b42', '55239840-307f-11ee-af48-fb839ee61b42', 'a18a554e-9c4d-11ea-93ea-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('55346b40-3583-11ed-9926-7f25ebd78fb7', '553380e0-3583-11ed-9926-7f25ebd78fb7', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('55346b41-3583-11ed-9926-7f25ebd78fb7', '553380e0-3583-11ed-9926-7f25ebd78fb7', '378429f0-46eb-11ec-939f-314f99801403', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('55346b42-3583-11ed-9926-7f25ebd78fb7', '553380e0-3583-11ed-9926-7f25ebd78fb7', '8089c17c-9c4d-11ea-92cc-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('55346b43-3583-11ed-9926-7f25ebd78fb7', '553380e0-3583-11ed-9926-7f25ebd78fb7', '8089b3ee-9c4d-11ea-92be-0a5bf521835e', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('55346b44-3583-11ed-9926-7f25ebd78fb7', '553380e0-3583-11ed-9926-7f25ebd78fb7', '8089cf00-9c4d-11ea-92dc-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('55349250-3583-11ed-9926-7f25ebd78fb7', '553380e0-3583-11ed-9926-7f25ebd78fb7', '80893d1a-9c4d-11ea-9282-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('55349251-3583-11ed-9926-7f25ebd78fb7', '553380e0-3583-11ed-9926-7f25ebd78fb7', '8089c32a-9c4d-11ea-92ce-0a5bf521835e', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('55349252-3583-11ed-9926-7f25ebd78fb7', '553380e0-3583-11ed-9926-7f25ebd78fb7', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('55349253-3583-11ed-9926-7f25ebd78fb7', '553380e0-3583-11ed-9926-7f25ebd78fb7', 'a18a2d62-9c4d-11ea-93af-0a5bf521835e', 170, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a62f4250-5c1f-11ed-b8aa-dd8357c99d07', '553380e0-3583-11ed-9926-7f25ebd78fb7', 'd0ceb8f0-3583-11ed-9548-ed051dc9e4fe', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('555098e0-f845-11ec-86ff-13fce83436c9', '554fd590-f845-11ec-86ff-13fce83436c9', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('5550bff0-f845-11ec-86ff-13fce83436c9', '554fd590-f845-11ec-86ff-13fce83436c9', '48cadac0-f6da-11ec-87d3-cf5d212ef325', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('55a87050-87b3-11eb-ba42-2d944e66f12b', '55a7ad00-87b3-11eb-ba42-2d944e66f12b', 'a18a29b6-9c4d-11ea-93aa-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('57809d40-308e-11ee-af48-fb839ee61b42', '574c6de0-308e-11ee-af48-fb839ee61b42', 'a18a81ae-9c4d-11ea-9415-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('57809d41-308e-11ee-af48-fb839ee61b42', '574c6de0-308e-11ee-af48-fb839ee61b42', 'a18a8258-9c4d-11ea-9416-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('57b223a0-3085-11ee-af48-fb839ee61b42', '578a7760-3085-11ee-af48-fb839ee61b42', 'ebbcfde0-ef91-11eb-bbe5-ef0537d994fa', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('58639a50-307a-11ee-af48-fb839ee61b42', '58400cc0-307a-11ee-af48-fb839ee61b42', 'a18acdee-9c4d-11ea-946e-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('58877400-3090-11ee-af48-fb839ee61b42', '585a97a0-3090-11ee-af48-fb839ee61b42', 'ff41d980-c19b-11ec-b810-d1ffe210d8b1', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('58879b10-3090-11ee-af48-fb839ee61b42', '585a97a0-3090-11ee-af48-fb839ee61b42', '74bb7ee0-d5e3-11ec-a670-e7c04af67adb', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('58c44930-3080-11ee-af48-fb839ee61b42', '588bad00-3080-11ee-af48-fb839ee61b42', 'a18a8cbc-9c4d-11ea-9425-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('58c47040-3080-11ee-af48-fb839ee61b42', '588bad00-3080-11ee-af48-fb839ee61b42', 'a18a8d66-9c4d-11ea-9426-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('58b90e80-de44-11ef-9861-a9c1b860eb22', '58b82420-de44-11ef-9861-a9c1b860eb22', '8089cfdc-9c4d-11ea-92dd-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('58b93590-de44-11ef-9861-a9c1b860eb22', '58b82420-de44-11ef-9861-a9c1b860eb22', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('58b93592-de44-11ef-9861-a9c1b860eb22', '58b82420-de44-11ef-9861-a9c1b860eb22', 'a18a43b0-9c4d-11ea-93d0-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('58b93593-de44-11ef-9861-a9c1b860eb22', '58b82420-de44-11ef-9861-a9c1b860eb22', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('58b95ca1-de44-11ef-9861-a9c1b860eb22', '58b82420-de44-11ef-9861-a9c1b860eb22', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('58b95ca3-de44-11ef-9861-a9c1b860eb22', '58b82420-de44-11ef-9861-a9c1b860eb22', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('58b983b0-de44-11ef-9861-a9c1b860eb22', '58b82420-de44-11ef-9861-a9c1b860eb22', 'a18a2f6a-9c4d-11ea-93b2-0a5bf521835e', 170, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('58b983b2-de44-11ef-9861-a9c1b860eb22', '58b82420-de44-11ef-9861-a9c1b860eb22', 'e9d88d10-b944-11eb-acec-29fb8569cb50', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('58b983b4-de44-11ef-9861-a9c1b860eb22', '58b82420-de44-11ef-9861-a9c1b860eb22', '6b794010-46eb-11ec-bc07-efd394bb365a', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('58b9aac1-de44-11ef-9861-a9c1b860eb22', '58b82420-de44-11ef-9861-a9c1b860eb22', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('58b9aac3-de44-11ef-9861-a9c1b860eb22', '58b82420-de44-11ef-9861-a9c1b860eb22', '15289b50-bba7-11ef-a2da-67539c782629', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('597fa190-308e-11ee-af48-fb839ee61b42', '59589190-308e-11ee-af48-fb839ee61b42', '08fa8280-783f-11eb-ad37-09556bb1f395', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('59e3df00-87d2-11eb-b96f-7177973d12e2', '59e342c0-87d2-11eb-b96f-7177973d12e2', 'a18a26c8-9c4d-11ea-93a9-0a5bf521835e', 300, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('59e3df01-87d2-11eb-b96f-7177973d12e2', '59e342c0-87d2-11eb-b96f-7177973d12e2', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('59e40610-87d2-11eb-b96f-7177973d12e2', '59e342c0-87d2-11eb-b96f-7177973d12e2', '80893d1a-9c4d-11ea-9282-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('5871c8f0-c988-11ec-860d-478ebb9d77b5', '5a322000-c158-11ec-9265-d57037e66861', '8f1cd300-c153-11ec-a2ba-7bb1dc10361f', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('5a33cdb1-c158-11ec-9265-d57037e66861', '5a322000-c158-11ec-9265-d57037e66861', 'ae8f5fb0-c157-11ec-b810-d1ffe210d8b1', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('24a52a90-e53b-11ef-9c1d-e1569f3a4a72', '5a578d00-cf29-11ee-b6de-95c295bfc3e2', '4c217cf0-cf15-11ee-9196-c5c68bf4c631', 5, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('24a551a1-e53b-11ef-9c1d-e1569f3a4a72', '5a578d00-cf29-11ee-b6de-95c295bfc3e2', '8089c5be-9c4d-11ea-92d1-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('24a551a3-e53b-11ef-9c1d-e1569f3a4a72', '5a578d00-cf29-11ee-b6de-95c295bfc3e2', '8089c690-9c4d-11ea-92d2-0a5bf521835e', 9.6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('24a551a5-e53b-11ef-9c1d-e1569f3a4a72', '5a578d00-cf29-11ee-b6de-95c295bfc3e2', '8089b312-9c4d-11ea-92bd-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d7a39730-e88d-11ef-9187-5bc2ac66eb1e', '5b05ba10-cf50-11ef-9028-f1198bb1e3d6', '8089b920-9c4d-11ea-92c4-0a5bf521835e', 220, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d7a39732-e88d-11ef-9187-5bc2ac66eb1e', '5b05ba10-cf50-11ef-9028-f1198bb1e3d6', '80899d1e-9c4d-11ea-92a4-0a5bf521835e', 780, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('5b430c30-307d-11ee-af48-fb839ee61b42', '5b1b38e0-307d-11ee-af48-fb839ee61b42', '59e342c0-87d2-11eb-b96f-7177973d12e2', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5cbe34c8-1a04-11eb-b256-0a5bf521835e', '5cbda90e-1a04-11eb-b255-0a5bf521835e', '8089a462-9c4d-11ea-92ac-0a5bf521835e', 10, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5db957d0-3087-11ee-af48-fb839ee61b42', '5d92e410-3087-11ee-af48-fb839ee61b42', '80893d1a-9c4d-11ea-9282-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('5ec89b20-e88e-11ef-9ae0-e94d7470c07a', '5ec7fee0-e88e-11ef-9ae0-e94d7470c07a', '5b05ba10-cf50-11ef-9028-f1198bb1e3d6', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5ec89b22-e88e-11ef-9ae0-e94d7470c07a', '5ec7fee0-e88e-11ef-9ae0-e94d7470c07a', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('5ec89b24-e88e-11ef-9ae0-e94d7470c07a', '5ec7fee0-e88e-11ef-9ae0-e94d7470c07a', 'a18a43b0-9c4d-11ea-93d0-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5ec89b25-e88e-11ef-9ae0-e94d7470c07a', '5ec7fee0-e88e-11ef-9ae0-e94d7470c07a', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5ec89b27-e88e-11ef-9ae0-e94d7470c07a', '5ec7fee0-e88e-11ef-9ae0-e94d7470c07a', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('5ec8c231-e88e-11ef-9ae0-e94d7470c07a', '5ec7fee0-e88e-11ef-9ae0-e94d7470c07a', 'a18a2cae-9c4d-11ea-93ae-0a5bf521835e', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5ec8c233-e88e-11ef-9ae0-e94d7470c07a', '5ec7fee0-e88e-11ef-9ae0-e94d7470c07a', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('5ec8c235-e88e-11ef-9ae0-e94d7470c07a', '5ec7fee0-e88e-11ef-9ae0-e94d7470c07a', 'a18a2f6a-9c4d-11ea-93b2-0a5bf521835e', 170, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5ec8c237-e88e-11ef-9ae0-e94d7470c07a', '5ec7fee0-e88e-11ef-9ae0-e94d7470c07a', 'e9d88d10-b944-11eb-acec-29fb8569cb50', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('5ec8c239-e88e-11ef-9ae0-e94d7470c07a', '5ec7fee0-e88e-11ef-9ae0-e94d7470c07a', '6b794010-46eb-11ec-bc07-efd394bb365a', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5ec8c23b-e88e-11ef-9ae0-e94d7470c07a', '5ec7fee0-e88e-11ef-9ae0-e94d7470c07a', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5fd226f0-bedd-11eb-b72d-730bbd0b1638', '5fd18ab0-bedd-11eb-b72d-730bbd0b1638', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5fd226f2-bedd-11eb-b72d-730bbd0b1638', '5fd18ab0-bedd-11eb-b72d-730bbd0b1638', '8089c17c-9c4d-11ea-92cc-0a5bf521835e', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5fd226f3-bedd-11eb-b72d-730bbd0b1638', '5fd18ab0-bedd-11eb-b72d-730bbd0b1638', '8089b3ee-9c4d-11ea-92be-0a5bf521835e', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5fd24e00-bedd-11eb-b72d-730bbd0b1638', '5fd18ab0-bedd-11eb-b72d-730bbd0b1638', '80893d1a-9c4d-11ea-9282-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5fd24e01-bedd-11eb-b72d-730bbd0b1638', '5fd18ab0-bedd-11eb-b72d-730bbd0b1638', '8089c780-9c4d-11ea-92d3-0a5bf521835e', 2, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5fd24e02-bedd-11eb-b72d-730bbd0b1638', '5fd18ab0-bedd-11eb-b72d-730bbd0b1638', '8089c32a-9c4d-11ea-92ce-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5fd24e03-bedd-11eb-b72d-730bbd0b1638', '5fd18ab0-bedd-11eb-b72d-730bbd0b1638', '8089a0c0-9c4d-11ea-92a8-0a5bf521835e', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5fd24e04-bedd-11eb-b72d-730bbd0b1638', '5fd18ab0-bedd-11eb-b72d-730bbd0b1638', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('5fd24e05-bedd-11eb-b72d-730bbd0b1638', '5fd18ab0-bedd-11eb-b72d-730bbd0b1638', 'a18a2d62-9c4d-11ea-93af-0a5bf521835e', 250, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('82c14940-5468-11ec-b34b-49e62cc45be8', '5fd18ab0-bedd-11eb-b72d-730bbd0b1638', '378429f0-46eb-11ec-939f-314f99801403', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('5fddca40-bede-11eb-95fb-335b2b14a84d', '5fdd5510-bede-11eb-95fb-335b2b14a84d', '5fd18ab0-bedd-11eb-b72d-730bbd0b1638', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('5fddca41-bede-11eb-95fb-335b2b14a84d', '5fdd5510-bede-11eb-95fb-335b2b14a84d', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('5fddca42-bede-11eb-95fb-335b2b14a84d', '5fdd5510-bede-11eb-95fb-335b2b14a84d', 'a18a3168-9c4d-11ea-93b5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('605551b0-3082-11ee-af48-fb839ee61b42', '6029fbf0-3082-11ee-af48-fb839ee61b42', '076132f0-e3ad-11eb-8237-736a902b6e66', 120, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('607428d0-d1f9-11ec-b363-f7982c6efb86', '60738c90-d1f9-11ec-b363-f7982c6efb86', 'a18acc7c-9c4d-11ea-946c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('60744fe0-d1f9-11ec-b363-f7982c6efb86', '60738c90-d1f9-11ec-b363-f7982c6efb86', 'ba102e80-d1f8-11ec-b363-f7982c6efb86', 24, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('6194e9d0-d1f3-11ec-b363-f7982c6efb86', '61942680-d1f3-11ec-b363-f7982c6efb86', 'a18a47ca-9c4d-11ea-93d6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6194e9d1-d1f3-11ec-b363-f7982c6efb86', '61942680-d1f3-11ec-b363-f7982c6efb86', 'fcf1fa20-d1c2-11ec-88bd-5b29d81a78b4', 400, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6194e9d2-d1f3-11ec-b363-f7982c6efb86', '61942680-d1f3-11ec-b363-f7982c6efb86', '8089bd76-9c4d-11ea-92c9-0a5bf521835e', 30, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('61c62e80-307c-11ee-af48-fb839ee61b42', '61a0f340-307c-11ee-af48-fb839ee61b42', '0b64ad20-e54a-11eb-b993-552ff2e9d866', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d6d7a1b0-21d2-11f0-8e38-472558b3b72f', '61b0d79e-1a02-11eb-8e96-0a5bf521835e', 'a18a491e-9c4d-11ea-93d8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d6d7a1b2-21d2-11f0-8e38-472558b3b72f', '61b0d79e-1a02-11eb-8e96-0a5bf521835e', '96ef61c0-916f-11eb-9d41-2dd57a3d8f5e', 2, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d6d7c8c0-21d2-11f0-8e38-472558b3b72f', '61b0d79e-1a02-11eb-8e96-0a5bf521835e', '808931ee-9c4d-11ea-9275-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('622510b0-38d1-11ed-88aa-d327dbab6e49', '62236300-38d1-11ed-88aa-d327dbab6e49', '6957aad0-f4f5-11eb-a95c-45ac352893ba', 55, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b742bdb0-4617-11ed-b8df-c363575b0859', '62236300-38d1-11ed-88aa-d327dbab6e49', '3c859810-3a7b-11ed-9f9b-fb5c16910c99', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('623aaaf0-c44d-11eb-933b-0fde1972ba99', '62352cb0-c44d-11eb-933b-0fde1972ba99', 'a18a47ca-9c4d-11ea-93d6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('623aaaf1-c44d-11eb-933b-0fde1972ba99', '62352cb0-c44d-11eb-933b-0fde1972ba99', '8089a7fa-9c4d-11ea-92b0-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('623ad200-c44d-11eb-933b-0fde1972ba99', '62352cb0-c44d-11eb-933b-0fde1972ba99', '2dbdce80-8805-11eb-b96f-7177973d12e2', 16, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('635a3320-f6d7-11ec-82ff-e103d8d6432f', '63596fd0-f6d7-11ec-82ff-e103d8d6432f', 'fda50190-f6d1-11ec-87d3-cf5d212ef325', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('635a5a30-f6d7-11ec-82ff-e103d8d6432f', '63596fd0-f6d7-11ec-82ff-e103d8d6432f', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('649ebb30-3082-11ee-af48-fb839ee61b42', '64644a40-3082-11ee-af48-fb839ee61b42', 'a18a5e2c-9c4d-11ea-93f1-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('649ebb31-3082-11ee-af48-fb839ee61b42', '64644a40-3082-11ee-af48-fb839ee61b42', 'a18a5ed6-9c4d-11ea-93f2-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('67c09170-307e-11ee-af48-fb839ee61b42', '6793b510-307e-11ee-af48-fb839ee61b42', '43fa2710-edf5-11eb-8cf4-3f10540222ef', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('67ebefe0-7581-11ed-9ceb-4384b0d4acc1', '67eb2c90-7581-11ed-9ceb-4384b0d4acc1', 'f8c2c2a0-d694-11ec-9aab-3f3b95fb7b18', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('67eddd30-811d-11ed-b263-b95e21b5e348', '67ed40f0-811d-11ed-b263-b95e21b5e348', 'ba0d5480-6686-11ed-a031-8b54f9890809', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('5203ce50-fe73-11ef-a0fa-d156085a72c6', '6a121b90-1d9c-11ef-8e49-3f4681dd1e3c', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('5203f560-fe73-11ef-a0fa-d156085a72c6', '6a121b90-1d9c-11ef-8e49-3f4681dd1e3c', '0e9eb340-1d9c-11ef-994d-0be528309243', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('5203f562-fe73-11ef-a0fa-d156085a72c6', '6a121b90-1d9c-11ef-8e49-3f4681dd1e3c', 'a18a89c4-9c4d-11ea-9421-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('6b5d4790-307b-11ee-af48-fb839ee61b42', '6b2ebd80-307b-11ee-af48-fb839ee61b42', 'a18aade6-9c4d-11ea-9450-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('6b5d6ea0-307b-11ee-af48-fb839ee61b42', '6b2ebd80-307b-11ee-af48-fb839ee61b42', 'a18aae9a-9c4d-11ea-9451-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6b79b540-46eb-11ec-bc07-efd394bb365a', '6b794010-46eb-11ec-bc07-efd394bb365a', '8089c406-9c4d-11ea-92cf-0a5bf521835e', 1080, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('6bb0b530-d5c1-11ec-8b7a-0f22ec019de6', '6bb018f0-d5c1-11ec-8b7a-0f22ec019de6', 'f6becfa0-c98b-11ec-885b-c998f5137173', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('6bb0dc40-d5c1-11ec-8b7a-0f22ec019de6', '6bb018f0-d5c1-11ec-8b7a-0f22ec019de6', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('6c185f90-308e-11ee-af48-fb839ee61b42', '6bd981d0-308e-11ee-af48-fb839ee61b42', 'a18a8fa0-9c4d-11ea-9429-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('6c185f91-308e-11ee-af48-fb839ee61b42', '6bd981d0-308e-11ee-af48-fb839ee61b42', 'a18a904a-9c4d-11ea-942a-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('bff46580-5796-11ee-8a35-b9ff8bb74ead', '6c33fb20-4821-11ed-a241-9d0cf2de716e', '02b03e40-35b9-11ed-b203-11e5174470d0', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('bff46581-5796-11ee-8a35-b9ff8bb74ead', '6c33fb20-4821-11ed-a241-9d0cf2de716e', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6d018310-952c-11ef-afc3-13d48984d813', '6cfb1a70-952c-11ef-afc3-13d48984d813', '8089d838-9c4d-11ea-92e5-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6d018311-952c-11ef-afc3-13d48984d813', '6cfb1a70-952c-11ef-afc3-13d48984d813', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6d024660-952c-11ef-afc3-13d48984d813', '6cfb1a70-952c-11ef-afc3-13d48984d813', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('6d024661-952c-11ef-afc3-13d48984d813', '6cfb1a70-952c-11ef-afc3-13d48984d813', 'e760b460-4790-11ec-939f-314f99801403', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6d024662-952c-11ef-afc3-13d48984d813', '6cfb1a70-952c-11ef-afc3-13d48984d813', '80899ef4-9c4d-11ea-92a6-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('6d334fb0-e320-11eb-b993-552ff2e9d866', '6d32b370-e320-11eb-b993-552ff2e9d866', 'a18a3212-9c4d-11ea-93b6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('f57265d0-479f-11ec-919a-17e2ac44051f', '6d32b370-e320-11eb-b993-552ff2e9d866', '009727f0-bee0-11eb-95fb-335b2b14a84d', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('6e155b50-307e-11ee-af48-fb839ee61b42', '6def0ea0-307e-11ee-af48-fb839ee61b42', 'a18ad6f4-9c4d-11ea-9478-0a5bf521835e', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('6e6b6e60-a827-11ef-b50d-0d342dc0c076', '6e6aab10-a827-11ef-b50d-0d342dc0c076', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6e6b9570-a827-11ef-b50d-0d342dc0c076', '6e6aab10-a827-11ef-b50d-0d342dc0c076', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('6e6b9572-a827-11ef-b50d-0d342dc0c076', '6e6aab10-a827-11ef-b50d-0d342dc0c076', 'a18a7f06-9c4d-11ea-9411-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('6e6bbc80-a827-11ef-b50d-0d342dc0c076', '6e6aab10-a827-11ef-b50d-0d342dc0c076', 'a18aa8fa-9c4d-11ea-9449-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6e6bbc82-a827-11ef-b50d-0d342dc0c076', '6e6aab10-a827-11ef-b50d-0d342dc0c076', '80899ef4-9c4d-11ea-92a6-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('683394c0-00ef-11f0-bc1c-a97e1b7628be', '6ed90490-b1fa-11ed-8398-4d566f64bec9', '11608c10-bdf2-11ef-ba0c-d9e4e2a63cd3', 17, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6833e2e0-00ef-11f0-bc1c-a97e1b7628be', '6ed90490-b1fa-11ed-8398-4d566f64bec9', '89c0dd60-00ee-11f0-9d98-b7ea8c718efe', 80, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('683409f0-00ef-11f0-bc1c-a97e1b7628be', '6ed90490-b1fa-11ed-8398-4d566f64bec9', '80893b6c-9c4d-11ea-9280-0a5bf521835e', 3, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('6f93b8c0-3090-11ee-af48-fb839ee61b42', '6f6f40d0-3090-11ee-af48-fb839ee61b42', 'a18acc7c-9c4d-11ea-946c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6ffa46f0-3089-11ee-af48-fb839ee61b42', '6fd5a7f0-3089-11ee-af48-fb839ee61b42', 'f37315a0-e542-11eb-8237-736a902b6e66', 2, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6ffa6e01-3089-11ee-af48-fb839ee61b42', '6fd5a7f0-3089-11ee-af48-fb839ee61b42', '8089297e-9c4d-11ea-926b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6ffa6e02-3089-11ee-af48-fb839ee61b42', '6fd5a7f0-3089-11ee-af48-fb839ee61b42', '80892a5a-9c4d-11ea-926c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('7087eeb0-308e-11ee-af48-fb839ee61b42', '70606980-308e-11ee-af48-fb839ee61b42', '89c8f070-72b0-11eb-a732-3588446adb69', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ab5e9210-1146-11f0-a1dc-b377ced4a126', '72d41420-e53a-11ef-ad07-115a9609c7c9', '80892032-9c4d-11ea-9260-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ab5e9211-1146-11f0-a1dc-b377ced4a126', '72d41420-e53a-11ef-ad07-115a9609c7c9', '0b4a7e70-e53a-11ef-ae90-c77ba71d6e00', 300, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ab5e9213-1146-11f0-a1dc-b377ced4a126', '72d41420-e53a-11ef-ad07-115a9609c7c9', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 20, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ab5e9215-1146-11f0-a1dc-b377ced4a126', '72d41420-e53a-11ef-ad07-115a9609c7c9', '808931ee-9c4d-11ea-9275-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('73cd1bb0-de4b-11ef-b1c9-b184c04c9ff1', '73cbbc20-de4b-11ef-b1c9-b184c04c9ff1', '8089bc9a-9c4d-11ea-92c8-0a5bf521835e', 35, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('74bc1b20-d5e3-11ec-a670-e7c04af67adb', '74bb7ee0-d5e3-11ec-a670-e7c04af67adb', '77bbb370-d5cb-11ec-a670-e7c04af67adb', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('74bc1b21-d5e3-11ec-a670-e7c04af67adb', '74bb7ee0-d5e3-11ec-a670-e7c04af67adb', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('74bc1b22-d5e3-11ec-a670-e7c04af67adb', '74bb7ee0-d5e3-11ec-a670-e7c04af67adb', '202590d0-be1b-11ec-9222-db267923b89e', 5, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('750624d0-3083-11ee-af48-fb839ee61b42', '74d26aa0-3083-11ee-af48-fb839ee61b42', 'b1346b10-9deb-11eb-8c37-bb20979b8c2f', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('75064be0-3083-11ee-af48-fb839ee61b42', '74d26aa0-3083-11ee-af48-fb839ee61b42', 'ad204cf0-9dec-11eb-8c37-bb20979b8c2f', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('75ae8b10-3089-11ee-af48-fb839ee61b42', '758be7e0-3089-11ee-af48-fb839ee61b42', '001f3140-ef92-11eb-bbe5-ef0537d994fa', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('767f72d0-308d-11ee-af48-fb839ee61b42', '764b4370-308d-11ee-af48-fb839ee61b42', 'a18a805a-9c4d-11ea-9413-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('767f99e0-308d-11ee-af48-fb839ee61b42', '764b4370-308d-11ee-af48-fb839ee61b42', 'a18a8104-9c4d-11ea-9414-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('771f1df0-307c-11ee-af48-fb839ee61b42', '76f94670-307c-11ee-af48-fb839ee61b42', '2ce78f84-1a03-11eb-9cb1-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('77d39bb0-308e-11ee-af48-fb839ee61b42', '779c3800-308e-11ee-af48-fb839ee61b42', 'b24ad9b0-c15a-11ec-b810-d1ffe210d8b1', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('77d3c2c0-308e-11ee-af48-fb839ee61b42', '779c3800-308e-11ee-af48-fb839ee61b42', 'c0b383b0-d5c0-11ec-8b7a-0f22ec019de6', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('77bc4fb0-d5cb-11ec-a670-e7c04af67adb', '77bbb370-d5cb-11ec-a670-e7c04af67adb', '80892032-9c4d-11ea-9260-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('77bc76c0-d5cb-11ec-a670-e7c04af67adb', '77bbb370-d5cb-11ec-a670-e7c04af67adb', '4018f880-c19c-11ec-b810-d1ffe210d8b1', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('77bc76c1-d5cb-11ec-a670-e7c04af67adb', '77bbb370-d5cb-11ec-a670-e7c04af67adb', '80892532-9c4d-11ea-9266-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('77bc76c2-d5cb-11ec-a670-e7c04af67adb', '77bbb370-d5cb-11ec-a670-e7c04af67adb', '8089260e-9c4d-11ea-9267-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('77bc76c3-d5cb-11ec-a670-e7c04af67adb', '77bbb370-d5cb-11ec-a670-e7c04af67adb', '808931ee-9c4d-11ea-9275-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('86e76750-4bda-11ee-a133-513b0bc2e397', '77d9cbe0-4bda-11ee-a133-513b0bc2e397', '4d132c80-4bda-11ee-b9c8-7dced45403b1', 150, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('86e76751-4bda-11ee-a133-513b0bc2e397', '77d9cbe0-4bda-11ee-a133-513b0bc2e397', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 3, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('84ea4d40-84a6-11ef-8ef8-37c5596a9593', '784d06a0-8487-11ef-8ef8-37c5596a9593', '8089c0aa-9c4d-11ea-92cb-0a5bf521835e', 1700, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('84ea4d41-84a6-11ef-8ef8-37c5596a9593', '784d06a0-8487-11ef-8ef8-37c5596a9593', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('84ea7450-84a6-11ef-8ef8-37c5596a9593', '784d06a0-8487-11ef-8ef8-37c5596a9593', '80899b48-9c4d-11ea-92a2-0a5bf521835e', 680, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('84ea7451-84a6-11ef-8ef8-37c5596a9593', '784d06a0-8487-11ef-8ef8-37c5596a9593', '8089d522-9c4d-11ea-92e3-0a5bf521835e', 340, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('84ea7452-84a6-11ef-8ef8-37c5596a9593', '784d06a0-8487-11ef-8ef8-37c5596a9593', '8089b772-9c4d-11ea-92c2-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('84ea7453-84a6-11ef-8ef8-37c5596a9593', '784d06a0-8487-11ef-8ef8-37c5596a9593', '8089cc80-9c4d-11ea-92d9-0a5bf521835e', 1550, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('788ea8b0-e88e-11ef-9187-5bc2ac66eb1e', '788dbe50-e88e-11ef-9187-5bc2ac66eb1e', '5b05ba10-cf50-11ef-9028-f1198bb1e3d6', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('788ecfc1-e88e-11ef-9187-5bc2ac66eb1e', '788dbe50-e88e-11ef-9187-5bc2ac66eb1e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('788ecfc3-e88e-11ef-9187-5bc2ac66eb1e', '788dbe50-e88e-11ef-9187-5bc2ac66eb1e', 'a18a43b0-9c4d-11ea-93d0-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('788ecfc4-e88e-11ef-9187-5bc2ac66eb1e', '788dbe50-e88e-11ef-9187-5bc2ac66eb1e', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('788f9310-e88e-11ef-9187-5bc2ac66eb1e', '788dbe50-e88e-11ef-9187-5bc2ac66eb1e', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('788f9312-e88e-11ef-9187-5bc2ac66eb1e', '788dbe50-e88e-11ef-9187-5bc2ac66eb1e', '8089cfdc-9c4d-11ea-92dd-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('788f9314-e88e-11ef-9187-5bc2ac66eb1e', '788dbe50-e88e-11ef-9187-5bc2ac66eb1e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('788f9316-e88e-11ef-9187-5bc2ac66eb1e', '788dbe50-e88e-11ef-9187-5bc2ac66eb1e', 'a18a2f6a-9c4d-11ea-93b2-0a5bf521835e', 170, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('788f9318-e88e-11ef-9187-5bc2ac66eb1e', '788dbe50-e88e-11ef-9187-5bc2ac66eb1e', 'e9d88d10-b944-11eb-acec-29fb8569cb50', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('788fba21-e88e-11ef-9187-5bc2ac66eb1e', '788dbe50-e88e-11ef-9187-5bc2ac66eb1e', '6b794010-46eb-11ec-bc07-efd394bb365a', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('788fba23-e88e-11ef-9187-5bc2ac66eb1e', '788dbe50-e88e-11ef-9187-5bc2ac66eb1e', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('792687da-19d9-11eb-bd62-0a5bf521835e', '7925f31a-19d9-11eb-bd61-0a5bf521835e', '8089b3ee-9c4d-11ea-92be-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('7a125a60-3089-11ee-af48-fb839ee61b42', '79ecf810-3089-11ee-af48-fb839ee61b42', '16025d90-e545-11eb-b993-552ff2e9d866', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('7a125a61-3089-11ee-af48-fb839ee61b42', '79ecf810-3089-11ee-af48-fb839ee61b42', '7c32a4d0-e545-11eb-b993-552ff2e9d866', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7a3183d0-d1f9-11ec-b363-f7982c6efb86', '7a30c080-d1f9-11ec-b363-f7982c6efb86', 'ba102e80-d1f8-11ec-b363-f7982c6efb86', 30, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7a3183d1-d1f9-11ec-b363-f7982c6efb86', '7a30c080-d1f9-11ec-b363-f7982c6efb86', 'fcf1fa20-d1c2-11ec-88bd-5b29d81a78b4', 400, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('7a3183d2-d1f9-11ec-b363-f7982c6efb86', '7a30c080-d1f9-11ec-b363-f7982c6efb86', 'a18a47ca-9c4d-11ea-93d6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('7a61ac80-3081-11ee-af48-fb839ee61b42', '7a3c2320-3081-11ee-af48-fb839ee61b42', '00398690-e54b-11eb-b993-552ff2e9d866', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('7b50aaf0-3082-11ee-af48-fb839ee61b42', '7b268db0-3082-11ee-af48-fb839ee61b42', 'a18acf56-9c4d-11ea-9470-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7b50d201-3082-11ee-af48-fb839ee61b42', '7b268db0-3082-11ee-af48-fb839ee61b42', '808981d0-9c4d-11ea-929e-0a5bf521835e', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7c331a00-e545-11eb-b993-552ff2e9d866', '7c32a4d0-e545-11eb-b993-552ff2e9d866', '8089751e-9c4d-11ea-9293-0a5bf521835e', 14, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7c334110-e545-11eb-b993-552ff2e9d866', '7c32a4d0-e545-11eb-b993-552ff2e9d866', '8089b844-9c4d-11ea-92c3-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7c334111-e545-11eb-b993-552ff2e9d866', '7c32a4d0-e545-11eb-b993-552ff2e9d866', '15854ed0-6bb6-11eb-80f6-73940ffe6b4a', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7c334112-e545-11eb-b993-552ff2e9d866', '7c32a4d0-e545-11eb-b993-552ff2e9d866', '6289ccb0-6bb6-11eb-aac1-2355e6ce6dd2', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7d219d60-fb04-11ee-a4a8-777d36a25868', '7d1f5370-fb04-11ee-a4a8-777d36a25868', 'd627b890-d864-11ed-89d3-cf05f605d483', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b6cb0a70-b8d5-11f0-8031-052614611c52', '7de3eb70-b1fb-11ed-a45c-5f2ed7b3184f', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b6cb0a71-b8d5-11f0-8031-052614611c52', '7de3eb70-b1fb-11ed-a45c-5f2ed7b3184f', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b6cb0a73-b8d5-11f0-8031-052614611c52', '7de3eb70-b1fb-11ed-a45c-5f2ed7b3184f', 'f0f73b30-b8d3-11f0-8023-f50462a02790', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b6cb0a75-b8d5-11f0-8031-052614611c52', '7de3eb70-b1fb-11ed-a45c-5f2ed7b3184f', '80893d1a-9c4d-11ea-9282-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b6cba6b0-b8d5-11f0-8031-052614611c52', '7de3eb70-b1fb-11ed-a45c-5f2ed7b3184f', 'a18a26c8-9c4d-11ea-93a9-0a5bf521835e', 300, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b6cba6b2-b8d5-11f0-8031-052614611c52', '7de3eb70-b1fb-11ed-a45c-5f2ed7b3184f', '374bc7e0-f306-11ed-b0fa-47c95be3e3ca', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b6cba6b4-b8d5-11f0-8031-052614611c52', '7de3eb70-b1fb-11ed-a45c-5f2ed7b3184f', '6ed90490-b1fa-11ed-8398-4d566f64bec9', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('93408f30-1146-11f0-a1dc-b377ced4a126', '7dfe9fa0-e553-11ef-8b3c-2dedf456f4e7', '0b4a7e70-e53a-11ef-ae90-c77ba71d6e00', 120, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('93408f31-1146-11f0-a1dc-b377ced4a126', '7dfe9fa0-e553-11ef-8b3c-2dedf456f4e7', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7f2069c0-9784-11eb-819d-97a3d64b2bfa', '7f1f7f60-9784-11eb-819d-97a3d64b2bfa', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7f2069c1-9784-11eb-819d-97a3d64b2bfa', '7f1f7f60-9784-11eb-819d-97a3d64b2bfa', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7f2069c2-9784-11eb-819d-97a3d64b2bfa', '7f1f7f60-9784-11eb-819d-97a3d64b2bfa', '80899d1e-9c4d-11ea-92a4-0a5bf521835e', 200, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7f2069c3-9784-11eb-819d-97a3d64b2bfa', '7f1f7f60-9784-11eb-819d-97a3d64b2bfa', '8089d838-9c4d-11ea-92e5-0a5bf521835e', 140, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d0749a30-5467-11ec-a8c2-03e92580e6a1', '7f1f7f60-9784-11eb-819d-97a3d64b2bfa', 'e760b460-4790-11ec-939f-314f99801403', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('80977cb0-3081-11ee-af48-fb839ee61b42', '806437b0-3081-11ee-af48-fb839ee61b42', 'a18a8866-9c4d-11ea-941f-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8097a3c0-3081-11ee-af48-fb839ee61b42', '806437b0-3081-11ee-af48-fb839ee61b42', 'a18a8910-9c4d-11ea-9420-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8069d9b0-9784-11eb-819d-97a3d64b2bfa', '80693d70-9784-11eb-819d-97a3d64b2bfa', '8089d838-9c4d-11ea-92e5-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8069d9b1-9784-11eb-819d-97a3d64b2bfa', '80693d70-9784-11eb-819d-97a3d64b2bfa', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8069d9b2-9784-11eb-819d-97a3d64b2bfa', '80693d70-9784-11eb-819d-97a3d64b2bfa', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8069d9b3-9784-11eb-819d-97a3d64b2bfa', '80693d70-9784-11eb-819d-97a3d64b2bfa', '80899d1e-9c4d-11ea-92a4-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('f63de960-5467-11ec-a8c2-03e92580e6a1', '80693d70-9784-11eb-819d-97a3d64b2bfa', 'e760b460-4790-11ec-939f-314f99801403', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('80e73ca0-307c-11ee-af48-fb839ee61b42', '80ac2f70-307c-11ee-af48-fb839ee61b42', 'aaae78d0-c153-11ec-b810-d1ffe210d8b1', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('80e73ca1-307c-11ee-af48-fb839ee61b42', '80ac2f70-307c-11ee-af48-fb839ee61b42', '2d25e250-d520-11ec-983e-772482502ae8', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('a14e7020-0833-11ed-b103-871c3047b536', '813c8560-9868-11eb-9abf-858942205919', '0eee652c-abcf-11ea-9ac1-0a5bf521835e', 250, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a14e7021-0833-11ed-b103-871c3047b536', '813c8560-9868-11eb-9abf-858942205919', '80897a3c-9c4d-11ea-9296-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('81c083b0-d520-11ec-9a5d-f575e98074a0', '81befd10-d520-11ec-9a5d-f575e98074a0', 'c8a6e570-c153-11ec-9265-d57037e66861', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('81c083b1-d520-11ec-9a5d-f575e98074a0', '81befd10-d520-11ec-9a5d-f575e98074a0', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('82446100-308f-11ee-af48-fb839ee61b42', '821c66a0-308f-11ee-af48-fb839ee61b42', '9dd760c0-f5d1-11eb-a95c-45ac352893ba', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('f53811e0-e88d-11ef-9ae0-e94d7470c07a', '825d9aa0-e88d-11ef-b713-6d60198332da', '5b05ba10-cf50-11ef-9028-f1198bb1e3d6', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f53838f1-e88d-11ef-9ae0-e94d7470c07a', '825d9aa0-e88d-11ef-b713-6d60198332da', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('f53838f3-e88d-11ef-9ae0-e94d7470c07a', '825d9aa0-e88d-11ef-b713-6d60198332da', 'a18a43b0-9c4d-11ea-93d0-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f5386000-e88d-11ef-9ae0-e94d7470c07a', '825d9aa0-e88d-11ef-b713-6d60198332da', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f5386002-e88d-11ef-9ae0-e94d7470c07a', '825d9aa0-e88d-11ef-b713-6d60198332da', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f5386004-e88d-11ef-9ae0-e94d7470c07a', '825d9aa0-e88d-11ef-b713-6d60198332da', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('f5386006-e88d-11ef-9ae0-e94d7470c07a', '825d9aa0-e88d-11ef-b713-6d60198332da', 'a18a2f6a-9c4d-11ea-93b2-0a5bf521835e', 170, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f5388711-e88d-11ef-9ae0-e94d7470c07a', '825d9aa0-e88d-11ef-b713-6d60198332da', 'e9d88d10-b944-11eb-acec-29fb8569cb50', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('f5388713-e88d-11ef-9ae0-e94d7470c07a', '825d9aa0-e88d-11ef-b713-6d60198332da', '6b794010-46eb-11ec-bc07-efd394bb365a', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f5388715-e88d-11ef-9ae0-e94d7470c07a', '825d9aa0-e88d-11ef-b713-6d60198332da', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('f5388717-e88d-11ef-9ae0-e94d7470c07a', '825d9aa0-e88d-11ef-b713-6d60198332da', 'a18a2b50-9c4d-11ea-93ac-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('82d445cc-1a03-11eb-accc-0a5bf521835e', '82d3e2ee-1a03-11eb-accb-0a5bf521835e', '8089a99e-9c4d-11ea-92b2-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('83a47d50-307b-11ee-af48-fb839ee61b42', '837cd110-307b-11ee-af48-fb839ee61b42', '7925f31a-19d9-11eb-bd61-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('84038c40-3086-11ee-af48-fb839ee61b42', '83dc0710-3086-11ee-af48-fb839ee61b42', '2aad0c00-e31e-11eb-8237-736a902b6e66', 75, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('849ed220-a99e-11eb-a232-bb1b67e0525e', '849e0ed0-a99e-11eb-a232-bb1b67e0525e', '8089c924-9c4d-11ea-92d5-0a5bf521835e', 3, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('849ed221-a99e-11eb-a232-bb1b67e0525e', '849e0ed0-a99e-11eb-a232-bb1b67e0525e', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('849ed222-a99e-11eb-a232-bb1b67e0525e', '849e0ed0-a99e-11eb-a232-bb1b67e0525e', '8089b4ca-9c4d-11ea-92bf-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('849ef930-a99e-11eb-a232-bb1b67e0525e', '849e0ed0-a99e-11eb-a232-bb1b67e0525e', '8089a0c0-9c4d-11ea-92a8-0a5bf521835e', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('849ef931-a99e-11eb-a232-bb1b67e0525e', '849e0ed0-a99e-11eb-a232-bb1b67e0525e', '8089b3ee-9c4d-11ea-92be-0a5bf521835e', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('849ef933-a99e-11eb-a232-bb1b67e0525e', '849e0ed0-a99e-11eb-a232-bb1b67e0525e', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('849ef934-a99e-11eb-a232-bb1b67e0525e', '849e0ed0-a99e-11eb-a232-bb1b67e0525e', 'a18a2d62-9c4d-11ea-93af-0a5bf521835e', 170, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('849ef935-a99e-11eb-a232-bb1b67e0525e', '849e0ed0-a99e-11eb-a232-bb1b67e0525e', '8089c32a-9c4d-11ea-92ce-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('849f2040-a99e-11eb-a232-bb1b67e0525e', '849e0ed0-a99e-11eb-a232-bb1b67e0525e', '8089c17c-9c4d-11ea-92cc-0a5bf521835e', 53, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ba614140-492b-11ec-bc07-efd394bb365a', '849e0ed0-a99e-11eb-a232-bb1b67e0525e', '8089c5be-9c4d-11ea-92d1-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('84f0bf50-d5c0-11ec-9916-a1c1f658f229', '84f02310-d5c0-11ec-9916-a1c1f658f229', '40a50750-c159-11ec-853d-e7960d3897c4', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('84f0bf51-d5c0-11ec-9916-a1c1f658f229', '84f02310-d5c0-11ec-9916-a1c1f658f229', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('0153a6b0-d2ac-11ec-88bd-5b29d81a78b4', '84f86af0-be1b-11ec-92b5-d17e9a4e477d', '808938ec-9c4d-11ea-927d-0a5bf521835e', 54, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('2f0c2da0-f842-11ec-87d3-cf5d212ef325', '84f86af0-be1b-11ec-92b5-d17e9a4e477d', '18ab8420-a8b6-11eb-9770-c18e5ed172e8', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('2f0c2da1-f842-11ec-87d3-cf5d212ef325', '84f86af0-be1b-11ec-92b5-d17e9a4e477d', '61d22480-f840-11ec-a176-d902a1918d35', 0.85, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('2f0c54b0-f842-11ec-87d3-cf5d212ef325', '84f86af0-be1b-11ec-92b5-d17e9a4e477d', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e2b961a0-f843-11ec-a176-d902a1918d35', '84f86af0-be1b-11ec-92b5-d17e9a4e477d', '5ec23a80-f842-11ec-87d3-cf5d212ef325', 30, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('85915830-3086-11ee-af48-fb839ee61b42', '8567d730-3086-11ee-af48-fb839ee61b42', 'a18ac79a-9c4d-11ea-9465-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('85915831-3086-11ee-af48-fb839ee61b42', '8567d730-3086-11ee-af48-fb839ee61b42', 'a18ac84e-9c4d-11ea-9466-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('41abc930-236d-11f0-ac9f-fffdeb0f868f', '85862ad0-9deb-11eb-9fc3-c54eb2b1a2bd', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('41abc931-236d-11f0-ac9f-fffdeb0f868f', '85862ad0-9deb-11eb-9fc3-c54eb2b1a2bd', 'a18a85b4-9c4d-11ea-941b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('41abc933-236d-11f0-ac9f-fffdeb0f868f', '85862ad0-9deb-11eb-9fc3-c54eb2b1a2bd', '8089cc80-9c4d-11ea-92d9-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('85e167d0-811d-11ed-b263-b95e21b5e348', '85e0a480-811d-11ed-b263-b95e21b5e348', 'd971c9b0-6685-11ed-8cf9-1de12f567f43', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('85e98cb0-952c-11ef-b1c9-a52e879704e5', '85e7df00-952c-11ef-b1c9-a52e879704e5', '8089d838-9c4d-11ea-92e5-0a5bf521835e', 140, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('85e98cb1-952c-11ef-b1c9-a52e879704e5', '85e7df00-952c-11ef-b1c9-a52e879704e5', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('85e98cb2-952c-11ef-b1c9-a52e879704e5', '85e7df00-952c-11ef-b1c9-a52e879704e5', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('85e98cb3-952c-11ef-b1c9-a52e879704e5', '85e7df00-952c-11ef-b1c9-a52e879704e5', 'e760b460-4790-11ec-939f-314f99801403', 140, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('85e9b3c0-952c-11ef-b1c9-a52e879704e5', '85e7df00-952c-11ef-b1c9-a52e879704e5', '80899ef4-9c4d-11ea-92a6-0a5bf521835e', 200, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('86722900-308b-11ee-af48-fb839ee61b42', '864d3be0-308b-11ee-af48-fb839ee61b42', '8ce05420-fb75-11ec-82ff-e103d8d6432f', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('77b75970-e486-11ef-aa41-01eb4d41c1d0', '8800beb0-cc0f-11ee-8044-7df45c52b284', 'a18a4716-9c4d-11ea-93d5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('77b75971-e486-11ef-aa41-01eb4d41c1d0', '8800beb0-cc0f-11ee-8044-7df45c52b284', 'cfb73310-9387-11eb-b551-3d9be8d1c5c7', 6, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('77b78081-e486-11ef-aa41-01eb4d41c1d0', '8800beb0-cc0f-11ee-8044-7df45c52b284', '8089cfdc-9c4d-11ea-92dd-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('77b78083-e486-11ef-aa41-01eb4d41c1d0', '8800beb0-cc0f-11ee-8044-7df45c52b284', 'a18a9a72-9c4d-11ea-9434-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('88e381b0-308c-11ee-af48-fb839ee61b42', '88af7960-308c-11ee-af48-fb839ee61b42', '02b03e40-35b9-11ed-b203-11e5174470d0', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('88e3a8c0-308c-11ee-af48-fb839ee61b42', '88af7960-308c-11ee-af48-fb839ee61b42', '6c33fb20-4821-11ed-a241-9d0cf2de716e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('89c965a0-72b0-11eb-a732-3588446adb69', '89c8f070-72b0-11eb-a732-3588446adb69', '67bc3410-72b0-11eb-a732-3588446adb69', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('89c98cb0-72b0-11eb-a732-3588446adb69', '89c8f070-72b0-11eb-a732-3588446adb69', '80891f2e-9c4d-11ea-925f-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8a7482f0-3081-11ee-af48-fb839ee61b42', '8a42c490-3081-11ee-af48-fb839ee61b42', 'e089f680-9ded-11eb-8c37-bb20979b8c2f', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8a7482f1-3081-11ee-af48-fb839ee61b42', '8a42c490-3081-11ee-af48-fb839ee61b42', 'd75a78e0-9dee-11eb-b217-2bde6a29a24e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8ac462b0-2374-11f0-953f-0dfe025424db', '8ac32a30-2374-11f0-953f-0dfe025424db', '6c028cc0-fb73-11ec-87d3-cf5d212ef325', 25, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8af7c910-cf51-11ef-ab41-33862f723ed5', '8af64270-cf51-11ef-ab41-33862f723ed5', '5b05ba10-cf50-11ef-9028-f1198bb1e3d6', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8af7c912-cf51-11ef-ab41-33862f723ed5', '8af64270-cf51-11ef-ab41-33862f723ed5', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8af7c914-cf51-11ef-ab41-33862f723ed5', '8af64270-cf51-11ef-ab41-33862f723ed5', '8089d838-9c4d-11ea-92e5-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8af7c916-cf51-11ef-ab41-33862f723ed5', '8af64270-cf51-11ef-ab41-33862f723ed5', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8af7c917-cf51-11ef-ab41-33862f723ed5', '8af64270-cf51-11ef-ab41-33862f723ed5', '8089c258-9c4d-11ea-92cd-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8af7f021-cf51-11ef-ab41-33862f723ed5', '8af64270-cf51-11ef-ab41-33862f723ed5', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8af7f023-cf51-11ef-ab41-33862f723ed5', '8af64270-cf51-11ef-ab41-33862f723ed5', '8089b920-9c4d-11ea-92c4-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8af7f025-cf51-11ef-ab41-33862f723ed5', '8af64270-cf51-11ef-ab41-33862f723ed5', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8af7f027-cf51-11ef-ab41-33862f723ed5', '8af64270-cf51-11ef-ab41-33862f723ed5', '8089c406-9c4d-11ea-92cf-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8af7f029-cf51-11ef-ab41-33862f723ed5', '8af64270-cf51-11ef-ab41-33862f723ed5', 'a18a26c8-9c4d-11ea-93a9-0a5bf521835e', 300, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8b342870-308c-11ee-af48-fb839ee61b42', '8b0d3f80-308c-11ee-af48-fb839ee61b42', '8d539180-6168-11ec-b4f3-f589907dab6b', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8b8fe75a-1a05-11eb-912e-0a5bf521835e', '8b8f1d2a-1a05-11eb-912d-0a5bf521835e', '8089ab4c-9c4d-11ea-92b4-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8cd21dd0-3088-11ee-af48-fb839ee61b42', '8c249fc0-3088-11ee-af48-fb839ee61b42', '5a322000-c158-11ec-9265-d57037e66861', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8cd21dd1-3088-11ee-af48-fb839ee61b42', '8c249fc0-3088-11ee-af48-fb839ee61b42', 'a72946a0-d5c0-11ec-b2e2-5dd84dabb8a8', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8c6cd7e0-307e-11ee-af48-fb839ee61b42', '8c3685a0-307e-11ee-af48-fb839ee61b42', 'a18a798e-9c4d-11ea-9409-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8c6cd7e1-307e-11ee-af48-fb839ee61b42', '8c3685a0-307e-11ee-af48-fb839ee61b42', 'a18a7a38-9c4d-11ea-940a-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8ce27700-fb75-11ec-82ff-e103d8d6432f', '8ce05420-fb75-11ec-82ff-e103d8d6432f', 'a18acc7c-9c4d-11ea-946c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8ce27701-fb75-11ec-82ff-e103d8d6432f', '8ce05420-fb75-11ec-82ff-e103d8d6432f', '6ee353a0-fb75-11ec-86ff-13fce83436c9', 24, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('f46868a0-68fa-11ee-bf56-ffd73309e818', '8d0c5fa0-53d2-11ee-b332-e9fcffa35d2c', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f4688fb0-68fa-11ee-bf56-ffd73309e818', '8d0c5fa0-53d2-11ee-b332-e9fcffa35d2c', '8089cfdc-9c4d-11ea-92dd-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('f4688fb1-68fa-11ee-bf56-ffd73309e818', '8d0c5fa0-53d2-11ee-b332-e9fcffa35d2c', '54953940-53d1-11ee-98c2-6770c73d7d3c', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8d5406b0-6168-11ec-b4f3-f589907dab6b', '8d539180-6168-11ec-b4f3-f589907dab6b', '6befbf50-6168-11ec-b4f3-f589907dab6b', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9b4cf850-ea2f-11ef-a4bb-cf404e238390', '8e0501b0-ea2f-11ef-b574-a13e4e584bf5', 'a18a466c-9c4d-11ea-93d4-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9b4d1f60-ea2f-11ef-a4bb-cf404e238390', '8e0501b0-ea2f-11ef-b574-a13e4e584bf5', 'cfb73310-9387-11eb-b551-3d9be8d1c5c7', 3, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9b4d1f62-ea2f-11ef-a4bb-cf404e238390', '8e0501b0-ea2f-11ef-b574-a13e4e584bf5', 'a18a2cae-9c4d-11ea-93ae-0a5bf521835e', 55, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9b4d1f64-ea2f-11ef-a4bb-cf404e238390', '8e0501b0-ea2f-11ef-b574-a13e4e584bf5', 'a18a99c8-9c4d-11ea-9433-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8e5e2090-307e-11ee-af48-fb839ee61b42', '8e3059d0-307e-11ee-af48-fb839ee61b42', '320146d0-c994-11ec-a38a-8d13737e0b72', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8e5e2092-307e-11ee-af48-fb839ee61b42', '8e3059d0-307e-11ee-af48-fb839ee61b42', 'a18a4874-9c4d-11ea-93d7-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8e5e2093-307e-11ee-af48-fb839ee61b42', '8e3059d0-307e-11ee-af48-fb839ee61b42', 'a18a491e-9c4d-11ea-93d8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8e1a2110-a828-11ef-bf68-717db67f3dd6', '8e57e2d0-a827-11ef-8e56-e34985f0ea4e', '784d06a0-8487-11ef-8ef8-37c5596a9593', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8e1a2112-a828-11ef-bf68-717db67f3dd6', '8e57e2d0-a827-11ef-8e56-e34985f0ea4e', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8e1a4821-a828-11ef-bf68-717db67f3dd6', '8e57e2d0-a827-11ef-8e56-e34985f0ea4e', 'a18a7f06-9c4d-11ea-9411-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8e1a4823-a828-11ef-bf68-717db67f3dd6', '8e57e2d0-a827-11ef-8e56-e34985f0ea4e', '80899ef4-9c4d-11ea-92a6-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('188e8c50-e88e-11ef-9187-5bc2ac66eb1e', '8e7c7c00-de44-11ef-b2c8-4d73a1025b97', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('188e8c52-e88e-11ef-9187-5bc2ac66eb1e', '8e7c7c00-de44-11ef-b2c8-4d73a1025b97', 'a18a43b0-9c4d-11ea-93d0-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('188e8c53-e88e-11ef-9187-5bc2ac66eb1e', '8e7c7c00-de44-11ef-b2c8-4d73a1025b97', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('188eb361-e88e-11ef-9187-5bc2ac66eb1e', '8e7c7c00-de44-11ef-b2c8-4d73a1025b97', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('188eb363-e88e-11ef-9187-5bc2ac66eb1e', '8e7c7c00-de44-11ef-b2c8-4d73a1025b97', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('188eb365-e88e-11ef-9187-5bc2ac66eb1e', '8e7c7c00-de44-11ef-b2c8-4d73a1025b97', 'a18a2f6a-9c4d-11ea-93b2-0a5bf521835e', 170, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('188eb367-e88e-11ef-9187-5bc2ac66eb1e', '8e7c7c00-de44-11ef-b2c8-4d73a1025b97', 'e9d88d10-b944-11eb-acec-29fb8569cb50', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('188eda70-e88e-11ef-9187-5bc2ac66eb1e', '8e7c7c00-de44-11ef-b2c8-4d73a1025b97', '6b794010-46eb-11ec-bc07-efd394bb365a', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('188eda72-e88e-11ef-9187-5bc2ac66eb1e', '8e7c7c00-de44-11ef-b2c8-4d73a1025b97', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('188eda74-e88e-11ef-9187-5bc2ac66eb1e', '8e7c7c00-de44-11ef-b2c8-4d73a1025b97', '15289b50-bba7-11ef-a2da-67539c782629', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('188eda76-e88e-11ef-9187-5bc2ac66eb1e', '8e7c7c00-de44-11ef-b2c8-4d73a1025b97', 'a18a2b50-9c4d-11ea-93ac-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8e8347e0-d5e8-11ec-b2e2-5dd84dabb8a8', '8e828490-d5e8-11ec-b2e2-5dd84dabb8a8', '4523fdf0-ab9b-11ec-a872-7595cd01f649', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8e8347e1-d5e8-11ec-b2e2-5dd84dabb8a8', '8e828490-d5e8-11ec-b2e2-5dd84dabb8a8', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8f1d4830-c153-11ec-a2ba-7bb1dc10361f', '8f1cd300-c153-11ec-a2ba-7bb1dc10361f', '6e078db0-be2c-11ec-92b5-d17e9a4e477d', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8f1d4831-c153-11ec-a2ba-7bb1dc10361f', '8f1cd300-c153-11ec-a2ba-7bb1dc10361f', '8089c406-9c4d-11ea-92cf-0a5bf521835e', 20, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8f1d4832-c153-11ec-a2ba-7bb1dc10361f', '8f1cd300-c153-11ec-a2ba-7bb1dc10361f', '83dd7550-be2c-11ec-9222-db267923b89e', 40, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8f1d4833-c153-11ec-a2ba-7bb1dc10361f', '8f1cd300-c153-11ec-a2ba-7bb1dc10361f', '0d161320-1baf-11ec-9cd0-53f06f053e40', 20, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8f79a1c8-1a08-11eb-8433-0a5bf521835e', '8f7936fc-1a08-11eb-8432-0a5bf521835e', '808938ec-9c4d-11ea-927d-0a5bf521835e', 150, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('90556410-307b-11ee-af48-fb839ee61b42', '902e5410-307b-11ee-af48-fb839ee61b42', '97d07f20-1f03-11ed-b321-cb89e2c9960f', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('91b230c0-3082-11ee-af48-fb839ee61b42', '91852d50-3082-11ee-af48-fb839ee61b42', 'e9464450-be20-11ec-a7fa-3529186828e2', 3, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('238be7c0-3584-11ed-9926-7f25ebd78fb7', '92834de0-3583-11ed-9926-7f25ebd78fb7', 'd0ceb8f0-3583-11ed-9548-ed051dc9e4fe', 2, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9284d480-3583-11ed-9926-7f25ebd78fb7', '92834de0-3583-11ed-9926-7f25ebd78fb7', '80893112-9c4d-11ea-9274-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9284d481-3583-11ed-9926-7f25ebd78fb7', '92834de0-3583-11ed-9926-7f25ebd78fb7', '808921ea-9c4d-11ea-9262-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9284fb91-3583-11ed-9926-7f25ebd78fb7', '92834de0-3583-11ed-9926-7f25ebd78fb7', '808932c0-9c4d-11ea-9276-0a5bf521835e', 0.5, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9284fb92-3583-11ed-9926-7f25ebd78fb7', '92834de0-3583-11ed-9926-7f25ebd78fb7', '8089212c-9c4d-11ea-9261-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9284fb93-3583-11ed-9926-7f25ebd78fb7', '92834de0-3583-11ed-9926-7f25ebd78fb7', '808931ee-9c4d-11ea-9275-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('18c2bdf0-c982-11ec-a38a-8d13737e0b72', '931ca900-c156-11ec-853d-e7960d3897c4', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('18c2bdf1-c982-11ec-a38a-8d13737e0b72', '931ca900-c156-11ec-853d-e7960d3897c4', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('931d1e30-c156-11ec-853d-e7960d3897c4', '931ca900-c156-11ec-853d-e7960d3897c4', 'a18a60e8-9c4d-11ea-93f5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('931d1e31-c156-11ec-853d-e7960d3897c4', '931ca900-c156-11ec-853d-e7960d3897c4', '8f1cd300-c153-11ec-a2ba-7bb1dc10361f', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('939f1400-307f-11ee-af48-fb839ee61b42', '93798aa0-307f-11ee-af48-fb839ee61b42', 'f6ba4130-ef91-11eb-b539-d109965a1b2f', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('93bde270-3086-11ee-af48-fb839ee61b42', '93887a90-3086-11ee-af48-fb839ee61b42', 'a18a9874-9c4d-11ea-9431-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('93be0980-3086-11ee-af48-fb839ee61b42', '93887a90-3086-11ee-af48-fb839ee61b42', 'a18a991e-9c4d-11ea-9432-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('93f3f220-307c-11ee-af48-fb839ee61b42', '93cf2c10-307c-11ee-af48-fb839ee61b42', '08c02da0-da60-11eb-88cc-6f7cfe428a18', 2, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('941b5480-e1ea-11ee-b192-db3c6a6f33c1', '941a4310-e1ea-11ee-b192-db3c6a6f33c1', '0b9ba290-e1ea-11ee-9824-b524be6ecff3', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9462d932-19ec-11eb-b915-0a5bf521835e', '9461e7ac-19ec-11eb-b914-0a5bf521835e', '8089b4ca-9c4d-11ea-92bf-0a5bf521835e', 20, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8fe31c40-c982-11ec-885b-c998f5137173', '959ac860-c156-11ec-a2ba-7bb1dc10361f', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8fe31c41-c982-11ec-885b-c998f5137173', '959ac860-c156-11ec-a2ba-7bb1dc10361f', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('959b1680-c156-11ec-a2ba-7bb1dc10361f', '959ac860-c156-11ec-a2ba-7bb1dc10361f', 'a18a60e8-9c4d-11ea-93f5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('959b1681-c156-11ec-a2ba-7bb1dc10361f', '959ac860-c156-11ec-a2ba-7bb1dc10361f', '0d161320-1baf-11ec-9cd0-53f06f053e40', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('959b3d90-c156-11ec-a2ba-7bb1dc10361f', '959ac860-c156-11ec-a2ba-7bb1dc10361f', '5409fdc0-be1e-11ec-92b5-d17e9a4e477d', 80, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('95a0a590-9def-11eb-b727-2bf863f3754b', '95a03060-9def-11eb-b727-2bf863f3754b', 'a18a9a72-9c4d-11ea-9434-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('95a0a591-9def-11eb-b727-2bf863f3754b', '95a03060-9def-11eb-b727-2bf863f3754b', 'a18a2b50-9c4d-11ea-93ac-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('97051a00-308d-11ee-af48-fb839ee61b42', '96448920-308d-11ee-af48-fb839ee61b42', 'c8a6e570-c153-11ec-9265-d57037e66861', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('97054110-308d-11ee-af48-fb839ee61b42', '96448920-308d-11ee-af48-fb839ee61b42', '81befd10-d520-11ec-9a5d-f575e98074a0', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('975d8d80-307d-11ee-af48-fb839ee61b42', '9737dd10-307d-11ee-af48-fb839ee61b42', 'a18acd30-9c4d-11ea-946d-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('97797290-3080-11ee-af48-fb839ee61b42', '9744f510-3080-11ee-af48-fb839ee61b42', '95a03060-9def-11eb-b727-2bf863f3754b', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('97797291-3080-11ee-af48-fb839ee61b42', '9744f510-3080-11ee-af48-fb839ee61b42', 'df837110-9def-11eb-b217-2bde6a29a24e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('643929f0-8f69-11ee-ad20-8fcdb1b55b6b', '97d07f20-1f03-11ed-b321-cb89e2c9960f', 'a18a4874-9c4d-11ea-93d7-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('643929f1-8f69-11ee-ad20-8fcdb1b55b6b', '97d07f20-1f03-11ed-b321-cb89e2c9960f', '0f24c2c0-7d4b-11ed-b263-b95e21b5e348', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('643929f2-8f69-11ee-ad20-8fcdb1b55b6b', '97d07f20-1f03-11ed-b321-cb89e2c9960f', '218671b0-1f05-11ed-b87e-25470f2449dc', 2, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('99edeea0-9868-11eb-9e4f-6d7301ceddce', '99ec6800-9868-11eb-9e4f-6d7301ceddce', '6e48f33a-abce-11ea-ad20-0a5bf521835e', 660, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('99edeea1-9868-11eb-9e4f-6d7301ceddce', '99ec6800-9868-11eb-9e4f-6d7301ceddce', 'a18a47ca-9c4d-11ea-93d6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9bcd2300-3085-11ee-af48-fb839ee61b42', '9ba576c0-3085-11ee-af48-fb839ee61b42', 'a18a4d38-9c4d-11ea-93de-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9bc9f3a0-00f0-11f0-875d-858d9ed2850d', '9bc86d00-00f0-11f0-875d-858d9ed2850d', '202590d0-be1b-11ec-9222-db267923b89e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9bc9f3a1-00f0-11f0-875d-858d9ed2850d', '9bc86d00-00f0-11f0-875d-858d9ed2850d', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9bc9f3a2-00f0-11f0-875d-858d9ed2850d', '9bc86d00-00f0-11f0-875d-858d9ed2850d', '378429f0-46eb-11ec-939f-314f99801403', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9bc9f3a3-00f0-11f0-875d-858d9ed2850d', '9bc86d00-00f0-11f0-875d-858d9ed2850d', '8089c17c-9c4d-11ea-92cc-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9bc9f3a4-00f0-11f0-875d-858d9ed2850d', '9bc86d00-00f0-11f0-875d-858d9ed2850d', '8089b3ee-9c4d-11ea-92be-0a5bf521835e', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9bc9f3a5-00f0-11f0-875d-858d9ed2850d', '9bc86d00-00f0-11f0-875d-858d9ed2850d', '80893d1a-9c4d-11ea-9282-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9bc9f3a6-00f0-11f0-875d-858d9ed2850d', '9bc86d00-00f0-11f0-875d-858d9ed2850d', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9bc9f3a7-00f0-11f0-875d-858d9ed2850d', '9bc86d00-00f0-11f0-875d-858d9ed2850d', '374bc7e0-f306-11ed-b0fa-47c95be3e3ca', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9bc9f3a8-00f0-11f0-875d-858d9ed2850d', '9bc86d00-00f0-11f0-875d-858d9ed2850d', '8089a0c0-9c4d-11ea-92a8-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9bc9f3a9-00f0-11f0-875d-858d9ed2850d', '9bc86d00-00f0-11f0-875d-858d9ed2850d', 'a18a2d62-9c4d-11ea-93af-0a5bf521835e', 170, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9bfb8850-7580-11ed-a0a7-1b2de41c84da', '9bfa76e0-7580-11ed-a0a7-1b2de41c84da', '6ea4c720-c1a5-11ec-853d-e7960d3897c4', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9c2789f0-3083-11ee-af48-fb839ee61b42', '9c013d40-3083-11ee-af48-fb839ee61b42', 'f2e91490-9eb6-11eb-b217-2bde6a29a24e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9c27b101-3083-11ee-af48-fb839ee61b42', '9c013d40-3083-11ee-af48-fb839ee61b42', '8089297e-9c4d-11ea-926b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9c27d810-3083-11ee-af48-fb839ee61b42', '9c013d40-3083-11ee-af48-fb839ee61b42', '80892a5a-9c4d-11ea-926c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('26335650-d4c1-11ef-81b1-519beedbf8f8', '9c85c030-0969-11ec-80fe-8d0b2ae362cc', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('26337d60-d4c1-11ef-81b1-519beedbf8f8', '9c85c030-0969-11ec-80fe-8d0b2ae362cc', 'c4eddf70-e304-11eb-9b9e-0f6f0f6fa679', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('26337d62-d4c1-11ef-81b1-519beedbf8f8', '9c85c030-0969-11ec-80fe-8d0b2ae362cc', 'a18a3168-9c4d-11ea-93b5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9d073760-308a-11ee-af48-fb839ee61b42', '9ccd89c0-308a-11ee-af48-fb839ee61b42', 'a18a9f54-9c4d-11ea-943b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9d075e70-308a-11ee-af48-fb839ee61b42', '9ccd89c0-308a-11ee-af48-fb839ee61b42', 'a18a9ffe-9c4d-11ea-943c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9d4e0580-2374-11f0-8e38-472558b3b72f', '9d4d4230-2374-11f0-8e38-472558b3b72f', '3a5a9a90-f5ee-11eb-8f32-750a66e837fd', 25, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9d5e33d0-f0ca-11ed-9ff6-59801b43f17c', '9d5d7080-f0ca-11ed-9ff6-59801b43f17c', '8089b920-9c4d-11ea-92c4-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9d5e5ae1-f0ca-11ed-9ff6-59801b43f17c', '9d5d7080-f0ca-11ed-9ff6-59801b43f17c', '8089cfdc-9c4d-11ea-92dd-0a5bf521835e', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a66ca570-f2f9-11ed-ada6-f1c2893b2f15', '9d5d7080-f0ca-11ed-9ff6-59801b43f17c', '5ff10d10-f4f5-11eb-9855-6d337dfcae57', 20, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9de29580-3085-11ee-af48-fb839ee61b42', '9da7d670-3085-11ee-af48-fb839ee61b42', 'a18a6aac-9c4d-11ea-9401-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9de2bc90-3085-11ee-af48-fb839ee61b42', '9da7d670-3085-11ee-af48-fb839ee61b42', 'a18a6b56-9c4d-11ea-9402-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9ddba680-f5d1-11eb-a95c-45ac352893ba', '9dd760c0-f5d1-11eb-a95c-45ac352893ba', 'a18acc7c-9c4d-11ea-946c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b842a8d0-f5ee-11eb-a95c-45ac352893ba', '9dd760c0-f5d1-11eb-a95c-45ac352893ba', '3a5a9a90-f5ee-11eb-8f32-750a66e837fd', 32, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9de3c7e0-bede-11eb-b72d-730bbd0b1638', '9de32ba0-bede-11eb-b72d-730bbd0b1638', '5fd18ab0-bedd-11eb-b72d-730bbd0b1638', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9de3c7e1-bede-11eb-b72d-730bbd0b1638', '9de32ba0-bede-11eb-b72d-730bbd0b1638', 'a18a3168-9c4d-11ea-93b5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9e2efc40-de3f-11ef-a5b2-37188811106e', '9e2d9cb0-de3f-11ef-a5b2-37188811106e', 'a18a43b0-9c4d-11ea-93d0-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9e2efc41-de3f-11ef-a5b2-37188811106e', '9e2d9cb0-de3f-11ef-a5b2-37188811106e', 'a18a2cae-9c4d-11ea-93ae-0a5bf521835e', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9e2f4a61-de3f-11ef-a5b2-37188811106e', '9e2d9cb0-de3f-11ef-a5b2-37188811106e', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9e2f4a63-de3f-11ef-a5b2-37188811106e', '9e2d9cb0-de3f-11ef-a5b2-37188811106e', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9e2f7170-de3f-11ef-a5b2-37188811106e', '9e2d9cb0-de3f-11ef-a5b2-37188811106e', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9e2f7172-de3f-11ef-a5b2-37188811106e', '9e2d9cb0-de3f-11ef-a5b2-37188811106e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9e2f7174-de3f-11ef-a5b2-37188811106e', '9e2d9cb0-de3f-11ef-a5b2-37188811106e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9e2f7176-de3f-11ef-a5b2-37188811106e', '9e2d9cb0-de3f-11ef-a5b2-37188811106e', '6b794010-46eb-11ec-bc07-efd394bb365a', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9e2f9881-de3f-11ef-a5b2-37188811106e', '9e2d9cb0-de3f-11ef-a5b2-37188811106e', 'e9d88d10-b944-11eb-acec-29fb8569cb50', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9e2f9883-de3f-11ef-a5b2-37188811106e', '9e2d9cb0-de3f-11ef-a5b2-37188811106e', '15289b50-bba7-11ef-a2da-67539c782629', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9e2f9885-de3f-11ef-a5b2-37188811106e', '9e2d9cb0-de3f-11ef-a5b2-37188811106e', 'a18a2f6a-9c4d-11ea-93b2-0a5bf521835e', 170, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('72f4c840-cf51-11ef-90af-61ebec49d20b', '9e3d1030-cf50-11ef-8b1f-795efc194fa4', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('72f4ef51-cf51-11ef-90af-61ebec49d20b', '9e3d1030-cf50-11ef-8b1f-795efc194fa4', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('72f4ef52-cf51-11ef-90af-61ebec49d20b', '9e3d1030-cf50-11ef-8b1f-795efc194fa4', '8089c258-9c4d-11ea-92cd-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('72f4ef54-cf51-11ef-90af-61ebec49d20b', '9e3d1030-cf50-11ef-8b1f-795efc194fa4', 'a18a2cae-9c4d-11ea-93ae-0a5bf521835e', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('72f4ef56-cf51-11ef-90af-61ebec49d20b', '9e3d1030-cf50-11ef-8b1f-795efc194fa4', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('72f4ef58-cf51-11ef-90af-61ebec49d20b', '9e3d1030-cf50-11ef-8b1f-795efc194fa4', '8089b920-9c4d-11ea-92c4-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('72f4ef5a-cf51-11ef-90af-61ebec49d20b', '9e3d1030-cf50-11ef-8b1f-795efc194fa4', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('72f4ef5c-cf51-11ef-90af-61ebec49d20b', '9e3d1030-cf50-11ef-8b1f-795efc194fa4', '8089c406-9c4d-11ea-92cf-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('72f4ef5e-cf51-11ef-90af-61ebec49d20b', '9e3d1030-cf50-11ef-8b1f-795efc194fa4', 'a18a26c8-9c4d-11ea-93a9-0a5bf521835e', 300, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('72f51661-cf51-11ef-90af-61ebec49d20b', '9e3d1030-cf50-11ef-8b1f-795efc194fa4', '5b05ba10-cf50-11ef-9028-f1198bb1e3d6', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9f3e1490-308a-11ee-af48-fb839ee61b42', '9effd310-308a-11ee-af48-fb839ee61b42', 'deb3cd90-be1c-11ec-92b5-d17e9a4e477d', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9f3e3ba0-308a-11ee-af48-fb839ee61b42', '9effd310-308a-11ee-af48-fb839ee61b42', 'c0773370-d5bf-11ec-9916-a1c1f658f229', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9f43b280-308d-11ee-af48-fb839ee61b42', '9f1d65d0-308d-11ee-af48-fb839ee61b42', 'a18a4c8e-9c4d-11ea-93dd-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a03ba1b0-307a-11ee-af48-fb839ee61b42', 'a0183b30-307a-11ee-af48-fb839ee61b42', '8089d522-9c4d-11ea-92e3-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('a0b4fe20-307f-11ee-af48-fb839ee61b42', 'a0917090-307f-11ee-af48-fb839ee61b42', 'a18ad582-9c4d-11ea-9476-0a5bf521835e', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9c167e30-b8d5-11f0-a1c1-eb4c62071ccb', 'a0ccfde0-1d9b-11ef-93d6-1dc8be8e1247', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9c167e31-b8d5-11f0-a1c1-eb4c62071ccb', 'a0ccfde0-1d9b-11ef-93d6-1dc8be8e1247', 'a18a89c4-9c4d-11ea-9421-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9c167e33-b8d5-11f0-a1c1-eb4c62071ccb', 'a0ccfde0-1d9b-11ef-93d6-1dc8be8e1247', '8089a1ba-9c4d-11ea-92a9-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9c167e35-b8d5-11f0-a1c1-eb4c62071ccb', 'a0ccfde0-1d9b-11ef-93d6-1dc8be8e1247', 'a48c7a10-c885-11ef-8a4d-17c77f3f8f34', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a0f3a940-3089-11ee-af48-fb839ee61b42', 'a0cf7f70-3089-11ee-af48-fb839ee61b42', '8089c924-9c4d-11ea-92d5-0a5bf521835e', 0.08, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a1a78230-3084-11ee-af48-fb839ee61b42', 'a1809940-3084-11ee-af48-fb839ee61b42', '2aad0c00-e31e-11eb-8237-736a902b6e66', 120, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1ba8c86-9c4d-11ea-9479-0a5bf521835e', 'a18a26c8-9c4d-11ea-93a9-0a5bf521835e', '80893810-9c4d-11ea-927c-0a5bf521835e', 425, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bb6c6e-9c4d-11ea-947a-0a5bf521835e', 'a18a29b6-9c4d-11ea-93aa-0a5bf521835e', '8089d446-9c4d-11ea-92e2-0a5bf521835e', 1500, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ea520e70-2da6-11ec-ac7d-edfd3dbf0302', 'a18a29b6-9c4d-11ea-93aa-0a5bf521835e', '80899c4c-9c4d-11ea-92a3-0a5bf521835e', 1100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1bb8b54-9c4d-11ea-947c-0a5bf521835e', 'a18a2a9c-9c4d-11ea-93ab-0a5bf521835e', 'a18a29b6-9c4d-11ea-93aa-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('51d07c00-9395-11eb-b551-3d9be8d1c5c7', 'a18a2b50-9c4d-11ea-93ac-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 125, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bb9aa4-9c4d-11ea-947d-0a5bf521835e', 'a18a2b50-9c4d-11ea-93ac-0a5bf521835e', '8089cc80-9c4d-11ea-92d9-0a5bf521835e', 1250, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bba9cc-9c4d-11ea-947e-0a5bf521835e', 'a18a2bfa-9c4d-11ea-93ad-0a5bf521835e', '8089cfdc-9c4d-11ea-92dd-0a5bf521835e', 1330, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('826d0680-a3d8-11ed-b334-9d8027d9f5cd', 'a18a2cae-9c4d-11ea-93ae-0a5bf521835e', '8089d0a4-9c4d-11ea-92de-0a5bf521835e', 1340, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e927ac60-bb94-11ef-837e-b7ae84901a5c', 'a18a2d62-9c4d-11ea-93af-0a5bf521835e', '80893658-9c4d-11ea-927a-0a5bf521835e', 290, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bbd776-9c4d-11ea-9481-0a5bf521835e', 'a18a2e0c-9c4d-11ea-93b0-0a5bf521835e', '8089c852-9c4d-11ea-92d4-0a5bf521835e', 17.5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bbe694-9c4d-11ea-9482-0a5bf521835e', 'a18a2eb6-9c4d-11ea-93b1-0a5bf521835e', '80893748-9c4d-11ea-927b-0a5bf521835e', 320, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bbf684-9c4d-11ea-9483-0a5bf521835e', 'a18a2f6a-9c4d-11ea-93b2-0a5bf521835e', '80893572-9c4d-11ea-9279-0a5bf521835e', 470, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('63500c20-80ad-11eb-a07d-432b365e0f0f', 'a18a3014-9c4d-11ea-93b3-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bc0642-9c4d-11ea-9484-0a5bf521835e', 'a18a3014-9c4d-11ea-93b3-0a5bf521835e', '8089d838-9c4d-11ea-92e5-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bc15d8-9c4d-11ea-9485-0a5bf521835e', 'a18a3014-9c4d-11ea-93b3-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bc354a-9c4d-11ea-9487-0a5bf521835e', 'a18a3014-9c4d-11ea-93b3-0a5bf521835e', '80899d1e-9c4d-11ea-92a4-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('be2d7ea0-5467-11ec-bf5f-b354dfc64247', 'a18a3014-9c4d-11ea-93b3-0a5bf521835e', 'e760b460-4790-11ec-939f-314f99801403', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('32834b40-5468-11ec-a8c2-03e92580e6a1', 'a18a30be-9c4d-11ea-93b4-0a5bf521835e', 'e760b460-4790-11ec-939f-314f99801403', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('93aa2a30-3012-11ec-83cf-e13293277655', 'a18a30be-9c4d-11ea-93b4-0a5bf521835e', '80899df0-9c4d-11ea-92a5-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bc4526-9c4d-11ea-9488-0a5bf521835e', 'a18a30be-9c4d-11ea-93b4-0a5bf521835e', '8089cfdc-9c4d-11ea-92dd-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bc54c6-9c4d-11ea-9489-0a5bf521835e', 'a18a30be-9c4d-11ea-93b4-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e6693d50-8285-11eb-aa51-a7979c7c712f', 'a18a30be-9c4d-11ea-93b4-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('1f721800-874b-11eb-b06e-f714206729cb', 'a18a3168-9c4d-11ea-93b5-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('69b53ce0-5468-11ec-a8c2-03e92580e6a1', 'a18a3168-9c4d-11ea-93b5-0a5bf521835e', 'e760b460-4790-11ec-939f-314f99801403', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1bc83ce-9c4d-11ea-948c-0a5bf521835e', 'a18a3168-9c4d-11ea-93b5-0a5bf521835e', 'a18a2b50-9c4d-11ea-93ac-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bc9404-9c4d-11ea-948d-0a5bf521835e', 'a18a3168-9c4d-11ea-93b5-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5fc95fd0-ea2f-11ef-9c9a-5327e8c7c929', 'a18a3212-9c4d-11ea-93b6-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('5fc95fd1-ea2f-11ef-9c9a-5327e8c7c929', 'a18a3212-9c4d-11ea-93b6-0a5bf521835e', 'a18a2cae-9c4d-11ea-93ae-0a5bf521835e', 55, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5fc95fd2-ea2f-11ef-9c9a-5327e8c7c929', 'a18a3212-9c4d-11ea-93b6-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('5fc95fd3-ea2f-11ef-9c9a-5327e8c7c929', 'a18a3212-9c4d-11ea-93b6-0a5bf521835e', 'e760b460-4790-11ec-939f-314f99801403', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5fc95fd4-ea2f-11ef-9c9a-5327e8c7c929', 'a18a3212-9c4d-11ea-93b6-0a5bf521835e', '80899df0-9c4d-11ea-92a5-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6e97a850-ea2f-11ef-8b3c-1777d889a253', 'a18a32bc-9c4d-11ea-93b7-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('6e97a851-ea2f-11ef-8b3c-1777d889a253', 'a18a32bc-9c4d-11ea-93b7-0a5bf521835e', 'a18a2cae-9c4d-11ea-93ae-0a5bf521835e', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6e97a852-ea2f-11ef-8b3c-1777d889a253', 'a18a32bc-9c4d-11ea-93b7-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('6e97a853-ea2f-11ef-8b3c-1777d889a253', 'a18a32bc-9c4d-11ea-93b7-0a5bf521835e', 'e760b460-4790-11ec-939f-314f99801403', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6e97a854-ea2f-11ef-8b3c-1777d889a253', 'a18a32bc-9c4d-11ea-93b7-0a5bf521835e', '80899df0-9c4d-11ea-92a5-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('60899750-80e8-11eb-a07d-432b365e0f0f', 'a18a3366-9c4d-11ea-93b8-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1bd40f2-9c4d-11ea-9498-0a5bf521835e', 'a18a3366-9c4d-11ea-93b8-0a5bf521835e', 'a18a2b50-9c4d-11ea-93ac-0a5bf521835e', 90, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bd509c-9c4d-11ea-9499-0a5bf521835e', 'a18a3366-9c4d-11ea-93b8-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('29c91a20-5468-11ec-bf5f-b354dfc64247', 'a18a341a-9c4d-11ea-93b9-0a5bf521835e', 'e760b460-4790-11ec-939f-314f99801403', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('2a8676d0-80ea-11eb-a07d-432b365e0f0f', 'a18a341a-9c4d-11ea-93b9-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bd6050-9c4d-11ea-949a-0a5bf521835e', 'a18a341a-9c4d-11ea-93b9-0a5bf521835e', '8089cfdc-9c4d-11ea-92dd-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bd6fdc-9c4d-11ea-949b-0a5bf521835e', 'a18a341a-9c4d-11ea-93b9-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bd8f12-9c4d-11ea-949d-0a5bf521835e', 'a18a341a-9c4d-11ea-93b9-0a5bf521835e', '80899ef4-9c4d-11ea-92a6-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('11e699c0-80ea-11eb-b7b6-29f989e36bf6', 'a18a34c4-9c4d-11ea-93ba-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('1738e7a0-5468-11ec-addc-4ff06367e2a8', 'a18a34c4-9c4d-11ea-93ba-0a5bf521835e', 'e760b460-4790-11ec-939f-314f99801403', 140, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bd9ebc-9c4d-11ea-949e-0a5bf521835e', 'a18a34c4-9c4d-11ea-93ba-0a5bf521835e', '8089cfdc-9c4d-11ea-92dd-0a5bf521835e', 140, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bdae20-9c4d-11ea-949f-0a5bf521835e', 'a18a34c4-9c4d-11ea-93ba-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bdcdc4-9c4d-11ea-94a1-0a5bf521835e', 'a18a34c4-9c4d-11ea-93ba-0a5bf521835e', '80899ef4-9c4d-11ea-92a6-0a5bf521835e', 200, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('4ba3f110-5468-11ec-b34b-49e62cc45be8', 'a18a3578-9c4d-11ea-93bb-0a5bf521835e', 'e760b460-4790-11ec-939f-314f99801403', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('799a0800-8760-11eb-ba42-2d944e66f12b', 'a18a3578-9c4d-11ea-93bb-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1bddda0-9c4d-11ea-94a2-0a5bf521835e', 'a18a3578-9c4d-11ea-93bb-0a5bf521835e', 'a18a2b50-9c4d-11ea-93ac-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bded72-9c4d-11ea-94a3-0a5bf521835e', 'a18a3578-9c4d-11ea-93bb-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1be0d16-9c4d-11ea-94a5-0a5bf521835e', 'a18a3578-9c4d-11ea-93bb-0a5bf521835e', '80899ef4-9c4d-11ea-92a6-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('3daa0f90-5468-11ec-bf5f-b354dfc64247', 'a18a3622-9c4d-11ea-93bc-0a5bf521835e', 'e760b460-4790-11ec-939f-314f99801403', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1be1cac-9c4d-11ea-94a6-0a5bf521835e', 'a18a3622-9c4d-11ea-93bc-0a5bf521835e', 'a18a2b50-9c4d-11ea-93ac-0a5bf521835e', 140, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1be2c4c-9c4d-11ea-94a7-0a5bf521835e', 'a18a3622-9c4d-11ea-93bc-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1be4baa-9c4d-11ea-94a9-0a5bf521835e', 'a18a3622-9c4d-11ea-93bc-0a5bf521835e', '80899ef4-9c4d-11ea-92a6-0a5bf521835e', 200, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ea86d580-875f-11eb-b06e-f714206729cb', 'a18a3622-9c4d-11ea-93bc-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('81bb0ee0-80e8-11eb-b7b6-29f989e36bf6', 'a18a36d6-9c4d-11ea-93bd-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1be5b68-9c4d-11ea-94aa-0a5bf521835e', 'a18a36d6-9c4d-11ea-93bd-0a5bf521835e', '8089d0a4-9c4d-11ea-92de-0a5bf521835e', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1be6b62-9c4d-11ea-94ab-0a5bf521835e', 'a18a36d6-9c4d-11ea-93bd-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1be7b20-9c4d-11ea-94ac-0a5bf521835e', 'a18a36d6-9c4d-11ea-93bd-0a5bf521835e', '8089a1ba-9c4d-11ea-92a9-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8b456140-80e8-11eb-b7b6-29f989e36bf6', 'a18a3780-9c4d-11ea-93be-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1be8aac-9c4d-11ea-94ad-0a5bf521835e', 'a18a3780-9c4d-11ea-93be-0a5bf521835e', '8089d0a4-9c4d-11ea-92de-0a5bf521835e', 80, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1be9a9c-9c4d-11ea-94ae-0a5bf521835e', 'a18a3780-9c4d-11ea-93be-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1beaa28-9c4d-11ea-94af-0a5bf521835e', 'a18a3780-9c4d-11ea-93be-0a5bf521835e', '8089a1ba-9c4d-11ea-92a9-0a5bf521835e', 200, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('0d4baa50-80e9-11eb-b7b6-29f989e36bf6', 'a18a382a-9c4d-11ea-93bf-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1beb9b4-9c4d-11ea-94b0-0a5bf521835e', 'a18a382a-9c4d-11ea-93bf-0a5bf521835e', '8089cfdc-9c4d-11ea-92dd-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1becb66-9c4d-11ea-94b1-0a5bf521835e', 'a18a382a-9c4d-11ea-93bf-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bedb42-9c4d-11ea-94b2-0a5bf521835e', 'a18a382a-9c4d-11ea-93bf-0a5bf521835e', '8089a1ba-9c4d-11ea-92a9-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1beeaba-9c4d-11ea-94b3-0a5bf521835e', 'a18a38d4-9c4d-11ea-93c0-0a5bf521835e', '8089cfdc-9c4d-11ea-92dd-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1befa6e-9c4d-11ea-94b4-0a5bf521835e', 'a18a38d4-9c4d-11ea-93c0-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bf0a54-9c4d-11ea-94b5-0a5bf521835e', 'a18a38d4-9c4d-11ea-93c0-0a5bf521835e', '8089a1ba-9c4d-11ea-92a9-0a5bf521835e', 200, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('dc9c7060-80e8-11eb-a07d-432b365e0f0f', 'a18a38d4-9c4d-11ea-93c0-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a4f74a90-80e8-11eb-b7b6-29f989e36bf6', 'a18a3988-9c4d-11ea-93c1-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bf1a30-9c4d-11ea-94b6-0a5bf521835e', 'a18a3988-9c4d-11ea-93c1-0a5bf521835e', '8089d838-9c4d-11ea-92e5-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bf29c6-9c4d-11ea-94b7-0a5bf521835e', 'a18a3988-9c4d-11ea-93c1-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bf3984-9c4d-11ea-94b8-0a5bf521835e', 'a18a3988-9c4d-11ea-93c1-0a5bf521835e', '8089a1ba-9c4d-11ea-92a9-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('96420850-80e8-11eb-b7b6-29f989e36bf6', 'a18a3a32-9c4d-11ea-93c2-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bf4924-9c4d-11ea-94b9-0a5bf521835e', 'a18a3a32-9c4d-11ea-93c2-0a5bf521835e', '8089d838-9c4d-11ea-92e5-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bf58c4-9c4d-11ea-94ba-0a5bf521835e', 'a18a3a32-9c4d-11ea-93c2-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bf6878-9c4d-11ea-94bb-0a5bf521835e', 'a18a3a32-9c4d-11ea-93c2-0a5bf521835e', '8089a1ba-9c4d-11ea-92a9-0a5bf521835e', 200, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('26f29720-80e9-11eb-b7b6-29f989e36bf6', 'a18a3ae6-9c4d-11ea-93c3-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1bf7836-9c4d-11ea-94bc-0a5bf521835e', 'a18a3ae6-9c4d-11ea-93c3-0a5bf521835e', 'a18a2b50-9c4d-11ea-93ac-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bf87b8-9c4d-11ea-94bd-0a5bf521835e', 'a18a3ae6-9c4d-11ea-93c3-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bf9744-9c4d-11ea-94be-0a5bf521835e', 'a18a3ae6-9c4d-11ea-93c3-0a5bf521835e', '8089a1ba-9c4d-11ea-92a9-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('1b389380-80e9-11eb-b7b6-29f989e36bf6', 'a18a3b90-9c4d-11ea-93c4-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1bfa770-9c4d-11ea-94bf-0a5bf521835e', 'a18a3b90-9c4d-11ea-93c4-0a5bf521835e', 'a18a2b50-9c4d-11ea-93ac-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bfb710-9c4d-11ea-94c0-0a5bf521835e', 'a18a3b90-9c4d-11ea-93c4-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bfc714-9c4d-11ea-94c1-0a5bf521835e', 'a18a3b90-9c4d-11ea-93c4-0a5bf521835e', '8089a1ba-9c4d-11ea-92a9-0a5bf521835e', 200, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1bff630-9c4d-11ea-94c4-0a5bf521835e', 'a18a3d98-9c4d-11ea-93c7-0a5bf521835e', '80897f50-9c4d-11ea-929c-0a5bf521835e', 63, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c005da-9c4d-11ea-94c5-0a5bf521835e', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', '8089212c-9c4d-11ea-9261-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c01598-9c4d-11ea-94c6-0a5bf521835e', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', '808921ea-9c4d-11ea-9262-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c0252e-9c4d-11ea-94c7-0a5bf521835e', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', '80893112-9c4d-11ea-9274-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c03528-9c4d-11ea-94c8-0a5bf521835e', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', '808931ee-9c4d-11ea-9275-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c048e2-9c4d-11ea-94c9-0a5bf521835e', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', '808932c0-9c4d-11ea-9276-0a5bf521835e', 0.5, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('3802d4f0-56f5-11ee-998b-51c19134b821', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', '80893112-9c4d-11ea-9274-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('3802d4f1-56f5-11ee-998b-51c19134b821', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', '8089238e-9c4d-11ea-9264-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('3802d4f2-56f5-11ee-998b-51c19134b821', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', '80892cda-9c4d-11ea-926f-0a5bf521835e', 0.3, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('3802d4f3-56f5-11ee-998b-51c19134b821', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', '808932c0-9c4d-11ea-9276-0a5bf521835e', 0.5, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('3802fc00-56f5-11ee-998b-51c19134b821', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', '808922c6-9c4d-11ea-9263-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('3802fc01-56f5-11ee-998b-51c19134b821', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', '808931ee-9c4d-11ea-9275-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b7abacc0-e53a-11ef-ae90-c77ba71d6e00', 'a18a404a-9c4d-11ea-93cb-0a5bf521835e', 'd0ceb8f0-3583-11ed-9548-ed051dc9e4fe', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b7abacc1-e53a-11ef-ae90-c77ba71d6e00', 'a18a404a-9c4d-11ea-93cb-0a5bf521835e', '378429f0-46eb-11ec-939f-314f99801403', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b7abacc2-e53a-11ef-ae90-c77ba71d6e00', 'a18a404a-9c4d-11ea-93cb-0a5bf521835e', '8089b3ee-9c4d-11ea-92be-0a5bf521835e', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b7abacc3-e53a-11ef-ae90-c77ba71d6e00', 'a18a404a-9c4d-11ea-93cb-0a5bf521835e', '8089a0c0-9c4d-11ea-92a8-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c18e64-9c4d-11ea-94dc-0a5bf521835e', 'a18a40f4-9c4d-11ea-93cc-0a5bf521835e', '80892032-9c4d-11ea-9260-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c19df0-9c4d-11ea-94dd-0a5bf521835e', 'a18a40f4-9c4d-11ea-93cc-0a5bf521835e', '8089a61a-9c4d-11ea-92ae-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c1ad90-9c4d-11ea-94de-0a5bf521835e', 'a18a40f4-9c4d-11ea-93cc-0a5bf521835e', '808926cc-9c4d-11ea-9268-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c1bd3a-9c4d-11ea-94df-0a5bf521835e', 'a18a40f4-9c4d-11ea-93cc-0a5bf521835e', '808931ee-9c4d-11ea-9275-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c1ccd0-9c4d-11ea-94e0-0a5bf521835e', 'a18a40f4-9c4d-11ea-93cc-0a5bf521835e', '808932c0-9c4d-11ea-9276-0a5bf521835e', 0.5, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c20c2c-9c4d-11ea-94e4-0a5bf521835e', 'a18a42fc-9c4d-11ea-93cf-0a5bf521835e', '808922c6-9c4d-11ea-9263-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c21bcc-9c4d-11ea-94e5-0a5bf521835e', 'a18a42fc-9c4d-11ea-93cf-0a5bf521835e', '8089238e-9c4d-11ea-9264-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c22b9e-9c4d-11ea-94e6-0a5bf521835e', 'a18a42fc-9c4d-11ea-93cf-0a5bf521835e', '808931ee-9c4d-11ea-9275-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c23b3e-9c4d-11ea-94e7-0a5bf521835e', 'a18a42fc-9c4d-11ea-93cf-0a5bf521835e', '808932c0-9c4d-11ea-9276-0a5bf521835e', 0.5, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c24ade-9c4d-11ea-94e8-0a5bf521835e', 'a18a43b0-9c4d-11ea-93d0-0a5bf521835e', '8089212c-9c4d-11ea-9261-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c25a7e-9c4d-11ea-94e9-0a5bf521835e', 'a18a43b0-9c4d-11ea-93d0-0a5bf521835e', '808921ea-9c4d-11ea-9262-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c26a32-9c4d-11ea-94ea-0a5bf521835e', 'a18a43b0-9c4d-11ea-93d0-0a5bf521835e', '8089a534-9c4d-11ea-92ad-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c279c8-9c4d-11ea-94eb-0a5bf521835e', 'a18a43b0-9c4d-11ea-93d0-0a5bf521835e', '80893112-9c4d-11ea-9274-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c28972-9c4d-11ea-94ec-0a5bf521835e', 'a18a43b0-9c4d-11ea-93d0-0a5bf521835e', '808931ee-9c4d-11ea-9275-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c2991c-9c4d-11ea-94ed-0a5bf521835e', 'a18a43b0-9c4d-11ea-93d0-0a5bf521835e', '808932c0-9c4d-11ea-9276-0a5bf521835e', 0.5, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c2a95c-9c4d-11ea-94ee-0a5bf521835e', 'a18a4464-9c4d-11ea-93d1-0a5bf521835e', '808922c6-9c4d-11ea-9263-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c2b91a-9c4d-11ea-94ef-0a5bf521835e', 'a18a4464-9c4d-11ea-93d1-0a5bf521835e', '8089238e-9c4d-11ea-9264-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c2c8d8-9c4d-11ea-94f0-0a5bf521835e', 'a18a4464-9c4d-11ea-93d1-0a5bf521835e', '8089a534-9c4d-11ea-92ad-0a5bf521835e', 2, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c2d882-9c4d-11ea-94f1-0a5bf521835e', 'a18a4464-9c4d-11ea-93d1-0a5bf521835e', '80893112-9c4d-11ea-9274-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c2e80e-9c4d-11ea-94f2-0a5bf521835e', 'a18a4464-9c4d-11ea-93d1-0a5bf521835e', '808931ee-9c4d-11ea-9275-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c2f786-9c4d-11ea-94f3-0a5bf521835e', 'a18a4464-9c4d-11ea-93d1-0a5bf521835e', '808932c0-9c4d-11ea-9276-0a5bf521835e', 0.5, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9d247530-fe6c-11ef-8ce1-43e176c4f995', 'a18a466c-9c4d-11ea-93d4-0a5bf521835e', '96d871b0-b37b-11ed-9ea0-d38c4a9947cb', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9d247531-fe6c-11ef-8ce1-43e176c4f995', 'a18a466c-9c4d-11ea-93d4-0a5bf521835e', '80893112-9c4d-11ea-9274-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9d247532-fe6c-11ef-8ce1-43e176c4f995', 'a18a466c-9c4d-11ea-93d4-0a5bf521835e', '808921ea-9c4d-11ea-9262-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9d247533-fe6c-11ef-8ce1-43e176c4f995', 'a18a466c-9c4d-11ea-93d4-0a5bf521835e', 'ba162090-7eb7-11ec-bafd-fb0d701e3442', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9d247534-fe6c-11ef-8ce1-43e176c4f995', 'a18a466c-9c4d-11ea-93d4-0a5bf521835e', '808932c0-9c4d-11ea-9276-0a5bf521835e', 0.5, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9d247535-fe6c-11ef-8ce1-43e176c4f995', 'a18a466c-9c4d-11ea-93d4-0a5bf521835e', '8089212c-9c4d-11ea-9261-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9d247536-fe6c-11ef-8ce1-43e176c4f995', 'a18a466c-9c4d-11ea-93d4-0a5bf521835e', '808931ee-9c4d-11ea-9275-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7fc53b50-fe6c-11ef-b39f-37ef02c1e266', 'a18a4716-9c4d-11ea-93d5-0a5bf521835e', '96d871b0-b37b-11ed-9ea0-d38c4a9947cb', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7fc53b51-fe6c-11ef-b39f-37ef02c1e266', 'a18a4716-9c4d-11ea-93d5-0a5bf521835e', '80893112-9c4d-11ea-9274-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7fc53b52-fe6c-11ef-b39f-37ef02c1e266', 'a18a4716-9c4d-11ea-93d5-0a5bf521835e', '8089238e-9c4d-11ea-9264-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7fc56260-fe6c-11ef-b39f-37ef02c1e266', 'a18a4716-9c4d-11ea-93d5-0a5bf521835e', 'ba162090-7eb7-11ec-bafd-fb0d701e3442', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7fc56261-fe6c-11ef-b39f-37ef02c1e266', 'a18a4716-9c4d-11ea-93d5-0a5bf521835e', '808932c0-9c4d-11ea-9276-0a5bf521835e', 0.5, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7fc56262-fe6c-11ef-b39f-37ef02c1e266', 'a18a4716-9c4d-11ea-93d5-0a5bf521835e', '808922c6-9c4d-11ea-9263-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7fc56263-fe6c-11ef-b39f-37ef02c1e266', 'a18a4716-9c4d-11ea-93d5-0a5bf521835e', '808931ee-9c4d-11ea-9275-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6af75c10-21d2-11f0-8e38-472558b3b72f', 'a18a47ca-9c4d-11ea-93d6-0a5bf521835e', '80897cbc-9c4d-11ea-9299-0a5bf521835e', 0.001, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6af75c11-21d2-11f0-8e38-472558b3b72f', 'a18a47ca-9c4d-11ea-93d6-0a5bf521835e', '80897b0e-9c4d-11ea-9297-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6af75c12-21d2-11f0-8e38-472558b3b72f', 'a18a47ca-9c4d-11ea-93d6-0a5bf521835e', '80897a3c-9c4d-11ea-9296-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6af7f850-21d2-11f0-8e38-472558b3b72f', 'a18a47ca-9c4d-11ea-93d6-0a5bf521835e', '7d3cb780-c9ca-11eb-b7f7-8b9a3a648073', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c45c02-9c4d-11ea-9507-0a5bf521835e', 'a18a4874-9c4d-11ea-93d7-0a5bf521835e', '808933c4-9c4d-11ea-9277-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('652fa450-da73-11ef-917b-5356b4e0e7ef', 'a18a491e-9c4d-11ea-93d8-0a5bf521835e', '0f24c2c0-7d4b-11ed-b263-b95e21b5e348', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('652fa451-da73-11ef-917b-5356b4e0e7ef', 'a18a491e-9c4d-11ea-93d8-0a5bf521835e', '80892c12-9c4d-11ea-926e-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6530b5c0-da73-11ef-917b-5356b4e0e7ef', 'a18a491e-9c4d-11ea-93d8-0a5bf521835e', '808933c4-9c4d-11ea-9277-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('889587a0-92bc-11eb-881f-ade4fee12a0c', 'a18a49d2-9c4d-11ea-93d9-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c49c12-9c4d-11ea-950b-0a5bf521835e', 'a18a49d2-9c4d-11ea-93d9-0a5bf521835e', '8089cf00-9c4d-11ea-92dc-0a5bf521835e', 2, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('1f0d3b20-220f-11f0-a98f-152ce1f9f564', 'a18a4b30-9c4d-11ea-93db-0a5bf521835e', '1541beb0-21db-11f0-ac69-4ff8f2877233', 2, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('1f0d3b21-220f-11f0-a98f-152ce1f9f564', 'a18a4b30-9c4d-11ea-93db-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c4cb2e-9c4d-11ea-950e-0a5bf521835e', 'a18a4bda-9c4d-11ea-93dc-0a5bf521835e', '8089cc80-9c4d-11ea-92d9-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c4db14-9c4d-11ea-950f-0a5bf521835e', 'a18a4c8e-9c4d-11ea-93dd-0a5bf521835e', '8089cfdc-9c4d-11ea-92dd-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c4ead2-9c4d-11ea-9510-0a5bf521835e', 'a18a4d38-9c4d-11ea-93de-0a5bf521835e', '8089d838-9c4d-11ea-92e5-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('5b8f9310-f307-11ed-ba72-bbf252b6b15e', 'a18a4de2-9c4d-11ea-93df-0a5bf521835e', '374bc7e0-f306-11ed-b0fa-47c95be3e3ca', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('aab6ee50-5468-11ec-bf5f-b354dfc64247', 'a18a4de2-9c4d-11ea-93df-0a5bf521835e', '378429f0-46eb-11ec-939f-314f99801403', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c4fae0-9c4d-11ea-9511-0a5bf521835e', 'a18a4de2-9c4d-11ea-93df-0a5bf521835e', 'a18a2d62-9c4d-11ea-93af-0a5bf521835e', 170, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c50a94-9c4d-11ea-9512-0a5bf521835e', 'a18a4de2-9c4d-11ea-93df-0a5bf521835e', '8089cf00-9c4d-11ea-92dc-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c51ade-9c4d-11ea-9513-0a5bf521835e', 'a18a4de2-9c4d-11ea-93df-0a5bf521835e', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c52a7e-9c4d-11ea-9514-0a5bf521835e', 'a18a4de2-9c4d-11ea-93df-0a5bf521835e', '8089c17c-9c4d-11ea-92cc-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c559b8-9c4d-11ea-9517-0a5bf521835e', 'a18a4de2-9c4d-11ea-93df-0a5bf521835e', '8089b3ee-9c4d-11ea-92be-0a5bf521835e', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c5696c-9c4d-11ea-9518-0a5bf521835e', 'a18a4de2-9c4d-11ea-93df-0a5bf521835e', '80893d1a-9c4d-11ea-9282-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c57952-9c4d-11ea-9519-0a5bf521835e', 'a18a4de2-9c4d-11ea-93df-0a5bf521835e', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c588f2-9c4d-11ea-951a-0a5bf521835e', 'a18a4de2-9c4d-11ea-93df-0a5bf521835e', '8089a0c0-9c4d-11ea-92a8-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8284df20-f307-11ed-b0fa-47c95be3e3ca', 'a18a4e8c-9c4d-11ea-93e0-0a5bf521835e', '374bc7e0-f306-11ed-b0fa-47c95be3e3ca', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('a1232610-5468-11ec-addc-4ff06367e2a8', 'a18a4e8c-9c4d-11ea-93e0-0a5bf521835e', '378429f0-46eb-11ec-939f-314f99801403', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c598b0-9c4d-11ea-951b-0a5bf521835e', 'a18a4e8c-9c4d-11ea-93e0-0a5bf521835e', 'a18a2d62-9c4d-11ea-93af-0a5bf521835e', 250, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c5a86e-9c4d-11ea-951c-0a5bf521835e', 'a18a4e8c-9c4d-11ea-93e0-0a5bf521835e', '8089cf00-9c4d-11ea-92dc-0a5bf521835e', 2, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c5b87c-9c4d-11ea-951d-0a5bf521835e', 'a18a4e8c-9c4d-11ea-93e0-0a5bf521835e', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c5c81c-9c4d-11ea-951e-0a5bf521835e', 'a18a4e8c-9c4d-11ea-93e0-0a5bf521835e', '8089c17c-9c4d-11ea-92cc-0a5bf521835e', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c5f76a-9c4d-11ea-9521-0a5bf521835e', 'a18a4e8c-9c4d-11ea-93e0-0a5bf521835e', '8089b3ee-9c4d-11ea-92be-0a5bf521835e', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c6070a-9c4d-11ea-9522-0a5bf521835e', 'a18a4e8c-9c4d-11ea-93e0-0a5bf521835e', '80893d1a-9c4d-11ea-9282-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c61722-9c4d-11ea-9523-0a5bf521835e', 'a18a4e8c-9c4d-11ea-93e0-0a5bf521835e', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c62762-9c4d-11ea-9524-0a5bf521835e', 'a18a4e8c-9c4d-11ea-93e0-0a5bf521835e', '8089a0c0-9c4d-11ea-92a8-0a5bf521835e', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('570a2710-21d1-11f0-8e38-472558b3b72f', 'a18a4fea-9c4d-11ea-93e2-0a5bf521835e', 'a18a4de2-9c4d-11ea-93df-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('570a2712-21d1-11f0-8e38-472558b3b72f', 'a18a4fea-9c4d-11ea-93e2-0a5bf521835e', 'a18a3014-9c4d-11ea-93b3-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('570a2714-21d1-11f0-8e38-472558b3b72f', 'a18a4fea-9c4d-11ea-93e2-0a5bf521835e', 'a18a43b0-9c4d-11ea-93d0-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c68680-9c4d-11ea-952a-0a5bf521835e', 'a18a5094-9c4d-11ea-93e3-0a5bf521835e', 'a18a4de2-9c4d-11ea-93df-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c6962a-9c4d-11ea-952b-0a5bf521835e', 'a18a5094-9c4d-11ea-93e3-0a5bf521835e', 'a18a30be-9c4d-11ea-93b4-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c6a5c0-9c4d-11ea-952c-0a5bf521835e', 'a18a5148-9c4d-11ea-93e4-0a5bf521835e', 'a18a4de2-9c4d-11ea-93df-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c6b592-9c4d-11ea-952d-0a5bf521835e', 'a18a5148-9c4d-11ea-93e4-0a5bf521835e', 'a18a30be-9c4d-11ea-93b4-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c6c582-9c4d-11ea-952e-0a5bf521835e', 'a18a5148-9c4d-11ea-93e4-0a5bf521835e', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c6d52c-9c4d-11ea-952f-0a5bf521835e', 'a18a51f2-9c4d-11ea-93e5-0a5bf521835e', 'a18a4de2-9c4d-11ea-93df-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c6e4fe-9c4d-11ea-9530-0a5bf521835e', 'a18a51f2-9c4d-11ea-93e5-0a5bf521835e', 'a18a3212-9c4d-11ea-93b6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c6f4e4-9c4d-11ea-9531-0a5bf521835e', 'a18a52a6-9c4d-11ea-93e6-0a5bf521835e', 'a18a4de2-9c4d-11ea-93df-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c704b6-9c4d-11ea-9532-0a5bf521835e', 'a18a52a6-9c4d-11ea-93e6-0a5bf521835e', 'a18a3212-9c4d-11ea-93b6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c7146a-9c4d-11ea-9533-0a5bf521835e', 'a18a52a6-9c4d-11ea-93e6-0a5bf521835e', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c72464-9c4d-11ea-9534-0a5bf521835e', 'a18a5350-9c4d-11ea-93e7-0a5bf521835e', 'a18a4de2-9c4d-11ea-93df-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c73440-9c4d-11ea-9535-0a5bf521835e', 'a18a5350-9c4d-11ea-93e7-0a5bf521835e', 'a18a3168-9c4d-11ea-93b5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('bded2490-00f8-11f0-bdd5-cdbffff7bf66', 'a18a53fa-9c4d-11ea-93e8-0a5bf521835e', '9bc86d00-00f0-11f0-875d-858d9ed2850d', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('bded2492-00f8-11f0-bdd5-cdbffff7bf66', 'a18a53fa-9c4d-11ea-93e8-0a5bf521835e', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('bded2493-00f8-11f0-bdd5-cdbffff7bf66', 'a18a53fa-9c4d-11ea-93e8-0a5bf521835e', 'a18a3168-9c4d-11ea-93b5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8e19b070-874a-11eb-ba42-2d944e66f12b', 'a18a54ae-9c4d-11ea-93e9-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8e19b071-874a-11eb-ba42-2d944e66f12b', 'a18a54ae-9c4d-11ea-93e9-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c77338-9c4d-11ea-9539-0a5bf521835e', 'a18a54ae-9c4d-11ea-93e9-0a5bf521835e', 'a18a4de2-9c4d-11ea-93df-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c78314-9c4d-11ea-953a-0a5bf521835e', 'a18a54ae-9c4d-11ea-93e9-0a5bf521835e', 'a18a2a9c-9c4d-11ea-93ab-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6207cc60-874a-11eb-b06e-f714206729cb', 'a18a554e-9c4d-11ea-93ea-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6207f370-874a-11eb-b06e-f714206729cb', 'a18a554e-9c4d-11ea-93ea-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c79354-9c4d-11ea-953b-0a5bf521835e', 'a18a554e-9c4d-11ea-93ea-0a5bf521835e', 'a18a4de2-9c4d-11ea-93df-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c7a2f4-9c4d-11ea-953c-0a5bf521835e', 'a18a554e-9c4d-11ea-93ea-0a5bf521835e', 'a18a2a9c-9c4d-11ea-93ab-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c7b2b2-9c4d-11ea-953d-0a5bf521835e', 'a18a554e-9c4d-11ea-93ea-0a5bf521835e', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c7e200-9c4d-11ea-9540-0a5bf521835e', 'a18a5a9e-9c4d-11ea-93ec-0a5bf521835e', 'a18a4e8c-9c4d-11ea-93e0-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c7f1d2-9c4d-11ea-9541-0a5bf521835e', 'a18a5a9e-9c4d-11ea-93ec-0a5bf521835e', 'a18a3014-9c4d-11ea-93b3-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c8017c-9c4d-11ea-9542-0a5bf521835e', 'a18a5a9e-9c4d-11ea-93ec-0a5bf521835e', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c81130-9c4d-11ea-9543-0a5bf521835e', 'a18a5b70-9c4d-11ea-93ed-0a5bf521835e', 'a18a4e8c-9c4d-11ea-93e0-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c820da-9c4d-11ea-9544-0a5bf521835e', 'a18a5b70-9c4d-11ea-93ed-0a5bf521835e', 'a18a30be-9c4d-11ea-93b4-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c83106-9c4d-11ea-9545-0a5bf521835e', 'a18a5c1a-9c4d-11ea-93ee-0a5bf521835e', 'a18a4e8c-9c4d-11ea-93e0-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c840ba-9c4d-11ea-9546-0a5bf521835e', 'a18a5c1a-9c4d-11ea-93ee-0a5bf521835e', 'a18a30be-9c4d-11ea-93b4-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c852b2-9c4d-11ea-9547-0a5bf521835e', 'a18a5c1a-9c4d-11ea-93ee-0a5bf521835e', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c862a2-9c4d-11ea-9548-0a5bf521835e', 'a18a5cce-9c4d-11ea-93ef-0a5bf521835e', 'a18a4e8c-9c4d-11ea-93e0-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c8722e-9c4d-11ea-9549-0a5bf521835e', 'a18a5cce-9c4d-11ea-93ef-0a5bf521835e', 'a18a32bc-9c4d-11ea-93b7-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c881d8-9c4d-11ea-954a-0a5bf521835e', 'a18a5d78-9c4d-11ea-93f0-0a5bf521835e', 'a18a4e8c-9c4d-11ea-93e0-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c891be-9c4d-11ea-954b-0a5bf521835e', 'a18a5d78-9c4d-11ea-93f0-0a5bf521835e', 'a18a32bc-9c4d-11ea-93b7-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c8a14a-9c4d-11ea-954c-0a5bf521835e', 'a18a5d78-9c4d-11ea-93f0-0a5bf521835e', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c8b0e0-9c4d-11ea-954d-0a5bf521835e', 'a18a5e2c-9c4d-11ea-93f1-0a5bf521835e', 'a18a4e8c-9c4d-11ea-93e0-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c8c10c-9c4d-11ea-954e-0a5bf521835e', 'a18a5e2c-9c4d-11ea-93f1-0a5bf521835e', 'a18a3168-9c4d-11ea-93b5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c8d138-9c4d-11ea-954f-0a5bf521835e', 'a18a5ed6-9c4d-11ea-93f2-0a5bf521835e', 'a18a4e8c-9c4d-11ea-93e0-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c8e0d8-9c4d-11ea-9550-0a5bf521835e', 'a18a5ed6-9c4d-11ea-93f2-0a5bf521835e', 'a18a3168-9c4d-11ea-93b5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c8f082-9c4d-11ea-9551-0a5bf521835e', 'a18a5ed6-9c4d-11ea-93f2-0a5bf521835e', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('155e3530-8749-11eb-b06e-f714206729cb', 'a18a5f8a-9c4d-11ea-93f3-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('155e5c40-8749-11eb-b06e-f714206729cb', 'a18a5f8a-9c4d-11ea-93f3-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c90090-9c4d-11ea-9552-0a5bf521835e', 'a18a5f8a-9c4d-11ea-93f3-0a5bf521835e', 'a18a4e8c-9c4d-11ea-93e0-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c9104e-9c4d-11ea-9553-0a5bf521835e', 'a18a5f8a-9c4d-11ea-93f3-0a5bf521835e', 'a18a2a9c-9c4d-11ea-93ab-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('2411a2b0-8749-11eb-b06e-f714206729cb', 'a18a6034-9c4d-11ea-93f4-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('2411a2b1-8749-11eb-b06e-f714206729cb', 'a18a6034-9c4d-11ea-93f4-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c91fee-9c4d-11ea-9554-0a5bf521835e', 'a18a6034-9c4d-11ea-93f4-0a5bf521835e', 'a18a4e8c-9c4d-11ea-93e0-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c92fac-9c4d-11ea-9555-0a5bf521835e', 'a18a6034-9c4d-11ea-93f4-0a5bf521835e', 'a18a2a9c-9c4d-11ea-93ab-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c93f9c-9c4d-11ea-9556-0a5bf521835e', 'a18a6034-9c4d-11ea-93f4-0a5bf521835e', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('03796740-f50d-11eb-8ccc-17901c63413d', 'a18a60e8-9c4d-11ea-93f5-0a5bf521835e', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('0ece2be0-3012-11ec-ac7d-edfd3dbf0302', 'a18a60e8-9c4d-11ea-93f5-0a5bf521835e', '80899fda-9c4d-11ea-92a7-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('339cc9b0-cf62-11eb-ad59-4b0ef542f836', 'a18a60e8-9c4d-11ea-93f5-0a5bf521835e', 'e9d88d10-b944-11eb-acec-29fb8569cb50', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c94f3c-9c4d-11ea-9557-0a5bf521835e', 'a18a60e8-9c4d-11ea-93f5-0a5bf521835e', 'a18a2eb6-9c4d-11ea-93b1-0a5bf521835e', 170, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c95f2c-9c4d-11ea-9558-0a5bf521835e', 'a18a60e8-9c4d-11ea-93f5-0a5bf521835e', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('df88f6f0-5468-11ec-addc-4ff06367e2a8', 'a18a60e8-9c4d-11ea-93f5-0a5bf521835e', '378429f0-46eb-11ec-939f-314f99801403', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('0872ab40-3012-11ec-af58-791b3a8d753c', 'a18a619c-9c4d-11ea-93f6-0a5bf521835e', '80899fda-9c4d-11ea-92a7-0a5bf521835e', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('0cce51c0-f50d-11eb-9855-6d337dfcae57', 'a18a619c-9c4d-11ea-93f6-0a5bf521835e', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('29bf4e40-cf62-11eb-95c3-b518d92a1f18', 'a18a619c-9c4d-11ea-93f6-0a5bf521835e', 'e9d88d10-b944-11eb-acec-29fb8569cb50', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1c9be2c-9c4d-11ea-955e-0a5bf521835e', 'a18a619c-9c4d-11ea-93f6-0a5bf521835e', 'a18a2eb6-9c4d-11ea-93b1-0a5bf521835e', 250, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1c9cdcc-9c4d-11ea-955f-0a5bf521835e', 'a18a619c-9c4d-11ea-93f6-0a5bf521835e', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 90, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d75b4e60-5468-11ec-bf5f-b354dfc64247', 'a18a619c-9c4d-11ea-93f6-0a5bf521835e', '378429f0-46eb-11ec-939f-314f99801403', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1ca2cea-9c4d-11ea-9565-0a5bf521835e', 'a18a6246-9c4d-11ea-93f7-0a5bf521835e', 'a18a60e8-9c4d-11ea-93f5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1ca3cbc-9c4d-11ea-9566-0a5bf521835e', 'a18a6246-9c4d-11ea-93f7-0a5bf521835e', 'a18a30be-9c4d-11ea-93b4-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1ca4c8e-9c4d-11ea-9567-0a5bf521835e', 'a18a62f0-9c4d-11ea-93f8-0a5bf521835e', 'a18a60e8-9c4d-11ea-93f5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1ca5c56-9c4d-11ea-9568-0a5bf521835e', 'a18a62f0-9c4d-11ea-93f8-0a5bf521835e', 'a18a30be-9c4d-11ea-93b4-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1ca6c14-9c4d-11ea-9569-0a5bf521835e', 'a18a62f0-9c4d-11ea-93f8-0a5bf521835e', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1ca7bf0-9c4d-11ea-956a-0a5bf521835e', 'a18a639a-9c4d-11ea-93f9-0a5bf521835e', 'a18a60e8-9c4d-11ea-93f5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1ca8bd6-9c4d-11ea-956b-0a5bf521835e', 'a18a639a-9c4d-11ea-93f9-0a5bf521835e', 'a18a3014-9c4d-11ea-93b3-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1ca9bf8-9c4d-11ea-956c-0a5bf521835e', 'a18a644e-9c4d-11ea-93fa-0a5bf521835e', 'a18a60e8-9c4d-11ea-93f5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1caab98-9c4d-11ea-956d-0a5bf521835e', 'a18a644e-9c4d-11ea-93fa-0a5bf521835e', 'a18a3014-9c4d-11ea-93b3-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cabb9c-9c4d-11ea-956e-0a5bf521835e', 'a18a644e-9c4d-11ea-93fa-0a5bf521835e', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cacb6e-9c4d-11ea-956f-0a5bf521835e', 'a18a6502-9c4d-11ea-93fb-0a5bf521835e', 'a18a60e8-9c4d-11ea-93f5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cadb18-9c4d-11ea-9570-0a5bf521835e', 'a18a6502-9c4d-11ea-93fb-0a5bf521835e', 'a18a3212-9c4d-11ea-93b6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1caeafe-9c4d-11ea-9571-0a5bf521835e', 'a18a65ac-9c4d-11ea-93fc-0a5bf521835e', 'a18a60e8-9c4d-11ea-93f5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cafad0-9c4d-11ea-9572-0a5bf521835e', 'a18a65ac-9c4d-11ea-93fc-0a5bf521835e', 'a18a3212-9c4d-11ea-93b6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cb0a5c-9c4d-11ea-9573-0a5bf521835e', 'a18a65ac-9c4d-11ea-93fc-0a5bf521835e', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cb1a2e-9c4d-11ea-9574-0a5bf521835e', 'a18a6660-9c4d-11ea-93fd-0a5bf521835e', 'a18a60e8-9c4d-11ea-93f5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cb29ce-9c4d-11ea-9575-0a5bf521835e', 'a18a6660-9c4d-11ea-93fd-0a5bf521835e', 'a18a3168-9c4d-11ea-93b5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cb3a04-9c4d-11ea-9576-0a5bf521835e', 'a18a6890-9c4d-11ea-93fe-0a5bf521835e', 'a18a60e8-9c4d-11ea-93f5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cb49c2-9c4d-11ea-9577-0a5bf521835e', 'a18a6890-9c4d-11ea-93fe-0a5bf521835e', 'a18a3168-9c4d-11ea-93b5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cb5980-9c4d-11ea-9578-0a5bf521835e', 'a18a6890-9c4d-11ea-93fe-0a5bf521835e', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cb69ac-9c4d-11ea-9579-0a5bf521835e', 'a18a694e-9c4d-11ea-93ff-0a5bf521835e', 'a18a60e8-9c4d-11ea-93f5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cb7992-9c4d-11ea-957a-0a5bf521835e', 'a18a694e-9c4d-11ea-93ff-0a5bf521835e', 'a18a2a9c-9c4d-11ea-93ab-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cb8978-9c4d-11ea-957b-0a5bf521835e', 'a18a69f8-9c4d-11ea-9400-0a5bf521835e', 'a18a60e8-9c4d-11ea-93f5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cb9940-9c4d-11ea-957c-0a5bf521835e', 'a18a69f8-9c4d-11ea-9400-0a5bf521835e', 'a18a2a9c-9c4d-11ea-93ab-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cba8f4-9c4d-11ea-957d-0a5bf521835e', 'a18a69f8-9c4d-11ea-9400-0a5bf521835e', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cbb8b2-9c4d-11ea-957e-0a5bf521835e', 'a18a6aac-9c4d-11ea-9401-0a5bf521835e', 'a18a619c-9c4d-11ea-93f6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cbc8ac-9c4d-11ea-957f-0a5bf521835e', 'a18a6aac-9c4d-11ea-9401-0a5bf521835e', 'a18a30be-9c4d-11ea-93b4-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cbd8b0-9c4d-11ea-9580-0a5bf521835e', 'a18a6b56-9c4d-11ea-9402-0a5bf521835e', 'a18a619c-9c4d-11ea-93f6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cbe86e-9c4d-11ea-9581-0a5bf521835e', 'a18a6b56-9c4d-11ea-9402-0a5bf521835e', 'a18a30be-9c4d-11ea-93b4-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cbf890-9c4d-11ea-9582-0a5bf521835e', 'a18a6b56-9c4d-11ea-9402-0a5bf521835e', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cc084e-9c4d-11ea-9583-0a5bf521835e', 'a18a6c0a-9c4d-11ea-9403-0a5bf521835e', 'a18a619c-9c4d-11ea-93f6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cc180c-9c4d-11ea-9584-0a5bf521835e', 'a18a6c0a-9c4d-11ea-9403-0a5bf521835e', 'a18a3014-9c4d-11ea-93b3-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cc27d4-9c4d-11ea-9585-0a5bf521835e', 'a18a6cb4-9c4d-11ea-9404-0a5bf521835e', 'a18a619c-9c4d-11ea-93f6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cc37ce-9c4d-11ea-9586-0a5bf521835e', 'a18a6cb4-9c4d-11ea-9404-0a5bf521835e', 'a18a3014-9c4d-11ea-93b3-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cc4778-9c4d-11ea-9587-0a5bf521835e', 'a18a6cb4-9c4d-11ea-9404-0a5bf521835e', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cc5736-9c4d-11ea-9588-0a5bf521835e', 'a18a7678-9c4d-11ea-9405-0a5bf521835e', 'a18a619c-9c4d-11ea-93f6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cc66f4-9c4d-11ea-9589-0a5bf521835e', 'a18a7678-9c4d-11ea-9405-0a5bf521835e', 'a18a32bc-9c4d-11ea-93b7-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cc773e-9c4d-11ea-958a-0a5bf521835e', 'a18a777c-9c4d-11ea-9406-0a5bf521835e', 'a18a619c-9c4d-11ea-93f6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cc8a76-9c4d-11ea-958b-0a5bf521835e', 'a18a777c-9c4d-11ea-9406-0a5bf521835e', 'a18a32bc-9c4d-11ea-93b7-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cc9a52-9c4d-11ea-958c-0a5bf521835e', 'a18a777c-9c4d-11ea-9406-0a5bf521835e', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1ccaa38-9c4d-11ea-958d-0a5bf521835e', 'a18a7830-9c4d-11ea-9407-0a5bf521835e', 'a18a619c-9c4d-11ea-93f6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1ccba00-9c4d-11ea-958e-0a5bf521835e', 'a18a7830-9c4d-11ea-9407-0a5bf521835e', 'a18a3168-9c4d-11ea-93b5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1ccc9be-9c4d-11ea-958f-0a5bf521835e', 'a18a78da-9c4d-11ea-9408-0a5bf521835e', 'a18a619c-9c4d-11ea-93f6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1ccd9c2-9c4d-11ea-9590-0a5bf521835e', 'a18a78da-9c4d-11ea-9408-0a5bf521835e', 'a18a3168-9c4d-11ea-93b5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cce958-9c4d-11ea-9591-0a5bf521835e', 'a18a78da-9c4d-11ea-9408-0a5bf521835e', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1ccf934-9c4d-11ea-9592-0a5bf521835e', 'a18a798e-9c4d-11ea-9409-0a5bf521835e', 'a18a619c-9c4d-11ea-93f6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cd0a28-9c4d-11ea-9593-0a5bf521835e', 'a18a798e-9c4d-11ea-9409-0a5bf521835e', 'a18a2a9c-9c4d-11ea-93ab-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cd2972-9c4d-11ea-9595-0a5bf521835e', 'a18a7a38-9c4d-11ea-940a-0a5bf521835e', 'a18a619c-9c4d-11ea-93f6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cd3980-9c4d-11ea-9596-0a5bf521835e', 'a18a7a38-9c4d-11ea-940a-0a5bf521835e', 'a18a2a9c-9c4d-11ea-93ab-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cd5906-9c4d-11ea-9598-0a5bf521835e', 'a18a7a38-9c4d-11ea-940a-0a5bf521835e', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('11b90480-5469-11ec-addc-4ff06367e2a8', 'a18a7ae2-9c4d-11ea-940b-0a5bf521835e', '378429f0-46eb-11ec-939f-314f99801403', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('1d63b120-3012-11ec-83cf-e13293277655', 'a18a7ae2-9c4d-11ea-940b-0a5bf521835e', '80899fda-9c4d-11ea-92a7-0a5bf521835e', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('61e44930-f503-11eb-8f32-750a66e837fd', 'a18a7ae2-9c4d-11ea-940b-0a5bf521835e', 'e9d88d10-b944-11eb-acec-29fb8569cb50', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8ece9270-5467-11ec-addc-4ff06367e2a8', 'a18a7ae2-9c4d-11ea-940b-0a5bf521835e', '6b794010-46eb-11ec-bc07-efd394bb365a', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cd68b0-9c4d-11ea-9599-0a5bf521835e', 'a18a7ae2-9c4d-11ea-940b-0a5bf521835e', 'a18a2eb6-9c4d-11ea-93b1-0a5bf521835e', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1cd78be-9c4d-11ea-959a-0a5bf521835e', 'a18a7ae2-9c4d-11ea-940b-0a5bf521835e', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1cd9826-9c4d-11ea-959c-0a5bf521835e', 'a18a7ae2-9c4d-11ea-940b-0a5bf521835e', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 20, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1cde7cc-9c4d-11ea-95a1-0a5bf521835e', 'a18a7ae2-9c4d-11ea-940b-0a5bf521835e', '80893d1a-9c4d-11ea-9282-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('fcc17760-9310-11ec-802a-0f56a24c7a3e', 'a18a7ae2-9c4d-11ea-940b-0a5bf521835e', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('161d8260-3012-11ec-af58-791b3a8d753c', 'a18a7b8c-9c4d-11ea-940c-0a5bf521835e', '80899fda-9c4d-11ea-92a7-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('27c2f470-5469-11ec-b34b-49e62cc45be8', 'a18a7b8c-9c4d-11ea-940c-0a5bf521835e', '378429f0-46eb-11ec-939f-314f99801403', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('90699e40-f503-11eb-8f32-750a66e837fd', 'a18a7b8c-9c4d-11ea-940c-0a5bf521835e', 'e9d88d10-b944-11eb-acec-29fb8569cb50', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('a2e7d5f0-5467-11ec-a8c2-03e92580e6a1', 'a18a7b8c-9c4d-11ea-940c-0a5bf521835e', '6b794010-46eb-11ec-bc07-efd394bb365a', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1ce077a-9c4d-11ea-95a3-0a5bf521835e', 'a18a7b8c-9c4d-11ea-940c-0a5bf521835e', 'a18a2eb6-9c4d-11ea-93b1-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1ce17a6-9c4d-11ea-95a4-0a5bf521835e', 'a18a7b8c-9c4d-11ea-940c-0a5bf521835e', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1ce3736-9c4d-11ea-95a6-0a5bf521835e', 'a18a7b8c-9c4d-11ea-940c-0a5bf521835e', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 20, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1ce76d8-9c4d-11ea-95aa-0a5bf521835e', 'a18a7b8c-9c4d-11ea-940c-0a5bf521835e', '8089b312-9c4d-11ea-92bd-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1ce86be-9c4d-11ea-95ab-0a5bf521835e', 'a18a7b8c-9c4d-11ea-940c-0a5bf521835e', '80893d1a-9c4d-11ea-9282-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f113a8c0-9310-11ec-bdf2-dbb798a33559', 'a18a7b8c-9c4d-11ea-940c-0a5bf521835e', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cea658-9c4d-11ea-95ad-0a5bf521835e', 'a18a7c40-9c4d-11ea-940d-0a5bf521835e', 'a18a7ae2-9c4d-11ea-940b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1ceb62a-9c4d-11ea-95ae-0a5bf521835e', 'a18a7c40-9c4d-11ea-940d-0a5bf521835e', 'a18a3366-9c4d-11ea-93b8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cec5f2-9c4d-11ea-95af-0a5bf521835e', 'a18a7ce0-9c4d-11ea-940e-0a5bf521835e', 'a18a7ae2-9c4d-11ea-940b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1ced588-9c4d-11ea-95b0-0a5bf521835e', 'a18a7ce0-9c4d-11ea-940e-0a5bf521835e', 'a18a3366-9c4d-11ea-93b8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cee5dc-9c4d-11ea-95b1-0a5bf521835e', 'a18a7ce0-9c4d-11ea-940e-0a5bf521835e', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cef5c2-9c4d-11ea-95b2-0a5bf521835e', 'a18a7da8-9c4d-11ea-940f-0a5bf521835e', 'a18a7b8c-9c4d-11ea-940c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cf056c-9c4d-11ea-95b3-0a5bf521835e', 'a18a7da8-9c4d-11ea-940f-0a5bf521835e', 'a18a3366-9c4d-11ea-93b8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cf1552-9c4d-11ea-95b4-0a5bf521835e', 'a18a7e5c-9c4d-11ea-9410-0a5bf521835e', 'a18a7b8c-9c4d-11ea-940c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cf2538-9c4d-11ea-95b5-0a5bf521835e', 'a18a7e5c-9c4d-11ea-9410-0a5bf521835e', 'a18a3366-9c4d-11ea-93b8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cf34f6-9c4d-11ea-95b6-0a5bf521835e', 'a18a7e5c-9c4d-11ea-9410-0a5bf521835e', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cf44b4-9c4d-11ea-95b7-0a5bf521835e', 'a18a7f06-9c4d-11ea-9411-0a5bf521835e', 'a18a26c8-9c4d-11ea-93a9-0a5bf521835e', 300, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1cf5472-9c4d-11ea-95b8-0a5bf521835e', 'a18a7f06-9c4d-11ea-9411-0a5bf521835e', '8089c17c-9c4d-11ea-92cc-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b3d6c780-9310-11ec-a3e7-efebc90d2100', 'a18a7f06-9c4d-11ea-9411-0a5bf521835e', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('03d7b1f0-9310-11ec-a3e7-efebc90d2100', 'a18a7fb0-9c4d-11ea-9412-0a5bf521835e', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1cf7452-9c4d-11ea-95ba-0a5bf521835e', 'a18a7fb0-9c4d-11ea-9412-0a5bf521835e', 'a18a26c8-9c4d-11ea-93a9-0a5bf521835e', 400, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1cf8460-9c4d-11ea-95bb-0a5bf521835e', 'a18a7fb0-9c4d-11ea-9412-0a5bf521835e', '8089c17c-9c4d-11ea-92cc-0a5bf521835e', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9c2526b0-5798-11ee-b338-23c2e19316f3', 'a18a805a-9c4d-11ea-9413-0a5bf521835e', 'a18a7f06-9c4d-11ea-9411-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9c2526b1-5798-11ee-b338-23c2e19316f3', 'a18a805a-9c4d-11ea-9413-0a5bf521835e', 'a18a341a-9c4d-11ea-93b9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('931f1f80-5798-11ee-8a35-b9ff8bb74ead', 'a18a8104-9c4d-11ea-9414-0a5bf521835e', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('931f4690-5798-11ee-8a35-b9ff8bb74ead', 'a18a8104-9c4d-11ea-9414-0a5bf521835e', 'a18a7f06-9c4d-11ea-9411-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('931f4691-5798-11ee-8a35-b9ff8bb74ead', 'a18a8104-9c4d-11ea-9414-0a5bf521835e', 'a18a341a-9c4d-11ea-93b9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8a5c14c0-5798-11ee-a0d7-6bcb9c2501f8', 'a18a81ae-9c4d-11ea-9415-0a5bf521835e', 'a18a7fb0-9c4d-11ea-9412-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8a5c14c1-5798-11ee-a0d7-6bcb9c2501f8', 'a18a81ae-9c4d-11ea-9415-0a5bf521835e', 'a18a34c4-9c4d-11ea-93ba-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('7f8a0020-5798-11ee-9ff4-4dca7cca2633', 'a18a8258-9c4d-11ea-9416-0a5bf521835e', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('7f8a0021-5798-11ee-9ff4-4dca7cca2633', 'a18a8258-9c4d-11ea-9416-0a5bf521835e', 'a18a7fb0-9c4d-11ea-9412-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('7f8a0022-5798-11ee-9ff4-4dca7cca2633', 'a18a8258-9c4d-11ea-9416-0a5bf521835e', 'a18a34c4-9c4d-11ea-93ba-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('0a29fc20-20f7-11f0-b283-b7d039d59cfb', 'a18a83ac-9c4d-11ea-9418-0a5bf521835e', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('0a29fc21-20f7-11f0-b283-b7d039d59cfb', 'a18a83ac-9c4d-11ea-9418-0a5bf521835e', 'a18a7f06-9c4d-11ea-9411-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('0a29fc23-20f7-11f0-b283-b7d039d59cfb', 'a18a83ac-9c4d-11ea-9418-0a5bf521835e', 'a18a3578-9c4d-11ea-93bb-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('fcdad990-20f6-11f0-acf1-2d87a7025b77', 'a18a850a-9c4d-11ea-941a-0a5bf521835e', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('fcdad991-20f6-11f0-acf1-2d87a7025b77', 'a18a850a-9c4d-11ea-941a-0a5bf521835e', 'a18a7fb0-9c4d-11ea-9412-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('fcdb4ec1-20f6-11f0-acf1-2d87a7025b77', 'a18a850a-9c4d-11ea-941a-0a5bf521835e', 'a18a3622-9c4d-11ea-93bc-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('17401df0-f50d-11eb-a95c-45ac352893ba', 'a18a85b4-9c4d-11ea-941b-0a5bf521835e', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('656dc4a0-5467-11ec-bf5f-b354dfc64247', 'a18a85b4-9c4d-11ea-941b-0a5bf521835e', '6b794010-46eb-11ec-bc07-efd394bb365a', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('65ac9da0-7845-11eb-b271-77eecb50c50c', 'a18a85b4-9c4d-11ea-941b-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('83745270-492c-11ec-939f-314f99801403', 'a18a85b4-9c4d-11ea-941b-0a5bf521835e', '8089c406-9c4d-11ea-92cf-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a73271f0-300a-11ec-b791-5b82b17368f0', 'a18a85b4-9c4d-11ea-941b-0a5bf521835e', '80898374-9c4d-11ea-92a0-0a5bf521835e', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d1119a-9c4d-11ea-95d1-0a5bf521835e', 'a18a85b4-9c4d-11ea-941b-0a5bf521835e', 'a18a26c8-9c4d-11ea-93a9-0a5bf521835e', 300, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1d12158-9c4d-11ea-95d2-0a5bf521835e', 'a18a85b4-9c4d-11ea-941b-0a5bf521835e', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1d1411a-9c4d-11ea-95d4-0a5bf521835e', 'a18a85b4-9c4d-11ea-941b-0a5bf521835e', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1d16154-9c4d-11ea-95d6-0a5bf521835e', 'a18a85b4-9c4d-11ea-941b-0a5bf521835e', '8089b3ee-9c4d-11ea-92be-0a5bf521835e', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1d17112-9c4d-11ea-95d7-0a5bf521835e', 'a18a85b4-9c4d-11ea-941b-0a5bf521835e', '8089b312-9c4d-11ea-92bd-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('fbcc5620-80e9-11eb-a07d-432b365e0f0f', 'a18a85b4-9c4d-11ea-941b-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('23ade130-f50d-11eb-8f32-750a66e837fd', 'a18a865e-9c4d-11ea-941c-0a5bf521835e', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('59e27220-5467-11ec-addc-4ff06367e2a8', 'a18a865e-9c4d-11ea-941c-0a5bf521835e', '6b794010-46eb-11ec-bc07-efd394bb365a', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5d46a700-7845-11eb-ad37-09556bb1f395', 'a18a865e-9c4d-11ea-941c-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('99f41840-300a-11ec-b791-5b82b17368f0', 'a18a865e-9c4d-11ea-941c-0a5bf521835e', '80898374-9c4d-11ea-92a0-0a5bf521835e', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d190d4-9c4d-11ea-95d9-0a5bf521835e', 'a18a865e-9c4d-11ea-941c-0a5bf521835e', 'a18a26c8-9c4d-11ea-93a9-0a5bf521835e', 400, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1d1a092-9c4d-11ea-95da-0a5bf521835e', 'a18a865e-9c4d-11ea-941c-0a5bf521835e', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1d1c090-9c4d-11ea-95dc-0a5bf521835e', 'a18a865e-9c4d-11ea-941c-0a5bf521835e', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1d1e020-9c4d-11ea-95de-0a5bf521835e', 'a18a865e-9c4d-11ea-941c-0a5bf521835e', '8089b3ee-9c4d-11ea-92be-0a5bf521835e', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1d1f092-9c4d-11ea-95df-0a5bf521835e', 'a18a865e-9c4d-11ea-941c-0a5bf521835e', '8089b312-9c4d-11ea-92bd-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('efa008b0-80e9-11eb-b7b6-29f989e36bf6', 'a18a865e-9c4d-11ea-941c-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a74870d0-8ec8-11ee-bbb7-6d439f77b2c9', 'a18a8712-9c4d-11ea-941d-0a5bf521835e', '8089d838-9c4d-11ea-92e5-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('a74870d1-8ec8-11ee-bbb7-6d439f77b2c9', 'a18a8712-9c4d-11ea-941d-0a5bf521835e', 'a18a85b4-9c4d-11ea-941b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('09c554a0-236d-11f0-8b17-c9ef36ffc4e8', 'a18a87bc-9c4d-11ea-941e-0a5bf521835e', '8089d838-9c4d-11ea-92e5-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('09c554a2-236d-11f0-8b17-c9ef36ffc4e8', 'a18a87bc-9c4d-11ea-941e-0a5bf521835e', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('09c554a3-236d-11f0-8b17-c9ef36ffc4e8', 'a18a87bc-9c4d-11ea-941e-0a5bf521835e', 'a18a85b4-9c4d-11ea-941b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('6c58b3e0-8ec8-11ee-89c1-731f17c336c3', 'a18a8866-9c4d-11ea-941f-0a5bf521835e', '8089d838-9c4d-11ea-92e5-0a5bf521835e', 140, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('6c58daf0-8ec8-11ee-89c1-731f17c336c3', 'a18a8866-9c4d-11ea-941f-0a5bf521835e', 'a18a865e-9c4d-11ea-941c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('60571ff0-8ec8-11ee-8a5f-8dee2b680a2f', 'a18a8910-9c4d-11ea-9420-0a5bf521835e', '8089d838-9c4d-11ea-92e5-0a5bf521835e', 140, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('60574700-8ec8-11ee-8a5f-8dee2b680a2f', 'a18a8910-9c4d-11ea-9420-0a5bf521835e', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('60574701-8ec8-11ee-8a5f-8dee2b680a2f', 'a18a8910-9c4d-11ea-9420-0a5bf521835e', 'a18a865e-9c4d-11ea-941c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('798421f0-5467-11ec-addc-4ff06367e2a8', 'a18a89c4-9c4d-11ea-9421-0a5bf521835e', '6b794010-46eb-11ec-bc07-efd394bb365a', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d2afb4-9c4d-11ea-95eb-0a5bf521835e', 'a18a89c4-9c4d-11ea-9421-0a5bf521835e', 'a18a2f6a-9c4d-11ea-93b2-0a5bf521835e', 170, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1d2bfd6-9c4d-11ea-95ec-0a5bf521835e', 'a18a89c4-9c4d-11ea-9421-0a5bf521835e', '8089d522-9c4d-11ea-92e3-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1d2cf8a-9c4d-11ea-95ed-0a5bf521835e', 'a18a89c4-9c4d-11ea-9421-0a5bf521835e', '8089b4ca-9c4d-11ea-92bf-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1d2df5c-9c4d-11ea-95ee-0a5bf521835e', 'a18a89c4-9c4d-11ea-9421-0a5bf521835e', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1d30f04-9c4d-11ea-95f1-0a5bf521835e', 'a18a89c4-9c4d-11ea-9421-0a5bf521835e', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ef1474c0-f50c-11eb-a95c-45ac352893ba', 'a18a89c4-9c4d-11ea-9421-0a5bf521835e', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('7139c9a0-5467-11ec-addc-4ff06367e2a8', 'a18a8a6e-9c4d-11ea-9422-0a5bf521835e', '6b794010-46eb-11ec-bc07-efd394bb365a', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d31ef4-9c4d-11ea-95f2-0a5bf521835e', 'a18a8a6e-9c4d-11ea-9422-0a5bf521835e', 'a18a2f6a-9c4d-11ea-93b2-0a5bf521835e', 250, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1d32f48-9c4d-11ea-95f3-0a5bf521835e', 'a18a8a6e-9c4d-11ea-9422-0a5bf521835e', '8089d522-9c4d-11ea-92e3-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1d33f1a-9c4d-11ea-95f4-0a5bf521835e', 'a18a8a6e-9c4d-11ea-9422-0a5bf521835e', '8089b4ca-9c4d-11ea-92bf-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1d34ece-9c4d-11ea-95f5-0a5bf521835e', 'a18a8a6e-9c4d-11ea-9422-0a5bf521835e', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 90, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1d37e6c-9c4d-11ea-95f8-0a5bf521835e', 'a18a8a6e-9c4d-11ea-9422-0a5bf521835e', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('fbe9d370-f50c-11eb-8ccc-17901c63413d', 'a18a8a6e-9c4d-11ea-9422-0a5bf521835e', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d38ec0-9c4d-11ea-95f9-0a5bf521835e', 'a18a8b40-9c4d-11ea-9423-0a5bf521835e', 'a18a89c4-9c4d-11ea-9421-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d39e92-9c4d-11ea-95fa-0a5bf521835e', 'a18a8b40-9c4d-11ea-9423-0a5bf521835e', 'a18a36d6-9c4d-11ea-93bd-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d3ae5a-9c4d-11ea-95fb-0a5bf521835e', 'a18a8c08-9c4d-11ea-9424-0a5bf521835e', 'a18a89c4-9c4d-11ea-9421-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d3bec2-9c4d-11ea-95fc-0a5bf521835e', 'a18a8c08-9c4d-11ea-9424-0a5bf521835e', 'a18a36d6-9c4d-11ea-93bd-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d3ceb2-9c4d-11ea-95fd-0a5bf521835e', 'a18a8c08-9c4d-11ea-9424-0a5bf521835e', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d3de66-9c4d-11ea-95fe-0a5bf521835e', 'a18a8cbc-9c4d-11ea-9425-0a5bf521835e', 'a18a8a6e-9c4d-11ea-9422-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d3ee24-9c4d-11ea-95ff-0a5bf521835e', 'a18a8cbc-9c4d-11ea-9425-0a5bf521835e', 'a18a3780-9c4d-11ea-93be-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d3fe14-9c4d-11ea-9600-0a5bf521835e', 'a18a8d66-9c4d-11ea-9426-0a5bf521835e', 'a18a8a6e-9c4d-11ea-9422-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d4dcd0-9c4d-11ea-9601-0a5bf521835e', 'a18a8d66-9c4d-11ea-9426-0a5bf521835e', 'a18a3780-9c4d-11ea-93be-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d4ec48-9c4d-11ea-9602-0a5bf521835e', 'a18a8d66-9c4d-11ea-9426-0a5bf521835e', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d4fc2e-9c4d-11ea-9603-0a5bf521835e', 'a18a8e1a-9c4d-11ea-9427-0a5bf521835e', 'a18a89c4-9c4d-11ea-9421-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d50c0a-9c4d-11ea-9604-0a5bf521835e', 'a18a8e1a-9c4d-11ea-9427-0a5bf521835e', 'a18a382a-9c4d-11ea-93bf-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('096ecf30-2378-11f0-bb68-a1d2c971872e', 'a18a8ece-9c4d-11ea-9428-0a5bf521835e', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('096ecf31-2378-11f0-bb68-a1d2c971872e', 'a18a8ece-9c4d-11ea-9428-0a5bf521835e', 'a18a89c4-9c4d-11ea-9421-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('096ecf33-2378-11f0-bb68-a1d2c971872e', 'a18a8ece-9c4d-11ea-9428-0a5bf521835e', 'a18a382a-9c4d-11ea-93bf-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d54ad0-9c4d-11ea-9608-0a5bf521835e', 'a18a8fa0-9c4d-11ea-9429-0a5bf521835e', 'a18a8a6e-9c4d-11ea-9422-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d55a52-9c4d-11ea-9609-0a5bf521835e', 'a18a8fa0-9c4d-11ea-9429-0a5bf521835e', 'a18a38d4-9c4d-11ea-93c0-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d569de-9c4d-11ea-960a-0a5bf521835e', 'a18a904a-9c4d-11ea-942a-0a5bf521835e', 'a18a8a6e-9c4d-11ea-9422-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d57992-9c4d-11ea-960b-0a5bf521835e', 'a18a904a-9c4d-11ea-942a-0a5bf521835e', 'a18a38d4-9c4d-11ea-93c0-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d5890a-9c4d-11ea-960c-0a5bf521835e', 'a18a904a-9c4d-11ea-942a-0a5bf521835e', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d59922-9c4d-11ea-960d-0a5bf521835e', 'a18a90f4-9c4d-11ea-942b-0a5bf521835e', 'a18a89c4-9c4d-11ea-9421-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d5a8b8-9c4d-11ea-960e-0a5bf521835e', 'a18a90f4-9c4d-11ea-942b-0a5bf521835e', 'a18a3988-9c4d-11ea-93c1-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d5b876-9c4d-11ea-960f-0a5bf521835e', 'a18a919e-9c4d-11ea-942c-0a5bf521835e', 'a18a89c4-9c4d-11ea-9421-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d5c816-9c4d-11ea-9610-0a5bf521835e', 'a18a919e-9c4d-11ea-942c-0a5bf521835e', 'a18a3988-9c4d-11ea-93c1-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d5d7a2-9c4d-11ea-9611-0a5bf521835e', 'a18a919e-9c4d-11ea-942c-0a5bf521835e', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d5e76a-9c4d-11ea-9612-0a5bf521835e', 'a18a9252-9c4d-11ea-942d-0a5bf521835e', 'a18a8a6e-9c4d-11ea-9422-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d5f750-9c4d-11ea-9613-0a5bf521835e', 'a18a9252-9c4d-11ea-942d-0a5bf521835e', 'a18a3a32-9c4d-11ea-93c2-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d60a88-9c4d-11ea-9614-0a5bf521835e', 'a18a9306-9c4d-11ea-942e-0a5bf521835e', 'a18a8a6e-9c4d-11ea-9422-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d61a64-9c4d-11ea-9615-0a5bf521835e', 'a18a9306-9c4d-11ea-942e-0a5bf521835e', 'a18a3a32-9c4d-11ea-93c2-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d62a22-9c4d-11ea-9616-0a5bf521835e', 'a18a9306-9c4d-11ea-942e-0a5bf521835e', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d63abc-9c4d-11ea-9617-0a5bf521835e', 'a18a96d0-9c4d-11ea-942f-0a5bf521835e', 'a18a89c4-9c4d-11ea-9421-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d64a8e-9c4d-11ea-9618-0a5bf521835e', 'a18a96d0-9c4d-11ea-942f-0a5bf521835e', 'a18a3ae6-9c4d-11ea-93c3-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d66e06-9c4d-11ea-9619-0a5bf521835e', 'a18a97b6-9c4d-11ea-9430-0a5bf521835e', 'a18a89c4-9c4d-11ea-9421-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d67e32-9c4d-11ea-961a-0a5bf521835e', 'a18a97b6-9c4d-11ea-9430-0a5bf521835e', 'a18a3ae6-9c4d-11ea-93c3-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d68e5e-9c4d-11ea-961b-0a5bf521835e', 'a18a97b6-9c4d-11ea-9430-0a5bf521835e', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d69e30-9c4d-11ea-961c-0a5bf521835e', 'a18a9874-9c4d-11ea-9431-0a5bf521835e', 'a18a8a6e-9c4d-11ea-9422-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d6add0-9c4d-11ea-961d-0a5bf521835e', 'a18a9874-9c4d-11ea-9431-0a5bf521835e', 'a18a3b90-9c4d-11ea-93c4-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d6bda2-9c4d-11ea-961e-0a5bf521835e', 'a18a991e-9c4d-11ea-9432-0a5bf521835e', 'a18a8a6e-9c4d-11ea-9422-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d6ce00-9c4d-11ea-961f-0a5bf521835e', 'a18a991e-9c4d-11ea-9432-0a5bf521835e', 'a18a3b90-9c4d-11ea-93c4-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d6ddc8-9c4d-11ea-9620-0a5bf521835e', 'a18a991e-9c4d-11ea-9432-0a5bf521835e', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('4217d660-e480-11ef-9c1d-e1569f3a4a72', 'a18a99c8-9c4d-11ea-9433-0a5bf521835e', '8089b696-9c4d-11ea-92c1-0a5bf521835e', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('4217d661-e480-11ef-9c1d-e1569f3a4a72', 'a18a99c8-9c4d-11ea-9433-0a5bf521835e', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('4217d662-e480-11ef-9c1d-e1569f3a4a72', 'a18a99c8-9c4d-11ea-9433-0a5bf521835e', '8089b4ca-9c4d-11ea-92bf-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('4217d663-e480-11ef-9c1d-e1569f3a4a72', 'a18a99c8-9c4d-11ea-9433-0a5bf521835e', '8089b312-9c4d-11ea-92bd-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('4217d664-e480-11ef-9c1d-e1569f3a4a72', 'a18a99c8-9c4d-11ea-9433-0a5bf521835e', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('4217fd70-e480-11ef-9c1d-e1569f3a4a72', 'a18a99c8-9c4d-11ea-9433-0a5bf521835e', 'a18a2f6a-9c4d-11ea-93b2-0a5bf521835e', 170, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('4217fd71-e480-11ef-9c1d-e1569f3a4a72', 'a18a99c8-9c4d-11ea-9433-0a5bf521835e', 'e902d420-2d90-11ec-ac7d-edfd3dbf0302', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('4217fd72-e480-11ef-9c1d-e1569f3a4a72', 'a18a99c8-9c4d-11ea-9433-0a5bf521835e', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('63dba2e0-e480-11ef-9c1d-e1569f3a4a72', 'a18a9a72-9c4d-11ea-9434-0a5bf521835e', '8089b696-9c4d-11ea-92c1-0a5bf521835e', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('63dba2e1-e480-11ef-9c1d-e1569f3a4a72', 'a18a9a72-9c4d-11ea-9434-0a5bf521835e', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('63dbc9f0-e480-11ef-9c1d-e1569f3a4a72', 'a18a9a72-9c4d-11ea-9434-0a5bf521835e', '8089b4ca-9c4d-11ea-92bf-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('63dbc9f1-e480-11ef-9c1d-e1569f3a4a72', 'a18a9a72-9c4d-11ea-9434-0a5bf521835e', '8089b312-9c4d-11ea-92bd-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('63dbc9f2-e480-11ef-9c1d-e1569f3a4a72', 'a18a9a72-9c4d-11ea-9434-0a5bf521835e', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('63dbc9f3-e480-11ef-9c1d-e1569f3a4a72', 'a18a9a72-9c4d-11ea-9434-0a5bf521835e', 'a18a2f6a-9c4d-11ea-93b2-0a5bf521835e', 250, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('63dbc9f4-e480-11ef-9c1d-e1569f3a4a72', 'a18a9a72-9c4d-11ea-9434-0a5bf521835e', 'e902d420-2d90-11ec-ac7d-edfd3dbf0302', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('63dbc9f5-e480-11ef-9c1d-e1569f3a4a72', 'a18a9a72-9c4d-11ea-9434-0a5bf521835e', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d7cc1a-9c4d-11ea-962f-0a5bf521835e', 'a18a9b26-9c4d-11ea-9435-0a5bf521835e', 'a18a99c8-9c4d-11ea-9433-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1d7eb8c-9c4d-11ea-9631-0a5bf521835e', 'a18a9b26-9c4d-11ea-9435-0a5bf521835e', '8089d838-9c4d-11ea-92e5-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('e24c1820-9395-11eb-aba7-4f9745baecec', 'a18a9b26-9c4d-11ea-9435-0a5bf521835e', 'cfb73310-9387-11eb-b551-3d9be8d1c5c7', 3, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('870aed00-21db-11f0-8e38-472558b3b72f', 'a18a9bda-9c4d-11ea-9436-0a5bf521835e', '1541beb0-21db-11f0-ac69-4ff8f2877233', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('870aed02-21db-11f0-8e38-472558b3b72f', 'a18a9bda-9c4d-11ea-9436-0a5bf521835e', '8089d838-9c4d-11ea-92e5-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('870b1410-21db-11f0-8e38-472558b3b72f', 'a18a9bda-9c4d-11ea-9436-0a5bf521835e', 'a18a466c-9c4d-11ea-93d4-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('870b1411-21db-11f0-8e38-472558b3b72f', 'a18a9bda-9c4d-11ea-9436-0a5bf521835e', 'cfb73310-9387-11eb-b551-3d9be8d1c5c7', 3, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('870b1413-21db-11f0-8e38-472558b3b72f', 'a18a9bda-9c4d-11ea-9436-0a5bf521835e', 'a18a99c8-9c4d-11ea-9433-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('561cce90-e480-11ef-ae90-c77ba71d6e00', 'a18a9d2e-9c4d-11ea-9438-0a5bf521835e', '8089d838-9c4d-11ea-92e5-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('561cce92-e480-11ef-ae90-c77ba71d6e00', 'a18a9d2e-9c4d-11ea-9438-0a5bf521835e', 'a18a4716-9c4d-11ea-93d5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('561cf5a0-e480-11ef-ae90-c77ba71d6e00', 'a18a9d2e-9c4d-11ea-9438-0a5bf521835e', 'cfb73310-9387-11eb-b551-3d9be8d1c5c7', 6, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('561cf5a2-e480-11ef-ae90-c77ba71d6e00', 'a18a9d2e-9c4d-11ea-9438-0a5bf521835e', 'a18a9a72-9c4d-11ea-9434-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('229b0880-21dd-11f0-953f-0dfe025424db', 'a18a9ea0-9c4d-11ea-943a-0a5bf521835e', '1541beb0-21db-11f0-ac69-4ff8f2877233', 4, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('229b0882-21dd-11f0-953f-0dfe025424db', 'a18a9ea0-9c4d-11ea-943a-0a5bf521835e', 'a18a466c-9c4d-11ea-93d4-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('229b0883-21dd-11f0-953f-0dfe025424db', 'a18a9ea0-9c4d-11ea-943a-0a5bf521835e', 'cfb73310-9387-11eb-b551-3d9be8d1c5c7', 3, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('229b0885-21dd-11f0-953f-0dfe025424db', 'a18a9ea0-9c4d-11ea-943a-0a5bf521835e', 'a18a99c8-9c4d-11ea-9433-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d8f6f8-9c4d-11ea-9642-0a5bf521835e', 'a18a9f54-9c4d-11ea-943b-0a5bf521835e', 'a18a9a72-9c4d-11ea-9434-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d93f9ec0-9389-11eb-b551-3d9be8d1c5c7', 'a18a9f54-9c4d-11ea-943b-0a5bf521835e', 'cfb73310-9387-11eb-b551-3d9be8d1c5c7', 6, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d9167e-9c4d-11ea-9644-0a5bf521835e', 'a18a9ffe-9c4d-11ea-943c-0a5bf521835e', 'a18a9a72-9c4d-11ea-9434-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1d935be-9c4d-11ea-9646-0a5bf521835e', 'a18a9ffe-9c4d-11ea-943c-0a5bf521835e', 'a18a4716-9c4d-11ea-93d5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('e596f3d0-9389-11eb-b551-3d9be8d1c5c7', 'a18a9ffe-9c4d-11ea-943c-0a5bf521835e', 'cfb73310-9387-11eb-b551-3d9be8d1c5c7', 6, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('95544300-87e5-11eb-b96f-7177973d12e2', 'a18aa0b2-9c4d-11ea-943d-0a5bf521835e', '8089b920-9c4d-11ea-92c4-0a5bf521835e', 35, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1d945fe-9c4d-11ea-9647-0a5bf521835e', 'a18aa0b2-9c4d-11ea-943d-0a5bf521835e', '8089af7a-9c4d-11ea-92b9-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1d955c6-9c4d-11ea-9648-0a5bf521835e', 'a18aa0b2-9c4d-11ea-943d-0a5bf521835e', '8089ce24-9c4d-11ea-92db-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9bf9c650-84a6-11ef-935c-936b2828bb6b', 'a18aa8fa-9c4d-11ea-9449-0a5bf521835e', '8089c0aa-9c4d-11ea-92cb-0a5bf521835e', 1700, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9bf9c651-84a6-11ef-935c-936b2828bb6b', 'a18aa8fa-9c4d-11ea-9449-0a5bf521835e', '8089cfdc-9c4d-11ea-92dd-0a5bf521835e', 1550, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9bf9ed60-84a6-11ef-935c-936b2828bb6b', 'a18aa8fa-9c4d-11ea-9449-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9bf9ed61-84a6-11ef-935c-936b2828bb6b', 'a18aa8fa-9c4d-11ea-9449-0a5bf521835e', '80899b48-9c4d-11ea-92a2-0a5bf521835e', 680, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9bf9ed62-84a6-11ef-935c-936b2828bb6b', 'a18aa8fa-9c4d-11ea-9449-0a5bf521835e', '8089d522-9c4d-11ea-92e3-0a5bf521835e', 340, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9bf9ed63-84a6-11ef-935c-936b2828bb6b', 'a18aa8fa-9c4d-11ea-9449-0a5bf521835e', '8089b772-9c4d-11ea-92c2-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1dcefba-9c4d-11ea-9682-0a5bf521835e', 'a18aa9ae-9c4d-11ea-944a-0a5bf521835e', 'a18aa8fa-9c4d-11ea-9449-0a5bf521835e', 170, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1dcff64-9c4d-11ea-9683-0a5bf521835e', 'a18aa9ae-9c4d-11ea-944a-0a5bf521835e', '8089a2b4-9c4d-11ea-92aa-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d5066b00-9bbb-11ec-ae00-d1675697e7e3', 'a18aa9ae-9c4d-11ea-944a-0a5bf521835e', '808926cc-9c4d-11ea-9268-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1dd1ee0-9c4d-11ea-9685-0a5bf521835e', 'a18aaa58-9c4d-11ea-944b-0a5bf521835e', 'a18aa8fa-9c4d-11ea-9449-0a5bf521835e', 170, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1dd2ec6-9c4d-11ea-9686-0a5bf521835e', 'a18aaa58-9c4d-11ea-944b-0a5bf521835e', 'a18a40f4-9c4d-11ea-93cc-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('15e42880-e53b-11ef-b97d-910876679500', 'a18aabc0-9c4d-11ea-944d-0a5bf521835e', 'a18a404a-9c4d-11ea-93cb-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('15e44f90-e53b-11ef-b97d-910876679500', 'a18aabc0-9c4d-11ea-944d-0a5bf521835e', '80892032-9c4d-11ea-9260-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('15e44f91-e53b-11ef-b97d-910876679500', 'a18aabc0-9c4d-11ea-944d-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('15e44f93-e53b-11ef-b97d-910876679500', 'a18aabc0-9c4d-11ea-944d-0a5bf521835e', '8089cf00-9c4d-11ea-92dc-0a5bf521835e', 5, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5b175760-874d-11eb-b06e-f714206729cb', 'a18aade6-9c4d-11ea-9450-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 20, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1ddbd50-9c4d-11ea-968f-0a5bf521835e', 'a18aade6-9c4d-11ea-9450-0a5bf521835e', '80893de2-9c4d-11ea-9283-0a5bf521835e', 250, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1dddcb8-9c4d-11ea-9691-0a5bf521835e', 'a18aade6-9c4d-11ea-9450-0a5bf521835e', '8089a2b4-9c4d-11ea-92aa-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('67bdb6d0-874d-11eb-b06e-f714206729cb', 'a18aae9a-9c4d-11ea-9451-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 20, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1ddec8a-9c4d-11ea-9692-0a5bf521835e', 'a18aae9a-9c4d-11ea-9451-0a5bf521835e', '80893de2-9c4d-11ea-9283-0a5bf521835e', 250, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1ddfc3e-9c4d-11ea-9693-0a5bf521835e', 'a18aae9a-9c4d-11ea-9451-0a5bf521835e', 'a18a40f4-9c4d-11ea-93cc-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1de0bde-9c4d-11ea-9694-0a5bf521835e', 'a18aaf4e-9c4d-11ea-9452-0a5bf521835e', '8089c690-9c4d-11ea-92d2-0a5bf521835e', 38, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1de2baa-9c4d-11ea-9696-0a5bf521835e', 'a18ab142-9c4d-11ea-9453-0a5bf521835e', '8089c690-9c4d-11ea-92d2-0a5bf521835e', 38, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1de3b7c-9c4d-11ea-9697-0a5bf521835e', 'a18ab142-9c4d-11ea-9453-0a5bf521835e', 'a18a42fc-9c4d-11ea-93cf-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('4d5dbf50-9f68-11f0-91d5-9b05ac486625', 'a18ab372-9c4d-11ea-9456-0a5bf521835e', 'a18a491e-9c4d-11ea-93d8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('4d5dbf51-9f68-11f0-91d5-9b05ac486625', 'a18ab372-9c4d-11ea-9456-0a5bf521835e', 'a18a4874-9c4d-11ea-93d7-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('4d5dbf52-9f68-11f0-91d5-9b05ac486625', 'a18ab372-9c4d-11ea-9456-0a5bf521835e', '808943f0-9c4d-11ea-928a-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('4d5dbf54-9f68-11f0-91d5-9b05ac486625', 'a18ab372-9c4d-11ea-9456-0a5bf521835e', 'b59ccca0-349c-11f0-9650-152532a65f04', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7c3fc250-8f6b-11ee-924f-01ca33225705', 'a18ab426-9c4d-11ea-9457-0a5bf521835e', '5bd9afd0-4e2a-11ee-8d17-29eec0ef8ef1', 91, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7c3fc251-8f6b-11ee-924f-01ca33225705', 'a18ab426-9c4d-11ea-9457-0a5bf521835e', '8089b9f2-9c4d-11ea-92c5-0a5bf521835e', 4.6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1dece2a-9c4d-11ea-96a0-0a5bf521835e', 'a18abe3a-9c4d-11ea-9458-0a5bf521835e', 'a18ab426-9c4d-11ea-9457-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1deddde-9c4d-11ea-96a1-0a5bf521835e', 'a18abe3a-9c4d-11ea-9458-0a5bf521835e', 'a18a4874-9c4d-11ea-93d7-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1deed88-9c4d-11ea-96a2-0a5bf521835e', 'a18abeee-9c4d-11ea-9459-0a5bf521835e', 'a18ab426-9c4d-11ea-9457-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1defd82-9c4d-11ea-96a3-0a5bf521835e', 'a18abeee-9c4d-11ea-9459-0a5bf521835e', 'a18a491e-9c4d-11ea-93d8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1df0df4-9c4d-11ea-96a4-0a5bf521835e', 'a18abfa2-9c4d-11ea-945a-0a5bf521835e', '808944cc-9c4d-11ea-928b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1df1dd0-9c4d-11ea-96a5-0a5bf521835e', 'a18abfa2-9c4d-11ea-945a-0a5bf521835e', '80891f2e-9c4d-11ea-925f-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1df2dd4-9c4d-11ea-96a6-0a5bf521835e', 'a18ac056-9c4d-11ea-945b-0a5bf521835e', '80896f06-9c4d-11ea-928c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1df44c2-9c4d-11ea-96a7-0a5bf521835e', 'a18ac056-9c4d-11ea-945b-0a5bf521835e', '80891f2e-9c4d-11ea-925f-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1df5520-9c4d-11ea-96a8-0a5bf521835e', 'a18ac10a-9c4d-11ea-945c-0a5bf521835e', '8089408a-9c4d-11ea-9286-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1df965c-9c4d-11ea-96a9-0a5bf521835e', 'a18ac10a-9c4d-11ea-945c-0a5bf521835e', '80894170-9c4d-11ea-9287-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1dfa73c-9c4d-11ea-96aa-0a5bf521835e', 'a18ac1be-9c4d-11ea-945d-0a5bf521835e', 'a18ac10a-9c4d-11ea-945c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1dfb72c-9c4d-11ea-96ab-0a5bf521835e', 'a18ac1be-9c4d-11ea-945d-0a5bf521835e', '80894328-9c4d-11ea-9289-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1dfc6cc-9c4d-11ea-96ac-0a5bf521835e', 'a18ac272-9c4d-11ea-945e-0a5bf521835e', 'a18ac10a-9c4d-11ea-945c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1dfd694-9c4d-11ea-96ad-0a5bf521835e', 'a18ac272-9c4d-11ea-945e-0a5bf521835e', '80894328-9c4d-11ea-9289-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1dfe670-9c4d-11ea-96ae-0a5bf521835e', 'a18ac272-9c4d-11ea-945e-0a5bf521835e', '80892032-9c4d-11ea-9260-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1dff6d8-9c4d-11ea-96af-0a5bf521835e', 'a18ac326-9c4d-11ea-945f-0a5bf521835e', '80893f90-9c4d-11ea-9285-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1e006c8-9c4d-11ea-96b0-0a5bf521835e', 'a18ac326-9c4d-11ea-945f-0a5bf521835e', '80894170-9c4d-11ea-9287-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1e0169a-9c4d-11ea-96b1-0a5bf521835e', 'a18ac3da-9c4d-11ea-9460-0a5bf521835e', 'a18ac326-9c4d-11ea-945f-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1e02644-9c4d-11ea-96b2-0a5bf521835e', 'a18ac3da-9c4d-11ea-9460-0a5bf521835e', '80894328-9c4d-11ea-9289-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1e035ee-9c4d-11ea-96b3-0a5bf521835e', 'a18ac484-9c4d-11ea-9461-0a5bf521835e', 'a18ac326-9c4d-11ea-945f-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1e045e8-9c4d-11ea-96b4-0a5bf521835e', 'a18ac484-9c4d-11ea-9461-0a5bf521835e', '80894328-9c4d-11ea-9289-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1e055a6-9c4d-11ea-96b5-0a5bf521835e', 'a18ac484-9c4d-11ea-9461-0a5bf521835e', '80892032-9c4d-11ea-9260-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1e06550-9c4d-11ea-96b6-0a5bf521835e', 'a18ac538-9c4d-11ea-9462-0a5bf521835e', '808971ae-9c4d-11ea-928f-0a5bf521835e', 83, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1e07540-9c4d-11ea-96b7-0a5bf521835e', 'a18ac538-9c4d-11ea-9462-0a5bf521835e', '80893ec8-9c4d-11ea-9284-0a5bf521835e', 8.5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1e084fe-9c4d-11ea-96b8-0a5bf521835e', 'a18ac538-9c4d-11ea-9462-0a5bf521835e', '8089bace-9c4d-11ea-92c6-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1e09566-9c4d-11ea-96b9-0a5bf521835e', 'a18ac628-9c4d-11ea-9463-0a5bf521835e', 'a18ac538-9c4d-11ea-9462-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1e0a524-9c4d-11ea-96ba-0a5bf521835e', 'a18ac628-9c4d-11ea-9463-0a5bf521835e', '80897d8e-9c4d-11ea-929a-0a5bf521835e', 8.5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1e0b4d8-9c4d-11ea-96bb-0a5bf521835e', 'a18ac628-9c4d-11ea-9463-0a5bf521835e', 'a18a4874-9c4d-11ea-93d7-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1e0c4a0-9c4d-11ea-96bc-0a5bf521835e', 'a18ac6e6-9c4d-11ea-9464-0a5bf521835e', 'a18ac538-9c4d-11ea-9462-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1e0d472-9c4d-11ea-96bd-0a5bf521835e', 'a18ac6e6-9c4d-11ea-9464-0a5bf521835e', '80897d8e-9c4d-11ea-929a-0a5bf521835e', 8.5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1e0e444-9c4d-11ea-96be-0a5bf521835e', 'a18ac6e6-9c4d-11ea-9464-0a5bf521835e', 'a18a491e-9c4d-11ea-93d8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1e0f3ee-9c4d-11ea-96bf-0a5bf521835e', 'a18ac79a-9c4d-11ea-9465-0a5bf521835e', 'a18ac538-9c4d-11ea-9462-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1e103b6-9c4d-11ea-96c0-0a5bf521835e', 'a18ac79a-9c4d-11ea-9465-0a5bf521835e', '808943f0-9c4d-11ea-928a-0a5bf521835e', 16.5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1e113a6-9c4d-11ea-96c1-0a5bf521835e', 'a18ac79a-9c4d-11ea-9465-0a5bf521835e', 'a18a4874-9c4d-11ea-93d7-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1e12382-9c4d-11ea-96c2-0a5bf521835e', 'a18ac84e-9c4d-11ea-9466-0a5bf521835e', 'a18ac538-9c4d-11ea-9462-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1e133f4-9c4d-11ea-96c3-0a5bf521835e', 'a18ac84e-9c4d-11ea-9466-0a5bf521835e', '808943f0-9c4d-11ea-928a-0a5bf521835e', 16.5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1e143c6-9c4d-11ea-96c4-0a5bf521835e', 'a18ac84e-9c4d-11ea-9466-0a5bf521835e', 'a18a491e-9c4d-11ea-93d8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5421da80-edf4-11eb-8fb0-df4c06cfdb0d', 'a18ac902-9c4d-11ea-9467-0a5bf521835e', '2dbdce80-8805-11eb-b96f-7177973d12e2', 20, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1e153ac-9c4d-11ea-96c5-0a5bf521835e', 'a18ac902-9c4d-11ea-9467-0a5bf521835e', '8089b920-9c4d-11ea-92c4-0a5bf521835e', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5fac32f0-a8e5-11eb-a511-a582f5c4cbb1', 'a18acbc8-9c4d-11ea-946b-0a5bf521835e', '2dbdce80-8805-11eb-b96f-7177973d12e2', 10, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1e1e290-9c4d-11ea-96ce-0a5bf521835e', 'a18acbc8-9c4d-11ea-946b-0a5bf521835e', '8089a7fa-9c4d-11ea-92b0-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1e20298-9c4d-11ea-96d0-0a5bf521835e', 'a18acbc8-9c4d-11ea-946b-0a5bf521835e', 'a18a47ca-9c4d-11ea-93d6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e9761280-c44c-11eb-933b-0fde1972ba99', 'a18acbc8-9c4d-11ea-946b-0a5bf521835e', '80897bea-9c4d-11ea-9298-0a5bf521835e', 13, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('75521dd0-21d2-11f0-8b95-0ba6cd1a2e00', 'a18acc7c-9c4d-11ea-946c-0a5bf521835e', '80897a3c-9c4d-11ea-9296-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('75521dd2-21d2-11f0-8b95-0ba6cd1a2e00', 'a18acc7c-9c4d-11ea-946c-0a5bf521835e', '0e8b62f0-21d2-11f0-840c-7186b075b488', 20, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('75521dd4-21d2-11f0-8b95-0ba6cd1a2e00', 'a18acc7c-9c4d-11ea-946c-0a5bf521835e', 'a18a47ca-9c4d-11ea-93d6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('65094e70-88bc-11eb-9522-1dda16a44fe7', 'a18acd30-9c4d-11ea-946d-0a5bf521835e', '2dbdce80-8805-11eb-b96f-7177973d12e2', 10, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1e231d2-9c4d-11ea-96d3-0a5bf521835e', 'a18acd30-9c4d-11ea-946d-0a5bf521835e', 'a18acbc8-9c4d-11ea-946b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1e26152-9c4d-11ea-96d6-0a5bf521835e', 'a18acdee-9c4d-11ea-946e-0a5bf521835e', 'a18acbc8-9c4d-11ea-946b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1e27228-9c4d-11ea-96d7-0a5bf521835e', 'a18acdee-9c4d-11ea-946e-0a5bf521835e', '80897d8e-9c4d-11ea-929a-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1e2a1a8-9c4d-11ea-96da-0a5bf521835e', 'a18ace98-9c4d-11ea-946f-0a5bf521835e', 'a18acbc8-9c4d-11ea-946b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1e2b166-9c4d-11ea-96db-0a5bf521835e', 'a18ace98-9c4d-11ea-946f-0a5bf521835e', '80897e56-9c4d-11ea-929b-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1e2c12e-9c4d-11ea-96dc-0a5bf521835e', 'a18acf56-9c4d-11ea-9470-0a5bf521835e', 'a18acc7c-9c4d-11ea-946c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1e2d0f6-9c4d-11ea-96dd-0a5bf521835e', 'a18acf56-9c4d-11ea-9470-0a5bf521835e', '8089bd76-9c4d-11ea-92c9-0a5bf521835e', 24, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1e2e0d2-9c4d-11ea-96de-0a5bf521835e', 'a18ad00a-9c4d-11ea-9471-0a5bf521835e', 'a18acc7c-9c4d-11ea-946c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1e2f09a-9c4d-11ea-96df-0a5bf521835e', 'a18ad00a-9c4d-11ea-9471-0a5bf521835e', '8089bc9a-9c4d-11ea-92c8-0a5bf521835e', 24, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('604af430-fe6d-11ef-9f24-3dea27761cfa', 'a18ad0be-9c4d-11ea-9472-0a5bf521835e', '80892b22-9c4d-11ea-926d-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('604af431-fe6d-11ef-9f24-3dea27761cfa', 'a18ad0be-9c4d-11ea-9472-0a5bf521835e', '8089751e-9c4d-11ea-9293-0a5bf521835e', 7, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('604af433-fe6d-11ef-9f24-3dea27761cfa', 'a18ad0be-9c4d-11ea-9472-0a5bf521835e', '8089b844-9c4d-11ea-92c3-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1e241a4-9c4d-11ea-96d4-0a5bf521835e', 'a18ad582-9c4d-11ea-9476-0a5bf521835e', 'a18a3d98-9c4d-11ea-93c7-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1e28218-9c4d-11ea-96d8-0a5bf521835e', 'a18ad640-9c4d-11ea-9477-0a5bf521835e', '80898022-9c4d-11ea-929d-0a5bf521835e', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1e291f4-9c4d-11ea-96d9-0a5bf521835e', 'a18ad6f4-9c4d-11ea-9478-0a5bf521835e', '808981d0-9c4d-11ea-929e-0a5bf521835e', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a1949f70-2393-11ed-a94a-933a73b178be', 'a192cab0-2393-11ed-a94a-933a73b178be', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 9, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a1949f71-2393-11ed-a94a-933a73b178be', 'a192cab0-2393-11ed-a94a-933a73b178be', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 11, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a1949f72-2393-11ed-a94a-933a73b178be', 'a192cab0-2393-11ed-a94a-933a73b178be', '08727600-be21-11ec-bc2e-4d33dd81b98a', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a1949f73-2393-11ed-a94a-933a73b178be', 'a192cab0-2393-11ed-a94a-933a73b178be', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a194c680-2393-11ed-a94a-933a73b178be', 'a192cab0-2393-11ed-a94a-933a73b178be', '8089b696-9c4d-11ea-92c1-0a5bf521835e', 1, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a194c681-2393-11ed-a94a-933a73b178be', 'a192cab0-2393-11ed-a94a-933a73b178be', '80899c4c-9c4d-11ea-92a3-0a5bf521835e', 9, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('92c84130-11bb-11f1-94ae-f304d9684582', 'a32565b0-117c-11f1-a108-496d87d5c077', '80892032-9c4d-11ea-9260-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('92c84131-11bb-11f1-94ae-f304d9684582', 'a32565b0-117c-11f1-a108-496d87d5c077', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('92c84133-11bb-11f1-94ae-f304d9684582', 'a32565b0-117c-11f1-a108-496d87d5c077', '6ed90490-b1fa-11ed-8398-4d566f64bec9', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('92c84135-11bb-11f1-94ae-f304d9684582', 'a32565b0-117c-11f1-a108-496d87d5c077', '09c960e0-117e-11f1-ae64-1f8e3f56f901', 300, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('72832eb0-b8d5-11f0-b6fe-43cc2133c362', 'a48c7a10-c885-11ef-8a4d-17c77f3f8f34', 'f0f73b30-b8d3-11f0-8023-f50462a02790', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('934092a0-b815-11ed-bc1a-53d6e629924d', 'a5b09760-55c7-11ed-b50c-474f649a5bc5', 'a18a2cae-9c4d-11ea-93ae-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a5b15ab0-55c7-11ed-b50c-474f649a5bc5', 'a5b09760-55c7-11ed-b50c-474f649a5bc5', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a5b181c0-55c7-11ed-b50c-474f649a5bc5', 'a5b09760-55c7-11ed-b50c-474f649a5bc5', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('a5b181c1-55c7-11ed-b50c-474f649a5bc5', 'a5b09760-55c7-11ed-b50c-474f649a5bc5', 'e760b460-4790-11ec-939f-314f99801403', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a5b181c2-55c7-11ed-b50c-474f649a5bc5', 'a5b09760-55c7-11ed-b50c-474f649a5bc5', '80899ef4-9c4d-11ea-92a6-0a5bf521835e', 200, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('fd34f5a0-b739-11ef-af32-d773254a9d2d', 'a6d20cd0-b738-11ef-9837-1733243488a6', '8089bc9a-9c4d-11ea-92c8-0a5bf521835e', 24, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a6d90d40-be26-11ec-bc2e-4d33dd81b98a', 'a6d8bf20-be26-11ec-bc2e-4d33dd81b98a', '0d161320-1baf-11ec-9cd0-53f06f053e40', 1, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a6d93450-be26-11ec-bc2e-4d33dd81b98a', 'a6d8bf20-be26-11ec-bc2e-4d33dd81b98a', '8089c406-9c4d-11ea-92cf-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('a729e2e0-d5c0-11ec-b2e2-5dd84dabb8a8', 'a72946a0-d5c0-11ec-b2e2-5dd84dabb8a8', '5a322000-c158-11ec-9265-d57037e66861', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('a729e2e1-d5c0-11ec-b2e2-5dd84dabb8a8', 'a72946a0-d5c0-11ec-b2e2-5dd84dabb8a8', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('a7f12cb0-307d-11ee-af48-fb839ee61b42', 'a7bbc4d0-307d-11ee-af48-fb839ee61b42', 'a18a694e-9c4d-11ea-93ff-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('a7f12cb1-307d-11ee-af48-fb839ee61b42', 'a7bbc4d0-307d-11ee-af48-fb839ee61b42', 'a18a69f8-9c4d-11ea-9400-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a804a8f0-fb05-11ee-b163-25d7673ac736', 'a802ad20-fb05-11ee-b163-25d7673ac736', 'cab47370-9316-11ec-bdf2-dbb798a33559', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('a8920b20-307e-11ee-af48-fb839ee61b42', 'a86d9330-307e-11ee-af48-fb839ee61b42', '82d3e2ee-1a03-11eb-accb-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('a8c76110-3080-11ee-af48-fb839ee61b42', 'a89f66b0-3080-11ee-af48-fb839ee61b42', 'aeff8c4e-19d9-11eb-a885-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('a94135e0-3089-11ee-af48-fb839ee61b42', 'a9076130-3089-11ee-af48-fb839ee61b42', '959ac860-c156-11ec-a2ba-7bb1dc10361f', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('a9415cf0-3089-11ee-af48-fb839ee61b42', 'a9076130-3089-11ee-af48-fb839ee61b42', '17a8ac50-d5c0-11ec-a670-e7c04af67adb', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('a9ace8a0-308c-11ee-af48-fb839ee61b42', 'a96f1c50-308c-11ee-af48-fb839ee61b42', 'a18a9252-9c4d-11ea-942d-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('a9ad0fb0-308c-11ee-af48-fb839ee61b42', 'a96f1c50-308c-11ee-af48-fb839ee61b42', 'a18a9306-9c4d-11ea-942e-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('a9b06180-3080-11ee-af48-fb839ee61b42', 'a98a14d0-3080-11ee-af48-fb839ee61b42', 'a18acc7c-9c4d-11ea-946c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d84dbcb0-c88a-11ef-a93e-5bccff2f221f', 'a9fa7cb0-d6ee-11ee-8099-878d940648e3', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d84de3c0-c88a-11ef-a93e-5bccff2f221f', 'a9fa7cb0-d6ee-11ee-8099-878d940648e3', '80893d1a-9c4d-11ea-9282-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d84e0ad0-c88a-11ef-a93e-5bccff2f221f', 'a9fa7cb0-d6ee-11ee-8099-878d940648e3', 'a18a26c8-9c4d-11ea-93a9-0a5bf521835e', 300, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d84e0ad1-c88a-11ef-a93e-5bccff2f221f', 'a9fa7cb0-d6ee-11ee-8099-878d940648e3', '374bc7e0-f306-11ed-b0fa-47c95be3e3ca', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d84e0ad2-c88a-11ef-a93e-5bccff2f221f', 'a9fa7cb0-d6ee-11ee-8099-878d940648e3', '6ed90490-b1fa-11ed-8398-4d566f64bec9', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d84e0ad3-c88a-11ef-a93e-5bccff2f221f', 'a9fa7cb0-d6ee-11ee-8099-878d940648e3', '784d06a0-8487-11ef-8ef8-37c5596a9593', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('760e8820-9d25-11f0-b494-179041587982', 'aa30a470-fb76-11ec-a176-d902a1918d35', 'a18acc7c-9c4d-11ea-946c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('760e8821-9d25-11f0-b494-179041587982', 'aa30a470-fb76-11ec-a176-d902a1918d35', '70a95120-fb76-11ec-82ff-e103d8d6432f', 24, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('76e82a50-d2ab-11ec-94f4-0b63ddc79043', 'aaae78d0-c153-11ec-b810-d1ffe210d8b1', '80899fda-9c4d-11ea-92a7-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('aaaf1510-c153-11ec-b810-d1ffe210d8b1', 'aaae78d0-c153-11ec-b810-d1ffe210d8b1', 'c30371a0-be1b-11ec-a7fa-3529186828e2', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('aaaf1511-c153-11ec-b810-d1ffe210d8b1', 'aaae78d0-c153-11ec-b810-d1ffe210d8b1', 'e9464450-be20-11ec-a7fa-3529186828e2', 3, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ee145e60-d27d-11ec-b363-f7982c6efb86', 'aaae78d0-c153-11ec-b810-d1ffe210d8b1', '0d161320-1baf-11ec-9cd0-53f06f053e40', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('abd88e20-307f-11ee-af48-fb839ee61b42', 'abb108f0-307f-11ee-af48-fb839ee61b42', '9fe020a0-e31b-11eb-b993-552ff2e9d866', 250, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('abd8b531-307f-11ee-af48-fb839ee61b42', 'abb108f0-307f-11ee-af48-fb839ee61b42', '80897b0e-9c4d-11ea-9297-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('abd8b532-307f-11ee-af48-fb839ee61b42', 'abb108f0-307f-11ee-af48-fb839ee61b42', '80897cbc-9c4d-11ea-9299-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ac149bc0-6d38-11eb-a732-3588446adb69', 'ac133c30-6d38-11eb-a732-3588446adb69', '80897280-9c4d-11ea-9290-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ac14c2d0-6d38-11eb-a732-3588446adb69', 'ac133c30-6d38-11eb-a732-3588446adb69', '15854ed0-6bb6-11eb-80f6-73940ffe6b4a', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ac14c2d1-6d38-11eb-a732-3588446adb69', 'ac133c30-6d38-11eb-a732-3588446adb69', '6289ccb0-6bb6-11eb-aac1-2355e6ce6dd2', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ac14c2d2-6d38-11eb-a732-3588446adb69', 'ac133c30-6d38-11eb-a732-3588446adb69', '8089b844-9c4d-11ea-92c3-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('acd280b0-308e-11ee-af48-fb839ee61b42', 'acac8220-308e-11ee-af48-fb839ee61b42', '8089b772-9c4d-11ea-92c2-0a5bf521835e', 0.05, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('7748ec10-5797-11ee-8a35-b9ff8bb74ead', 'ad204cf0-9dec-11eb-8c37-bb20979b8c2f', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('7748ec11-5797-11ee-8a35-b9ff8bb74ead', 'ad204cf0-9dec-11eb-8c37-bb20979b8c2f', 'a18a865e-9c4d-11ea-941c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7748ec12-5797-11ee-8a35-b9ff8bb74ead', 'ad204cf0-9dec-11eb-8c37-bb20979b8c2f', '8089cc80-9c4d-11ea-92d9-0a5bf521835e', 140, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('adf05720-23dc-11ed-925e-393317a6b4b7', 'adef93d0-23dc-11ed-925e-393317a6b4b7', '378429f0-46eb-11ec-939f-314f99801403', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('adf05721-23dc-11ed-925e-393317a6b4b7', 'adef93d0-23dc-11ed-925e-393317a6b4b7', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('adf05723-23dc-11ed-925e-393317a6b4b7', 'adef93d0-23dc-11ed-925e-393317a6b4b7', 'e9d88d10-b944-11eb-acec-29fb8569cb50', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('adf07e30-23dc-11ed-925e-393317a6b4b7', 'adef93d0-23dc-11ed-925e-393317a6b4b7', '80899fda-9c4d-11ea-92a7-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('adf07e31-23dc-11ed-925e-393317a6b4b7', 'adef93d0-23dc-11ed-925e-393317a6b4b7', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d07a0bb0-23dc-11ed-a94a-933a73b178be', 'adef93d0-23dc-11ed-925e-393317a6b4b7', '6b66cd30-23dc-11ed-8331-7f9fd88301ac', 120, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('3681f760-c159-11ec-9265-d57037e66861', 'ae8f5fb0-c157-11ec-b810-d1ffe210d8b1', '8089b312-9c4d-11ea-92bd-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ae8ffbf0-c157-11ec-b810-d1ffe210d8b1', 'ae8f5fb0-c157-11ec-b810-d1ffe210d8b1', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ae8ffbf1-c157-11ec-b810-d1ffe210d8b1', 'ae8f5fb0-c157-11ec-b810-d1ffe210d8b1', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ae8ffbf2-c157-11ec-b810-d1ffe210d8b1', 'ae8f5fb0-c157-11ec-b810-d1ffe210d8b1', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ae8ffbf3-c157-11ec-b810-d1ffe210d8b1', 'ae8f5fb0-c157-11ec-b810-d1ffe210d8b1', '80893d1a-9c4d-11ea-9282-0a5bf521835e', 8, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('ae902301-c157-11ec-b810-d1ffe210d8b1', 'ae8f5fb0-c157-11ec-b810-d1ffe210d8b1', 'a18a26c8-9c4d-11ea-93a9-0a5bf521835e', 300, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ae902302-c157-11ec-b810-d1ffe210d8b1', 'ae8f5fb0-c157-11ec-b810-d1ffe210d8b1', '80899fda-9c4d-11ea-92a7-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('af00c870-19d9-11eb-a886-0a5bf521835e', 'aeff8c4e-19d9-11eb-a885-0a5bf521835e', '8089b920-9c4d-11ea-92c4-0a5bf521835e', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('af00d3ce-19d9-11eb-bfe3-0a5bf521835e', 'aeff8c4e-19d9-11eb-a885-0a5bf521835e', '8089cd5c-9c4d-11ea-92da-0a5bf521835e', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('af00dd6a-19d9-11eb-ad42-0a5bf521835e', 'aeff8c4e-19d9-11eb-a885-0a5bf521835e', '80899a4e-9c4d-11ea-92a1-0a5bf521835e', 20, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a3867570-bdf5-11ef-82e5-6fff7ba76104', 'af274560-bded-11ef-b77b-b5f02a7171be', '18ab8420-a8b6-11eb-9770-c18e5ed172e8', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a3867572-bdf5-11ef-82e5-6fff7ba76104', 'af274560-bded-11ef-b77b-b5f02a7171be', 'd6825b50-bdf1-11ef-ba0c-d9e4e2a63cd3', 65, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a3867574-bdf5-11ef-82e5-6fff7ba76104', 'af274560-bded-11ef-b77b-b5f02a7171be', '79da2e70-bdef-11ef-be99-f72f1fb7b2f1', 35, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a3869c81-bdf5-11ef-82e5-6fff7ba76104', 'af274560-bded-11ef-b77b-b5f02a7171be', '11608c10-bdf2-11ef-ba0c-d9e4e2a63cd3', 455, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a3869c83-bdf5-11ef-82e5-6fff7ba76104', 'af274560-bded-11ef-b77b-b5f02a7171be', '61d22480-f840-11ec-a176-d902a1918d35', 3, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a3869c85-bdf5-11ef-82e5-6fff7ba76104', 'af274560-bded-11ef-b77b-b5f02a7171be', '8089b696-9c4d-11ea-92c1-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('a386c391-bdf5-11ef-82e5-6fff7ba76104', 'af274560-bded-11ef-b77b-b5f02a7171be', '3d046180-bdf1-11ef-b77b-b5f02a7171be', 400, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b04fc9f0-c992-11ec-8b95-edfe4c030b67', 'b04edf90-c992-11ec-8b95-edfe4c030b67', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b04fc9f1-c992-11ec-8b95-edfe4c030b67', 'b04edf90-c992-11ec-8b95-edfe4c030b67', '80893d1a-9c4d-11ea-9282-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b04ff100-c992-11ec-8b95-edfe4c030b67', 'b04edf90-c992-11ec-8b95-edfe4c030b67', 'a18a26c8-9c4d-11ea-93a9-0a5bf521835e', 300, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b0ebfea0-bee0-11eb-b72d-730bbd0b1638', 'b0ea9f10-bee0-11eb-b72d-730bbd0b1638', '009727f0-bee0-11eb-95fb-335b2b14a84d', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b0ebfea1-bee0-11eb-b72d-730bbd0b1638', 'b0ea9f10-bee0-11eb-b72d-730bbd0b1638', 'a18a3168-9c4d-11ea-93b5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b0ebfea2-bee0-11eb-b72d-730bbd0b1638', 'b0ea9f10-bee0-11eb-b72d-730bbd0b1638', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('80399680-5797-11ee-b338-23c2e19316f3', 'b1346b10-9deb-11eb-8c37-bb20979b8c2f', 'a18a865e-9c4d-11ea-941c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('80399681-5797-11ee-b338-23c2e19316f3', 'b1346b10-9deb-11eb-8c37-bb20979b8c2f', '8089cc80-9c4d-11ea-92d9-0a5bf521835e', 140, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b1d09b90-308b-11ee-af48-fb839ee61b42', 'b1a98b90-308b-11ee-af48-fb839ee61b42', '8089ca00-9c4d-11ea-92d6-0a5bf521835e', 0.05, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b24b27d0-c15a-11ec-b810-d1ffe210d8b1', 'b24ad9b0-c15a-11ec-b810-d1ffe210d8b1', 'a18a7f06-9c4d-11ea-9411-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b24b4ee0-c15a-11ec-b810-d1ffe210d8b1', 'b24ad9b0-c15a-11ec-b810-d1ffe210d8b1', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b24b4ee1-c15a-11ec-b810-d1ffe210d8b1', 'b24ad9b0-c15a-11ec-b810-d1ffe210d8b1', '5409fdc0-be1e-11ec-92b5-d17e9a4e477d', 80, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b24b4ee2-c15a-11ec-b810-d1ffe210d8b1', 'b24ad9b0-c15a-11ec-b810-d1ffe210d8b1', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b24b4ee3-c15a-11ec-b810-d1ffe210d8b1', 'b24ad9b0-c15a-11ec-b810-d1ffe210d8b1', '0d161320-1baf-11ec-9cd0-53f06f053e40', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b24b4ee4-c15a-11ec-b810-d1ffe210d8b1', 'b24ad9b0-c15a-11ec-b810-d1ffe210d8b1', '80899ef4-9c4d-11ea-92a6-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('bed75c50-fe6d-11ef-b39f-37ef02c1e266', 'b3d91460-e3eb-11eb-8237-736a902b6e66', '8089751e-9c4d-11ea-9293-0a5bf521835e', 7, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('bed75c52-fe6d-11ef-b39f-37ef02c1e266', 'b3d91460-e3eb-11eb-8237-736a902b6e66', '80897b0e-9c4d-11ea-9297-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('bed75c53-fe6d-11ef-b39f-37ef02c1e266', 'b3d91460-e3eb-11eb-8237-736a902b6e66', '8089bbbe-9c4d-11ea-92c7-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('bed78361-fe6d-11ef-b39f-37ef02c1e266', 'b3d91460-e3eb-11eb-8237-736a902b6e66', '80897a3c-9c4d-11ea-9296-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b41e90f0-3090-11ee-af48-fb839ee61b42', 'b3dd1b20-3090-11ee-af48-fb839ee61b42', 'a18a5cce-9c4d-11ea-93ef-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b41eb800-3090-11ee-af48-fb839ee61b42', 'b3dd1b20-3090-11ee-af48-fb839ee61b42', 'a18a5d78-9c4d-11ea-93f0-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b41d0310-757f-11ed-a0a7-1b2de41c84da', 'b41c3fc0-757f-11ed-a0a7-1b2de41c84da', 'd3adbff0-fb8e-11ec-86ff-13fce83436c9', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b59e0520-349c-11f0-9650-152532a65f04', 'b59ccca0-349c-11f0-9650-152532a65f04', '808943f0-9c4d-11ea-928a-0a5bf521835e', 200, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b59e0522-349c-11f0-9650-152532a65f04', 'b59ccca0-349c-11f0-9650-152532a65f04', '32df9ea0-4e20-11ee-89fc-3b4978b6868d', 1000, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('cdd7b230-bdff-11ef-b1d2-cb85c75371d6', 'b6ad21f0-bdfd-11ef-914f-cb5d4afd0259', '2af3efe0-bdfd-11ef-a034-73777b7f79b7', 190, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('cdd7b232-bdff-11ef-b1d2-cb85c75371d6', 'b6ad21f0-bdfd-11ef-914f-cb5d4afd0259', '11608c10-bdf2-11ef-ba0c-d9e4e2a63cd3', 300, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('cdd7d940-bdff-11ef-b1d2-cb85c75371d6', 'b6ad21f0-bdfd-11ef-914f-cb5d4afd0259', '61d22480-f840-11ec-a176-d902a1918d35', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('cdd7d942-bdff-11ef-b1d2-cb85c75371d6', 'b6ad21f0-bdfd-11ef-914f-cb5d4afd0259', '6957aad0-f4f5-11eb-a95c-45ac352893ba', 165, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('cdd7d944-bdff-11ef-b1d2-cb85c75371d6', 'b6ad21f0-bdfd-11ef-914f-cb5d4afd0259', '18ab8420-a8b6-11eb-9770-c18e5ed172e8', 200, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('b8b5f790-3089-11ee-af48-fb839ee61b42', 'b888f420-3089-11ee-af48-fb839ee61b42', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('1a25f800-68fb-11ee-bf56-ffd73309e818', 'b8f79e50-53d1-11ee-ad93-4d410949057c', '8089cfdc-9c4d-11ea-92dd-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('1a261f10-68fb-11ee-bf56-ffd73309e818', 'b8f79e50-53d1-11ee-ad93-4d410949057c', '54953940-53d1-11ee-98c2-6770c73d7d3c', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b99d62a0-308f-11ee-af48-fb839ee61b42', 'b9678590-308f-11ee-af48-fb839ee61b42', '4523fdf0-ab9b-11ec-a872-7595cd01f649', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b99d62a1-308f-11ee-af48-fb839ee61b42', 'b9678590-308f-11ee-af48-fb839ee61b42', '8e828490-d5e8-11ec-b2e2-5dd84dabb8a8', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('2ad47230-68fb-11ee-bf56-ffd73309e818', 'b9d1dc40-53d2-11ee-ad93-4d410949057c', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('2ad47231-68fb-11ee-bf56-ffd73309e818', 'b9d1dc40-53d2-11ee-ad93-4d410949057c', '54953940-53d1-11ee-98c2-6770c73d7d3c', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('2ad49940-68fb-11ee-bf56-ffd73309e818', 'b9d1dc40-53d2-11ee-ad93-4d410949057c', '8089cc80-9c4d-11ea-92d9-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('177e88f0-21d3-11f0-8b95-0ba6cd1a2e00', 'baa28230-7cd6-11eb-9648-651da3a4a532', '8eda7860-7cd6-11eb-83c2-81353eec23fb', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('bb5e0bc0-ea2f-11ef-99fd-f75a4ffbaeb0', 'bb5d2160-ea2f-11ef-99fd-f75a4ffbaeb0', '6f6abe40-4e2f-11ee-9a37-c1fb9a9e60bd', 70, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('bb5e32d1-ea2f-11ef-99fd-f75a4ffbaeb0', 'bb5d2160-ea2f-11ef-99fd-f75a4ffbaeb0', 'a18a4716-9c4d-11ea-93d5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('bb5e32d2-ea2f-11ef-99fd-f75a4ffbaeb0', 'bb5d2160-ea2f-11ef-99fd-f75a4ffbaeb0', 'cfb73310-9387-11eb-b551-3d9be8d1c5c7', 6, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('bb5e32d4-ea2f-11ef-99fd-f75a4ffbaeb0', 'bb5d2160-ea2f-11ef-99fd-f75a4ffbaeb0', 'a18a9a72-9c4d-11ea-9434-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('27a94e60-a828-11ef-8e56-e34985f0ea4e', 'bb979880-a827-11ef-8e56-e34985f0ea4e', '784d06a0-8487-11ef-8ef8-37c5596a9593', 170, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('27a94e61-a828-11ef-8e56-e34985f0ea4e', 'bb979880-a827-11ef-8e56-e34985f0ea4e', '8089a2b4-9c4d-11ea-92aa-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('27a97570-a828-11ef-8e56-e34985f0ea4e', 'bb979880-a827-11ef-8e56-e34985f0ea4e', '808926cc-9c4d-11ea-9268-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c03b8280-c151-11ec-b810-d1ffe210d8b1', 'c03b0d50-c151-11ec-b810-d1ffe210d8b1', 'fc0ae680-c150-11ec-a2ba-7bb1dc10361f', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c03b8281-c151-11ec-b810-d1ffe210d8b1', 'c03b0d50-c151-11ec-b810-d1ffe210d8b1', 'e9464450-be20-11ec-a7fa-3529186828e2', 3, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c03ba990-c151-11ec-b810-d1ffe210d8b1', 'c03b0d50-c151-11ec-b810-d1ffe210d8b1', '83dd7550-be2c-11ec-9222-db267923b89e', 40, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c03ba991-c151-11ec-b810-d1ffe210d8b1', 'c03b0d50-c151-11ec-b810-d1ffe210d8b1', '6e078db0-be2c-11ec-92b5-d17e9a4e477d', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c0786bf0-d5bf-11ec-9916-a1c1f658f229', 'c0773370-d5bf-11ec-9916-a1c1f658f229', 'deb3cd90-be1c-11ec-92b5-d17e9a4e477d', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c0789300-d5bf-11ec-9916-a1c1f658f229', 'c0773370-d5bf-11ec-9916-a1c1f658f229', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c0b44700-d5c0-11ec-8b7a-0f22ec019de6', 'c0b383b0-d5c0-11ec-8b7a-0f22ec019de6', 'b24ad9b0-c15a-11ec-b810-d1ffe210d8b1', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c0b44701-d5c0-11ec-8b7a-0f22ec019de6', 'c0b383b0-d5c0-11ec-8b7a-0f22ec019de6', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c0f0d7d0-308f-11ee-af48-fb839ee61b42', 'c0c9eee0-308f-11ee-af48-fb839ee61b42', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c11a6ec0-fb04-11ee-9be0-1f5f4004d531', 'c119ab70-fb04-11ee-9be0-1f5f4004d531', '26d4cc10-d865-11ed-9677-6bd4a1cc96ce', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c1968db0-308f-11ee-af48-fb839ee61b42', 'c15517e0-308f-11ee-af48-fb839ee61b42', 'a18a90f4-9c4d-11ea-942b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c1968db1-308f-11ee-af48-fb839ee61b42', 'c15517e0-308f-11ee-af48-fb839ee61b42', 'a18a919e-9c4d-11ea-942c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c19259e0-308d-11ee-af48-fb839ee61b42', 'c16cd080-308d-11ee-af48-fb839ee61b42', '68f22880-e3ad-11eb-8237-736a902b6e66', 75, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8526c070-de3f-11ef-b19c-c3b3bf5def36', 'c27c908c-19f2-11eb-a7a0-0a5bf521835e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8526e781-de3f-11ef-b19c-c3b3bf5def36', 'c27c908c-19f2-11eb-a7a0-0a5bf521835e', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8526e782-de3f-11ef-b19c-c3b3bf5def36', 'c27c908c-19f2-11eb-a7a0-0a5bf521835e', '8089c258-9c4d-11ea-92cd-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8526e784-de3f-11ef-b19c-c3b3bf5def36', 'c27c908c-19f2-11eb-a7a0-0a5bf521835e', 'a18a2cae-9c4d-11ea-93ae-0a5bf521835e', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8526e786-de3f-11ef-b19c-c3b3bf5def36', 'c27c908c-19f2-11eb-a7a0-0a5bf521835e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8526e788-de3f-11ef-b19c-c3b3bf5def36', 'c27c908c-19f2-11eb-a7a0-0a5bf521835e', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8526e78a-de3f-11ef-b19c-c3b3bf5def36', 'c27c908c-19f2-11eb-a7a0-0a5bf521835e', '8089c406-9c4d-11ea-92cf-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8526e78c-de3f-11ef-b19c-c3b3bf5def36', 'c27c908c-19f2-11eb-a7a0-0a5bf521835e', 'a18a26c8-9c4d-11ea-93a9-0a5bf521835e', 300, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('85270e90-de3f-11ef-b19c-c3b3bf5def36', 'c27c908c-19f2-11eb-a7a0-0a5bf521835e', '15289b50-bba7-11ef-a2da-67539c782629', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c31d2a80-308b-11ee-af48-fb839ee61b42', 'c2f64190-308b-11ee-af48-fb839ee61b42', '55a7ad00-87b3-11eb-ba42-2d944e66f12b', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('03efc650-be1c-11ec-92b5-d17e9a4e477d', 'c30371a0-be1b-11ec-a7fa-3529186828e2', '84f86af0-be1b-11ec-92b5-d17e9a4e477d', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c3040de0-be1b-11ec-a7fa-3529186828e2', 'c30371a0-be1b-11ec-a7fa-3529186828e2', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c3040de1-be1b-11ec-a7fa-3529186828e2', 'c30371a0-be1b-11ec-a7fa-3529186828e2', '378429f0-46eb-11ec-939f-314f99801403', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c3040de2-be1b-11ec-a7fa-3529186828e2', 'c30371a0-be1b-11ec-a7fa-3529186828e2', '8089c17c-9c4d-11ea-92cc-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c3040de3-be1b-11ec-a7fa-3529186828e2', 'c30371a0-be1b-11ec-a7fa-3529186828e2', '8089b3ee-9c4d-11ea-92be-0a5bf521835e', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c3040de4-be1b-11ec-a7fa-3529186828e2', 'c30371a0-be1b-11ec-a7fa-3529186828e2', '80893d1a-9c4d-11ea-9282-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c30434f0-be1b-11ec-a7fa-3529186828e2', 'c30371a0-be1b-11ec-a7fa-3529186828e2', '8089c32a-9c4d-11ea-92ce-0a5bf521835e', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c30434f2-be1b-11ec-a7fa-3529186828e2', 'c30371a0-be1b-11ec-a7fa-3529186828e2', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c30434f3-be1b-11ec-a7fa-3529186828e2', 'c30371a0-be1b-11ec-a7fa-3529186828e2', 'a18a2d62-9c4d-11ea-93af-0a5bf521835e', 170, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c30434f4-be1b-11ec-a7fa-3529186828e2', 'c30371a0-be1b-11ec-a7fa-3529186828e2', '202590d0-be1b-11ec-9222-db267923b89e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c3402ec0-307e-11ee-af48-fb839ee61b42', 'c3179820-307e-11ee-af48-fb839ee61b42', 'cd5461e0-bf8f-11eb-ba7c-19483afb8580', 2, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c3402ec2-307e-11ee-af48-fb839ee61b42', 'c3179820-307e-11ee-af48-fb839ee61b42', '8089297e-9c4d-11ea-926b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c34055d0-307e-11ee-af48-fb839ee61b42', 'c3179820-307e-11ee-af48-fb839ee61b42', '80892a5a-9c4d-11ea-926c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c4438ca0-308c-11ee-af48-fb839ee61b42', 'c360a6b0-308c-11ee-af48-fb839ee61b42', 'c03b0d50-c151-11ec-b810-d1ffe210d8b1', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c4444ff0-308c-11ee-af48-fb839ee61b42', 'c360a6b0-308c-11ee-af48-fb839ee61b42', '0cb021c0-c97c-11ec-860d-478ebb9d77b5', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c3ddce50-307e-11ee-af48-fb839ee61b42', 'c3a0ec60-307e-11ee-af48-fb839ee61b42', '6d32b370-e320-11eb-b993-552ff2e9d866', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c3ddf560-307e-11ee-af48-fb839ee61b42', 'c3a0ec60-307e-11ee-af48-fb839ee61b42', '07993880-e321-11eb-b4a4-c79ec670c12e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c4570d40-308f-11ee-af48-fb839ee61b42', 'c4302450-308f-11ee-af48-fb839ee61b42', 'a18ac1be-9c4d-11ea-945d-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c4575b60-308f-11ee-af48-fb839ee61b42', 'c4302450-308f-11ee-af48-fb839ee61b42', 'a18ac272-9c4d-11ea-945e-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e847be80-d4c0-11ef-8da4-b1c162856090', 'c4eddf70-e304-11eb-9b9e-0f6f0f6fa679', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e847e590-d4c0-11ef-8da4-b1c162856090', 'c4eddf70-e304-11eb-9b9e-0f6f0f6fa679', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 1.5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e8480ca0-d4c0-11ef-8da4-b1c162856090', 'c4eddf70-e304-11eb-9b9e-0f6f0f6fa679', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e8480ca1-d4c0-11ef-8da4-b1c162856090', 'c4eddf70-e304-11eb-9b9e-0f6f0f6fa679', '8089d522-9c4d-11ea-92e3-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e8480ca2-d4c0-11ef-8da4-b1c162856090', 'c4eddf70-e304-11eb-9b9e-0f6f0f6fa679', '80893d1a-9c4d-11ea-9282-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e8480ca3-d4c0-11ef-8da4-b1c162856090', 'c4eddf70-e304-11eb-9b9e-0f6f0f6fa679', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 20, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('e8480ca4-d4c0-11ef-8da4-b1c162856090', 'c4eddf70-e304-11eb-9b9e-0f6f0f6fa679', '6b794010-46eb-11ec-bc07-efd394bb365a', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('e84833b0-d4c0-11ef-8da4-b1c162856090', 'c4eddf70-e304-11eb-9b9e-0f6f0f6fa679', 'a18a26c8-9c4d-11ea-93a9-0a5bf521835e', 300, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e84833b1-d4c0-11ef-8da4-b1c162856090', 'c4eddf70-e304-11eb-9b9e-0f6f0f6fa679', '80899fda-9c4d-11ea-92a7-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c6739bc0-307b-11ee-af48-fb839ee61b42', 'c64cd9e0-307b-11ee-af48-fb839ee61b42', 'a18ace98-9c4d-11ea-946f-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c74741a0-308a-11ee-af48-fb839ee61b42', 'c71bebe0-308a-11ee-af48-fb839ee61b42', '60738c90-d1f9-11ec-b363-f7982c6efb86', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c7fe8080-3086-11ee-af48-fb839ee61b42', 'c7d7e5b0-3086-11ee-af48-fb839ee61b42', 'd8713460-19d9-11eb-b532-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c842ad30-7580-11ed-9c6e-83547301d186', 'c8414da0-7580-11ed-9c6e-83547301d186', '6ea4c720-c1a5-11ec-853d-e7960d3897c4', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c8a81df0-c153-11ec-9265-d57037e66861', 'c8a6e570-c153-11ec-9265-d57037e66861', 'c30371a0-be1b-11ec-a7fa-3529186828e2', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c8a84500-c153-11ec-9265-d57037e66861', 'c8a6e570-c153-11ec-9265-d57037e66861', '80899fda-9c4d-11ea-92a7-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c8a84501-c153-11ec-9265-d57037e66861', 'c8a6e570-c153-11ec-9265-d57037e66861', '8f1cd300-c153-11ec-a2ba-7bb1dc10361f', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('ca575a10-3085-11ee-af48-fb839ee61b42', 'ca2f38a0-3085-11ee-af48-fb839ee61b42', 'a18a49d2-9c4d-11ea-93d9-0a5bf521835e', 2, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c1259120-cf51-11ef-8b1f-795efc194fa4', 'cc0f9000-cf50-11ef-90af-61ebec49d20b', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c1267b80-cf51-11ef-8b1f-795efc194fa4', 'cc0f9000-cf50-11ef-90af-61ebec49d20b', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c1267b81-cf51-11ef-8b1f-795efc194fa4', 'cc0f9000-cf50-11ef-90af-61ebec49d20b', '8089c258-9c4d-11ea-92cd-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c126a290-cf51-11ef-8b1f-795efc194fa4', 'cc0f9000-cf50-11ef-90af-61ebec49d20b', '8089cfdc-9c4d-11ea-92dd-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c126a292-cf51-11ef-8b1f-795efc194fa4', 'cc0f9000-cf50-11ef-90af-61ebec49d20b', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c126a294-cf51-11ef-8b1f-795efc194fa4', 'cc0f9000-cf50-11ef-90af-61ebec49d20b', '8089b920-9c4d-11ea-92c4-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c126c9a1-cf51-11ef-8b1f-795efc194fa4', 'cc0f9000-cf50-11ef-90af-61ebec49d20b', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c126f0b0-cf51-11ef-8b1f-795efc194fa4', 'cc0f9000-cf50-11ef-90af-61ebec49d20b', '8089c406-9c4d-11ea-92cf-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c126f0b2-cf51-11ef-8b1f-795efc194fa4', 'cc0f9000-cf50-11ef-90af-61ebec49d20b', 'a18a26c8-9c4d-11ea-93a9-0a5bf521835e', 300, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('c126f0b4-cf51-11ef-8b1f-795efc194fa4', 'cc0f9000-cf50-11ef-90af-61ebec49d20b', '5b05ba10-cf50-11ef-9028-f1198bb1e3d6', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('cc4ed160-d5e4-11ec-9916-a1c1f658f229', 'cc4e3520-d5e4-11ec-9916-a1c1f658f229', '80892032-9c4d-11ea-9260-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('cc4ed161-d5e4-11ec-9916-a1c1f658f229', 'cc4e3520-d5e4-11ec-9916-a1c1f658f229', 'e5e1fbe0-c15b-11ec-a2ba-7bb1dc10361f', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('80e31780-6d36-11eb-a4bf-c58d44f967d3', 'cd65a10a-1a06-11eb-90f1-0a5bf521835e', '8089b844-9c4d-11ea-92c3-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('cd668d72-1a06-11eb-90f2-0a5bf521835e', 'cd65a10a-1a06-11eb-90f1-0a5bf521835e', '80897280-9c4d-11ea-9290-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('cfab9850-308f-11ee-af48-fb839ee61b42', 'cf812cf0-308f-11ee-af48-fb839ee61b42', '5cf92180-dc2e-11ec-ae34-1dcb862714d3', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('cfabbf60-308f-11ee-af48-fb839ee61b42', 'cf812cf0-308f-11ee-af48-fb839ee61b42', '80891f2e-9c4d-11ea-925f-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('65086e00-21d4-11f0-ac9f-fffdeb0f868f', 'cfb73310-9387-11eb-b551-3d9be8d1c5c7', '8089d90a-9c4d-11ea-92e6-0a5bf521835e', 6.67, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('65086e01-21d4-11f0-ac9f-fffdeb0f868f', 'cfb73310-9387-11eb-b551-3d9be8d1c5c7', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('cfec1160-a63b-11ee-b682-015a80327a47', 'cfeb4e10-a63b-11ee-b682-015a80327a47', '8cb796e0-a63a-11ee-b3cd-3d8b47d7dc66', 5, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d054eb10-2374-11f0-953f-0dfe025424db', 'd0522bf0-2374-11f0-953f-0dfe025424db', 'ba102e80-d1f8-11ec-b363-f7982c6efb86', 25, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d095a990-811c-11ed-b263-b95e21b5e348', 'd0947110-811c-11ed-b263-b95e21b5e348', '9846ad50-5147-11ed-b50c-474f649a5bc5', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d1808e20-3089-11ee-af48-fb839ee61b42', 'd15b52e0-3089-11ee-af48-fb839ee61b42', '76bb1e20-c158-11ec-9265-d57037e66861', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('0013c640-68fb-11ee-ab1f-b75cbbbc7fd2', 'd2326660-53d2-11ee-a233-1bda7c5c59b1', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('0013ed50-68fb-11ee-ab1f-b75cbbbc7fd2', 'd2326660-53d2-11ee-a233-1bda7c5c59b1', '8089d0a4-9c4d-11ea-92de-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('0013ed51-68fb-11ee-ab1f-b75cbbbc7fd2', 'd2326660-53d2-11ee-a233-1bda7c5c59b1', '54953940-53d1-11ee-98c2-6770c73d7d3c', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d29e4940-3080-11ee-af48-fb839ee61b42', 'd26a8f10-3080-11ee-af48-fb839ee61b42', '0e0a0240-ebf3-11ec-a12f-77342cf624c3', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d29e4941-3080-11ee-af48-fb839ee61b42', 'd26a8f10-3080-11ee-af48-fb839ee61b42', 'fd4c24c0-041a-11ed-ba73-47672f6aff75', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d338ed80-307e-11ee-af48-fb839ee61b42', 'd31279c0-307e-11ee-af48-fb839ee61b42', '8b8f1d2a-1a05-11eb-912d-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9784bae0-c152-11ec-b810-d1ffe210d8b1', 'd3c50930-be1c-11ec-92b5-d17e9a4e477d', '80899fda-9c4d-11ea-92a7-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9789f5a0-be1e-11ec-9222-db267923b89e', 'd3c50930-be1c-11ec-92b5-d17e9a4e477d', '5409fdc0-be1e-11ec-92b5-d17e9a4e477d', 80, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d3c55750-be1c-11ec-92b5-d17e9a4e477d', 'd3c50930-be1c-11ec-92b5-d17e9a4e477d', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d3c55752-be1c-11ec-92b5-d17e9a4e477d', 'd3c50930-be1c-11ec-92b5-d17e9a4e477d', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d3c55753-be1c-11ec-92b5-d17e9a4e477d', 'd3c50930-be1c-11ec-92b5-d17e9a4e477d', 'e760b460-4790-11ec-939f-314f99801403', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d3cd7fa0-d5c0-11ec-b2e2-5dd84dabb8a8', 'd3cd0a70-d5c0-11ec-b2e2-5dd84dabb8a8', '044d1cf0-c15b-11ec-853d-e7960d3897c4', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d3cd7fa1-d5c0-11ec-b2e2-5dd84dabb8a8', 'd3cd0a70-d5c0-11ec-b2e2-5dd84dabb8a8', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d481a680-f0ca-11ed-ada6-f1c2893b2f15', 'd480e330-f0ca-11ed-ada6-f1c2893b2f15', '8089a0c0-9c4d-11ea-92a8-0a5bf521835e', 200, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d481a681-f0ca-11ed-ada6-f1c2893b2f15', 'd480e330-f0ca-11ed-ada6-f1c2893b2f15', '808943f0-9c4d-11ea-928a-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d481a682-f0ca-11ed-ada6-f1c2893b2f15', 'd480e330-f0ca-11ed-ada6-f1c2893b2f15', '8089bf42-9c4d-11ea-92ca-0a5bf521835e', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d4bc78e0-3081-11ee-af48-fb839ee61b42', 'd499d5b0-3081-11ee-af48-fb839ee61b42', '5cbda90e-1a04-11eb-b255-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9a997310-5797-11ee-a0d7-6bcb9c2501f8', 'd58148e0-9dea-11eb-9fc3-c54eb2b1a2bd', 'a18a85b4-9c4d-11ea-941b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9a997311-5797-11ee-a0d7-6bcb9c2501f8', 'd58148e0-9dea-11eb-9fc3-c54eb2b1a2bd', '8089cc80-9c4d-11ea-92d9-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d5fe95d0-3081-11ee-af48-fb839ee61b42', 'd5cf9690-3081-11ee-af48-fb839ee61b42', '813c8560-9868-11eb-9abf-858942205919', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d5fe95d1-3081-11ee-af48-fb839ee61b42', 'd5cf9690-3081-11ee-af48-fb839ee61b42', '99ec6800-9868-11eb-9e4f-6d7301ceddce', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d61f5680-307c-11ee-af48-fb839ee61b42', 'd5f8e2c0-307c-11ee-af48-fb839ee61b42', '0268e650-d1f3-11ec-94f4-0b63ddc79043', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d6063a80-c886-11ef-8cdd-494b0e1336ff', 'd6050200-c886-11ef-8cdd-494b0e1336ff', '784d06a0-8487-11ef-8ef8-37c5596a9593', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d624f5c0-fb73-11ec-a176-d902a1918d35', 'd623e450-fb73-11ec-a176-d902a1918d35', '6c028cc0-fb73-11ec-87d3-cf5d212ef325', 24, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d6251cd0-fb73-11ec-a176-d902a1918d35', 'd623e450-fb73-11ec-a176-d902a1918d35', 'a18acc7c-9c4d-11ea-946c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d640bda0-a828-11ef-8823-a5dd9aeddc06', 'd63f3700-a828-11ef-8823-a5dd9aeddc06', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d640bda2-a828-11ef-8823-a5dd9aeddc06', 'd63f3700-a828-11ef-8823-a5dd9aeddc06', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d640e4b0-a828-11ef-8823-a5dd9aeddc06', 'd63f3700-a828-11ef-8823-a5dd9aeddc06', 'a18a7f06-9c4d-11ea-9411-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d640e4b2-a828-11ef-8823-a5dd9aeddc06', 'd63f3700-a828-11ef-8823-a5dd9aeddc06', '80899ef4-9c4d-11ea-92a6-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d640e4b4-a828-11ef-8823-a5dd9aeddc06', 'd63f3700-a828-11ef-8823-a5dd9aeddc06', '784d06a0-8487-11ef-8ef8-37c5596a9593', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d6faefd0-3084-11ee-af48-fb839ee61b42', 'd6d629c0-3084-11ee-af48-fb839ee61b42', 'a18acf56-9c4d-11ea-9470-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f442e2d0-e5cb-11ee-9039-533d7f6e976b', 'd742a500-cf26-11ee-9180-5f1b01ee3b04', '4c217cf0-cf15-11ee-9196-c5c68bf4c631', 5, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f442e2d2-e5cb-11ee-9039-533d7f6e976b', 'd742a500-cf26-11ee-9180-5f1b01ee3b04', '8089c5be-9c4d-11ea-92d1-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f44309e0-e5cb-11ee-9039-533d7f6e976b', 'd742a500-cf26-11ee-9180-5f1b01ee3b04', '8089c690-9c4d-11ea-92d2-0a5bf521835e', 9.6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f44309e2-e5cb-11ee-9039-533d7f6e976b', 'd742a500-cf26-11ee-9180-5f1b01ee3b04', '8089b312-9c4d-11ea-92bd-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d75aee10-9dee-11eb-b217-2bde6a29a24e', 'd75a78e0-9dee-11eb-b217-2bde6a29a24e', 'a18a99c8-9c4d-11ea-9433-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d75b1520-9dee-11eb-b217-2bde6a29a24e', 'd75a78e0-9dee-11eb-b217-2bde6a29a24e', 'a18a466c-9c4d-11ea-93d4-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('d75b1521-9dee-11eb-b217-2bde6a29a24e', 'd75a78e0-9dee-11eb-b217-2bde6a29a24e', 'a18a2b50-9c4d-11ea-93ac-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d7905630-307d-11ee-af48-fb839ee61b42', 'd76a0980-307d-11ee-af48-fb839ee61b42', 'dd840f20-bf8f-11eb-8fcb-8ba60eb97259', 2, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d7907d41-307d-11ee-af48-fb839ee61b42', 'd76a0980-307d-11ee-af48-fb839ee61b42', '80892a5a-9c4d-11ea-926c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d7907d42-307d-11ee-af48-fb839ee61b42', 'd76a0980-307d-11ee-af48-fb839ee61b42', '8089297e-9c4d-11ea-926b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('d871a4ae-19d9-11eb-b533-0a5bf521835e', 'd8713460-19d9-11eb-b532-0a5bf521835e', '8089b312-9c4d-11ea-92bd-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('dc122610-3083-11ee-af48-fb839ee61b42', 'dbeb1610-3083-11ee-af48-fb839ee61b42', '2e5a7d12-1a09-11eb-8a54-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('dd5dfbfa-1a08-11eb-99ec-0a5bf521835e', 'dd5d83b4-1a08-11eb-99eb-0a5bf521835e', '8089acfa-9c4d-11ea-92b6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('de6709c0-a63b-11ee-8113-71b52dd3cd48', 'de64e6e0-a63b-11ee-8113-71b52dd3cd48', '984d2290-a63a-11ee-b682-015a80327a47', 5, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b5165a00-be1e-11ec-9222-db267923b89e', 'deb3cd90-be1c-11ec-92b5-d17e9a4e477d', 'd3c50930-be1c-11ec-92b5-d17e9a4e477d', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('deb41bb1-be1c-11ec-92b5-d17e9a4e477d', 'deb3cd90-be1c-11ec-92b5-d17e9a4e477d', 'c30371a0-be1b-11ec-a7fa-3529186828e2', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('df840d50-9def-11eb-b217-2bde6a29a24e', 'df837110-9def-11eb-b217-2bde6a29a24e', 'a18a9a72-9c4d-11ea-9434-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('df840d51-9def-11eb-b217-2bde6a29a24e', 'df837110-9def-11eb-b217-2bde6a29a24e', 'a18a2b50-9c4d-11ea-93ac-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('df840d52-9def-11eb-b217-2bde6a29a24e', 'df837110-9def-11eb-b217-2bde6a29a24e', 'a18a4716-9c4d-11ea-93d5-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('3dfddbb0-2163-11ee-888e-8daad14c2966', 'dfc097de-1a05-11eb-b954-0a5bf521835e', 'f2e68828-1a05-11eb-b54a-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e0204930-fb03-11ee-8b75-2926d2419fed', 'e01f5ed0-fb03-11ee-8b75-2926d2419fed', '8089bace-9c4d-11ea-92c6-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('b1b0bfa0-9dee-11eb-9fc3-c54eb2b1a2bd', 'e089f680-9ded-11eb-8c37-bb20979b8c2f', 'a18a2b50-9c4d-11ea-93ac-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('e08a92c0-9ded-11eb-8c37-bb20979b8c2f', 'e089f680-9ded-11eb-8c37-bb20979b8c2f', 'a18a99c8-9c4d-11ea-9433-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('2331f320-9786-11eb-9d7c-23923b7c2cc5', 'e10bb450-9784-11eb-818f-6d98184fe9ec', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 1.5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('e10c2980-9784-11eb-818f-6d98184fe9ec', 'e10bb450-9784-11eb-818f-6d98184fe9ec', 'a18a26c8-9c4d-11ea-93a9-0a5bf521835e', 300, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e10c5090-9784-11eb-818f-6d98184fe9ec', 'e10bb450-9784-11eb-818f-6d98184fe9ec', '8089c17c-9c4d-11ea-92cc-0a5bf521835e', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e11572e0-f0cb-11ed-b842-fb729038efc8', 'e113c530-f0cb-11ed-b842-fb729038efc8', '8089a0c0-9c4d-11ea-92a8-0a5bf521835e', 1000, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e11572e1-f0cb-11ed-b842-fb729038efc8', 'e113c530-f0cb-11ed-b842-fb729038efc8', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 500, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7aa11e20-de3f-11ef-b19c-c3b3bf5def36', 'e13c3290-bbb8-11ef-b71c-3fa77561451e', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7aa11e22-de3f-11ef-b19c-c3b3bf5def36', 'e13c3290-bbb8-11ef-b71c-3fa77561451e', '8089d838-9c4d-11ea-92e5-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('7aa11e24-de3f-11ef-b19c-c3b3bf5def36', 'e13c3290-bbb8-11ef-b71c-3fa77561451e', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7aa11e25-de3f-11ef-b19c-c3b3bf5def36', 'e13c3290-bbb8-11ef-b71c-3fa77561451e', '8089c258-9c4d-11ea-92cd-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7aa11e27-de3f-11ef-b19c-c3b3bf5def36', 'e13c3290-bbb8-11ef-b71c-3fa77561451e', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7aa11e29-de3f-11ef-b19c-c3b3bf5def36', 'e13c3290-bbb8-11ef-b71c-3fa77561451e', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('7aa11e2b-de3f-11ef-b19c-c3b3bf5def36', 'e13c3290-bbb8-11ef-b71c-3fa77561451e', '8089c406-9c4d-11ea-92cf-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('7aa14530-de3f-11ef-b19c-c3b3bf5def36', 'e13c3290-bbb8-11ef-b71c-3fa77561451e', 'a18a26c8-9c4d-11ea-93a9-0a5bf521835e', 300, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('7aa14532-de3f-11ef-b19c-c3b3bf5def36', 'e13c3290-bbb8-11ef-b71c-3fa77561451e', '15289b50-bba7-11ef-a2da-67539c782629', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('e291aca0-3087-11ee-af48-fb839ee61b42', 'e26a4e80-3087-11ee-af48-fb839ee61b42', 'a18ad640-9c4d-11ea-9477-0a5bf521835e', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('074984d0-d4c1-11ef-81b1-519beedbf8f8', 'e2a255e0-7cd5-11eb-9648-651da3a4a532', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('074984d1-d4c1-11ef-81b1-519beedbf8f8', 'e2a255e0-7cd5-11eb-9648-651da3a4a532', '8089d0a4-9c4d-11ea-92de-0a5bf521835e', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('0749abe0-d4c1-11ef-81b1-519beedbf8f8', 'e2a255e0-7cd5-11eb-9648-651da3a4a532', 'c4eddf70-e304-11eb-9b9e-0f6f0f6fa679', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e2f95c50-7580-11ed-9ceb-4384b0d4acc1', 'e2f871f0-7580-11ed-9ceb-4384b0d4acc1', 'e927cbf0-fb8e-11ec-82ff-e103d8d6432f', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e3ca7544-1a09-11eb-8de1-0a5bf521835e', 'e3c9e278-1a09-11eb-8de0-0a5bf521835e', '8089ae9e-9c4d-11ea-92b8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e44dea50-3081-11ee-af48-fb839ee61b42', 'e42a35b0-3081-11ee-af48-fb839ee61b42', 'c5655100-9eb6-11eb-846b-b95a8fb3fd70', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e44e1161-3081-11ee-af48-fb839ee61b42', 'e42a35b0-3081-11ee-af48-fb839ee61b42', '8089297e-9c4d-11ea-926b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e44e1162-3081-11ee-af48-fb839ee61b42', 'e42a35b0-3081-11ee-af48-fb839ee61b42', '80892a5a-9c4d-11ea-926c-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e4388590-9f68-11f0-99be-ff2defcc9a29', 'e437c240-9f68-11f0-99be-ff2defcc9a29', '32df9ea0-4e20-11ee-89fc-3b4978b6868d', 100, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('e4388592-9f68-11f0-99be-ff2defcc9a29', 'e437c240-9f68-11f0-99be-ff2defcc9a29', 'a18a491e-9c4d-11ea-93d8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('e4388593-9f68-11f0-99be-ff2defcc9a29', 'e437c240-9f68-11f0-99be-ff2defcc9a29', 'a18a4874-9c4d-11ea-93d7-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e4388594-9f68-11f0-99be-ff2defcc9a29', 'e437c240-9f68-11f0-99be-ff2defcc9a29', '808943f0-9c4d-11ea-928a-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('580fdd40-e486-11ef-ae90-c77ba71d6e00', 'e4be28a0-cc0e-11ee-a6b6-e7ad7f0affd8', 'a18a466c-9c4d-11ea-93d4-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('58100450-e486-11ef-ae90-c77ba71d6e00', 'e4be28a0-cc0e-11ee-a6b6-e7ad7f0affd8', 'cfb73310-9387-11eb-b551-3d9be8d1c5c7', 3, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('58100452-e486-11ef-ae90-c77ba71d6e00', 'e4be28a0-cc0e-11ee-a6b6-e7ad7f0affd8', '8089cfdc-9c4d-11ea-92dd-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('58102b61-e486-11ef-ae90-c77ba71d6e00', 'e4be28a0-cc0e-11ee-a6b6-e7ad7f0affd8', 'a18a99c8-9c4d-11ea-9433-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('73d04cc0-20f6-11f0-acf1-2d87a7025b77', 'e54b9770-55c8-11ed-b50c-474f649a5bc5', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('73d04cc1-20f6-11f0-acf1-2d87a7025b77', 'e54b9770-55c8-11ed-b50c-474f649a5bc5', 'a5b09760-55c7-11ed-b50c-474f649a5bc5', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('73d04cc3-20f6-11f0-acf1-2d87a7025b77', 'e54b9770-55c8-11ed-b50c-474f649a5bc5', 'a18a7fb0-9c4d-11ea-9412-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('e5fbdce0-308b-11ee-af48-fb839ee61b42', 'e5d6c8b0-308b-11ee-af48-fb839ee61b42', 'a18abfa2-9c4d-11ea-945a-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('cab94040-c98e-11ec-860d-478ebb9d77b5', 'e5e1fbe0-c15b-11ec-a2ba-7bb1dc10361f', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e5e24a00-c15b-11ec-a2ba-7bb1dc10361f', 'e5e1fbe0-c15b-11ec-a2ba-7bb1dc10361f', '8089cc80-9c4d-11ea-92d9-0a5bf521835e', 125, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e5e27110-c15b-11ec-a2ba-7bb1dc10361f', 'e5e1fbe0-c15b-11ec-a2ba-7bb1dc10361f', '80899ef4-9c4d-11ea-92a6-0a5bf521835e', 20, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e5e27111-c15b-11ec-a2ba-7bb1dc10361f', 'e5e1fbe0-c15b-11ec-a2ba-7bb1dc10361f', '808926cc-9c4d-11ea-9268-0a5bf521835e', 3, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e5e27112-c15b-11ec-a2ba-7bb1dc10361f', 'e5e1fbe0-c15b-11ec-a2ba-7bb1dc10361f', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e5e27113-c15b-11ec-a2ba-7bb1dc10361f', 'e5e1fbe0-c15b-11ec-a2ba-7bb1dc10361f', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('e67b55d0-307a-11ee-af48-fb839ee61b42', 'e6468a30-307a-11ee-af48-fb839ee61b42', 'a18a7830-9c4d-11ea-9407-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('e67b7ce0-307a-11ee-af48-fb839ee61b42', 'e6468a30-307a-11ee-af48-fb839ee61b42', 'a18a78da-9c4d-11ea-9408-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('f2fe1bf0-9a0c-11f0-94a8-ed31aa11b049', 'e6f3d5d0-4c36-11f0-8e4e-bf609a422157', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f2fe1bf1-9a0c-11f0-94a8-ed31aa11b049', 'e6f3d5d0-4c36-11f0-8e4e-bf609a422157', '1541beb0-21db-11f0-ac69-4ff8f2877233', 4, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f2fe4300-9a0c-11f0-94a8-ed31aa11b049', 'e6f3d5d0-4c36-11f0-8e4e-bf609a422157', '8089b312-9c4d-11ea-92bd-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f2fe4302-9a0c-11f0-94a8-ed31aa11b049', 'e6f3d5d0-4c36-11f0-8e4e-bf609a422157', '8089b920-9c4d-11ea-92c4-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('f2fe4304-9a0c-11f0-94a8-ed31aa11b049', 'e6f3d5d0-4c36-11f0-8e4e-bf609a422157', 'e760b460-4790-11ec-939f-314f99801403', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('f2fe4306-9a0c-11f0-94a8-ed31aa11b049', 'e6f3d5d0-4c36-11f0-8e4e-bf609a422157', 'a18a26c8-9c4d-11ea-93a9-0a5bf521835e', 300, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('f2fe4308-9a0c-11f0-94a8-ed31aa11b049', 'e6f3d5d0-4c36-11f0-8e4e-bf609a422157', '5b05ba10-cf50-11ef-9028-f1198bb1e3d6', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e76150a0-4790-11ec-939f-314f99801403', 'e760b460-4790-11ec-939f-314f99801403', '0d161320-1baf-11ec-9cd0-53f06f053e40', 1080, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('e7aa9c20-307c-11ee-af48-fb839ee61b42', 'e7727520-307c-11ee-af48-fb839ee61b42', 'a18a8712-9c4d-11ea-941d-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('e7aac330-307c-11ee-af48-fb839ee61b42', 'e7727520-307c-11ee-af48-fb839ee61b42', 'a18a87bc-9c4d-11ea-941e-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('e78958f2-19ec-11eb-a475-0a5bf521835e', 'e788cc3e-19ec-11eb-a474-0a5bf521835e', 'a18a2cae-9c4d-11ea-93ae-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e803ed70-3081-11ee-af48-fb839ee61b42', 'e7d9a920-3081-11ee-af48-fb839ee61b42', '68f22880-e3ad-11eb-8237-736a902b6e66', 120, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('e8278cf0-307f-11ee-af48-fb839ee61b42', 'e7ec58b0-307f-11ee-af48-fb839ee61b42', 'a18a7678-9c4d-11ea-9405-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('e8278cf1-307f-11ee-af48-fb839ee61b42', 'e7ec58b0-307f-11ee-af48-fb839ee61b42', 'a18a777c-9c4d-11ea-9406-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('24bae180-236d-11f0-a98f-152ce1f9f564', 'e877b220-7733-11ee-8098-81145f75bf63', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('24bae181-236d-11f0-a98f-152ce1f9f564', 'e877b220-7733-11ee-8098-81145f75bf63', '8089d0a4-9c4d-11ea-92de-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('24bae183-236d-11f0-a98f-152ce1f9f564', 'e877b220-7733-11ee-8098-81145f75bf63', 'a18a85b4-9c4d-11ea-941b-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('cc62ada0-be21-11ec-bc2e-4d33dd81b98a', 'e9464450-be20-11ec-a7fa-3529186828e2', '08727600-be21-11ec-bc2e-4d33dd81b98a', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e946b980-be20-11ec-a7fa-3529186828e2', 'e9464450-be20-11ec-a7fa-3529186828e2', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 4, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e946e090-be20-11ec-a7fa-3529186828e2', 'e9464450-be20-11ec-a7fa-3529186828e2', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e946e091-be20-11ec-a7fa-3529186828e2', 'e9464450-be20-11ec-a7fa-3529186828e2', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 17.5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e946e092-be20-11ec-a7fa-3529186828e2', 'e9464450-be20-11ec-a7fa-3529186828e2', '8089b696-9c4d-11ea-92c1-0a5bf521835e', 0.5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e946e094-be20-11ec-a7fa-3529186828e2', 'e9464450-be20-11ec-a7fa-3529186828e2', '808938ec-9c4d-11ea-927d-0a5bf521835e', 3.5, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e946e095-be20-11ec-a7fa-3529186828e2', 'e9464450-be20-11ec-a7fa-3529186828e2', '18ab8420-a8b6-11eb-9770-c18e5ed172e8', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('ea06a000-dfff-11ec-807b-81b583ff1692', 'ea05dcb0-dfff-11ec-807b-81b583ff1692', '3f700a20-c1a3-11ec-853d-e7960d3897c4', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ea06a001-dfff-11ec-807b-81b583ff1692', 'ea05dcb0-dfff-11ec-807b-81b583ff1692', '8089b9f2-9c4d-11ea-92c5-0a5bf521835e', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ea06a002-dfff-11ec-807b-81b583ff1692', 'ea05dcb0-dfff-11ec-807b-81b583ff1692', 'cab47370-9316-11ec-bdf2-dbb798a33559', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('ec4eeb50-3086-11ee-af48-fb839ee61b42', 'ec236e80-3086-11ee-af48-fb839ee61b42', '3468b980-e31c-11eb-8237-736a902b6e66', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ecb4dd60-2374-11f0-953f-0dfe025424db', 'ecb308a0-2374-11f0-953f-0dfe025424db', '8089bd76-9c4d-11ea-92c9-0a5bf521835e', 25, 'L');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ed0ab3f0-2161-11ee-8578-978bb1f27913', 'ed09c990-2161-11ee-8578-978bb1f27913', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('ed0ab3f1-2161-11ee-8578-978bb1f27913', 'ed09c990-2161-11ee-8578-978bb1f27913', '378429f0-46eb-11ec-939f-314f99801403', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ed0ab3f2-2161-11ee-8578-978bb1f27913', 'ed09c990-2161-11ee-8578-978bb1f27913', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('ed0ab3f3-2161-11ee-8578-978bb1f27913', 'ed09c990-2161-11ee-8578-978bb1f27913', 'e113c530-f0cb-11ed-b842-fb729038efc8', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ed0ab3f4-2161-11ee-8578-978bb1f27913', 'ed09c990-2161-11ee-8578-978bb1f27913', 'e747d290-f0c9-11ed-9ff6-59801b43f17c', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('ed0adb00-2161-11ee-8578-978bb1f27913', 'ed09c990-2161-11ee-8578-978bb1f27913', '9d5d7080-f0ca-11ed-9ff6-59801b43f17c', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ed0adb01-2161-11ee-8578-978bb1f27913', 'ed09c990-2161-11ee-8578-978bb1f27913', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('ed0adb02-2161-11ee-8578-978bb1f27913', 'ed09c990-2161-11ee-8578-978bb1f27913', '374bc7e0-f306-11ed-b0fa-47c95be3e3ca', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('ed0adb03-2161-11ee-8578-978bb1f27913', 'ed09c990-2161-11ee-8578-978bb1f27913', 'd480e330-f0ca-11ed-ada6-f1c2893b2f15', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('ed0adb04-2161-11ee-8578-978bb1f27913', 'ed09c990-2161-11ee-8578-978bb1f27913', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('5e8ebcb0-8121-11ed-9124-af8ed14a816a', 'ee38efd0-d50e-11ec-b5cd-3fba70e914e7', 'fcf1fa20-d1c2-11ec-88bd-5b29d81a78b4', 400, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('ee4042d0-d50e-11ec-b5cd-3fba70e914e7', 'ee38efd0-d50e-11ec-b5cd-3fba70e914e7', 'a18a47ca-9c4d-11ea-93d6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ee4042d2-d50e-11ec-b5cd-3fba70e914e7', 'ee38efd0-d50e-11ec-b5cd-3fba70e914e7', '3a5a9a90-f5ee-11eb-8f32-750a66e837fd', 30, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('efd0b8b0-307e-11ee-af48-fb839ee61b42', 'ef9b02b0-307e-11ee-af48-fb839ee61b42', 'ea05dcb0-dfff-11ec-807b-81b583ff1692', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('efd106d0-307e-11ee-af48-fb839ee61b42', 'ef9b02b0-307e-11ee-af48-fb839ee61b42', 'a18a4874-9c4d-11ea-93d7-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('efd106d1-307e-11ee-af48-fb839ee61b42', 'ef9b02b0-307e-11ee-af48-fb839ee61b42', 'a18a491e-9c4d-11ea-93d8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f097b050-7580-11ed-a0a7-1b2de41c84da', 'f09677d0-7580-11ed-a0a7-1b2de41c84da', 'e927cbf0-fb8e-11ec-82ff-e103d8d6432f', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f0f82590-b8d3-11f0-8023-f50462a02790', 'f0f73b30-b8d3-11f0-8023-f50462a02790', '8089c0aa-9c4d-11ea-92cb-0a5bf521835e', 1700, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f0f82591-b8d3-11f0-8023-f50462a02790', 'f0f73b30-b8d3-11f0-8023-f50462a02790', '8089cfdc-9c4d-11ea-92dd-0a5bf521835e', 1550, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f0f82592-b8d3-11f0-8023-f50462a02790', 'f0f73b30-b8d3-11f0-8023-f50462a02790', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f0f82593-b8d3-11f0-8023-f50462a02790', 'f0f73b30-b8d3-11f0-8023-f50462a02790', '80899b48-9c4d-11ea-92a2-0a5bf521835e', 680, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f0f84ca0-b8d3-11f0-8023-f50462a02790', 'f0f73b30-b8d3-11f0-8023-f50462a02790', '8089d522-9c4d-11ea-92e3-0a5bf521835e', 340, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f0f84ca1-b8d3-11f0-8023-f50462a02790', 'f0f73b30-b8d3-11f0-8023-f50462a02790', '8089b772-9c4d-11ea-92c2-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('f1b4eec0-308e-11ee-af48-fb839ee61b42', 'f17b6830-308e-11ee-af48-fb839ee61b42', 'a18a639a-9c4d-11ea-93f9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('f1b515d0-308e-11ee-af48-fb839ee61b42', 'f17b6830-308e-11ee-af48-fb839ee61b42', 'a18a644e-9c4d-11ea-93fa-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f1faf310-307b-11ee-af48-fb839ee61b42', 'f1cd5360-307b-11ee-af48-fb839ee61b42', '8089c258-9c4d-11ea-92cd-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f21554b0-3082-11ee-af48-fb839ee61b42', 'f1ee92d0-3082-11ee-af48-fb839ee61b42', '5409fdc0-be1e-11ec-92b5-d17e9a4e477d', 80, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('2f76fc70-2163-11ee-a3e8-f955b29df76d', 'f2e68828-1a05-11eb-b54a-0a5bf521835e', '844e6910-90f2-11ed-808a-65c448e0727c', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('4e8ad9e0-b815-11ed-bc1a-53d6e629924d', 'f453f830-55c7-11ed-8260-85ea4d40d179', 'a18a2cae-9c4d-11ea-93ae-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f454e290-55c7-11ed-8260-85ea4d40d179', 'f453f830-55c7-11ed-8260-85ea4d40d179', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f454e292-55c7-11ed-8260-85ea4d40d179', 'f453f830-55c7-11ed-8260-85ea4d40d179', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('f454e293-55c7-11ed-8260-85ea4d40d179', 'f453f830-55c7-11ed-8260-85ea4d40d179', 'e760b460-4790-11ec-939f-314f99801403', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f454e294-55c7-11ed-8260-85ea4d40d179', 'f453f830-55c7-11ed-8260-85ea4d40d179', '80899ef4-9c4d-11ea-92a6-0a5bf521835e', 200, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e94e7b30-cf51-11ef-ab41-33862f723ed5', 'f4bdfdc0-cf50-11ef-90af-61ebec49d20b', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('e94ea240-cf51-11ef-ab41-33862f723ed5', 'f4bdfdc0-cf50-11ef-90af-61ebec49d20b', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e94ea241-cf51-11ef-ab41-33862f723ed5', 'f4bdfdc0-cf50-11ef-90af-61ebec49d20b', '8089c258-9c4d-11ea-92cd-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e94ea243-cf51-11ef-ab41-33862f723ed5', 'f4bdfdc0-cf50-11ef-90af-61ebec49d20b', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e94ea245-cf51-11ef-ab41-33862f723ed5', 'f4bdfdc0-cf50-11ef-90af-61ebec49d20b', '8089b920-9c4d-11ea-92c4-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e94ea247-cf51-11ef-ab41-33862f723ed5', 'f4bdfdc0-cf50-11ef-90af-61ebec49d20b', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('e94ea249-cf51-11ef-ab41-33862f723ed5', 'f4bdfdc0-cf50-11ef-90af-61ebec49d20b', '8089c406-9c4d-11ea-92cf-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('e94ea24b-cf51-11ef-ab41-33862f723ed5', 'f4bdfdc0-cf50-11ef-90af-61ebec49d20b', 'a18a26c8-9c4d-11ea-93a9-0a5bf521835e', 300, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('e94ec950-cf51-11ef-ab41-33862f723ed5', 'f4bdfdc0-cf50-11ef-90af-61ebec49d20b', '5b05ba10-cf50-11ef-9028-f1198bb1e3d6', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('e94ec952-cf51-11ef-ab41-33862f723ed5', 'f4bdfdc0-cf50-11ef-90af-61ebec49d20b', 'a18a2b50-9c4d-11ea-93ac-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8026e5c0-c98c-11ec-a38a-8d13737e0b72', 'f6becfa0-c98b-11ec-885b-c998f5137173', 'a18a2f6a-9c4d-11ea-93b2-0a5bf521835e', 170, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('80270cd1-c98c-11ec-a38a-8d13737e0b72', 'f6becfa0-c98b-11ec-885b-c998f5137173', '80899fda-9c4d-11ea-92a7-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('80270cd2-c98c-11ec-a38a-8d13737e0b72', 'f6becfa0-c98b-11ec-885b-c998f5137173', '83dd7550-be2c-11ec-9222-db267923b89e', 40, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('80270cd3-c98c-11ec-a38a-8d13737e0b72', 'f6becfa0-c98b-11ec-885b-c998f5137173', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('802733e0-c98c-11ec-a38a-8d13737e0b72', 'f6becfa0-c98b-11ec-885b-c998f5137173', '0d161320-1baf-11ec-9cd0-53f06f053e40', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('802733e2-c98c-11ec-a38a-8d13737e0b72', 'f6becfa0-c98b-11ec-885b-c998f5137173', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('802733e3-c98c-11ec-a38a-8d13737e0b72', 'f6becfa0-c98b-11ec-885b-c998f5137173', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9ce0a0c0-c9a0-11ec-8b95-edfe4c030b67', 'f6becfa0-c98b-11ec-885b-c998f5137173', '8089cc80-9c4d-11ea-92d9-0a5bf521835e', 60, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9ce0a0c1-c9a0-11ec-8b95-edfe4c030b67', 'f6becfa0-c98b-11ec-885b-c998f5137173', '76bb1e20-c158-11ec-9265-d57037e66861', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c3f75a90-d27f-11ec-94f4-0b63ddc79043', 'f6becfa0-c98b-11ec-885b-c998f5137173', '8089b4ca-9c4d-11ea-92bf-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('33fc6cf0-20f6-11f0-b283-b7d039d59cfb', 'f73f86d0-952c-11ef-9dfb-cd4665e53e06', '6cfb1a70-952c-11ef-afc3-13d48984d813', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('33fc6cf2-20f6-11f0-b283-b7d039d59cfb', 'f73f86d0-952c-11ef-9dfb-cd4665e53e06', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('33fc6cf3-20f6-11f0-b283-b7d039d59cfb', 'f73f86d0-952c-11ef-9dfb-cd4665e53e06', 'a18a7f06-9c4d-11ea-9411-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f8654720-3083-11ee-af48-fb839ee61b42', 'f8434030-3083-11ee-af48-fb839ee61b42', '8089b696-9c4d-11ea-92c1-0a5bf521835e', 0.05, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f8b67030-308a-11ee-af48-fb839ee61b42', 'f890e6d0-308a-11ee-af48-fb839ee61b42', '076132f0-e3ad-11eb-8237-736a902b6e66', 750, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('f9389fe0-3087-11ee-af48-fb839ee61b42', 'f90c38b0-3087-11ee-af48-fb839ee61b42', 'a18ac628-9c4d-11ea-9463-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('f938c6f0-3087-11ee-af48-fb839ee61b42', 'f90c38b0-3087-11ee-af48-fb839ee61b42', 'a18ac6e6-9c4d-11ea-9464-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('f98deaa0-d5bf-11ec-9916-a1c1f658f229', 'f98cd930-d5bf-11ec-9916-a1c1f658f229', '931ca900-c156-11ec-853d-e7960d3897c4', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('f98deaa1-d5bf-11ec-9916-a1c1f658f229', 'f98cd930-d5bf-11ec-9916-a1c1f658f229', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('0fbde050-f0cc-11ed-b3e5-85bdede5075f', 'f9d5e230-f0c9-11ed-ada6-f1c2893b2f15', 'e747d290-f0c9-11ed-9ff6-59801b43f17c', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('0fbe2e70-f0cc-11ed-b3e5-85bdede5075f', 'f9d5e230-f0c9-11ed-ada6-f1c2893b2f15', 'e113c530-f0cb-11ed-b842-fb729038efc8', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('43209160-f304-11ed-b0fa-47c95be3e3ca', 'f9d5e230-f0c9-11ed-ada6-f1c2893b2f15', '378429f0-46eb-11ec-939f-314f99801403', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('550c3490-f306-11ed-9ff6-59801b43f17c', 'f9d5e230-f0c9-11ed-ada6-f1c2893b2f15', '374bc7e0-f306-11ed-b0fa-47c95be3e3ca', 100, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8a5d5340-f0cc-11ed-b842-fb729038efc8', 'f9d5e230-f0c9-11ed-ada6-f1c2893b2f15', 'd480e330-f0ca-11ed-ada6-f1c2893b2f15', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9ce40fe0-f0cc-11ed-ada6-f1c2893b2f15', 'f9d5e230-f0c9-11ed-ada6-f1c2893b2f15', '9d5d7080-f0ca-11ed-9ff6-59801b43f17c', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('c2146520-f316-11ed-babd-c932e64ef53a', 'f9d5e230-f0c9-11ed-ada6-f1c2893b2f15', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f9d6cc91-f0c9-11ed-ada6-f1c2893b2f15', 'f9d5e230-f0c9-11ed-ada6-f1c2893b2f15', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 70, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('f9d6cc93-f0c9-11ed-ada6-f1c2893b2f15', 'f9d5e230-f0c9-11ed-ada6-f1c2893b2f15', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('fb119080-3085-11ee-af48-fb839ee61b42', 'fa3e6200-3085-11ee-af48-fb839ee61b42', '8f1cd300-c153-11ec-a2ba-7bb1dc10361f', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('fad43a60-307a-11ee-af48-fb839ee61b42', 'faad0350-307a-11ee-af48-fb839ee61b42', '9461e7ac-19ec-11eb-b914-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9ab16a10-0a38-11f0-b543-b7f780083816', 'faf38230-cf2b-11ee-9180-5f1b01ee3b04', 'a18a4de2-9c4d-11ea-93df-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('9ab16a12-0a38-11f0-b543-b7f780083816', 'faf38230-cf2b-11ee-9180-5f1b01ee3b04', 'a18a43b0-9c4d-11ea-93d0-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9ab20650-0a38-11f0-b543-b7f780083816', 'faf38230-cf2b-11ee-9180-5f1b01ee3b04', '4c217cf0-cf15-11ee-9196-c5c68bf4c631', 5, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('fbd14d20-307c-11ee-af48-fb839ee61b42', 'fbab2780-307c-11ee-af48-fb839ee61b42', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('9ca2c0c0-c1c6-11ec-a2ba-7bb1dc10361f', 'fc0ae680-c150-11ec-a2ba-7bb1dc10361f', '7a9b0d70-c1c6-11ec-853d-e7960d3897c4', 2, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('fc0b34a0-c150-11ec-a2ba-7bb1dc10361f', 'fc0ae680-c150-11ec-a2ba-7bb1dc10361f', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('fc0b34a1-c150-11ec-a2ba-7bb1dc10361f', 'fc0ae680-c150-11ec-a2ba-7bb1dc10361f', '8089b4ca-9c4d-11ea-92bf-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('fc0b34a2-c150-11ec-a2ba-7bb1dc10361f', 'fc0ae680-c150-11ec-a2ba-7bb1dc10361f', '8089b312-9c4d-11ea-92bd-0a5bf521835e', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('fc0b34a3-c150-11ec-a2ba-7bb1dc10361f', 'fc0ae680-c150-11ec-a2ba-7bb1dc10361f', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('fc0b5bb0-c150-11ec-a2ba-7bb1dc10361f', 'fc0ae680-c150-11ec-a2ba-7bb1dc10361f', 'a18a2f6a-9c4d-11ea-93b2-0a5bf521835e', 170, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('fc0b5bb1-c150-11ec-a2ba-7bb1dc10361f', 'fc0ae680-c150-11ec-a2ba-7bb1dc10361f', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('fc0b5bb2-c150-11ec-a2ba-7bb1dc10361f', 'fc0ae680-c150-11ec-a2ba-7bb1dc10361f', '808982ac-9c4d-11ea-929f-0a5bf521835e', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8d306640-de3f-11ef-b6d3-554965be2b1a', 'fcaa98f0-bbb8-11ef-bb4e-b5c75a97c9e7', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8d308d51-de3f-11ef-b6d3-554965be2b1a', 'fcaa98f0-bbb8-11ef-bb4e-b5c75a97c9e7', 'a18a3e42-9c4d-11ea-93c8-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8d308d52-de3f-11ef-b6d3-554965be2b1a', 'fcaa98f0-bbb8-11ef-bb4e-b5c75a97c9e7', '8089c258-9c4d-11ea-92cd-0a5bf521835e', 10, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8d308d54-de3f-11ef-b6d3-554965be2b1a', 'fcaa98f0-bbb8-11ef-bb4e-b5c75a97c9e7', '8089cfdc-9c4d-11ea-92dd-0a5bf521835e', 110, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8d30b460-de3f-11ef-b6d3-554965be2b1a', 'fcaa98f0-bbb8-11ef-bb4e-b5c75a97c9e7', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8d30b462-de3f-11ef-b6d3-554965be2b1a', 'fcaa98f0-bbb8-11ef-bb4e-b5c75a97c9e7', '8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('8d30b464-de3f-11ef-b6d3-554965be2b1a', 'fcaa98f0-bbb8-11ef-bb4e-b5c75a97c9e7', '8089c406-9c4d-11ea-92cf-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8d30b466-de3f-11ef-b6d3-554965be2b1a', 'fcaa98f0-bbb8-11ef-bb4e-b5c75a97c9e7', 'a18a26c8-9c4d-11ea-93a9-0a5bf521835e', 300, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('8d30db71-de3f-11ef-b6d3-554965be2b1a', 'fcaa98f0-bbb8-11ef-bb4e-b5c75a97c9e7', '15289b50-bba7-11ef-a2da-67539c782629', 150, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('fd4ce810-041a-11ed-ba73-47672f6aff75', 'fd4c24c0-041a-11ed-ba73-47672f6aff75', '0e0a0240-ebf3-11ec-a12f-77342cf624c3', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('fd4ce811-041a-11ed-ba73-47672f6aff75', 'fd4c24c0-041a-11ed-ba73-47672f6aff75', 'a18a3ef6-9c4d-11ea-93c9-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('1fcf8ce0-f6d7-11ec-86ff-13fce83436c9', 'fda50190-f6d1-11ec-87d3-cf5d212ef325', '47398600-f6d2-11ec-82ff-e103d8d6432f', 50, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('fda59dd0-f6d1-11ec-87d3-cf5d212ef325', 'fda50190-f6d1-11ec-87d3-cf5d212ef325', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 30, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('fda5c4e0-f6d1-11ec-87d3-cf5d212ef325', 'fda50190-f6d1-11ec-87d3-cf5d212ef325', '8089d298-9c4d-11ea-92e0-0a5bf521835e', 6, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('fda5c4e1-f6d1-11ec-87d3-cf5d212ef325', 'fda50190-f6d1-11ec-87d3-cf5d212ef325', '5409fdc0-be1e-11ec-92b5-d17e9a4e477d', 80, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('fda5c4e2-f6d1-11ec-87d3-cf5d212ef325', 'fda50190-f6d1-11ec-87d3-cf5d212ef325', '8089c406-9c4d-11ea-92cf-0a5bf521835e', 40, 'kg');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('fda5c4e3-f6d1-11ec-87d3-cf5d212ef325', 'fda50190-f6d1-11ec-87d3-cf5d212ef325', 'a18a2f6a-9c4d-11ea-93b2-0a5bf521835e', 170, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('fda5c4e4-f6d1-11ec-87d3-cf5d212ef325', 'fda50190-f6d1-11ec-87d3-cf5d212ef325', '8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 90, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('fda5c4e5-f6d1-11ec-87d3-cf5d212ef325', 'fda50190-f6d1-11ec-87d3-cf5d212ef325', '6d016550-6fd4-11eb-a4bf-c58d44f967d3', 5, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('fda5ebf0-f6d1-11ec-87d3-cf5d212ef325', 'fda50190-f6d1-11ec-87d3-cf5d212ef325', '8089b312-9c4d-11ea-92bd-0a5bf521835e', 25, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('fda5ebf1-f6d1-11ec-87d3-cf5d212ef325', 'fda50190-f6d1-11ec-87d3-cf5d212ef325', '80893c3e-9c4d-11ea-9281-0a5bf521835e', 12, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('fda61300-f6d1-11ec-87d3-cf5d212ef325', 'fda50190-f6d1-11ec-87d3-cf5d212ef325', '8089b4ca-9c4d-11ea-92bf-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('fe259f90-308b-11ee-af48-fb839ee61b42', 'fdfc93c0-308b-11ee-af48-fb839ee61b42', 'fcf1fa20-d1c2-11ec-88bd-5b29d81a78b4', 400, 'L');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('fe25c6a0-308b-11ee-af48-fb839ee61b42', 'fdfc93c0-308b-11ee-af48-fb839ee61b42', 'a18a47ca-9c4d-11ea-93d6-0a5bf521835e', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('142f35e0-c19c-11ec-9265-d57037e66861', 'ff41d980-c19b-11ec-b810-d1ffe210d8b1', '202590d0-be1b-11ec-9222-db267923b89e', 5, 'unite');
INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES ('838dff20-c566-11ec-80c5-cfbaa9dcc3bd', 'ff41d980-c19b-11ec-b810-d1ffe210d8b1', '4018f880-c19c-11ec-b810-d1ffe210d8b1', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ff4275c1-c19b-11ec-b810-d1ffe210d8b1', 'ff41d980-c19b-11ec-b810-d1ffe210d8b1', '8089d37e-9c4d-11ea-92e1-0a5bf521835e', 15, 'kg');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ff83a4e0-757e-11ed-9ceb-4384b0d4acc1', 'ff829370-757e-11ed-9ceb-4384b0d4acc1', '67bc3410-72b0-11eb-a732-3588446adb69', 1, 'unite');
INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES ('ff83a4e1-757e-11ed-9ceb-4384b0d4acc1', 'ff829370-757e-11ed-9ceb-4384b0d4acc1', '80891f2e-9c4d-11ea-925f-0a5bf521835e', 1, 'unite');

-- Initialize stocks (all at 0)
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('076132f0-e3ad-11eb-8237-736a902b6e66', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('03c6ec00-d386-11ed-8873-3d005b07a028', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('04f43df0-7d4e-11ed-9124-af8ed14a816a', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('001f3140-ef92-11eb-bbe5-ef0537d994fa', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('0176d3d0-7d4a-11ed-bef2-3be33b07e51f', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('070c0f70-d387-11ed-b5ed-85ce7cabeb42', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('033209b0-09cd-11ed-8e50-07ad3601b8bc', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('06656f60-b230-11ef-9c6e-779763fa7658', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('07b0e2e0-ee1c-11eb-8cf4-3f10540222ef', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('07c64f70-a8eb-11eb-a511-a582f5c4cbb1', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('08c02da0-da60-11eb-88cc-6f7cfe428a18', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('097085c0-1f09-11ee-bc5c-5d86ba5dc90c', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('08727600-be21-11ec-bc2e-4d33dd81b98a', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('09c960e0-117e-11f1-ae64-1f8e3f56f901', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('0dab1460-4e2b-11ee-8d17-29eec0ef8ef1', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('0b64ad20-e54a-11eb-b993-552ff2e9d866', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('0b4a7e70-e53a-11ef-ae90-c77ba71d6e00', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('0d161320-1baf-11ec-9cd0-53f06f053e40', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('0b9ba290-e1ea-11ee-9824-b524be6ecff3', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('0f24c2c0-7d4b-11ed-b263-b95e21b5e348', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('11608c10-bdf2-11ef-ba0c-d9e4e2a63cd3', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('12506e40-e277-11ed-9686-4bbf18f0f5ed', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('15854ed0-6bb6-11eb-80f6-73940ffe6b4a', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('1541beb0-21db-11f0-ac69-4ff8f2877233', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('10212950-5147-11ed-ae1b-9d995079b109', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('1288ef60-f30a-11ed-ada6-f1c2893b2f15', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('0e8b62f0-21d2-11f0-840c-7186b075b488', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('0fb01600-7d4f-11ed-9124-af8ed14a816a', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('17d942f0-c275-11ed-b116-d7b40111f808', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('1c0a2560-a8eb-11eb-9cae-41439e88333c', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('19ae6ea0-7d49-11ed-9124-af8ed14a816a', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('18ab8420-a8b6-11eb-9770-c18e5ed172e8', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('1a99aa30-d386-11ed-991b-f3f2287d9251', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('1edcd750-4d86-11ee-b55c-159c4c7fd68f', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('1ccd9ea0-a8fa-11eb-9cae-41439e88333c', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('202590d0-be1b-11ec-9222-db267923b89e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('21cb1ba0-d38a-11ed-a335-b118b249b5d3', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('21dd4110-91c0-11ed-b4d4-2171468c5ab0', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('218671b0-1f05-11ed-b87e-25470f2449dc', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('26d4cc10-d865-11ed-9677-6bd4a1cc96ce', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('26662f50-e277-11ed-bd5b-0f903c199e04', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('2aad0c00-e31e-11eb-8237-736a902b6e66', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('2af3efe0-bdfd-11ef-a034-73777b7f79b7', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('2280bae0-20fa-11f0-ab9e-b3d91cd9f60a', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('29372760-da73-11f0-ad55-178a15fbfae9', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('28362d70-1f09-11ee-8289-e38a95489b1f', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('2b68f4e0-5147-11ed-b50c-474f649a5bc5', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('2b877c00-46bf-11ec-939f-314f99801403', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('26c8acb0-a332-11eb-a60c-5545ff63e985', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('2e3b3e20-4617-11ed-b8df-c363575b0859', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('2cf1bfa0-19f7-11ec-967c-692187d0a72f', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('2dbdce80-8805-11eb-b96f-7177973d12e2', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('305de0c0-d395-11ed-89d3-cf05f605d483', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('32df9ea0-4e20-11ee-89fc-3b4978b6868d', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('2f232d10-ec86-11ec-9630-193a22d236be', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('34fbcd00-a33a-11eb-84f4-0b99e046e5f3', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('32bb7eb0-2d65-11ef-a188-f3703d636499', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('35deb170-d398-11ed-bf32-3110e1284941', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('39983170-bba8-11ef-8612-e5fe96a59ed9', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('42afc510-7d4e-11ed-b263-b95e21b5e348', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('3d046180-bdf1-11ef-b77b-b5f02a7171be', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('419abe30-4e29-11ee-99c3-efac9f73b6b5', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('384576e0-e3be-11eb-b4a4-c79ec670c12e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('3ed4bfb0-7d4c-11ed-a047-fb061caa6559', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('3c1aade0-4d83-11ee-9848-af14af9a4362', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('3a5a9a90-f5ee-11eb-8f32-750a66e837fd', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('46b9cde0-7d49-11ed-bef2-3be33b07e51f', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('3c859810-3a7b-11ed-9f9b-fb5c16910c99', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('457af520-d394-11ed-9c3f-53b8785e19c0', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('48203b90-a63a-11ee-941d-29757a71a6ae', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('48734040-c1a5-11ec-853d-e7960d3897c4', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('43802dc0-4e2e-11ee-8d17-29eec0ef8ef1', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('498ec2a0-e54c-11eb-be8e-9f30aafccd7a', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('4c217cf0-cf15-11ee-9196-c5c68bf4c631', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('4bd60d30-7d48-11ed-a047-fb061caa6559', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('4b420b70-1f8e-11ed-b87e-25470f2449dc', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('4cdc9920-9eff-11f0-b3c9-33035a5842ae', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('5439a090-7d4d-11ed-9124-af8ed14a816a', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('550da450-7d4b-11ed-b263-b95e21b5e348', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('4d17d8d0-2d65-11ef-b990-47930060fae2', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('562ac320-f4f5-11eb-9855-6d337dfcae57', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('53090f20-19f4-11ec-b6d2-6571eca8bd6a', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('570c0710-f5d4-11eb-8ccc-17901c63413d', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('59a0b220-7e80-11ec-bafd-fb0d701e3442', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('5409fdc0-be1e-11ec-92b5-d17e9a4e477d', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('4fd6e900-d38c-11ed-a335-b118b249b5d3', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('57387cf0-b8d5-11f0-8023-f50462a02790', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('5ccdcfd0-a63a-11ee-90ac-0338ca361de0', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('5ec23a80-f842-11ec-87d3-cf5d212ef325', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('60f608e0-d398-11ed-a90f-effe91255ffc', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('602f4f30-a8f1-11eb-a272-274b1324dbc5', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('60698600-a333-11eb-a82e-d37eb9df5ff1', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('5bd9afd0-4e2a-11ee-8d17-29eec0ef8ef1', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('61767070-7d49-11ed-a047-fb061caa6559', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('5ff10d10-f4f5-11eb-9855-6d337dfcae57', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('5cf92180-dc2e-11ec-ae34-1dcb862714d3', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('6121a440-7d4a-11ed-b263-b95e21b5e348', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('63466fb0-a8f0-11eb-a511-a582f5c4cbb1', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('6289ccb0-6bb6-11eb-aac1-2355e6ce6dd2', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('61d22480-f840-11ec-a176-d902a1918d35', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('65efe100-4d86-11ee-a7f1-87190e351617', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('6957aad0-f4f5-11eb-a95c-45ac352893ba', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('68f22880-e3ad-11eb-8237-736a902b6e66', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('67bc3410-72b0-11eb-a732-3588446adb69', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('67fffe90-7d4c-11ed-bef2-3be33b07e51f', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('6286a130-fb92-11ec-87d3-cf5d212ef325', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('66ff9a30-00f8-11ed-82ff-e103d8d6432f', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('6b66cd30-23dc-11ed-8331-7f9fd88301ac', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('6bb818c0-d045-11eb-9f02-bf5812513161', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('6ea4c720-c1a5-11ec-853d-e7960d3897c4', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('6c028cc0-fb73-11ec-87d3-cf5d212ef325', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('6eaefda0-a63a-11ee-941d-29757a71a6ae', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('6befbf50-6168-11ec-b4f3-f589907dab6b', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('6e078db0-be2c-11ec-92b5-d17e9a4e477d', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('6d016550-6fd4-11eb-a4bf-c58d44f967d3', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('6be24a70-da70-11f0-8612-8be369b626f7', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('6e48f33a-abce-11ea-ad20-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('75410240-7d4a-11ed-b263-b95e21b5e348', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('70a95120-fb76-11ec-82ff-e103d8d6432f', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('6fdb4200-fb92-11ec-a176-d902a1918d35', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('76bb1e20-c158-11ec-9265-d57037e66861', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('6ee353a0-fb75-11ec-86ff-13fce83436c9', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('77aa7da0-7d49-11ed-9124-af8ed14a816a', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('76aa31a0-2370-11f0-8b17-c9ef36ffc4e8', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('72a76ef0-9eff-11f0-aced-2f0ff397d130', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('74a7fbc0-5146-11ed-b50c-474f649a5bc5', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('6f6abe40-4e2f-11ee-9a37-c1fb9a9e60bd', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('7a3903c0-d398-11ed-9c3f-53b8785e19c0', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('7a9b0d70-c1c6-11ec-853d-e7960d3897c4', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('791cdaa0-4d84-11ee-bde1-5fde63a70b93', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('79da2e70-bdef-11ef-be99-f72f1fb7b2f1', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('7dc74cc0-5145-11ed-ae1b-9d995079b109', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('7dac17b0-6757-11ee-a127-bd5aba4de5fc', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('7b06f6a0-601f-11ed-ba86-0916fa7dd2eb', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('7d3cb780-c9ca-11eb-b7f7-8b9a3a648073', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('78f6cb20-e3ce-11eb-be8e-9f30aafccd7a', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('7f9bfdb0-87b2-11eb-b06e-f714206729cb', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8088c240-9c4d-11ea-925e-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('808921ea-9c4d-11ea-9262-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80891f2e-9c4d-11ea-925f-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80892032-9c4d-11ea-9260-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089260e-9c4d-11ea-9267-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('808922c6-9c4d-11ea-9263-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089246a-9c4d-11ea-9265-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089212c-9c4d-11ea-9261-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80892532-9c4d-11ea-9266-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089238e-9c4d-11ea-9264-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('808928ac-9c4d-11ea-926a-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('808927a8-9c4d-11ea-9269-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089297e-9c4d-11ea-926b-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('808926cc-9c4d-11ea-9268-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80892e92-9c4d-11ea-9271-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80892a5a-9c4d-11ea-926c-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80892cda-9c4d-11ea-926f-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80892dc0-9c4d-11ea-9270-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80892b22-9c4d-11ea-926d-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80892c12-9c4d-11ea-926e-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('808931ee-9c4d-11ea-9275-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80893112-9c4d-11ea-9274-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80893658-9c4d-11ea-927a-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80893036-9c4d-11ea-9273-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80893496-9c4d-11ea-9278-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80893572-9c4d-11ea-9279-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80892f64-9c4d-11ea-9272-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('808933c4-9c4d-11ea-9277-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80893748-9c4d-11ea-927b-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('808932c0-9c4d-11ea-9276-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('808939be-9c4d-11ea-927e-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('808938ec-9c4d-11ea-927d-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80893810-9c4d-11ea-927c-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80893f90-9c4d-11ea-9285-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80893a90-9c4d-11ea-927f-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80893ec8-9c4d-11ea-9284-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80893d1a-9c4d-11ea-9282-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80893b6c-9c4d-11ea-9280-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80893c3e-9c4d-11ea-9281-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80893de2-9c4d-11ea-9283-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80894170-9c4d-11ea-9287-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80896f06-9c4d-11ea-928c-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80897000-9c4d-11ea-928d-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('808971ae-9c4d-11ea-928f-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80894328-9c4d-11ea-9289-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089408a-9c4d-11ea-9286-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('808944cc-9c4d-11ea-928b-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089424c-9c4d-11ea-9288-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('808970d2-9c4d-11ea-928e-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('808943f0-9c4d-11ea-928a-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089737a-9c4d-11ea-9291-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80897442-9c4d-11ea-9292-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80897280-9c4d-11ea-9290-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80897884-9c4d-11ea-9294-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80897a3c-9c4d-11ea-9296-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80897b0e-9c4d-11ea-9297-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80897bea-9c4d-11ea-9298-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80897cbc-9c4d-11ea-9299-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089751e-9c4d-11ea-9293-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80897960-9c4d-11ea-9295-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80897e56-9c4d-11ea-929b-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80897d8e-9c4d-11ea-929a-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80898374-9c4d-11ea-92a0-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80899c4c-9c4d-11ea-92a3-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80899a4e-9c4d-11ea-92a1-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80897f50-9c4d-11ea-929c-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80899b48-9c4d-11ea-92a2-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('808981d0-9c4d-11ea-929e-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80898022-9c4d-11ea-929d-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('808982ac-9c4d-11ea-929f-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80899d1e-9c4d-11ea-92a4-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80899df0-9c4d-11ea-92a5-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80899ef4-9c4d-11ea-92a6-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089a390-9c4d-11ea-92ab-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089a2b4-9c4d-11ea-92aa-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089a534-9c4d-11ea-92ad-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('80899fda-9c4d-11ea-92a7-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089a1ba-9c4d-11ea-92a9-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089a0c0-9c4d-11ea-92a8-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089a462-9c4d-11ea-92ac-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089a8cc-9c4d-11ea-92b1-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089a7fa-9c4d-11ea-92b0-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089ac28-9c4d-11ea-92b5-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089add6-9c4d-11ea-92b7-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089aa7a-9c4d-11ea-92b3-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089a71e-9c4d-11ea-92af-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089a99e-9c4d-11ea-92b2-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089a61a-9c4d-11ea-92ae-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089ab4c-9c4d-11ea-92b4-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089acfa-9c4d-11ea-92b6-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089af7a-9c4d-11ea-92b9-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089ae9e-9c4d-11ea-92b8-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089b3ee-9c4d-11ea-92be-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089b4ca-9c4d-11ea-92bf-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089b5ba-9c4d-11ea-92c0-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089b696-9c4d-11ea-92c1-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089b312-9c4d-11ea-92bd-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089b16e-9c4d-11ea-92bb-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089b236-9c4d-11ea-92bc-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089b772-9c4d-11ea-92c2-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089b9f2-9c4d-11ea-92c5-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089b844-9c4d-11ea-92c3-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089bace-9c4d-11ea-92c6-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089b920-9c4d-11ea-92c4-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089bc9a-9c4d-11ea-92c8-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089bf42-9c4d-11ea-92ca-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089c0aa-9c4d-11ea-92cb-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089bd76-9c4d-11ea-92c9-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089c17c-9c4d-11ea-92cc-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089bbbe-9c4d-11ea-92c7-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089c4d8-9c4d-11ea-92d0-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089c5be-9c4d-11ea-92d1-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089c32a-9c4d-11ea-92ce-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089c258-9c4d-11ea-92cd-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089c690-9c4d-11ea-92d2-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089c406-9c4d-11ea-92cf-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089c852-9c4d-11ea-92d4-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089ca00-9c4d-11ea-92d6-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089c924-9c4d-11ea-92d5-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089c780-9c4d-11ea-92d3-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089cd5c-9c4d-11ea-92da-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089cac8-9c4d-11ea-92d7-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089cf00-9c4d-11ea-92dc-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089cbae-9c4d-11ea-92d8-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089d1c6-9c4d-11ea-92df-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089ce24-9c4d-11ea-92db-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089d298-9c4d-11ea-92e0-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089cfdc-9c4d-11ea-92dd-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089cc80-9c4d-11ea-92d9-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089d90a-9c4d-11ea-92e6-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089d522-9c4d-11ea-92e3-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089d446-9c4d-11ea-92e2-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089d37e-9c4d-11ea-92e1-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089d838-9c4d-11ea-92e5-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('88c4aa00-a33b-11eb-a68c-ebc667a0f6a6', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('844e6910-90f2-11ed-808a-65c448e0727c', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('84398c10-601f-11ed-85c3-e1b33cb1c0b7', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('83dd7550-be2c-11ec-9222-db267923b89e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8089d0a4-9c4d-11ea-92de-0a5bf521835e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('88c9e970-e482-11ef-aa41-01eb4d41c1d0', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8cb796e0-a63a-11ee-b3cd-3d8b47d7dc66', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('905c80f0-9eb6-11eb-b217-2bde6a29a24e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('89c0dd60-00ee-11f0-9d98-b7ea8c718efe', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8f221700-4d81-11ee-9848-af14af9a4362', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('952356e0-8d98-11ed-b5d4-d30635a860b5', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('96d871b0-b37b-11ed-9ea0-d38c4a9947cb', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8faec180-7d4a-11ed-b263-b95e21b5e348', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('94e89f80-d4be-11eb-8c4c-2fe8d4c30ca4', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('8eda7860-7cd6-11eb-83c2-81353eec23fb', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('91d84850-9dfe-11f0-ad3e-2792898a72a1', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('9fe020a0-e31b-11eb-b993-552ff2e9d866', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('9e0f3020-d385-11ed-b3c8-cd0e0e620070', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('98361850-77a3-11ed-9a28-4df3cd6470f6', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('984d2290-a63a-11ee-b682-015a80327a47', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('96ef61c0-916f-11eb-9d41-2dd57a3d8f5e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('9724eb40-55c9-11ed-8260-85ea4d40d179', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('9846ad50-5147-11ed-b50c-474f649a5bc5', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('9898f160-7d4c-11ed-b263-b95e21b5e348', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('9e7f4730-9eb6-11eb-846b-b95a8fb3fd70', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('a20c0f10-7d48-11ed-a047-fb061caa6559', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('aef2a440-20b9-11ee-8622-37df65c2b093', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('a5980d40-7d4e-11ed-9124-af8ed14a816a', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('a54f72d0-d864-11ed-a335-b118b249b5d3', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('a3e37730-ede1-11eb-b539-d109965a1b2f', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('b54c7000-7d4e-11ed-a047-fb061caa6559', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('a54866e0-6ae6-11eb-80f6-73940ffe6b4a', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('ad6b1c90-19f6-11ec-964d-47192e0197c6', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('a84e6e30-da70-11f0-adac-a3171657b79f', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('b5996970-7d4c-11ed-bef2-3be33b07e51f', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('a39ec9b0-d38f-11ed-9677-6bd4a1cc96ce', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('b59bf6e0-d864-11ed-9aa1-ef27351cff41', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('b6016290-bb2a-11f0-9bda-f77aaf7b1906', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('b5bcc650-6c3b-11eb-830a-2b05dd6006ef', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('bb248820-c310-11ed-9c70-752f0462a215', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('ba162090-7eb7-11ec-bafd-fb0d701e3442', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('bc30cef0-2370-11f0-ac9f-fffdeb0f868f', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('b7c1c370-d38a-11ed-9677-6bd4a1cc96ce', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('ba102e80-d1f8-11ec-b363-f7982c6efb86', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('b632b350-5146-11ed-b50c-474f649a5bc5', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('ba0d5480-6686-11ed-a031-8b54f9890809', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('c08fb080-da70-11f0-aed4-7d96cdc22e1f', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('bf29fff0-c1a8-11ec-b810-d1ffe210d8b1', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('c2209b50-4d85-11ee-b1b9-d7aabbfa3a52', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('c39076e0-6023-11ed-8dc7-092ea485f5d7', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('c5a46030-bb2a-11f0-9bda-f77aaf7b1906', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('bfd9c020-d395-11ed-a335-b118b249b5d3', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('c384cf60-a8b5-11eb-9cae-41439e88333c', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('c523b650-7d49-11ed-b263-b95e21b5e348', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('c62145d0-8c13-11ed-a977-852f0d1617fb', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('cf2ba4a0-74c4-11ee-bc12-d54052347f51', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('cfbb0da0-08fb-11ee-8674-bb09560c03c4', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('c88ce710-7d4b-11ed-b263-b95e21b5e348', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('c7c73660-2836-11ed-b785-09840579bd69', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('cd5461e0-bf8f-11eb-ba7c-19483afb8580', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('cc3d2e20-7cf7-11eb-83c2-81353eec23fb', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('cf5aa960-2370-11f0-8b95-0ba6cd1a2e00', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('cab47370-9316-11ec-bdf2-dbb798a33559', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('d0f323c0-b740-11ef-95c4-57b2d144b46f', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('c5655100-9eb6-11eb-846b-b95a8fb3fd70', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('d0ceb8f0-3583-11ed-9548-ed051dc9e4fe', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('d627b890-d864-11ed-89d3-cf05f605d483', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('d632baa0-ebcb-11ec-9630-193a22d236be', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('d7dc0a50-77a3-11ed-9df8-0bd02a42dd7f', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('d6825b50-bdf1-11ef-ba0c-d9e4e2a63cd3', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('d3adbff0-fb8e-11ec-86ff-13fce83436c9', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('d971c9b0-6685-11ed-8cf9-1de12f567f43', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('dd840f20-bf8f-11eb-8fcb-8ba60eb97259', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('dc85cbf0-5146-11ed-9fe9-c12459cc1b44', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('da05ca10-ab96-11ed-9bd5-bfc79caa022b', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('d257ad90-9eb6-11eb-98d0-4d3123634f37', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('ddca0900-2370-11f0-bb68-a1d2c971872e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('dee419c0-c1a8-11ec-853d-e7960d3897c4', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('e902d420-2d90-11ec-ac7d-edfd3dbf0302', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('e0db1a50-7d4e-11ed-bef2-3be33b07e51f', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('e927cbf0-fb8e-11ec-82ff-e103d8d6432f', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('e747d290-f0c9-11ed-9ff6-59801b43f17c', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('e7240c10-7d48-11ed-a047-fb061caa6559', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('e704fed0-a8ea-11eb-a272-274b1324dbc5', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('e61c84e0-4d82-11ee-b1b9-d7aabbfa3a52', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('f37315a0-e542-11eb-8237-736a902b6e66', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('f2e91490-9eb6-11eb-b217-2bde6a29a24e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('ebbcfde0-ef91-11eb-bbe5-ef0537d994fa', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('f0deb290-fe75-11ef-9f24-3dea27761cfa', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('ec92a780-4d84-11ee-a7f1-87190e351617', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('e9d88d10-b944-11eb-acec-29fb8569cb50', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('f0198690-7d4a-11ed-b263-b95e21b5e348', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('eb643230-fe6c-11ef-a70a-c30a5e202927', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('ebee1fa0-9eb6-11eb-98d0-4d3123634f37', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('f189f420-2853-11ed-8172-37c06f5b9a95', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('f7663c30-5933-11ed-988a-6df56d6d4bf0', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('f456eba0-d38d-11ed-9c3f-53b8785e19c0', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('f6545520-fe77-11ef-abd3-1d5bab16a12f', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('f6ba4130-ef91-11eb-b539-d109965a1b2f', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('f7fccfe0-d392-11ed-993e-3b5e3ecd3f4f', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('f8c2c2a0-d694-11ec-9aab-3f3b95fb7b18', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('f8f32660-20b8-11ee-8622-37df65c2b093', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('f9dbed40-236e-11f0-bb68-a1d2c971872e', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('fc2bc190-f5d4-11eb-8ccc-17901c63413d', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('faac3510-8f66-11ee-89c1-731f17c336c3', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('fd416aa0-d384-11ed-b4ea-03c09a21f282', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('fc2f93f0-6428-11ee-8a36-29bc4666a7c6', 0, 'manuel');
INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES ('fcf1fa20-d1c2-11ec-88bd-5b29d81a78b4', 0, 'manuel');

COMMIT;