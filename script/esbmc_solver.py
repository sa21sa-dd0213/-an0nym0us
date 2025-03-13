import os
import subprocess
import sys
import re

"""
esbmc_solver.py

This script runs ESBMC to analyze Solidity smart contracts for vulnerabilities. It first ensures 
that the corresponding .solast file exists by calling `get_sol_ast()`. Then, it executes `esbmc`
with specific verification options based on the vulnerability type, such as division by zero, 
overflow, underflow, out-of-bounds access, and assertion violations.

### Counterexample Extraction:
The script detects counterexamples using ESBMC's output format, starting from:
    
    [Counterexample]
    
Example ESBMC output:
    
    [Counterexample]

    State 2 file example.sol line 35 function t thread 0
    ----------------------------------------------------
    Violated property:
      file example.sol line 35 function t
      division by zero   (GPT: we need to extract this as the vulnerability_type)
      y != 0

    VERIFICATION FAILED

The script extracts counterexamples by searching for `[Counterexample]` as the starting point 
and stopping at `VERIFICATION FAILED`.

### Vulnerability Type Extraction:
The vulnerability type is determined based on specific messages in ESBMC's output:

| ESBMC Message         | Mapped Vulnerability Type |
|-----------------------|-------------------------|
| "division by zero"    | divByZero               |
| "dereference failure" | outOfBounds             |
| "assertion"           | assert or reentrancy    |
| '!overflow("-"'       | underflow               |
| '!overflow("+"'       | overflow                |

If an assertion violation is detected and the counterexample contains `"reentrant call"`, 
the script reclassifies the violation as `"Reentrancy"`.

### ESBMC Command Execution:
The script runs ESBMC with different configurations based on the vulnerability type:

- **Division by Zero:** `--overflow-check --no-bounds-check --no-pointer-check`
- **Out of Bounds:** `--overflow-check --no-div-by-zero`
- **Overflow/Underflow:** `--overflow-check --unsigned-overflow-check --no-bounds-check --no-div-by-zero --no-pointer-check`
- **Assertion Violation:** `--no-standard-check`

If no counterexample is found, the script exits, indicating that no exploitable vulnerability was detected.
"""

def get_sol_ast(file):
    """
    Checks if the corresponding .solast file exists for ESBMC.
    If missing or outdated, generates it using 'solc --ast-compact-json'.
    Always overwrites the existing AST file to reflect the latest Solidity changes.
    """
    if not file.endswith(".sol"):
        print("❌ Error: The input file must be a Solidity (.sol) file.")
        exit(1)

    ast_file = file + "ast"  # Expected AST file name (example.sol → example.solast)

    # **Step 1: If AST file exists and is a file, delete it to ensure freshness**
    if os.path.exists(ast_file) and os.path.isfile(ast_file):
        print(f"⚠️ Existing AST file found: {ast_file} → Overwriting...")
        os.remove(ast_file)

    # **Step 2: Generate AST and correctly write to file**
    command = ["solc", "--ast-compact-json", file]
    
    try:
        print(f"🔍 Running command: {' '.join(command)}")
        result = subprocess.run(command, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

        # **Write the AST output to a file**
        with open(ast_file, "w", encoding="utf-8") as f:
            f.write(result.stdout)

        print(f"✅ New AST file generated: {ast_file}")

    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to generate AST: {e.stderr}")
        exit(1)

    return ast_file


def check_compile(file):
    """
    Checks if the corresponding .solast file exists for ESBMC.
    If missing or outdated, generates it using 'solc --ast-compact-json'.
    Always overwrites the existing AST file to reflect the latest Solidity changes.
    """
    print("🔍 Checking compilation...")
    
    if not file.endswith(".sol"):
        print("❌ Error: The input file must be a Solidity (.sol) file.")
        exit(1)

    ast_file = file + "ast"  # Expected AST file name (example.sol → example.solast)

    # **Step 1: If AST file exists and is a file, delete it to ensure freshness**
    if os.path.exists(ast_file) and os.path.isfile(ast_file):
        print(f"⚠️ Existing AST file found: {ast_file} → Overwriting...")
        os.remove(ast_file)

    # **Step 2: Generate AST and correctly write to file**
    command = ["solc", "--ast-compact-json", file]
    
    try:
        print(f"🔍 Running command: {' '.join(command)}")
        result = subprocess.run(command, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

        # **Write the AST output to a file**
        with open(ast_file, "w", encoding="utf-8") as f:
            f.write(result.stdout)

        print(f"✅ New AST file generated: {ast_file}")

    except subprocess.CalledProcessError as e:
        # print(f"❌ Failed to generate AST: {e.stderr}")
        return False, e.stderr

    return True, None

def esbmc_solving(args, file, label, timeout, is_bccv, extra_options=None):
    """
    Runs ESBMC on the Solidity file to detect vulnerabilities.
    - Tries `--k-induction`
    - If no counterexample is found, retries with `--incremental-bmc`
    - Returns the extracted counterexample and identified vulnerability type
    """
    print("🔍 Running ESBMC verification...")

    # Ensure the AST file exists
    get_sol_ast(file)

    # Base command
    base_command = [
        "esbmc",
        "--sol",
        file,
        file + "ast",
        "--base-k-step",
        "2",
        "--k-step",
        "2",
    ]

    if args.function:
        base_command.extend([f"--function {args.function}"])

    if not is_bccv and args.contract:
        base_command.extend([f"--contract {args.contract}"])

    if args.addition:
        base_command.extend([f"{args.addition}"])

    label_properties = {
        "DV": ["--overflow-check", "--no-bounds-check", "--no-pointer-check"],
        "OB": ["--overflow-check", "--no-div-by-zero"],
        "AO": ["--overflow-check", "--unsigned-overflow-check", "--no-bounds-check", "--no-div-by-zero", "--no-pointer-check"],
        "AU": ["--overflow-check", "--unsigned-overflow-check", "--no-bounds-check", "--no-div-by-zero", "--no-pointer-check"],
        "AS": ["--no-standard-check"],
        "RE": ["--no-standard-check"]
    }

    if label in label_properties:
        base_command.extend(label_properties[label])

    # **Add extra options if provided**
    if extra_options:
        base_command.extend(extra_options)

    print(f"🛠 Running ESBMC with command: {' '.join(base_command)}")

    result = run_esbmc(base_command + ["--k-induction"], timeout)
    if "Counterexample" in result:
        print("✅ Counterexample found using K-Induction!")
        return extract_esbmc_output(result, label)

    print("⚠️ No counterexample found with K-Induction. Trying Incremental-BMC...")

    result = run_esbmc(base_command + ["--incremental-bmc"], timeout)
    if "Counterexample" in result:
        print("✅ Counterexample found using Incremental-BMC!")
        return extract_esbmc_output(result, label)

    print("❌ No counterexample found in both methods.")
    return "", ""


def run_esbmc(command, timeout):
    """Runs an ESBMC command and returns the output."""
    try:
        result = subprocess.run(
            command,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            timeout=timeout,
        )
        return result.stdout + result.stderr
    except subprocess.TimeoutExpired:
        print(f"⚠️ ESBMC timed out after {timeout} seconds.")
        return ""


def extract_esbmc_output(output_text, label=None):
    """
    Extracts the counterexample while preserving ESBMC's original formatting.
    """

    vulnerability_map = {
        "division by zero": "divByZero",
        "dereference failure": "outOfBounds",
        "assertion": "assert",
        '!overflow("-"': "underflow",
        '!overflow("+"': "overflow",
    }

    counterexample_lines = []
    vulnerability_type = None
    collecting = False
    found_violation = False
    verification_failed_count = 0  # Ensure "VERIFICATION FAILED" appears only once

    lines = output_text.splitlines(keepends=True)  # Preserve original newlines & spaces

    for i, line in enumerate(lines):
        # **Step 1: Detect start of counterexample**
        if "[Counterexample]" in line and not collecting:
            collecting = True
            counterexample_lines.append(line)  # Preserve header
            continue

        # **Step 2: Detect violation type (only first occurrence)**
        if "Violated property:" in line and not found_violation:
            counterexample_lines.append(line)  # Preserve this message
            found_violation = True
            continue

        # **Step 3: Extract exact vulnerability type**
        for keyword, mapped_type in vulnerability_map.items():
            if keyword in line.lower():
                vulnerability_type = mapped_type
                print(
                    f"🛑 Violation detected: {line.strip()} (Mapped: {vulnerability_type})"
                )

        # **Step 4: Capture full counterexample (DO NOT strip tabs or spaces)**
        if collecting:
            counterexample_lines.append(line)  # Append line as-is

        # **Step 5: Stop collecting at first "VERIFICATION FAILED"**
        if "VERIFICATION FAILED" in line:
            break  # Stop processing further lines

    # **Step 6: Remove unwanted "Bug found (k = X)"**
    counterexample_str = "".join(counterexample_lines)
    counterexample_str = re.sub(
        r"\nBug found \(k = \d+\)", "", counterexample_str
    ).strip()

    # **Step 7: Differentiate Assertion Violation vs Reentrancy**
    if (
        vulnerability_type == "assert"
        and "reentrant call" in counterexample_str.lower()
    ):
        vulnerability_type = "reentrancy"
        print("🔍 Detected reentrant call → Reclassifying as 'Reentrancy'")

    # **Step 8: Ensure valid output, else exit**
    if not counterexample_str or not found_violation:
        print("❌ No exploitable counterexample found.")
        sys.exit(1)

    print(f"✅ Extracted Counterexample:\n{counterexample_str}")
    return counterexample_str, vulnerability_type
