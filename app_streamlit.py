# app_streamlit.py
import streamlit as st
import requests
from PIL import Image
import io

st.title("EasyOCR upload demo")

uploaded = st.file_uploader("Upload an image", type=["png","jpg","jpeg","pdf"])
if uploaded:
    if uploaded.type == "application/pdf":
        st.warning("PDFs not handled in this simple demo. Convert to images first.")
    else:
        img = Image.open(uploaded)
        st.image(img, caption="Uploaded image", use_column_width=True)
        if st.button("Send to local FastAPI /ocr"):
            files = {"file": ("img.jpg", uploaded.getvalue(), uploaded.type)}
            resp = requests.post("http://localhost:8000/ocr", files=files)
            if resp.ok:
                st.json(resp.json())
            else:
                st.error(f"OCR failed: {resp.status_code}")
