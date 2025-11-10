# test_easyocr.py
import easyocr
import time



reader = easyocr.Reader(['en'], gpu=False)   # set gpu=True if you installed GPU torch
#print("EasyOCR reader loaded. Languages:", reader.lang_list)
t1 = time.time()
res = reader.readtext('test_img.jpg')    # replace with a real small image path
print("Found", len(res), "text boxes")
for bbox, text, conf in res:
    print(text, conf)
print(f'Time taken in process is {time.time()-t1}')