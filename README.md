# Wiremock Oyun Alanı

### Zaman ve Tarih

```json
{
  "request": {
    "method": "GET",
    "url": "/now"
  },
  "response": {
    "status": 200,
    "body": "{{now timezone='Europe/Istanbul'}}",
    "transformers": ["response-template"]
  }
}
```

```rest
GET http://test/now HTTP/1.1
Host: test
```
