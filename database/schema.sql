-- ตารางเก็บพจนานุกรมหลัก
CREATE TABLE Dictionary (
    id INTEGER PRIMARY KEY,
    word_en TEXT NOT NULL,
    word_th TEXT NOT NULL,
    phonetic TEXT,
    example_sentence TEXT,
    category TEXT -- เช่น medical, engineering, general
);

-- ตารางเก็บความคืบหน้าผู้ใช้ (Save Point)
CREATE TABLE UserProgress (
    user_id INTEGER PRIMARY KEY,
    last_word_id INTEGER,
    learning_streak INTEGER,
    difficult_words TEXT -- เก็บ ID คำที่ผู้ใช้ทำผิดบ่อยเป็น JSON
);

-- ตารางสิทธิ์การใช้งานภาษา (Pay-per-Upgrade)
CREATE TABLE Subscriptions (
    language_code VARCHAR(5) PRIMARY KEY, -- เช่น 'JP', 'KR'
    is_unlocked BOOLEAN DEFAULT FALSE,
    purchase_date DATETIME
);
