from pydantic import BaseModel


class QandA(BaseModel):
    question_id: int
    first_name: str | None
    last_name: str | None
    question: str
    answer: str | None

    class Config:
        orm_mode = True

class AskQ(BaseModel):
    listing_id: int
    question: str

class AnswerQ(BaseModel):
    question_id: int
    answer: str