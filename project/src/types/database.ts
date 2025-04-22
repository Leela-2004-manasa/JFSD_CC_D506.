import { Database } from '@supabase/supabase-js';

export type Tables = Database['public']['Tables'];
export type User = Tables['users']['Row'];
export type Course = Tables['courses']['Row'];
export type Module = Tables['modules']['Row'];
export type Lesson = Tables['lessons']['Row'];
export type Quiz = Tables['quizzes']['Row'];
export type QuizQuestion = Tables['quiz_questions']['Row'];
export type StudentProgress = Tables['student_progress']['Row'];
export type ChatMessage = Tables['chat_messages']['Row'];
export type Notification = Tables['notifications']['Row'];