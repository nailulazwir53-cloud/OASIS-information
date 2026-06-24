-- Users table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  email_verified BOOLEAN DEFAULT false,
  password_hash VARCHAR(255) NOT NULL,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  profile_picture_url VARCHAR(500),
  orcid_id VARCHAR(50),
  h_index INTEGER,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  is_active BOOLEAN DEFAULT true,
  metadata JSONB
);

CREATE INDEX idx_users_email ON users(email);

-- Papers table
CREATE TABLE papers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source_id VARCHAR(50) NOT NULL,
  source VARCHAR(50) NOT NULL,
  title VARCHAR(500) NOT NULL,
  abstract TEXT,
  publication_date DATE,
  citation_count INTEGER DEFAULT 0,
  novelty_score FLOAT,
  pdf_s3_path VARCHAR(500),
  text_extracted BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(source, source_id)
);

CREATE INDEX idx_papers_source ON papers(source, source_id);
CREATE INDEX idx_papers_publication_date ON papers(publication_date DESC);
CREATE INDEX idx_papers_novelty_score ON papers(novelty_score DESC);

-- ... More tables follow similar pattern
