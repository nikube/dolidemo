# DoliDemo

Instance de démonstration **Dolibarr 23.0.3** prête à déployer (Docker Compose),
avec données de démo réalistes (PME fictive) et DMM (DoliModuleManager) pré-installé.

- Image de base : [`ghcr.io/nikube/dolibarr-demo:23.0.3`](https://github.com/nikube/dolibarr-demo-image)
- Données : générées au 1er démarrage par `install/generate-demo.php` (lock dans le volume `documents`)
- Modules custom : volume `custom`, DMM activé automatiquement (`DOLI_ACTIVATE_MODULES`)
- Cron : sidecar curl qui appelle `cron_run_jobs_by_url.php` chaque minute
- Mails : capturés par Mailpit (aucun envoi réel)

## Lancer en local

```bash
docker compose up -d --build
# http://localhost:8090  — admin / admin  (la démo met ~1-2 min à se générer, voir les logs)
docker compose logs -f dolibarr
```

## Déployer sur Coolify

1. Nouvelle ressource → **Docker Compose** → source GitHub App → ce repo, branche `main`.
2. Coolify génère `SERVICE_PASSWORD_*` et `SERVICE_FQDN_DOLIBARR` ; le login/mot de passe admin sont
   `SERVICE_USER_DOLIBARR` / `SERVICE_PASSWORD_DOLIBARR` (générés, modifiables dans les variables d'environnement).
3. Attribuer le domaine au service `dolibarr` (port 80). Mailpit : exposer le port 8025 sur un
   sous-domaine si on veut consulter les mails de la démo.
4. Deploy. Chaque push sur `main` redéploie.

## Réinitialiser la démo

Supprimer les volumes (`docker compose down -v` en local, ou les volumes de la ressource
dans Coolify) puis redéployer : base vierge + régénération de la démo.
Pour ne régénérer que les données sur une base existante : supprimer
`documents/install.demo-realistic.done` **et** vider la base.

## Mettre à jour

- Dolibarr : `ARG DOLIBARR_VERSION` dans le `Dockerfile` (le tag doit exister sur
  `ghcr.io/nikube/dolibarr-demo`).
- DMM : `ARG DMM_VERSION` (release `nikube/DMM`).
