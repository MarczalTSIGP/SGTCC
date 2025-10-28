PRAGMA foreign_keys = ON;

-- ============================================
-- solid_queue_blocked_executions
-- ============================================
CREATE TABLE solid_queue_blocked_executions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    job_id INTEGER NOT NULL,
    queue_name TEXT NOT NULL,
    priority INTEGER NOT NULL DEFAULT 0,
    concurrency_key TEXT NOT NULL,
    expires_at DATETIME NOT NULL,
    created_at DATETIME NOT NULL,
    FOREIGN KEY (job_id) REFERENCES solid_queue_jobs(id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX index_solid_queue_blocked_executions_on_job_id
    ON solid_queue_blocked_executions(job_id);

CREATE INDEX index_solid_queue_blocked_executions_for_release
    ON solid_queue_blocked_executions(concurrency_key, priority, job_id);

CREATE INDEX index_solid_queue_blocked_executions_for_maintenance
    ON solid_queue_blocked_executions(expires_at, concurrency_key);

-- ============================================
-- solid_queue_claimed_executions
-- ============================================
CREATE TABLE solid_queue_claimed_executions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    job_id INTEGER NOT NULL,
    process_id INTEGER,
    created_at DATETIME NOT NULL,
    FOREIGN KEY (job_id) REFERENCES solid_queue_jobs(id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX index_solid_queue_claimed_executions_on_job_id
    ON solid_queue_claimed_executions(job_id);

CREATE INDEX index_solid_queue_claimed_executions_on_process_id_and_job_id
    ON solid_queue_claimed_executions(process_id, job_id);

-- ============================================
-- solid_queue_failed_executions
-- ============================================
CREATE TABLE solid_queue_failed_executions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    job_id INTEGER NOT NULL,
    error TEXT,
    created_at DATETIME NOT NULL,
    FOREIGN KEY (job_id) REFERENCES solid_queue_jobs(id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX index_solid_queue_failed_executions_on_job_id
    ON solid_queue_failed_executions(job_id);

-- ============================================
-- solid_queue_jobs
-- ============================================
CREATE TABLE solid_queue_jobs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    queue_name TEXT NOT NULL,
    class_name TEXT NOT NULL,
    arguments TEXT,
    priority INTEGER NOT NULL DEFAULT 0,
    active_job_id TEXT,
    scheduled_at DATETIME,
    finished_at DATETIME,
    concurrency_key TEXT,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL
);

CREATE INDEX index_solid_queue_jobs_on_active_job_id ON solid_queue_jobs(active_job_id);
CREATE INDEX index_solid_queue_jobs_on_class_name ON solid_queue_jobs(class_name);
CREATE INDEX index_solid_queue_jobs_on_finished_at ON solid_queue_jobs(finished_at);
CREATE INDEX index_solid_queue_jobs_for_filtering ON solid_queue_jobs(queue_name, finished_at);
CREATE INDEX index_solid_queue_jobs_for_alerting ON solid_queue_jobs(scheduled_at, finished_at);

-- ============================================
-- solid_queue_pauses
-- ============================================
CREATE TABLE solid_queue_pauses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    queue_name TEXT NOT NULL,
    created_at DATETIME NOT NULL
);

CREATE UNIQUE INDEX index_solid_queue_pauses_on_queue_name
    ON solid_queue_pauses(queue_name);

-- ============================================
-- solid_queue_processes
-- ============================================
CREATE TABLE solid_queue_processes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    kind TEXT NOT NULL,
    last_heartbeat_at DATETIME NOT NULL,
    supervisor_id INTEGER,
    pid INTEGER NOT NULL,
    hostname TEXT,
    metadata TEXT,
    created_at DATETIME NOT NULL,
    name TEXT NOT NULL
);

CREATE INDEX index_solid_queue_processes_on_last_heartbeat_at
    ON solid_queue_processes(last_heartbeat_at);

CREATE UNIQUE INDEX index_solid_queue_processes_on_name_and_supervisor_id
    ON solid_queue_processes(name, supervisor_id);

CREATE INDEX index_solid_queue_processes_on_supervisor_id
    ON solid_queue_processes(supervisor_id);

-- ============================================
-- solid_queue_ready_executions
-- ============================================
CREATE TABLE solid_queue_ready_executions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    job_id INTEGER NOT NULL,
    queue_name TEXT NOT NULL,
    priority INTEGER NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL,
    FOREIGN KEY (job_id) REFERENCES solid_queue_jobs(id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX index_solid_queue_ready_executions_on_job_id
    ON solid_queue_ready_executions(job_id);

CREATE INDEX index_solid_queue_poll_all
    ON solid_queue_ready_executions(priority, job_id);

CREATE INDEX index_solid_queue_poll_by_queue
    ON solid_queue_ready_executions(queue_name, priority, job_id);

-- ============================================
-- solid_queue_recurring_executions
-- ============================================
CREATE TABLE solid_queue_recurring_executions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    job_id INTEGER NOT NULL,
    task_key TEXT NOT NULL,
    run_at DATETIME NOT NULL,
    created_at DATETIME NOT NULL,
    FOREIGN KEY (job_id) REFERENCES solid_queue_jobs(id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX index_solid_queue_recurring_executions_on_job_id
    ON solid_queue_recurring_executions(job_id);

CREATE UNIQUE INDEX index_solid_queue_recurring_executions_on_task_key_and_run_at
    ON solid_queue_recurring_executions(task_key, run_at);

-- ============================================
-- solid_queue_recurring_tasks
-- ============================================
CREATE TABLE solid_queue_recurring_tasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    key TEXT NOT NULL,
    schedule TEXT NOT NULL,
    command TEXT,
    class_name TEXT,
    arguments TEXT,
    queue_name TEXT,
    priority INTEGER DEFAULT 0,
    static BOOLEAN NOT NULL DEFAULT 1,
    description TEXT,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL
);

CREATE UNIQUE INDEX index_solid_queue_recurring_tasks_on_key
    ON solid_queue_recurring_tasks(key);

CREATE INDEX index_solid_queue_recurring_tasks_on_static
    ON solid_queue_recurring_tasks(static);

-- ============================================
-- solid_queue_scheduled_executions
-- ============================================
CREATE TABLE solid_queue_scheduled_executions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    job_id INTEGER NOT NULL,
    queue_name TEXT NOT NULL,
    priority INTEGER NOT NULL DEFAULT 0,
    scheduled_at DATETIME NOT NULL,
    created_at DATETIME NOT NULL,
    FOREIGN KEY (job_id) REFERENCES solid_queue_jobs(id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX index_solid_queue_scheduled_executions_on_job_id
    ON solid_queue_scheduled_executions(job_id);

CREATE INDEX index_solid_queue_dispatch_all
    ON solid_queue_scheduled_executions(scheduled_at, priority, job_id);

-- ============================================
-- solid_queue_semaphores
-- ============================================
CREATE TABLE solid_queue_semaphores (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    key TEXT NOT NULL,
    value INTEGER NOT NULL DEFAULT 1,
    expires_at DATETIME NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL
);

CREATE UNIQUE INDEX index_solid_queue_semaphores_on_key
    ON solid_queue_semaphores(key);

CREATE INDEX index_solid_queue_semaphores_on_key_and_value
    ON solid_queue_semaphores(key, value);

CREATE INDEX index_solid_queue_semaphores_on_expires_at
    ON solid_queue_semaphores(expires_at);

-- ============================================
-- notifications
-- ============================================
CREATE TABLE notifications (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    recipient_type TEXT NOT NULL,
    recipient_id INTEGER NOT NULL,
    event_key TEXT,
    notification_type TEXT NOT NULL,
    data TEXT DEFAULT '{}',
    sent_at DATETIME,
    attempts INTEGER NOT NULL DEFAULT 0,
    max_attempts INTEGER NOT NULL DEFAULT 3,
    status TEXT DEFAULT 'pending',
    scheduled_at DATETIME,
    last_attempted_at DATETIME,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL
);

CREATE INDEX index_notifications_on_recipient
    ON notifications(recipient_type, recipient_id);

-- ============================================
-- notification_templates
-- ============================================
CREATE TABLE notification_templates (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    key TEXT NOT NULL UNIQUE,
    subject TEXT NOT NULL,
    body TEXT NOT NULL,
    channel TEXT NOT NULL DEFAULT 'email',
    active BOOLEAN NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL
);

-- ============================================
-- notification_rules
-- ============================================
CREATE TABLE notification_rules (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    notification_template_id INTEGER NOT NULL,
    days_before INTEGER NOT NULL DEFAULT 0,
    max_retries INTEGER NOT NULL DEFAULT 1,
    hours_before INTEGER NOT NULL DEFAULT 0,
    hours_after INTEGER NOT NULL DEFAULT 0,
    retry_interval_hours INTEGER NOT NULL DEFAULT 0,
    extra_notes TEXT,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    FOREIGN KEY (notification_template_id) REFERENCES notification_templates(id)
);

CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);

INSERT INTO "schema_migrations" (version) VALUES
('20251027193144'),
('20251027193205'),
('20251027193220');
