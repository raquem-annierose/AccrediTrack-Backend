-- ==========================================
-- 1. DATABASE CREATION
-- ==========================================
DROP DATABASE IF EXISTS accreditrack_db;
CREATE DATABASE accreditrack_db;
USE accreditrack_db;

CREATE TABLE `programs` (
  `id` INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `code` VARCHAR(100) NULL DEFAULT NULL,
  `name` VARCHAR(255) NULL DEFAULT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `image_path` VARCHAR(255) NULL DEFAULT NULL,
  `program_status` ENUM('active','inactive','phased_out') DEFAULT 'active',
  `status` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 = active | 0 = inactive',
  `created_by` VARCHAR(255) NULL DEFAULT NULL,
  `created_by_id` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` DATETIME NULL DEFAULT NULL
);

CREATE TABLE `accreditation_levels` (
  `id` INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `code` VARCHAR(100) NULL DEFAULT NULL,
  `name` VARCHAR(255) NULL DEFAULT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `status` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 = active | 0 = inactive',
  `created_by` VARCHAR(255) NULL DEFAULT NULL,
  `created_by_id` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` DATETIME NULL DEFAULT NULL
);

CREATE TABLE `accreditation_cycles` (
  `id` INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `batch_name` VARCHAR(255) NULL DEFAULT NULL,
  `start_date` DATE NULL DEFAULT NULL,
  `end_date` DATE NULL DEFAULT NULL,
  `accreditation_cycle_status` ENUM('planning','ongoing','closed','archived') DEFAULT 'planning',
  `status` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 = active | 0 = inactive',
  `created_by` VARCHAR(255) NULL DEFAULT NULL,
  `created_by_id` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` DATETIME NULL DEFAULT NULL
);

CREATE TABLE `accreditation_cycles_programs` (
  `id` INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `accreditation_level_id` INT(11) NULL DEFAULT NULL,
  `program_id` INT(11) NOT NULL,
  `accreditation_cycle_id` INT(11) NOT NULL,
  `status` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 = active | 0 = inactive',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` DATETIME NULL DEFAULT NULL
);

CREATE TABLE `accreditation_areas` (
  `id` INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(100) NULL DEFAULT NULL,
  `title` VARCHAR(255) NULL DEFAULT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `image_path` VARCHAR(255) NULL DEFAULT NULL,
  `status` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 = active | 0 = inactive',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` DATETIME NULL DEFAULT NULL
);

CREATE TABLE `accreditation_area_parameters` (
  `id` INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `accreditation_area_id` INT(11) NOT NULL,
  `accreditation_cycle_program_id` INT(11) NOT NULL,
  `name` VARCHAR(100) NULL DEFAULT NULL,
  `title` VARCHAR(255) NULL DEFAULT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `status` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 = active | 0 = inactive',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` DATETIME NULL DEFAULT NULL
);

CREATE TABLE `accreditation_area_parameters_phases` (
  `id` INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `accreditation_area_parameter_id` INT(11) NOT NULL,
  `accreditation_phase_id` INT(11) NOT NULL,
  `status` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 = active | 0 = inactive',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` DATETIME NULL DEFAULT NULL
);

CREATE TABLE `accreditation_phases` (
  `id` INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `code` VARCHAR(10) NULL DEFAULT NULL,
  `title` VARCHAR(255) NULL DEFAULT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `status` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 = active | 0 = inactive',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` DATETIME NULL DEFAULT NULL
);

CREATE TABLE `accreditation_benchmarks` (
  `id` INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `accreditation_area_parameters_phase_id` INT(11) NOT NULL,
  `benchmark_title` VARCHAR(255) NULL DEFAULT NULL,
  `benchmark_code` VARCHAR(10) NULL DEFAULT NULL,
  `benchmark_description` VARCHAR(255) NULL DEFAULT NULL,
  `benchmark_requirement` TEXT NULL DEFAULT NULL,
  `status` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 = active | 0 = inactive',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` DATETIME NULL DEFAULT NULL
);

CREATE TABLE `benchmark_tasks` (
  `id` INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `accreditation_benchmark_id` INT(11) NOT NULL,
  `assigned_user_id` VARCHAR(255) NULL DEFAULT NULL,
  `assigned_user_fullname` VARCHAR(255) NULL DEFAULT NULL,
  `internal_accreditor_user_id` VARCHAR(255) DEFAULT NULL,
  `internal_accreditor_user_fullname` VARCHAR(255) DEFAULT NULL,
  `internal_accreditor_evaluated_at` DATETIME NULL DEFAULT NULL,
  `internal_accreditor_ratings` INT(2) NULL DEFAULT NULL COMMENT '1 - Lowest , 5 = Highest',
  `internal_accreditor_comments` VARCHAR(255) NULL DEFAULT NULL,
  `external_accreditor_user_id` VARCHAR(255) DEFAULT NULL,
  `external_accreditor_user_fullname` VARCHAR(255) DEFAULT NULL,
  `external_accreditor_evaluated_at` DATETIME NULL DEFAULT NULL,
  `external_accreditor_ratings` INT(2) NULL DEFAULT NULL COMMENT '1 - Lowest , 5 = Highest',
  `external_accreditor_comments` VARCHAR(255) NULL DEFAULT NULL,
  `due_date` DATETIME NULL DEFAULT NULL,
  `task_status` ENUM('not_started', 'in_progress', 'submitted' , 'approved' , 'for_revision' ) DEFAULT 'not_started',
  `status` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 = active | 0 = inactive',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` DATETIME NULL DEFAULT NULL
);

CREATE TABLE `benchmark_task_artifacts` (
  `id` INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `benchmark_task_id` INT(11) NOT NULL,
  `uploader_id` VARCHAR(255) NULL DEFAULT NULL,
  `uploader_fullname` VARCHAR(255) NULL DEFAULT NULL,
  `filename` VARCHAR(255) DEFAULT NULL,
  `file_path` VARCHAR(255) DEFAULT NULL,
  `uploaded_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `status` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 = active | 0 = inactive',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` DATETIME NULL DEFAULT NULL
);

CREATE TABLE `benchmark_task_artifacts_comments` (
  `id` INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `benchmark_task_artifact_id` INT(11) NOT NULL,
  `comment` VARCHAR(255) NULL DEFAULT NULL,
  `user_id` VARCHAR(255) NULL DEFAULT NULL,
  `user_fullname` VARCHAR(255) NULL DEFAULT NULL,
  `status` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 = active | 0 = inactive',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` DATETIME NULL DEFAULT NULL
);

CREATE TABLE `notifications` (
  `id` INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `user_id` VARCHAR(255) NULL DEFAULT NULL,
  `user_fullname` VARCHAR(255) NULL DEFAULT NULL,
  `title` VARCHAR(255) NULL DEFAULT NULL,
  `message` VARCHAR(255) NULL DEFAULT NULL,
  `status` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 = active | 0 = inactive',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` DATETIME NULL DEFAULT NULL
);

CREATE TABLE `audit_logs` (
  `id` INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `user_id` VARCHAR(255) NULL DEFAULT NULL,
  `user_fullname` VARCHAR(255) NULL DEFAULT NULL,
  `action` VARCHAR(255) NULL DEFAULT NULL,
  `details` VARCHAR(255) NULL DEFAULT NULL,
  `ip_address` VARCHAR(100) NULL DEFAULT NULL,
  `status` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 = active | 0 = inactive',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` DATETIME NULL DEFAULT NULL
);

ALTER TABLE `accreditation_cycles_programs` ADD FOREIGN KEY (`accreditation_level_id`) REFERENCES `accreditation_levels` (`id`);

ALTER TABLE `accreditation_cycles_programs` ADD FOREIGN KEY (`program_id`) REFERENCES `programs` (`id`);

ALTER TABLE `accreditation_cycles_programs` ADD FOREIGN KEY (`accreditation_cycle_id`) REFERENCES `accreditation_cycles` (`id`);

ALTER TABLE `accreditation_area_parameters` ADD FOREIGN KEY (`accreditation_area_id`) REFERENCES `accreditation_areas` (`id`);

ALTER TABLE `accreditation_area_parameters` ADD FOREIGN KEY (`accreditation_cycle_program_id`) REFERENCES `accreditation_cycles_programs` (`id`);

ALTER TABLE `accreditation_area_parameters_phases` ADD FOREIGN KEY (`accreditation_area_parameter_id`) REFERENCES `accreditation_area_parameters` (`id`);

ALTER TABLE `accreditation_area_parameters_phases` ADD FOREIGN KEY (`accreditation_phase_id`) REFERENCES `accreditation_phases` (`id`);

ALTER TABLE `accreditation_benchmarks` ADD FOREIGN KEY (`accreditation_area_parameters_phase_id`) REFERENCES `accreditation_area_parameters_phases` (`id`);

ALTER TABLE `benchmark_tasks` ADD FOREIGN KEY (`accreditation_benchmark_id`) REFERENCES `accreditation_benchmarks` (`id`);

ALTER TABLE `benchmark_task_artifacts` ADD FOREIGN KEY (`benchmark_task_id`) REFERENCES `benchmark_tasks` (`id`);

ALTER TABLE `benchmark_task_artifacts_comments` ADD FOREIGN KEY (`benchmark_task_artifact_id`) REFERENCES `benchmark_task_artifacts` (`id`);
