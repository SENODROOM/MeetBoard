# Atlas backup / restore drill

## Cadence

Quarterly restore drill. Record date + owner in the table below.

| Date | Env | Owner | Result | Notes |
|------|-----|-------|--------|-------|
| 2026-08-07 | staging process | Platform | Process ready | Runbook + synthetic health; schedule live Atlas restore next game day |

## Backup

1. Atlas → Cluster → Backup → ensure continuous cloud backup **on**.
2. Confirm retention ≥ 7 days (prod target ≥ 30 if budget allows).
3. Snapshot policy matches RPO in `docs/program/OKRS_Y1.md`.

## Restore drill (staging)

1. Pick a point-in-time ≤ 24h ago.
2. Restore to a **new** cluster or temp DB name `quantummeet-restore-drill`.
3. Point staging `MONGO_URI` at restored DB (or local tunnel).
4. Run `npm run synthetic:health` + create room + classroom join.
5. Revert URI; delete restore cluster.

## Cost glance

- Atlas backup $/mo vs cluster tier — note in quarterly cost review.
- Vercel Blob storage for recordings — purged via `/api/cron/recordings-retention` (`RECORDING_RETENTION_DAYS`).
