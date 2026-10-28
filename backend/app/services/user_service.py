
from sqlalchemy.orm import Session
from pwdlib import PasswordHash
from app.models.model import User
from app.core.security import verify_password, create_access_token


password_hash = PasswordHash.recommended()


def register_user(db: Session, full_name: str, email: str, password: str):
    existing_user = db.query(User).filter(User.email == email).first()

    if existing_user:
        return None

    hashed_password = password_hash.hash(password)

    new_user = User(
        full_name=full_name,
        email=email,
        hashed_password=hashed_password,
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return new_user


def login_user(db: Session, email: str, password: str):
    user = db.query(User).filter(User.email == email).first()

    if not user or not verify_password(password, user.hashed_password):
        return None

    access_token = create_access_token(user.id)

    return {
        "access_token": access_token,
        "token_type": "bearer",
    }
