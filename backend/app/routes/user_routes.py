
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.schemas.user_schema import UserRegister
from app.services.user_service import register_user
from app.schemas.user_schema import UserRegister, UserLogin
from app.services.user_service import register_user, login_user
from app.core.security import get_current_user
from app.models.model import User

from app.schemas.user_schema import UserUpdate

router = APIRouter(prefix="/auth", tags=["Authentication"])


@router.post("/register", status_code=status.HTTP_201_CREATED)
def register(payload: UserRegister, db: Session = Depends(get_db)):
    user = register_user(
        db=db,
        full_name=payload.full_name,
        email=payload.email,
        password=payload.password,
    )

    if user is None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Email already registered",
        )

    return {
        "message": "Registration successful",
        "user": {
            "id": user.id,
            "full_name": user.full_name,
            "email": user.email,
        },
    }



@router.post("/login")
def login(payload: UserLogin, db: Session = Depends(get_db)):
    result = login_user(
        db=db,
        email=payload.email,
        password=payload.password,
    )

    if result is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password",
        )

    return result



@router.get("/me")
def get_my_profile(
    current_user: User = Depends(get_current_user)
):
    return {
        "id": current_user.id,
        "full_name": current_user.full_name,
        "email": current_user.email
    }


@router.put("/me")
def update_my_profile(
    user_data: UserUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    current_user.full_name = user_data.full_name

    db.commit()
    db.refresh(current_user)

    return {
        "message": "Profile updated successfully",
        "id": current_user.id,
        "full_name": current_user.full_name,
        "email": current_user.email
    }



@router.delete("/me")
def delete_my_account(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    db.delete(current_user)
    db.commit()

    return {"message": "Account deleted successfully"}