import google.generativeai as genai
import os
from IPython.display import Markdown

gemini_api_key = os.environ["GEMINI_API_KEY"]
genai.configure(api_key = gemini_api_key)

model = genai.GenerativeModel('gemini-pro')
response = model.generate_content("Who is the GOAT in the NBA") 
Markdown(response)
print(response)
