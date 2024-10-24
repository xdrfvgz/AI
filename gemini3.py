import google.generativeai as genai
import os
import sys
from IPython.display import Markdown

# Configure the API
gemini_api_key = os.environ["GEMINI_API_KEY"]
genai.configure(api_key=gemini_api_key)

# Create the model and generate content
model = genai.GenerativeModel('gemini-pro')
response = model.generate_content(sys.argv[1])

# Extract the text from the response
response_text = response.text

# If you're in an IPython environment and want to display as Markdown
# Markdown(response_text)

# For regular Python script, just print the text
print(response_text)
