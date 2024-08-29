#!/bin/bash

# Step 1: Create the project directory structure
echo "Setting up project directory structure..."
mkdir -p alx-backend-user-data/0x00-personal_data
mkdir -p alx-backend-user-data/scripts

# Step 2: Create the Python and SQL files
echo "Creating necessary files..."
touch alx-backend-user-data/0x00-personal_data/filtered_logger.py
touch alx-backend-user-data/0x00-personal_data/main.py
touch alx-backend-user-data/0x00-personal_data/main.sql
touch alx-backend-user-data/0x00-personal_data/README.md
touch alx-backend-user-data/requirements.txt

# Step 3: Add initial content to filtered_logger.py
echo "Adding code to filtered_logger.py..."
cat <<EOL > alx-backend-user-data/0x00-personal_data/filtered_logger.py
#!/usr/bin/env python3
"""
Module for a filtered logger
"""
import re
import logging
from typing import List

PII_FIELDS = ('name', 'email', 'phone', 'ssn', 'password')

class RedactingFormatter(logging.Formatter):
    """
    Redacting Formatter class
    """

    REDACTION = "***"
    FORMAT = "[HOLBERTON] %(name)s %(levelname)s %(asctime)-15s: %(message)s"
    SEPARATOR = ";"

    def __init__(self, fields: List[str]):
        super(RedactingFormatter, self).__init__(self.FORMAT)
        self.fields = fields

    def format(self, record: logging.LogRecord) -> str:
        """
        Format the message to redact sensitive information
        """
        message = super(RedactingFormatter, self).format(record)
        return self.redact(message)

    def redact(self, message: str) -> str:
        """
        Redact sensitive information in the log message
        """
        for field in self.fields:
            message = re.sub(f"{field}=[^;]+", f"{field}={self.REDACTION}", message)
        return message
EOL

# Step 4: Add initial content to main.py
echo "Adding code to main.py..."
cat <<EOL > alx-backend-user-data/0x00-personal_data/main.py
#!/usr/bin/env python3
"""
Main file for testing the filtered logger
"""
import logging
from filtered_logger import RedactingFormatter, PII_FIELDS

def get_logger() -> logging.Logger:
    """
    Creates a logger object
    """
    logger = logging.getLogger("user_data")
    logger.setLevel(logging.INFO)
    logger.propagate = False

    stream_handler = logging.StreamHandler()
    stream_handler.setFormatter(RedactingFormatter(PII_FIELDS))
    logger.addHandler(stream_handler)

    return logger

if __name__ == "__main__":
    logger = get_logger()
    logger.info("name=John Doe; email=john.doe@example.com; phone=123-456-7890; ssn=123-45-6789; password=secret")
EOL

# Step 5: Add a placeholder SQL query to main.sql
echo "Adding placeholder SQL query to main.sql..."
cat <<EOL > alx-backend-user-data/0x00-personal_data/main.sql
-- SQL script placeholder
SELECT * FROM users;
EOL

# Step 6: Add a simple README
echo "Adding content to README.md..."
cat <<EOL > alx-backend-user-data/0x00-personal_data/README.md
# ALX Backend User Data

This project focuses on creating a filtered logger to redact PII fields in log messages.

## Files

- **filtered_logger.py**: Contains the RedactingFormatter class for redacting PII fields.
- **main.py**: Main script to test the logger.
- **main.sql**: Placeholder for SQL commands.
EOL

# Step 7: Add a requirements.txt file for Python dependencies
echo "Adding dependencies to requirements.txt..."
cat <<EOL > alx-backend-user-data/requirements.txt
# Add any Python dependencies here
EOL

# Step 8: Create a run script in the scripts directory
echo "Creating a run script..."
cat <<EOL > alx-backend-user-data/scripts/run.sh
#!/bin/bash
# Run the main Python script and check for pycodestyle compliance

echo "Running the main script..."
python3 ../0x00-personal_data/main.py

echo "Checking code style with pycodestyle..."
pycodestyle ../0x00-personal_data/
EOL

# Step 9: Make the scripts executable
chmod +x alx-backend-user-data/scripts/run.sh

# Step 10: Print completion message
echo "Setup complete. You can run the project using scripts/run.sh"
