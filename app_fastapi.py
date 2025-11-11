# app_fastapi.py
from fastapi import FastAPI, File, UploadFile
import easyocr
import numpy as np
from PIL import Image
import io

app = FastAPI()
reader = easyocr.Reader(['en'], gpu=False)

@app.post("/ocr")
async def ocr_upload(file: UploadFile = File(...)):
    data = await file.read()
    img = Image.open(io.BytesIO(data)).convert('RGB')
    arr = np.array(img)
    results = reader.readtext(arr)
    lines = [{"text": r[1], "conf": float(r[2])} for r in results]
    return {"lines": lines}
