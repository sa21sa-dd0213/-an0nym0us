import argparse
import sys
import os


def parse_arguments():
    """Parse command-line arguments and validate file existence."""
    parser = argparse.ArgumentParser(
        description="VeriExploit: A tool for analyzing smart contract vulnerabilities."
    )
    parser.add_argument(
        "-s",
        "--solver",
        choices=["SMTChecker", "ESBMC"],
        default="SMTChecker",
        help="Specify the solver",
    )
    parser.add_argument(
        "-f", "--file", required=True, help="Path to the Solidity source file"
    )
    parser.add_argument(
        "-d", "--debug", choices=["no_GE", "no_RE"], help="Ablation setting (optional)"
    )
    parser.add_argument(
        "-w", "--web", action="store_true", help="Use ChatGPT Web UI instead of API"
    )
    parser.add_argument(
        "-l",
        "--label",
        choices=["AO", "AU", "DV", "OB", "AS", "RE"],
        help="Specify the bug type",
    )
    parser.add_argument(
        "-t", "--timeout", type=int, help="Timeout for solver execution (seconds)"
    )
    parser.add_argument("-c", "--contract", help="(ESBMC) Entry/Target contract name")
    parser.add_argument("--function", help="(ESBMC) Entry/Target function name")
    parser.add_argument("-a","--addition", help="add additional options")

    args = parser.parse_args()

    if not os.path.isfile(args.file):
        print(f"❌ Error: The specified file '{args.file}' does not exist.")
        sys.exit(1)

    return args
