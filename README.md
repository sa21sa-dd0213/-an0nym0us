
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

![Showcase](showcase.svg)

## Dependencies

VeriExploit currently supports two open-sourced verifiers that both support BCCV:

- **SMTChecker (SolCMC):** [Ethereum Solidity](https://github.com/ethereum/solidity)
- **ESBMC:** [ESBMC GitHub](https://github.com/esbmc/esbmc/)

## Usage

```sh
$ python3 VeriExploit.py [options]
```

### Options

| Option           | Description                                           |
|-----------------|-------------------------------------------------------|
| `-s`, `--solver`  | Choose between `SMTChecker` or `ESBMC` (default: SMTChecker) |
| `-f`, `--file`    | Path to the Solidity source file (required)         |
| `-l`, `--label`   | Specify the bug type (`AO`, `AU`, `DV`, `OB`, `AS`, `RE`) |
| `-t`, `--timeout` | Set a timeout (in seconds) for solver execution     |
| `-d`, `--debug`   | Enable debugging mode (`no_GE` to skip generation, `no_RE` to disable self-reflection) |
| `-w`, `--web`     | Use ChatGPT Web UI instead of API                   |

### Example Commands

#### Run SMTChecker on a Solidity file for division by zero detection:
```sh
python3 VeriExploit.py -s SMTChecker -f example/example.sol -l DV
```


