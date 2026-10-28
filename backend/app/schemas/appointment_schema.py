
from datetime import date
from pydantic import BaseModel, Field


class AppointmentCreate(BaseModel):
    doctor_name: str = Field(min_length=2, max_length=100)
    appointment_date: date
    appointment_time: str
    reason: str = Field(min_length=2, max_length=255)
