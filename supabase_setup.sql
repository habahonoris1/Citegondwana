-- ═══════════════════════════════════════════════════════════════════
-- BAR CITÉ GONDWANA — Script SQL Supabase
-- À exécuter dans : Supabase Dashboard → SQL Editor → New Query
-- Projet : citegondwana (zqgrxzmomcukfvpqeyfc)
-- ═══════════════════════════════════════════════════════════════════

-- ── 1. UTILISATEURS ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS gw_users (
  id            BIGINT PRIMARY KEY,
  username      TEXT NOT NULL UNIQUE,
  pass          TEXT,
  hash_pass     TEXT,
  role          TEXT NOT NULL DEFAULT 'serveur',
  name          TEXT,
  must_change_pass BOOLEAN DEFAULT false
);

-- ── 2. PRODUITS ──────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS gw_products (
  id    BIGINT PRIMARY KEY,
  name  TEXT NOT NULL,
  cat   TEXT,
  price NUMERIC(12,2) DEFAULT 0,
  cost  NUMERIC(12,2) DEFAULT 0,
  stock INTEGER DEFAULT 0,
  min   INTEGER DEFAULT 0
);

-- ── 3. VENTES ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS gw_sales (
  id         BIGINT PRIMARY KEY,
  date       TEXT,
  time       TEXT,
  sale_table TEXT,
  items      JSONB,
  total      NUMERIC(12,2) DEFAULT 0,
  method     TEXT,
  server     TEXT,
  client     TEXT
);

-- ── 4. FOURNISSEURS ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS gw_suppliers (
  id       BIGINT PRIMARY KEY,
  name     TEXT NOT NULL,
  contact  TEXT,
  phone    TEXT,
  products TEXT
);

-- ── 5. CLIENTS ───────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS gw_clients (
  id           BIGINT PRIMARY KEY,
  name         TEXT NOT NULL,
  phone        TEXT,
  balance      NUMERIC(12,2) DEFAULT 0,
  credit_limit NUMERIC(12,2) DEFAULT 0
);

-- ── 6. FACTURES ──────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS gw_invoices (
  id      BIGINT PRIMARY KEY,
  number  TEXT,
  date    TEXT,
  time    TEXT,
  sale    JSONB,
  total   NUMERIC(12,2) DEFAULT 0,
  tva     NUMERIC(12,2) DEFAULT 0,
  ttc     NUMERIC(12,2) DEFAULT 0
);

-- ── 7. PARAMÈTRES ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS gw_settings (
  id              BIGINT PRIMARY KEY DEFAULT 1,
  name            TEXT,
  addr            TEXT,
  phone           TEXT,
  tva             NUMERIC(5,2) DEFAULT 0,
  currency        TEXT DEFAULT 'GNF',
  invoice_counter INTEGER DEFAULT 1,
  categories      JSONB,
  logo_type       TEXT DEFAULT 'emoji',
  logo_emoji      TEXT DEFAULT '🍸',
  logo_image      TEXT,
  logo_bg         TEXT DEFAULT '#C9A84C'
);

-- ── 8. ACHATS / APPROVISIONNEMENTS ───────────────────────────────
CREATE TABLE IF NOT EXISTS gw_purchases (
  id        BIGINT PRIMARY KEY,
  date      TEXT,
  date_raw  TEXT,
  ref       TEXT,
  supplier  TEXT,
  items     JSONB,
  total     NUMERIC(12,2) DEFAULT 0,
  pay_src   TEXT,
  by_user   TEXT
);

-- ── 9. MOUVEMENTS CAISSE ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS gw_caisse (
  id         BIGINT PRIMARY KEY,
  date       TEXT,
  time       TEXT,
  date_raw   TEXT,
  type       TEXT,
  categorie  TEXT,
  libelle    TEXT,
  montant    NUMERIC(12,2) DEFAULT 0,
  auto       BOOLEAN DEFAULT false,
  user_name  TEXT,
  ref        TEXT
);

-- ── 10. MOUVEMENTS BANQUE ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS gw_banque (
  id         BIGINT PRIMARY KEY,
  date       TEXT,
  time       TEXT,
  date_raw   TEXT,
  type       TEXT,
  categorie  TEXT,
  libelle    TEXT,
  montant    NUMERIC(12,2) DEFAULT 0,
  auto       BOOLEAN DEFAULT false,
  user_name  TEXT,
  ref        TEXT
);

-- ── 11. MÉTA (soldes initiaux) ───────────────────────────────────
CREATE TABLE IF NOT EXISTS gw_meta (
  id           BIGINT PRIMARY KEY DEFAULT 1,
  caisse_init  NUMERIC(12,2) DEFAULT 0,
  banque_init  NUMERIC(12,2) DEFAULT 0
);

-- ── 12. TABLES DU BAR ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS gw_tables (
  id       BIGINT PRIMARY KEY,
  name     TEXT NOT NULL,
  occupied BOOLEAN DEFAULT false
);

-- ── 13. RÔLES (méta) ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS gw_role_meta (
  role_key TEXT PRIMARY KEY,
  label    TEXT,
  icon     TEXT,
  color    TEXT
);

-- ── 14. PERMISSIONS PAR RÔLE ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS gw_role_perms (
  role_key TEXT PRIMARY KEY,
  modules  JSONB
);

-- ── 15. RÔLES PERSONNALISÉS ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS gw_custom_roles (
  role_key TEXT PRIMARY KEY,
  label    TEXT,
  icon     TEXT,
  color    TEXT
);

-- ═══════════════════════════════════════════════════════════════════
-- ROW LEVEL SECURITY — autoriser la clé anon à tout faire
-- (L'app gère elle-même l'auth par username/password)
-- ═══════════════════════════════════════════════════════════════════

ALTER TABLE gw_users        ENABLE ROW LEVEL SECURITY;
ALTER TABLE gw_products     ENABLE ROW LEVEL SECURITY;
ALTER TABLE gw_sales        ENABLE ROW LEVEL SECURITY;
ALTER TABLE gw_suppliers    ENABLE ROW LEVEL SECURITY;
ALTER TABLE gw_clients      ENABLE ROW LEVEL SECURITY;
ALTER TABLE gw_invoices     ENABLE ROW LEVEL SECURITY;
ALTER TABLE gw_settings     ENABLE ROW LEVEL SECURITY;
ALTER TABLE gw_purchases    ENABLE ROW LEVEL SECURITY;
ALTER TABLE gw_caisse       ENABLE ROW LEVEL SECURITY;
ALTER TABLE gw_banque       ENABLE ROW LEVEL SECURITY;
ALTER TABLE gw_meta         ENABLE ROW LEVEL SECURITY;
ALTER TABLE gw_tables       ENABLE ROW LEVEL SECURITY;
ALTER TABLE gw_role_meta    ENABLE ROW LEVEL SECURITY;
ALTER TABLE gw_role_perms   ENABLE ROW LEVEL SECURITY;
ALTER TABLE gw_custom_roles ENABLE ROW LEVEL SECURITY;

-- Policies : accès complet via clé anon (l'app gère l'auth)
DO $$
DECLARE
  t TEXT;
  tables TEXT[] := ARRAY[
    'gw_users','gw_products','gw_sales','gw_suppliers','gw_clients',
    'gw_invoices','gw_settings','gw_purchases','gw_caisse','gw_banque',
    'gw_meta','gw_tables','gw_role_meta','gw_role_perms','gw_custom_roles'
  ];
BEGIN
  FOREACH t IN ARRAY tables LOOP
    EXECUTE format('
      CREATE POLICY "anon_all_%s" ON %I
      FOR ALL TO anon USING (true) WITH CHECK (true);
    ', t, t);
  END LOOP;
END $$;

-- ═══════════════════════════════════════════════════════════════════
-- DONNÉES INITIALES (optionnel — l'app crée le gérant au 1er boot)
-- ═══════════════════════════════════════════════════════════════════

INSERT INTO gw_settings (id, name, currency, tva, logo_emoji)
VALUES (1, 'Bar Cité Gondwana', 'GNF', 0, '🍸')
ON CONFLICT (id) DO NOTHING;

INSERT INTO gw_meta (id, caisse_init, banque_init)
VALUES (1, 0, 0)
ON CONFLICT (id) DO NOTHING;

-- ═══════════════════════════════════════════════════════════════════
-- TERMINÉ ✅
-- ═══════════════════════════════════════════════════════════════════
