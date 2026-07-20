import os

with open("app_logic.js", "r", encoding="utf-8") as f:
    content = f.read()

lines = content.split("\n")
chunks = []
current_chunk = []
current_size = 0
depth = 0
target_size = 20000

for line in lines:
    current_chunk.append(line)
    current_size += len(line) + 1
    depth += line.count("{") - line.count("}")
    if depth == 0 and current_size >= target_size:
        chunks.append("\n".join(current_chunk))
        current_chunk = []
        current_size = 0

if current_chunk:
    chunks.append("\n".join(current_chunk))

for i, chunk in enumerate(chunks, start=1):
    with open(f"app_logic_part{i}.js", "w", encoding="utf-8") as f:
        f.write(chunk)

print(f"Split into {len(chunks)} parts:")
for i in range(1, len(chunks) + 1):
    size = os.path.getsize(f"app_logic_part{i}.js")
    print(f"  part{i}: {size} bytes")
