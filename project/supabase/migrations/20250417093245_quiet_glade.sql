/*
  # Learning Platform Schema

  1. New Tables
    - users (extends Supabase auth.users)
      - role (enum: student, instructor, admin)
      - full_name (text)
      - avatar_url (text)
    
    - courses
      - id (uuid, primary key)
      - title (text)
      - description (text)
      - instructor_id (uuid, references users)
      - created_at (timestamp)
      - updated_at (timestamp)
    
    - modules
      - id (uuid, primary key)
      - course_id (uuid, references courses)
      - title (text)
      - order_index (integer)
      - created_at (timestamp)
    
    - lessons
      - id (uuid, primary key)
      - module_id (uuid, references modules)
      - title (text)
      - content (text)
      - order_index (integer)
      - created_at (timestamp)
    
    - quizzes
      - id (uuid, primary key)
      - lesson_id (uuid, references lessons)
      - title (text)
      - created_at (timestamp)
    
    - quiz_questions
      - id (uuid, primary key)
      - quiz_id (uuid, references quizzes)
      - question (text)
      - options (jsonb)
      - correct_answer (text)
      - order_index (integer)
    
    - student_progress
      - id (uuid, primary key)
      - user_id (uuid, references users)
      - lesson_id (uuid, references lessons)
      - completed_at (timestamp)
      - quiz_score (integer)
    
    - chat_messages
      - id (uuid, primary key)
      - sender_id (uuid, references users)
      - receiver_id (uuid, references users)
      - message (text)
      - created_at (timestamp)
    
    - notifications
      - id (uuid, primary key)
      - user_id (uuid, references users)
      - title (text)
      - content (text)
      - read (boolean)
      - created_at (timestamp)

  2. Security
    - Enable RLS on all tables
    - Add appropriate policies for each role
*/

-- Create custom types
CREATE TYPE user_role AS ENUM ('student', 'instructor', 'admin');

-- Create users table extension
CREATE TABLE users (
  id uuid REFERENCES auth.users NOT NULL PRIMARY KEY,
  role user_role NOT NULL DEFAULT 'student',
  full_name text,
  avatar_url text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create courses table
CREATE TABLE courses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text,
  instructor_id uuid REFERENCES users NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create modules table
CREATE TABLE modules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id uuid REFERENCES courses ON DELETE CASCADE NOT NULL,
  title text NOT NULL,
  order_index integer NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Create lessons table
CREATE TABLE lessons (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  module_id uuid REFERENCES modules ON DELETE CASCADE NOT NULL,
  title text NOT NULL,
  content text,
  order_index integer NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Create quizzes table
CREATE TABLE quizzes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id uuid REFERENCES lessons ON DELETE CASCADE NOT NULL,
  title text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Create quiz questions table
CREATE TABLE quiz_questions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  quiz_id uuid REFERENCES quizzes ON DELETE CASCADE NOT NULL,
  question text NOT NULL,
  options jsonb NOT NULL,
  correct_answer text NOT NULL,
  order_index integer NOT NULL
);

-- Create student progress table
CREATE TABLE student_progress (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users NOT NULL,
  lesson_id uuid REFERENCES lessons NOT NULL,
  completed_at timestamptz DEFAULT now(),
  quiz_score integer
);

-- Create chat messages table
CREATE TABLE chat_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  sender_id uuid REFERENCES users NOT NULL,
  receiver_id uuid REFERENCES users NOT NULL,
  message text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Create notifications table
CREATE TABLE notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users NOT NULL,
  title text NOT NULL,
  content text NOT NULL,
  read boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE modules ENABLE ROW LEVEL SECURITY;
ALTER TABLE lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE quizzes ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Create policies
-- Users policies
CREATE POLICY "Users can read their own data" ON users
  FOR SELECT TO authenticated
  USING (auth.uid() = id);

-- Courses policies
CREATE POLICY "Anyone can view courses" ON courses
  FOR SELECT TO authenticated
  USING (true);

CREATE POLICY "Instructors can create courses" ON courses
  FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid()
      AND users.role = 'instructor'
    )
  );

-- Modules policies
CREATE POLICY "Anyone can view modules" ON modules
  FOR SELECT TO authenticated
  USING (true);

-- Lessons policies
CREATE POLICY "Anyone can view lessons" ON lessons
  FOR SELECT TO authenticated
  USING (true);

-- Student progress policies
CREATE POLICY "Students can view and update their own progress" ON student_progress
  FOR ALL TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- Chat messages policies
CREATE POLICY "Users can view their own messages" ON chat_messages
  FOR SELECT TO authenticated
  USING (sender_id = auth.uid() OR receiver_id = auth.uid());

CREATE POLICY "Users can send messages" ON chat_messages
  FOR INSERT TO authenticated
  WITH CHECK (sender_id = auth.uid());

-- Notifications policies
CREATE POLICY "Users can view their own notifications" ON notifications
  FOR SELECT TO authenticated
  USING (user_id = auth.uid());