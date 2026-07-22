import os
import py_compile

bad_files = []
for root, dirs, files in os.walk("Core/App"):
    for fname in files:
        if fname.endswith(".py"):
            path = os.path.join(root, fname)
            # Check 1: can it be read as clean UTF-8?
            try:
                with open(path, "r", encoding="utf-8") as f:
                    content = f.read()
                if "\ufeff" in content or "Ã" in content or "Ø" in content:
                    bad_files.append((path, "mojibake/BOM detected"))
            except UnicodeDecodeError as e:
                bad_files.append((path, f"UnicodeDecodeError: {e}"))
            # Check 2: does it compile?
            try:
                py_compile.compile(path, doraise=True)
            except Exception as e:
                bad_files.append((path, f"CompileError: {e}"))

with open("encoding_scan_result.txt", "w", encoding="utf-8") as out:
    out.write(f"Total bad files: {len(set(f[0] for f in bad_files))}\n\n")
    for path, issue in bad_files:
        out.write(f"{path} -> {issue}\n")
