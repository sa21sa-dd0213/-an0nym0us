import subprocess
import sys
import re

"""
smtchecker_solving.py

This script runs SMTChecker to analyze Solidity smart contracts for vulnerabilities. It first 
executes `solc` with the CHC (Craig Interpolation) engine, and if no counterexample is found, 
it falls back to the BMC (Bounded Model Checking) engine. The script extracts counterexamples 
related to overflow, underflow, division by zero, out-of-bounds access, assertion violations, 
and reentrancy.

### Counterexample Extraction:
The script detects counterexamples using SMTChecker warnings in the following format:

    Warning: CHC: Overflow (resulting value larger than 2**256 - 1) happens here.
    Counterexample:
    x = 1, y = 115792089237316195423570985008687907853269984665640564039457584007913129639935
     = 0

    Transaction trace:
    Overflow.constructor(1, ...)
    State: x = 1, y = ...
    Overflow.stateAdd()
        Overflow.add(1, ...) -- internal call

The script identifies warnings matching:
    Warning: (CHC|BMC): <Violation Type> (...details...) happens here.
It then captures all lines until the next warning, ensuring the full counterexample is retained.

### Reentrancy Detection:
If the violation type is "Assertion Violation" and the transaction trace contains "reentrant call",
the violation is reclassified as "Reentrancy".

If no counterexample is found, the script exits, indicating that no exploitable vulnerability was detected.
"""


# return counterexample_str, current_violation
def smtchecker_solving(args, file, label, timeout, is_bccv, extra_options=None):
    """Runs SMTChecker (CHC → BMC fallback) and extracts counterexamples."""
    print("🔍 Running SMTChecker verification...")

    label_map = {
        "AO": "overflow",
        "AU": "underflow",
        "DV": "divByZero",
        "OB": "outOfBounds",
        "AS": "assert",
        "RE": "assert",
    }

    property_check = label_map.get(label, "default")

    # avoid compilation error
    if is_bccv:
        try:
            # Step 1: Read all lines
            with open(file, "r", encoding="utf-8") as f:
                lines = f.readlines()

            # Step 2: Overwrite file with filtered lines
            with open(file, "w", encoding="utf-8") as f:
                for line in lines:
                    if not re.match(
                        r"^\s*pragma\s+solidity\s+[^;]+;", line
                    ) and not re.match(r"^\s*import\s+[^;]+;", line):
                        f.write(line)
            # print("⚠️ Removed pragma and import lines for BCCV run.")
        except Exception as e:
            print(f"❌ Error while cleaning Solidity file for BCCV: {e}")

    if is_bccv:
        l = ["chc"]
    else:
        l = ["chc", "bmc"]

    for engine in l:
        print(f"🛠 Running SMTChecker with {engine.upper()} engine...")
        command = [
            "solc",
            f"--model-checker-engine={engine}",
            f"--model-checker-targets={property_check}",
            file,
        ]

        # **Add extra options if provided**
        if extra_options:
            command.extend(extra_options)

        # bccv requires more resource, so we set up timeout
        if is_bccv:
            command.extend(["--model-checker-timeout=120"])

        if args.addition:
            command.extend([f"{args.addition}"])

        print(f"🔹 Executing command: {' '.join(command)}")

        try:
            result = subprocess.run(
                command,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                timeout=timeout,
            )
            if "Counterexample" in result.stdout or re.search(
                r"Warning: (?:CHC|BMC): (.+?) happens here\.", result.stdout
            ):
                print("✅ Counterexample found!")
                return extract_smtchecker_output(result.stdout, label)
            elif "Counterexample" in result.stderr or re.search(
                r"Warning: (?:CHC|BMC): (.+?) happens here\.", result.stderr
            ):
                print("✅ Counterexample found!")
                return extract_smtchecker_output(result.stderr, label)
        except subprocess.TimeoutExpired:
            print(f"⚠️ SMTChecker timed out after {timeout} seconds.")
            return "", ""

    print("❌ No counterexample found.")
    return "", ""


def extract_smtchecker_output(output_text, label=None):
    """Extracts the counterexample and violation type from SMTChecker output."""
    violation_map = {
        "Overflow": "overflow",
        "Underflow": "underflow",
        "Division by zero": "divByZero",
        "Assertion violation": "assert",
        "Out of bounds array": "outOfBounds",
        "Fixed bytes index access": "outOfBounds",
    }

    expected_violation = {
        "AO": "overflow",
        "AU": "underflow",
        "DV": "divByZero",
        "OB": "outOfBounds",
        "AS": "assert",
        "RE": "reentrancy",
    }.get(label)

    counterexample = []
    current_violation = None
    collecting = False
    found_violation = False

    lines = output_text.split("\n")

    for i, line in enumerate(lines):
        # **Step 1: Detect Violation Type**
        match = re.search(
            r"Warning: (?:CHC|BMC): (.+?) happens here\.", line, re.IGNORECASE
        )
        if match:
            detected_violation_text = match.group(1).strip()
            detected_violation = violation_map.get(detected_violation_text, "all")

            print(
                f"🛑 Violation detected: {detected_violation_text} (Mapped: {detected_violation})"
            )

            # **Step 2: Check if it's an assertion violation BEFORE skipping**
            if detected_violation == "assert":
                counterexample_str = "\n".join(
                    lines[i:]
                )  # Capture all output after detection

                if "reentrant call" in counterexample_str.lower():
                    detected_violation = "reentrancy"
                    print("🔍 Detected reentrant call → Reclassifying as 'Reentrancy'")

            # **Step 3: Start Collecting Counterexample**
            collecting = True
            current_violation = detected_violation
            found_violation = True
            counterexample.clear()

            # simplification **Keep the line but remove "Warning: {}: "** to save token
            # not need to send to llm
            counterexample.append(
                re.sub(r"Warning: (?:BMC|CHC): ", "", line, flags=re.IGNORECASE)
            )
            continue

        if collecting:
            if "Warning: " in lines:  # Stop collecting at next warning
                break
            if "Note that" in line:  # Stop collecting once we reach "Note that"
                break

            counterexample.append(line.strip())  # Keep everything else

    counterexample_str = "\n".join(counterexample).strip()

    # **Step 4: Ensure Violation is Correctly Mapped Before Filtering**
    if current_violation == "default":
        print("⚠️ Violation could not be classified. Skipping.")
        return "", ""

    # **Step 5: Skip if Violation Doesn't Match Expected Label**
    if expected_violation and expected_violation != current_violation:
        print(
            f"⚠️ Skipping violation '{current_violation}' (does not match '{expected_violation}')"
        )
        return "", ""  # Return empty if it doesn't match the expected label

    if not found_violation or not counterexample_str:
        print("❌ No exploitable counterexample found.")
        return "", ""

    print(f"✅ Extracted Counterexample:\n{counterexample_str}")
    return counterexample_str, current_violation
