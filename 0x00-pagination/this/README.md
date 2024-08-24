# Project: Unittests and Integration Tests

## Overview

This project contains unit and integration tests for utilities and client functions interacting with external APIs. The main focus is on testing nested map access, HTTP requests, memoization, and GitHub API client functionalities.

## Requirements

- Python 3.7
- Ubuntu 18.04 LTS
- `unittest`, `unittest.mock`, and `parameterized` libraries

## Files

- `utils.py`: Contains utility functions for nested map access, JSON fetching, and memoization.
- `client.py`: Defines the `GithubOrgClient` class for interacting with GitHub API.
- `fixtures.py`: Contains fixtures for integration tests.
- `test_utils.py`: Unit tests for functions in `utils.py`.
- `test_client.py`: Integration tests for `GithubOrgClient` in `client.py`.

## Setup

1. Clone the repository.
2. Ensure you are using Python 3.7.
3. Install necessary libraries:
    ```bash
    pip install parameterized
    ```
4. Run tests using:
    ```bash
    python3 -m unittest discover
    ```

## Testing

- `test_utils.py`: Contains tests for `access_nested_map`, `get_json`, and `memoize`.
- `test_client.py`: Contains integration tests for `GithubOrgClient` methods.

## Notes

- Ensure all files are executable and end with a new line.
- Documentation for all modules, classes, and functions is included.

## License

This project is licensed under the MIT License.
