
from datetime import date
from pydantic import BaseModel, Field


class MedicalRecordCreate(BaseModel):
    title: str = Field(min_length=2, max_length=100)
    description: str = Field(min_length=2, max_length=255)
    record_date: date
    doctor_name: str = Field(min_length=2, max_length=100)
