from fastapi import FastAPI
from pydantic import BaseModel
from fastapi import UploadFile
from spire.doc import Document
from spire.doc import FileFormat

app = FastAPI()

@app.post("/word_to_pdf")
def word_to_pdf(file: UploadFile):
    name, ext = file.filename.split(".")
    document = Document()
    print(file.filename)
    document.LoadFromFile(file.filename)
    document.SaveToFile(name + ".pdf", fileFormat=FileFormat.PDF)
    document.Close()

    # return the resultant file

    