export interface Paper {
  id: string;
  sourceId: string;
  source: 'arxiv' | 'pubmed' | 'biorxiv' | 'crossref';
  title: string;
  abstract: string;
  authors: Author[];
  publicationDate: Date;
  citationCount: number;
  noveltyScore: number;
  pdfUrl?: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface Author {
  id?: string;
  name: string;
  affiliation?: string;
  orcidId?: string;
}

export interface PaperContent {
  paperId: string;
  fullText: string;
  keyFindings: string;
  methodology: string;
  limitations: string;
}
