PRAGMA foreign_keys = ON;

-- Rules for yearly and category-specific professionalisation budgets.
CREATE TABLE IF NOT EXISTS budget_rules (
  id TEXT PRIMARY KEY,
  school_year_id TEXT NOT NULL REFERENCES school_years(id) ON DELETE CASCADE,
  category TEXT NOT NULL CHECK (category IN ('pedagogisch_didactisch','vakinhoudelijk')),
  max_amount_cents INTEGER,
  max_hours INTEGER,
  applies_to TEXT NOT NULL DEFAULT 'per_person',
  active INTEGER NOT NULL DEFAULT 1 CHECK (active IN (0,1)),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE (school_year_id, category, applies_to)
);

-- Metadata for documents. Binary files will be stored in a private R2 bucket,
-- never directly in the D1 database.
CREATE TABLE IF NOT EXISTS application_documents (
  id TEXT PRIMARY KEY,
  application_id TEXT NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
  uploaded_by TEXT NOT NULL REFERENCES users(id),
  original_filename TEXT NOT NULL,
  object_key TEXT NOT NULL UNIQUE,
  mime_type TEXT NOT NULL,
  size_bytes INTEGER NOT NULL CHECK (size_bytes > 0),
  uploaded_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Outbox pattern: notifications are queued transactionally and sent by a worker.
CREATE TABLE IF NOT EXISTS notification_outbox (
  id TEXT PRIMARY KEY,
  application_id TEXT REFERENCES applications(id) ON DELETE CASCADE,
  recipient_user_id TEXT REFERENCES users(id),
  recipient_email TEXT NOT NULL,
  template_key TEXT NOT NULL,
  payload_json TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','processing','sent','failed')),
  attempts INTEGER NOT NULL DEFAULT 0,
  next_attempt_at TEXT,
  sent_at TEXT,
  last_error TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Track tasks that arise after an approval, such as PICTO entry or
-- arranging lesson cover. This keeps follow-up separate from approval.
CREATE TABLE IF NOT EXISTS application_tasks (
  id TEXT PRIMARY KEY,
  application_id TEXT NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
  task_type TEXT NOT NULL CHECK (task_type IN ('pictO_registration','lesson_cover','payment','registration','other')),
  assigned_role TEXT,
  assigned_user_id TEXT REFERENCES users(id),
  status TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open','in_progress','done','cancelled')),
  due_at TEXT,
  completed_at TEXT,
  notes TEXT,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_notification_outbox_status ON notification_outbox(status, next_attempt_at);
CREATE INDEX IF NOT EXISTS idx_application_tasks_status ON application_tasks(status, assigned_role);
CREATE INDEX IF NOT EXISTS idx_application_documents_application ON application_documents(application_id);
