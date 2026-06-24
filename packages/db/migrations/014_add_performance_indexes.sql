-- Migration: 014_add_performance_indexes.sql
-- Description: Advanced indexes for optimization
-- Created: 2024-01-01

-- Composite indexes for common query patterns

-- Search paper by field + novelty
CREATE INDEX idx_papers_field_novelty ON papers(field, novelty_score DESC)
WHERE is_active = true;

-- Recent papers by field
CREATE INDEX idx_papers_field_date ON papers(field, publication_date DESC)
WHERE publication_date > NOW() - INTERVAL '1 year';

-- Collection papers with metadata
CREATE INDEX idx_collection_papers_full ON collection_papers(collection_id, paper_id, is_favorite DESC);

-- Search query patterns
CREATE INDEX idx_search_queries_user_type_date ON search_queries(user_id, search_type, created_at DESC);

-- Topic trends recent data
CREATE INDEX idx_topic_trends_recent ON topic_trends(metric_date DESC)
WHERE metric_date > NOW() - INTERVAL '1 year';

-- Novelty scores recent
CREATE INDEX idx_novelty_scores_recent ON novelty_scores(paper_id, metric_date DESC)
WHERE metric_date > NOW() - INTERVAL '1 month';

-- Knowledge graph entity search
CREATE INDEX idx_kg_entities_search ON knowledge_graph_entities(entity_type, field, paper_count DESC);

-- Comments threaded view
CREATE INDEX idx_comments_thread ON comments(paper_id, parent_comment_id, created_at DESC)
WHERE deleted_at IS NULL;

-- Annotations by collection
CREATE INDEX idx_annotations_collection_type ON annotations(collection_id, annotation_type, created_at DESC);

-- Portfolio analysis trend
CREATE INDEX idx_portfolio_analysis_trend ON portfolio_analysis(organization_id, metric_date DESC);

-- Competitive analysis trend
CREATE INDEX idx_competitive_analysis_trend ON competitive_analysis(organization_id, metric_date DESC, competing_on_topic);

-- Gap opportunities by team
CREATE INDEX idx_gap_opportunities_team_score ON gap_opportunities(team_id, opportunity_score DESC);

-- User research interests
CREATE INDEX idx_users_interests ON users USING GIN(research_interests);

-- Paper keywords search
CREATE INDEX idx_papers_keywords ON papers USING GIN(keywords);

-- RAG retrieval performance
CREATE INDEX idx_rag_retrievals_quality ON rag_retrievals(session_id, result_quality_score DESC);

-- Active sessions
CREATE INDEX idx_copilot_sessions_active ON copilot_sessions(user_id, started_at DESC)
WHERE ended_at IS NULL;

-- Organization member active
CREATE INDEX idx_org_members_active ON organization_members(organization_id, role)
WHERE invitation_accepted_at IS NOT NULL;

-- Covering indexes for frequently accessed columns

-- Sessions with user info
CREATE INDEX idx_sessions_full ON sessions(user_id, expires_at)
INCLUDE (ip_address, user_agent);

-- Collections with metadata
CREATE INDEX idx_collections_full ON collections(created_by_user_id, created_at DESC)
INCLUDE (name, collection_type, is_public);

-- Papers with basic info
CREATE INDEX idx_papers_full ON papers(source, source_id)
INCLUDE (title, publication_date, citation_count);

-- Audit logs with context
CREATE INDEX idx_audit_logs_full ON audit_logs(created_at DESC)
INCLUDE (user_id, action_type, resource_type);

-- BRIN (Block Range Index) for time-series data
-- More efficient for large tables with natural ordering

CREATE INDEX idx_auth_logs_brin ON auth_audit_logs USING BRIN (created_at);
CREATE INDEX idx_search_queries_brin ON search_queries USING BRIN (created_at);
CREATE INDEX idx_entity_mentions_brin ON entity_mentions USING BRIN (created_at);
CREATE INDEX idx_copilot_messages_brin ON copilot_messages USING BRIN (created_at);

-- Statistics for query planner
ANALYZE users;
ANALYZE papers;
ANALYZE collections;
ANALYZE search_queries;
ANALYZE auth_audit_logs;
ANALYZE knowledge_graph_entities;
ANALYZE research_projects;
ANALYZE research_gaps;
