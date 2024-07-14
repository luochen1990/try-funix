from funix import funix                      # add line one
from IPython.display import Image
from openai import OpenAI                    # pip install openai

import os
client = OpenAI(api_key=os.environ.get("OPENAI_KEY"))


@funix()                                     # add line two
def dalle(prompt: str = "a cat") -> Image:
    response = client.images.generate(prompt=prompt)
    return response.data[0].url
