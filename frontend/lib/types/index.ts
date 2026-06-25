export interface User {
  id: string;
  email: string;
  name: string;
  avatar?: string;
  createdAt: string;
  updatedAt: string;
}

export interface AuthResponse {
  success: boolean;
  data: {
    user: User;
    token: string;
  };
  meta: {
    requestId: string;
    timestamp: string;
  };
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface RegisterRequest {
  email: string;
  password: string;
  name: string;
}

export interface Paper {
  id: string;
  title: string;
  abstract: string;
  authors: Author[];
  year: number;
  doi?: string;
  arxivId?: string;
  url: string;
  citations: number;
  keywords: string[];
  createdAt: string;
  updatedAt: string;
}

export interface Author {
  id: string;
  name: string;
  affiliation?: string;
}

export interface SearchQuery {
  q: string;
  type?: 'paper' | 'author' | 'topic' | 'institution';
  page?: number;
  pageSize?: number;
  sort?: 'relevance' | 'citations' | 'date';
}

export interface SearchResult {
  items: Paper[];
  total: number;
  page: number;
  pageSize: number;
  hasMore: boolean;
}

export interface KnowledgeGraphNode {
  id: string;
  label: string;
  type: 'author' | 'topic' | 'institution' | 'paper';
  metadata?: Record<string, unknown>;
}

export interface KnowledgeGraphEdge {
  id: string;
  source: string;
  target: string;
  weight: number;
  type: string;
}

export interface KnowledgeGraph {
  nodes: KnowledgeGraphNode[];
  edges: KnowledgeGraphEdge[];
}

export interface NoveltyScore {
  paperId: string;
  score: number;
  reasoning: string;
  relatedPapers: string[];
}

export interface ResearchGap {
  id: string;
  title: string;
  description: string;
  relatedTopics: string[];
  relatedPapers: string[];
  opportunity: string;
  difficulty: 'low' | 'medium' | 'high';
}

export interface CopilotMessage {
  id: string;
  role: 'user' | 'assistant';
  content: string;
  timestamp: string;
}

export interface CopilotConversation {
  id: string;
  title: string;
  messages: CopilotMessage[];
  createdAt: string;
  updatedAt: string;
}

export interface ApiResponse<T> {
  success: boolean;
  data: T;
  meta: {
    requestId: string;
    timestamp: string;
  };
}

export interface ApiError {
  success: false;
  error: {
    code: string;
    message: string;
  };
}

export interface PaginatedResponse<T> {
  items: T[];
  total: number;
  page: number;
  pageSize: number;
  hasMore: boolean;
}
