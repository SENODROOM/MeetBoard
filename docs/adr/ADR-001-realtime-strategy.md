# ADR-001 — Realtime Signaling Strategy

- **Status:** Accepted (program baseline)  
- **Date:** 2026-08-07  
- **Squad:** Realtime & Media (Accountable); Platform (Consulted)  
- **Related:** Standing reliability (E-903); Y2 edge decision if multi-region poll SLO fails  

---

## Context

QuantumMeet must run on **Vercel serverless** for the HTTP API. Persistent Socket.io (or similar long-lived Node WebSocket servers) on Vercel is not a viable primary architecture. Media is **WebRTC P2P (mesh)** for small rooms; signaling and app events still need an out-of-band bus before data channels exist.

Early product iterations used managed pub/sub (Ably), then a **Mongo-backed event bus + short-poll / long-poll** (`RoomEvent`, presence, SecretMeet inbox) via Express REST. That pattern keeps the API serverless-compatible but has latency and load tradeoffs.

## Decision

1. **Primary app API** remains dual Vercel projects: `client/` SPA + `server/` Express.  
2. **Primary signaling / fan-out** remains **Mongo event bus + HTTP poll/long-poll** (`GET/POST /api/rooms/:roomId/events`, presence heartbeats). No Socket.io server on Vercel.  
3. **Do not** reintroduce a third-party pub/sub as the *required* production bus unless ADR-001 is amended with cost/SLO justification.  
4. **Bus exit criteria:** published SLOs (p95 delivery), indexes, backpressure, load tests (see `docs/slo/signaling.md`).  
5. **Later:** If SLOs cannot be met with poll/long-poll under multi-region load, evaluate a **dedicated realtime edge** (e.g. Cloudflare Durable Objects, PartyKit-class, or regional Node fleet) — still **not** “Socket.io bolted onto Vercel Hobby/Pro as the only listener.” Record the choice as an **addendum** to this ADR.  
6. **Media** stays **WebRTC mesh** on this deploy ([ADR-002](./ADR-002-sfu-evaluation.md)); mesh does not replace app-level chat/host event persistence.

## Consequences

### Positive

- Fits serverless deploy and ops model already chosen.  
- Durable events and presence survive multi-instance deploys.  
- Clear ownership for Realtime squad without rewriting the Room socket-shaped client adapter overnight.

### Negative / risks

- Polling adds latency (~hundreds of ms) and Mongo QPS cost at scale.  
- Whiteboard and ICE bursts need coalescing and budgets (helpers already in client; measure under load).  
- Long-poll holds serverless execution time — must respect platform limits (cap wait ≤ ~25s).

### Compliance

- Event TTLs and retention must align with privacy / retention OKRs.  
- Host actions remain authorized via room tokens, not client-trusted IDs alone.  

## Alternatives considered

| Alternative | Why not (for now) |
|-------------|-------------------|
| Socket.io on long-lived Node (Railway/Render) | Splits ops model; prior goal was Vercel serverless API |
| Ably / Pusher as required bus | Cost + vendor lock; removed by product direction |
| WebRTC data channels only | Cannot bootstrap mesh (chicken-and-egg) |

## Validation

- Load tests and SLO checks (`docs/slo/signaling.md`, `/api/health` metrics).  
- Long-poll go/no-go harness (`docs/slo/long-poll-gonogo.md`).  
- Amend this ADR if a dedicated edge is selected (Y2Q2 OKR).

## Y2 edge addendum

**Status:** Accepted as contingency — **not required** while single-region poll/long-poll meets SLO.

Trigger when dual-region poll RTT breaks signaling SLO. Options: edge workers for long-poll wake, or managed realtime edge. Keep media on WebRTC mesh (ADR-002) — no hosted SFU.

Until triggered, remain on Mongo HTTP bus ([dual-region-signaling.md](../slo/dual-region-signaling.md)).


## References

- `server/lib/events.js`, `client/src/lib/realtimeClient.js`  
- [EPICS_BACKLOG.md](../program/EPICS_BACKLOG.md)  
- [OKRS_Y1.md](../program/OKRS_Y1.md)  
