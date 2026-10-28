
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.schemas.medical_record_schema import MedicalRecordCreate
from app.services.medical_record_service import create_medical_record, get_user_medical_records
from app.routes.user_routes import get_current_user

router = APIRouter(prefix="/medical-records", tags=["Medical Records"])


@router.post("/")
def add_medical_record(
    record_data: MedicalRecordCreate,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    return create_medical_record(
        db=db,
        user_id=current_user.id,
        title=record_data.title,
        description=record_data.description,
        record_date=record_data.record_date,
        doctor_name=record_data.doctor_name
    )


@router.get("/")
def list_medical_records(
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    return get_user_medical_records(db, current_user.id)
