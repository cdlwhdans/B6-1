# B6-1: 도서 대여 데이터베이스 실습

회원, 카테고리, 도서, 대여 기록을 관리하는 MySQL 기반 SQL 실습 과제

백엔드 프레임워크 없이 테이블 설계, 데이터 입력, 조회·조인·집계·수정·삭제 수행

## 실행 환경

- macOS / Docker(OrbStack 등) / Docker Compose
- MySQL 8.0 / MySQL CLI

## 제출 파일

| 파일 | 내용 |
| --- | --- |
| `compose.yaml` | MySQL 실행 환경 |
| `sql/01_schema.sql` | 데이터베이스 및 테이블 생성, PK·FK·제약조건 |
| `sql/02_data.sql` | 테이블별 샘플 데이터 10행 입력 |
| `sql/03_queries.sql` | 설명을 포함한 핵심 SQL 15개 |
| [`results/result.txt`](results/result.txt) | SQL 문장과 실행 결과 |

## 테이블 설계

| 테이블 | 역할 | 주요 컬럼 |
| --- | --- | --- |
| `member` | 회원 관리 | member_id(PK), name, email |
| `category` | 카테고리 관리 | category_id(PK), name |
| `book` | 도서 관리 | book_id(PK), title, category_id(FK) |
| `rental` | 대여 기록 관리 | rental_id(PK), member_id(FK), book_id(FK), rental_date, return_date |

### 관계 및 제약조건

- 카테고리 1 : 도서 N — `book.category_id` → `category.category_id`
- 회원 1 : 대여 기록 N — `rental.member_id` → `member.member_id`
- 도서 1 : 대여 기록 N — `rental.book_id` → `book.book_id`
- 모든 테이블에 PK, 필수 컬럼에 `NOT NULL` 적용
- 회원 이메일에 `UNIQUE` 적용
- FK로 존재하지 않는 회원·도서·카테고리 참조 방지
- `return_date`: 실제 반납일, `NULL`이면 미반납 상태

각 테이블에 샘플 데이터 10행 입력. FK 참조 관계에 따라 회원·카테고리 → 도서 → 대여 기록 순서로 입력

## 실행 방법

### 1. 저장소 준비

Docker 실행 환경을 켠 다음 맥 터미널에서 아래 명령 실행. 이미 클론한 경우 해당 프로젝트 폴더에서 진행

```bash
git clone https://github.com/cdlwhdans/B6-1.git
cd B6-1
mkdir -p results
docker compose up -d
```

### 2. MySQL 접속

MySQL 초기화 완료 후 접속

```bash
docker compose exec mysql mysql -u root -p --verbose
```

비밀번호: `1234`

접속 후 `mysql>`에서 아래 명령 입력



## 핵심 SQL 구성

| 번호 | 구분 | 내용 |
| --- | --- | --- |
| 01~04 | 기본 조회 | 전체 회원, 컴퓨터 도서, 미반납 기록, 최근 대여 3건 |
| 05~08 | 조인 | 도서와 카테고리, 대여와 회원, 미반납 도서와 회원, 모든 회원의 대여 기록 |
| 09~11 | 집계 | 회원별 대여 횟수, 카테고리별 도서 수, 회원별 평균 대여 일수 |
| 12 | 서브쿼리 | 대여 기록이 없는 회원 |
| 13 | UPDATE | 6번 대여 기록의 반납일 수정 |
| 14 | DELETE | 10번 대여 기록 삭제 |
| 15 | 인덱스 | 대여일 검색·정렬에 활용할 `idx_rental_date` 생성 및 확인 |

- 집계에 `COUNT`, `AVG`, `GROUP BY` 사용
- MySQL 관련 문법과 함수는 SQL 파일에 주석으로 표시

- 13·14번: 변경 후 조회 결과 확인, `ROLLBACK`으로 변경 취소 및 원본 데이터 유지
- 15번: 생성한 인덱스 유지. `03_queries.sql` 재실행 시 인덱스 이름 중복 오류 발생 가능

## 저장 위치

- `sql/`: 작성한 SQL 파일 저장, 컨테이너의 `/sql`로 접근
- `results/`: 실행 결과 텍스트 저장, 컨테이너의 `/results`로 접근
- `mysql_data` Docker 볼륨: 실제 MySQL 테이블과 데이터 저장

Git 제출 대상: SQL 파일과 실행 결과. Docker 볼륨의 실제 DB 데이터는 제출 대상에서 제외

