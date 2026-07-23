# Jina AI 重排序格式（Rerank）

### 简介

Jina AI Rerank 是一个强大的文本重排序模型，可以根据查询对文档列表进行相关性排序。该模型支持多语言，可以处理不同语言的文本内容，并为每个文档分配相关性分数。


### 基础重排序请求:

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

### 响应示例:

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





