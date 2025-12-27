-- ==========================================
-- 1. DATABASE CREATION
-- ==========================================
DROP DATABASE IF EXISTS accreditrack_db;
CREATE DATABASE accreditrack_db;
USE accreditrack_db;

-- ==========================================
-- 2. STRUCTURE & METADATA
-- ==========================================

CREATE TABLE programs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    status ENUM('active', 'inactive', 'phased_out') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE accreditation_levels (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(10) NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE accreditation_cycles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    program_id INT NOT NULL,
    level_id INT NOT NULL,
    batch_name VARCHAR(100) NOT NULL,
    start_date DATE,
    end_date DATE,
    status ENUM('planning', 'ongoing', 'closed', 'archived') DEFAULT 'planning',
    FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE CASCADE,
    FOREIGN KEY (level_id) REFERENCES accreditation_levels(id)
);

-- ==========================================
-- 3. USER MANAGEMENT (RBAC)
-- ==========================================

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    program_id INT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM(
        'admin',
        'coordinator',
        'faculty',
        'internal_accreditor',
        'external_accreditor'
    ) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE SET NULL
);

-- ==========================================
-- 4. THE ACCREDITATION INSTRUMENT
-- ==========================================

CREATE TABLE accreditation_areas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT
);

CREATE TABLE parameters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    area_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    FOREIGN KEY (area_id) REFERENCES accreditation_areas(id) ON DELETE CASCADE
);

-- ------------------------------------------
-- S-I-O PHASE REFERENCE TABLE
-- ------------------------------------------

CREATE TABLE ref_phases (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code CHAR(1) NOT NULL,              -- S, I, O
    name VARCHAR(50) NOT NULL,          -- SYSTEM, IMPLEMENTATION, OUTCOMES
    description VARCHAR(255)            -- Full meaning of the phase
);

-- ------------------------------------------
-- BENCHMARKS (per Parameter × Phase)
-- ------------------------------------------

CREATE TABLE benchmarks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    parameter_id INT NOT NULL,
    phase_id INT NOT NULL,
    benchmark_code VARCHAR(10) NOT NULL, -- S.1, I.2, O.1
    description TEXT NOT NULL,

    FOREIGN KEY (parameter_id) REFERENCES parameters(id) ON DELETE CASCADE,
    FOREIGN KEY (phase_id) REFERENCES ref_phases(id)
);

-- ------------------------------------------
-- LEGACY / SIMPLE REQUIREMENTS (optional)
-- ------------------------------------------
-- You may deprecate this later if benchmarks fully replace it

CREATE TABLE requirements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    parameter_id INT NOT NULL,
    description TEXT NOT NULL,
    is_mandatory BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (parameter_id) REFERENCES parameters(id) ON DELETE CASCADE
);

-- ==========================================
-- 5. WORKFLOW & LOCAL FILE STORAGE
-- ==========================================

CREATE TABLE tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cycle_id INT NOT NULL,
    assigned_to_user_id INT NOT NULL,
    requirement_id INT NOT NULL,
    deadline DATE,
    status ENUM('todo', 'in_progress', 'completed') DEFAULT 'todo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cycle_id) REFERENCES accreditation_cycles(id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_to_user_id) REFERENCES users(id),
    FOREIGN KEY (requirement_id) REFERENCES requirements(id)
);

CREATE TABLE task_submissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT NOT NULL,
    uploader_id INT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_size_kb FLOAT,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending_review', 'approved', 'returned') DEFAULT 'pending_review',
    feedback_comment TEXT,
    FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
    FOREIGN KEY (uploader_id) REFERENCES users(id)
);

-- ==========================================
-- 6. EVALUATION MODULE
-- ==========================================

CREATE TABLE evaluations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cycle_id INT NOT NULL,
    area_id INT NOT NULL,
    evaluator_id INT NOT NULL,
    type ENUM('internal', 'external') NOT NULL,
    overall_score DECIMAL(5,2),
    remarks TEXT,
    recommendation TEXT,
    status ENUM('draft', 'submitted', 'finalized') DEFAULT 'draft',
    evaluated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (cycle_id) REFERENCES accreditation_cycles(id) ON DELETE CASCADE,
    FOREIGN KEY (area_id) REFERENCES accreditation_areas(id),
    FOREIGN KEY (evaluator_id) REFERENCES users(id)
);

-- ==========================================
-- 7. SECURITY & LOGGING
-- ==========================================

CREATE TABLE audit_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    action VARCHAR(50) NOT NULL,
    details TEXT,
    ip_address VARCHAR(45),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- ==========================================
-- 8. SEEDING
-- ==========================================

INSERT INTO programs (code, name) VALUES 
('BSIT', 'Bachelor of Science in Information Technology'),
('BSCS', 'Bachelor of Science in Computer Science');

INSERT INTO accreditation_levels (code, name) VALUES 
('Lvl1', 'Level I Formal Survey'),
('Lvl2', 'Level II Re-accreditation');

INSERT INTO accreditation_areas (name, title) VALUES
('Area I', 'Vision, Mission, Goals and Objectives'),
('Area II', 'Faculty'),
('Area III', 'Curriculum and Instruction'),
('Area IV', 'Support to Students'),
('Area V', 'Research'),
('Area VI', 'Extension and Community Involvement'),
('Area VII', 'Library'),
('Area VIII', 'Physical Plant and Facilities'),
('Area IX', 'Laboratories'),
('Area X', 'Administration');

-- S-I-O PHASE SEEDING
INSERT INTO ref_phases (code, name, description) VALUES
('S', 'System', 'Inputs and processes supporting the area'),
('I', 'Implementation', 'Actual execution and deployment'),
('O', 'Outcomes', 'Results, impact, and effectiveness');
