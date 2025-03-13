from script import LLM
from script import smtchecker_solver, esbmc_solver
from script import prompt_generator
import re

Rep_path = "Reproduction.sol"


def generate_reproduction_contract(args):
    """
    Runs verification, extracts counterexamples, and generates a reproduction contract via GPT-4o.
    Returns (initial_prompt, initial_response) for self-reflection.
    """
    print("🔍 Running verification and generating reproduction contract...")

    # **Step 1: Run the correct solver based on user input**
    if args.solver == "SMTChecker":
        counterexample, vulnerability_type = smtchecker_solver.smtchecker_solving(
            args, args.file, args.label, args.timeout, False
        )
        if counterexample is None or vulnerability_type is None:
            print("❌ counterexample or vulnerability_type not found")
            exit(1)
    elif args.solver == "ESBMC":
        esbmc_solver.get_sol_ast(args.file)  # Ensure AST file exists before analysis
        counterexample, vulnerability_type = esbmc_solver.esbmc_solving(
            args, args.file, args.label, args.timeout, False, [f"--unbound"]
        )
        if counterexample is None or vulnerability_type is None:
            print("❌ counterexample or vulnerability_type not found")
            exit(1)
    else:
        print("❌ Unsupported solver.")
        return None, None, None  # ✅ Return None when generation fails

    # **Step 2: Construct the GPT-4o prompt**
    initial_prompt = prompt_generator.construct_generation_prompt(
        args.file, args.solver, counterexample, vulnerability_type
    )

    # **Step 3: Send prompt to GPT-4o**
    initial_response = send_to_gpt(args, initial_prompt)

    return (
        initial_prompt,
        initial_response,
        counterexample,
    )  # ✅ Now returns both for self-reflection


def baseline(args):
    with open(args.file, "r", encoding="utf-8") as f:
        source_code = f.read()
    initial_prompt = prompt_generator.format_prompt(
        prompt_generator.load_prompt_template("./templates/baseline.txt"),
        source_code=source_code,
    )
    initial_response = send_to_gpt(args, initial_prompt)

    return (
        initial_prompt,
        initial_response,
        "",
    )  # baseline do not have CE


def send_to_gpt(args, prompt):
    """
    Sends the constructed prompt to GPT-4o and saves the reproduction contract.
    """
    response = LLM.send_prompt(prompt)

    if response == "ChatGPT Web UI opened.":
        print("⚠️ GPT prompt sent via Web UI. Please check manually.")
        return

    print("\n🎯 GPT-4o Raw Response:\n", response)

    # **Step 4: Filter the response**
    filtered_response = filter_response(response, args.file)

    # Save the reproduction contract
    with open(Rep_path, "w", encoding="utf-8") as f:
        f.write(filtered_response)

    print(f"\n✅ Solidity Reproduction Contract saved to: {Rep_path}")
    return response


def filter_response(response, original_contract_path):
    """
    Cleans the GPT response:
    1. Removes the outer "```solidity ```" block.
    2. Filters out contracts that were already present in the input Solidity file.
    3. Removes SPDX, pragma, and import statements.
    4. Ensures no unwanted characters (like 'y') appear in the output.
    5. Maintains the original format without modifying indentation.
    """

    # **Step 1: Remove Markdown code block formatting**
    response = response.strip()  # Trim leading/trailing whitespace

    if response.startswith("```solidity"):
        response = response[len("```solidity") :].strip()
    if response.endswith("```"):
        response = response[:-3].strip()

    # **Step 2: Remove SPDX, pragma, and import statements**
    response = remove_unnecessary_lines(response)

    # **Step 3: Extract contract names from the response**
    response_contracts = extract_contract_names(response)

    # **Step 4: Extract contract names from the original file**
    with open(original_contract_path, "r", encoding="utf-8") as f:
        original_contract_content = f.read()

    original_contracts = extract_contract_names(original_contract_content)

    # **Step 5: Filter out contracts that exist in the original file**
    filtered_lines = []
    inside_unwanted_contract = False
    first_valid_line = True  # Flag to remove any garbage text at the start

    for line in response.splitlines():
        clean_line = (
            line.rstrip()
        )  # Trim only trailing spaces, keep original indentation

        # **Ignore completely empty lines at the start**
        if first_valid_line and not clean_line:
            continue

        first_valid_line = (
            False  # We have found a valid line, stop skipping empty lines
        )

        # **Check if this line declares a contract that was in the original file**
        if any(f"contract {c}" in clean_line for c in original_contracts):
            print(
                f"⚠️ Removing contract '{clean_line}' as it exists in the original file."
            )
            inside_unwanted_contract = True
            continue  # Skip this line and enter filtering mode

        # **If we find a new contract declaration, stop filtering (only if inside unwanted contract)**
        if "contract " in clean_line:
            inside_unwanted_contract = False

        # **Append the line if it's not inside an unwanted contract**
        if not inside_unwanted_contract:
            filtered_lines.append(clean_line)

    # **Ensure there are no unexpected characters at the start**
    final_output = "\n".join(filtered_lines).lstrip(
        " \n\t\r"
    )  # Strip leading whitespace & newlines

    return final_output


def remove_unnecessary_lines(solidity_code):
    """
    Removes SPDX-License-Identifier, pragma statements, and import statements.
    """

    cleaned_lines = []
    for line in solidity_code.splitlines():
        # Ignore SPDX, pragma, and import statements
        if re.match(r"^\s*// SPDX-License-Identifier", line):
            continue
        if re.match(r"^\s*pragma solidity", line):
            continue
        if re.match(r"^\s*import\s+.*;", line):
            continue

        cleaned_lines.append(line)

    return "\n".join(cleaned_lines).strip()


def extract_contract_names(solidity_code):
    """
    Extracts contract names from Solidity code.
    Example: `contract Example {` → Extracts "Example".
    """
    pattern = re.compile(r"contract\s+(\w+)")
    return pattern.findall(solidity_code)
