
from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from fastapi import APIRouter, Depends, status, HTTPException
from app.core.database import get_db
from app.core.security import get_current_user
from app.models.model import User
from app.schemas.appointment_schema import AppointmentCreate
from app.services.appointment_service import (
    create_appointment,
    get_user_appointments,
)
from app.services.appointment_service import (
    create_appointment,
    get_user_appointments,
    cancel_appointment,
)

router = APIRouter(prefix="/appointments", tags=["Appointments"])


@router.post("/", status_code=status.HTTP_201_CREATED)
def book_appointment(
    payload: AppointmentCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    appointment = create_appointment(
        db=db,
        user_id=current_user.id,
        doctor_name=payload.doctor_name,
        appointment_date=payload.appointment_date,
        appointment_time=payload.appointment_time,
        reason=payload.reason,
    )

    return {
        "message": "Appointment booked successfully",
        "appointment": {
            "id": appointment.id,
            "user_id": appointment.user_id,
            "doctor_name": appointment.doctor_name,
            "appointment_date": appointment.appointment_date,
            "appointment_time": appointment.appointment_time,
            "reason": appointment.reason,
        },
    }


@router.get("/")
def list_appointments(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    appointments = get_user_appointments(
        db=db,
        user_id=current_user.id,
    )

    return {
        "appointments": [
            {
                "id": appointment.id,
                "doctor_name": appointment.doctor_name,
                "appointment_date": appointment.appointment_date,
                "appointment_time": appointment.appointment_time,
                "reason": appointment.reason,
            }
            for appointment in appointments
        ]
    }

@router.delete("/{appointment_id}")
def delete_appointment(
    appointment_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    appointment = cancel_appointment(
        db=db,
        user_id=current_user.id,
        appointment_id=appointment_id,
    )

    if appointment is None:
        raise HTTPException(
            status_code=404,
            detail="Appointment not found",
        )

    return {"message": "Appointment cancelled successfully"}