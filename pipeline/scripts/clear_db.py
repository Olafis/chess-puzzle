"""
DB 전체 초기화 스크립트.

계정, 퍼즐, 경기 등 모든 데이터를 삭제합니다.

실행: cd pipeline && python scripts/clear_db.py
"""
import os
import sys

_PIPELINE_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, _PIPELINE_ROOT)

from db import get_connection

TABLES = [
    "PuzzleCategoryVote",
    "PuzzleFeedback",
    "PuzzleAttempt",
    "UserCategoryRating",
    "Account",
    "Session",
    "Puzzle",
    "Game",
    "User",
    "VerificationToken",
]


def main():
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            tables_sql = ", ".join(f'"{t}"' for t in TABLES)
            cur.execute(f"TRUNCATE {tables_sql} CASCADE;")
        conn.commit()
        print("DB 전체 초기화 완료 (계정, 퍼즐, 경기 등 모든 데이터 삭제됨)")
    except Exception as e:
        conn.rollback()
        print(f"오류: {e}", file=sys.stderr)
        sys.exit(1)
    finally:
        conn.close()


if __name__ == "__main__":
    main()
