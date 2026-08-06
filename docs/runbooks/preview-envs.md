# Preview environments per PR

## Target

Every PR gets disposable **API** + **client** preview URLs (Vercel).

## Checklist

1. Vercel project(s) have Preview Deployments enabled for both `client` and `server` roots.
2. Preview env vars: `MONGO_URI` → **staging** Atlas (never prod), `JWT_SECRET`, `ROOM_TOKEN_SECRET`, `ICE_SERVERS` (shared TURN OK), `CRON_SECRET`.
3. Client preview: `REACT_APP_SERVER_URL` = that PR’s API preview URL (set via Vercel env or build hook).
4. CORS: `EXTRA_ALLOWED_ORIGINS` or existing `quantum-meet-frontend-*.vercel.app` pattern.
5. Smoke: open client preview → home loads; `GET {api}/api/health` → `ok`.

## Notes

- Prefer wiring `REACT_APP_SERVER_URL` to the matching API preview per PR.  
- Seed staging data when running classroom E2E against previews.  
