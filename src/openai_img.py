from funix import funix
from IPython.display import Image
from openai import OpenAI

client = OpenAI()

@funix()
def dalle(prompt: str = "a cat") -> Image:
    response = client.images.generate(prompt=prompt)
    return response.data[0].url
