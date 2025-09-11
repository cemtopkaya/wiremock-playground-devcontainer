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
    "jsonBody": {
      "now": "{{now timezone='Europe/Istanbul'}}",
      "after": "{{now timezone='Europe/Istanbul' offset='now +5 hours'}}",
      "before": "{{now timezone='Europe/Istanbul' offset='now -11 minutes'}}",
      "epoch": "{{now format='epoch'}}",
      "unix": "{{now format='unix'}}"
    },
    "transformers": ["response-template"],
    "headers": {
      "Content-Type": "application/json"
    }
  }
}
```

```rest
GET http://test/now HTTP/1.1
Host: test
```

Sonuç:

```text
HTTP/1.1 200 OK
Connection: close
Content-Type: application/json
Matched-Stub-Id: 99d3c4be-628f-4aea-a09b-0339d2602ba9

{
  "now": "2025-09-11T19:46:40+03:00",
  "after": "2025-09-12T00:46:40+03:00",
  "before": "2025-09-11T19:35:40+03:00",
  "epoch": "1757609200185",
  "unix": "1757609200"
}
```
