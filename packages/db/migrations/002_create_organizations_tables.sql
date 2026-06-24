-- Migration: 002_create_organizations_tables.sql
-- Description: Organizations, teams, and membership tables
-- Created: 2024-01-01

-- Create organizations table
CREATE TABLE organizations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  organization_type VARCHAR(50) NOT NULL CHECK (organization_type IN ('university', 'company', 'lab', 'hospital', 'other')),
  domain VARCHAR(255),
  website_url VARCHAR(500),
  logo_url VARCHAR(500),
  description TEXT,
  contact_email VARCHAR(255),
  country VARCHAR(100),
  timezone VARCHAR(50),
  verification_status VARCHAR(20) DEFAULT 'pending' CHECK (verification_status IN ('verified', 'pending', 'rejected')),
  subscription_tier VARCHAR(20) DEFAULT 'free' CHECK (subscription_tier IN ('free', 'professional', 'enterprise')),
  created_by_user_id UUID,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  metadata JSONB
);

-- Create organization members table
CREATE TABLE organization_members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role VARCHAR(20) NOT NULL CHECK (role IN ('admin', 'member', 'viewer')),
  joined_at TIMESTAMP DEFAULT NOW(),
  invited_by_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  invitation_accepted_at TIMESTAMP,
  is_primary_org BOOLEAN DEFAULT false,
  UNIQUE(organization_id, user_id)
);

-- Create teams table
CREATE TABLE teams (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  created_by_user_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  is_public BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(organization_id, name)
);

-- Create team members table
CREATE TABLE team_members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role VARCHAR(20) NOT NULL CHECK (role IN ('lead', 'member')),
  joined_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(team_id, user_id)
);

-- Create indexes for organizations
CREATE INDEX idx_organizations_domain ON organizations(domain);
CREATE INDEX idx_organizations_subscription_tier ON organizations(subscription_tier);
CREATE INDEX idx_organizations_created_by ON organizations(created_by_user_id);

-- Create indexes for organization members
CREATE INDEX idx_org_members_organization ON organization_members(organization_id);
CREATE INDEX idx_org_members_user ON organization_members(user_id);
CREATE INDEX idx_org_members_role ON organization_members(role);

-- Create indexes for teams
CREATE INDEX idx_teams_organization ON teams(organization_id);
CREATE INDEX idx_teams_created_by ON teams(created_by_user_id);
CREATE INDEX idx_teams_public ON teams(organization_id) WHERE is_public = true;

-- Create indexes for team members
CREATE INDEX idx_team_members_team ON team_members(team_id);
CREATE INDEX idx_team_members_user ON team_members(user_id);
CREATE INDEX idx_team_members_role ON team_members(role);
