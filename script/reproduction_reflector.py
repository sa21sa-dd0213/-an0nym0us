from script import (
    prompt_generator,
    reproduction_generator,
    reproduction_validator,
    esbmc_solver,
)
from script import log

MAX_REFLECTION_ATTEMPTS = 5  # Maximum self-reflection loops

Rep_path = "Reproduction.sol"
TEMP_FILE = "temporary.sol"


def perform_self_reflection(
    args, gen_memory, initial_response, validate_result, counterexample
):
    """
    Iteratively improves the reproduction contract by feeding validation failures back to GPT-4o.
    """
    reflect_memory = []  # Stores full history (prompt + response)
    reflect_prompt_history = []  # Only stores reflection prompts (to be returned)

    for attempt in range(1, MAX_REFLECTION_ATTEMPTS + 1):
        print(f"🔄 Self-reflection attempt {attempt}/{MAX_REFLECTION_ATTEMPTS}")

        # **Generate feedback based on the last failed response**
        reflect_prompt = generate_feedback(args, validate_result, counterexample)

        # **Prepare memory context for GPT-4o (Chain-of-Thought)**
        memory_context = (
            gen_memory
            + "\n"
            + "\n".join(reflect_memory)
            + f"\n\n## Current Prompt: \n{reflect_prompt}\n"
        )

        # **Re-run GPT with accumulated reflection context**
        reflect_response = self_reflection(args, validate_result, memory_context)

        print("\n🎯 GPT-4o Raw Response:\n", reflect_response)

        # **Filter and save the updated reproduction contract**
        filtered_response = reproduction_generator.filter_response(
            reflect_response, args.file
        )
        with open(Rep_path, "w", encoding="utf-8") as f:
            f.write(filtered_response)

        print(f"\n✅ New Solidity Reproduction Contract saved to: {Rep_path}")

        # **Store both the prompt & response in reflect_memory**
        reflect_memory.append(f"\n## Reflection Prompt {attempt}:\n{reflect_prompt}\n")
        reflect_memory.append(
            f"\n## Reflection Response {attempt}:\n{reflect_response}\n"
        )

        # **Store only the prompt history for return**
        reflect_prompt_history.append(reflect_prompt)

        # **Revalidate the new contract using BCCV**
        validate_result = reproduction_validator.validate_reproduction_contract(args)

        # redo the compilation checking
        is_compilable, _ = esbmc_solver.check_compile(TEMP_FILE)

        # **If BCCV finds a counterexample, the contract is correct, STOP**
        if is_compilable and validate_result == "Validation Success":
            print("✅ BCCV found a counterexample. Stopping self-reflection.")
            return reflect_prompt_history  # ✅ Only return the history of reflection prompts

        # **If BCCV reports success (no counterexample), continue self-reflection**
        if not is_compilable:
            print("❌ Compilation Error. Continuing self-reflection...")
        else:
            print(
                "❌ BCCV validation failed (no counterexample). Continuing self-reflection..."
            )

    print("❌ Maximum reflection attempts reached. Cleaning up failed reproduction.")
    log.cleanup_failed_reproduction()  # Remove invalid reproduction.sol
    return reflect_prompt_history  # ✅ Returns only the prompt history, as requested


def generate_feedback(args, validate_result, counterexample):
    """
    Generates feedback for self-reflection based on validation failure.
    """
    if validate_result:  # If validate_result is not empty, it's a compilation error
        return prompt_generator.construct_compilation_reflect_prompt(validate_result)

    # **Extract counterexample information (line number, function name)**
    line_number, func_name = extract_counterexample_info(counterexample, args.solver)

    # **Modify contract for ESBMC or SMTChecker**
    if line_number:
        if args.solver == "SMTChecker":
            insert_assert_at_line("temporary.sol", line_number)
            validate_result = reproduction_validator.run_bccv(args, True)
        elif args.solver == "ESBMC" and func_name:
            extra_options = ["--negate-property", func_name]
            validate_result = reproduction_validator.run_bccv(args, True, extra_options)

    # **Generate appropriate reflection prompt based on new validation**
    if validate_result == "":
        return prompt_generator.construct_unreach_reflect_prompt()
    return prompt_generator.construct_wval_reflect_prompt(validate_result)


def self_reflection(args, validate_result, memory_context):
    """
    Calls LLM with memory_context and retrieves an improved reproduction contract.
    """
    from script import LLM  # Avoid circular import issues

    print("🧠 Sending feedback to LLM for self-reflection...")
    return LLM.send_prompt_to_gpt(memory_context)


def extract_counterexample_info(counterexample, solver):
    """
    Extracts line number and function name from a counterexample.
    """
    import re

    if solver == "SMTChecker":
        match = re.search(r"-->\s.*:(\d+):\d+", counterexample)
        if match:
            return int(match.group(1)), None  # SMTChecker doesn't provide function name

    elif solver == "ESBMC":
        matches = list(re.finditer(r"line\s+(\d+)\s+function\s+(\w+)", counterexample))
        if matches:
            last_match = matches[-1]  # Get the last match (first from bottom)
            return int(last_match.group(1)), last_match.group(2)

    return None, None


def insert_assert_at_line(filename, line_number):
    """
    Inserts `assert(false);` at a specific line in the Solidity file.
    """
    with open(filename, "r", encoding="utf-8") as f:
        lines = f.readlines()

    if 1 <= line_number <= len(lines):
        lines.insert(line_number - 1, "    assert(false);\n")  # Preserve indentation

        with open(filename, "w", encoding="utf-8") as f:
            f.writelines(lines)

        print(f"✅ Inserted `assert(false);` at line {line_number} in {filename}")
    else:
        print(f"⚠️ Invalid line number {line_number}. Skipping assertion insertion.")
