
from sqlalchemy.orm import Session
from app.models.model import Appointment


def create_appointment(
    db: Session,
    user_id: int,
    doctor_name: str,
    appointment_date,
    appointment_time: str,
    reason: str,
):
    appointment = Appointment(
        user_id=user_id,
        doctor_name=doctor_name,
        appointment_date=appointment_date,
        appointment_time=appointment_time,
        reason=reason,
    )

    db.add(appointment)
    db.commit()
    db.refresh(appointment)

    return appointment


def get_user_appointments(db: Session, user_id: int):
    return (
        db.query(Appointment)
        .filter(Appointment.user_id == user_id)
        .order_by(Appointment.appointment_date.desc())
        .all()
    )



def cancel_appointment(db: Session, user_id: int, appointment_id: int):
    appointment = (
        db.query(Appointment)
        .filter(
            Appointment.id == appointment_id,
            Appointment.user_id == user_id,
        )
        .first()
    )

    if appointment is None:
        return None

    db.delete(appointment)
    db.commit()

    return appointment
