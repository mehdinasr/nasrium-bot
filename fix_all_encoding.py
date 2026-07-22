import os
import shutil
import py_compile

SRC_DIR = "Core/App"
BACKUP_DIR = "Core/App_backup_before_fix"

# 1. Backup everything first (safety net)
if not os.path.exists(BACKUP_DIR):
    shutil.copytree(SRC_DIR, BACKUP_DIR)
    print(f"Backup created at {BACKUP_DIR}")
else:
    print("Backup already exists, skipping backup step.")

fixed = []
unchanged = []
failed = []

for root, dirs, files in os.walk(SRC_DIR):
    for fname in files:
        if not fname.endswith(".py"):
            continue
        path = os.path.join(root, fname)
        try:
            with open(path, "r", encoding="utf-8") as f:
                content = f.read()
        except UnicodeDecodeError as e:
            failed.append((path, f"read error: {e}"))
            continue

        original = content

        # Remove stray BOM anywhere in the text
        content = content.replace("\ufeff", "")

        # Attempt to reverse double-encoding mojibake:
        # take the (incorrectly decoded) text, re-encode as latin-1
        # to recover the original UTF-8 bytes, then decode properly.
        if any(ch in content for ch in ["Ã", "Ø", "Ù", "Â"]):
            try:
                repaired = content.encode("latin-1").decode("utf-8")
                content = repaired
            except (UnicodeDecodeError, UnicodeEncodeError):
                pass  # leave as-is if repair attempt fails

        if content != original:
            with open(path, "w", encoding="utf-8") as f:
                f.write(content)
            fixed.append(path)
        else:
            unchanged.append(path)

# 2. Verify every file still compiles
compile_errors = []
for root, dirs, files in os.walk(SRC_DIR):
    for fname in files:
        if fname.endswith(".py"):
            path = os.path.join(root, fname)
            try:
                py_compile.compile(path, doraise=True)
            except Exception as e:
                compile_errors.append((path, str(e)))

with open("fix_report.txt", "w", encoding="utf-8") as out:
    out.write(f"Fixed (mojibake/BOM repaired): {len(fixed)}\n")
    out.write(f"Unchanged (already clean): {len(unchanged)}\n")
    out.write(f"Read failures: {len(failed)}\n")
    out.write(f"Compile errors remaining: {len(compile_errors)}\n\n")
    if failed:
        out.write("=== READ FAILURES ===\n")
        for p, e in failed:
            out.write(f"{p} -> {e}\n")
        out.write("\n")
    if compile_errors:
        out.write("=== COMPILE ERRORS ===\n")
        for p, e in compile_errors:
            out.write(f"{p} -> {e}\n")
