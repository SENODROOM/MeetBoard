# Signaling SLO (lightweight)

**Targets (staging/prod to validate):**

| Metric | Target | How to check |
|--------|--------|--------------|
| Event publish success | ≥ 99% | Vercel logs / `eventsRejected` vs `eventsPublished` on `/api/health` |
| Poll list p95 (no wait) | &lt; 300ms | `npm run load:events` |
| Offer→answer perceived | &lt; 2s typical | Manual 2-browser test |
| Long-poll hold | ≤ 15–20s | Client `wait` query |

**Load controls already in code:**

- List limit 100 events/poll  
- Payload cap ~120KB  
- ICE + cursor + whiteboard stroke coalescing on client  
- Slower poll when tab hidden; presence heartbeat skipped when hidden  
- Longer idle poll interval + 15s heartbeat / 45s presence stale  

**Dashboards:** use `/api/health` metrics + Vercel/Atlas consoles; optional Grafana later under E-903.
