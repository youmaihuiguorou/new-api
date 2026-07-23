# **Nano-banana image generation API**

**Interface path**:`POST /v1/images/generations`

**Recommended model**:

`nano-banana`(Optimized based on Gemini-2.5-flash-image-preview)

`nano-banana-pro`(Based on Gemini-3-pro-image-preview optimization)

`nano-banana-2`(Optimized based on Gemini-3.1-flash-image-preview)

**Note: The generated image URL is a temporary link (valid for 2 hours). Please save important works locally. **

---

### **Model comparison**
| Features| `gemini-2.5-flash-image-preview` | `nano-banana`                          | `nano-banana-pro`       |
|---------------------|----------------------------------|----------------------------------------|------------------------|
| **Type**| Official native model| Paint optimized version| Stronger and higher definition version (4K quality)|
| **Support interface**| Chat interface only| Image generation interface| Image generation interface|
| **Return format**| Base64 (may not return images)| URL or Base64| URL or Base64|
| **Picture ratio setting**| ❌ Not supported| ✅ Support| ✅ Support
| **Failed deduction**| ❌ Not stated| ✅ No deductions| ✅ No deductions|
| **Compatible formats**| -                                | Dalle format| Dalle format|

---

### **Request Parameters**
#### **Header**
| Parameter name| Type| required| Default value| Description|
|----------------|--------|------|----------------------|--------------------------|
| `Authorization`| string | Optional| `Bearer {{YOUR_API_KEY}}` | API authentication token|

#### **Body (`application/json`)**
| Parameter name| Type| required| Description|
|-------------------|------------------|------|----------------------------------------------------------------------|
| `model`           | string           | ✅   | Model name (e.g.`nano-banana` or`nano-banana-pro`）                     |
| `prompt`          | string           | ✅   | Image description text|
| `aspect_ratio`    | enum[string]     | ✅   | Image ratio:<br><br> `auto`，`1:1`, `4:3`, `3:4`, `16:9`, `9:16`, `2:3`, `3:2`, `4:5`, `5:4`, `21:9`|
| `response_format`| string           | ❌   | Return format:`url`(default) or`b64_json`                                 |
| `image`      | array[string]    | ❌   | The reference image URL or image Base64 data list entered when generating images.|
| `image_size`      | enum[string]    | ❌   |    Only supported by nano-banana-pro and nano-banana-2, optional values: 1K, 2K, 4K|
| `search`      | enum[boolean]    | ❌   |    Whether to enable the native networking function, only nano-banana-pro and nano-banana-2 support it. Optional values:`true`，`false`|


---

### **Request Example**
#### **JSON Body**
```json
{
    "prompt": "cat",
    "model": "nano-banana",
    "aspect_ratio": "16:9"
}
```

#### **cURL code**
```bash
curl --location --request POST 'https://api.wukong.support/v1/images/generations' \
--header 'Authorization: Bearer {{YOUR_API_KEY}}' \
--header 'Content-Type: application/json' \
--data-raw '{
    "prompt": "cat",
    "model": "nano-banana",
    "aspect_ratio": "16:9"
}'
```

---

### **Response Example**
#### **Successful response (HTTP 200)**
```json
{
    "data": [
        {
            "url": "https://example.com/generated_image.png"
        }
    ]
}
```
- **Format**:`application/json`
- **Return content**: Contains the URL or Base64 data of the generated image (depending on`response_format`）。

---

### **Key Notes**
1. **Optimization Features**
   - `nano-banana` Optimized for image generation, supports scale settings and Dalle format.
   - No fees will be deducted in case of failure, reducing the risk of usage costs.
2. **HD version**
   - `nano-banana-pro`、`nano-banana-2` Supports output of 4K image quality, suitable for scenarios requiring high resolution.
