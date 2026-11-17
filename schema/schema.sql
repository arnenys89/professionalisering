PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  email TEXT NOT NULL UNIQUE,
  display_name TEXT NOT NULL,
  job_title TEXT,
  auth_provider TEXT,
  external_subject TEXT,
  active INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0,1)),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS user_roles (
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('administrator','directie','personeelslid','tac_ta','econoom','personeelsverantwoordelijke')),
  assigned_by TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, role)
);

CREATE TABLE IF NOT EXISTS school_years (
  id TEXT PRIMARY KEY,
  label TEXT NOT NULL UNIQUE,
  start_date TEXT NOT NULL,
  end_date TEXT NOT NULL,
  CHECK (start_date < end_date)
);

CREATE TABLE IF NOT EXISTS applications (
  id TEXT PRIMARY KEY,
  school_year_id TEXT NOT NULL REFERENCES school_years(id),
  applicant_user_id TEXT NOT NULL REFERENCES users(id),
  title TEXT NOT NULL,
  provider TEXT,
  category TEXT NOT NULL CHECK (category IN ('pedagogisch_didactisch','vakinhoudelijk')),
  timing TEXT NOT NULL CHECK (timing IN ('tijdens_lesuren','buiten_lesuren')),
  start_at TEXT NOT NULL,
  end_at TEXT NOT NULL,
  justification TEXT NOT NULL,
  travel_mode TEXT,
  ticket_required INTEGER NOT NULL DEFAULT 0 CHECK (ticket_required IN (0,1)),
  payment_required INTEGER NOT NULL DEFAULT 0 CHECK (payment_required IN (0,1)),
  payment_status TEXT NOT NULL DEFAULT 'not_required',
  approval_status TEXT NOT NULL DEFAULT 'submitted',
  pictO_status TEXT NOT NULL DEFAULT 'pending',
  general_notes TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS payment_details (
  application_id TEXT PRIMARY KEY REFERENCES applications(id) ON DELETE CASCADE,
  organization_name TEXT,
  iban TEXT,
  bic TEXT,
  enterprise_number TEXT,
  registration_email TEXT
);

CREATE TABLE IF NOT EXISTS participants (
  id TEXT PRIMARY KEY,
  application_id TEXT NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
  user_id TEXT NOT NULL REFERENCES users(id),
  campus TEXT,
  registration_email TEXT
);

CREATE TABLE IF NOT EXISTS lesson_slots (
  id TEXT PRIMARY KEY,
  participant_id TEXT NOT NULL REFERENCES participants(id) ON DELETE CASCADE,
  lesson_number INTEGER NOT NULL CHECK (lesson_number BETWEEN 1 AND 8),
  class_name TEXT,
  subject TEXT,
  task_location TEXT,
  is_free INTEGER NOT NULL DEFAULT 0 CHECK (is_free IN (0,1)),
  notes TEXT,
  UNIQUE (participant_id, lesson_number)
);

CREATE TABLE IF NOT EXISTS approval_events (
  id TEXT PRIMARY KEY,
  application_id TEXT NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
  actor_user_id TEXT REFERENCES users(id),
  decision TEXT NOT NULL,
  notes TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS payment_events (
  id TEXT PRIMARY KEY,
  application_id TEXT NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
  actor_user_id TEXT REFERENCES users(id),
  status TEXT NOT NULL,
  notes TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS followups (
  id TEXT PRIMARY KEY,
  participant_id TEXT NOT NULL REFERENCES participants(id) ON DELETE CASCADE,
  attendance_status TEXT CHECK (attendance_status IN ('volledig','gedeeltelijk','afwezig')),
  multiplier_teams TEXT,
  multiplier_method TEXT,
  multiplier_due_date TEXT,
  comments TEXT,
  submitted_at TEXT
);

CREATE TABLE IF NOT EXISTS audit_log (
  id TEXT PRIMARY KEY,
  actor_user_id TEXT REFERENCES users(id),
  entity_type TEXT NOT NULL,
  entity_id TEXT NOT NULL,
  action TEXT NOT NULL,
  before_json TEXT,
  after_json TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS app_settings (
  key TEXT PRIMARY KEY,
  value_json TEXT NOT NULL,
  updated_by TEXT REFERENCES users(id),
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_applications_school_year ON applications(school_year_id);
CREATE INDEX IF NOT EXISTS idx_applications_applicant ON applications(applicant_user_id);
CREATE INDEX IF NOT EXISTS idx_applications_status ON applications(approval_status);
CREATE INDEX IF NOT EXISTS idx_participants_application ON participants(application_id);
CREATE INDEX IF NOT EXISTS idx_lesson_slots_participant ON lesson_slots(participant_id);
