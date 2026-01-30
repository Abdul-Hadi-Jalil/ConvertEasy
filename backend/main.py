from fastapi import FastAPI
from pydantic import BaseModel
from fastapi import UploadFile
from fastapi.responses import FileResponse
from spire.doc import Document
from spire.doc import FileFormat
import tempfile
import os

app = FastAPI()

@app.post("/word_to_pdf")
async def word_to_pdf(file: UploadFile):
    # Get original filename without extension
    original_name = file.filename.rsplit('.', 1)[0]  # "document.docx" → "document"
    
    temp_dir = tempfile.gettempdir()
    input_path = os.path.join(temp_dir, file.filename)
    
    content = await file.read()
    with open(input_path, "wb") as f:
        f.write(content)
    
    output_path = input_path.replace(".docx", ".pdf").replace(".doc", ".pdf")
    
    document = Document()
    document.LoadFromFile(input_path)
    document.SaveToFile(output_path, FileFormat.PDF)
    document.Close()
    
    # Return with original name
    return FileResponse(
        path=output_path,
        filename=f"{original_name}.pdf",  # Same name as original
        media_type="application/pdf"
    )