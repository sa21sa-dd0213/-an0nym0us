import os
import subprocess
from script import smtchecker_solver, esbmc_solver
from script import log

TEMP_FILE = "temporary.sol"
REPRODUCTION_FILE = "Reproduction.sol"


def validate_reproduction_contract(args):
    """
    Validates the generated reproduction contract by:
    1. Checking if `Reproduction.sol` exists.
    2. Merging `args.file` (original contract) with `Reproduction.sol` into `temporary.sol`.
    3. If ESBMC is used, generating the AST.
    4. Running bounded contract verification (BCCV) using SMTChecker or ESBMC.
    5. Cleaning up temporary files.
    6. Returning whether the contract passes validation or not.
    """

    # **Step 1: Check if `Reproduction.sol` exists**
    if not os.path.exists(REPRODUCTION_FILE):
        print(f"❌ Validation failed: `{REPRODUCTION_FILE}` not found.")
        exit(1)

    # **Step 2: Merge original and reproduction contract into `temporary.sol`**
    merge_contracts(args.file, REPRODUCTION_FILE, TEMP_FILE)

    # **Step 3: If using ESBMC, generate AST**
    is_compilable, stderr = esbmc_solver.check_compile(TEMP_FILE)
    if is_compilable == False:
        print("❌ Compilation error detected during AST generation.")
        return stderr

    # **Step 4: Run Bounded Contract Verification (BCCV)**
    counterexample_str = run_bccv(args)

    # **Step 5: Handle BCCV result**
    if not counterexample_str:
        print("❌ No counterexample found. BCCV Validation Failed.")
        return ""  # Validation Failed
    else:
        # output_filename = f"{args.solver}_bccv.txt"
        output_filename = f"result_bccv.txt"
        with open(output_filename, "w", encoding="utf-8") as f:
            f.write(counterexample_str)

        print(f"✅ Counterexample detected. Output saved to `{output_filename}`.")
        return "Validation Success" 


def merge_contracts(original_file, reproduction_file, output_file):
    """
    Merges `original_file` and `reproduction_file` into a new Solidity file `output_file`.
    """

    with open(original_file, "r", encoding="utf-8") as orig, open(
        reproduction_file, "r", encoding="utf-8"
    ) as repro, open(output_file, "w", encoding="utf-8") as temp:

        original_content = orig.read()
        reproduction_content = repro.read()

        # **Remove trailing newlines from original contract to avoid extra spacing**
        original_content = original_content.rstrip("\n")

        # **Ensure a newline before adding the reproduction contract**
        temp.write(f"{original_content}\n\n{reproduction_content}")

    print(
        f"✅ Merged `{original_file}` and `{reproduction_file}` into `{output_file}`."
    )


def run_bccv(args, additional_options=[]):
    """
    Runs Bounded Contract Verification (BCCV) using SMTChecker or ESBMC.
    Accepts extra options (e.g., `--negate-property` for ESBMC).
    """
    print("🔹 Running Bounded Cross-Contract Verfication...")

    # **Step 1: Configure the solver-specific BCCV command**
    if args.solver == "SMTChecker":
        options = [
            "--model-checker-ext-calls=trusted",
            f"--model-checker-contracts={TEMP_FILE}:Reproduction",
        ]  # Append extra options if any

        counterexample_str, _ = smtchecker_solver.smtchecker_solving(
            TEMP_FILE, "", args.timeout, extra_options=options
        ) # the label need to be set as assert

    elif args.solver == "ESBMC":
        options = [
            "--bound",
            "--contract",
            "Reproduction",
        ] + additional_options  # Append extra options if any

        counterexample_str, _ = esbmc_solver.esbmc_solving(
            TEMP_FILE, "AS", args.timeout, extra_options=options
        ) # the label need to be set as assert

    else:
        print(f"❌ Unsupported solver: {args.solver}")
        return ""

    return counterexample_str
