# OpenAI image editing interface (gpt-image-1)

**Request method:**`POST`  
**Interface address:**`https://api.wukong.support/v1/images/edits`  
**Official Documentation:**[OpenAI API Reference](https://platform.openai.com/docs/api-reference/images/createEdit)  

---

### 1. Request parameters

#### 1. Header parameters

| Parameter name| Type| Is it necessary| Example value| Description|
| -------------- | ------- | -------- | ----------------------- | ------------------------ |
| Authorization  | string  | ✅       | Bearer {{YOUR_API_KEY}} | API key, need to be prefixed with Bearer|

#### 2. Body parameter (`multipart/form-data`）

| Parameter name| Type| Is it necessary| Description|
| -------------- | --------------------- | -------- | ------------------------------------------------------------ |
| image          | file or file array| ✅       | The pictures to be edited support PNG, WEBP, and JPG formats, each<25MB。         |
| prompt         | string                | ✅       | A description of the desired image.<br>gpt-image-1: Maximum length 32000 characters.             |
| mask           | file                  | Optional| PNG mask image, the transparent area (alpha=0) represents the area to be edited, and must be consistent with the image size.<4MB. Only valid for the first image. |
| model          | string                | Optional| Model used:`dall-e-2` or`gpt-image-1`。<br>Default`dall-e-2`, if the unique parameters of gpt-image-1 are used, it will be automatically switched. |
| n              | integer or null| Optional| Number of generated images, 1~10, default 1.                                   |
| quality        | string or null| Optional| gpt-image-1 specific:`high`、`medium`、`low`, default`auto`。        |
| response_format| string or null| Optional| Return format:`url` or`b64_json`. Only supported by dall-e-2`url`。          |
| size           | string or null| Optional| Image size:<ul><li>gpt-image-1: "1024x1024", "1536x1024", "1024x1536", "auto" (default)</li><li>dall-e-2: "256x256", "512x512", "1024x1024"</li></ul> |

---

### 2. Parameter examples

#### Header

```http
Authorization: Bearer {{YOUR_API_KEY}}
```

#### Body (multipart/form-data)

| parameters| Example value|
| ------ | ----------------------------------------- |
| image  | E:\Desktop\gpt\icon_samll2.png            |
| prompt | wear glasses|
| model  | gpt-image-1                               |

---

### 3. Sample code (Python Requests)

```python
import http.client
import mimetypes
from codecs import encode

conn = http.client.HTTPSConnection("{{BASE_URL}}")
dataList = []
boundary = 'wL36Yn8afVp8Ag7AmP8qZ0SA4n1v9T'
dataList.append(encode('--' + boundary))
dataList.append(encode('Content-Disposition: form-data; name=image; filename={0}'.format('E:\\\\Desktop\\\\gpt\\\\icon_samll2.png')))

fileType = mimetypes.guess_type('E:\\\\Desktop\\\\gpt\\\\icon_samll2.png')[0] or 'application/octet-stream'
dataList.append(encode('Content-Type: {}'.format(fileType)))
dataList.append(encode(''))

with open('E:\\Desktop\\gpt\\icon_samll2.png', 'rb') as f:
   dataList.append(f.read())
dataList.append(encode('--' + boundary))
dataList.append(encode('Content-Disposition: form-data; name=prompt;'))

dataList.append(encode('Content-Type: {}'.format('text/plain')))
dataList.append(encode(''))

dataList.append(encode("带上眼镜"))
dataList.append(encode('--' + boundary))
dataList.append(encode('Content-Disposition: form-data; name=model;'))

dataList.append(encode('Content-Type: {}'.format('text/plain')))
dataList.append(encode(''))

dataList.append(encode("gpt-image-1"))
dataList.append(encode('--'+boundary+'--'))
dataList.append(encode(''))
body = b'\r\n'.join(dataList)
payload = body
headers = {
   'Authorization': 'Bearer {{YOUR_API_KEY}}',
   'Content-type': 'multipart/form-data; boundary={}'.format(boundary)
}
conn.request("POST", "/v1/images/edits", payload, headers)
res = conn.getresponse()
data = res.read()
print(data.decode("utf-8"))
```

---

### 4. Response examples

**HTTP 200 Success**

```json
{
    "created": 1713833628,
    "data": [
        {
            "b64_json": "..."
        }
    ],
    "usage": {
        "total_tokens": 100,
        "input_tokens": 50,
        "output_tokens": 50,
        "input_tokens_details": {
            "text_tokens": 10,
            "image_tokens": 40
        }
    }
}
```

---

**Description:**
- `b64_json` The field is the base64 encoded image content.
- If selected`response_format` for`url`, then return`url` field, the image is valid for 60 minutes (only supports dall-e-2).
- `usage` Partially displays the Token statistics of this request.

---

For further use or integration, it is recommended to refer to[Official documentation](https://platform.openai.com/docs/api-reference/images/createEdit)。
