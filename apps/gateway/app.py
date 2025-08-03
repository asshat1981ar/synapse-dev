from fastapi import FastAPI

app = FastAPI(title="Synapse Gateway")

@app.get("/healthz")
def health():
    return {"ok": True, "service": "gateway"}

# Day 4: /api/v1/init, auth, Neon calls
