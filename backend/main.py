from fastapi import FastAPI, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse
from spire.doc import Document
from spire.doc import FileFormat
import tempfile
import os

app = FastAPI()

# Add CORS middleware - THIS IS CRITICAL
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",      # Flutter web default
        "http://127.0.0.1:3000",      # Flutter web alternative
        "http://localhost:5320",      # Another possible Flutter port
        "http://127.0.0.1:5320",      # Alternative port
        "*"                           # For development only - remove in production
    ],
    allow_credentials=True,
    allow_methods=["*"],              # Allow all HTTP methods
    allow_headers=["*"],              # Allow all headers
    expose_headers=["*"],             # Expose all headers to browser
)

@app.post("/word_to_pdf")
async def word_to_pdf(file: UploadFile):
    # Get original filename without extension
    original_name = file.filename.rsplit('.', 1)[0]  # "document.docx" → "document"
    
    temp_dir = tempfile.gettempdir()
    input_path = os.path.join(temp_dir, file.filename)
    
    # Read file content
    content = await file.read()
    with open(input_path, "wb") as f:
        f.write(content)
    
    # Create output path
    output_path = input_path.replace(".docx", ".pdf").replace(".doc", ".pdf")
    
    # Convert Word to PDF
    document = Document()
    document.LoadFromFile(input_path)
    document.SaveToFile(output_path, FileFormat.PDF)
    document.Close()
    
    # Clean up input file
    if os.path.exists(input_path):
        os.remove(input_path)
    
    # Return PDF file with proper CORS headers
    return FileResponse(
        path=output_path,
        filename=f"{original_name}.pdf",
        media_type="application/pdf",
        headers={
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Expose-Headers": "Content-Disposition"
        }
    )

# Optional: Add a test endpoint to verify CORS is working
@app.get("/test-cors")
async def test_cors():
    return {"message": "CORS is working!", "status": "success"}

# Optional: Health check endpoint
@app.get("/")
async def root():
    return {"message": "Word to PDF Converter API", "status": "running"}