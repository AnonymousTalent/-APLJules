from openai import OpenAI

client = OpenAI()

def translate(text):
    resp = client.chat.completions.create(
        model="gpt-4.1-mini",
        messages=[
            {"role": "system", "content": "Translate to Traditional Chinese, keep technical terms."},
            {"role": "user", "content": text}
        ]
    )
    return resp.choices[0].message.content


if __name__ == "__main__":
    print(translate("Hello world"))