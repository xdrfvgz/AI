from IPython.display import Markdown

model = genai.GenerativeModel('gemini-pro')
response = model.generate_content("Who is the GOAT in the NBA?")

Markdown(response.text)
 
