from funix import funix                      # add line one
from IPython.display import Image
from openai import OpenAI                    # pip install openai
import os

# 初始化OpenAI客户端
client = OpenAI()

@funix()                                     # add line two
def dalle(prompt: str = "a cat") -> Image:
    response = client.images.generate(prompt=prompt)
    return response.data[0].url
