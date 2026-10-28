
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.database import Base, engine
from app.models import model
from app.routes.user_routes import router as user_router
from app.routes.appointment_routes import router as appointment_router
from app.routes.medical_record_routes import router as medical_record_router
Base.metadata.create_all(bind=engine)

app = FastAPI(title="MediCare API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(user_router)
app.include_router(appointment_router)
app.include_router(medical_record_router)


@app.get("/")
def home():
    return {"message": "Welcome to MediCare API"}


@app.get("/health")
def health_check():
    return {"status": "healthy"}
