
from sqlalchemy.orm import Session
from app.models.model import MedicalRecord


def create_medical_record(
    db: Session,
    user_id: int,
    title: str,
    description: str,
    record_date,
    doctor_name: str
):
    record = MedicalRecord(
        user_id=user_id,
        title=title,
        description=description,
        record_date=record_date,
        doctor_name=doctor_name
    )

    db.add(record)
    db.commit()
    db.refresh(record)

    return record


def get_user_medical_records(db: Session, user_id: int):
    return (
        db.query(MedicalRecord)
        .filter(MedicalRecord.user_id == user_id)
        .order_by(MedicalRecord.record_date.desc())
        .all()
    )
