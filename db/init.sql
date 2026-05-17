-- Table des utilisateurs
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    username VARCHAR(150) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role VARCHAR(20) CHECK (role IN ('agent','apporteur','admin')) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending','active','disabled')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Superadmin par défaut
INSERT INTO users (name, username, password_hash, role, status)
VALUES ('SuperAdmin', 'info@bankad.name', crypt('admin', gen_salt('bf')), 'admin', 'active')
ON CONFLICT (username) DO NOTHING;

-- Table des prospects
CREATE TABLE IF NOT EXISTS prospects (
    id SERIAL PRIMARY KEY,
    agent_id INT REFERENCES users(id),
    name VARCHAR(150) NOT NULL,
    survey_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des budgets
CREATE TABLE IF NOT EXISTS budgets (
    id SERIAL PRIMARY KEY,
    prospect_id INT REFERENCES prospects(id),
    amount NUMERIC(12,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des commissions
CREATE TABLE IF NOT EXISTS commissions (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    commission_rate NUMERIC(5,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des fichiers cryptés
CREATE TABLE IF NOT EXISTS encrypted_files (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    file_name VARCHAR(255),
    file_data BYTEA,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
