import os

def count_lines(file_path):
    """Count the number of lines in a file."""
    if os.path.exists(file_path):
        with open(file_path, 'r') as file:
            return sum(1 for line in file)
    return 0

def extract_violations(file_path):
    """Extract the number of violations from the DRC output file."""
    if os.path.exists(file_path):
        with open(file_path, 'r') as file:
            for line in file:
                if "Found" in line and "violations" in line:
                    parts = line.split()
                    return int(parts[1])  # Extract the number of violations
    return 0

# File paths
erc_errors_path = "erc_errors.txt"
erc_warnings_path = "erc_warnings.txt"
drc_errors_path = "drc_errors.txt"
drc_warnings_path = "drc_warnings.txt"
drc_output_path = "drc_output.txt"

# Read counts
erc_errors = count_lines(erc_errors_path)
erc_warnings = count_lines(erc_warnings_path)
drc_errors = count_lines(drc_errors_path)
drc_warnings = count_lines(drc_warnings_path)
violations = extract_violations(drc_output_path)

# Tests
def test_erc_errors():
    assert erc_errors < 5, f"ERC Errors ({erc_errors}) are not less than 5"

def test_erc_warnings():
    assert erc_warnings < 5, f"ERC Warnings ({erc_warnings}) are not less than 5"

def test_drc_errors():
    assert drc_errors < 5, f"DRC Errors ({drc_errors}) are not less than 5"

def test_drc_warnings():
    assert drc_warnings < 5, f"DRC Warnings ({drc_warnings}) are not less than 5"
