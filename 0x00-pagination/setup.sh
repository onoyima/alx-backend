#!/bin/bash

# Create README.md
cat <<EOL > README.md
# 0x00. Pagination

This project is part of the ALX backend curriculum.

## Files
- 0-simple_helper_function.py: Simple helper function to calculate start and end indexes for pagination.
- 1-simple_pagination.py: Implementation of pagination using the Server class.
- 2-hypermedia_pagination.py: Hypermedia pagination implementation.
- 3-hypermedia_del_pagination.py: Deletion-resilient hypermedia pagination.
EOL

# Create 0-simple_helper_function.py
cat <<EOL > 0-simple_helper_function.py
#!/usr/bin/env python3
"""
Simple helper function to calculate start and end indexes for pagination.
"""

def index_range(page: int, page_size: int) -> tuple:
    """
    Returns a tuple containing the start index and end index
    """
    start_index = (page - 1) * page_size
    end_index = page * page_size
    return (start_index, end_index)
EOL

# Create 1-simple_pagination.py
cat <<EOL > 1-simple_pagination.py
#!/usr/bin/env python3
"""
Implementation of pagination using the Server class.
"""

import csv
from typing import List

index_range = __import__('0-simple_helper_function').index_range

class Server:
    """Server class to paginate a database of popular baby names."""
    DATA_FILE = "Popular_Baby_Names.csv"

    def __init__(self):
        self.__dataset = None

    def dataset(self) -> List[List]:
        """Cached dataset"""
        if self.__dataset is None:
            with open(self.DATA_FILE) as f:
                reader = csv.reader(f)
                dataset = [row for row in reader]
            self.__dataset = dataset[1:]
        return self.__dataset

    def get_page(self, page: int = 1, page_size: int = 10) -> List[List]:
        """Get the appropriate page of the dataset"""
        assert isinstance(page, int) and page > 0
        assert isinstance(page_size, int) and page_size > 0
        start_index, end_index = index_range(page, page_size)
        return self.dataset()[start_index:end_index] if start_index < len(self.dataset()) else []
EOL

# Create 2-hypermedia_pagination.py
cat <<EOL > 2-hypermedia_pagination.py
#!/usr/bin/env python3
"""
Hypermedia pagination implementation.
"""

import csv
from typing import List, Dict
import math

index_range = __import__('0-simple_helper_function').index_range

class Server:
    """Server class to paginate a database of popular baby names."""
    DATA_FILE = "Popular_Baby_Names.csv"

    def __init__(self):
        self.__dataset = None

    def dataset(self) -> List[List]:
        """Cached dataset"""
        if self.__dataset is None:
            with open(self.DATA_FILE) as f:
                reader = csv.reader(f)
                dataset = [row for row in reader]
            self.__dataset = dataset[1:]
        return self.__dataset

    def get_page(self, page: int = 1, page_size: int = 10) -> List[List]:
        """Get the appropriate page of the dataset"""
        assert isinstance(page, int) and page > 0
        assert isinstance(page_size, int) and page_size > 0
        start_index, end_index = index_range(page, page_size)
        return self.dataset()[start_index:end_index] if start_index < len(self.dataset()) else []

    def get_hyper(self, page: int = 1, page_size: int = 10) -> Dict:
        """Get a page with hypermedia pagination"""
        data = self.get_page(page, page_size)
        total_pages = math.ceil(len(self.dataset()) / page_size)

        return {
            "page_size": len(data),
            "page": page,
            "data": data,
            "next_page": page + 1 if page < total_pages else None,
            "prev_page": page - 1 if page > 1 else None,
            "total_pages": total_pages
        }
EOL

# Create 3-hypermedia_del_pagination.py
cat <<EOL > 3-hypermedia_del_pagination.py
#!/usr/bin/env python3
"""
Deletion-resilient hypermedia pagination.
"""

import csv
from typing import List, Dict

index_range = __import__('0-simple_helper_function').index_range

class Server:
    """Server class to paginate a database of popular baby names."""
    DATA_FILE = "Popular_Baby_Names.csv"

    def __init__(self):
        self.__dataset = None
        self.__indexed_dataset = None

    def dataset(self) -> List[List]:
        """Cached dataset"""
        if self.__dataset is None:
            with open(self.DATA_FILE) as f:
                reader = csv.reader(f)
                dataset = [row for row in reader]
            self.__dataset = dataset[1:]
        return self.__dataset

    def indexed_dataset(self) -> Dict[int, List]:
        """Dataset indexed by sorting position, starting at 0"""
        if self.__indexed_dataset is None:
            dataset = self.dataset()
            self.__indexed_dataset = {
                i: dataset[i] for i in range(len(dataset))
            }
        return self.__indexed_dataset

    def get_hyper_index(self, index: int = None, page_size: int = 10) -> Dict:
        """Deletion-resilient hypermedia pagination"""
        assert isinstance(index, int) and index >= 0 and index < len(self.dataset())
        data = []
        next_index = index
        for i in range(page_size):
            while next_index not in self.indexed_dataset():
                next_index += 1
            data.append(self.indexed_dataset()[next_index])
            next_index += 1

        return {
            "index": index,
            "next_index": next_index,
            "page_size": len(data),
            "data": data
        }
EOL

echo "Setup complete."

