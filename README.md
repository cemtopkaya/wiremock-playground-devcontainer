# Wiremock Oyun Alanı

Wiremock denemeleri için konteyneri ayaklandırıyorum. Bu pratik yapmak için klavye kısayollarıyla: Ctrl+Shift+P -> Run Task -> "start or restart wiremock_test"


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


## json Eklentisi

### parseJson 1

```json
{
  "request": {
    "method": "GET",
    "urlPath": "/parsejson1"
  },
  "response": {
    "status": 200,
    "body": "{{#parseJson 'parsedObj'}}{ \"name\": \"transformed\" }{{/parseJson}}{{parsedObj}}",
    "transformers": ["response-template"],
    "headers": {
      "Content-Type": "application/json"
    }
  }
}
```

```rest
GET http://test/parsejson1 HTTP/1.1
```

Sonuç:

```text
HTTP/1.1 200 OK
Connection: close
Content-Type: application/json
Matched-Stub-Id: 31556ae2-d850-4df3-bf3c-f5dd09bb4666

{name=transformed}
```


### parseJson 2

```json
{
  "request": {
    "method": "GET",
    "urlPath": "/parsejson2"
  },
  "response": {
    "status": 200,
    "body": "{{#parseJson 'parsedObj'}}{\"cmpfToken\": { \"hash\": \"6bfa249f\", \"uid\": 311, \"username\": \"admin\" } }{{/parseJson}}{{parsedObj}}",
    "transformers": ["response-template"],
    "headers": {
      "Content-Type": "application/json"
    }
  }
}
```

```rest
GET http://test/parsejson2 HTTP/1.1
```

Sonuç:

```text
HTTP/1.1 200 OK
Connection: close
Content-Type: application/json
Matched-Stub-Id: edb8b0a7-4c21-4a5e-a21f-158199325aae

{cmpfToken={hash=6bfa249f, uid=311, username=admin}}
```


### parseJson 3 toJson 1

```json
{
  "request": {
    "method": "GET",
    "urlPath": "/parsejson3toJson"
  },
  "response": {
    "status": 200,
    "body": "{{#parseJson 'parsedObj'}}{\"cmpfToken\": { \"hash\": \"6bfa249f\", \"uid\": 311, \"username\": \"admin\" } }{{/parseJson}}{{parsedObj}}{{toJson parsedObj}}",
    "transformers": ["response-template"],
    "headers": {
      "Content-Type": "application/json"
    }
  }
}
```

```rest
GET http://test/parsejson3toJson HTTP/1.1
```

Sonuç:

```text
HTTP/1.1 200 OK
Connection: close
Content-Type: application/json
Matched-Stub-Id: d6b1be4a-d0f4-4b36-8c6b-e618f486c95b

{cmpfToken={hash=6bfa249f, uid=311, username=admin}}{
  "cmpfToken" : {
    "hash" : "6bfa249f",
    "uid" : 311,
    "username" : "admin"
  }
}
```


### toJson 2

```json
{
  "request": {
    "method": "GET",
    "urlPath": "/toJson"
  },
  "response": {
    "status": 200,
    "body": "{{toJson (array 1 2 3) }}",
    "transformers": ["response-template"],
    "headers": {
      "Content-Type": "application/json"
    }
  }
}
```

```rest
GET http://test/toJson HTTP/1.1
```

Sonuç:

```text
HTTP/1.1 200 OK
Connection: close
Content-Type: application/json
Matched-Stub-Id: 2755e08b-dada-4559-83d1-d5e8ad35ea39

[
  1,
  2,
  3
]
```

### jsonPath 1

```json
{
  "request": {
    "method": "POST",
    "urlPath": "/jsonPath1",
    "bodyPatterns": [
      {
        "equalToJson": "{\"username\":\"admin\",\"password\":\"test\",\"rememberMe\":false}",
        "ignoreArrayOrder": true,
        "ignoreExtraElements": true
      }
    ]
  },
  "response": {
    "status": 200,
    "body": "{\"keywords\": \"{{{jsonPath request.body '$.username'}}}\"}",
    "transformers": ["response-template"],
    "headers": {
      "Content-Type": "application/json"
    }
  }
}
```

```rest
POST http://test/jsonPath1 HTTP/1.1

{
    "username":"admin",
    "password":"test",
    "rememberMe":false
}
```

Sonuç:

```text
HTTP/1.1 200 OK
Connection: close
Content-Type: application/json
Matched-Stub-Id: ae2348f3-a1d8-4bbc-ae16-6b1a056e25c5

{
  "keywords": "admin"
}
```


### parseJson 5

```json
{
  "request": {
    "method": "POST",
    "urlPath": "/jsonPath2",
    "bodyPatterns": [
      {
        "equalToJson": "{\"username\":\"admin\",\"password\":\"test\",\"rememberMe\":false}",
        "ignoreArrayOrder": true,
        "ignoreExtraElements": true
      }
    ]
  },
  "response": {
    "status": 200,
    "body": { "keywords": {{{jsonPath request.body '$'}}}},
    "transformers": ["response-template"],
    "headers": {
      "Content-Type": "application/json"
    }
  }
}
```

```rest
POST http://test/jsonPath2 HTTP/1.1

{
    "username":"admin",
    "password":"test",
    "rememberMe":false
}
```

Sonuç:

```text
HTTP/1.1 200 OK
Connection: close
Content-Type: application/json
Matched-Stub-Id: d8fa79f6-6811-470d-9a6c-618da5a6dda2

{
  "keywords": {
    "username": "admin",
    "password": "test",
    "rememberMe": false
  }
}
```


### parseJson 6 jsonPath 2

```json
```

```rest
POST http://test/parsejson3jsonPath HTTP/1.1

{
    "username":"admin",
    "password":"test",
    "rememberMe":false
}
```

Sonuç:

```text
```


### parseJson 7

```json
```

```rest
GET http://test/now HTTP/1.1
```

Sonuç:

```text
```


### parseJson 8

```json
```

```rest
GET http://test/now HTTP/1.1
```

Sonuç:

```text
```

### JWT Eklentisiyle Token Üretmek

```json
{
  "id": "119dd039-6968-363d-b6c8-5b9123b85b0d",
  "request": {
    "url": "/jwt-auth",
    "method": "POST",

    "bodyPatterns": [
      {
        "equalToJson": "{\"username\":\"user@company.com\",\"password\":\"sifre123\",\"captcha\":\"MBi8b\",\"rememberMe\":false}",
        "ignoreArrayOrder": true,
        "ignoreExtraElements": true
      }
    ]
  },
  "response": {
    "status": 200,
    "body": "{\"token\": \"{{{jwt maxAge='1 hours' jti='parameters.jti' sub='parameters.username' resourceName='Portal Project'}}}\" }",
    "transformers": ["response-template"],
    "transformerParameters": {
      "uid": 311,
      "oid": 282,
      "username": "user@company.com",
      "jti": "9c52d2d2-a6c2-4e71-bb5d-05bb7c287206"
    },
    "headers": {
      "Server": "nginx",
      "X-Iinfo": "54-143178181-143173302 PNYN RT(1756794036749 17) q(0 0 0 -1) r(2 2) U24",
      "Access-Control-Allow-Methods": "GET, HEAD",
      "X-Content-Type-Options": "nosniff",
      "Access-Control-Allow-Headers": "Msisdn, apiKey",
      "Date": "{{now format='EEE, dd MMM yyyy HH:mm:ss' timezone='GMT'}} GMT",
      "X-Frame-Options": "SAMEORIGIN",
      "Access-Control-Expose-Headers": "Origin",
      "Strict-Transport-Security": "max-age=31536000; includeSubdomains; preload",
      "X-CDN": "Imperva",
      "Access-Control-Allow-Credentials": "true",
      "Content-Security-Policy": [
        "default-src 'self' 'unsafe-eval' 'unsafe-inline' blob:; connect-src 'self' blob:  https://notify.dcbprotect.com http://notify.dcbprotect.com; img-src 'self' data: blob:;",
        "default-src 'self' http://telecel-test.telenity.com https://telecel-test.telenity.com; connect-src 'self' http://telecel-test.telenity.com https://telecel-test.telenity.com http://sdptest.telecel.com.gh https://sdptest.telecel.com.gh; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://sdptest.telecel.com.gh http://telecel-test.telenity.com; img-src 'self' data: blob: http://telecel-test.telenity.com https://telecel-test.telenity.com http://sdptest.telecel.com.gh https://sdptest.telecel.com.gh; style-src 'self' 'unsafe-inline' http://sdptest.telecel.com.gh https://sdptest.telecel.com.gh; font-src 'self' http://sdptest.telecel.com.gh https://sdptest.telecel.com.gh; frame-src http://sdptest.telecel.com.gh https://sdptest.telecel.com.gh; object-src 'self' blob: data: http://telecel-test.telenity.com https://telecel-test.telenity.com http://sdptest.telecel.com.gh https://sdptest.telecel.com.gh"
      ],
      "X-XSS-Protection": "1; mode=block",
      "X-Powered-By": "Express",
      "Content-Type": "application/json"
    }
  },
  "uuid": "119dd039-6968-363d-b6c8-5b9123b85b0d"
}
```

```rest
POST http://test/jwt-auth HTTP/1.1

{
    "username":"user@company.com",
    "password":"sifre123",
    "captcha":"MBi8b",
    "rememberMe":false
}
```

Sonuç:

```text
HTTP/1.1 200 OK
Connection: close
Server: nginx
X-Iinfo: 54-143178181-143173302 PNYN RT(1756794036749 17) q(0 0 0 -1) r(2 2) U24
Access-Control-Allow-Methods: GET, HEAD
X-Content-Type-Options: nosniff
Access-Control-Allow-Headers: Msisdn, apiKey
Date: Fri, 12 Sep 2025 01:26:26 GMT
X-Frame-Options: SAMEORIGIN
Access-Control-Expose-Headers: Origin
Strict-Transport-Security: max-age=31536000; includeSubdomains; preload
X-CDN: Imperva
Access-Control-Allow-Credentials: true
Content-Security-Policy: default-src 'self' 'unsafe-eval' 'unsafe-inline' blob:; connect-src 'self' blob:  https://notify.dcbprotect.com http://notify.dcbprotect.com; img-src 'self' data: blob:;, default-src 'self' http://telecel-test.telenity.com https://telecel-test.telenity.com; connect-src 'self' http://telecel-test.telenity.com https://telecel-test.telenity.com http://sdptest.telecel.com.gh https://sdptest.telecel.com.gh; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://sdptest.telecel.com.gh http://telecel-test.telenity.com; img-src 'self' data: blob: http://telecel-test.telenity.com https://telecel-test.telenity.com http://sdptest.telecel.com.gh https://sdptest.telecel.com.gh; style-src 'self' 'unsafe-inline' http://sdptest.telecel.com.gh https://sdptest.telecel.com.gh; font-src 'self' http://sdptest.telecel.com.gh https://sdptest.telecel.com.gh; frame-src http://sdptest.telecel.com.gh https://sdptest.telecel.com.gh; object-src 'self' blob: data: http://telecel-test.telenity.com https://telecel-test.telenity.com http://sdptest.telecel.com.gh https://sdptest.telecel.com.gh
X-XSS-Protection: 1; mode=block
X-Powered-By: Express
Content-Type: application/json
Matched-Stub-Id: 119dd039-6968-363d-b6c8-5b9123b85b0d

{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NTc2NDM5ODYsImlhdCI6MTc1NzY0MDM4NiwiaXNzIjoid2lyZW1vY2siLCJhdWQiOiJ3aXJlbW9jay5pbyIsInN1YiI6InBhcmFtZXRlcnMudXNlcm5hbWUiLCJtYXhBZ2UiOiIxIGhvdXJzIiwianRpIjoicGFyYW1ldGVycy5qdGkiLCJyZXNvdXJjZU5hbWUiOiJQb3J0YWwgUHJvamVjdCJ9.rbegJtG-NlQ5CunT305h4nVJ7Dtxt4pNWdmMnhPiyvE"
}
```


### JWT Eklentisiyle Token Üretmek

```json
{
  "id": "119dd039-6968-363d-b6c8-5b9123b85b0d",
  "request": {
    "url": "/jwt-auth",
    "method": "POST",

    "bodyPatterns": [
      {
        "equalToJson": "{\"username\":\"user@company.com\",\"password\":\"sifre123\",\"captcha\":\"MBi8b\",\"rememberMe\":false}",
        "ignoreArrayOrder": true,
        "ignoreExtraElements": true
      }
    ]
  },
  "response": {
    "status": 200,
    "body": "{\"token\": \"{{{jwt maxAge='1 hours' jti='parameters.jti' sub='parameters.username' resourceName='Portal Project'}}}\" }",
    "transformers": ["response-template"],
    "transformerParameters": {
      "uid": 311,
      "oid": 282,
      "username": "user@company.com",
      "jti": "9c52d2d2-a6c2-4e71-bb5d-05bb7c287206"
    },
    "headers": {
      "Server": "nginx",
      "X-Iinfo": "54-143178181-143173302 PNYN RT(1756794036749 17) q(0 0 0 -1) r(2 2) U24",
      "Access-Control-Allow-Methods": "GET, HEAD",
      "X-Content-Type-Options": "nosniff",
      "Access-Control-Allow-Headers": "Msisdn, apiKey",
      "Date": "{{now format='EEE, dd MMM yyyy HH:mm:ss' timezone='GMT'}} GMT",
      "X-Frame-Options": "SAMEORIGIN",
      "Access-Control-Expose-Headers": "Origin",
      "Strict-Transport-Security": "max-age=31536000; includeSubdomains; preload",
      "X-CDN": "Imperva",
      "Access-Control-Allow-Credentials": "true",
      "Content-Security-Policy": [
        "default-src 'self' 'unsafe-eval' 'unsafe-inline' blob:; connect-src 'self' blob:  https://notify.dcbprotect.com http://notify.dcbprotect.com; img-src 'self' data: blob:;",
        "default-src 'self' http://telecel-test.telenity.com https://telecel-test.telenity.com; connect-src 'self' http://telecel-test.telenity.com https://telecel-test.telenity.com http://sdptest.telecel.com.gh https://sdptest.telecel.com.gh; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://sdptest.telecel.com.gh http://telecel-test.telenity.com; img-src 'self' data: blob: http://telecel-test.telenity.com https://telecel-test.telenity.com http://sdptest.telecel.com.gh https://sdptest.telecel.com.gh; style-src 'self' 'unsafe-inline' http://sdptest.telecel.com.gh https://sdptest.telecel.com.gh; font-src 'self' http://sdptest.telecel.com.gh https://sdptest.telecel.com.gh; frame-src http://sdptest.telecel.com.gh https://sdptest.telecel.com.gh; object-src 'self' blob: data: http://telecel-test.telenity.com https://telecel-test.telenity.com http://sdptest.telecel.com.gh https://sdptest.telecel.com.gh"
      ],
      "X-XSS-Protection": "1; mode=block",
      "X-Powered-By": "Express",
      "Content-Type": "application/json"
    }
  },
  "uuid": "119dd039-6968-363d-b6c8-5b9123b85b0d"
}
```

```rest
POST http://test/parsejson-assign-base64-post HTTP/1.1

{
    "username":"user@company.com",
    "password":"sifre123",
    "captcha":"MBi8b",
    "rememberMe":false
}
```

Sonuç:

```text
HTTP/1.1 200 OK
Connection: close
Server: nginx
X-Iinfo: 54-143178181-143173302 PNYN RT(1756794036749 17) q(0 0 0 -1) r(2 2) U24
Access-Control-Allow-Methods: GET, HEAD
X-Content-Type-Options: nosniff
Access-Control-Allow-Headers: Msisdn, apiKey
Date: Fri, 12 Sep 2025 01:33:18 GMT
X-Frame-Options: SAMEORIGIN
Access-Control-Expose-Headers: Origin
Strict-Transport-Security: max-age=31536000; includeSubdomains; preload
X-CDN: Imperva
Access-Control-Allow-Credentials: true
Content-Security-Policy: default-src 'self' 'unsafe-eval' 'unsafe-inline' blob:; connect-src 'self' blob:  https://notify.dcbprotect.com http://notify.dcbprotect.com; img-src 'self' data: blob:;, default-src 'self' http://telecel-test.telenity.com https://telecel-test.telenity.com; connect-src 'self' http://telecel-test.telenity.com https://telecel-test.telenity.com http://sdptest.telecel.com.gh https://sdptest.telecel.com.gh; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://sdptest.telecel.com.gh http://telecel-test.telenity.com; img-src 'self' data: blob: http://telecel-test.telenity.com https://telecel-test.telenity.com http://sdptest.telecel.com.gh https://sdptest.telecel.com.gh; style-src 'self' 'unsafe-inline' http://sdptest.telecel.com.gh https://sdptest.telecel.com.gh; font-src 'self' http://sdptest.telecel.com.gh https://sdptest.telecel.com.gh; frame-src http://sdptest.telecel.com.gh https://sdptest.telecel.com.gh; object-src 'self' blob: data: http://telecel-test.telenity.com https://telecel-test.telenity.com http://sdptest.telecel.com.gh https://sdptest.telecel.com.gh
X-XSS-Protection: 1; mode=block
X-Powered-By: Express
Content-Type: application/json
Matched-Stub-Id: 96d6874b-5fba-4b30-9918-aaff2b310232

{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.ewogICJzdWIiOiB7CiAgImNtcGZUb2tlbiIgOiB7CiAgICAiaGFzaCIgOiAiNmJmYTI0OWYiLAogICAgInRva2VuIiA6ICI5NWNlMzFhNSIsCiAgICAidWlkIiA6IDMxMSwKICAgICJvaWQiIDogMjgyCiAgfSwKICAidXNlcm5hbWUiIDogInVzZXJAY29tcGFueS5jb20iCn0sCiAgImp0aSI6ICIiLAogICJyZXNvdXJjZU5hbWUiOiAiUG9ydGFsIFByb2plY3QiLAogICJpYXQiOiAxNzU3NjQwNzk4MzExLAogICJleHAiOiAxNzU3NjQ0Mzk4MzEzCn0.hefveqzyp0ar53cppfwxffs944imumkxy6xdbfeldgf",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.ewogICJzdWIiOiB7CiAgImNtcGZUb2tlbiIgOiB7CiAgICAiaGFzaCIgOiAiNmJmYTI0OWYiLAogICAgInRva2VuIiA6ICI5NWNlMzFhNSIsCiAgICAidWlkIiA6IDMxMSwKICAgICJvaWQiIDogMjgyCiAgfSwKICAidXNlcm5hbWUiIDogInVzZXJAY29tcGFueS5jb20iCn0sCiAgImp0aSI6ICIiLAogICJyZXNvdXJjZU5hbWUiOiAiUG9ydGFsIFByb2plY3QiLAogICJpYXQiOiAxNzU3NjQwNzk4MzE0LAogICJleHAiOiAxNzU3NjQ0Mzk4MzE0LAogICJuYmYiOiAxNzU3NjQzNzk4MzE0LAogICJyZWZyZXNoT25seSI6IHRydWUKfQ.hefveqzyp0ar53cppfwxffs944imumkxy6xdbfeldgf"
}
```


