# Jina AI reranking format (Rerank)

### Introduction

Jina AI Rerank is a powerful text reranking model that can rank document lists for relevance based on queries. The model supports multiple languages ​​and can process text content in different languages ​​and assign a relevance score to each document.


### Basic reordering request:

```
curl https://api.wukong.support/v1/rerank \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "model": "jina-reranker-v2-base-multilingual",
    "query": "Organic skincare products for sensitive skin",
    "top_n": 3,
    "documents": [
      "Organic skincare for sensitive skin with aloe vera and chamomile...",
      "New makeup trends focus on bold colors and innovative techniques...",
      "Bio-Hautpflege für empfindliche Haut mit Aloe Vera und Kamille..."
    ]
  }'
  
```

### Response example:

```
{
  "results": [
    {
      "document": {
        "text": "Organic skincare for sensitive skin with aloe vera and chamomile..."
      },
      "index": 0,
      "relevance_score": 0.8783142566680908
    },
    {
      "document": {
        "text": "Bio-Hautpflege für empfindliche Haut mit Aloe Vera und Kamille..."
      },
      "index": 2,
      "relevance_score": 0.7624675869941711
    }
  ],
  "usage": {
    "prompt_tokens": 815,
    "completion_tokens": 0,
    "total_tokens": 815
  }
}
```





