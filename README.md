# NoSQL Databases

Run ```docker-compose up -d``` to launch Elasticsearch cluster. 

Run ```bash import.sh``` command to create index and populate data frin the English dictionary. 

Run 
```curl -XGET "http://localhost:9200/autocomplete/_search?pretty" -H 'Content-Type: application/json' --data-binary @./queries/search.json``` 
command to run search. Search settgins are located in ```/queries/search.json``` file. Example:
```json
{
    "query": {
        "match": {
            "word": {
                "query": "acbelegaje",
                "fuzziness": "AUTO"
            }
        }
    }
}
```
Search for a word **acbelegaje** will still return 
```json
{
        "_index" : "autocomplete",
        "_id" : "yzbIjYMBKLv8DmBgV9IT",
        "_score" : 33.88402,
        "_source" : {
          "word" : "accelerate"
        }
      }
```
as a result. 

I used a combination of fuzziness and ngram analyzer to create autocomplete with types correction using the following settings. 

```json
{
    "settings": {
        "analysis": {
            "analyzer": {
                "custom_edge_ngram_analyzer": {
                    "type": "custom",
                    "tokenizer": "customized_edge_tokenizer",
                    "filter": [
                        "lowercase"
                    ]
                }
            },
            "tokenizer": {
                "customized_edge_tokenizer": {
                    "type": "edge_ngram",
                    "min_gram": 2,
                    "max_gram": 6,
                    "token_chars": [
                        "letter"
                    ]
                }
            }
        }
    },
    "mappings": {
        "properties": {
            "word": {
                "type": "text",
                "analyzer": "custom_edge_ngram_analyzer"
            }
        }
    }
}
```