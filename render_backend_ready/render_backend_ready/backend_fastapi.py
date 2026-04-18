from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Dict, List, Optional
from datetime import datetime, timedelta

app = FastAPI(title="Family Auto Share Backend")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

share_links: Dict[str, dict] = {}
sessions: Dict[str, dict] = {}
updates: Dict[str, List[dict]] = {}

class StartSession(BaseModel):
    token: str
    participant_name: str
    expires_minutes: int = 500
    battery: Optional[int] = None

class LocationUpdate(BaseModel):
    token: str
    latitude: float
    longitude: float
    accuracy: Optional[float] = None
    battery: Optional[int] = None
    timestamp: str

@app.get("/")
def root():
    return {"ok": True, "service": "family-auto-share-backend"}

@app.post("/api/session/start")
def start_session(body: StartSession):
    share_links.setdefault(body.token, {"label": body.participant_name, "accepted": False})
    share_links[body.token]["accepted"] = True
    share_links[body.token]["last_seen"] = datetime.utcnow().isoformat()
    sessions[body.token] = {
        "participant_name": body.participant_name,
        "created_at": datetime.utcnow().isoformat(),
        "expires_at": (datetime.utcnow() + timedelta(minutes=body.expires_minutes)).isoformat(),
        "battery": body.battery,
        "active": True,
    }
    updates.setdefault(body.token, [])
    return {"ok": True, "token": body.token}

@app.post("/api/location/update")
def location_update(body: LocationUpdate):
    if body.token not in sessions:
        raise HTTPException(status_code=404, detail="Session not found")
    payload = body.model_dump()
    updates.setdefault(body.token, []).append(payload)
    share_links.setdefault(body.token, {})
    share_links[body.token]["last_seen"] = datetime.utcnow().isoformat()
    share_links[body.token]["label"] = sessions[body.token]["participant_name"]
    return {"ok": True, "count": len(updates[body.token])}

@app.get("/api/dashboard/active")
def active_sessions():
    latest = {k: v[-1] if v else None for k, v in updates.items()}
    return {
        "sessions": sessions,
        "links": share_links,
        "latest": latest,
    }

@app.get("/api/history/{token}")
def get_history(token: str):
    return {"ok": True, "token": token, "history": updates.get(token, [])}
