import os


def context_matching(violation_type):
    """
    Retrieves the context description for the given violation type.
    If no specific context file exists, returns a default message.
    """
    context_file = f"./templates/context/{violation_type}.txt"

    if os.path.exists(context_file):
        with open(context_file, "r", encoding="utf-8") as f:
            return f.read()

    print("Cannot read from the context file")
    exit(0)


def format_prompt(template, **kwargs):
    """
    Replaces placeholders in the prompt template dynamically.

    Args:
        template (str): The template string.
        **kwargs: Dynamic key-value pairs to replace in the template.

    Returns:
        str: The formatted prompt.
    """
    for key, value in kwargs.items():
        template = template.replace(f"<{key}>", value)
    return template


def load_prompt_template(file_path):
    """Loads the prompt template from a file."""
    if not os.path.exists(file_path):
        return f"Error: Template file '{file_path}' not found."

    try:
        with open(file_path, "r", encoding="utf-8") as file:
            return file.read()
    except Exception as e:
        return f"Error loading template: {e}"


def construct_generation_prompt(file, solver, counterexample, violation_type):
    """Generates GPT-4o prompt based on extracted counterexample."""

    with open(file, "r", encoding="utf-8") as f:
        source_code = f.read()

    # Get vulnerability context
    context_info = context_matching(violation_type)

    violation_map = {
        "overflow": "Overflow",
        "underflow": "Underflow",
        "divByZero": "Division by zero",
        "assert": "Assertion Violation",
        "outOfBounds": "Out of bounds array",
        "reentrancy": "Reentrancy"
    }

    return format_prompt(
        load_prompt_template("./templates/generate_exploit.txt"),
        source_code=source_code,
        solver=solver,
        counterexample=counterexample,
        context=context_info,
        vulnerability_type=violation_map[violation_type],
    )


def construct_compilation_reflect_prompt(validate_result):
    """
    Constructs a reflection prompt for compilation errors.
    Extracts the <error_message> from `templates/compilation_error.txt` and fills it.
    """
    print("❌ Found Compilation Error. Self-reflecting...")
    template_path = "./templates/compilation_error.txt"

    return format_prompt(
        load_prompt_template(template_path), error_message=validate_result
    )


def construct_unreach_reflect_prompt():
    """
    Constructs a reflection prompt for unreachable contract verification failures.
    Reads the `templates/bccv_unreach.txt` template.
    """

    print("❌ The reproduction contract cannot reach the target bug. Self-reflecting...")
    template_path = "./templates/bccv_unreach.txt"

    return format_prompt(load_prompt_template(template_path))


def construct_wval_reflect_prompt(validate_result):
    """
    Constructs a reflection prompt when verification fails due to wrong validation.
    Extracts the <counterexample> from `templates/bccv_wval.txt` and fills it.
    """
    print("❌ The reproduction contract can reach the target bug, but cannot re-trigger. Self-reflecting...")
    template_path = "./templates/bccv_wval.txt"

    return format_prompt(
        load_prompt_template(template_path), counterexample=validate_result
    )
