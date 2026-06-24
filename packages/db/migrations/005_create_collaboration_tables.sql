-- Migration: 005_create_collaboration_tables.sql
-- Description: Annotations, comments, and research projects tables
-- Created: 2024-01-01

-- Create annotations table
CREATE TABLE annotations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  paper_id UUID NOT NULL REFERENCES papers(id) ON DELETE CASCADE,
  created_by_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  collection_id UUID REFERENCES collections(id) ON DELETE SET NULL,
  annotation_type VARCHAR(50) NOT NULL CHECK (annotation_type IN ('highlight', 'note', 'bookmark')),
  page_number INTEGER,
  text_quoted VARCHAR(500),
  annotation_text TEXT,
  color_code VARCHAR(20),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create comments table
CREATE TABLE comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  paper_id UUID NOT NULL REFERENCES papers(id) ON DELETE CASCADE,
  annotation_id UUID REFERENCES annotations(id) ON DELETE SET NULL,
  parent_comment_id UUID REFERENCES comments(id) ON DELETE CASCADE,
  created_by_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  comment_text TEXT NOT NULL,
  is_edited BOOLEAN DEFAULT false,
  edited_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW(),
  deleted_at TIMESTAMP
);

-- Create comment reactions table
CREATE TABLE comment_reactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  comment_id UUID NOT NULL REFERENCES comments(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  reaction_emoji VARCHAR(10) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(comment_id, user_id, reaction_emoji)
);

-- Create research projects table
CREATE TABLE research_projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID REFERENCES organizations(id) ON DELETE SET NULL,
  created_by_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  team_id UUID REFERENCES teams(id) ON DELETE SET NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  status VARCHAR(50) NOT NULL CHECK (status IN ('planning', 'active', 'completed', 'archived')),
  start_date DATE,
  end_date DATE,
  research_area VARCHAR(100),
  collection_id UUID REFERENCES collections(id) ON DELETE SET NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create project members table
CREATE TABLE project_members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES research_projects(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role VARCHAR(50) NOT NULL CHECK (role IN ('lead', 'contributor')),
  joined_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(project_id, user_id)
);

-- Create indexes for annotations
CREATE INDEX idx_annotations_paper ON annotations(paper_id);
CREATE INDEX idx_annotations_user ON annotations(created_by_user_id);
CREATE INDEX idx_annotations_collection ON annotations(collection_id);
CREATE INDEX idx_annotations_type ON annotations(annotation_type);

-- Create indexes for comments
CREATE INDEX idx_comments_paper ON comments(paper_id);
CREATE INDEX idx_comments_annotation ON comments(annotation_id);
CREATE INDEX idx_comments_user ON comments(created_by_user_id);
CREATE INDEX idx_comments_parent ON comments(parent_comment_id);
CREATE INDEX idx_comments_created_at ON comments(created_at DESC);

-- Create indexes for comment reactions
CREATE INDEX idx_reactions_comment ON comment_reactions(comment_id);
CREATE INDEX idx_reactions_user ON comment_reactions(user_id);

-- Create indexes for research projects
CREATE INDEX idx_projects_organization ON research_projects(organization_id);
CREATE INDEX idx_projects_team ON research_projects(team_id);
CREATE INDEX idx_projects_user ON research_projects(created_by_user_id);
CREATE INDEX idx_projects_status ON research_projects(status);
CREATE INDEX idx_projects_dates ON research_projects(start_date, end_date);

-- Create indexes for project members
CREATE INDEX idx_project_members_project ON project_members(project_id);
CREATE INDEX idx_project_members_user ON project_members(user_id);
