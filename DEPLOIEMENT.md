# 🚀 Guide déploiement — Bar Cité Gondwana sur Netlify + Supabase

## Ce que tu as dans ce dossier

| Fichier | Rôle |
|---|---|
| `index.html` | L'app convertie (MySQL → Supabase) |
| `netlify.toml` | Config Netlify (headers sécurité, redirections) |
| `supabase_setup.sql` | Script SQL à exécuter une seule fois |
| `DEPLOIEMENT.md` | Ce guide |

---

## ÉTAPE 1 — Créer les tables Supabase

1. Va sur **https://supabase.com/dashboard/project/zqgrxzmomcukfvpqeyfc**
2. Clique sur **SQL Editor** dans le menu gauche
3. Clique **New Query**
4. Ouvre `supabase_setup.sql`, copie tout le contenu, colle-le dans l'éditeur
5. Clique **▶ Run**
6. Tu dois voir : `Success. No rows returned`

---

## ÉTAPE 2 — Déployer sur Netlify (Drag & Drop)

1. Va sur **https://app.netlify.com**
2. Connecte-toi à ton compte
3. Dans le dashboard, cherche la zone **"Drag and drop your site folder here"**
   (ou clique **Add new site → Deploy manually**)
4. **Glisse le dossier `gondwana-netlify` entier** dans cette zone
5. Netlify déploie en 10-30 secondes
6. Tu obtiens une URL du type : `https://xxxxxxxx.netlify.app`

---

## ÉTAPE 3 — Personnaliser l'URL (optionnel)

1. Dans ton site Netlify → **Site configuration → General**
2. **Change site name** → tape par exemple `citegondwana`
3. Ton URL devient : `https://citegondwana.netlify.app`

---

## ÉTAPE 4 — Premier accès

Ouvre ton URL Netlify dans le navigateur.

**Identifiants par défaut :**
| Champ | Valeur |
|---|---|
| Rôle | 🛡️ Gérant |
| Utilisateur | `gerant` |
| Mot de passe | `admin123` |

⚠️ **L'app te demandera immédiatement de changer le mot de passe** — c'est normal.

---

## Connexion Supabase configurée

- **URL** : `https://zqgrxzmomcukfvpqeyfc.supabase.co`
- **Clé** : anon/public (intégrée dans index.html)
- **Tables** : 15 tables créées automatiquement

---

## En cas de problème

**L'app affiche "🔴 Erreur Supabase"**
→ Vérifie que le script SQL a bien été exécuté (Étape 1)
→ Vérifie que les policies RLS ont été créées

**Les tables n'apparaissent pas dans Supabase**
→ Va dans **Table Editor** pour vérifier
→ Réexécute le script SQL si besoin

**Erreur CORS**
→ Supabase autorise toutes les origines par défaut — pas de config CORS nécessaire
