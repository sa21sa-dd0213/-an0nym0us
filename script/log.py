import os

TEMP_FILE = "temporary.sol"
REPRODUCTION_FILE = "Reproduction.sol"


def cleanup_temp_files():
    """
    Deletes temporary files created during validation.
    """
    files_to_remove = [TEMP_FILE, TEMP_FILE + "ast"]

    for file in files_to_remove:
        if os.path.exists(file):
            os.remove(file)
            print(f"🗑 Deleted temporary file: {file}")


def cleanup_temp_files():
    """Deletes temporary files used during validation."""
    if os.path.exists(TEMP_FILE):
        os.remove(TEMP_FILE)
        print(f"🗑 Deleted temporary file: {TEMP_FILE}")

    ast_file = TEMP_FILE + "ast"
    if os.path.exists(ast_file):
        os.remove(ast_file)
        print(f"🗑 Deleted AST file: {ast_file}")

    ast_file = REPRODUCTION_FILE + "ast"
    if os.path.exists(ast_file):
        os.remove(ast_file)
        print(f"🗑 Deleted AST file: {ast_file}")


def save_reflection_log(reflect_memory):
    """Saves the accumulated reflection memory to a file."""
    print("✅ Saves the accumulated reflection prompt history to a file")
    with open("reflection.txt", "w", encoding="utf-8") as f:
        f.write("\n".join(reflect_memory))
    print("📄 Reflection logs saved to reflection.txt")


def cleanup_failed_reproduction():
    """
    Deletes `Reproduction.sol` and its AST file if self-reflection fails after max attempts.
    """
    if os.path.exists(REPRODUCTION_FILE):
        os.remove(REPRODUCTION_FILE)
        print(f"🗑 Deleted incorrect reproduction contract: {REPRODUCTION_FILE}")

    ast_file = REPRODUCTION_FILE + "ast"
    if os.path.exists(ast_file):
        os.remove(ast_file)
        print(f"🗑 Deleted outdated AST file: {ast_file}")
