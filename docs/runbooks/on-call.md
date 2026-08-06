# P0 on-call rotation

## Roster (fill names)

| Week starting | Primary | Secondary | Notes |
|---------------|---------|-----------|-------|
| _TBD_ | Platform | Realtime | Rotate weekly |

## Paging

1. Alert source: Vercel / Atlas / synthetic health fail (`npm run synthetic:health`).  
2. Page primary via team channel + phone tree.  
3. Follow [incident-p0.md](./incident-p0.md).  

## Coverage rules

- Primary acknowledges within **15 minutes** for P0.  
- Secondary covers if primary is OOO.  
- Hand-off every Monday with open incidents listed.

Staff this table for production paging.
