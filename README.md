
# VeriExploit

## Organization

```
VeriExploit/
├── README.md
├── VeriExploit.py          # executable
├── result/                 # evaluation result(contain dataset and log)
│   ├── dataset         
│   ├── Log                 
│   │   ├── ArithmaticOverflow
│   │   ├── ArithmaticUnderflow
│   │   ├── AssertionViolation
│   │   ├── DivByZero
│   │   ├── OutOfBound
│   │   ├── Reentrancy
│   │   ├── result.xlsx
├── showcase.svg            # log file and a statistical table
├── example/
│   ├── example.sol         # test case to play with
├── script/                 # implementation   
│   ├── __init__.py
│   ├── LLM.py
│   ├── arg_parser.py
│   ├── esbmc_solver.py
│   ├── log.py
│   ├── prompt_generator.py
│   ├── reproduction_generator.py
│   ├── reproduction_reflector.py
│   ├── reproduction_validator.py
│   ├── smtchecker_solver.py
├── templates/               # prompt template
│   ├── baseline.txt
│   ├── bccv_unreach.txt
│   ├── bccv_wval.txt
│   ├── compilation_error.txt
│   ├── generate_exploit.txt
│   ├── context/             # vulnerability context
│   │   ├── assert.txt
│   │   ├── divByZero.txt
│   │   ├── outOfBounds.txt
│   │   ├── overflow.txt
│   │   ├── reentrancy.txt
│   │   ├── underflow.txt
****
```

## Showcase

- SMTChecker: Division By Zero

![Showcase](showcase_smtchecker.svg)

- ESBMC: Reentrancy

![Showcase](showcase_esbmc.svg)

## Dependencies
`pip3 install argparse openai selenium`

VeriExploit currently supports two open-source verifiers, which are [SolCMC (SMTChecker)](https://github.com/ethereum/solidity) and [ESBMC](https://ssvlab.github.io/esbmc/documentation.html#esbmc-solidity)

To run the script, build the verifiers by following their respective build instructions:
- SolCMC: https://docs.soliditylang.org/en/latest/installing-solidity.html#building-from-source
- ESBMC: https://github.com/esbmc/esbmc/blob/master/BUILDING.md

## Command to Run

### Usage

```sh
$ python3 VeriExploit.py [options]
```

### Options

| Option            | Description                                                                            |
| ----------------- | -------------------------------------------------------------------------------------- |
| `-s`, `--solver`  | Choose between `SMTChecker` or `ESBMC` (default: SMTChecker)                           |
| `-f`, `--file`    | Path to the Solidity source file (required)                                            |
| `-l`, `--label`   | Specify the bug type (`AO`, `AU`, `DV`, `OB`, `AS`, `RE`)                              |
| `-t`, `--timeout` | Set a timeout (in seconds) for solver execution                                        |
| `-d`, `--debug`   | Enable debugging mode (`no_GE` to skip generation, `no_RE` to disable self-reflection) |
| `-w`, `--web`     | Use ChatGPT Web UI instead of API (Experimental)                                       |
| `-c`, `--contract`| (ESBMC) Entry/Target contract                                                          |
| `--function`      | (ESBMC) Entry/Target function                                                          |
| `-a`, `--addition`| use additional solver's options (e.g. --cex-only)                                      |

### Supported Property

Currently, VeriExploit support:

- `AO`: Arrithmetic overflow
- `AU`: Arrithmetic underflow
- `DV`: Division by zero
- `OB`: Out of bound index access
- `AS`: Assertion Violation
- `RE`: Reentrancy

Performance may vary depending on the verifier used. 

### Example Commands

```sh
python3 VeriExploit.py -s SMTChecker -f example/SMTChecker.sol -l DV
python3 VeriExploit.py -s ESBMC -f example/ESBMC.sol -l RE
```


