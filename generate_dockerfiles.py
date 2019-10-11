with open('templates/Dockerfile', mode='r', encoding='utf-8') as f:
    text = f.read()

print(text.format(image='ubuntu', tag='18.04'))